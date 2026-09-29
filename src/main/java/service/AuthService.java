package service;

import dao.SettingDao;
import dao.UserDao;
import dto.LoginDto;
import dto.RegisterDto;
import dto.UserDto;
import entity.Setting;
import entity.User;
import entity.enums.AuthProvider;
import entity.enums.SettingType;
import entity.enums.UserStatus;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;
import util.DbConnection;
import util.PasswordUtil;
import util.ValidationUtil;

public class AuthService {

    private final UserDao userDao;
    private final SettingDao settingDao;

    public AuthService(UserDao userDao, SettingDao settingDao) {
        this.userDao = userDao;
        this.settingDao = settingDao;
    }

    public UserDto authenticate(LoginDto dto) {
        validateLogin(dto);
        try (Connection con = DbConnection.getConnection()) {
            Optional<User> userOpt = userDao.findByUsernameOrEmail(con, dto.getLoginId().trim());
            if (!userOpt.isPresent()) {
                throw new IllegalArgumentException("Tài khoản hoặc mật khẩu không chính xác.");
            }
            User user = userOpt.get();
            if (user.getStatus() == UserStatus.BANNED) {
                throw new IllegalStateException("Tài khoản của bạn đã bị khóa.");
            }
            if (user.getStatus() == UserStatus.INACTIVE) {
                throw new IllegalStateException("Tài khoản chưa được kích hoạt.");
            }
            if (!PasswordUtil.verify(dto.getPassword(), user.getPasswordHash())) {
                throw new IllegalArgumentException("Tài khoản hoặc mật khẩu không chính xác.");
            }
            return mapUser(user);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi xác thực hệ thống: " + e.getMessage(), e);
        }
    }

    public UserDto register(RegisterDto dto) {
        validateRegistration(dto);
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                if (userDao.existsUsername(con, dto.getUsername().trim(), null)) {
                    throw new IllegalArgumentException("Tên đăng nhập đã được sử dụng.");
                }
                if (userDao.existsEmail(con, dto.getEmail().trim(), null)) {
                    throw new IllegalArgumentException("Email đã được sử dụng.");
                }

                Setting studentRole = resolveStudentRole();

                User user = new User();
                user.setUsername(dto.getUsername().trim());
                user.setEmail(dto.getEmail().trim());
                user.setPasswordHash(PasswordUtil.hash(dto.getPassword()));
                user.setFullName(dto.getFullName().trim());
                user.setRoleId(studentRole != null ? studentRole.getId() : null);
                user.setRoleType(SettingType.USER_ROLE);
                user.setAuthProvider(AuthProvider.LOCAL);
                user.setStatus(UserStatus.ACTIVE);

                long id = userDao.insert(con, user);
                user.setId(id);
                con.commit();
                return mapUser(user);
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi đăng ký tài khoản: " + e.getMessage(), e);
        }
    }

    public UserDto authenticateGoogle(String email, String name) {
        if (!ValidationUtil.isEmail(email)) {
            throw new IllegalArgumentException("Email Google không hợp lệ.");
        }
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Optional<User> userOpt = userDao.findByUsernameOrEmail(con, email.trim());
                User user;
                if (userOpt.isPresent()) {
                    user = userOpt.get();
                } else {
                    Setting studentRole = resolveStudentRole();
                    user = new User();
                    user.setUsername(email.split("@")[0]);
                    user.setEmail(email.trim());
                    user.setPasswordHash(null);
                    user.setFullName(name != null && !name.trim().isEmpty() ? name.trim() : email.split("@")[0]);
                    user.setRoleId(studentRole != null ? studentRole.getId() : null);
                    user.setRoleType(SettingType.USER_ROLE);
                    user.setAuthProvider(AuthProvider.GOOGLE);
                    user.setStatus(UserStatus.ACTIVE);
                    long id = userDao.insert(con, user);
                    user.setId(id);
                }
                con.commit();
                return mapUser(user);
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi đăng nhập Google: " + e.getMessage(), e);
        }
    }

    public void logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }

    private void validateLogin(LoginDto dto) {
        if (dto == null) {
            throw new IllegalArgumentException("Thông tin đăng nhập không được để trống.");
        }
        ValidationUtil.requireText(dto.getLoginId(), "Tên đăng nhập hoặc Email");
        ValidationUtil.requireText(dto.getPassword(), "Mật khẩu");
    }

    private void validateRegistration(RegisterDto dto) {
        if (dto == null) {
            throw new IllegalArgumentException("Thông tin đăng ký không được để trống.");
        }

        ValidationUtil.requireText(dto.getFullName(), "Họ và tên");
        if (!ValidationUtil.isValidFullName(dto.getFullName())) {
            throw new IllegalArgumentException("Họ và tên phải từ 3 đến 50 ký tự.");
        }

        ValidationUtil.requireText(dto.getUsername(), "Tên đăng nhập");
        if (!ValidationUtil.isValidUsername(dto.getUsername())) {
            throw new IllegalArgumentException(
                    "Tên đăng nhập phải từ 4–30 ký tự, chỉ gồm chữ cái, số hoặc dấu gạch dưới (_).");
        }

        ValidationUtil.requireText(dto.getEmail(), "Email");
        if (!ValidationUtil.isEmail(dto.getEmail())) {
            throw new IllegalArgumentException("Email không đúng định dạng.");
        }

        ValidationUtil.requireText(dto.getPassword(), "Mật khẩu");
        if (!ValidationUtil.isStrongPassword(dto.getPassword())) {
            throw new IllegalArgumentException(
                    "Mật khẩu phải từ 8–32 ký tự, chứa ít nhất 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.");
        }

        // Xác nhận mật khẩu
        if (!dto.getPassword().equals(dto.getConfirmPassword())) {
            throw new IllegalArgumentException("Xác nhận mật khẩu không khớp.");
        }

        if (!dto.isAgreeTerms()) {
            throw new IllegalArgumentException("Bạn phải đồng ý với điều khoản dịch vụ để tiếp tục.");
        }
    }

    private Setting resolveStudentRole() {
        try (Connection con = DbConnection.getConnection()) {
            List<Setting> roles = settingDao.findByType(con, SettingType.USER_ROLE);
            for (Setting r : roles) {
                if ("STUDENT".equalsIgnoreCase(r.getValue()) || "ROLE_STUDENT".equalsIgnoreCase(r.getName())) {
                    return r;
                }
            }
            return !roles.isEmpty() ? roles.get(0) : null;
        } catch (SQLException e) {
            return null;
        }
    }

    private UserDto mapUser(User user) {
        if (user == null) {
            return null;
        }
        UserDto dto = new UserDto();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFullName(user.getFullName());
        dto.setRoleId(user.getRoleId());
        dto.setAuthProvider(user.getAuthProvider());
        dto.setStatus(user.getStatus());

        if (user.getRoleId() != null) {
            try (Connection con = DbConnection.getConnection()) {
                settingDao.findById(con, user.getRoleId()).ifPresent(s -> dto.setRoleName(s.getValue()));
            } catch (SQLException ignored) {
            }
        }
        return dto;
    }
}
