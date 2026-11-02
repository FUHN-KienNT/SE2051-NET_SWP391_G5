package controller;

import dao.CourseDao;
import dao.LessonDao;
import dao.LessonProgressDao;
import dao.ModuleDao;
import dao.RegistrationDao;
import dao.SettingDao;
import dao.UserDao;
import dto.CourseDto;
import dto.SettingDto;
import dto.UserDto;
import entity.enums.CourseStatus;
import entity.enums.SettingType;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import service.CourseService;
import service.RegistrationService;
import service.SettingService;
import service.UserService;
import util.SessionUtil;

/**
 * Controller phụ trách các màn hình System Administration (BF-02):
 * - Admin Dashboard (II.2.1)
 * - Course List (II.2.4.1)
 * - Course Detail (II.2.4.2) & Phân công Expert
 */
@WebServlet(name = "AdminCourseServlet", urlPatterns = {"/admin/*", "/manager/*"})
public class AdminCourseServlet extends HttpServlet {
    private CourseService courseService;
    private SettingService settingService;
    private UserService userService;
    private RegistrationService registrationService;

    @Override
    public void init() throws ServletException {
        CourseDao courseDao = new CourseDao();
        RegistrationDao registrationDao = new RegistrationDao();
        this.courseService = new CourseService(
                courseDao, new ModuleDao(), new LessonDao(),
                new LessonProgressDao(), registrationDao
        );
        this.settingService = new SettingService(new SettingDao());
        this.userService = new UserService(new UserDao(), new SettingDao());
        this.registrationService = new RegistrationService(registrationDao, courseDao);
    }

    /**
     * Tiếp nhận và điều hướng các yêu cầu HTTP GET từ Quản trị viên (Admin) và Quản lý (Manager).
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "dashboard";
        processAction(action, req, resp);
    }

    /**
     * Tiếp nhận và điều hướng các yêu cầu HTTP POST (lưu, xóa, cập nhật trạng thái) từ Admin/Manager.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "dashboard";
        processAction(action, req, resp);
    }

    /**
     * Điều hướng các action của Admin Course: dashboard, courses, course-detail, save-course, toggle-status, delete-course.
     */
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

    /**
     * Duyệt xuất bản hoặc Từ chối khóa học.
     * 1. Gọi courseService.getCourseDetail(courseId) để kiểm tra khóa học tồn tại.
     * 2. Gọi courseService.updateCourseStatus(courseId, newStatus) để cập nhật cột 'status' trong bảng 'courses'.
     */
    private void toggleCourseStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String fromDashboard = req.getParameter("fromDashboard");
        String targetStatus = req.getParameter("status");
        if (idStr != null) {
            try {
                long courseId = Long.parseLong(idStr.trim());
                CourseDto course = courseService.getCourseDetail(courseId);
                CourseStatus newStatus;
                if (targetStatus != null && !targetStatus.trim().isEmpty()) {
                    newStatus = CourseStatus.fromDb(targetStatus.trim());
                } else {
                    newStatus = course.getStatus() == CourseStatus.PUBLISHED ? CourseStatus.DRAFT : CourseStatus.PUBLISHED;
                }
                courseService.updateCourseStatus(courseId, newStatus);
            } catch (Exception ignored) {}
        }
        if ("true".equalsIgnoreCase(fromDashboard)) {
            resp.sendRedirect(req.getContextPath() + req.getServletPath() + "/dashboard?success=status_updated");
        } else {
            resp.sendRedirect(req.getContextPath() + req.getServletPath() + "/courses?success=status_updated");
        }
    }

    /**
     * Hiển thị Bảng điều khiển Quản trị (Admin Dashboard).
     * 1. Gọi courseService, userService, settingService lấy thống kê khóa học, user, danh mục và khóa chờ duyệt.
     * 2. Gọi registrationService tính tổng doanh thu và số lượt đăng ký từ database.
     */
    private void showDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        dto.UserDto currentUser = util.SessionUtil.getCurrentUser(req);
        if (currentUser != null && "MANAGER".equalsIgnoreCase(currentUser.getRoleName())) {
            resp.sendRedirect(req.getContextPath() + "/manager/dashboard");
            return;
        }

        List<CourseDto> allCourses = courseService.getAllCourses();
        List<UserDto> experts = courseService.getExperts();
        List<UserDto> allUsers = userService.getUsers();
        List<SettingDto> categories = settingService.getByType(SettingType.COURSE_CATEGORY);

        List<CourseDto> pendingCourses = new java.util.ArrayList<>();
        int publishedCount = 0;
        int draftCount = 0;
        int pendingReviewCount = 0;
        if (allCourses != null) {
            for (CourseDto c : allCourses) {
                if (c.getStatus() == CourseStatus.PENDING_REVIEW) {
                    pendingReviewCount++;
                    pendingCourses.add(c);
                } else if (c.getStatus() == CourseStatus.DRAFT) {
                    draftCount++;
                } else if (c.getStatus() == CourseStatus.PUBLISHED) {
                    publishedCount++;
                }
            }
        }

        BigDecimal totalRevenue = registrationService.sumTotalRevenue();
        int totalPaidRegistrations = registrationService.countTotalPaidRegistrations();
        int totalRegistrations = registrationService.countTotalRegistrations();

        boolean isDbConnected = false;
        try (java.sql.Connection con = util.DbConnection.getConnection()) {
            isDbConnected = con != null && !con.isClosed() && con.isValid(2);
        } catch (Exception ignored) {}

        req.setAttribute("totalCourses", allCourses != null ? allCourses.size() : 0);
        req.setAttribute("publishedCount", publishedCount);
        req.setAttribute("draftCount", draftCount);
        req.setAttribute("pendingReviewCount", pendingReviewCount);
        req.setAttribute("pendingCourses", pendingCourses);
        req.setAttribute("draftCourses", pendingCourses);
        req.setAttribute("totalExperts", experts != null ? experts.size() : 0);
        req.setAttribute("totalUsers", allUsers != null ? allUsers.size() : 0);
        req.setAttribute("totalCategories", categories != null ? categories.size() : 0);
        req.setAttribute("totalRevenue", totalRevenue != null ? totalRevenue : BigDecimal.ZERO);
        req.setAttribute("totalPaidRegistrations", totalPaidRegistrations);
        req.setAttribute("totalRegistrations", totalRegistrations);
        req.setAttribute("isDbConnected", isDbConnected);
        req.setAttribute("recentCourses", allCourses != null && allCourses.size() > 5 ? allCourses.subList(0, 5) : allCourses);
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    /**
     * Quản lý danh sách khóa học toàn hệ thống.
     * 1. Gọi courseService.searchAdminCourses() lọc khóa học theo keyword, danh mục, manager, status.
     * 2. Gọi courseService.getExperts(), settingService, userService lấy danh sách cho bộ lọc.
     */
    private void showCourseList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("search");
        String categoryIdStr = req.getParameter("categoryId");
        String managerIdStr = req.getParameter("managerId");
        String status = req.getParameter("status");

        Long categoryId = (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) ? Long.parseLong(categoryIdStr.trim()) : null;
        Long managerId = (managerIdStr != null && !managerIdStr.trim().isEmpty()) ? Long.parseLong(managerIdStr.trim()) : null;
        if (status != null && status.trim().isEmpty()) status = null;

        List<CourseDto> courses = courseService.searchAdminCourses(search, categoryId, managerId, status);
        List<UserDto> experts = courseService.getExperts();
        List<SettingDto> categories = settingService.getByType(SettingType.COURSE_CATEGORY);

        List<UserDto> allUsers = userService.getUsers();
        List<UserDto> managers = new java.util.ArrayList<>();
        for (UserDto u : allUsers) {
            // Role 3 = Manager, Role 5 = Admin. Both can manage courses.
            if (u.getRoleId() != null && (u.getRoleId() == 3L || u.getRoleId() == 5L)) { 
                managers.add(u);
            }
        }

        req.setAttribute("courses", courses);
        req.setAttribute("experts", experts);
        req.setAttribute("managers", managers);
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/WEB-INF/views/admin/course_list.jsp").forward(req, resp);
    }

    /**
     * Xem chi tiết khóa học và phân công Expert/Manager phụ trách.
     * 1. Gọi courseService.getCourseDetail(courseId) lấy thông tin khóa học và đề cương.
     * 2. Gọi courseService.getExperts(), settingService, userService nạp dữ liệu phân công.
     */
    private void showCourseDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            long courseId = Long.parseLong(idStr.trim());
            CourseDto course = courseService.getCourseDetail(courseId);
            req.setAttribute("course", course);
        }
        List<UserDto> experts = courseService.getExperts();
        List<SettingDto> categories = settingService.getByType(SettingType.COURSE_CATEGORY);

        List<UserDto> allUsers = userService.getUsers();
        List<UserDto> managers = new java.util.ArrayList<>();
        for (UserDto u : allUsers) {
            if (u.getRoleId() != null && (u.getRoleId() == 3L || u.getRoleId() == 5L)) { 
                managers.add(u);
            }
        }

        req.setAttribute("experts", experts);
        req.setAttribute("managers", managers);
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/WEB-INF/views/admin/course_detail.jsp").forward(req, resp);
    }

    /**
     * Lưu thông tin khóa học và phân công Expert.
     * 1. Gọi bindCourse(req) để đọc dữ liệu form.
     * 2. Gọi courseService.saveCourse(dto) để cập nhật vào bảng 'courses'.
     */
    private void saveCourse(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        CourseDto dto = bindCourse(req);
        if (dto.getId() == null || dto.getId() <= 0) {
            resp.sendRedirect(req.getContextPath() + req.getServletPath() + "/courses?error=" + java.net.URLEncoder.encode("Admin và Manager không trực tiếp tạo khóa học. Khóa học phải do Expert khởi tạo và gửi duyệt.", "UTF-8"));
            return;
        }
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (dto.getManagerId() == null && currentUser != null) {
            dto.setManagerId(currentUser.getId());
        }
        try {
            long id = courseService.saveCourse(dto);
            resp.sendRedirect(req.getContextPath() + req.getServletPath() + "/course-detail?id=" + id + "&success=true");
        } catch (Exception e) {
            String encodedErr = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + req.getServletPath() + "/courses?error=" + encodedErr);
        }
    }

    /**
     * Xóa khóa học khỏi hệ thống.
     * 1. Gọi courseService.deleteCourse(courseId, currentUser) để kiểm tra và xóa khóa học.
     */
    private void deleteCourse(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                UserDto currentUser = SessionUtil.getCurrentUser(req);
                courseService.deleteCourse(Long.parseLong(idStr.trim()), currentUser);
                resp.sendRedirect(req.getContextPath() + req.getServletPath() + "/courses?deleted=true");
                return;
            } catch (Exception e) {
                String encodedErr = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + req.getServletPath() + "/courses?error=" + encodedErr);
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + req.getServletPath() + "/courses");
    }

    /**
     * Bóc tách tham số form request sang đối tượng CourseDto.
     */
    private CourseDto bindCourse(HttpServletRequest req) {
        CourseDto dto = new CourseDto();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            dto.setId(Long.parseLong(idStr.trim()));
        }
        dto.setTitle(req.getParameter("title"));
        String catId = req.getParameter("categoryId");
        String customCategory = req.getParameter("customCategory");
        if (customCategory != null && !customCategory.trim().isEmpty()) {
            dto.setCategoryId(courseService.getOrCreateCategory(customCategory));
        } else if (catId != null && !catId.trim().isEmpty() && !"__NEW__".equalsIgnoreCase(catId.trim())) {
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
