package service;

import dao.CourseDao;
import dao.LessonProgressDao;
import dao.RegistrationDao;
import dto.CourseDto;
import dto.RecentLearningDto;
import dto.StudentAiRecommendationDto;
import java.util.HashSet;
import java.util.Set;
import util.GeminiAiUtil;
import dto.RegistrationDto;
import dto.UserDto;
import entity.Course;
import entity.Registration;
import entity.enums.CourseStatus;
import entity.enums.PaymentMethod;
import entity.enums.PaymentStatus;
import entity.enums.RegistrationStatus;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import util.DbConnection;

public class RegistrationService {
    private final RegistrationDao registrationDao;
    private final CourseDao courseDao;

    public RegistrationService(RegistrationDao registrationDao, CourseDao courseDao) {
        this.registrationDao = registrationDao;
        this.courseDao = courseDao;
    }

    public RegistrationDto enroll(long userId, long courseId) {
        return enroll(userId, courseId, null);
    }

    public RegistrationDto enroll(long userId, long courseId, BigDecimal customAmount) {
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Optional<Course> courseOpt = courseDao.findById(con, courseId);
                if (!courseOpt.isPresent()) {
                    throw new IllegalArgumentException("Không tìm thấy khóa học ID: " + courseId);
                }
                Course course = courseOpt.get();

                // Nếu học viên đã có đơn đăng ký từ trước (đã mua / đang học), ưu tiên trả về quyền truy cập
                Optional<Registration> existingOpt = registrationDao.findByUserAndCourse(con, userId, courseId);
                if (existingOpt.isPresent()) {
                    Registration reg = existingOpt.get();
                    if (reg.getStatus() == RegistrationStatus.ACTIVE
                            || reg.getStatus() == RegistrationStatus.COMPLETED) {
                        return mapRegistration(reg);
                    }
                    if (reg.getStatus() == RegistrationStatus.PENDING) {
                        if (customAmount != null && customAmount.compareTo(BigDecimal.ZERO) >= 0) {
                            reg.setPaymentAmount(customAmount);
                            registrationDao.updatePayment(con, reg);
                            con.commit();
                        }
                        return mapRegistration(reg);
                    }
                }

                // Với người dùng chưa đăng ký: Không cho phép đăng ký mới khóa học đang ở trạng thái Nháp hoặc Chờ duyệt
                if (course.getStatus() == CourseStatus.DRAFT) {
                    throw new IllegalStateException(
                            "Khóa học này đang ở trạng thái Nháp (chưa được xuất bản). Bạn không thể đăng ký.");
                }
                if (course.getStatus() == CourseStatus.PENDING_REVIEW) {
                    throw new IllegalStateException("Khóa học này đang chờ phê duyệt. Bạn không thể đăng ký.");
                }

                if (existingOpt.isPresent()) {
                    Registration reg = existingOpt.get();
                    if (reg.getStatus() == RegistrationStatus.ACTIVE
                            || reg.getStatus() == RegistrationStatus.COMPLETED) {
                        return mapRegistration(reg);
                    }
                    if (reg.getStatus() == RegistrationStatus.PENDING) {
                        return mapRegistration(reg);
                    }
                    // Truong hop truoc do don bi huy / that bai: Kich hoat lai don hang moi
                    Registration fresh = initializePayment(course, customAmount);
                    reg.setStatus(fresh.getStatus());
                    reg.setPaymentStatus(fresh.getPaymentStatus());
                    reg.setPaymentMethod(fresh.getPaymentMethod());
                    reg.setPaymentCode(fresh.getPaymentCode());
                    reg.setPaymentAmount(fresh.getPaymentAmount());
                    reg.setRegistrationDate(OffsetDateTime.now());
                    reg.setPaidAt(fresh.getPaidAt());
                    registrationDao.updatePayment(con, reg);
                    con.commit();
                    return mapRegistration(reg);
                }

                // Nếu chưa có đơn đăng ký, kiểm tra xem khóa học đã lưu trữ (ngừng tuyển sinh)
                // hay chưa
                boolean isArchived = course.getStatus() == CourseStatus.ARCHIVED
                        || (course.getArchiveAt() != null && !course.getArchiveAt().isAfter(OffsetDateTime.now()));
                if (isArchived) {
                    throw new IllegalStateException(
                            "Khóa học này đã được chuyển sang chế độ Lưu trữ (ngừng nhận học viên mới). Bạn không thể đăng ký mới.");
                }

                Registration reg = initializePayment(course, customAmount);
                reg.setUserId(userId);
                reg.setCourseId(courseId);
                long id = registrationDao.insert(con, reg);
                reg.setId(id);
                con.commit();
                return mapRegistration(reg);
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi đăng ký khóa học: " + e.getMessage(), e);
        }
    }

    public List<RegistrationDto> getByUser(long userId) {
        return getEnrichedByUser(userId);
    }

    public List<RegistrationDto> getEnrichedByUser(long userId) {
        String sql = "SELECT "
                + "  r.id AS reg_id, r.user_id, u.full_name AS user_name, r.course_id, "
                + "  c.title AS course_title, c.category_id, s.name AS category_name, exp.full_name AS expert_name, "
                + "  r.registration_date, r.progress_percentage, r.status AS reg_status, "
                + "  r.payment_method, r.payment_code, r.payment_amount, r.payment_status, r.paid_at, "
                + "  c.status AS course_status, c.archive_at, c.archive_notice, "
                + "  (SELECT COUNT(1) FROM lessons l JOIN modules m ON l.module_id = m.id WHERE m.course_id = c.id AND l.is_active = true) AS total_lessons, "
                + "  (SELECT COUNT(1) FROM lesson_progress lp WHERE lp.registration_id = r.id AND lp.status = 'COMPLETED') AS completed_lessons, "
                + "  last_lp.lesson_id AS last_lesson_id, last_l.title AS last_lesson_title, last_lp.updated_at AS last_studied_at "
                + "FROM registrations r "
                + "JOIN users u ON r.user_id = u.id "
                + "JOIN courses c ON r.course_id = c.id "
                + "LEFT JOIN settings s ON c.category_id = s.id "
                + "LEFT JOIN users exp ON c.expert_id = exp.id "
                + "LEFT JOIN LATERAL ( "
                + "  SELECT lp.lesson_id, COALESCE(lp.updated_at, lp.completed_at) AS updated_at "
                + "  FROM lesson_progress lp "
                + "  WHERE lp.registration_id = r.id "
                + "  ORDER BY COALESCE(lp.updated_at, lp.completed_at) DESC NULLS LAST "
                + "  LIMIT 1 "
                + ") last_lp ON true "
                + "LEFT JOIN lessons last_l ON last_lp.lesson_id = last_l.id "
                + "WHERE r.user_id = ? "
                + "ORDER BY r.id DESC";

        try (Connection con = DbConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<RegistrationDto> list = new ArrayList<>();
                while (rs.next()) {
                    RegistrationDto dto = new RegistrationDto();
                    dto.setId(rs.getLong("reg_id"));
                    dto.setUserId(rs.getLong("user_id"));
                    dto.setUserName(rs.getString("user_name"));
                    dto.setCourseId(rs.getLong("course_id"));
                    dto.setCourseTitle(rs.getString("course_title"));

                    long catId = rs.getLong("category_id");
                    if (!rs.wasNull())
                        dto.setCategoryId(catId);
                    dto.setCategoryName(rs.getString("category_name"));
                    dto.setExpertName(rs.getString("expert_name"));

                    dto.setRegistrationDate(rs.getObject("registration_date", OffsetDateTime.class));
                    dto.setProgressPercentage(rs.getBigDecimal("progress_percentage"));
                    dto.setStatus(RegistrationStatus.fromDb(rs.getString("reg_status")));
                    dto.setPaymentMethod(PaymentMethod.fromDb(rs.getString("payment_method")));
                    dto.setPaymentCode(rs.getString("payment_code"));
                    dto.setPaymentAmount(rs.getBigDecimal("payment_amount"));
                    dto.setPaymentStatus(PaymentStatus.fromDb(rs.getString("payment_status")));
                    dto.setPaidAt(rs.getObject("paid_at", OffsetDateTime.class));

                    CourseStatus cStatus = CourseStatus.fromDb(rs.getString("course_status"));
                    dto.setCourseStatus(cStatus);
                    OffsetDateTime archiveAt = rs.getObject("archive_at", OffsetDateTime.class);
                    boolean isArchived = cStatus == CourseStatus.ARCHIVED
                            || (archiveAt != null && !archiveAt.isAfter(OffsetDateTime.now()));
                    dto.setArchived(isArchived);
                    dto.setArchiveNotice(rs.getString("archive_notice"));

                    int total = rs.getInt("total_lessons");
                    int completed = rs.getInt("completed_lessons");
                    dto.setTotalLessons(total);
                    dto.setCompletedLessons(completed);

                    // Recalculate dynamic progress if lesson count changed
                                        // #m_tiendo [TRẠM 3/4 - CÔNG THỨC % TIẾN ĐỘ]: (completed_lessons / total_lessons) * 100, làm tròn 1 chữ số thập phân
if (total > 0 && completed > 0) {
                        dto.setProgressPercentage(BigDecimal.valueOf(completed * 100.0 / total).setScale(1,
                                java.math.RoundingMode.HALF_UP));
                    }

                    long lastLid = rs.getLong("last_lesson_id");
                    if (!rs.wasNull())
                        dto.setLastLessonId(lastLid);
                    dto.setLastLessonTitle(rs.getString("last_lesson_title"));
                    dto.setLastStudiedAt(rs.getObject("last_studied_at", OffsetDateTime.class));

                    list.add(dto);
                }
                return list;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách đăng ký của học viên: " + e.getMessage(), e);
        }
    }

        // #m_tiendo [TRẠM 2/4 - TRUY VẤN BÀI GẦN NHẤT]: SQL JOIN 4 bảng lesson_progress, registrations, courses, lessons -> ORDER BY last_studied_at DESC LIMIT 1
public RecentLearningDto getRecentLearning(long userId) {
        String sqlRecent = "SELECT "
                + "  r.id AS reg_id, r.course_id, c.title AS course_title, s.name AS category_name, "
                + "  l.id AS lesson_id, l.title AS lesson_title, l.video_url, lp.status AS lp_status, "
                + "  r.progress_percentage, "
                + "  (SELECT COUNT(1) FROM lessons l2 JOIN modules m2 ON l2.module_id = m2.id WHERE m2.course_id = c.id AND l2.is_active = true) AS total_lessons, "
                + "  (SELECT COUNT(1) FROM lesson_progress lp2 WHERE lp2.registration_id = r.id AND lp2.status = 'COMPLETED') AS completed_lessons, "
                + "  COALESCE(lp.updated_at, lp.completed_at) AS last_studied_at "
                + "FROM lesson_progress lp "
                + "JOIN registrations r ON lp.registration_id = r.id "
                + "JOIN courses c ON r.course_id = c.id "
                + "LEFT JOIN settings s ON c.category_id = s.id "
                + "JOIN lessons l ON lp.lesson_id = l.id "
                + "WHERE r.user_id = ? AND r.status IN ('ACTIVE', 'COMPLETED') "
                + "ORDER BY COALESCE(lp.updated_at, lp.completed_at) DESC NULLS LAST "
                + "LIMIT 1";

        try (Connection con = DbConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(sqlRecent)) {
                ps.setLong(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        long regId = rs.getLong("reg_id");
                        long courseId = rs.getLong("course_id");
                        String courseTitle = rs.getString("course_title");
                        String catName = rs.getString("category_name");
                        long lessonId = rs.getLong("lesson_id");
                        String lessonTitle = rs.getString("lesson_title");
                        String videoUrl = rs.getString("video_url");
                        String lpStatus = rs.getString("lp_status");
                        BigDecimal progress = rs.getBigDecimal("progress_percentage");
                        int totalLessons = rs.getInt("total_lessons");
                        int completedLessons = rs.getInt("completed_lessons");
                        OffsetDateTime lastStudiedAt = rs.getObject("last_studied_at", OffsetDateTime.class);

                        if ("COMPLETED".equalsIgnoreCase(lpStatus)) {
                            String sqlNext = "SELECT l.id, l.title, l.video_url "
                                    + "FROM lessons l "
                                    + "JOIN modules m ON l.module_id = m.id "
                                    + "LEFT JOIN lesson_progress lp ON lp.lesson_id = l.id AND lp.registration_id = ? "
                                    + "WHERE m.course_id = ? AND l.is_active = true AND (lp.status IS NULL OR lp.status != 'COMPLETED') "
                                    + "ORDER BY m.order_index ASC, l.order_index ASC "
                                    + "LIMIT 1";
                            try (PreparedStatement psNext = con.prepareStatement(sqlNext)) {
                                psNext.setLong(1, regId);
                                psNext.setLong(2, courseId);
                                try (ResultSet rsNext = psNext.executeQuery()) {
                                    if (rsNext.next()) {
                                        lessonId = rsNext.getLong("id");
                                        lessonTitle = rsNext.getString("title");
                                        videoUrl = rsNext.getString("video_url");
                                    }
                                }
                            }
                        }

                        if (totalLessons > 0 && completedLessons > 0) {
                            progress = BigDecimal.valueOf(completedLessons * 100.0 / totalLessons)
                                    .setScale(1, java.math.RoundingMode.HALF_UP);
                        }

                        return new RecentLearningDto(regId, courseId, courseTitle, catName,
                                lessonId, lessonTitle, videoUrl, progress, completedLessons, totalLessons,
                                lastStudiedAt);
                    }
                }
            }

            // Fallback: If no lesson_progress recorded yet, pick the first lesson of the
            // latest active registration
            String sqlFallback = "SELECT "
                    + "  r.id AS reg_id, r.course_id, c.title AS course_title, s.name AS category_name, "
                    + "  l.id AS lesson_id, l.title AS lesson_title, l.video_url, "
                    + "  r.progress_percentage, "
                    + "  (SELECT COUNT(1) FROM lessons l2 JOIN modules m2 ON l2.module_id = m2.id WHERE m2.course_id = c.id AND l2.is_active = true) AS total_lessons, "
                    + "  (SELECT COUNT(1) FROM lesson_progress lp2 WHERE lp2.registration_id = r.id AND lp2.status = 'COMPLETED') AS completed_lessons, "
                    + "  r.registration_date AS last_studied_at "
                    + "FROM registrations r "
                    + "JOIN courses c ON r.course_id = c.id "
                    + "LEFT JOIN settings s ON c.category_id = s.id "
                    + "LEFT JOIN LATERAL ( "
                    + "  SELECT l3.id, l3.title, l3.video_url "
                    + "  FROM lessons l3 "
                    + "  JOIN modules m3 ON l3.module_id = m3.id "
                    + "  WHERE m3.course_id = c.id "
                    + "  ORDER BY m3.order_index ASC, l3.order_index ASC "
                    + "  LIMIT 1 "
                    + ") l ON true "
                    + "WHERE r.user_id = ? AND r.status IN ('ACTIVE', 'COMPLETED') "
                    + "ORDER BY r.id DESC "
                    + "LIMIT 1";

            try (PreparedStatement psFb = con.prepareStatement(sqlFallback)) {
                psFb.setLong(1, userId);
                try (ResultSet rsFb = psFb.executeQuery()) {
                    if (rsFb.next()) {
                        long regId = rsFb.getLong("reg_id");
                        long courseId = rsFb.getLong("course_id");
                        String courseTitle = rsFb.getString("course_title");
                        String catName = rsFb.getString("category_name");
                        long lessonId = rsFb.getLong("lesson_id");
                        String lessonTitle = rsFb.getString("lesson_title");
                        String videoUrl = rsFb.getString("video_url");
                        BigDecimal progress = rsFb.getBigDecimal("progress_percentage");
                        int totalLessons = rsFb.getInt("total_lessons");
                        int completedLessons = rsFb.getInt("completed_lessons");
                        OffsetDateTime lastStudiedAt = rsFb.getObject("last_studied_at", OffsetDateTime.class);

                        return new RecentLearningDto(regId, courseId, courseTitle, catName,
                                lessonId, lessonTitle, videoUrl, progress, completedLessons, totalLessons,
                                lastStudiedAt);
                    }
                }
            }

            return null;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy bài học gần nhất: " + e.getMessage(), e);
        }
    }

    /**
     * Gợi ý khóa học thông minh cho học sinh dựa trên lịch sử học tập bằng Google Gemini AI (kèm Fallback Heuristic):
     * - Tìm các khóa học đã xuất bản (PUBLISHED) trên hệ thống mà học viên chưa đăng ký.
     * - Nếu có cấu hình Gemini API: gửi lịch sử khóa học và danh mục để AI phân tích lộ trình và gợi ý.
     * - Nếu Gemini không phản hồi hoặc chưa cấu hình API Key: ưu tiên gợi ý các khóa học cùng danh mục hoặc khóa học nổi bật (Featured).
     */
    public StudentAiRecommendationDto getStudentAiRecommendations(long userId, List<RegistrationDto> myRegistrations) {
        try (Connection con = DbConnection.getConnection()) {
            Set<Long> registeredCourseIds = new HashSet<>();
            List<String> enrolledTitles = new ArrayList<>();
            List<String> enrolledCategories = new ArrayList<>();

            if (myRegistrations != null) {
                for (RegistrationDto r : myRegistrations) {
                    registeredCourseIds.add(r.getCourseId());
                    if (r.getCourseTitle() != null && !r.getCourseTitle().trim().isEmpty()) {
                        enrolledTitles.add(r.getCourseTitle().trim());
                    }
                    if (r.getCategoryName() != null && !r.getCategoryName().trim().isEmpty()) {
                        if (!enrolledCategories.contains(r.getCategoryName().trim())) {
                            enrolledCategories.add(r.getCategoryName().trim());
                        }
                    }
                }
            }

            List<CourseDto> publishedCourses = courseDao.searchPublishedSummaries(con, null, null, 25, 0);
            List<CourseDto> candidates = new ArrayList<>();
            for (CourseDto cItem : publishedCourses) {
                if (!registeredCourseIds.contains(cItem.getId())) {
                    candidates.add(cItem);
                }
            }

            if (candidates.isEmpty()) {
                return new StudentAiRecommendationDto(Collections.emptyList(), null, false);
            }

            // 1. Thử gọi Google Gemini AI nếu khả dụng
            if (GeminiAiUtil.isAvailable()) {
                GeminiAiUtil.StudentRecommendationResult aiResult =
                        GeminiAiUtil.recommendCoursesForStudent(enrolledTitles, enrolledCategories, candidates);
                if (aiResult != null && !aiResult.getRecommendedCourseIds().isEmpty()) {
                    List<CourseDto> recommended = new ArrayList<>();
                    for (Long recId : aiResult.getRecommendedCourseIds()) {
                        for (CourseDto cItem : candidates) {
                            if (cItem.getId() == recId.longValue() && !recommended.contains(cItem)) {
                                recommended.add(cItem);
                                break;
                            }
                        }
                    }
                    if (!recommended.isEmpty()) {
                        String advice = (aiResult.getAdvice() != null && !aiResult.getAdvice().trim().isEmpty())
                                ? aiResult.getAdvice().trim()
                                : "Dựa trên sở thích học tập của bạn, Courson AI gợi ý các khóa học này giúp bạn phát triển năng lực toàn diện.";
                        return new StudentAiRecommendationDto(recommended, advice, true);
                    }
                }
            }

            // 2. Fallback Heuristic nếu Gemini chưa cấu hình hoặc không khả dụng
            List<CourseDto> fallbackList = new ArrayList<>();
            if (!enrolledCategories.isEmpty()) {
                for (CourseDto cItem : candidates) {
                    if (cItem.getCategoryName() != null && enrolledCategories.contains(cItem.getCategoryName().trim())) {
                        if (!fallbackList.contains(cItem)) {
                            fallbackList.add(cItem);
                        }
                    }
                    if (fallbackList.size() >= 3) break;
                }
            }
            if (fallbackList.size() < 3) {
                for (CourseDto cItem : candidates) {
                    if (!fallbackList.contains(cItem)) {
                        fallbackList.add(cItem);
                    }
                    if (fallbackList.size() >= 3) break;
                }
            }

            String fallbackAdvice = !enrolledTitles.isEmpty()
                    ? "Dựa trên các chủ đề bạn đang theo học, Courson gợi ý những khóa học phù hợp nhất giúp bạn mở rộng kiến thức và hoàn thiện kỹ năng."
                    : "Chào mừng bạn đến với Courson! Dưới đây là những khóa học tiêu biểu được đánh giá cao nhất dành cho người mới bắt đầu.";

            return new StudentAiRecommendationDto(fallbackList, fallbackAdvice, false);
        } catch (SQLException e) {
            return new StudentAiRecommendationDto(Collections.emptyList(), null, false);
        }
    }

    public List<RegistrationDto> getByCourse(long courseId) {
        try (Connection con = DbConnection.getConnection()) {
            List<Registration> list = registrationDao.findByCourseId(con, courseId);
            List<RegistrationDto> dtoList = new ArrayList<>();
            for (Registration r : list) {
                dtoList.add(mapRegistration(r));
            }
            return dtoList;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách học viên khóa học: " + e.getMessage(), e);
        }
    }

    public RegistrationDto getById(long registrationId) {
        try (Connection con = DbConnection.getConnection()) {
            return registrationDao.findById(con, registrationId).map(this::mapRegistration).orElse(null);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy chi tiết đăng ký: " + e.getMessage(), e);
        }
    }

    public CourseDto getCourseSummary(long courseId) {
        try (Connection con = DbConnection.getConnection()) {
            return courseDao.findById(con, courseId).map(this::mapCourse).orElse(null);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy thông tin khóa học: " + e.getMessage(), e);
        }
    }

    public boolean canViewCourseRegistrations(long courseId, UserDto user) {
        if (user == null || user.getRoleName() == null) {
            return false;
        }
        return "ADMIN".equalsIgnoreCase(user.getRoleName()) || "MANAGER".equalsIgnoreCase(user.getRoleName());
    }

    public boolean canViewRegistration(RegistrationDto registration, UserDto user) {
        if (registration == null || user == null || user.getRoleName() == null) {
            return false;
        }
        return Long.valueOf(user.getId()).equals(registration.getUserId())
                || "ADMIN".equalsIgnoreCase(user.getRoleName())
                || "MANAGER".equalsIgnoreCase(user.getRoleName());
    }

    public List<RegistrationDto> getByManager(long managerId) {
        try (Connection con = DbConnection.getConnection()) {
            List<Registration> list = registrationDao.findByManagerId(con, managerId);
            List<RegistrationDto> dtoList = new ArrayList<>();
            for (Registration r : list) {
                dtoList.add(mapRegistration(r));
            }
            return dtoList;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách đăng ký cho quản lý: " + e.getMessage(), e);
        }
    }

    public List<RegistrationDto> getAll() {
        try (Connection con = DbConnection.getConnection()) {
            List<Registration> list = registrationDao.findAll(con);
            List<RegistrationDto> dtoList = new ArrayList<>();
            for (Registration r : list) {
                dtoList.add(mapRegistration(r));
            }
            return dtoList;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách toàn bộ đăng ký: " + e.getMessage(), e);
        }
    }

    public List<CourseDto> getCoursesForManager(UserDto user) {
        if (user == null || user.getRoleName() == null) {
            return Collections.emptyList();
        }
        try (Connection con = DbConnection.getConnection()) {
            List<Course> courses = courseDao.searchAdmin(con, null, null, null, null);
            List<CourseDto> list = new ArrayList<>();
            for (Course c : courses) {
                CourseDto dto = new CourseDto();
                dto.setId(c.getId());
                dto.setTitle(c.getTitle());
                list.add(dto);
            }
            return list;
        } catch (SQLException e) {
            return Collections.emptyList();
        }
    }

    public int countByManagerId(long managerId) {
        try (Connection con = DbConnection.getConnection()) {
            return registrationDao.countByManagerId(con, managerId);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi đếm số lượng đăng ký cho quản lý: " + e.getMessage(), e);
        }
    }

    public BigDecimal sumRevenueByManagerId(long managerId) {
        try (Connection con = DbConnection.getConnection()) {
            return registrationDao.sumRevenueByManagerId(con, managerId);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi tính doanh thu cho quản lý: " + e.getMessage(), e);
        }
    }

    /**
     * Tính tổng doanh thu hệ thống cho Admin Dashboard.
     * 1. Gọi registrationDao.sumTotalRevenue(con) để truy vấn bảng 'registrations'.
     */
    public BigDecimal sumTotalRevenue() {
        try (Connection con = DbConnection.getConnection()) {
            return registrationDao.sumTotalRevenue(con);
        } catch (SQLException e) {
            return BigDecimal.ZERO;
        }
    }

    /**
     * Đếm tổng số đơn đăng ký đã thanh toán thành công cho Admin Dashboard.
     * 1. Gọi registrationDao.countTotalPaidRegistrations(con) để truy vấn bảng 'registrations'.
     */
    public int countTotalPaidRegistrations() {
        try (Connection con = DbConnection.getConnection()) {
            return registrationDao.countTotalPaidRegistrations(con);
        } catch (SQLException e) {
            return 0;
        }
    }

    /**
     * Đếm tổng số đơn đăng ký cho Admin Dashboard.
     * 1. Gọi registrationDao.countTotalRegistrations(con) để truy vấn bảng 'registrations'.
     */
    public int countTotalRegistrations() {
        try (Connection con = DbConnection.getConnection()) {
            return registrationDao.countTotalRegistrations(con);
        } catch (SQLException e) {
            return 0;
        }
    }

    public void updatePayment(long id, PaymentStatus status, String code, OffsetDateTime paidAt) {
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Optional<Registration> regOpt = registrationDao.findById(con, id);
                if (!regOpt.isPresent()) {
                    throw new IllegalArgumentException("Không tìm thấy đơn đăng ký ID: " + id);
                }
                Registration reg = regOpt.get();
                validatePaymentTransition(reg.getPaymentStatus(), status);

                reg.setPaymentStatus(status);
                if (code != null)
                    reg.setPaymentCode(code);
                if (paidAt != null)
                    reg.setPaidAt(paidAt);
                if (status == PaymentStatus.SUCCESS || status == PaymentStatus.FREE) {
                    reg.setStatus(RegistrationStatus.ACTIVE);
                    if (reg.getPaidAt() == null) {
                        reg.setPaidAt(paidAt != null ? paidAt : OffsetDateTime.now());
                    }
                    if (reg.getPaymentCode() == null || reg.getPaymentCode().trim().isEmpty()) {
                        reg.setPaymentCode(code != null ? code : ("PAY-" + System.currentTimeMillis()));
                    }
                } else if (status == PaymentStatus.FAILED) {
                    reg.setStatus(RegistrationStatus.CANCELLED);
                }


                registrationDao.updatePayment(con, reg);
                con.commit();
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi cập nhật thanh toán: " + e.getMessage(), e);
        }
    }

    public void cancel(long id, long userId) {
        try (Connection con = DbConnection.getConnection()) {
            Registration registration = registrationDao.findById(con, id)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đơn đăng ký ID: " + id));
            if (!Long.valueOf(userId).equals(registration.getUserId())) {
                throw new SecurityException("Bạn không có quyền hủy đơn đăng ký này.");
            }
            registrationDao.updateStatus(con, id, RegistrationStatus.CANCELLED);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi hủy đăng ký: " + e.getMessage(), e);
        }
    }

    public void refreshProgress(long id) {
        try (Connection con = DbConnection.getConnection()) {
            LessonProgressDao progressDao = new LessonProgressDao();
            BigDecimal percent = progressDao.calculateProgress(con, id);
            registrationDao.updateProgress(con, id, percent);
            if (percent.compareTo(BigDecimal.valueOf(100.0)) >= 0) {
                registrationDao.updateStatus(con, id, RegistrationStatus.COMPLETED);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi cập nhật tiến độ học tập: " + e.getMessage(), e);
        }
    }

    public boolean hasCourseAccess(long userId, long courseId) {
        return findActiveRegistrationId(userId, courseId) != null;
    }

    public Long findActiveRegistrationId(long userId, long courseId) {
        try (Connection con = DbConnection.getConnection()) {
            Optional<Registration> regOpt = registrationDao.findByUserAndCourse(con, userId, courseId);
            if (regOpt.isPresent()) {
                Registration reg = regOpt.get();
                if (reg.getStatus() == RegistrationStatus.ACTIVE
                        || reg.getStatus() == RegistrationStatus.COMPLETED) {
                    return reg.getId();
                }
            }
            return null;
        } catch (SQLException e) {
            return null;
        }
    }

    private Registration initializePayment(Course course) {
        return initializePayment(course, null);
    }

    private Registration initializePayment(Course course, BigDecimal customAmount) {
        Registration reg = new Registration();
        reg.setRegistrationDate(OffsetDateTime.now());
        reg.setProgressPercentage(BigDecimal.ZERO);
        BigDecimal amount = customAmount != null ? customAmount : (course.getPrice() != null ? course.getPrice() : BigDecimal.ZERO);
        if (amount.compareTo(BigDecimal.ZERO) < 0) {
            amount = BigDecimal.ZERO;
        }
        reg.setPaymentAmount(amount);

        if (reg.getPaymentAmount().compareTo(BigDecimal.ZERO) <= 0) {
            reg.setStatus(RegistrationStatus.ACTIVE);
            reg.setPaymentStatus(PaymentStatus.FREE);
            reg.setPaymentCode("FREE-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            reg.setPaidAt(OffsetDateTime.now());
        } else {
            reg.setStatus(RegistrationStatus.PENDING);
            reg.setPaymentStatus(PaymentStatus.PENDING);
            reg.setPaymentMethod(PaymentMethod.VNPAY);
            reg.setPaymentCode("PAY-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }
        return reg;
    }

    private void validatePaymentTransition(PaymentStatus current, PaymentStatus next) {
        if (current == PaymentStatus.SUCCESS && next != PaymentStatus.SUCCESS) {
            throw new IllegalStateException("Đơn hàng đã thanh toán thành công, không thể chuyển đổi trạng thái.");
        }
    }

    private RegistrationDto mapRegistration(Registration entity) {
        if (entity == null)
            return null;
        RegistrationDto dto = new RegistrationDto();
        dto.setId(entity.getId());
        dto.setUserId(entity.getUserId());
        dto.setCourseId(entity.getCourseId());
        dto.setRegistrationDate(entity.getRegistrationDate());
        dto.setProgressPercentage(entity.getProgressPercentage());
        dto.setStatus(entity.getStatus());
        dto.setPaymentMethod(entity.getPaymentMethod());
        dto.setPaymentCode(entity.getPaymentCode());
        dto.setPaymentAmount(entity.getPaymentAmount());
        dto.setPaymentStatus(entity.getPaymentStatus());
        dto.setPaidAt(entity.getPaidAt());

        try (Connection con = DbConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement("SELECT full_name FROM users WHERE id = ?")) {
                ps.setLong(1, entity.getUserId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next())
                        dto.setUserName(rs.getString("full_name"));
                }
            }
            try (PreparedStatement ps = con.prepareStatement("SELECT title FROM courses WHERE id = ?")) {
                ps.setLong(1, entity.getCourseId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next())
                        dto.setCourseTitle(rs.getString("title"));
                }
            }
        } catch (SQLException ignored) {
        }
        return dto;
    }

    private CourseDto mapCourse(Course course) {
        CourseDto dto = new CourseDto();
        dto.setId(course.getId());
        dto.setTitle(course.getTitle());
        dto.setPrice(course.getPrice());
        dto.setStatus(course.getStatus());
        return dto;
    }
}
