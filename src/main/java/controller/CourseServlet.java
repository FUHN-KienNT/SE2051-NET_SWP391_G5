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

    private void showLearningContent(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
            if ((currentLessonIdStr == null || currentLessonIdStr.trim().isEmpty()) && course != null && course.getModules() != null) {
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
        LessonProgressStatus status = (statusStr != null) ? LessonProgressStatus.fromDb(statusStr) : LessonProgressStatus.COMPLETED;

        try {
            courseService.updateLessonProgress(regId, currentUser.getId(), lessonId, status);
        } catch (SecurityException e) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/courses/learn?registrationId=" + regId + "&lessonId=" + lessonId);
    }
}
