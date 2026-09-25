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
import entity.enums.CourseStatus;
import entity.enums.LessonProgressStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import service.CourseService;
import util.SessionUtil;

@WebServlet(name = "CourseServlet", urlPatterns = {"/courses/*"})
public class CourseServlet extends HttpServlet {
    private static final String MAPPING = "/courses/*";
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
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "catalog";
        processAction(action, req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "catalog";
        processAction(action, req, resp);
    }

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        switch (action) {
            case "catalog":
                showCatalog(req, resp);
                break;
            case "detail":
                showCourseDetail(req, resp);
                break;
            case "manage":
                showManagedCourses(req, resp);
                break;
            case "save":
                saveCourse(req, resp);
                break;
            case "delete":
                deleteCourse(req, resp);
                break;
            case "save-module":
                saveModule(req, resp);
                break;
            case "delete-module":
                deleteModule(req, resp);
                break;
            case "save-lesson":
                saveLesson(req, resp);
                break;
            case "delete-lesson":
                deleteLesson(req, resp);
                break;
            case "learn":
                showLearningContent(req, resp);
                break;
            case "update-progress":
                updateLessonProgress(req, resp);
                break;
            default:
                showCatalog(req, resp);
                break;
        }
    }

    private void showCatalog(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String categoryIdStr = req.getParameter("categoryId");
        Long categoryId = (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) ? Long.parseLong(categoryIdStr) : null;
        List<CourseDto> list = courseService.searchPublished(keyword, categoryId);
        req.setAttribute("courses", list);
        req.getRequestDispatcher("/WEB-INF/views/course/catalog.jsp").forward(req, resp);
    }

    private void showCourseDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            long courseId = Long.parseLong(idStr);
            CourseDto course = courseService.getCourseDetail(courseId);
            req.setAttribute("course", course);
        }
        req.getRequestDispatcher("/WEB-INF/views/course/detail.jsp").forward(req, resp);
    }

    private void showManagedCourses(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser != null) {
            List<CourseDto> list = courseService.getManagedCourses(currentUser.getId());
            req.setAttribute("courses", list);
        }
        req.getRequestDispatcher("/WEB-INF/views/course/manage.jsp").forward(req, resp);
    }

    private void saveCourse(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        CourseDto dto = bindCourse(req);
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (dto.getManagerId() == null && currentUser != null) {
            dto.setManagerId(currentUser.getId());
        }
        try {
            long id = courseService.saveCourse(dto);
            resp.sendRedirect(req.getContextPath() + "/courses/detail?id=" + id + "&success=true");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/courses/manage?error=" + e.getMessage());
        }
    }

    private void deleteCourse(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            courseService.deleteCourse(Long.parseLong(idStr));
        }
        resp.sendRedirect(req.getContextPath() + "/courses/manage");
    }

    private void saveModule(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ModuleDto dto = bindModule(req);
        try {
            courseService.saveModule(dto);
            resp.sendRedirect(req.getContextPath() + "/courses/detail?id=" + dto.getCourseId());
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/courses/manage?error=" + e.getMessage());
        }
    }

    private void deleteModule(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String moduleIdStr = req.getParameter("moduleId");
        String courseIdStr = req.getParameter("courseId");
        if (moduleIdStr != null) {
            courseService.deleteModule(Long.parseLong(moduleIdStr));
        }
        resp.sendRedirect(req.getContextPath() + "/courses/detail?id=" + courseIdStr);
    }

    private void saveLesson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        LessonDto dto = bindLesson(req);
        String courseIdStr = req.getParameter("courseId");
        try {
            courseService.saveLesson(dto);
            resp.sendRedirect(req.getContextPath() + "/courses/detail?id=" + courseIdStr);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/courses/manage?error=" + e.getMessage());
        }
    }

    private void deleteLesson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String lessonIdStr = req.getParameter("lessonId");
        String courseIdStr = req.getParameter("courseId");
        if (lessonIdStr != null) {
            courseService.deleteLesson(Long.parseLong(lessonIdStr));
        }
        resp.sendRedirect(req.getContextPath() + "/courses/detail?id=" + courseIdStr);
    }

    private void showLearningContent(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String regIdStr = req.getParameter("registrationId");
        if (regIdStr != null) {
            long regId = Long.parseLong(regIdStr);
            CourseDto course = courseService.getLearningContent(regId);
            req.setAttribute("course", course);
            req.setAttribute("registrationId", regId);

            String currentLessonIdStr = req.getParameter("lessonId");
            req.setAttribute("currentLessonId", currentLessonIdStr);
        }
        req.getRequestDispatcher("/WEB-INF/views/course/learn.jsp").forward(req, resp);
    }

    private void updateLessonProgress(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        long regId = Long.parseLong(req.getParameter("registrationId"));
        long lessonId = Long.parseLong(req.getParameter("lessonId"));
        String statusStr = req.getParameter("status");
        LessonProgressStatus status = (statusStr != null) ? LessonProgressStatus.fromDb(statusStr) : LessonProgressStatus.COMPLETED;

        courseService.updateLessonProgress(regId, lessonId, status);
        resp.sendRedirect(req.getContextPath() + "/courses/learn?registrationId=" + regId + "&lessonId=" + lessonId);
    }

    private CourseDto bindCourse(HttpServletRequest req) {
        CourseDto dto = new CourseDto();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            dto.setId(Long.parseLong(idStr.trim()));
        }
        dto.setTitle(req.getParameter("title"));
        String catId = req.getParameter("categoryId");
        if (catId != null && !catId.trim().isEmpty()) {
            dto.setCategoryId(Long.parseLong(catId.trim()));
        } else {
            dto.setCategoryId(6L);
        }
        dto.setDescription(req.getParameter("description"));
        String priceStr = req.getParameter("price");
        dto.setPrice(priceStr != null && !priceStr.trim().isEmpty() ? new BigDecimal(priceStr.trim()) : BigDecimal.ZERO);
        String statusStr = req.getParameter("status");
        dto.setStatus(statusStr != null ? CourseStatus.fromDb(statusStr) : CourseStatus.DRAFT);
        return dto;
    }

    private ModuleDto bindModule(HttpServletRequest req) {
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
        return dto;
    }

    private LessonDto bindLesson(HttpServletRequest req) {
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
        return dto;
    }
}
