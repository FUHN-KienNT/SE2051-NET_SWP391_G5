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
        processAction(action, req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "catalog";
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
        String categoryIdStr = req.getParameter("categoryId");
        Long categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Long.parseLong(categoryIdStr.trim());
            } catch (NumberFormatException ignored) {
            }
        }
        List<CourseDto> list = courseService.searchPublished(keyword, categoryId);
        List<SettingDto> categories = courseService.getActiveCategories();
        req.setAttribute("courses", list);
        req.setAttribute("categories", categories);
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedCategoryId", categoryId);
        req.getRequestDispatcher("/WEB-INF/views/course/catalog.jsp").forward(req, resp);
    }

    private void showCourseDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            long courseId = Long.parseLong(idStr);
            CourseDto course = courseService.getCourseDetail(courseId);

            UserDto currentUser = SessionUtil.getCurrentUser(req);
            boolean hasAccess = false;
            boolean isPrivileged = false;
            Long userRegId = null;

            if (currentUser != null) {
                String role = currentUser.getRoleName();
                isPrivileged = "ADMIN".equalsIgnoreCase(role) || "MANAGER".equalsIgnoreCase(role)
                        || (course.getExpertId() != null && course.getExpertId().equals(currentUser.getId()));
                if (isPrivileged) {
                    hasAccess = true;
                } else {
                    hasAccess = registrationService.hasCourseAccess(currentUser.getId(), courseId);
                    if (hasAccess) {
                        List<RegistrationDto> myRegs = registrationService.getByUser(currentUser.getId());
                        for (RegistrationDto r : myRegs) {
                            if (r.getCourseId().equals(courseId)
                                    && (r.getStatus() == RegistrationStatus.ACTIVE || r.getStatus() == RegistrationStatus.COMPLETED)) {
                                userRegId = r.getId();
                                break;
                            }
                        }
                    }
                }
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
        }
        req.getRequestDispatcher("/WEB-INF/views/course/detail.jsp").forward(req, resp);
    }

    private void showLearningContent(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String regIdStr = req.getParameter("registrationId");
        if (regIdStr != null) {
            long regId = Long.parseLong(regIdStr);
            CourseDto course;
            try {
                course = courseService.getLearningContent(regId, currentUser.getId());
            } catch (SecurityException e) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
                return;
            } catch (IllegalStateException e) {
                SessionUtil.setFlashError(req, e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/registrations/my");
                return;
            }
            req.setAttribute("course", course);
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
        }
        req.getRequestDispatcher("/WEB-INF/views/course/learn.jsp").forward(req, resp);
    }

    private void updateLessonProgress(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        long regId = Long.parseLong(req.getParameter("registrationId"));
        long lessonId = Long.parseLong(req.getParameter("lessonId"));
        String statusStr = req.getParameter("status");
        LessonProgressStatus status = (statusStr != null) ? LessonProgressStatus.fromDb(statusStr)
                : LessonProgressStatus.COMPLETED;

        try {
            courseService.updateLessonProgress(regId, currentUser.getId(), lessonId, status);
        } catch (SecurityException e) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/courses/learn?registrationId=" + regId + "&lessonId=" + lessonId);
    }

    private void saveLessonNote(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        resp.setContentType("application/json;charset=UTF-8");
        if (currentUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"success\":false,\"message\":\"Vui lòng đăng nhập lại.\"}");
            return;
        }
        try {
            long regId = Long.parseLong(req.getParameter("registrationId"));
            long lessonId = Long.parseLong(req.getParameter("lessonId"));
            String note = req.getParameter("note");
            courseService.saveLessonNote(regId, currentUser.getId(), lessonId, note);
            resp.getWriter().write("{\"success\":true,\"message\":\"Đã lưu ghi chú thành công!\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            String safeMsg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"").replace("\n", " ") : "Lỗi không xác định";
            resp.getWriter().write("{\"success\":false,\"message\":\"" + safeMsg + "\"}");
        }
    }
}
