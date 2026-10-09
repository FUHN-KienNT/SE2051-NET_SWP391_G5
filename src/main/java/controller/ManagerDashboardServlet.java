package controller;

import dto.CourseDto;
import dto.RegistrationDto;
import dto.UserDto;
import service.CourseService;
import service.RegistrationService;
import util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import dao.CourseDao;
import dao.LessonDao;
import dao.LessonProgressDao;
import dao.ModuleDao;
import dao.RegistrationDao;

@WebServlet("/manager/dashboard")
public class ManagerDashboardServlet extends HttpServlet {
    private CourseService courseService;
    private RegistrationService registrationService;

    @Override
    public void init() throws ServletException {
        CourseDao courseDao = new CourseDao();
        ModuleDao moduleDao = new ModuleDao();
        LessonDao lessonDao = new LessonDao();
        LessonProgressDao lessonProgressDao = new LessonProgressDao();
        RegistrationDao registrationDao = new RegistrationDao();
        
        this.courseService = new CourseService(courseDao, moduleDao, lessonDao, lessonProgressDao, registrationDao);
        this.registrationService = new RegistrationService(registrationDao, courseDao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null || !"MANAGER".equalsIgnoreCase(currentUser.getRoleName())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            return;
        }

        long managerId = currentUser.getId();

        // 1. Tổng quan khóa học
        List<CourseDto> managerCourses = courseService.searchAdminCourses(null, null, managerId, null);
        int totalCourses = managerCourses.size();
        
        long publishedCount = managerCourses.stream().filter(c -> "PUBLISHED".equals(c.getStatus())).count();
        long draftCount = managerCourses.stream().filter(c -> "DRAFT".equals(c.getStatus())).count();
        long pendingCount = managerCourses.stream().filter(c -> "PENDING_REVIEW".equals(c.getStatus())).count();

        // 2. Tổng quan đăng ký và doanh thu
        int totalRegistrations = registrationService.countByManagerId(managerId);
        BigDecimal totalRevenue = registrationService.sumRevenueByManagerId(managerId);

        // 3. Danh sách đăng ký gần đây
        List<RegistrationDto> recentRegistrations = registrationService.getByManager(managerId);
        if (recentRegistrations.size() > 10) {
            recentRegistrations = recentRegistrations.subList(0, 10);
        }

        req.setAttribute("totalCourses", totalCourses);
        req.setAttribute("publishedCount", publishedCount);
        req.setAttribute("draftCount", draftCount);
        req.setAttribute("pendingCount", pendingCount);
        
        req.setAttribute("totalRegistrations", totalRegistrations);
        req.setAttribute("totalRevenue", totalRevenue);
        
        req.setAttribute("recentCourses", managerCourses.size() > 5 ? managerCourses.subList(0, 5) : managerCourses);
        req.setAttribute("recentRegistrations", recentRegistrations);

        req.getRequestDispatcher("/WEB-INF/views/manager/dashboard.jsp").forward(req, resp);
    }
}
