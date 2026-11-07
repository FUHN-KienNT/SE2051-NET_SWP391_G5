package service;

import dao.SettingDao;
import dao.UserDao;
import dto.SettingDto;
import dto.UserDto;
import entity.Setting;
import entity.User;
import entity.enums.AuthProvider;
import entity.enums.SettingType;
import entity.enums.UserStatus;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    /**
     * Lấy toàn bộ danh sách người dùng trong hệ thống.
     */
    public List<UserDto> getUsers() {
        return searchUsers(null, null, null, "id", "desc");
    }

    /**
     * Tìm kiếm, lọc theo vai trò, trạng thái và sắp xếp danh sách người dùng (SRS 2.3.1).
     */
    public List<UserDto> searchUsers(Long roleId, String status, String keyword, String sortBy, String sortOrder) {
        try (Connection con = DbConnection.getConnection()) {
            List<User> list = userDao.search(con, roleId, status, keyword, sortBy, sortOrder);
            Map<Long, String> roleMap = loadRoleMap(con);

            List<UserDto> result = new ArrayList<>();
            for (User u : list) {
                result.add(mapUserWithRoleMap(u, roleMap));
            }
            return result;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi tìm kiếm danh sách người dùng: " + e.getMessage(), e);
        }
    }

    /**
     * Lấy danh sách các vai trò tài khoản (USER_ROLE) từ bảng settings để hiển thị dropdown bộ lọc.
     */
    public List<SettingDto> getRoles() {
        try (Connection con = DbConnection.getConnection()) {
            List<Setting> settings = settingDao.findByType(con, SettingType.USER_ROLE);
            List<SettingDto> dtos = new ArrayList<>();
            for (Setting s : settings) {
                SettingDto dto = new SettingDto();
                dto.setId(s.getId());
                dto.setType(s.getType());
                dto.setName(s.getName());
                dto.setValue(s.getValue());
                dto.setPriority(s.getPriority());
                dto.setStatus(s.getStatus());
                dto.setDescription(s.getDescription());
                dtos.add(dto);
            }
            return dtos;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi tải danh mục vai trò người dùng: " + e.getMessage(), e);
        }
    }

    /**
     * Lấy thông tin chi tiết một người dùng theo ID (SRS 2.3.2) cùng số lượng khóa học liên kết.
     */
    public UserDto getUser(long userId) {
        try (Connection con = DbConnection.getConnection()) {
            Map<Long, String> roleMap = loadRoleMap(con);
            User user = userDao.findById(con, userId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng với ID: " + userId));

            UserDto dto = mapUserWithRoleMap(user, roleMap);
            dto.setEnrolledCoursesCount(userDao.countUserRegistrations(con, userId));
            dto.setAssignedCoursesCount(userDao.countExpertCourses(con, userId) + userDao.countManagerCourses(con, userId));
            return dto;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi truy xuất người dùng: " + e.getMessage(), e);
        }
    }

    /**
     * Tạo tài khoản người dùng mới (SRS 2.3.3 New User).
     * Kiểm tra định dạng Username, Email, Số điện thoại và mật khẩu.
     */
    public long createUser(UserDto dto) {
        if (dto == null) {
            throw new IllegalArgumentException("Thông tin người dùng không được để trống.");
        }
        ValidationUtil.requireText(dto.getFullName(), "Họ và tên");
        if (dto.getFullName().trim().length() > 100) {
            throw new IllegalArgumentException("Họ và tên không được vượt quá 100 ký tự.");
        }
        ValidationUtil.requireText(dto.getUsername(), "Tên đăng nhập");
        if (!ValidationUtil.isValidUsername(dto.getUsername().trim())) {
            throw new IllegalArgumentException("Tên đăng nhập phải có từ 4 đến 30 ký tự, chỉ gồm chữ cái, chữ số và dấu gạch dưới (_).");
        }
        ValidationUtil.requireText(dto.getEmail(), "Email");
        if (!ValidationUtil.isEmail(dto.getEmail().trim())) {
            throw new IllegalArgumentException("Email không đúng định dạng.");
        }
        if (dto.getPhone() != null && !dto.getPhone().trim().isEmpty() && !ValidationUtil.isValidPhone(dto.getPhone().trim())) {
            throw new IllegalArgumentException("Số điện thoại không đúng định dạng (phải có 10 chữ số và bắt đầu bằng số 0, ví dụ: 0901234567).");
        }
        if (dto.getRawPassword() == null || dto.getRawPassword().trim().length() < 6) {
            throw new IllegalArgumentException("Mật khẩu khởi tạo phải có độ dài tối thiểu 6 ký tự.");
        }
        if (dto.getRoleId() == null || dto.getRoleId() <= 0) {
            throw new IllegalArgumentException("Vui lòng chọn vai trò (Role) cho tài khoản.");
        }

        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                if (userDao.existsUsername(con, dto.getUsername().trim(), null)) {
                    throw new IllegalArgumentException("Tên đăng nhập \"" + dto.getUsername().trim() + "\" đã tồn tại trên hệ thống.");
                }
                if (userDao.existsEmail(con, dto.getEmail().trim().toLowerCase(), null)) {
                    throw new IllegalArgumentException("Địa chỉ email \"" + dto.getEmail().trim() + "\" đã được sử dụng.");
                }

                User user = new User();
                user.setUsername(dto.getUsername().trim());
                user.setEmail(dto.getEmail().trim().toLowerCase());
                user.setFullName(dto.getFullName().trim());
                user.setPasswordHash(PasswordUtil.hash(dto.getRawPassword().trim()));
                user.setRoleId(dto.getRoleId());
                user.setRoleType(SettingType.USER_ROLE);
                user.setAuthProvider(AuthProvider.LOCAL);
                user.setStatus(dto.getStatus() != null ? dto.getStatus() : UserStatus.ACTIVE);
                user.setPhone(dto.getPhone() != null ? dto.getPhone().trim() : null);

                long id = userDao.insert(con, user);
                con.commit();
                return id;
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi khởi tạo tài khoản người dùng: " + e.getMessage(), e);
        }
    }

    /**
     * Cập nhật thông tin chi tiết & phân quyền tài khoản (SRS 2.3.2 User Details).
     * BẢO ĐẢM TOÀN VẸN DỮ LIỆU & BẢO VỆ ADMIN:
     * - Admin không được tự khóa hoặc tự hạ vai trò quản trị của chính mình.
     * - Không được hạ vai trò hoặc vô hiệu hóa Quản trị viên (Admin) duy nhất đang hoạt động.
     * - Học viên đã tham gia khóa học không được phép chuyển đổi sang vai trò khác.
     * - Chuyên gia đang phụ trách khóa học không được phép chuyển sang vai trò khác.
     * - Quản lý đang phụ trách khóa học không được phép chuyển sang vai trò khác.
     */
    public void updateUser(UserDto dto, UserDto currentUser) {
        if (dto == null || dto.getId() == null || dto.getId() <= 0) {
            throw new IllegalArgumentException("ID người dùng không hợp lệ.");
        }
        ValidationUtil.requireText(dto.getFullName(), "Họ và tên");
        if (dto.getFullName().trim().length() > 100) {
            throw new IllegalArgumentException("Họ và tên không được vượt quá 100 ký tự.");
        }
        if (dto.getPhone() != null && !dto.getPhone().trim().isEmpty() && !ValidationUtil.isValidPhone(dto.getPhone().trim())) {
            throw new IllegalArgumentException("Số điện thoại không đúng định dạng (phải có 10 chữ số và bắt đầu bằng số 0, ví dụ: 0901234567).");
        }
        if (dto.getRoleId() == null || dto.getRoleId() <= 0) {
            throw new IllegalArgumentException("Vui lòng chọn vai trò cho tài khoản.");
        }

        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Optional<User> existingOpt = userDao.findById(con, dto.getId());
                if (!existingOpt.isPresent()) {
                    throw new IllegalArgumentException("Không tìm thấy người dùng cần cập nhật.");
                }
                User user = existingOpt.get();

                // 1. Ràng buộc Tự thao tác: Admin không được tự khóa hoặc tự hạ quyền
                if (currentUser != null && currentUser.getId().equals(user.getId())) {
                    if (dto.getStatus() != null && dto.getStatus() != UserStatus.ACTIVE) {
                        throw new IllegalArgumentException("Bạn không thể tự khóa hoặc vô hiệu hóa tài khoản quản trị của chính mình.");
                    }
                    if (dto.getRoleId() != null && dto.getRoleId() != 5L) {
                        throw new IllegalArgumentException("Bạn không thể tự hạ vai trò quản trị (Admin) của chính mình.");
                    }
                }

                // 2. Ràng buộc Quản trị viên cuối cùng (Last Active Admin Protection)
                if (user.getRoleId() != null && user.getRoleId() == 5L && user.getStatus() == UserStatus.ACTIVE) {
                    boolean isDemoting = (dto.getRoleId() != null && dto.getRoleId() != 5L);
                    boolean isDeactivating = (dto.getStatus() != null && dto.getStatus() != UserStatus.ACTIVE);
                    if (isDemoting || isDeactivating) {
                        int activeAdmins = userDao.countActiveAdmins(con);
                        if (activeAdmins <= 1) {
                            throw new IllegalArgumentException("Không thể vô hiệu hóa hoặc hạ quyền Quản trị viên này vì đây là Quản trị viên (Admin) duy nhất đang hoạt động trên hệ thống.");
                        }
                    }
                }

                // 3. Ràng buộc tính toàn vẹn khi thay đổi vai trò (Role Transfer Restriction)
                if (user.getRoleId() != null && !user.getRoleId().equals(dto.getRoleId())) {
                    // Nếu là Học viên (Role 2)
                    if (user.getRoleId() == 2L) {
                        int regCount = userDao.countUserRegistrations(con, user.getId());
                        if (regCount > 0) {
                            throw new IllegalArgumentException("Không thể chuyển đổi vai trò: Tài khoản này là Học viên đã đăng ký tham gia " 
                                    + regCount + " khóa học trên hệ thống. Dữ liệu học tập và chứng nhận cần được bảo toàn.");
                        }
                    }
                    // Nếu là Chuyên gia (Role 4)
                    if (user.getRoleId() == 4L) {
                        int expCourses = userDao.countExpertCourses(con, user.getId());
                        if (expCourses > 0) {
                            throw new IllegalArgumentException("Không thể chuyển đổi vai trò: Chuyên gia đang được phân công phụ trách " 
                                    + expCourses + " khóa học. Vui lòng chuyển giao các khóa học này cho Chuyên gia khác trước khi đổi vai trò.");
                        }
                    }
                    // Nếu là Quản lý (Role 3)
                    if (user.getRoleId() == 3L) {
                        int mgrCourses = userDao.countManagerCourses(con, user.getId());
                        if (mgrCourses > 0) {
                            throw new IllegalArgumentException("Không thể chuyển đổi vai trò: Quản lý đang phụ trách " 
                                    + mgrCourses + " khóa học. Vui lòng bàn giao quyền quản lý trước khi đổi vai trò.");
                        }
                    }
                }

                user.setFullName(dto.getFullName().trim());
                user.setRoleId(dto.getRoleId());
                user.setRoleType(SettingType.USER_ROLE);
                if (dto.getStatus() != null) {
                    user.setStatus(dto.getStatus());
                }
                if (dto.getPhone() != null) {
                    user.setPhone(dto.getPhone().trim());
                }

                // Cập nhật mật khẩu nếu Admin nhập mật khẩu mới
                if (dto.getRawPassword() != null && !dto.getRawPassword().trim().isEmpty()) {
                    String newPwd = dto.getRawPassword().trim();
                    if (newPwd.length() < 6) {
                        throw new IllegalArgumentException("Mật khẩu mới phải có tối thiểu 6 ký tự.");
                    }
                    String hashed = PasswordUtil.hash(newPwd);
                    user.setPasswordHash(hashed);
                }

                userDao.update(con, user);
                con.commit();
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi cập nhật người dùng: " + e.getMessage(), e);
        }
    }

    public void updateUser(UserDto dto) {
        updateUser(dto, null);
    }

    /**
     * Xóa tài khoản người dùng an toàn.
     */
    public void deleteUser(long userId, UserDto currentUser) {
        if (currentUser != null && currentUser.getId().equals(userId)) {
            throw new IllegalArgumentException("Bạn không thể tự xóa tài khoản của chính mình.");
        }
        try (Connection con = DbConnection.getConnection()) {
            Optional<User> userOpt = userDao.findById(con, userId);
            if (!userOpt.isPresent()) {
                throw new IllegalArgumentException("Không tìm thấy người dùng ID: " + userId);
            }
            User user = userOpt.get();

            if (user.getRoleId() != null && user.getRoleId() == 5L && user.getStatus() == UserStatus.ACTIVE) {
                int activeAdmins = userDao.countActiveAdmins(con);
                if (activeAdmins <= 1) {
                    throw new IllegalArgumentException("Không thể xóa Quản trị viên này vì đây là Quản trị viên (Admin) duy nhất đang hoạt động trên hệ thống.");
                }
            }

            int regCount = userDao.countUserRegistrations(con, userId);
            if (regCount > 0) {
                throw new IllegalArgumentException("Không thể xóa tài khoản: Học viên đã tham gia " + regCount + " khóa học. Hãy chuyển trạng thái sang Tạm khóa (Suspended) thay vì xóa.");
            }

            int expCourses = userDao.countExpertCourses(con, userId);
            if (expCourses > 0) {
                throw new IllegalArgumentException("Không thể xóa tài khoản: Chuyên gia đang phụ trách " + expCourses + " khóa học trên hệ thống.");
            }

            int mgrCourses = userDao.countManagerCourses(con, userId);
            if (mgrCourses > 0) {
                throw new IllegalArgumentException("Không thể xóa tài khoản: Quản lý đang phụ trách " + mgrCourses + " khóa học trên hệ thống.");
            }

            userDao.delete(con, userId);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi xóa người dùng: " + e.getMessage(), e);
        }
    }

    public void deleteUser(long userId) {
        deleteUser(userId, null);
    }

    /**
     * Đặt lại mật khẩu tài khoản trực tiếp (Reset Password).
     */
    public void resetPassword(long userId, String newPassword) {
        if (newPassword == null || newPassword.trim().length() < 6) {
            throw new IllegalArgumentException("Mật khẩu mới phải có độ dài tối thiểu 6 ký tự.");
        }
        try (Connection con = DbConnection.getConnection()) {
            boolean updated = userDao.updatePassword(con, userId, PasswordUtil.hash(newPassword.trim()));
            if (!updated) {
                throw new IllegalArgumentException("Không tìm thấy tài khoản người dùng ID: " + userId);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi đặt lại mật khẩu: " + e.getMessage(), e);
        }
    }

    /**
     * Thêm mới hoặc cập nhật thông tin người dùng (tương thích backward).
     */
    public long saveUser(UserDto dto) {
        if (dto.getId() != null && dto.getId() > 0) {
            updateUser(dto, null);
            return dto.getId();
        } else {
            return createUser(dto);
        }
    }

    /**
     * Chuyển đổi trạng thái tài khoản trực tiếp (Toggle Status):
     * Nếu ACTIVE -> Khóa/Tạm dừng (BANNED/Suspended)
     * Nếu BANNED/INACTIVE -> Kích hoạt (ACTIVE)
     */
    public UserStatus toggleStatus(long userId, UserDto currentUser) {
        if (currentUser != null && currentUser.getId().equals(userId)) {
            throw new IllegalArgumentException("Bạn không thể tự khóa tài khoản quản trị của chính mình.");
        }
        try (Connection con = DbConnection.getConnection()) {
            User user = userDao.findById(con, userId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng ID: " + userId));

            // Kiểm tra bảo vệ Admin cuối cùng nếu đang chuyển từ ACTIVE sang BANNED
            if (user.getRoleId() != null && user.getRoleId() == 5L && user.getStatus() == UserStatus.ACTIVE) {
                int activeAdmins = userDao.countActiveAdmins(con);
                if (activeAdmins <= 1) {
                    throw new IllegalArgumentException("Không thể khóa Quản trị viên này vì đây là Quản trị viên (Admin) duy nhất đang hoạt động trên hệ thống.");
                }
            }

            UserStatus targetStatus = (user.getStatus() == UserStatus.ACTIVE) ? UserStatus.BANNED : UserStatus.ACTIVE;
            userDao.updateStatus(con, userId, targetStatus);
            return targetStatus;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi chuyển đổi trạng thái người dùng: " + e.getMessage(), e);
        }
    }

    public UserStatus toggleStatus(long userId) {
        return toggleStatus(userId, null);
    }

    /**
     * Khóa hoặc mở khóa trạng thái tài khoản người dùng (ACTIVE / BANNED / INACTIVE).
     */
    public void changeStatus(long userId, UserStatus status, UserDto currentUser) {
        if (status == null) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ.");
        }
        if (currentUser != null && currentUser.getId().equals(userId) && status != UserStatus.ACTIVE) {
            throw new IllegalArgumentException("Bạn không thể tự khóa hoặc vô hiệu hóa tài khoản quản trị của chính mình.");
        }
        try (Connection con = DbConnection.getConnection()) {
            if (status != UserStatus.ACTIVE) {
                User user = userDao.findById(con, userId)
                        .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng ID: " + userId));
                if (user.getRoleId() != null && user.getRoleId() == 5L && user.getStatus() == UserStatus.ACTIVE) {
                    int activeAdmins = userDao.countActiveAdmins(con);
                    if (activeAdmins <= 1) {
                        throw new IllegalArgumentException("Không thể vô hiệu hóa Quản trị viên này vì đây là Quản trị viên duy nhất đang hoạt động.");
                    }
                }
            }

            boolean updated = userDao.updateStatus(con, userId, status);
            if (!updated) {
                throw new IllegalArgumentException("Không thể cập nhật trạng thái người dùng ID: " + userId);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi thay đổi trạng thái người dùng: " + e.getMessage(), e);
        }
    }

    public void changeStatus(long userId, UserStatus status) {
        changeStatus(userId, status, null);
    }

    /**
     * Cập nhật hồ sơ cá nhân của người dùng hiện tại.
     */
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

    private Map<Long, String> loadRoleMap(Connection con) {
        Map<Long, String> roleMap = new HashMap<>();
        try {
            List<Setting> roles = settingDao.findByType(con, SettingType.USER_ROLE);
            for (Setting s : roles) {
                roleMap.put(s.getId(), s.getName());
            }
        } catch (SQLException ignored) {
        }
        return roleMap;
    }

    private UserDto mapUserWithRoleMap(User user, Map<Long, String> roleMap) {
        if (user == null) return null;
        UserDto dto = new UserDto();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFullName(user.getFullName());
        dto.setRoleId(user.getRoleId());
        dto.setAuthProvider(user.getAuthProvider());
        dto.setStatus(user.getStatus());
        dto.setCreatedAt(user.getCreatedAt());
        dto.setAvatarUrl(user.getAvatarUrl());
        dto.setPhone(user.getPhone());
        dto.setBirthDate(user.getBirthDate());

        if (user.getRoleId() != null) {
            dto.setRoleName(roleMap.getOrDefault(user.getRoleId(), "STUDENT"));
        } else {
            dto.setRoleName("STUDENT");
        }
        return dto;
    }
}
