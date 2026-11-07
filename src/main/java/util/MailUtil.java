package util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

public final class MailUtil {

    private static final Logger LOGGER = Logger.getLogger(MailUtil.class.getName());
    private static final String SMTP_TIMEOUT_MS = "10000";

    private static final ExecutorService EXECUTOR = Executors.newFixedThreadPool(4, r -> {
        Thread t = new Thread(r, "CoursonMailWorker");
        t.setDaemon(true);
        return t;
    });

    private static String SMTP_HOST = "smtp.gmail.com";
    private static String SMTP_PORT = "587";
    private static String SMTP_USERNAME = "";
    private static String SMTP_PASSWORD = "";
    private static String FROM_NAME = "Courson LMS";
    private static String APP_BASE_URL = "http://localhost:8080/Courson";

    static {
        loadConfig();
    }

    private MailUtil() {
    }

    private static void loadConfig() {
        try (InputStream is = MailUtil.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (is != null) {
                Properties prop = new Properties();
                prop.load(is);
                if (prop.containsKey("mail.smtp.host")) SMTP_HOST = prop.getProperty("mail.smtp.host").trim();
                if (prop.containsKey("mail.smtp.port")) SMTP_PORT = prop.getProperty("mail.smtp.port").trim();
                if (prop.containsKey("mail.smtp.username")) SMTP_USERNAME = prop.getProperty("mail.smtp.username").trim();
                if (prop.containsKey("mail.smtp.password")) SMTP_PASSWORD = prop.getProperty("mail.smtp.password").trim();
                if (prop.containsKey("mail.from.name")) FROM_NAME = prop.getProperty("mail.from.name").trim();
                if (prop.containsKey("app.base.url")) APP_BASE_URL = prop.getProperty("app.base.url").trim();
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Không thể đọc mail.properties, sử dụng cấu hình mặc định", e);
        }

        // Environment variable overrides
        if (System.getenv("MAIL_SMTP_HOST") != null) SMTP_HOST = System.getenv("MAIL_SMTP_HOST").trim();
        if (System.getenv("MAIL_SMTP_PORT") != null) SMTP_PORT = System.getenv("MAIL_SMTP_PORT").trim();
        if (System.getenv("MAIL_SMTP_USERNAME") != null) SMTP_USERNAME = System.getenv("MAIL_SMTP_USERNAME").trim();
        if (System.getenv("MAIL_SMTP_PASSWORD") != null) SMTP_PASSWORD = System.getenv("MAIL_SMTP_PASSWORD").trim();
        if (System.getenv("MAIL_FROM_NAME") != null) FROM_NAME = System.getenv("MAIL_FROM_NAME").trim();
        if (System.getenv("APP_BASE_URL") != null) APP_BASE_URL = System.getenv("APP_BASE_URL").trim();

        // Remove any spaces if provided as 4-word Google App password
        if (SMTP_PASSWORD != null) {
            SMTP_PASSWORD = SMTP_PASSWORD.replace(" ", "");
        }
    }

    public static String getAppBaseUrl() {
        return APP_BASE_URL;
    }

    private static String resolveBaseUrl(String dynamicBaseUrl) {
        String baseUrl = (dynamicBaseUrl != null && !dynamicBaseUrl.trim().isEmpty()) ? dynamicBaseUrl.trim() : APP_BASE_URL;
        if (baseUrl.endsWith("/")) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        }
        return baseUrl;
    }

    private static Session createSmtpSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.connectiontimeout", SMTP_TIMEOUT_MS);
        props.put("mail.smtp.timeout", SMTP_TIMEOUT_MS);
        props.put("mail.smtp.writetimeout", SMTP_TIMEOUT_MS);

        if ("465".equals(SMTP_PORT)) {
            props.put("mail.smtp.ssl.enable", "true");
        } else {
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
        }

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
            }
        });
    }

    private static void sendHtmlEmailSync(String toEmail, String subject, String htmlBody, String emailTypeLabel)
            throws MessagingException {
        if (toEmail == null || toEmail.trim().isEmpty()) {
            LOGGER.warning("Địa chỉ email nhận không hợp lệ, bỏ qua gửi mail.");
            return;
        }

        if (SMTP_USERNAME == null || SMTP_USERNAME.isEmpty() || SMTP_PASSWORD == null || SMTP_PASSWORD.isEmpty()) {
            LOGGER.severe("Chưa cấu hình tài khoản SMTP (username hoặc password rỗng). Vui lòng kiểm tra mail.properties.");
            return;
        }

        Session session = createSmtpSession();
        MimeMessage message = new MimeMessage(session);
        try {
            message.setFrom(new InternetAddress(SMTP_USERNAME, FROM_NAME, StandardCharsets.UTF_8.name()));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail.trim()));
            message.setSubject(subject, StandardCharsets.UTF_8.name());
            message.setContent(htmlBody, "text/html; charset=UTF-8");

            Transport.send(message);
            LOGGER.info("Đã gửi email " + emailTypeLabel + " thành công tới: " + toEmail);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Gửi email " + emailTypeLabel + " thất bại tới: " + toEmail, e);
            throw new MessagingException("Gửi email " + emailTypeLabel + " thất bại: " + e.getMessage(), e);
        }
    }

    /**
     * Sends verification email asynchronously.
     */
    public static void sendVerificationEmailAsync(String toEmail, String fullName, String rawToken, String dynamicBaseUrl) {
        EXECUTOR.submit(() -> {
            try {
                sendVerificationEmailSync(toEmail, fullName, rawToken, dynamicBaseUrl);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi gửi email xác thực bất đồng bộ tới: " + toEmail, e);
            }
        });
    }

    /**
     * Synchronous mail sending logic for verification.
     */
    public static void sendVerificationEmailSync(String toEmail, String fullName, String rawToken, String dynamicBaseUrl)
            throws MessagingException {
        String verificationUrl = resolveBaseUrl(dynamicBaseUrl) + "/verify?token=" + rawToken;
        String htmlBody = buildVerificationEmailHtml(fullName != null ? fullName : "Học viên", verificationUrl);
        sendHtmlEmailSync(toEmail, "Xác thực tài khoản Courson LMS", htmlBody, "xác thực");
    }

    /**
     * Sends password reset email asynchronously.
     */
    public static void sendPasswordResetEmailAsync(String toEmail, String fullName, String rawToken, String dynamicBaseUrl) {
        EXECUTOR.submit(() -> {
            try {
                sendPasswordResetEmailSync(toEmail, fullName, rawToken, dynamicBaseUrl);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi gửi email đặt lại mật khẩu bất đồng bộ tới: " + toEmail, e);
            }
        });
    }

    /**
     * Synchronous mail sending logic for password reset.
     */
    public static void sendPasswordResetEmailSync(String toEmail, String fullName, String rawToken, String dynamicBaseUrl)
            throws MessagingException {
        String resetUrl = resolveBaseUrl(dynamicBaseUrl) + "/auth/reset-password?token=" + rawToken;
        String htmlBody = buildPasswordResetEmailHtml(fullName != null ? fullName : "Học viên", resetUrl);
        sendHtmlEmailSync(toEmail, "Đặt lại mật khẩu tài khoản Courson LMS", htmlBody, "đặt lại mật khẩu");
    }

    private static String buildVerificationEmailHtml(String displayName, String verificationUrl) {
        return buildEmailTemplate(
                "Xác thực tài khoản Courson LMS",
                "Kích hoạt tài khoản của bạn",
                displayName,
                "Cảm ơn bạn đã đăng ký tài khoản tại <strong>Courson LMS</strong>. Vui lòng bấm vào nút bên dưới để hoàn tất xác thực email và bắt đầu hành trình học tập:",
                "Xác thực tài khoản",
                verificationUrl,
                "Link xác thực này có hiệu lực trong vòng <strong>24 giờ</strong> và chỉ sử dụng được 1 lần.",
                "Nếu bạn không đăng ký tài khoản này, vui lòng bỏ qua email. Tài khoản sẽ tự động hết hạn."
        );
    }

    private static String buildPasswordResetEmailHtml(String displayName, String resetUrl) {
        return buildEmailTemplate(
                "Đặt lại mật khẩu Courson LMS",
                "Yêu cầu đặt lại mật khẩu",
                displayName,
                "Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản Courson LMS của bạn. Vui lòng bấm vào nút bên dưới để tiến hành tạo mật khẩu mới:",
                "Đặt lại mật khẩu",
                resetUrl,
                "Link đặt lại mật khẩu có hiệu lực trong vòng <strong>24 giờ</strong> và chỉ sử dụng được 1 lần.",
                "Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này. Tài khoản của bạn vẫn được bảo mật an toàn."
        );
    }

    private static String buildEmailTemplate(
            String pageTitle,
            String heading,
            String displayName,
            String introHtml,
            String ctaLabel,
            String ctaUrl,
            String noteHtml,
            String disclaimerText) {
        return "<!DOCTYPE html>"
                + "<html lang=\"vi\">"
                + "<head>"
                + "<meta charset=\"UTF-8\">"
                + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
                + "<title>" + pageTitle + "</title>"
                + "</head>"
                + "<body style=\"margin:0;padding:0;background-color:#F5EFEB;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;color:#1F1F20;\">"
                + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"table-layout:fixed;background-color:#F5EFEB;padding:40px 10px;\">"
                + "  <tr>"
                + "    <td align=\"center\">"
                + "      <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:580px;background:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 10px 30px rgba(0,0,0,0.06);border:1px solid #E5DFD7;\">"
                + "        <!-- Header / Logo -->"
                + "        <tr>"
                + "          <td style=\"background:#1F1F20;padding:32px 40px;text-align:center;\">"
                + "            <div style=\"display:inline-flex;align-items:center;gap:10px;\">"
                + "              <span style=\"display:inline-block;width:38px;height:38px;background:linear-gradient(135deg,#F38020,#FF9D42);border-radius:10px;text-align:center;line-height:38px;font-size:22px;\">☁️</span>"
                + "              <span style=\"font-size:22px;font-weight:800;letter-spacing:0.5px;color:#ffffff;\">COURSON<span style=\"color:#F38020;\">.LMS</span></span>"
                + "            </div>"
                + "          </td>"
                + "        </tr>"
                + "        <!-- Body -->"
                + "        <tr>"
                + "          <td style=\"padding:40px 40px 32px 40px;\">"
                + "            <h2 style=\"margin:0 0 16px 0;font-size:22px;font-weight:700;color:#1F1F20;\">" + heading + "</h2>"
                + "            <p style=\"margin:0 0 16px 0;font-size:15px;line-height:1.6;color:#555555;\">"
                + "              Xin chào <strong>" + escapeHtml(displayName) + "</strong>,"
                + "            </p>"
                + "            <p style=\"margin:0 0 24px 0;font-size:15px;line-height:1.6;color:#555555;\">"
                + "              " + introHtml
                + "            </p>"
                + "            <!-- CTA Button -->"
                + "            <div style=\"text-align:center;margin:32px 0;\">"
                + "              <a href=\"" + ctaUrl + "\" target=\"_blank\" style=\"display:inline-block;background:linear-gradient(135deg,#F38020,#E56B00);color:#ffffff;text-decoration:none;font-size:16px;font-weight:700;padding:14px 36px;border-radius:10px;box-shadow:0 6px 18px rgba(243,128,32,0.35);letter-spacing:0.3px;\">"
                + "                " + ctaLabel
                + "              </a>"
                + "            </div>"
                + "            <!-- Expiration & Security notes -->"
                + "            <div style=\"background:#FFF8F0;border-left:4px solid #F38020;padding:12px 16px;border-radius:6px;margin:24px 0;\">"
                + "              <p style=\"margin:0;font-size:13.5px;color:#A24E00;line-height:1.5;\">"
                + "                ⏰ <strong>Lưu ý:</strong> " + noteHtml
                + "              </p>"
                + "            </div>"
                + "            <p style=\"margin:0;font-size:13px;color:#999999;line-height:1.5;font-style:italic;\">"
                + "              " + disclaimerText
                + "            </p>"
                + "          </td>"
                + "        </tr>"
                + "        <!-- Footer -->"
                + "        <tr>"
                + "          <td style=\"background:#FAF8F5;border-top:1px solid #ECE7E1;padding:20px 40px;text-align:center;\">"
                + "            <p style=\"margin:0;font-size:12px;color:#999999;\">"
                + "              © " + java.time.Year.now().getValue() + " Courson LMS. Mọi quyền được bảo lưu."
                + "            </p>"
                + "          </td>"
                + "        </tr>"
                + "      </table>"
                + "    </td>"
                + "  </tr>"
                + "</table>"
                + "</body>"
                + "</html>";
    }

    private static String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
}