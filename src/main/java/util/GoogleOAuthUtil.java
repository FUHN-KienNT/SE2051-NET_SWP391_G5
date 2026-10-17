package util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.logging.Logger;

/**
 * Utility class thực hiện Google OAuth 2.0 Authorization Code Flow
 * mà không cần thư viện ngoài — chỉ dùng HttpURLConnection thuần Java.
 *
 * Flow:
 *  1. buildAuthUrl()        → redirect trình duyệt người dùng tới Google
 *  2. exchangeCodeForToken() → server đổi `code` lấy access_token
 *  3. getUserInfo()          → dùng access_token gọi Google UserInfo API
 */
public final class GoogleOAuthUtil {

    private static final Logger LOGGER = Logger.getLogger(GoogleOAuthUtil.class.getName());

    // ── Google OAuth 2.0 endpoints ──
    private static final String AUTH_ENDPOINT  = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String TOKEN_ENDPOINT = "https://oauth2.googleapis.com/token";
    private static final String USERINFO_URL   = "https://www.googleapis.com/oauth2/v3/userinfo";

    private static volatile Properties props;

    private GoogleOAuthUtil() { }

    // ────────────────────────────────────────────────
    //  Config loading
    // ────────────────────────────────────────────────
    private static Properties getProperties() {
        if (props == null) {
            synchronized (GoogleOAuthUtil.class) {
                if (props == null) {
                    Properties p = new Properties();
                    try (InputStream is = GoogleOAuthUtil.class
                            .getClassLoader()
                            .getResourceAsStream("google-oauth.properties")) {
                        if (is != null) {
                            p.load(is);
                        } else {
                            LOGGER.warning("google-oauth.properties not found on classpath");
                        }
                    } catch (IOException e) {
                        LOGGER.warning("Cannot load google-oauth.properties: " + e.getMessage());
                    }
                    props = p;
                }
            }
        }
        return props;
    }

    public static String getClientId() {
        return getProperties().getProperty("google.client.id", "");
    }

    private static String getClientSecret() {
        return getProperties().getProperty("google.client.secret", "");
    }

    public static String getRedirectUri() {
        return getProperties().getProperty("google.redirect.uri", "");
    }

    /** Trả về true nếu credentials đã được cấu hình (không phải placeholder). */
    public static boolean isConfigured() {
        String id = getClientId();
        String secret = getClientSecret();
        return id != null && !id.isBlank() && !id.equals("YOUR_GOOGLE_CLIENT_ID")
            && secret != null && !secret.isBlank() && !secret.equals("YOUR_GOOGLE_CLIENT_SECRET");
    }

    // ────────────────────────────────────────────────
    //  Step 1 – Build Google authorization URL
    // ────────────────────────────────────────────────
    /**
     * Tạo URL để redirect người dùng tới trang đăng nhập Google.
     *
     * @param state CSRF-protection token (nên lưu vào session trước khi redirect)
     */
    public static String buildAuthUrl(String state) throws IOException {
        return AUTH_ENDPOINT
            + "?client_id=" + encode(getClientId())
            + "&redirect_uri=" + encode(getRedirectUri())
            + "&response_type=code"
            + "&scope=" + encode("openid email profile")
            + "&access_type=offline"
            + "&prompt=select_account"
            + (state != null ? "&state=" + encode(state) : "");
    }

    // ────────────────────────────────────────────────
    //  Step 2 – Exchange authorization code → access_token
    // ────────────────────────────────────────────────
    /**
     * POST tới Google token endpoint để đổi {@code code} lấy access_token.
     *
     * @return access_token string
     * @throws IOException nếu HTTP call thất bại
     */
    public static String exchangeCodeForToken(String code) throws IOException {
        String body = "code=" + encode(code)
            + "&client_id=" + encode(getClientId())
            + "&client_secret=" + encode(getClientSecret())
            + "&redirect_uri=" + encode(getRedirectUri())
            + "&grant_type=authorization_code";

        String json = postForm(TOKEN_ENDPOINT, body);
        return extractJsonField(json, "access_token");
    }

    // ────────────────────────────────────────────────
    //  Step 3 – Fetch user info
    // ────────────────────────────────────────────────
    /**
     * Gọi Google UserInfo API và trả về thông tin người dùng dưới dạng {@link GoogleUserInfo}.
     */
    public static GoogleUserInfo getUserInfo(String accessToken) throws IOException {
        String json = getJson(USERINFO_URL, accessToken);
        GoogleUserInfo info = new GoogleUserInfo();
        info.setGoogleId(extractJsonField(json, "sub"));
        info.setEmail(extractJsonField(json, "email"));
        info.setName(extractJsonField(json, "name"));
        info.setPicture(extractJsonField(json, "picture"));
        // email_verified là boolean trong JSON
        String verifiedStr = extractJsonField(json, "email_verified");
        info.setEmailVerified("true".equalsIgnoreCase(verifiedStr));
        return info;
    }

    // ────────────────────────────────────────────────
    //  HTTP helpers
    // ────────────────────────────────────────────────
    private static String postForm(String urlStr, String body) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setConnectTimeout(10_000);
        conn.setReadTimeout(10_000);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }

        int status = conn.getResponseCode();
        InputStream is = (status >= 200 && status < 300)
            ? conn.getInputStream()
            : conn.getErrorStream();

        String response = readStream(is);
        if (status < 200 || status >= 300) {
            throw new IOException("Google token endpoint returned HTTP " + status + ": " + response);
        }
        return response;
    }

    private static String getJson(String urlStr, String bearerToken) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setConnectTimeout(10_000);
        conn.setReadTimeout(10_000);
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + bearerToken);

        int status = conn.getResponseCode();
        InputStream is = (status >= 200 && status < 300)
            ? conn.getInputStream()
            : conn.getErrorStream();

        String response = readStream(is);
        if (status < 200 || status >= 300) {
            throw new IOException("Google UserInfo API returned HTTP " + status + ": " + response);
        }
        return response;
    }

    private static String readStream(InputStream is) throws IOException {
        if (is == null) return "";
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            return sb.toString();
        }
    }

    // ────────────────────────────────────────────────
    //  Minimal JSON field extractor (không dùng thư viện JSON ngoài)
    //  Chỉ dùng cho JSON phẳng (flat JSON) từ Google API.
    // ────────────────────────────────────────────────
    /**
     * Trích xuất giá trị của một field từ JSON phẳng (không nested).
     * Hỗ trợ cả string ("field":"value") và scalar (field:true/false/number).
     */
    static String extractJsonField(String json, String field) {
        if (json == null || field == null) return null;
        // Try quoted string value first: "field": "value"
        String quotedPattern = "\"" + field + "\"";
        int idx = json.indexOf(quotedPattern);
        if (idx < 0) return null;

        int colonIdx = json.indexOf(':', idx + quotedPattern.length());
        if (colonIdx < 0) return null;

        // Skip whitespace after colon
        int start = colonIdx + 1;
        while (start < json.length() && json.charAt(start) == ' ') start++;
        if (start >= json.length()) return null;

        if (json.charAt(start) == '"') {
            // String value
            int end = start + 1;
            while (end < json.length()) {
                if (json.charAt(end) == '"' && json.charAt(end - 1) != '\\') break;
                end++;
            }
            return json.substring(start + 1, end);
        } else {
            // Non-string value (boolean, number, null)
            int end = start;
            while (end < json.length() && ",}\n\r".indexOf(json.charAt(end)) < 0) {
                end++;
            }
            return json.substring(start, end).trim();
        }
    }

    private static String encode(String s) throws IOException {
        return URLEncoder.encode(s == null ? "" : s, StandardCharsets.UTF_8);
    }

    // ────────────────────────────────────────────────
    //  DTO
    // ────────────────────────────────────────────────
    public static class GoogleUserInfo {
        private String googleId;
        private String email;
        private String name;
        private String picture;
        private boolean emailVerified;

        public String getGoogleId()      { return googleId; }
        public void setGoogleId(String v){ googleId = v; }
        public String getEmail()         { return email; }
        public void setEmail(String v)   { email = v; }
        public String getName()          { return name; }
        public void setName(String v)    { name = v; }
        public String getPicture()       { return picture; }
        public void setPicture(String v) { picture = v; }
        public boolean isEmailVerified() { return emailVerified; }
        public void setEmailVerified(boolean v){ emailVerified = v; }

        @Override
        public String toString() {
            return "GoogleUserInfo{email='" + email + "', name='" + name + "', verified=" + emailVerified + "}";
        }
    }
}
