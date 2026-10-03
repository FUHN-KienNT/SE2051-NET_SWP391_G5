package controller;

import dao.CourseDao;
import dao.LessonDao;
import dao.LessonProgressDao;
import dao.ModuleDao;
import dao.RegistrationDao;
import dto.CourseDto;
import dto.UserDto;
import entity.enums.CourseStatus;
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

/**
 * Controller phụ trách các màn hình System Administration (BF-02) của Dũng:
 * - Admin Dashboard (II.2.1)
 * - Course List (II.2.4.1)
 * - Course Detail (II.2.4.2) & Phân công Expert
 */
@WebServlet(name = "AdminCourseServlet", urlPatterns = {"/admin/*"})
public class AdminCourseServlet extends HttpServlet {
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
                showDashboard(req, resp);
                break;
            case "courses":
                showCourseList(req, resp);
                break;
            case "course-detail":
                showCourseDetail(req, resp);
                break;
            case "save-course":
                saveCourse(req, resp);
                break;
            case "toggle-status":
                toggleCourseStatus(req, resp);
                break;
            case "delete-course":
                deleteCourse(req, resp);
                break;
            default:
                showDashboard(req, resp);
                break;
        }
    }

    private void toggleCourseStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                long courseId = Long.parseLong(idStr);
                CourseDto course = courseService.getCourseDetail(courseId);
                CourseStatus newStatus = course.getStatus() == CourseStatus.PUBLISHED ? CourseStatus.DRAFT : CourseStatus.PUBLISHED;
                courseService.updateCourseStatus(courseId, newStatus);
            } catch (Exception ignored) {}
        }
        resp.sendRedirect(req.getContextPath() + "/admin/courses?success=status_updated");
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<CourseDto> allCourses = courseService.getAllCourses();
        List<UserDto> experts = courseService.getExperts();
        
        req.setAttribute("totalCourses", allCourses.size());
        req.setAttribute("totalExperts", experts.size());
        req.setAttribute("recentCourses", allCourses.size() > 5 ? allCourses.subList(0, 5) : allCourses);
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void showCourseList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<CourseDto> courses = courseService.getAllCourses();
        List<UserDto> experts = courseService.getExperts();
        
        req.setAttribute("courses", courses);
        req.setAttribute("experts", experts);
        req.getRequestDispatcher("/WEB-INF/views/admin/course_list.jsp").forward(req, resp);
    }

    private void showCourseDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            long courseId = Long.parseLong(idStr);
            CourseDto course = courseService.getCourseDetail(courseId);
            req.setAttribute("course", course);
        }
        List<UserDto> experts = courseService.getExperts();
        req.setAttribute("experts", experts);
        req.getRequestDispatcher("/WEB-INF/views/admin/course_detail.jsp").forward(req, resp);
    }

    private void saveCourse(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        CourseDto dto = bindCourse(req);
        if (dto.getId() == null || dto.getId() <= 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Admin và Manager không trực tiếp tạo khóa học. Khóa học phải do Expert khởi tạo và gửi duyệt.", "UTF-8"));
            return;
        }
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (dto.getManagerId() == null && currentUser != null) {
            dto.setManagerId(currentUser.getId());
        }
        try {
            long id = courseService.saveCourse(dto);
            resp.sendRedirect(req.getContextPath() + "/admin/course-detail?id=" + id + "&success=true");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private void deleteCourse(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            courseService.deleteCourse(Long.parseLong(idStr));
        }
        resp.sendRedirect(req.getContextPath() + "/admin/courses");
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
        
        // Gán Expert phụ trách khóa học (theo SRS)
        String expertIdStr = req.getParameter("expertId");
        if (expertIdStr != null && !expertIdStr.trim().isEmpty()) {
            dto.setExpertId(Long.parseLong(expertIdStr.trim()));
        }
        return dto;
    }
}
