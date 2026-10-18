package controller;

import dao.CourseDao;
import dao.LessonDao;
import dao.LessonProgressDao;
import dao.ModuleDao;
import dao.RegistrationDao;
import dto.CourseDto;
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
            Long userRegId = null;

            if (currentUser != null) {
                String role = currentUser.getRoleName();
                boolean isPrivileged = "ADMIN".equalsIgnoreCase(role) || "MANAGER".equalsIgnoreCase(role)
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
            }
            req.setAttribute("course", course);
            req.setAttribute("registrationId", regId);

            String currentLessonIdStr = req.getParameter("lessonId");
            if ((currentLessonIdStr == null || currentLessonIdStr.trim().isEmpty()) && course != null
                    && course.getModules() != null) {
                for (ModuleDto m : course.getModules()) {
                    if (m.getLessons() != null && !m.getLessons().isEmpty()) {
                        currentLessonIdStr = String.valueOf(m.getLessons().get(0).getId());
                        break;
                    }
                }
            }
            req.setAttribute("currentLessonId", currentLessonIdStr);
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
