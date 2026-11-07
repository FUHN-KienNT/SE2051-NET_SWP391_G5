package controller;

import dao.SettingDao;
import dao.UserDao;
import dto.SettingDto;
import dto.UserDto;
import entity.enums.AuthProvider;
import entity.enums.UserStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import service.UserService;
import util.SessionUtil;

@WebServlet(name = "UserServlet", urlPatterns = {"/users/*"})
public class UserServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService(new UserDao(), new SettingDao());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "list";
        processAction(action, req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "save";
        processAction(action, req, resp);
    }

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        switch (action) {
            case "list":
                showList(req, resp);
                break;
            case "detail":
                showDetail(req, resp);
                break;
            case "new":
                showNewUser(req, resp);
                break;
            case "create":
                createUser(req, resp);
                break;
            case "save":
                saveUser(req, resp);
                break;
            case "reset-password":
                resetPassword(req, resp);
                break;
            case "toggle-status":
                toggleStatus(req, resp);
                break;
            case "change-status":
                changeStatus(req, resp);
                break;
            case "delete":
                deleteUser(req, resp);
                break;
            case "profile":
                showProfile(req, resp);
                break;
            case "update-profile":
                updateProfile(req, resp);
                break;
            default:
                showList(req, resp);
                break;
        }
    }

    /**
     * SRS 2.3.1: Quản lý danh sách Người dùng (User List).
     * Hỗ trợ tìm kiếm theo full name, username, email; lọc theo Role và Status; sắp xếp theo các cột.
     */
    private void showList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String roleIdStr = req.getParameter("roleId");
        String status = req.getParameter("status");
        String sortBy = req.getParameter("sortBy");
        String sortOrder = req.getParameter("sortOrder");

        Long roleId = null;
        if (roleIdStr != null && !roleIdStr.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleIdStr.trim())) {
            try {
                roleId = Long.parseLong(roleIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        if (status == null || status.trim().isEmpty()) {
            status = "ALL";
        }

        if (sortBy == null || sortBy.trim().isEmpty()) {
            sortBy = "id";
        }
        if (sortOrder == null || sortOrder.trim().isEmpty()) {
            sortOrder = "desc";
        }

        List<UserDto> users = userService.searchUsers(roleId, status, keyword, sortBy, sortOrder);
        List<SettingDto> roles = userService.getRoles();

        req.setAttribute("users", users);
        req.setAttribute("roles", roles);
        req.setAttribute("currentKeyword", keyword != null ? keyword : "");
        req.setAttribute("currentRoleId", roleId);
        req.setAttribute("currentStatus", status);
        req.setAttribute("currentSortBy", sortBy);
        req.setAttribute("currentSortOrder", sortOrder);

        req.getRequestDispatcher("/WEB-INF/views/user/list.jsp").forward(req, resp);
    }

    /**
     * SRS 2.3.2: Chi tiết người dùng & Phân quyền (User Details).
     */
    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/users/list");
            return;
        }

        try {
            long userId = Long.parseLong(idStr.trim());
            UserDto user = userService.getUser(userId);
            List<SettingDto> roles = userService.getRoles();
            req.setAttribute("user", user);
            req.setAttribute("roles", roles);
            req.getRequestDispatcher("/WEB-INF/views/user/detail.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/users/list?error=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8));
        }
    }

    /**
     * SRS 2.3.3: Màn hình tạo tài khoản nội bộ / người dùng mới (New User).
     */
    private void showNewUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<SettingDto> roles = userService.getRoles();
        req.setAttribute("roles", roles);
        req.getRequestDispatcher("/WEB-INF/views/user/new.jsp").forward(req, resp);
    }

    /**
     * Xử lý POST tạo tài khoản mới (SRS 2.3.3).
     */
    private void createUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto dto = new UserDto();
        dto.setFullName(req.getParameter("fullName"));
        dto.setUsername(req.getParameter("username"));
        dto.setEmail(req.getParameter("email"));
        dto.setRawPassword(req.getParameter("password"));
        dto.setPhone(req.getParameter("phone"));

        String roleIdStr = req.getParameter("roleId");
        if (roleIdStr != null && !roleIdStr.trim().isEmpty()) {
            dto.setRoleId(Long.parseLong(roleIdStr.trim()));
        }

        String statusStr = req.getParameter("status");
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            dto.setStatus(UserStatus.fromDb(statusStr.trim()));
        } else {
            dto.setStatus(UserStatus.ACTIVE);
        }

        try {
            long newUserId = userService.createUser(dto);
            resp.sendRedirect(req.getContextPath() + "/users/list?success=created");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("formUser", dto);
            req.setAttribute("roles", userService.getRoles());
            req.getRequestDispatcher("/WEB-INF/views/user/new.jsp").forward(req, resp);
        }
    }

    /**
     * Cập nhật thông tin, phân quyền và mật khẩu người dùng (SRS 2.3.2).
     */
    private void saveUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        UserDto dto = new UserDto();
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/users/list");
            return;
        }

        long userId = Long.parseLong(idStr.trim());
        dto.setId(userId);
        dto.setFullName(req.getParameter("fullName"));
        dto.setPhone(req.getParameter("phone"));

        String roleIdStr = req.getParameter("roleId");
        if (roleIdStr != null && !roleIdStr.trim().isEmpty()) {
            dto.setRoleId(Long.parseLong(roleIdStr.trim()));
        }

        String statusStr = req.getParameter("status");
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            dto.setStatus(UserStatus.fromDb(statusStr.trim()));
        }

        // Nhận mật khẩu mới nếu Admin muốn đổi mật khẩu
        String newPassword = req.getParameter("newPassword");
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            dto.setRawPassword(newPassword.trim());
        }

        try {
            userService.updateUser(dto, currentUser);
            String successParam = (dto.getRawPassword() != null && !dto.getRawPassword().isEmpty()) ? "password_and_info_updated" : "true";
            resp.sendRedirect(req.getContextPath() + "/users/detail?id=" + userId + "&success=" + successParam);
        } catch (Exception e) {
            try {
                UserDto existingUser = userService.getUser(userId);
                existingUser.setFullName(dto.getFullName());
                existingUser.setPhone(dto.getPhone());
                existingUser.setRoleId(dto.getRoleId());
                existingUser.setStatus(dto.getStatus());
                req.setAttribute("user", existingUser);
            } catch (Exception ignored) {}

            req.setAttribute("roles", userService.getRoles());
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/user/detail.jsp").forward(req, resp);
        }
    }

    /**
     * Đặt lại mật khẩu tài khoản trực tiếp (Reset Password).
     */
    private void resetPassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String password = req.getParameter("password");
        if (password == null || password.trim().isEmpty()) {
            password = "Password@123";
        }
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                long userId = Long.parseLong(idStr.trim());
                userService.resetPassword(userId, password.trim());
                resp.sendRedirect(req.getContextPath() + "/users/detail?id=" + userId + "&success=password_reset");
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/users/detail?id=" + idStr + "&error=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8));
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/users/list");
    }

    /**
     * Bật / Tắt trạng thái tài khoản trực tiếp (Toggle Account Status - SRS 2.3.1).
     */
    private void toggleStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                long userId = Long.parseLong(idStr.trim());
                userService.toggleStatus(userId, currentUser);
                resp.sendRedirect(req.getContextPath() + "/users/list?success=status_updated");
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/users/list?error=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8));
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/users/list");
    }

    /**
     * Đổi trạng thái tài khoản sang trạng thái mục tiêu cụ thể.
     */
    private void changeStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        String idStr = req.getParameter("id");
        String statusStr = req.getParameter("status");
        if (idStr != null && statusStr != null) {
            try {
                long id = Long.parseLong(idStr.trim());
                UserStatus status = UserStatus.fromDb(statusStr.trim());
                userService.changeStatus(id, status, currentUser);
                resp.sendRedirect(req.getContextPath() + "/users/list?success=status_updated");
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/users/list?error=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8));
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/users/list");
    }

    /**
     * Xóa tài khoản người dùng an toàn.
     */
    private void deleteUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                long userId = Long.parseLong(idStr.trim());
                userService.deleteUser(userId, currentUser);
                resp.sendRedirect(req.getContextPath() + "/users/list?success=deleted");
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/users/list?error=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8));
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/users/list");
    }

    private void showProfile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser != null) {
            UserDto profile = userService.getUser(currentUser.getId());
            req.setAttribute("user", profile);
        }
        resp.sendRedirect(req.getContextPath() + "/profile");
    }

    private void updateProfile(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        UserDto dto = new UserDto();
        dto.setId(currentUser.getId());
        dto.setFullName(req.getParameter("fullName"));
        try {
            userService.updateProfile(dto);
            currentUser.setFullName(dto.getFullName());
            SessionUtil.setCurrentUser(req, currentUser);
            resp.sendRedirect(req.getContextPath() + "/profile?success=true");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/profile?error=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8));
        }
    }
}
