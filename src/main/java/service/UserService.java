package service;

import dao.SettingDao;
import dao.UserDao;
import dto.UserDto;
import entity.Setting;
import entity.User;
import entity.enums.AuthProvider;
import entity.enums.SettingType;
import entity.enums.UserStatus;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import util.DbConnection;
import util.PasswordUtil;
import util.ValidationUtil;

public class UserService {
    private final UserDao userDao;
    private final SettingDao settingDao;

    public UserService(UserDao userDao, SettingDao settingDao) {
        this.userDao = userDao;
        this.settingDao = settingDao;
    }

    public List<UserDto> getUsers() {
        try (Connection con = DbConnection.getConnection()) {
            List<User> list = userDao.findAll(con);
            List<UserDto> result = new ArrayList<>();
            for (User u : list) {
                result.add(mapUser(u));
            }
            return result;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách người dùng: " + e.getMessage(), e);
        }
    }

    public UserDto getUser(long userId) {
        try (Connection con = DbConnection.getConnection()) {
            return userDao.findById(con, userId)
                    .map(this::mapUser)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng với ID: " + userId));
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi truy xuất người dùng: " + e.getMessage(), e);
        }
    }

    public long saveUser(UserDto dto) {
        validateUser(dto);
        ensureUniqueIdentity(dto);
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                if (dto.getId() != null && dto.getId() > 0) {
                    Optional<User> existingOpt = userDao.findById(con, dto.getId());
                    if (!existingOpt.isPresent()) {
                        throw new IllegalArgumentException("Không tìm thấy người dùng cần cập nhật.");
                    }
                    User user = existingOpt.get();
                    user.setFullName(dto.getFullName().trim());
                    user.setRoleId(dto.getRoleId());
                    user.setStatus(dto.getStatus() != null ? dto.getStatus() : user.getStatus());
                    userDao.update(con, user);
                    con.commit();
                    return user.getId();
                } else {
                    User user = new User();
                    user.setUsername(dto.getUsername().trim());
                    user.setEmail(dto.getEmail().trim());
                    user.setFullName(dto.getFullName().trim());
                    user.setPasswordHash(PasswordUtil.hash("123456")); // Mật khẩu mặc định khi admin tạo
                    user.setRoleId(dto.getRoleId());
                    user.setRoleType(SettingType.USER_ROLE);
                    user.setAuthProvider(dto.getAuthProvider() != null ? dto.getAuthProvider() : AuthProvider.LOCAL);
                    user.setStatus(dto.getStatus() != null ? dto.getStatus() : UserStatus.ACTIVE);
                    long id = userDao.insert(con, user);
                    con.commit();
                    return id;
                }
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lưu người dùng: " + e.getMessage(), e);
        }
    }

    public void updateProfile(UserDto dto) {
        if (dto == null || dto.getId() == null) {
            throw new IllegalArgumentException("Thông tin hồ sơ không hợp lệ.");
        }
        ValidationUtil.requireText(dto.getFullName(), "Họ và tên");
        try (Connection con = DbConnection.getConnection()) {
            Optional<User> userOpt = userDao.findById(con, dto.getId());
            if (!userOpt.isPresent()) {
                throw new IllegalArgumentException("Không tìm thấy người dùng.");
            }
            User user = userOpt.get();
            user.setFullName(dto.getFullName().trim());
            userDao.update(con, user);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi cập nhật hồ sơ: " + e.getMessage(), e);
        }
    }

    public void changeStatus(long userId, UserStatus status) {
        if (status == null) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ.");
        }
        try (Connection con = DbConnection.getConnection()) {
            boolean updated = userDao.updateStatus(con, userId, status);
            if (!updated) {
                throw new IllegalArgumentException("Không thể cập nhật trạng thái người dùng ID: " + userId);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi thay đổi trạng thái người dùng: " + e.getMessage(), e);
        }
    }

    private void validateUser(UserDto dto) {
        if (dto == null) {
            throw new IllegalArgumentException("Dữ liệu người dùng trống.");
        }
        if (dto.getId() == null || dto.getId() <= 0) {
            ValidationUtil.requireText(dto.getUsername(), "Tên đăng nhập");
            ValidationUtil.requireText(dto.getEmail(), "Email");
            if (!ValidationUtil.isEmail(dto.getEmail())) {
                throw new IllegalArgumentException("Email không đúng định dạng.");
            }
        }
        ValidationUtil.requireText(dto.getFullName(), "Họ và tên");
    }

    private void ensureUniqueIdentity(UserDto dto) {
        try (Connection con = DbConnection.getConnection()) {
            if (dto.getId() == null || dto.getId() <= 0) {
                if (userDao.existsUsername(con, dto.getUsername(), null)) {
                    throw new IllegalArgumentException("Tên đăng nhập đã tồn tại.");
                }
                if (userDao.existsEmail(con, dto.getEmail(), null)) {
                    throw new IllegalArgumentException("Email đã tồn tại.");
                }
            } else {
                if (dto.getEmail() != null && userDao.existsEmail(con, dto.getEmail(), dto.getId())) {
                    throw new IllegalArgumentException("Email đã được sử dụng bởi tài khoản khác.");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi kiểm tra tính duy nhất của tài khoản: " + e.getMessage(), e);
        }
    }

    private UserDto mapUser(User user) {
        if (user == null) return null;
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
                Optional<Setting> s = settingDao.findById(con, user.getRoleId());
                s.ifPresent(setting -> dto.setRoleName(setting.getValue()));
            } catch (SQLException ignored) {
            }
        }
        return dto;
    }
}
