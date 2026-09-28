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
import java.util.Optional;
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

    public CourseDto getCourseDetail(long courseId) {
        try (Connection con = DbConnection.getConnection()) {
            Course course = courseDao.findById(con, courseId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khóa học ID: " + courseId));
            return buildCourseTree(course);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi xem chi tiết khóa học: " + e.getMessage(), e);
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
                    if (dto.getCategoryId() != null) course.setCategoryId(dto.getCategoryId());
                    course.setDescription(dto.getDescription());
                    course.setPrice(dto.getPrice());
                    course.setStatus(dto.getStatus() != null ? dto.getStatus() : CourseStatus.DRAFT);
                    if (dto.getManagerId() != null) course.setManagerId(dto.getManagerId());
                    if (dto.getExpertId() != null) course.setExpertId(dto.getExpertId());
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

    public void deleteCourse(long courseId) {
        try (Connection con = DbConnection.getConnection()) {
            boolean deleted = courseDao.delete(con, courseId);
            if (!deleted) {
                throw new IllegalArgumentException("Không tìm thấy khóa học cần xóa.");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi xóa khóa học: " + e.getMessage(), e);
        }
    }

    public long saveModule(ModuleDto dto) {
        if (dto == null || dto.getCourseId() == null) {
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
                    m.setOrderIndex(dto.getOrderIndex());
                    moduleDao.update(con, m);
                    id = m.getId();
                } else {
                    Module m = new Module();
                    m.setCourseId(dto.getCourseId());
                    m.setTitle(dto.getTitle().trim());
                    m.setOrderIndex(dto.getOrderIndex());
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

    public long saveLesson(LessonDto dto) {
        if (dto == null || dto.getModuleId() == null) {
            throw new IllegalArgumentException("Dữ liệu bài học không hợp lệ.");
        }
        ValidationUtil.requireText(dto.getTitle(), "Tiêu đề bài học");
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                long id;
                if (dto.getId() != null && dto.getId() > 0) {
                    Lesson l = lessonDao.findById(con, dto.getId())
                            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài học cần sửa."));
                    l.setTitle(dto.getTitle().trim());
                    l.setContent(dto.getContent());
                    l.setVideoUrl(dto.getVideoUrl());
                    l.setDocumentUrl(dto.getDocumentUrl());
                    l.setOrderIndex(dto.getOrderIndex());
                    lessonDao.update(con, l);
                    id = l.getId();
                } else {
                    Lesson l = new Lesson();
                    l.setModuleId(dto.getModuleId());
                    l.setTitle(dto.getTitle().trim());
                    l.setContent(dto.getContent());
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

    public CourseDto getLearningContent(long registrationId) {
        try (Connection con = DbConnection.getConnection()) {
            Registration reg = registrationDao.findById(con, registrationId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đơn đăng ký ID: " + registrationId));
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

    public void updateLessonProgress(long registrationId, long lessonId, LessonProgressStatus status) {
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
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
        if (course == null) return null;
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
                            l.getVideoUrl(), l.getDocumentUrl(), l.getOrderIndex(), LessonProgressStatus.NOT_STARTED
                    );
                    mDto.getLessons().add(lDto);
                }

                List<Quiz> quizzes = quizDao.findByModuleId(con, m.getId());
                for (Quiz q : quizzes) {
                    QuizDto qDto = new QuizDto(
                            q.getId(), q.getModuleId(), q.getTitle(), q.getPassScore(),
                            q.getTimeLimitMinutes(), q.getOrderIndex(), new ArrayList<>()
                    );
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
