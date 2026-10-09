package dao;

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

public class RegistrationDao {
    private static final String SQL_FIND_BY_ID = "SELECT id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at FROM registrations WHERE id = ?";
    private static final String SQL_FIND_BY_USER = "SELECT id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at FROM registrations WHERE user_id = ? ORDER BY id DESC";
    private static final String SQL_FIND_BY_COURSE = "SELECT id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at FROM registrations WHERE course_id = ? ORDER BY id DESC";
    private static final String SQL_FIND_BY_USER_AND_COURSE = "SELECT id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at FROM registrations WHERE user_id = ? AND course_id = ?";
    private static final String SQL_FIND_BY_PAYMENT_CODE = "SELECT id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at FROM registrations WHERE payment_code = ?";
    private static final String SQL_INSERT = "INSERT INTO registrations (user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING id";
    private static final String SQL_UPDATE_PAYMENT = "UPDATE registrations SET payment_status = ?, payment_code = ?, paid_at = ?, status = ? WHERE id = ?";
    private static final String SQL_UPDATE_PROGRESS = "UPDATE registrations SET progress_percentage = ? WHERE id = ?";
    private static final String SQL_UPDATE_STATUS = "UPDATE registrations SET status = ? WHERE id = ?";

    public Optional<Registration> findById(Connection con, long id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_ID)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        }
        return Optional.empty();
    }

    public List<Registration> findByUserId(Connection con, long userId) throws SQLException {
        List<Registration> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_USER)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public List<Registration> findByCourseId(Connection con, long courseId) throws SQLException {
        List<Registration> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_COURSE)) {
            ps.setLong(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public Optional<Registration> findByUserAndCourse(Connection con, long userId, long courseId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_USER_AND_COURSE)) {
            ps.setLong(1, userId);
            ps.setLong(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        }
        return Optional.empty();
    }

    public Optional<Registration> findByPaymentCode(Connection con, String code) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_PAYMENT_CODE)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        }
        return Optional.empty();
    }

    public long insert(Connection con, Registration entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_INSERT)) {
            ps.setLong(1, entity.getUserId());
            ps.setLong(2, entity.getCourseId());
            OffsetDateTime now = OffsetDateTime.now();
            ps.setObject(3, entity.getRegistrationDate() != null ? entity.getRegistrationDate() : now);
            ps.setBigDecimal(4, entity.getProgressPercentage() != null ? entity.getProgressPercentage() : BigDecimal.ZERO);
            ps.setString(5, entity.getStatus() != null ? entity.getStatus().getDbValue() : RegistrationStatus.PENDING.getDbValue());
            ps.setString(6, entity.getPaymentMethod() != null ? entity.getPaymentMethod().getDbValue() : null);
            ps.setString(7, entity.getPaymentCode());
            ps.setBigDecimal(8, entity.getPaymentAmount() != null ? entity.getPaymentAmount() : BigDecimal.ZERO);
            ps.setString(9, entity.getPaymentStatus() != null ? entity.getPaymentStatus().getDbValue() : PaymentStatus.PENDING.getDbValue());
            ps.setObject(10, entity.getPaidAt());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    long id = rs.getLong(1);
                    entity.setId(id);
                    return id;
                }
            }
        }
        return 0L;
    }

    public boolean updatePayment(Connection con, Registration entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE_PAYMENT)) {
            ps.setString(1, entity.getPaymentStatus() != null ? entity.getPaymentStatus().getDbValue() : null);
            ps.setString(2, entity.getPaymentCode());
            ps.setObject(3, entity.getPaidAt());
            ps.setString(4, entity.getStatus() != null ? entity.getStatus().getDbValue() : null);
            ps.setLong(5, entity.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateProgress(Connection con, long id, BigDecimal percent) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE_PROGRESS)) {
            ps.setBigDecimal(1, percent);
            ps.setLong(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(Connection con, long id, RegistrationStatus status) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE_STATUS)) {
            ps.setString(1, status.getDbValue());
            ps.setLong(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Registration mapRow(ResultSet rs) throws SQLException {
        Registration r = new Registration();
        r.setId(rs.getLong("id"));
        r.setUserId(rs.getLong("user_id"));
        r.setCourseId(rs.getLong("course_id"));
        r.setRegistrationDate(rs.getObject("registration_date", OffsetDateTime.class));
        r.setProgressPercentage(rs.getBigDecimal("progress_percentage"));
        r.setStatus(RegistrationStatus.fromDb(rs.getString("status")));
        String pm = rs.getString("payment_method");
        r.setPaymentMethod(pm != null ? PaymentMethod.fromDb(pm) : null);
        r.setPaymentCode(rs.getString("payment_code"));
        r.setPaymentAmount(rs.getBigDecimal("payment_amount"));
        String ps = rs.getString("payment_status");
        r.setPaymentStatus(ps != null ? PaymentStatus.fromDb(ps) : null);
        r.setPaidAt(rs.getObject("paid_at", OffsetDateTime.class));
        return r;
    }
}
