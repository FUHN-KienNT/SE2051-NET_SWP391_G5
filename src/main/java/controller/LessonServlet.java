package controller;

import dao.CourseDao;
import dao.LessonDao;
import dao.LessonProgressDao;
import dao.ModuleDao;
import dao.RegistrationDao;
import dto.CourseDto;
import dto.LessonDto;
import dto.ModuleDto;
import dto.UserDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import service.CourseService;
import util.SessionUtil;

/**
 * Controller phụ trách các màn hình Lesson Management (BF-04) của Toàn:
 * - Expert Dashboard (II.4.3)
 * - Lesson List (II.4.1)
 * - Lesson Detail / Editor (II.4.1)
 */
@WebServlet(name = "LessonServlet", urlPatterns = {"/expert/*"})
public class LessonServlet extends HttpServlet {
    private CourseService courseService;

    @Override
    public void init() throws ServletException {
        this.courseService = new CourseService(
                new CourseDao(), new ModuleDao(), new LessonDao(),
                new LessonProgressDao(), new RegistrationDao()
        );
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "dashboard";
        processAction(action, req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "dashboard";
        processAction(action, req, resp);
    }

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        switch (action) {
            case "dashboard":
                showExpertDashboard(req, resp);
                break;
            case "lessons":
                showLessonList(req, resp);
                break;
            case "lesson-detail":
                showLessonDetail(req, resp);
                break;
            case "save-lesson":
                saveLesson(req, resp);
                break;
            case "delete-lesson":
                deleteLesson(req, resp);
                break;
            case "save-module":
                saveModule(req, resp);
                break;
            case "delete-module":
                deleteModule(req, resp);
                break;
            case "save-course":
                saveCourse(req, resp);
                break;
            case "delete-course":
                deleteCourse(req, resp);
                break;
            default:
                showExpertDashboard(req, resp);
                break;
        }
    }

    private void showExpertDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        List<CourseDto> courses = courseService.getManagedCourses(currentUser.getId());
        List<dto.SettingDto> categories = courseService.getCategories();
        req.setAttribute("courses", courses);
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/WEB-INF/views/expert/dashboard.jsp").forward(req, resp);
    }

    private void saveCourse(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        CourseDto dto = new CourseDto();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            dto.setId(Long.parseLong(idStr.trim()));
            // If editing, preserve original status or keep DRAFT
            try {
                CourseDto existing = courseService.getCourseDetail(dto.getId());
                dto.setStatus(existing.getStatus());
                dto.setManagerId(existing.getManagerId());
            } catch (Exception ignored) {
                dto.setStatus(entity.enums.CourseStatus.DRAFT);
            }
        } else {
            // New course created by Expert is always DRAFT awaiting Manager/Admin approval
            dto.setStatus(entity.enums.CourseStatus.DRAFT);
            dto.setManagerId(2L); // default manager
        }

        dto.setTitle(req.getParameter("title"));
        dto.setDescription(req.getParameter("description"));
        String catIdStr = req.getParameter("categoryId");
        if (catIdStr != null && !catIdStr.trim().isEmpty()) {
            dto.setCategoryId(Long.parseLong(catIdStr.trim()));
        } else {
            dto.setCategoryId(6L);
        }
        String priceStr = req.getParameter("price");
        dto.setPrice(priceStr != null && !priceStr.trim().isEmpty() ? new java.math.BigDecimal(priceStr.trim()) : java.math.BigDecimal.ZERO);
        dto.setExpertId(currentUser.getId());

        try {
            long savedId = courseService.saveCourse(dto);
            resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + savedId + "&success=created");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/expert/dashboard?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private void deleteCourse(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                long courseId = Long.parseLong(idStr);
                courseService.deleteCourse(courseId);
            } catch (Exception ignored) {}
        }
        resp.sendRedirect(req.getContextPath() + "/expert/dashboard?success=deleted");
    }

    private void showLessonList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr != null) {
            long courseId = Long.parseLong(courseIdStr);
            CourseDto course = courseService.getCourseDetail(courseId);
            req.setAttribute("course", course);
        }
        req.getRequestDispatcher("/WEB-INF/views/expert/lesson_list.jsp").forward(req, resp);
    }

    private void showLessonDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseIdStr = req.getParameter("courseId");
        String moduleIdStr = req.getParameter("moduleId");
        String lessonIdStr = req.getParameter("lessonId");

        if (courseIdStr != null) {
            long courseId = Long.parseLong(courseIdStr);
            CourseDto course = courseService.getCourseDetail(courseId);
            req.setAttribute("course", course);

            if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
                long lessonId = Long.parseLong(lessonIdStr);
                for (ModuleDto m : course.getModules()) {
                    for (LessonDto l : m.getLessons()) {
                        if (l.getId().equals(lessonId)) {
                            req.setAttribute("lesson", l);
                            req.setAttribute("selectedModuleId", m.getId());
                            break;
                        }
                    }
                }
            } else if (moduleIdStr != null) {
                req.setAttribute("selectedModuleId", Long.parseLong(moduleIdStr));
            }
        }
        req.getRequestDispatcher("/WEB-INF/views/expert/lesson_detail.jsp").forward(req, resp);
    }

    private void saveLesson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        LessonDto dto = new LessonDto();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            dto.setId(Long.parseLong(idStr.trim()));
        }
        String moduleId = req.getParameter("moduleId");
        if (moduleId != null && !moduleId.trim().isEmpty()) {
            dto.setModuleId(Long.parseLong(moduleId.trim()));
        }
        dto.setTitle(req.getParameter("title"));
        dto.setContent(req.getParameter("content"));
        dto.setVideoUrl(req.getParameter("videoUrl"));
        dto.setDocumentUrl(req.getParameter("documentUrl"));
        String orderStr = req.getParameter("orderIndex");
        dto.setOrderIndex(orderStr != null && !orderStr.trim().isEmpty() ? Integer.parseInt(orderStr.trim()) : 1);

        String courseIdStr = req.getParameter("courseId");
        try {
            courseService.saveLesson(dto);
            resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + courseIdStr + "&success=true");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + courseIdStr + "&error=" + e.getMessage());
        }
    }

    private void deleteLesson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String lessonIdStr = req.getParameter("lessonId");
        String courseIdStr = req.getParameter("courseId");
        if (lessonIdStr != null) {
            courseService.deleteLesson(Long.parseLong(lessonIdStr));
        }
        resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + courseIdStr);
    }

    private void saveModule(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ModuleDto dto = new ModuleDto();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            dto.setId(Long.parseLong(idStr.trim()));
        }
        String courseId = req.getParameter("courseId");
        if (courseId != null && !courseId.trim().isEmpty()) {
            dto.setCourseId(Long.parseLong(courseId.trim()));
        }
        dto.setTitle(req.getParameter("title"));
        String orderStr = req.getParameter("orderIndex");
        dto.setOrderIndex(orderStr != null && !orderStr.trim().isEmpty() ? Integer.parseInt(orderStr.trim()) : 1);

        try {
            courseService.saveModule(dto);
            resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + courseId);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + courseId + "&error=" + e.getMessage());
        }
    }

    private void deleteModule(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String moduleIdStr = req.getParameter("moduleId");
        String courseIdStr = req.getParameter("courseId");
        if (moduleIdStr != null) {
            courseService.deleteModule(Long.parseLong(moduleIdStr));
        }
        resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + courseIdStr);
    }
}
