package controller;

import dto.UserDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import service.ProfileService;
import service.ValidationException;
import util.SessionUtil;
import util.WebUtil;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/profile/*", "/uploads/*"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,        // 1MB
        maxFileSize = 15L * 1024L * 1024L,      // 15MB
        maxRequestSize = 20L * 1024L * 1024L    // 20MB
)
public class ProfileServlet extends HttpServlet {

    private ProfileService profileService;
    private File avatarStorageDir;

    @Override
    public void init() throws ServletException {
        this.profileService = new ProfileService();
        this.avatarStorageDir = ProfileService.resolveDefaultAvatarDir();
        if (!this.avatarStorageDir.exists()) {
            this.avatarStorageDir.mkdirs();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("/uploads".equalsIgnoreCase(req.getServletPath())) {
            serveAvatar(req, resp);
            return;
        }

        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String pathInfo = req.getPathInfo();
        if ("/change-password".equalsIgnoreCase(pathInfo) || "/password".equalsIgnoreCase(pathInfo)) {
            showChangePassword(req, resp, currentUser);
            return;
        }

        showProfile(req, resp, currentUser);
    }

    private void showProfile(HttpServletRequest req, HttpServletResponse resp, UserDto currentUser)
            throws ServletException, IOException {
        try {
            UserDto profile = profileService.getProfile(currentUser.getId());
            req.setAttribute("user", profile);
            req.getRequestDispatcher("/WEB-INF/views/profile/index.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi tải thông tin hồ sơ: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/profile/index.jsp").forward(req, resp);
        }
    }

    private void showChangePassword(HttpServletRequest req, HttpServletResponse resp, UserDto currentUser)
            throws ServletException, IOException {
        try {
            if (!profileService.hasPassword(currentUser.getId())) {
                resp.sendRedirect(req.getContextPath() + "/auth/set-password");
                return;
            }
            UserDto profile = profileService.getProfile(currentUser.getId());
            req.setAttribute("user", profile);
            req.getRequestDispatcher("/WEB-INF/views/profile/change-password.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi tải trang đổi mật khẩu: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/profile/change-password.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            if (isAjax(req)) {
                sendJsonResponse(resp, HttpServletResponse.SC_UNAUTHORIZED, false, null, "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.", null);
            } else {
                resp.sendRedirect(req.getContextPath() + "/auth/login");
            }
            return;
        }

        String pathInfo = req.getPathInfo();
        String action = req.getParameter("action");
        if (action == null && pathInfo != null && pathInfo.length() > 1) {
            action = pathInfo.substring(1);
        }
        if (action == null) {
            action = "";
        }

        if ("/change-password".equalsIgnoreCase(pathInfo) || "/password".equalsIgnoreCase(pathInfo)
                || "change-password".equalsIgnoreCase(action) || "password".equalsIgnoreCase(action)) {
            handleChangePassword(req, resp, currentUser);
            return;
        }

        switch (action) {
            case "avatar":
                handleUpdateAvatar(req, resp, currentUser);
                break;
            case "update-field":
                handleUpdateField(req, resp, currentUser);
                break;
            case "update":
            case "save":
            case "":
                if (req.getParameter("field") != null && !req.getParameter("field").trim().isEmpty()) {
                    handleUpdateField(req, resp, currentUser);
                } else {
                    handleUpdateProfile(req, resp, currentUser);
                }
                break;
            default:
                sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, false, null, "Thao tác không được hỗ trợ.", null);
                break;
        }
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp, UserDto currentUser)
            throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String username = req.getParameter("username");
        String phone = req.getParameter("phone");
        String birthDate = req.getParameter("birthDate");
        String bio = req.getParameter("bio");

        boolean ajax = isAjax(req);

        try {
            // Check avatar upload or remove
            String removeAvatar = req.getParameter("removeAvatar");
            if ("true".equalsIgnoreCase(removeAvatar)) {
                profileService.removeAvatar(currentUser.getId());
            } else {
                Part avatarPart = null;
                try {
                    avatarPart = req.getPart("avatar");
                } catch (Exception ignored) {
                }

                if (avatarPart != null && avatarPart.getSize() > 0) {
                    profileService.updateAvatar(currentUser.getId(), avatarPart);
                }
            }

            UserDto updatedUser = profileService.updateProfile(currentUser.getId(), fullName, username, phone, birthDate, bio);

            // Update session
            SessionUtil.setCurrentUser(req, updatedUser);

            if (ajax) {
                String avatarRel = updatedUser.getAvatarUrl();
                String fullAvatarUrl = "";
                if (avatarRel != null && !avatarRel.trim().isEmpty()) {
                    String ctx = req.getContextPath();
                    if (ctx == null) {
                        ctx = "";
                    }
                    if (!avatarRel.startsWith("/")) {
                        avatarRel = "/" + avatarRel;
                    }
                    fullAvatarUrl = ctx + avatarRel;
                }
                sendJsonResponse(resp, HttpServletResponse.SC_OK, true, "profile", "Cập nhật thông tin hồ sơ thành công!", fullAvatarUrl);
            } else {
                HttpSession session = req.getSession(true);
                session.setAttribute("flashToastType", "success");
                session.setAttribute("flashToastMessage", "Cập nhật thông tin hồ sơ thành công!");
                resp.sendRedirect(req.getContextPath() + "/profile");
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            String field = "profile";
            String msg = e.getMessage() != null ? e.getMessage() : "";
            if (msg.contains("Tiểu sử") || msg.contains("Mô tả")) {
                field = "bio";
            } else if (msg.contains("Họ và tên")) {
                field = "fullName";
            } else if (msg.contains("người dùng")) {
                field = "username";
            } else if (msg.contains("thoại")) {
                field = "phone";
            } else if (msg.contains("sinh") || msg.contains("tuổi")) {
                field = "birthDate";
            }
            if (ajax) {
                sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, false, field, e.getMessage(), null);
            } else {
                req.setAttribute("error", e.getMessage());
                showProfile(req, resp, currentUser);
            }
        } catch (Exception e) {
            if (ajax) {
                sendJsonResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, false, "profile", "Lỗi máy chủ khi cập nhật: " + e.getMessage(), null);
            } else {
                req.setAttribute("error", "Lỗi máy chủ khi cập nhật: " + e.getMessage());
                showProfile(req, resp, currentUser);
            }
        }
    }

    private void handleUpdateAvatar(HttpServletRequest req, HttpServletResponse resp, UserDto currentUser)
            throws IOException, ServletException {
        try {
            Part filePart = req.getPart("avatar");
            if (filePart == null || filePart.getSize() == 0) {
                sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, false, "avatar", "Vui lòng chọn một file ảnh hợp lệ.", null);
                return;
            }

            String newAvatarUrl = profileService.updateAvatar(currentUser.getId(), filePart);

            // Update session
            currentUser.setAvatarUrl(newAvatarUrl);
            SessionUtil.setCurrentUser(req, currentUser);

            String fullAvatarUrl = req.getContextPath() + newAvatarUrl;
            sendJsonResponse(resp, HttpServletResponse.SC_OK, true, "avatar", "Cập nhật ảnh đại diện thành công!", fullAvatarUrl);
        } catch (IllegalArgumentException | IllegalStateException e) {
            sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, false, "avatar", e.getMessage(), null);
        } catch (Exception e) {
            sendJsonResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, false, "avatar", "Lỗi hệ thống khi cập nhật ảnh: " + e.getMessage(), null);
        }
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp, UserDto currentUser)
            throws ServletException, IOException {
        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (newPassword == null) {
            newPassword = req.getParameter("value");
        }

        boolean ajax = isAjax(req);

        if (!profileService.hasPassword(currentUser.getId())) {
            if (ajax) {
                sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, false, "password", "Tài khoản chưa thiết lập mật khẩu. Vui lòng thiết lập mật khẩu trước.", null);
            } else {
                resp.sendRedirect(req.getContextPath() + "/auth/set-password");
            }
            return;
        }

        try {
            profileService.changePassword(currentUser.getId(), currentPassword, newPassword, confirmPassword);
            if (ajax) {
                sendJsonResponse(resp, HttpServletResponse.SC_OK, true, "password", "Đổi mật khẩu thành công!", null);
            } else {
                HttpSession session = req.getSession(true);
                session.setAttribute("flashToastType", "success");
                session.setAttribute("flashToastMessage", "Đổi mật khẩu thành công!");
                resp.sendRedirect(req.getContextPath() + "/profile/change-password");
            }
        } catch (ValidationException e) {
            if (ajax) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.setContentType("application/json;charset=UTF-8");
                StringBuilder sb = new StringBuilder();
                sb.append("{\"success\":false,\"message\":\"").append(escapeJson(e.getMessage())).append("\",\"fieldErrors\":{");
                int idx = 0;
                for (java.util.Map.Entry<String, String> entry : e.getErrors().entrySet()) {
                    if (idx > 0) sb.append(",");
                    sb.append("\"").append(escapeJson(entry.getKey())).append("\":\"").append(escapeJson(entry.getValue())).append("\"");
                    idx++;
                }
                sb.append("}}");
                resp.getWriter().write(sb.toString());
            } else {
                req.setAttribute("fieldErrors", e.getErrors());
                req.setAttribute("error", e.getMessage());
                showChangePassword(req, resp, currentUser);
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            if (ajax) {
                sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, false, "password", e.getMessage(), null);
            } else {
                req.setAttribute("error", e.getMessage());
                showChangePassword(req, resp, currentUser);
            }
        } catch (Exception e) {
            if (ajax) {
                sendJsonResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, false, "password", "Lỗi máy chủ khi đổi mật khẩu: " + e.getMessage(), null);
            } else {
                req.setAttribute("error", "Lỗi máy chủ khi đổi mật khẩu: " + e.getMessage());
                showChangePassword(req, resp, currentUser);
            }
        }
    }

    private void handleUpdateField(HttpServletRequest req, HttpServletResponse resp, UserDto currentUser)
            throws IOException {
        String field = req.getParameter("field");
        String value = req.getParameter("value");

        if (field == null || field.trim().isEmpty()) {
            sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, false, null, "Thiếu trường cần cập nhật.", null);
            return;
        }

        field = field.trim();

        // Strict security check: Email is NEVER allowed to be edited
        if ("email".equalsIgnoreCase(field)) {
            sendJsonResponse(resp, HttpServletResponse.SC_FORBIDDEN, false, "email", "Email là định danh tài khoản cố định, không được phép thay đổi.", null);
            return;
        }

        try {
            switch (field) {
                case "fullName": {
                    String updated = profileService.updateFullName(currentUser.getId(), value);
                    currentUser.setFullName(updated);
                    SessionUtil.setCurrentUser(req, currentUser);
                    sendJsonResponse(resp, HttpServletResponse.SC_OK, true, "fullName", "Cập nhật họ và tên thành công!", updated);
                    break;
                }
                case "username": {
                    String updated = profileService.updateUsername(currentUser.getId(), value);
                    currentUser.setUsername(updated);
                    SessionUtil.setCurrentUser(req, currentUser);
                    sendJsonResponse(resp, HttpServletResponse.SC_OK, true, "username", "Cập nhật tên đăng nhập thành công!", updated);
                    break;
                }
                case "phone": {
                    String updated = profileService.updatePhone(currentUser.getId(), value);
                    currentUser.setPhone(updated);
                    SessionUtil.setCurrentUser(req, currentUser);
                    sendJsonResponse(resp, HttpServletResponse.SC_OK, true, "phone", "Cập nhật số điện thoại thành công!", updated != null ? updated : "");
                    break;
                }
                case "birthDate": {
                    LocalDate updated = profileService.updateBirthDate(currentUser.getId(), value);
                    currentUser.setBirthDate(updated);
                    SessionUtil.setCurrentUser(req, currentUser);
                    String dateStr = updated != null ? updated.toString() : "";
                    sendJsonResponse(resp, HttpServletResponse.SC_OK, true, "birthDate", "Cập nhật ngày sinh thành công!", dateStr);
                    break;
                }
                case "bio": {
                    String updated = profileService.updateBio(currentUser.getId(), value);
                    currentUser.setBio(updated);
                    SessionUtil.setCurrentUser(req, currentUser);
                    sendJsonResponse(resp, HttpServletResponse.SC_OK, true, "bio", "Cập nhật tiểu sử thành công!", updated != null ? updated : "");
                    break;
                }
                case "password": {
                    handleChangePassword(req, resp, currentUser);
                    break;
                }
                default:
                    sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, false, field, "Trường cập nhật không hợp lệ: " + field, null);
                    break;
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, false, field, e.getMessage(), null);
        } catch (Exception e) {
            sendJsonResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, false, field, "Lỗi máy chủ khi cập nhật: " + e.getMessage(), null);
        }
    }

    private boolean isAjax(HttpServletRequest req) {
        return WebUtil.isAjax(req);
    }

    private void sendJsonResponse(HttpServletResponse resp, int status, boolean success, String field, String message, String value) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json;charset=UTF-8");
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"success\":").append(success);
        if (field != null) {
            sb.append(",\"field\":\"").append(escapeJson(field)).append("\"");
        }
        if (message != null) {
            sb.append(",\"message\":\"").append(escapeJson(message)).append("\"");
        }
        if (value != null) {
            sb.append(",\"value\":\"").append(escapeJson(value)).append("\"");
            sb.append(",\"avatarUrl\":\"").append(escapeJson(value)).append("\"");
        }
        sb.append("}");
        resp.getWriter().write(sb.toString());
    }

    private String escapeJson(String text) {
        return WebUtil.escapeJson(text);
    }

    private void serveAvatar(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.trim().isEmpty() || pathInfo.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Expected format: /avatar/{fileName}
        String normalized = pathInfo.replace('\\', '/');
        if (normalized.contains("..")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        File targetFile;
        if (normalized.startsWith("/avatar/")) {
            String fileName = normalized.substring("/avatar/".length());
            targetFile = new File(avatarStorageDir, fileName);
        } else {
            String fileName = normalized.startsWith("/") ? normalized.substring(1) : normalized;
            targetFile = new File(avatarStorageDir, fileName);
        }

        if (!targetFile.exists() || !targetFile.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String name = targetFile.getName().toLowerCase();
        String contentType = "application/octet-stream";
        if (name.endsWith(".png")) {
            contentType = "image/png";
        } else if (name.endsWith(".jpg") || name.endsWith(".jpeg")) {
            contentType = "image/jpeg";
        } else if (name.endsWith(".webp")) {
            contentType = "image/webp";
        }

        resp.setContentType(contentType);
        resp.setContentLengthLong(targetFile.length());
        resp.setHeader("Cache-Control", "public, max-age=86400");

        try (FileInputStream in = new FileInputStream(targetFile);
             OutputStream out = resp.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
        }
    }
}
