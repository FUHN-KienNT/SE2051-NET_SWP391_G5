package dto;

import entity.enums.AuthProvider;
import entity.enums.UserStatus;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;

public class UserDto {
    private Long id;
    private String username;
    private String email;
    private String fullName;
    private Long roleId;
    private String roleName;
    private AuthProvider authProvider;
    private UserStatus status;
    private String avatarUrl;
    private String phone;
    private LocalDate birthDate;
    private String bio;
    private OffsetDateTime createdAt;
    private String rawPassword;
    private int enrolledCoursesCount;
    private int assignedCoursesCount;

    public UserDto() {
    }

    public UserDto(Long id, String username, String email, String fullName, Long roleId,
                   String roleName, AuthProvider authProvider, UserStatus status) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.fullName = fullName;
        this.roleId = roleId;
        this.roleName = roleName;
        this.authProvider = authProvider;
        this.status = status;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        if (fullName != null && (fullName.contains("Nguy\u00E1") || fullName.contains("Nguyá") || fullName.contains("VÄ") || fullName.contains("Tráº") || fullName.contains("Thá»"))) {
            return fullName.replace("Nguyá»\u0085n", "Nguy\u1EC5n")
                           .replace("Nguyá»...n", "Nguy\u1EC5n")
                           .replace("Nguyá»n", "Nguy\u1EC5n")
                           .replace("VÄƒn", "V\u0103n")
                           .replace("Tráº§n", "Tr\u1EA7n")
                           .replace("Thá»‹", "Th\u1ECB");
        }
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Long getRoleId() {
        return roleId;
    }

    public void setRoleId(Long roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public AuthProvider getAuthProvider() {
        return authProvider;
    }

    public void setAuthProvider(AuthProvider authProvider) {
        this.authProvider = authProvider;
    }

    public UserStatus getStatus() {
        return status;
    }

    public void setStatus(UserStatus status) {
        this.status = status;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getRawPassword() {
        return rawPassword;
    }

    public void setRawPassword(String rawPassword) {
        this.rawPassword = rawPassword;
    }

    public int getEnrolledCoursesCount() {
        return enrolledCoursesCount;
    }

    public void setEnrolledCoursesCount(int enrolledCoursesCount) {
        this.enrolledCoursesCount = enrolledCoursesCount;
    }

    public int getAssignedCoursesCount() {
        return assignedCoursesCount;
    }

    public void setAssignedCoursesCount(int assignedCoursesCount) {
        this.assignedCoursesCount = assignedCoursesCount;
    }

    public boolean isRoleLocked() {
        if (roleId == null) return false;
        if (roleId == 2L && enrolledCoursesCount > 0) return true;
        if (roleId == 4L && assignedCoursesCount > 0) return true;
        if (roleId == 3L && assignedCoursesCount > 0) return true;
        return false;
    }

    public String getRoleLockReason() {
        if (roleId == null) return "";
        if (roleId == 2L && enrolledCoursesCount > 0) {
            return "Học viên đã tham gia " + enrolledCoursesCount + " khóa học trên hệ thống. Vai trò bị khóa để bảo toàn dữ liệu học tập.";
        }
        if (roleId == 4L && assignedCoursesCount > 0) {
            return "Chuyên gia đang được phân công phụ trách " + assignedCoursesCount + " khóa học. Vui lòng chuyển giao các khóa học này trước khi đổi vai trò.";
        }
        if (roleId == 3L && assignedCoursesCount > 0) {
            return "Quản lý đang phụ trách " + assignedCoursesCount + " khóa học trên hệ thống. Vui lòng bàn giao quyền quản lý trước khi đổi vai trò.";
        }
        return "";
    }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "N/A";
        return createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public String getStatusDisplay() {
        if (status == null) return "Unknown";
        switch (status) {
            case ACTIVE: return "Active";
            case INACTIVE: return "Inactive";
            case BANNED: return "Suspended";
            default: return status.name();
        }
    }
}
