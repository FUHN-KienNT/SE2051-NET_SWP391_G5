package service;

import dao.CourseDao;
import dao.LessonDao;
import dao.LessonProgressDao;
import dao.ModuleDao;
import dao.QuizDao;
import dao.RegistrationDao;
import dao.SettingDao;
import dao.UserDao;
import dto.CourseDto;
import dto.LessonDto;
import dto.ModuleDto;
import dto.QuizDto;
import entity.Course;
import entity.Lesson;
import entity.LessonProgress;
import entity.Module;
import entity.Quiz;
import entity.Registration;
import entity.User;
import dto.UserDto;
import entity.enums.CourseStatus;
import entity.enums.LessonProgressStatus;
import entity.enums.RegistrationStatus;
import entity.enums.SettingType;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import util.DbConnection;
import util.ValidationUtil;

public class CourseService {
    private final CourseDao courseDao;
    private final ModuleDao moduleDao;
    private final LessonDao lessonDao;
    private final LessonProgressDao lessonProgressDao;
    private final RegistrationDao registrationDao;

    public CourseService(CourseDao courseDao, ModuleDao moduleDao, LessonDao lessonDao,
            LessonProgressDao lessonProgressDao, RegistrationDao registrationDao) {
        this.courseDao = courseDao;
        this.moduleDao = moduleDao;
        this.lessonDao = lessonDao;
        this.lessonProgressDao = lessonProgressDao;
        this.registrationDao = registrationDao;
    }

    public List<CourseDto> searchPublished(String keyword, Long categoryId) {
        try (Connection con = DbConnection.getConnection()) {
            List<Course> list = courseDao.searchPublished(con, keyword, categoryId);
            List<CourseDto> dtos = new ArrayList<>();
            for (Course c : list) {
                dtos.add(buildCourseTree(c));
            }
            return dtos;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi tìm kiếm khóa học: " + e.getMessage(), e);
        }
    }

    public List<CourseDto> searchAdminCourses(String keyword, Long categoryId, Long managerId, String status) {
        try (Connection con = DbConnection.getConnection()) {
            List<Course> list = courseDao.searchAdmin(con, keyword, categoryId, managerId, status);
            List<CourseDto> dtos = new ArrayList<>();
            for (Course c : list) {
                dtos.add(buildCourseTree(c));
            }
            return dtos;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi tìm kiếm khóa học (Admin): " + e.getMessage(), e);
        }
    }

    public CourseDto getCourseDetail(long courseId) {
        try (Connection con = DbConnection.getConnection()) {
            Course course = courseDao.findById(con, courseId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khóa học ID: " + courseId));
            return buildCourseTree(course);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi xem chi tiết khóa học: " + e.getMessage(), e);
        }
    }

    /**
     * [Tối ưu hiệu năng]: Lấy trực tiếp thông tin 1 khóa học theo courseId (chỉ mục ID trong CSDL),
     * phục vụ form sửa thông tin khóa học mà không cần tải toàn bộ cây modules, bài học hay bài kiểm tra.
     */
    public CourseDto getCourseById(long courseId) {
        try (Connection con = DbConnection.getConnection()) {
            Course course = courseDao.findById(con, courseId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khóa học ID: " + courseId));
            CourseDto dto = new CourseDto();
            dto.setId(course.getId());
            dto.setTitle(course.getTitle());
            dto.setCategoryId(course.getCategoryId());
            dto.setDescription(course.getDescription());
            dto.setPrice(course.getPrice());
            dto.setStatus(course.getStatus());
            dto.setManagerId(course.getManagerId());
            dto.setExpertId(course.getExpertId());
            if (course.getCategoryId() != null) {
                SettingDao sDao = new SettingDao();
                sDao.findById(con, course.getCategoryId()).ifPresent(s -> dto.setCategoryName(s.getName()));
            }
            return dto;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi xem thông tin khóa học: " + e.getMessage(), e);
        }
    }

    /**
     * [Tối ưu hiệu năng]: Lấy trực tiếp thông tin 1 bài học theo lessonId (O(1)),
     * không cần tải toàn bộ cây khóa học.
     */
    public LessonDto getLessonById(long lessonId) {
        try (Connection con = DbConnection.getConnection()) {
            Lesson l = lessonDao.findById(con, lessonId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài học ID: " + lessonId));
            return new LessonDto(
                    l.getId(), l.getModuleId(), l.getTitle(), l.getContent(),
                    l.getVideoUrl(), l.getDocumentUrl(), l.getOrderIndex(),
                    LessonProgressStatus.NOT_STARTED);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy thông tin bài học: " + e.getMessage(), e);
        }
    }

    /**
     * [Tối ưu hiệu năng]: Chỉ lấy thông tin khóa học và danh sách Modules nhẹ nhàng
     * để đổ vào dropdown và breadcrumb, bỏ qua việc query nặng nề toàn bộ lessons &
     * quizzes.
     */
    public CourseDto getCourseSummaryWithModules(long courseId) {
        try (Connection con = DbConnection.getConnection()) {
            Course course = courseDao.findById(con, courseId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khóa học ID: " + courseId));
            CourseDto dto = new CourseDto();
            dto.setId(course.getId());
            dto.setTitle(course.getTitle());
            dto.setCategoryId(course.getCategoryId());
            dto.setDescription(course.getDescription());
            dto.setPrice(course.getPrice());
            dto.setStatus(course.getStatus());
            dto.setManagerId(course.getManagerId());
            dto.setExpertId(course.getExpertId());

            List<Module> modules = moduleDao.findByCourseId(con, course.getId());
            for (Module m : modules) {
                ModuleDto mDto = new ModuleDto();
                mDto.setId(m.getId());
                mDto.setCourseId(m.getCourseId());
                mDto.setTitle(m.getTitle());
                mDto.setOrderIndex(m.getOrderIndex());
                dto.getModules().add(mDto);
            }
            return dto;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách chương của khóa học: " + e.getMessage(), e);
        }
    }

    // =========================================================================
    // KIỂM TRA PHÂN QUYỀN CẤP DỮ LIỆU (IDOR DEFENSE)
    // =========================================================================

    public boolean canManageCourse(long courseId, UserDto user) {
        if (user == null) {
            return false;
        }
        String role = user.getRoleName();
        if ("ADMIN".equalsIgnoreCase(role) || "ROLE_ADMIN".equalsIgnoreCase(role)) {
            return true;
        }
        try (Connection con = DbConnection.getConnection()) {
            return courseDao.findById(con, courseId)
                    .map(c -> (c.getExpertId() != null && c.getExpertId().equals(user.getId()))
                            || (c.getManagerId() != null && c.getManagerId().equals(user.getId())))
                    .orElse(false);
        } catch (SQLException e) {
            return false;
        }
    }

    public void checkCourseOwnership(long courseId, UserDto user) {
        if (!canManageCourse(courseId, user)) {
            throw new SecurityException("Từ chối truy cập: Bạn không có quyền quản lý khóa học #" + courseId);
        }
    }

    public void checkModuleOwnership(long moduleId, UserDto user) {
        if (user == null)
            throw new SecurityException("Vui lòng đăng nhập.");
        String role = user.getRoleName();
        if ("ADMIN".equalsIgnoreCase(role) || "ROLE_ADMIN".equalsIgnoreCase(role)) {
            return;
        }
        try (Connection con = DbConnection.getConnection()) {
            Module m = moduleDao.findById(con, moduleId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy chương học ID: " + moduleId));
            checkCourseOwnership(m.getCourseId(), user);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi kiểm tra quyền chương học: " + e.getMessage(), e);
        }
    }

    public void checkLessonOwnership(long lessonId, UserDto user) {
        if (user == null)
            throw new SecurityException("Vui lòng đăng nhập.");
        String role = user.getRoleName();
        if ("ADMIN".equalsIgnoreCase(role) || "ROLE_ADMIN".equalsIgnoreCase(role)) {
            return;
        }
        try (Connection con = DbConnection.getConnection()) {
            Lesson l = lessonDao.findById(con, lessonId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài học ID: " + lessonId));
            checkModuleOwnership(l.getModuleId(), user);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi kiểm tra quyền bài học: " + e.getMessage(), e);
        }
    }

    public List<CourseDto> getManagedCourses(long userId) {
        try (Connection con = DbConnection.getConnection()) {
            List<Course> list = courseDao.findByManagerOrExpert(con, userId);
            List<CourseDto> dtos = new ArrayList<>();
            for (Course c : list) {
                dtos.add(buildCourseTree(c));
            }
            return dtos;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách khóa học quản lý: " + e.getMessage(), e);
        }
    }

    public List<CourseDto> getAllCourses() {
        try (Connection con = DbConnection.getConnection()) {
            List<Course> list = courseDao.findAll(con);
            List<CourseDto> dtos = new ArrayList<>();
            for (Course c : list) {
                dtos.add(buildCourseTree(c));
            }
            return dtos;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy toàn bộ danh sách khóa học: " + e.getMessage(), e);
        }
    }

    public List<UserDto> getExperts() {
        try (Connection con = DbConnection.getConnection()) {
            UserDao uDao = new UserDao();
            List<User> list = uDao.findByRoleId(con, 4L); // Role 4 = EXPERT
            List<UserDto> dtos = new ArrayList<>();
            for (User u : list) {
                UserDto dto = new UserDto();
                dto.setId(u.getId());
                dto.setUsername(u.getUsername());
                dto.setEmail(u.getEmail());
                dto.setFullName(u.getFullName());
                dto.setRoleId(u.getRoleId());
                dto.setRoleName("EXPERT");
                dto.setAuthProvider(u.getAuthProvider());
                dto.setStatus(u.getStatus());
                dtos.add(dto);
            }
            return dtos;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách chuyên gia: " + e.getMessage(), e);
        }
    }

    public long saveCourse(CourseDto dto) {
        validateCourse(dto);
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                long id;
                if (dto.getId() != null && dto.getId() > 0) {
                    Course course = courseDao.findById(con, dto.getId())
                            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khóa học cần sửa."));
                    course.setTitle(dto.getTitle().trim());
                    if (dto.getCategoryId() != null)
                        course.setCategoryId(dto.getCategoryId());
                    course.setDescription(dto.getDescription());
                    course.setPrice(dto.getPrice());
                    course.setStatus(dto.getStatus() != null ? dto.getStatus() : CourseStatus.DRAFT);
                    if (dto.getManagerId() != null)
                        course.setManagerId(dto.getManagerId());
                    if (dto.getExpertId() != null)
                        course.setExpertId(dto.getExpertId());
                    courseDao.update(con, course);
                    id = course.getId();
                } else {
                    Course course = new Course();
                    course.setTitle(dto.getTitle().trim());
                    course.setCategoryId(dto.getCategoryId());
                    course.setCategoryType(SettingType.COURSE_CATEGORY);
                    course.setDescription(dto.getDescription());
                    course.setPrice(dto.getPrice());
                    course.setStatus(dto.getStatus() != null ? dto.getStatus() : CourseStatus.DRAFT);
                    course.setManagerId(dto.getManagerId());
                    course.setExpertId(dto.getExpertId());
                    id = courseDao.insert(con, course);
                }
                con.commit();
                return id;
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lưu khóa học: " + e.getMessage(), e);
        }
    }

    public List<dto.SettingDto> getCategories() {
        try (Connection con = DbConnection.getConnection()) {
            SettingDao sDao = new SettingDao();
            List<entity.Setting> list = sDao.findByType(con, SettingType.COURSE_CATEGORY);
            List<dto.SettingDto> dtos = new ArrayList<>();
            for (entity.Setting s : list) {
                dto.SettingDto dto = new dto.SettingDto();
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
            throw new RuntimeException("Lỗi lấy danh mục khóa học: " + e.getMessage(), e);
        }
    }

    public Long getOrCreateCategory(String name) {
        if (name == null || name.trim().isEmpty()) {
            return 6L;
        }
        String trimmedName = name.trim();
        try (Connection con = DbConnection.getConnection()) {
            SettingDao sDao = new SettingDao();
            List<entity.Setting> list = sDao.findByType(con, SettingType.COURSE_CATEGORY);
            for (entity.Setting s : list) {
                if (s.getName().equalsIgnoreCase(trimmedName)) {
                    return s.getId();
                }
            }
            entity.Setting s = new entity.Setting();
            s.setType(SettingType.COURSE_CATEGORY);
            s.setName(trimmedName);
            String val = java.text.Normalizer.normalize(trimmedName, java.text.Normalizer.Form.NFD)
                    .replaceAll("\\p{M}", "")
                    .toUpperCase()
                    .replaceAll("[^A-Z0-9]+", "_")
                    .replaceAll("^_+|_+$", "");
            if (val.isEmpty()) {
                val = "CAT_" + System.currentTimeMillis();
            }
            s.setValue(val);
            s.setPriority(list.size() + 1);
            s.setStatus(entity.enums.SettingStatus.ACTIVE);
            s.setDescription("Danh mục tạo tự động khi tạo khóa học");
            return sDao.insert(con, s);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi tạo danh mục mới: " + e.getMessage(), e);
        }
    }

    public void updateCourseStatus(long courseId, CourseStatus status) {
        try (Connection con = DbConnection.getConnection()) {
            Course course = courseDao.findById(con, courseId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khóa học."));
            course.setStatus(status);
            courseDao.update(con, course);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi cập nhật trạng thái khóa học: " + e.getMessage(), e);
        }
    }

    public void deleteCourse(long courseId) {
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                // Xóa đăng ký học phụ thuộc nếu có
                try (java.sql.PreparedStatement ps = con.prepareStatement("DELETE FROM registrations WHERE course_id = ?")) {
                    ps.setLong(1, courseId);
                    ps.executeUpdate();
                }
                boolean deleted = courseDao.delete(con, courseId);
                if (!deleted) {
                    throw new IllegalArgumentException("Không tìm thấy khóa học cần xóa.");
                }
                con.commit();
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi xóa khóa học: " + e.getMessage(), e);
        }
    }

    public long saveModule(ModuleDto dto) {
        if (dto == null) {
            throw new IllegalArgumentException("Dữ liệu chương học không hợp lệ.");
        }
        ValidationUtil.requireText(dto.getTitle(), "Tiêu đề chương");
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                long id;
                if (dto.getId() != null && dto.getId() > 0) {
                    Module m = moduleDao.findById(con, dto.getId())
                            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy chương cần sửa."));
                    m.setTitle(dto.getTitle().trim());
                    if (dto.getOrderIndex() > 0 && !moduleDao.existsOrderIndex(con, m.getCourseId(), dto.getOrderIndex(), m.getId())) {
                        m.setOrderIndex(dto.getOrderIndex());
                    }
                    moduleDao.update(con, m);
                    id = m.getId();
                } else {
                    if (dto.getCourseId() == null) {
                        throw new IllegalArgumentException("Khóa học không hợp lệ.");
                    }
                    Module m = new Module();
                    m.setCourseId(dto.getCourseId());
                    m.setTitle(dto.getTitle().trim());
                    int order = dto.getOrderIndex();
                    if (order <= 0 || moduleDao.existsOrderIndex(con, dto.getCourseId(), order, null)) {
                        List<Module> currentModules = moduleDao.findByCourseId(con, dto.getCourseId());
                        order = currentModules.stream().mapToInt(Module::getOrderIndex).max().orElse(0) + 1;
                    }
                    m.setOrderIndex(order);
                    id = moduleDao.insert(con, m);
                }
                con.commit();
                return id;
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lưu chương học: " + e.getMessage(), e);
        }
    }

    public void deleteModule(long moduleId) {
        try (Connection con = DbConnection.getConnection()) {
            boolean deleted = moduleDao.delete(con, moduleId);
            if (!deleted) {
                throw new IllegalArgumentException("Không tìm thấy chương cần xóa.");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi xóa chương học: " + e.getMessage(), e);
        }
    }

    public long getOrCreateDefaultModuleId(long courseId) {
        try (Connection con = DbConnection.getConnection()) {
            List<Module> existing = moduleDao.findByCourseId(con, courseId);
            for (Module m : existing) {
                if ("Danh sách bài học".equalsIgnoreCase(m.getTitle()) || "Bài học chung".equalsIgnoreCase(m.getTitle())) {
                    return m.getId();
                }
            }
            if (existing.isEmpty()) {
                Module m = new Module();
                m.setCourseId(courseId);
                m.setTitle("Danh sách bài học");
                m.setOrderIndex(1);
                return moduleDao.insert(con, m);
            }
            // Nếu đã có các chương riêng biệt, tạo một mục "Bài học chung"
            Module m = new Module();
            m.setCourseId(courseId);
            m.setTitle("Bài học chung");
            m.setOrderIndex(existing.size() + 1);
            return moduleDao.insert(con, m);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi tìm hoặc tạo chương học mặc định: " + e.getMessage(), e);
        }
    }

    public long saveLesson(LessonDto dto) {
        if (dto == null) {
            throw new IllegalArgumentException("Dữ liệu bài học không hợp lệ.");
        }
        if (dto.getModuleId() == null || dto.getModuleId() <= 0) {
            if (dto.getCourseId() != null && dto.getCourseId() > 0) {
                dto.setModuleId(getOrCreateDefaultModuleId(dto.getCourseId()));
            } else {
                throw new IllegalArgumentException("Vui lòng chọn khóa học hoặc chương học hợp lệ.");
            }
        }
        ValidationUtil.requireText(dto.getTitle(), "Tiêu đề bài học");
        ValidationUtil.requireMaxLength(dto.getTitle(), 255, "Tiêu đề bài học");

        int order = dto.getOrderIndex() > 0 ? dto.getOrderIndex() : 1;
        dto.setOrderIndex(order);

        if (dto.getVideoUrl() != null && !dto.getVideoUrl().trim().isEmpty()) {
            String vUrl = dto.getVideoUrl().trim();
            ValidationUtil.requireMaxLength(vUrl, 500, "URL Video");
            if (!ValidationUtil.isValidVideoUrl(vUrl)) {
                throw new IllegalArgumentException(
                        "Định dạng URL Video không hợp lệ (hỗ trợ liên kết YouTube, Google Drive, Vimeo hoặc file MP4).");
            }
            dto.setVideoUrl(vUrl);
        } else {
            dto.setVideoUrl(null);
        }

        if (dto.getDocumentUrl() != null && !dto.getDocumentUrl().trim().isEmpty()) {
            String dUrl = dto.getDocumentUrl().trim();
            ValidationUtil.requireMaxLength(dUrl, 500, "URL Tài liệu");
            if (!ValidationUtil.isValidHttpUrl(dUrl)) {
                throw new IllegalArgumentException("URL Tài liệu đính kèm phải bắt đầu bằng http:// hoặc https://");
            }
            dto.setDocumentUrl(dUrl);
        } else {
            dto.setDocumentUrl(null);
        }

        if (dto.getContent() != null) {
            ValidationUtil.requireMaxLength(dto.getContent(), 65535, "Nội dung bài học");
        }

        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                // Kiểm tra chương học có tồn tại trong hệ thống hay không
                moduleDao.findById(con, dto.getModuleId())
                        .orElseThrow(() -> new IllegalArgumentException(
                                "Chương học ID " + dto.getModuleId() + " không tồn tại."));

                long id;
                if (dto.getId() != null && dto.getId() > 0) {
                    Lesson l = lessonDao.findById(con, dto.getId())
                            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài học cần sửa."));
                    l.setModuleId(dto.getModuleId());
                    l.setTitle(dto.getTitle().trim());
                    l.setContent(dto.getContent() != null ? dto.getContent() : "");
                    l.setVideoUrl(dto.getVideoUrl());
                    l.setDocumentUrl(dto.getDocumentUrl());
                    l.setOrderIndex(dto.getOrderIndex());
                    lessonDao.update(con, l);
                    id = l.getId();
                } else {
                    Lesson l = new Lesson();
                    l.setModuleId(dto.getModuleId());
                    l.setTitle(dto.getTitle().trim());
                    l.setContent(dto.getContent() != null ? dto.getContent() : "");
                    l.setVideoUrl(dto.getVideoUrl());
                    l.setDocumentUrl(dto.getDocumentUrl());
                    l.setOrderIndex(dto.getOrderIndex());
                    id = lessonDao.insert(con, l);
                }
                con.commit();
                return id;
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lưu bài học: " + e.getMessage(), e);
        }
    }

    public void deleteLesson(long lessonId) {
        try (Connection con = DbConnection.getConnection()) {
            boolean deleted = lessonDao.delete(con, lessonId);
            if (!deleted) {
                throw new IllegalArgumentException("Không tìm thấy bài học cần xóa.");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi xóa bài học: " + e.getMessage(), e);
        }
    }

    public int saveBatchLessons(long courseId, Long moduleId, List<LessonDto> lessons) {
        return saveBatchLessons(courseId, moduleId, null, lessons);
    }

    public int saveBatchLessons(long courseId, Long moduleId, String newModuleTitle, List<LessonDto> lessons) {
        if (lessons == null || lessons.isEmpty()) {
            return 0;
        }
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                long targetModuleId;
                if (moduleId != null && moduleId > 0) {
                    targetModuleId = moduleId;
                } else {
                    List<Module> existingModules = moduleDao.findByCourseId(con, courseId);
                    if (newModuleTitle != null && !newModuleTitle.trim().isEmpty()) {
                        Module newModule = new Module();
                        newModule.setCourseId(courseId);
                        newModule.setTitle(newModuleTitle.trim());
                        newModule.setOrderIndex(existingModules.size() + 1);
                        targetModuleId = moduleDao.insert(con, newModule);
                    } else if (!existingModules.isEmpty()) {
                        // Thêm tiếp vào module hiện có
                        targetModuleId = existingModules.get(existingModules.size() - 1).getId();
                    } else {
                        // Tự động tạo container bài học chung nếu khóa học chưa có chương nào
                        Module defaultModule = new Module();
                        defaultModule.setCourseId(courseId);
                        defaultModule.setTitle("Danh sách bài học");
                        defaultModule.setOrderIndex(1);
                        targetModuleId = moduleDao.insert(con, defaultModule);
                    }
                }

                List<Lesson> currentLessons = lessonDao.findByModuleId(con, targetModuleId);
                int startOrder = currentLessons.size() + 1;

                int count = 0;
                for (LessonDto dto : lessons) {
                    Lesson l = new Lesson();
                    l.setModuleId(targetModuleId);
                    l.setTitle(dto.getTitle() != null && !dto.getTitle().trim().isEmpty() ? dto.getTitle().trim()
                            : ("Bài " + (startOrder + count) + ": Bài giảng"));
                    l.setContent(dto.getContent() != null ? dto.getContent() : "");
                    l.setVideoUrl(dto.getVideoUrl());
                    l.setDocumentUrl(dto.getDocumentUrl());
                    l.setOrderIndex(startOrder + count);
                    lessonDao.insert(con, l);
                    count++;
                }

                con.commit();
                return count;
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lưu danh sách bài học hàng loạt: " + e.getMessage(), e);
        }
    }

    // =========================================================================
    // [TÍNH NĂNG]: CÀO YOUTUBE PLAYLIST & NHẬP BÀI HỌC HÀNG LOẠT (BATCH IMPORT)
    // Tag tìm kiếm: #YOUTUBE_PLAYLIST_IMPORT #BATCH_LESSON_PARSER
    // =========================================================================

    /**
     * Bóc tách danh sách bài học từ chuỗi văn bản (hỗ trợ cả nhiều link YouTube đơn lẻ lẫn YouTube Playlist):
     * - Tự động phát hiện tham số danh sách phát (Playlist) dạng 'list=PL...' hoặc 'playlist?list=PL...' hoặc mã ID 'PL...'.
     * - Nếu là Playlist: Tự động gửi request HTTP ngầm lên YouTube để cào toàn bộ video và tiêu đề gốc.
     * - Nếu là Video đơn lẻ: Bóc tách Video ID và lọc tiêu đề tiếng Việt tương ứng trên mỗi dòng.
     * - Cơ chế chống trùng lặp: 'seenVideoIds' loại bỏ các video bị trùng nếu người dùng dán nhiều lần.
     */
    public static List<LessonDto> parseBatchVideoText(String text) {
        List<LessonDto> list = new ArrayList<>();
        if (text == null || text.trim().isEmpty()) {
            return list;
        }

        String[] lines = text.split("\\r?\\n");
        int seq = 1;
        java.util.regex.Pattern playlistPattern = java.util.regex.Pattern.compile(
                "(?:[?&]list=|playlist\\?list=)([a-zA-Z0-9_-]+)|(^PL[a-zA-Z0-9_-]{16,})");
        java.util.regex.Pattern ytIdPattern = java.util.regex.Pattern.compile(
                "(?:youtu\\.be\\/|v\\/|u\\/\\w\\/|embed\\/|watch\\?v=|\\&v=)([a-zA-Z0-9_-]{11})|^([a-zA-Z0-9_-]{11})$");

        java.util.Set<String> processedPlaylistIds = new java.util.HashSet<>();
        java.util.Set<String> seenVideoIds = new java.util.HashSet<>();

        for (String line : lines) {
            line = line.trim();
            if (line.isEmpty())
                continue;

            // 1. Kiểm tra xem dòng có chứa Playlist ID hay không
            String playlistId = null;
            java.util.regex.Matcher plMatcher = playlistPattern.matcher(line);
            if (plMatcher.find()) {
                playlistId = plMatcher.group(1) != null ? plMatcher.group(1) : plMatcher.group(2);
            }

            if (playlistId != null && !processedPlaylistIds.contains(playlistId)) {
                processedPlaylistIds.add(playlistId);
                List<LessonDto> playlistVideos = fetchYoutubePlaylistVideos(playlistId);
                if (playlistVideos != null && !playlistVideos.isEmpty()) {
                    for (LessonDto plDto : playlistVideos) {
                        String vidId = extractVideoIdFromUrl(plDto.getVideoUrl());
                        if (vidId != null && seenVideoIds.add(vidId)) {
                            plDto.setOrderIndex(seq++);
                            list.add(plDto);
                        }
                    }
                    continue; // Đã xử lý trọn vẹn toàn bộ Playlist
                }
            }

            // 2. Nếu không phải Playlist (hoặc tải Playlist thất bại), bóc tách video đơn lẻ
            String videoId = null;
            String[] tokens = line.split("\\s+");
            for (String token : tokens) {
                java.util.regex.Matcher m = ytIdPattern.matcher(token);
                if (m.find()) {
                    videoId = m.group(1) != null ? m.group(1) : m.group(2);
                    break;
                }
            }

            if (videoId != null && seenVideoIds.add(videoId)) {
                String cleanLine = line.replaceAll("https?://[^\\s]+", "")
                        .replaceAll("^[0-9]+[\\.\\:\\-]\\s*", "")
                        .replaceAll("^[\\-\\–\\—\\|\\:\\.]+\\s*", "")
                        .replaceAll("\\s*[\\-\\–\\—\\|\\:]+$", "")
                        .trim();
                String title;
                if (!cleanLine.isEmpty() && cleanLine.length() > 2) {
                    title = cleanLine;
                } else {
                    title = "Bài " + seq + ": Video bài giảng";
                }

                LessonDto dto = new LessonDto();
                dto.setTitle(title);
                dto.setVideoUrl("https://www.youtube.com/embed/" + videoId);
                dto.setOrderIndex(seq++);
                list.add(dto);
            }
        }
        return list;
    }

    /**
     * Tự động kết nối YouTube và cào toàn bộ danh sách video (ID + Tiêu đề) từ Playlist công khai.
     */
    public static List<LessonDto> fetchYoutubePlaylistVideos(String playlistId) {
        List<LessonDto> list = new ArrayList<>();
        if (playlistId == null || playlistId.trim().isEmpty()) {
            return list;
        }
        playlistId = playlistId.trim();

        try {
            java.net.http.HttpClient client = java.net.http.HttpClient.newBuilder()
                    .connectTimeout(java.time.Duration.ofSeconds(10))
                    .followRedirects(java.net.http.HttpClient.Redirect.ALWAYS)
                    .build();

            String url = "https://www.youtube.com/playlist?list=" + playlistId;
            java.net.http.HttpRequest request = java.net.http.HttpRequest.newBuilder()
                    .uri(java.net.URI.create(url))
                    .timeout(java.time.Duration.ofSeconds(15))
                    .header("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36")
                    .header("Accept-Language", "vi,en-US;q=0.9,en;q=0.8")
                    .build();

            java.net.http.HttpResponse<String> response = client.send(request, java.net.http.HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() != 200) {
                return list;
            }

            String html = response.body();
            java.util.Set<String> seenIds = new java.util.HashSet<>();
            int seq = 1;

            // Pattern 1: Modern lockupViewModel with title content
            java.util.regex.Pattern p1 = java.util.regex.Pattern.compile(
                    "\"videoId\":\"([a-zA-Z0-9_-]{11})\".{1,1500}?\"title\":\\{\"content\":\"([^\"]+)\"\\}",
                    java.util.regex.Pattern.DOTALL);
            java.util.regex.Matcher m1 = p1.matcher(html);
            while (m1.find()) {
                String vid = m1.group(1);
                String rawTitle = unescapeUnicode(m1.group(2));
                if (seenIds.add(vid)) {
                    LessonDto dto = new LessonDto();
                    dto.setTitle(rawTitle);
                    dto.setVideoUrl("https://www.youtube.com/embed/" + vid);
                    dto.setOrderIndex(seq++);
                    list.add(dto);
                }
            }

            // Pattern 2: Legacy runs/text title
            if (list.isEmpty()) {
                java.util.regex.Pattern p2 = java.util.regex.Pattern.compile(
                        "\"videoId\":\"([a-zA-Z0-9_-]{11})\".{1,1500}?\"title\":\\{\"runs\":\\[\\{\"text\":\"([^\"]+)\"\\}",
                        java.util.regex.Pattern.DOTALL);
                java.util.regex.Matcher m2 = p2.matcher(html);
                while (m2.find()) {
                    String vid = m2.group(1);
                    String rawTitle = unescapeUnicode(m2.group(2));
                    if (seenIds.add(vid)) {
                        LessonDto dto = new LessonDto();
                        dto.setTitle(rawTitle);
                        dto.setVideoUrl("https://www.youtube.com/embed/" + vid);
                        dto.setOrderIndex(seq++);
                        list.add(dto);
                    }
                }
            }

            // Pattern 3: Fallback any videoId
            if (list.isEmpty()) {
                java.util.regex.Pattern p3 = java.util.regex.Pattern.compile(
                        "\"videoId\":\"([a-zA-Z0-9_-]{11})\"",
                        java.util.regex.Pattern.DOTALL);
                java.util.regex.Matcher m3 = p3.matcher(html);
                while (m3.find()) {
                    String vid = m3.group(1);
                    if (seenIds.add(vid)) {
                        LessonDto dto = new LessonDto();
                        dto.setTitle("Bài " + seq + ": Video bài giảng");
                        dto.setVideoUrl("https://www.youtube.com/embed/" + vid);
                        dto.setOrderIndex(seq++);
                        list.add(dto);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi tải YouTube playlist " + playlistId + ": " + e.getMessage());
        }
        return list;
    }

    private static String extractVideoIdFromUrl(String url) {
        if (url == null) return null;
        if (url.contains("/embed/")) {
            return url.substring(url.lastIndexOf("/embed/") + 7);
        }
        java.util.regex.Pattern ytIdPattern = java.util.regex.Pattern.compile(
                "(?:youtu\\.be\\/|v\\/|u\\/\\w\\/|embed\\/|watch\\?v=|\\&v=)([a-zA-Z0-9_-]{11})|^([a-zA-Z0-9_-]{11})$");
        java.util.regex.Matcher m = ytIdPattern.matcher(url);
        if (m.find()) {
            return m.group(1) != null ? m.group(1) : m.group(2);
        }
        return null;
    }

    private static String unescapeUnicode(String input) {
        if (input == null) return "";
        java.util.regex.Pattern p = java.util.regex.Pattern.compile("\\\\u([0-9a-fA-F]{4})");
        java.util.regex.Matcher m = p.matcher(input);
        StringBuilder sb = new StringBuilder();
        while (m.find()) {
            char ch = (char) Integer.parseInt(m.group(1), 16);
            m.appendReplacement(sb, java.util.regex.Matcher.quoteReplacement(Character.toString(ch)));
        }
        m.appendTail(sb);
        return sb.toString().replace("\\\"", "\"").replace("\\\\", "\\").trim();
    }

    public CourseDto getLearningContent(long registrationId, long userId) {
        try (Connection con = DbConnection.getConnection()) {
            Registration reg = registrationDao.findById(con, registrationId)
                    .orElseThrow(
                            () -> new IllegalArgumentException("Không tìm thấy đơn đăng ký ID: " + registrationId));
            if (!Long.valueOf(userId).equals(reg.getUserId())) {
                throw new SecurityException("Bạn không có quyền truy cập khóa học này.");
            }
            if (reg.getStatus() != RegistrationStatus.ACTIVE && reg.getStatus() != RegistrationStatus.COMPLETED) {
                throw new IllegalStateException("Đơn đăng ký chưa được kích hoạt hoặc đã bị hủy.");
            }
            Course course = courseDao.findById(con, reg.getCourseId())
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khóa học tương ứng."));

            CourseDto courseDto = buildCourseTree(course);

            // Populate progress for each lesson
            List<LessonProgress> progresses = lessonProgressDao.findByRegistrationId(con, registrationId);
            for (ModuleDto m : courseDto.getModules()) {
                for (LessonDto l : m.getLessons()) {
                    l.setProgressStatus(LessonProgressStatus.NOT_STARTED);
                    for (LessonProgress lp : progresses) {
                        if (lp.getLessonId().equals(l.getId())) {
                            l.setProgressStatus(lp.getStatus());
                            break;
                        }
                    }
                }
            }
            return courseDto;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi tải nội dung học tập: " + e.getMessage(), e);
        }
    }

    public void updateLessonProgress(long registrationId, long userId, long lessonId, LessonProgressStatus status) {
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Registration registration = registrationDao.findById(con, registrationId)
                        .orElseThrow(
                                () -> new IllegalArgumentException("Không tìm thấy đơn đăng ký ID: " + registrationId));
                if (!Long.valueOf(userId).equals(registration.getUserId())) {
                    throw new SecurityException("Bạn không có quyền cập nhật tiến độ của đơn đăng ký này.");
                }
                if (registration.getStatus() != RegistrationStatus.ACTIVE
                        && registration.getStatus() != RegistrationStatus.COMPLETED) {
                    throw new IllegalStateException("Đơn đăng ký chưa được kích hoạt hoặc đã bị hủy.");
                }
                Lesson lesson = lessonDao.findById(con, lessonId)
                        .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài học ID: " + lessonId));
                Module module = moduleDao.findById(con, lesson.getModuleId())
                        .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy chương học của bài học."));
                if (!registration.getCourseId().equals(module.getCourseId())) {
                    throw new SecurityException("Bài học không thuộc khóa học đã đăng ký.");
                }
                LessonProgress lp = new LessonProgress();
                lp.setRegistrationId(registrationId);
                lp.setLessonId(lessonId);
                lp.setStatus(status);
                if (status == LessonProgressStatus.COMPLETED) {
                    lp.setCompletedAt(OffsetDateTime.now());
                }
                lessonProgressDao.upsert(con, lp);

                refreshRegistrationProgress(registrationId);
                con.commit();
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi cập nhật tiến trình bài học: " + e.getMessage(), e);
        }
    }

    private void validateCourse(CourseDto dto) {
        if (dto == null) {
            throw new IllegalArgumentException("Dữ liệu khóa học trống.");
        }
        ValidationUtil.requireText(dto.getTitle(), "Tên khóa học");
        ValidationUtil.requirePositive(dto.getPrice(), "Học phí");
    }

    private CourseDto buildCourseTree(Course course) {
        if (course == null)
            return null;
        CourseDto dto = new CourseDto();
        dto.setId(course.getId());
        dto.setTitle(course.getTitle());
        dto.setCategoryId(course.getCategoryId());
        dto.setDescription(course.getDescription());
        dto.setPrice(course.getPrice());
        dto.setStatus(course.getStatus());
        dto.setManagerId(course.getManagerId());
        dto.setExpertId(course.getExpertId());

        try (Connection con = DbConnection.getConnection()) {
            if (course.getCategoryId() != null) {
                SettingDao sDao = new SettingDao();
                sDao.findById(con, course.getCategoryId()).ifPresent(s -> dto.setCategoryName(s.getName()));
            }
            UserDao uDao = new UserDao();
            if (course.getManagerId() != null) {
                uDao.findById(con, course.getManagerId()).ifPresent(u -> dto.setManagerName(u.getFullName()));
            }
            if (course.getExpertId() != null) {
                uDao.findById(con, course.getExpertId()).ifPresent(u -> dto.setExpertName(u.getFullName()));
            }

            // Build modules & lessons
            List<Module> modules = moduleDao.findByCourseId(con, course.getId());
            QuizDao quizDao = new QuizDao();
            for (Module m : modules) {
                ModuleDto mDto = new ModuleDto();
                mDto.setId(m.getId());
                mDto.setCourseId(m.getCourseId());
                mDto.setTitle(m.getTitle());
                mDto.setOrderIndex(m.getOrderIndex());

                List<Lesson> lessons = lessonDao.findByModuleId(con, m.getId());
                for (Lesson l : lessons) {
                    LessonDto lDto = new LessonDto(
                            l.getId(), l.getModuleId(), l.getTitle(), l.getContent(),
                            l.getVideoUrl(), l.getDocumentUrl(), l.getOrderIndex(), LessonProgressStatus.NOT_STARTED);
                    mDto.getLessons().add(lDto);
                }

                List<Quiz> quizzes = quizDao.findByModuleId(con, m.getId());
                for (Quiz q : quizzes) {
                    QuizDto qDto = new QuizDto(
                            q.getId(), q.getModuleId(), q.getTitle(), q.getPassScore(),
                            q.getTimeLimitMinutes(), q.getOrderIndex(), new ArrayList<>());
                    mDto.getQuizzes().add(qDto);
                }

                dto.getModules().add(mDto);
            }
        } catch (SQLException ignored) {
        }
        return dto;
    }

    private void refreshRegistrationProgress(long registrationId) {
        try (Connection con = DbConnection.getConnection()) {
            BigDecimal percent = lessonProgressDao.calculateProgress(con, registrationId);
            registrationDao.updateProgress(con, registrationId, percent);
            if (percent.compareTo(BigDecimal.valueOf(100.0)) >= 0) {
                registrationDao.updateStatus(con, registrationId, RegistrationStatus.COMPLETED);
            }
        } catch (SQLException ignored) {
        }
    }
}
