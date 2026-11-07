package test;

import dao.CourseDao;
import dao.RegistrationDao;
import dao.UserDao;
import dto.RegistrationDto;
import entity.Course;
import entity.Registration;
import entity.User;
import entity.enums.CourseStatus;
import entity.enums.PaymentStatus;
import entity.enums.RegistrationStatus;
import service.RegistrationService;
import util.DbConnection;
import util.VnPayUtil;
import util.VnPayUtil.VnPayVerifyResult;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class VnPayTestSuite {

    private static final RegistrationDao registrationDao = new RegistrationDao();
    private static final CourseDao courseDao = new CourseDao();
    private static final RegistrationService registrationService = new RegistrationService(registrationDao, courseDao);

    private static int totalPassed = 0;
    private static int totalFailed = 0;
    private static final List<String> failures = new ArrayList<>();

    @org.junit.jupiter.api.Test
    @org.junit.jupiter.api.DisplayName("Bộ kiểm thử Nghiệp vụ Thanh toán VNPay 2.1.0")
    public void testVnPaySuite() {
        totalPassed = 0;
        totalFailed = 0;
        failures.clear();

        try {
            testHmacSha512Calculation();
            testCreatePaymentUrl();
            testVerifyPaymentValidSuccess();
            testVerifyPaymentTamperedChecksum();
            testVerifyPaymentCancelledByUser();
            testRegistrationPaymentLifecycle();
        } catch (Exception e) {
            recordFailure("Lỗi ngoại lệ: " + e.getMessage());
        }

        if (totalFailed > 0) {
            org.junit.jupiter.api.Assertions.fail("Có " + totalFailed + " ca kiểm thử thất bại: " + String.join(", ", failures));
        }
    }

    public static void main(String[] args) {
        System.out.println("======================================================================");
        System.out.println("     COURSON LMS - KIỂM THỬ TÍCH HỢP THANH TOÁN ONLINE VNPAY 2.1.0    ");
        System.out.println("======================================================================\n");

        try {
            testHmacSha512Calculation();
            testCreatePaymentUrl();
            testVerifyPaymentValidSuccess();
            testVerifyPaymentTamperedChecksum();
            testVerifyPaymentCancelledByUser();
            testRegistrationPaymentLifecycle();
        } catch (Exception e) {
            e.printStackTrace();
            recordFailure("Lỗi ngoại lệ không lường trước trong quá trình test: " + e.getMessage());
        }

        System.out.println("\n======================================================================");
        System.out.println(String.format(" KẾT QUẢ KIỂM THỬ: %d THÀNH CÔNG, %d THẤT BẠI", totalPassed, totalFailed));
        System.out.println("======================================================================");

        if (totalFailed > 0) {
            System.out.println("\nDANH SÁCH TEST CASE THẤT BẠI:");
            for (String f : failures) {
                System.out.println(" - [FAIL] " + f);
            }
            System.exit(1);
        } else {
            System.out.println("\n>>> TẤT CẢ CÁC BÀI TEST VNPAY ĐỀU VƯỢT QUA XUẤT SẮC! <<<");
        }
    }

    private static void assertTrue(String testName, boolean condition, String failureMsg) {
        if (condition) {
            System.out.println("  [PASS] " + testName);
            totalPassed++;
        } else {
            System.out.println("  [FAIL] " + testName + " -> " + failureMsg);
            totalFailed++;
            failures.add(testName + ": " + failureMsg);
        }
    }

    private static void recordFailure(String msg) {
        System.out.println("  [FAIL] " + msg);
        totalFailed++;
        failures.add(msg);
    }

    // 1. Kiểm thử thuật toán mã băm bảo mật HMAC-SHA512
    private static void testHmacSha512Calculation() {
        System.out.println("--- 1. Kiểm thử tính toán chữ ký số HMAC-SHA512 ---");

        String secret = "XNBCJFAKAZQSGTARRLGCHVZWCIOIGSHN";
        String data = "vnp_Amount=10000000&vnp_Command=pay&vnp_TmnCode=CGXZLS0Z";

        String hash = VnPayUtil.hmacSHA512(secret, data);

        assertTrue("Hash không được rỗng", hash != null && !hash.isEmpty(), "Hash bị rỗng");
        assertTrue("HMAC-SHA512 phải có đúng 128 ký tự hexa (64 bytes)", hash.length() == 128, "Độ dài hash = " + hash.length());

        // Kiểm tra tính nhất quán (cùng input sinh cùng output)
        String hash2 = VnPayUtil.hmacSHA512(secret, data);
        assertTrue("Tính nhất quán của hàm băm HMAC-SHA512", hash.equals(hash2), "Hai lần băm không khớp");

        // Đổi data -> hash phải thay đổi
        String hash3 = VnPayUtil.hmacSHA512(secret, data + "&vnp_CurrCode=VND");
        assertTrue("Thay đổi dữ liệu sinh ra hash khác biệt", !hash.equals(hash3), "Hash không đổi khi dữ liệu đổi");
    }

    // 2. Kiểm thử tạo URL thanh toán VNPay với đầy đủ tham số tiêu chuẩn 2.1.0
    private static void testCreatePaymentUrl() {
        System.out.println("\n--- 2. Kiểm thử tạo URL chuyển hướng thanh toán VNPay ---");

        long regId = 888L;
        BigDecimal amount = new BigDecimal("499000"); // 499,000 VNĐ
        String orderInfo = "Thanh toan don dang ky #888";

        String paymentUrl = VnPayUtil.createPaymentUrl("http://localhost:8080/Courson", "127.0.0.1", regId, amount, orderInfo);

        assertTrue("URL thanh toán phải bắt đầu bằng URL Sandbox của VNPay",
                paymentUrl.startsWith("https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?"),
                "Sai PayUrl: " + paymentUrl);

        assertTrue("Phải chứa vnp_Version=2.1.0", paymentUrl.contains("vnp_Version=2.1.0"), "Thiếu version");
        assertTrue("Phải chứa vnp_Command=pay", paymentUrl.contains("vnp_Command=pay"), "Thiếu command");
        assertTrue("Phải chứa vnp_TmnCode", paymentUrl.contains("vnp_TmnCode=CGXZLS0Z"), "Thiếu tmnCode");
        assertTrue("Số tiền nhân 100 (499,000 x 100 = 49,900,000)", paymentUrl.contains("vnp_Amount=49900000"), "Sai vnp_Amount");
        assertTrue("Phải chứa vnp_CurrCode=VND", paymentUrl.contains("vnp_CurrCode=VND"), "Thiếu CurrCode");
        assertTrue("Phải chứa vnp_TxnRef chứa registrationId", paymentUrl.contains("vnp_TxnRef=888_"), "Sai vnp_TxnRef");
        assertTrue("Phải chứa chữ ký bảo mật vnp_SecureHash", paymentUrl.contains("&vnp_SecureHash="), "Thiếu vnp_SecureHash");
    }

    // 3. Kiểm thử xác thực kết quả phản hồi VNPay thành công (ResponseCode = 00)
    private static void testVerifyPaymentValidSuccess() {
        System.out.println("\n--- 3. Kiểm thử xác thực chữ ký và kết quả thành công (00) ---");

        Map<String, String> rawParams = new HashMap<>();
        rawParams.put("vnp_Amount", "25000000"); // 250,000 VNĐ
        rawParams.put("vnp_BankCode", "NCB");
        rawParams.put("vnp_BankTranNo", "VNP140001");
        rawParams.put("vnp_CardType", "ATM");
        rawParams.put("vnp_OrderInfo", "Thanh toan khoa hoc #10");
        rawParams.put("vnp_PayDate", "20261106120000");
        rawParams.put("vnp_ResponseCode", "00");
        rawParams.put("vnp_TmnCode", "CGXZLS0Z");
        rawParams.put("vnp_TransactionNo", "14234567");
        rawParams.put("vnp_TransactionStatus", "00");
        rawParams.put("vnp_TxnRef", "777_1730900000");

        // Tạo chữ ký số hợp lệ cho bộ tham số trên
        String secureHash = calculateHashForParams(rawParams, VnPayUtil.getHashSecret());

        Map<String, String[]> requestMap = new HashMap<>();
        for (Map.Entry<String, String> e : rawParams.entrySet()) {
            requestMap.put(e.getKey(), new String[]{e.getValue()});
        }
        requestMap.put("vnp_SecureHash", new String[]{secureHash});

        VnPayVerifyResult result = VnPayUtil.verifyPayment(requestMap);

        assertTrue("Chữ ký số phải hợp lệ", result.isValidSignature(), "Chữ ký số bị báo không hợp lệ");
        assertTrue("Trạng thái giao dịch phải là thành công", result.isSuccess(), "Giao dịch không thành công");
        assertTrue("Mã đăng ký phải phân tích đúng (777)", result.getRegistrationId() == 777L, "Mã đăng ký = " + result.getRegistrationId());
        assertTrue("Số tiền quy đổi về đúng 250,000 VNĐ", result.getAmount().compareTo(new BigDecimal("250000")) == 0, "Số tiền = " + result.getAmount());
        assertTrue("Mã giao dịch ngân hàng khớp (14234567)", "14234567".equals(result.getTransactionNo()), "Sai TransactionNo");
    }

    // 4. Kiểm thử phát hiện giả mạo chữ ký (Checksum Tampering)
    private static void testVerifyPaymentTamperedChecksum() {
        System.out.println("\n--- 4. Kiểm thử phát hiện dữ liệu bị can thiệp/chữ ký giả mạo ---");

        Map<String, String> rawParams = new HashMap<>();
        rawParams.put("vnp_Amount", "25000000");
        rawParams.put("vnp_BankCode", "NCB");
        rawParams.put("vnp_ResponseCode", "00");
        rawParams.put("vnp_TmnCode", "CGXZLS0Z");
        rawParams.put("vnp_TxnRef", "777_1730900000");

        String validHash = calculateHashForParams(rawParams, VnPayUtil.getHashSecret());

        // Kẻ tấn công sửa đổi số tiền thành 1000 đồng mà giữ nguyên hash cũ
        Map<String, String[]> tamperedMap = new HashMap<>();
        tamperedMap.put("vnp_Amount", new String[]{"100000"}); // Sửa từ 250k thành 1k
        tamperedMap.put("vnp_BankCode", new String[]{"NCB"});
        tamperedMap.put("vnp_ResponseCode", new String[]{"00"});
        tamperedMap.put("vnp_TmnCode", new String[]{"CGXZLS0Z"});
        tamperedMap.put("vnp_TxnRef", new String[]{"777_1730900000"});
        tamperedMap.put("vnp_SecureHash", new String[]{validHash}); // Hash cũ

        VnPayVerifyResult result = VnPayUtil.verifyPayment(tamperedMap);

        assertTrue("Hệ thống phải từ chối khi chữ ký số không khớp dữ liệu đã sửa",
                !result.isValidSignature(),
                "Hệ thống đã chấp nhận chữ ký số bị sai lệch!");
        assertTrue("Không được xác nhận thành công nếu chữ ký bị giả mạo",
                !result.isSuccess(),
                "isSuccess() trả về true khi chữ ký không hợp lệ!");
    }

    // 5. Kiểm thử khi khách hàng hủy giao dịch (ResponseCode = 24)
    private static void testVerifyPaymentCancelledByUser() {
        System.out.println("\n--- 5. Kiểm thử phản hồi khi khách hàng hủy giao dịch (24) ---");

        Map<String, String> rawParams = new HashMap<>();
        rawParams.put("vnp_Amount", "30000000");
        rawParams.put("vnp_ResponseCode", "24");
        rawParams.put("vnp_TmnCode", "CGXZLS0Z");
        rawParams.put("vnp_TxnRef", "555_1730900000");

        String secureHash = calculateHashForParams(rawParams, VnPayUtil.getHashSecret());

        Map<String, String[]> requestMap = new HashMap<>();
        for (Map.Entry<String, String> e : rawParams.entrySet()) {
            requestMap.put(e.getKey(), new String[]{e.getValue()});
        }
        requestMap.put("vnp_SecureHash", new String[]{secureHash});

        VnPayVerifyResult result = VnPayUtil.verifyPayment(requestMap);

        assertTrue("Chữ ký hợp lệ", result.isValidSignature(), "Chữ ký không hợp lệ");
        assertTrue("Giao dịch bị đánh dấu không thành công", !result.isSuccess(), "Giao dịch hủy không được coi là thành công");
        assertTrue("Thông báo phải chứa chữ 'hủy'", result.getMessage().toLowerCase().contains("hủy"), "Thông báo: " + result.getMessage());
    }

    // 6. Kiểm thử vòng đời đăng ký và cập nhật thanh toán vào Database
    private static void testRegistrationPaymentLifecycle() {
        System.out.println("\n--- 6. Kiểm thử vòng đời thanh toán và kích hoạt khóa học trong CSDL ---");

        long testUserId = -1L;
        long testCourseId = -1L;
        long testRegId = -1L;

        try (Connection con = DbConnection.getConnection()) {
            // Tìm 1 user test (role STUDENT)
            try (PreparedStatement ps = con.prepareStatement("SELECT id FROM users WHERE role_id = (SELECT id FROM settings WHERE value = 'STUDENT') LIMIT 1")) {
                try (var rs = ps.executeQuery()) {
                    if (rs.next()) testUserId = rs.getLong(1);
                }
            }

            // Tìm 1 khóa học đã xuất bản có phí
            try (PreparedStatement ps = con.prepareStatement("SELECT id FROM courses WHERE status = 'PUBLISHED' AND price > 0 LIMIT 1")) {
                try (var rs = ps.executeQuery()) {
                    if (rs.next()) testCourseId = rs.getLong(1);
                }
            }

            if (testUserId <= 0 || testCourseId <= 0) {
                System.out.println("  [SKIP] Không tìm thấy dữ liệu user/course phù hợp trong DB để test lifecycle.");
                return;
            }

            // Xóa đăng ký cũ nếu có để tạo môi trường sạch
            try (PreparedStatement ps = con.prepareStatement("DELETE FROM lesson_progress WHERE registration_id IN (SELECT id FROM registrations WHERE user_id = ? AND course_id = ?)")) {
                ps.setLong(1, testUserId);
                ps.setLong(2, testCourseId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = con.prepareStatement("DELETE FROM registrations WHERE user_id = ? AND course_id = ?")) {
                ps.setLong(1, testUserId);
                ps.setLong(2, testCourseId);
                ps.executeUpdate();
            }

            // Bước 1: Khởi tạo đăng ký (Enroll)
            RegistrationDto reg = registrationService.enroll(testUserId, testCourseId);
            testRegId = reg.getId();

            assertTrue("Đơn hàng mới tạo phải có ID > 0", testRegId > 0, "testRegId = " + testRegId);
            assertTrue("Trạng thái thanh toán ban đầu phải là PENDING", reg.getPaymentStatus() == PaymentStatus.PENDING, "PaymentStatus = " + reg.getPaymentStatus());
            assertTrue("Trạng thái đăng ký ban đầu phải là PENDING", reg.getStatus() == RegistrationStatus.PENDING, "Status = " + reg.getStatus());

            // Bước 2: Chưa thanh toán thì chưa có quyền vào học
            boolean hasAccessBefore = registrationService.hasCourseAccess(testUserId, testCourseId);
            assertTrue("Chưa thanh toán thì hasCourseAccess() phải trả về false", !hasAccessBefore, "Đã có quyền học trước khi trả tiền!");

            // Bước 3: Nhận phản hồi thanh toán thành công từ VNPay (Update Payment SUCCESS)
            String transactionCode = "VNPAY-TEST-SUCCESS-" + System.currentTimeMillis();
            OffsetDateTime paidAt = OffsetDateTime.now();
            registrationService.updatePayment(testRegId, PaymentStatus.SUCCESS, transactionCode, paidAt);

            // Bước 4: Kiểm tra lại trong DB
            RegistrationDto updatedReg = registrationService.getById(testRegId);
            assertTrue("Trạng thái thanh toán sau khi cập nhật phải là SUCCESS", updatedReg.getPaymentStatus() == PaymentStatus.SUCCESS, "PaymentStatus = " + updatedReg.getPaymentStatus());
            assertTrue("Trạng thái đăng ký phải được kích hoạt ACTIVE", updatedReg.getStatus() == RegistrationStatus.ACTIVE, "Status = " + updatedReg.getStatus());
            assertTrue("Mã giao dịch VNPay phải được lưu lại", transactionCode.equals(updatedReg.getPaymentCode()), "PaymentCode = " + updatedReg.getPaymentCode());
            assertTrue("Thời gian thanh toán paidAt không được null", updatedReg.getPaidAt() != null, "paidAt bị null");

            // Bước 5: Đã có quyền vào học bài giảng
            boolean hasAccessAfter = registrationService.hasCourseAccess(testUserId, testCourseId);
            assertTrue("Sau khi thanh toán thành công hasCourseAccess() phải trả về true", hasAccessAfter, "Chưa có quyền vào học sau khi thanh toán!");

            // Dọn dẹp bản ghi test
            try (PreparedStatement ps = con.prepareStatement("DELETE FROM registrations WHERE id = ?")) {
                ps.setLong(1, testRegId);
                ps.executeUpdate();
            }
            System.out.println("  [CLEANUP] Đã dọn dẹp sạch sẽ bản ghi đăng ký thử nghiệm.");
        } catch (Exception e) {
            recordFailure("Lỗi lifecycle CSDL: " + e.getMessage());
        }
    }

    private static String calculateHashForParams(Map<String, String> params, String secret) {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        boolean first = true;
        for (String fieldName : fieldNames) {
            String fieldValue = params.get(fieldName);
            if (fieldValue != null && !fieldValue.trim().isEmpty()) {
                try {
                    if (!first) {
                        hashData.append('&');
                    }
                    hashData.append(fieldName).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    first = false;
                } catch (Exception ignored) {
                }
            }
        }
        return VnPayUtil.hmacSHA512(secret, hashData.toString());
    }
}
