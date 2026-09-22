package entity;

import entity.enums.PaymentMethod;
import entity.enums.PaymentStatus;
import entity.enums.RegistrationStatus;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

public class Registration {
    private Long id;
    private Long userId;
    private Long courseId;
    private OffsetDateTime registrationDate;
    private BigDecimal progressPercentage;
    private RegistrationStatus status;
    private PaymentMethod paymentMethod;
    private String paymentCode;
    private BigDecimal paymentAmount;
    private PaymentStatus paymentStatus;
    private OffsetDateTime paidAt;

    public Registration() {
    }

    public Registration(Long id, Long userId, Long courseId, OffsetDateTime registrationDate,
                        BigDecimal progressPercentage, RegistrationStatus status, PaymentMethod paymentMethod,
                        String paymentCode, BigDecimal paymentAmount, PaymentStatus paymentStatus, OffsetDateTime paidAt) {
        this.id = id;
        this.userId = userId;
        this.courseId = courseId;
        this.registrationDate = registrationDate;
        this.progressPercentage = progressPercentage;
        this.status = status;
        this.paymentMethod = paymentMethod;
        this.paymentCode = paymentCode;
        this.paymentAmount = paymentAmount;
        this.paymentStatus = paymentStatus;
        this.paidAt = paidAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public OffsetDateTime getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(OffsetDateTime registrationDate) {
        this.registrationDate = registrationDate;
    }

    public BigDecimal getProgressPercentage() {
        return progressPercentage;
    }

    public void setProgressPercentage(BigDecimal progressPercentage) {
        this.progressPercentage = progressPercentage;
    }

    public RegistrationStatus getStatus() {
        return status;
    }

    public void setStatus(RegistrationStatus status) {
        this.status = status;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentCode() {
        return paymentCode;
    }

    public void setPaymentCode(String paymentCode) {
        this.paymentCode = paymentCode;
    }

    public BigDecimal getPaymentAmount() {
        return paymentAmount;
    }

    public void setPaymentAmount(BigDecimal paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public OffsetDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(OffsetDateTime paidAt) {
        this.paidAt = paidAt;
    }
}
