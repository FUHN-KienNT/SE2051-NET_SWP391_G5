package controller;

import dao.CourseDao;
import dao.LessonDao;
import dao.LessonProgressDao;
import dao.ModuleDao;
import dao.RegistrationDao;
import dto.CourseDto;
import dto.LessonDto;
import dto.ModuleDto;
import dto.RegistrationDto;
import dto.SettingDto;
import dto.UserDto;
import entity.enums.LessonProgressStatus;
import entity.enums.RegistrationStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import service.CourseService;
import service.RegistrationService;
import util.SessionUtil;

@WebServlet(name = "CourseServlet", urlPatterns = { "/courses/*" })
public class CourseServlet extends HttpServlet {
    private static final int CATALOG_PAGE_SIZE = 9;
    private CourseService courseService;
    private RegistrationService registrationService;

    @Override
    public void init() throws ServletException {
        CourseDao cDao = new CourseDao();
        RegistrationDao rDao = new RegistrationDao();
        this.courseService = new CourseService(
                cDao, new ModuleDao(), new LessonDao(),
                new LessonProgressDao(), rDao);
        this.registrationService = new RegistrationService(rDao, cDao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "catalog";

        // [Security Defense]: Chặn tuyệt đối HTTP GET đối với các action thay đổi trạng thái (tránh CSRF / prefetch)
        if ("update-progress".equals(action) || "save-lesson-note".equals(action)) {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                    "Phương thức GET không được hỗ trợ cho thao tác này. Vui lòng sử dụng POST.");
            return;
        }

        processAction(action, req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "catalog";

        if (!"update-progress".equals(action) && !"save-lesson-note".equals(action)) {
            // Không hỗ trợ POST cho các trang tĩnh / chỉ đọc
            resp.sendRedirect(req.getContextPath() + "/courses/" + action);
            return;
        }

        processAction(action, req, resp);
    }

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String flashError = SessionUtil.popFlashError(req);
        if (flashError != null) {
            req.setAttribute("errorMessage", flashError);
        }
        String flashSuccess = SessionUtil.popFlashSuccess(req);
        if (flashSuccess != null) {
            req.setAttribute("successMessage", flashSuccess);
        }

        switch (action) {
            case "catalog":
                showCatalog(req, resp);
                break;
            case "detail":
                showCourseDetail(req, resp);
                break;
            case "learn":
                showLearningContent(req, resp);
                break;
            case "update-progress":
                updateLessonProgress(req, resp);
                break;
            case "save-lesson-note":
                saveLessonNote(req, resp);
                break;
            default:
                showCatalog(req, resp);
                break;
        }
    }

    private void showCatalog(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        if (keyword != null) {
            keyword = keyword.trim();
        }

        String categoryIdStr = req.getParameter("categoryId");
        Long categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Long.parseLong(categoryIdStr.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        int currentPage = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr.trim());
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException ignored) {
            }
        }

        int totalCourses = courseService.countPublishedCourses(keyword, categoryId);
        int totalPages = totalCourses > 0 ? (int) Math.ceil((double) totalCourses / CATALOG_PAGE_SIZE) : 1;
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        List<CourseDto> list = courseService.searchPublishedPaginated(keyword, categoryId, currentPage, CATALOG_PAGE_SIZE);
        req.setAttribute("courses", list);
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedCategoryId", categoryId);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCourses", totalCourses);
        req.getRequestDispatcher("/WEB-INF/views/course/catalog.jsp").forward(req, resp);
    }

    private void showCourseDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            SessionUtil.setFlashError(req, "Mã khóa học không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        }

        long courseId;
        try {
            courseId = Long.parseLong(idStr.trim());
        } catch (NumberFormatException e) {
            SessionUtil.setFlashError(req, "Mã khóa học không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        }

        CourseDto course;
        try {
            course = courseService.getPublicCourseDetail(courseId);
        } catch (IllegalArgumentException e) {
            SessionUtil.setFlashError(req, "Không tìm thấy khóa học bạn yêu cầu.");
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        }

        UserDto currentUser = SessionUtil.getCurrentUser(req);
        boolean isPrivileged = courseService.isPrivilegedCourseViewer(currentUser, course);
        boolean hasAccess = isPrivileged;
        Long userRegId = null;

        if (currentUser != null && !isPrivileged) {
            userRegId = registrationService.findActiveRegistrationId(currentUser.getId(), courseId);
            hasAccess = (userRegId != null);
        }

        // Quy tắc: Khóa học DRAFT hoặc PENDING_REVIEW chỉ người quản lý / giảng viên mới được xem Preview
        if (course.getStatus() == entity.enums.CourseStatus.DRAFT || course.getStatus() == entity.enums.CourseStatus.PENDING_REVIEW) {
            if (!isPrivileged) {
                SessionUtil.setFlashError(req, "Khóa học này đang ở trạng thái Nháp hoặc chờ duyệt và chưa được công bố công khai.");
                resp.sendRedirect(req.getContextPath() + "/courses/catalog");
                return;
            }
            req.setAttribute("isPreviewDraft", true);
        }

        // Quy tắc: Ai chưa mua sẽ không nhìn thấy khóa học khi đã ẩn (Archived)
        if (course.isArchived()) {
            if (!hasAccess) {
                SessionUtil.setFlashError(req, "Khóa học này đã được chuyển sang chế độ Lưu trữ và không còn hiển thị công khai.");
                resp.sendRedirect(req.getContextPath() + "/courses/catalog");
                return;
            }
            req.setAttribute("isPurchasedArchived", true);
        }

        req.setAttribute("hasCourseAccess", hasAccess);
        if (userRegId != null) {
            req.setAttribute("userRegistrationId", userRegId);
        }
        req.setAttribute("course", course);
        req.setAttribute("categories", courseService.getCategories());        req.getRequestDispatcher("/WEB-INF/views/course/detail.jsp").forward(req, resp);
    }

    private void showLearningContent(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String regIdStr = req.getParameter("registrationId");
        if (regIdStr == null || regIdStr.trim().isEmpty()) {
            SessionUtil.setFlashError(req, "Mã đăng ký không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/registrations/my");
            return;
        }
        long regId;
        try {
            regId = Long.parseLong(regIdStr.trim());
        } catch (NumberFormatException e) {
            SessionUtil.setFlashError(req, "Mã đăng ký không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/registrations/my");
            return;
        }
        CourseDto course;
        try {
            course = courseService.getLearningContent(regId, currentUser.getId());
        } catch (SecurityException e) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
            return;
        } catch (Exception e) {
            SessionUtil.setFlashError(req, "Không thể tải nội dung học: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/registrations/my");
            return;
        }
            req.setAttribute("course", course);
            req.setAttribute("categories", courseService.getCategories());
            req.setAttribute("registrationId", regId);

            String sessionKey = "active_learning_lesson_" + regId;
            Long sessionLessonId = (Long) req.getSession().getAttribute(sessionKey);

            String requestedLessonIdStr = req.getParameter("lessonId");
            Long targetLessonId = null;
            if (requestedLessonIdStr != null && !requestedLessonIdStr.trim().isEmpty()) {
                try {
                    targetLessonId = Long.parseLong(requestedLessonIdStr.trim());
                } catch (NumberFormatException ignored) {
                }
            }

            LessonDto targetLesson = null;
            LessonDto firstActiveLesson = null;
            if (course != null && course.getModules() != null) {
                for (ModuleDto m : course.getModules()) {
                    if (m.getLessons() != null) {
                        for (LessonDto l : m.getLessons()) {
                            if (firstActiveLesson == null && l.isActive()) {
                                firstActiveLesson = l;
                            }
                            if (targetLessonId != null && l.getId() == targetLessonId.longValue()) {
                                targetLesson = l;
                            }
                        }
                    }
                }
            }

            Long finalLessonId = null;
            if (targetLesson != null) {
                if (targetLesson.isActive()) {
                    finalLessonId = targetLesson.getId();
                } else {
                    // Bài học đã bị ẩn: Học viên đang học dở phiên hiện tại thì vẫn được học tiếp
                    if (sessionLessonId != null && sessionLessonId.equals(targetLesson.getId())) {
                        finalLessonId = targetLesson.getId();
                    } else {
                        // Đã rời khỏi bài học hoặc truy cập bài học đã ẩn mà không có phiên học dở
                        SessionUtil.setFlashError(req, "Bài học này đã được tạm ẩn và không còn khả dụng.");
                        if (firstActiveLesson != null) {
                            resp.sendRedirect(req.getContextPath() + "/courses/learn?registrationId=" + regId + "&lessonId=" + firstActiveLesson.getId());
                            return;
                        } else {
                            resp.sendRedirect(req.getContextPath() + "/registrations/my");
                            return;
                        }
                    }
                }
            } else {
                // Không truyền lessonId cụ thể -> Mở bài học hoạt động đầu tiên
                if (firstActiveLesson != null) {
                    finalLessonId = firstActiveLesson.getId();
                } else if (sessionLessonId != null) {
                    finalLessonId = sessionLessonId;
                }
            }

            if (finalLessonId != null) {
                req.getSession().setAttribute(sessionKey, finalLessonId);
                courseService.touchLessonProgress(regId, currentUser.getId(), finalLessonId);
                req.setAttribute("currentLessonId", String.valueOf(finalLessonId));
            }
        req.getRequestDispatcher("/WEB-INF/views/course/learn.jsp").forward(req, resp);
    }

    private void updateLessonProgress(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!"POST".equalsIgnoreCase(req.getMethod())) {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Chỉ hỗ trợ phương thức POST để cập nhật tiến độ học tập.");
            return;
        }
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String regIdStr = req.getParameter("registrationId");
        String lessonIdStr = req.getParameter("lessonId");
        if (regIdStr == null || regIdStr.trim().isEmpty() || lessonIdStr == null || lessonIdStr.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số registrationId hoặc lessonId.");
            return;
        }

        long regId;
        long lessonId;
        try {
            regId = Long.parseLong(regIdStr.trim());
            lessonId = Long.parseLong(lessonIdStr.trim());
        } catch (NumberFormatException nfe) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tham số registrationId hoặc lessonId không hợp lệ.");
            return;
        }

        String statusStr = req.getParameter("status");
        LessonProgressStatus status = (statusStr != null) ? LessonProgressStatus.fromDb(statusStr)
                : LessonProgressStatus.COMPLETED;

        try {
            courseService.updateLessonProgress(regId, currentUser.getId(), lessonId, status);
        } catch (SecurityException e) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
            return;
        } catch (IllegalArgumentException e) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, e.getMessage());
            return;
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cập nhật tiến độ: " + e.getMessage());
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/courses/learn?registrationId=" + regId + "&lessonId=" + lessonId);
    }

    private void saveLessonNote(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        if (!"POST".equalsIgnoreCase(req.getMethod())) {
            resp.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            resp.getWriter().write("{\"success\":false,\"message\":\"Chỉ hỗ trợ phương thức POST để lưu ghi chú.\"}");
            return;
        }
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"success\":false,\"message\":\"Vui lòng đăng nhập lại.\"}");
            return;
        }

        String regIdStr = req.getParameter("registrationId");
        String lessonIdStr = req.getParameter("lessonId");
        if (regIdStr == null || regIdStr.trim().isEmpty() || lessonIdStr == null || lessonIdStr.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false,\"message\":\"Thiếu tham số registrationId hoặc lessonId.\"}");
            return;
        }

        try {
            long regId = Long.parseLong(regIdStr.trim());
            long lessonId = Long.parseLong(lessonIdStr.trim());
            String note = req.getParameter("note");
            courseService.saveLessonNote(regId, currentUser.getId(), lessonId, note);
            resp.getWriter().write("{\"success\":true,\"message\":\"Đã lưu ghi chú thành công!\"}");
        } catch (NumberFormatException nfe) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false,\"message\":\"Tham số registrationId hoặc lessonId không hợp lệ.\"}");
        } catch (SecurityException se) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            String safeMsg = se.getMessage() != null ? se.getMessage().replace("\"", "\\\"").replace("\n", " ") : "Bị từ chối truy cập";
            resp.getWriter().write("{\"success\":false,\"message\":\"" + safeMsg + "\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            String safeMsg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"").replace("\n", " ") : "Lỗi không xác định";
            resp.getWriter().write("{\"success\":false,\"message\":\"" + safeMsg + "\"}");
        }
    }
}
