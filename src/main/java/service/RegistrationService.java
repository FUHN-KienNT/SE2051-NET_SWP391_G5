package service;

import dao.CourseDao;
import dao.LessonProgressDao;
import dao.RegistrationDao;
import dto.RegistrationDto;
import entity.Course;
import entity.Registration;
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
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Optional<Course> courseOpt = courseDao.findById(con, courseId);
                if (!courseOpt.isPresent()) {
                    throw new IllegalArgumentException("Không tìm thấy khóa học ID: " + courseId);
                }
                Course course = courseOpt.get();

                Optional<Registration> existingOpt = registrationDao.findByUserAndCourse(con, userId, courseId);
                if (existingOpt.isPresent()) {
                    Registration reg = existingOpt.get();
                    if (reg.getStatus() == RegistrationStatus.ACTIVE || reg.getStatus() == RegistrationStatus.COMPLETED) {
                        return mapRegistration(reg);
                    }
                    if (reg.getStatus() == RegistrationStatus.PENDING) {
                        return mapRegistration(reg);
                    }
                }

                Registration reg = initializePayment(course);
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
        try (Connection con = DbConnection.getConnection()) {
            List<Registration> list = registrationDao.findByUserId(con, userId);
            List<RegistrationDto> dtoList = new ArrayList<>();
            for (Registration r : list) {
                dtoList.add(mapRegistration(r));
            }
            return dtoList;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách đăng ký của học viên: " + e.getMessage(), e);
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
                if (code != null) reg.setPaymentCode(code);
                if (paidAt != null) reg.setPaidAt(paidAt);

                if (status == PaymentStatus.SUCCESS || status == PaymentStatus.FREE) {
                    reg.setStatus(RegistrationStatus.ACTIVE);
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
        try (Connection con = DbConnection.getConnection()) {
            Optional<Registration> regOpt = registrationDao.findByUserAndCourse(con, userId, courseId);
            return regOpt.isPresent() && (regOpt.get().getStatus() == RegistrationStatus.ACTIVE || regOpt.get().getStatus() == RegistrationStatus.COMPLETED);
        } catch (SQLException e) {
            return false;
        }
    }

    private Registration initializePayment(Course course) {
        Registration reg = new Registration();
        reg.setRegistrationDate(OffsetDateTime.now());
        reg.setProgressPercentage(BigDecimal.ZERO);
        reg.setPaymentAmount(course.getPrice() != null ? course.getPrice() : BigDecimal.ZERO);

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
        if (entity == null) return null;
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
                    if (rs.next()) dto.setUserName(rs.getString("full_name"));
                }
            }
            try (PreparedStatement ps = con.prepareStatement("SELECT title FROM courses WHERE id = ?")) {
                ps.setLong(1, entity.getCourseId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) dto.setCourseTitle(rs.getString("title"));
                }
            }
        } catch (SQLException ignored) {
        }
        return dto;
    }
}
