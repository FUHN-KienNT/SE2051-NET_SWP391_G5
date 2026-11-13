package util;

import jakarta.servlet.http.HttpServletRequest;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * Tiện ích tích hợp cổng thanh toán trực tuyến VNPay 2.1.0
 */
public class VnPayUtil {

    private static String payUrl;
    private static String tmnCode;
    private static String hashSecret;
    private static String returnUrl = "/registrations/vnpay-return";
    private static String version = "2.1.0";
    private static String command = "pay";

    static {
        Properties props = new Properties();
        try (InputStream is = VnPayUtil.class.getClassLoader().getResourceAsStream("vnpay.properties")) {
            if (is != null) {
                props.load(is);
            }
        } catch (Exception e) {
            System.err.println("[VnPayUtil] Lỗi tải file vnpay.properties: " + e.getMessage());
        }

        payUrl = getPropertyOrEnv(props, "vnp_PayUrl", "VNP_PAY_URL");
        tmnCode = getPropertyOrEnv(props, "vnp_TmnCode", "VNP_TMN_CODE");
        hashSecret = getPropertyOrEnv(props, "vnp_HashSecret", "VNP_HASH_SECRET");

        String propReturnUrl = getPropertyOrEnv(props, "vnp_ReturnUrl", "VNP_RETURN_URL");
        if (propReturnUrl != null && !propReturnUrl.isEmpty()) {
            returnUrl = propReturnUrl;
        }
        String propVersion = getPropertyOrEnv(props, "vnp_Version", "VNP_VERSION");
        if (propVersion != null && !propVersion.isEmpty()) {
            version = propVersion;
        }
        String propCommand = getPropertyOrEnv(props, "vnp_Command", "VNP_COMMAND");
        if (propCommand != null && !propCommand.isEmpty()) {
            command = propCommand;
        }

        if (tmnCode == null || hashSecret == null || payUrl == null) {
            System.err.println("[VnPayUtil] CẢNH BÁO AN NINH: Thiếu cấu hình bắt buộc cho Cổng VNPay (vnp_TmnCode, vnp_HashSecret, vnp_PayUrl). Vui lòng cấu hình trong vnpay.properties hoặc biến môi trường.");
        }
    }

    private static String getPropertyOrEnv(Properties props, String propKey, String envKey) {
        String val = props.getProperty(propKey);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        val = System.getenv(envKey);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        val = System.getProperty(propKey);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        return null;
    }

    public static String getPayUrl() {
        return payUrl;
    }

    public static String getTmnCode() {
        return tmnCode;
    }

    public static String getHashSecret() {
        return hashSecret;
    }

    public static String getReturnUrl() {
        return returnUrl;
    }

    /**
     * Tạo URL thanh toán VNPay từ HttpServletRequest
     */
    public static String createPaymentUrl(HttpServletRequest req, long registrationId, BigDecimal amount, String orderInfo) {
        return createPaymentUrl(req, registrationId, amount, orderInfo, null);
    }

    public static String createPaymentUrl(HttpServletRequest req, long registrationId, BigDecimal amount, String orderInfo, String bankCode) {
        return createPaymentUrl(req, registrationId, amount, orderInfo, bankCode, null);
    }

    public static String createPaymentUrl(HttpServletRequest req, long registrationId, BigDecimal amount, String orderInfo, String bankCode, OffsetDateTime expireAt) {
        String scheme = req.getScheme();
        String serverName = req.getServerName();
        int serverPort = req.getServerPort();
        String contextPath = req.getContextPath();

        StringBuilder baseUrl = new StringBuilder();
        baseUrl.append(scheme).append("://").append(serverName);
        if (("http".equalsIgnoreCase(scheme) && serverPort != 80) || ("https".equalsIgnoreCase(scheme) && serverPort != 443)) {
            baseUrl.append(":").append(serverPort);
        }
        baseUrl.append(contextPath);

        String clientIp = req.getHeader("X-Forwarded-For");
        if (clientIp == null || clientIp.trim().isEmpty() || "unknown".equalsIgnoreCase(clientIp)) {
            clientIp = req.getRemoteAddr();
        }
        if (clientIp == null || "0:0:0:0:0:0:0:1".equals(clientIp)) {
            clientIp = "127.0.0.1";
        }
        if (clientIp.contains(",")) {
            clientIp = clientIp.split(",")[0].trim();
        }

        return createPaymentUrl(baseUrl.toString(), clientIp, registrationId, amount, orderInfo, bankCode, expireAt);
    }

    /**
     * Tạo URL thanh toán VNPay độc lập (tiện cho unit test và gọi service)
     */
    public static String createPaymentUrl(String baseUrl, String clientIp, long registrationId, BigDecimal amount, String orderInfo) {
        return createPaymentUrl(baseUrl, clientIp, registrationId, amount, orderInfo, null, null);
    }

    public static String createPaymentUrl(String baseUrl, String clientIp, long registrationId, BigDecimal amount, String orderInfo, String bankCode) {
        return createPaymentUrl(baseUrl, clientIp, registrationId, amount, orderInfo, bankCode, null);
    }

    public static String createPaymentUrl(String baseUrl, String clientIp, long registrationId, BigDecimal amount, String orderInfo, String bankCode, OffsetDateTime expireAt) {
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", version);
        vnp_Params.put("vnp_Command", command);
        vnp_Params.put("vnp_TmnCode", tmnCode);
        if (bankCode != null && !bankCode.trim().isEmpty()) {
            vnp_Params.put("vnp_BankCode", bankCode.trim());
        }

        // VNPay số tiền nhân 100
        long amountInVnd = amount != null ? amount.multiply(BigDecimal.valueOf(100)).longValue() : 0L;
        vnp_Params.put("vnp_Amount", String.valueOf(amountInVnd));
        vnp_Params.put("vnp_CurrCode", "VND");

        // Transaction Ref: registrationId_timestamp để chống trùng giao dịch khi người dùng ấn thanh toán lại
        String txnRef = registrationId + "_" + System.currentTimeMillis();
        vnp_Params.put("vnp_TxnRef", txnRef);

        String info = (orderInfo != null && !orderInfo.trim().isEmpty())
                ? orderInfo.trim()
                : "Thanh toan don dang ky #" + registrationId;
        vnp_Params.put("vnp_OrderInfo", info);
        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_Locale", "vn");

        String fullReturnUrl = returnUrl.startsWith("http") ? returnUrl : (baseUrl + returnUrl);
        vnp_Params.put("vnp_ReturnUrl", fullReturnUrl);

        String ip = (clientIp != null && !clientIp.trim().isEmpty()) ? clientIp : "127.0.0.1";
        vnp_Params.put("vnp_IpAddr", ip);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        formatter.setTimeZone(TimeZone.getTimeZone("Etc/GMT+7"));
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        if (expireAt != null) {
            java.time.ZonedDateTime gmt7Expire = expireAt.atZoneSameInstant(java.time.ZoneId.of("Asia/Ho_Chi_Minh"));
            String vnp_ExpireDate = gmt7Expire.format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
        } else {
            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
        }

        // Sắp xếp các tham số theo thứ tự bảng chữ cái ASCII
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        boolean first = true;

        for (String fieldName : fieldNames) {
            String fieldValue = vnp_Params.get(fieldName);
            if (fieldValue != null && !fieldValue.trim().isEmpty()) {
                try {
                    if (!first) {
                        hashData.append('&');
                        query.append('&');
                    }
                    hashData.append(fieldName).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()))
                         .append('=')
                         .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    first = false;
                } catch (Exception ignored) {
                }
            }
        }

        String queryUrl = query.toString();
        String vnp_SecureHash = hmacSHA512(hashSecret, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;

        return payUrl + "?" + queryUrl;
    }

    /**
     * Xác thực chữ ký số và dữ liệu phản hồi từ VNPay (Return URL hoặc IPN Webhook)
     */
    public static VnPayVerifyResult verifyPayment(Map<String, String[]> requestParameterMap) {
        Map<String, String> fields = new HashMap<>();
        for (Map.Entry<String, String[]> entry : requestParameterMap.entrySet()) {
            String key = entry.getKey();
            String[] values = entry.getValue();
            if (values != null && values.length > 0 && values[0] != null && !values[0].trim().isEmpty()) {
                fields.put(key, values[0].trim());
            }
        }

        String vnp_SecureHash = fields.remove("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");

        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        boolean first = true;
        for (String fieldName : fieldNames) {
            String fieldValue = fields.get(fieldName);
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

        String signValue = hmacSHA512(hashSecret, hashData.toString());
        boolean validSignature = signValue.equalsIgnoreCase(vnp_SecureHash);

        String responseCode = fields.get("vnp_ResponseCode");
        String transactionStatus = fields.get("vnp_TransactionStatus");
        String txnRef = fields.get("vnp_TxnRef");
        String transactionNo = fields.get("vnp_TransactionNo");
        String bankCode = fields.get("vnp_BankCode");
        String orderInfo = fields.get("vnp_OrderInfo");
        String payDate = fields.get("vnp_PayDate");

        long registrationId = -1L;
        if (txnRef != null) {
            try {
                if (txnRef.contains("_")) {
                    registrationId = Long.parseLong(txnRef.split("_")[0]);
                } else {
                    registrationId = Long.parseLong(txnRef);
                }
            } catch (NumberFormatException ignored) {
            }
        }

        BigDecimal amount = null;
        String amountStr = fields.get("vnp_Amount");
        if (amountStr != null) {
            try {
                amount = new BigDecimal(amountStr).divide(BigDecimal.valueOf(100));
            } catch (Exception ignored) {
            }
        }

        boolean success = validSignature && "00".equals(responseCode) && (transactionStatus == null || "00".equals(transactionStatus));
        String message = getResponseMessage(responseCode);

        return new VnPayVerifyResult(
                validSignature,
                success,
                responseCode,
                transactionStatus,
                registrationId,
                txnRef,
                transactionNo,
                amount,
                bankCode,
                orderInfo,
                payDate,
                message
        );
    }

    /**
     * Tính toán mã băm HMAC-SHA512
     */
    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) {
                return "";
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes(StandardCharsets.UTF_8);
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            return "";
        }
    }

    /**
     * Diễn giải mã phản hồi sang thông báo tiếng Việt
     */
    public static String getResponseMessage(String responseCode) {
        if (responseCode == null) return "Không có phản hồi từ cổng thanh toán";
        switch (responseCode) {
            case "00":
                return "Giao dịch thanh toán thành công!";
            case "07":
                return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo hoặc bất thường).";
            case "09":
                return "Thẻ/Tài khoản của bạn chưa đăng ký dịch vụ InternetBanking tại ngân hàng.";
            case "10":
                return "Xác thực thông tin thẻ/tài khoản không đúng quá 3 lần.";
            case "11":
                return "Đã hết hạn chờ thanh toán. Vui lòng thử lại.";
            case "12":
                return "Thẻ/Tài khoản của bạn đang bị khóa.";
            case "13":
                return "Quý khách nhập sai mật khẩu xác thực OTP. Vui lòng thực hiện lại giao dịch.";
            case "24":
                return "Giao dịch đã bị hủy bởi quý khách.";
            case "51":
                return "Tài khoản của bạn không đủ số dư để thực hiện giao dịch.";
            case "65":
                return "Tài khoản đã vượt quá hạn mức giao dịch trong ngày.";
            case "75":
                return "Ngân hàng thanh toán đang bảo trì hệ thống. Vui lòng thử lại sau.";
            case "79":
                return "Quý khách nhập sai mật khẩu thanh toán quá số lần quy định.";
            case "99":
            default:
                return "Giao dịch không thành công hoặc phát sinh lỗi xử lý (Mã lỗi: " + responseCode + ").";
        }
    }

    /**
     * Dữ liệu kết quả xác minh phản hồi VNPay
     */
    public static class VnPayVerifyResult {
        private final boolean validSignature;
        private final boolean success;
        private final String responseCode;
        private final String transactionStatus;
        private final long registrationId;
        private final String txnRef;
        private final String transactionNo;
        private final BigDecimal amount;
        private final String bankCode;
        private final String orderInfo;
        private final String payDate;
        private final String message;

        public VnPayVerifyResult(boolean validSignature, boolean success, String responseCode, String transactionStatus,
                                 long registrationId, String txnRef, String transactionNo, BigDecimal amount,
                                 String bankCode, String orderInfo, String payDate, String message) {
            this.validSignature = validSignature;
            this.success = success;
            this.responseCode = responseCode;
            this.transactionStatus = transactionStatus;
            this.registrationId = registrationId;
            this.txnRef = txnRef;
            this.transactionNo = transactionNo;
            this.amount = amount;
            this.bankCode = bankCode;
            this.orderInfo = orderInfo;
            this.payDate = payDate;
            this.message = message;
        }

        public boolean isValidSignature() { return validSignature; }
        public boolean isSuccess() { return success; }
        public String getResponseCode() { return responseCode; }
        public String getTransactionStatus() { return transactionStatus; }
        public long getRegistrationId() { return registrationId; }
        public String getTxnRef() { return txnRef; }
        public String getTransactionNo() { return transactionNo; }
        public BigDecimal getAmount() { return amount; }
        public String getBankCode() { return bankCode; }
        public String getOrderInfo() { return orderInfo; }
        public String getPayDate() { return payDate; }
        public String getMessage() { return message; }
    }
}
