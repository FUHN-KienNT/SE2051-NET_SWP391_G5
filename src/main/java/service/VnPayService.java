package service;

import dto.RegistrationDto;
import dto.UserDto;
import entity.enums.PaymentStatus;
import entity.enums.RegistrationStatus;
import util.VnPayUtil;
import util.VnPayUtil.VnPayVerifyResult;

import java.time.OffsetDateTime;
import java.util.Map;

/**
 * Service chuyên trách xử lý quy trình thanh toán VNPay:
 * - Xác thực chữ ký số (Checksum verification)
 * - Đối soát số tiền (Amount validation)
 * - Đảm bảo tính Idempotent (chống xử lý trùng lặp giao dịch)
 * - Tách biệt hoàn toàn logic Webhook (IPN) và Browser Return khỏi Servlet
 */
public class VnPayService {

    public enum VnPayProcessStatus {
        SUCCESS,
        ALREADY_CONFIRMED,
        INVALID_SIGNATURE,
        ORDER_NOT_FOUND,
        INVALID_AMOUNT,
        FAILED
    }

    public static class VnPayValidationResult {
        private final VnPayProcessStatus status;
        private final RegistrationDto registration;
        private final VnPayVerifyResult verifyResult;
        private final String message;

        public VnPayValidationResult(VnPayProcessStatus status, RegistrationDto registration,
                                    VnPayVerifyResult verifyResult, String message) {
            this.status = status;
            this.registration = registration;
            this.verifyResult = verifyResult;
            this.message = message;
        }

        public VnPayProcessStatus getStatus() {
            return status;
        }

        public RegistrationDto getRegistration() {
            return registration;
        }

        public VnPayVerifyResult getVerifyResult() {
            return verifyResult;
        }

        public String getMessage() {
            return message;
        }
    }

    public static class VnPayReturnOutcome {
        private final boolean success;
        private final String redirectPath;
        private final String message;
        private final boolean isFlashSuccess;

        public VnPayReturnOutcome(boolean success, String redirectPath, String message, boolean isFlashSuccess) {
            this.success = success;
            this.redirectPath = redirectPath;
            this.message = message;
            this.isFlashSuccess = isFlashSuccess;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getRedirectPath() {
            return redirectPath;
        }

        public String getMessage() {
            return message;
        }

        public boolean isFlashSuccess() {
            return isFlashSuccess;
        }
    }

    private final RegistrationService registrationService;

    public VnPayService(RegistrationService registrationService) {
        this.registrationService = registrationService;
    }

    /**
     * Xác thực và đối soát đồng nhất giữa Return URL (Browser) và IPN Webhook (Server-to-Server)
     */
    public VnPayValidationResult validateAndProcessVnPay(Map<String, String[]> parameterMap) {
        VnPayVerifyResult result = VnPayUtil.verifyPayment(parameterMap);

        if (!result.isValidSignature()) {
            return new VnPayValidationResult(VnPayProcessStatus.INVALID_SIGNATURE, null, result,
                    "Chữ ký bảo mật không hợp lệ từ VNPay (Invalid Checksum).");
        }

        long regId = result.getRegistrationId();
        if (regId <= 0) {
            return new VnPayValidationResult(VnPayProcessStatus.ORDER_NOT_FOUND, null, result,
                    "Không tìm thấy mã đơn đăng ký từ phản hồi VNPay.");
        }

        RegistrationDto reg = registrationService.getById(regId);
        if (reg == null) {
            return new VnPayValidationResult(VnPayProcessStatus.ORDER_NOT_FOUND, null, result,
                    "Không tìm thấy thông tin đơn đăng ký #" + regId);
        }

        // 1. Kiểm tra số tiền thanh toán (Amount Verification) - Đồng nhất cả IPN lẫn Return URL
        if (result.getAmount() != null && reg.getPaymentAmount() != null) {
            if (result.getAmount().compareTo(reg.getPaymentAmount()) != 0) {
                return new VnPayValidationResult(VnPayProcessStatus.INVALID_AMOUNT, reg, result,
                        "Số tiền thanh toán (" + result.getAmount() + ") không khớp với giá trị đơn hàng (" + reg.getPaymentAmount() + ").");
            }
        }

        // 2. Kiểm tra Idempotent: Đơn hàng đã thành công từ trước (do IPN hoặc Return xử lý trước)
        if (reg.getPaymentStatus() == PaymentStatus.SUCCESS || reg.getStatus() == RegistrationStatus.ACTIVE) {
            return new VnPayValidationResult(VnPayProcessStatus.ALREADY_CONFIRMED, reg, result,
                    "Đơn hàng đã được xác nhận thanh toán thành công trước đó.");
        }

        // 3. Cập nhật kết quả giao dịch vào CSDL
        if (result.isSuccess()) {
            registrationService.updatePayment(regId, PaymentStatus.SUCCESS, result.getTransactionNo(), OffsetDateTime.now());
            return new VnPayValidationResult(VnPayProcessStatus.SUCCESS, reg, result, "Thanh toán VNPay thành công!");
        } else {
            registrationService.updatePayment(regId, PaymentStatus.FAILED, result.getTransactionNo(), OffsetDateTime.now());
            return new VnPayValidationResult(VnPayProcessStatus.FAILED, reg, result,
                    "Thanh toán VNPay không thành công: " + result.getMessage() + " (Mã: " + result.getResponseCode() + ").");
        }
    }

    /**
     * Xử lý luồng khách hàng quay lại từ VNPay (Browser Return):
     * Thực hiện kiểm tra quyền sở hữu (IDOR Defense) và trả về hướng xử lý cùng thông báo
     */
    public VnPayReturnOutcome handleReturn(Map<String, String[]> parameterMap, UserDto currentUser) {
        VnPayValidationResult val = validateAndProcessVnPay(parameterMap);
        RegistrationDto reg = val.getRegistration();

        // IDOR Defense: nếu học viên đang đăng nhập, kiểm tra đơn hàng có thuộc về họ
        if (currentUser != null && reg != null && reg.getUserId() != currentUser.getId()) {
            return new VnPayReturnOutcome(false, "/registrations/my",
                    "Bạn không có quyền truy cập kết quả đơn đăng ký này.", false);
        }

        switch (val.getStatus()) {
            case INVALID_SIGNATURE:
            case ORDER_NOT_FOUND:
                return new VnPayReturnOutcome(false, "/registrations/my", val.getMessage(), false);

            case INVALID_AMOUNT:
                String targetAmountErr = reg != null ? ("/registrations/payment?courseId=" + reg.getCourseId()) : "/registrations/my";
                return new VnPayReturnOutcome(false, targetAmountErr, val.getMessage(), false);

            case ALREADY_CONFIRMED:
                String redirectConfirmed = reg != null ? ("/courses/learn?registrationId=" + reg.getId()) : "/registrations/my";
                return new VnPayReturnOutcome(true, redirectConfirmed,
                        "Đơn hàng của bạn đã được thanh toán thành công trước đó! Chúc bạn học tập hiệu quả.", true);

            case SUCCESS:
                String redirectSuccess = reg != null ? ("/courses/learn?registrationId=" + reg.getId()) : "/registrations/my";
                String courseName = (reg != null && reg.getCourseTitle() != null) ? reg.getCourseTitle() : "";
                return new VnPayReturnOutcome(true, redirectSuccess,
                        "Thanh toán VNPay thành công! Bạn đã được kích hoạt khóa học \"" + courseName + "\".", true);

            case FAILED:
            default:
                String targetFailed = reg != null ? ("/registrations/payment?courseId=" + reg.getCourseId()) : "/registrations/my";
                return new VnPayReturnOutcome(false, targetFailed, val.getMessage(), false);
        }
    }

    /**
     * Xử lý Webhook IPN từ máy chủ VNPay (Server-to-Server callback)
     * Trả về JSON theo đúng tài liệu VNPay 2.1.0
     */
    public String handleIpn(Map<String, String[]> parameterMap) {
        VnPayValidationResult val = validateAndProcessVnPay(parameterMap);
        switch (val.getStatus()) {
            case INVALID_SIGNATURE:
                return "{\"RspCode\":\"97\",\"Message\":\"Invalid Checksum\"}";
            case ORDER_NOT_FOUND:
                return "{\"RspCode\":\"01\",\"Message\":\"Order not found\"}";
            case INVALID_AMOUNT:
                return "{\"RspCode\":\"04\",\"Message\":\"Invalid Amount\"}";
            case ALREADY_CONFIRMED:
                return "{\"RspCode\":\"02\",\"Message\":\"Order already confirmed\"}";
            case SUCCESS:
            case FAILED:
            default:
                return "{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}";
        }
    }
}
