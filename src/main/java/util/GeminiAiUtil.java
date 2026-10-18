package util;

import dto.SettingDto;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Tiện ích tích hợp Google Gemini AI cho Courson LMS:
 * - Tự động phân loại danh mục khóa học chuẩn ngữ nghĩa (Semantic Classification).
 * - Tự động viết mô tả tóm tắt khóa học chuyên nghiệp, hấp dẫn (Course Description Generation).
 * - Sử dụng thuần java.net.http.HttpClient (Java 17) không tốn thêm bất kỳ thư viện ngoài nào.
 * - Hỗ trợ cơ chế tự phục hồi (Graceful Fallback) nếu gặp sự cố mạng hoặc hết quota.
 */
public final class GeminiAiUtil {
    private static final Logger LOGGER = Logger.getLogger(GeminiAiUtil.class.getName());
    private static String API_KEY = "";
    private static String MODEL = "gemini-2.5-flash-lite";
    private static int TIMEOUT_SECONDS = 5;

    private static final HttpClient HTTP_CLIENT = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(3))
            .build();

    static {
        loadConfig();
    }

    private GeminiAiUtil() {}

    private static void loadConfig() {
        try (InputStream is = GeminiAiUtil.class.getClassLoader().getResourceAsStream("ai.properties")) {
            if (is != null) {
                Properties prop = new Properties();
                prop.load(is);
                if (prop.containsKey("gemini.api.key")) {
                    API_KEY = prop.getProperty("gemini.api.key").trim();
                }
                if (prop.containsKey("gemini.model")) {
                    MODEL = prop.getProperty("gemini.model").trim();
                }
                if (prop.containsKey("gemini.timeout.seconds")) {
                    try {
                        TIMEOUT_SECONDS = Integer.parseInt(prop.getProperty("gemini.timeout.seconds").trim());
                    } catch (NumberFormatException ignored) {}
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Không thể đọc ai.properties, sử dụng cấu hình mặc định hoặc biến môi trường", e);
        }

        if (System.getenv("GEMINI_API_KEY") != null && !System.getenv("GEMINI_API_KEY").trim().isEmpty()) {
            API_KEY = System.getenv("GEMINI_API_KEY").trim();
        }
        if (System.getenv("GEMINI_MODEL") != null && !System.getenv("GEMINI_MODEL").trim().isEmpty()) {
            MODEL = System.getenv("GEMINI_MODEL").trim();
        }
    }

    public static boolean isAvailable() {
        return API_KEY != null && !API_KEY.isEmpty();
    }

    public static class CategoryResult {
        private final Long categoryId;
        private final String categoryName;
        private final String suggestedDescription;

        public CategoryResult(Long categoryId, String categoryName, String suggestedDescription) {
            this.categoryId = categoryId;
            this.categoryName = categoryName;
            this.suggestedDescription = suggestedDescription;
        }

        public Long getCategoryId() {
            return categoryId;
        }

        public String getCategoryName() {
            return categoryName;
        }

        public String getSuggestedDescription() {
            return suggestedDescription;
        }
    }

    /**
     * Phân loại danh mục khóa học thông minh VÀ tự động viết mô tả bằng Gemini AI trong cùng 1 request:
     * @param courseTitle Tiêu đề khóa học hoặc tiêu đề Playlist
     * @param courseContext Danh sách tiêu đề bài giảng hoặc đoạn text mô tả
     * @param categories Danh sách các danh mục đang hoạt động trong hệ thống
     * @return CategoryResult nếu phân loại thành công, hoặc null nếu có lỗi/mất mạng
     */
    public static CategoryResult classifyCourse(String courseTitle, String courseContext, List<SettingDto> categories) {
        if (!isAvailable() || categories == null || categories.isEmpty()) {
            return null;
        }

        try {
            StringBuilder catListJson = new StringBuilder("[");
            for (int i = 0; i < categories.size(); i++) {
                SettingDto c = categories.get(i);
                if (i > 0) catListJson.append(",");
                catListJson.append("{\"id\":").append(c.getId())
                           .append(",\"name\":\"").append(escapeJson(c.getName())).append("\"}");
            }
            catListJson.append("]");

            StringBuilder contentBuilder = new StringBuilder();
            if (courseTitle != null && !courseTitle.trim().isEmpty()) {
                contentBuilder.append("Tiêu đề: \"").append(courseTitle.trim()).append("\". ");
            }
            if (courseContext != null && !courseContext.trim().isEmpty()) {
                String ctx = courseContext.length() > 600 ? courseContext.substring(0, 600) : courseContext;
                contentBuilder.append("Nội dung bài học / trích đoạn: \"").append(ctx.trim()).append("\".");
            }

            String prompt = "Bạn là chuyên gia giáo dục và phân loại khóa học. Dựa vào nội dung khóa học sau: "
                    + contentBuilder.toString()
                    + " Hãy thực hiện 2 nhiệm vụ:\n"
                    + "1. Chọn DUY NHẤT 1 danh mục phù hợp nhất từ danh sách: " + catListJson.toString() + "\n"
                    + "2. Viết một đoạn mô tả tóm tắt khóa học súc tích, chuyên nghiệp và hấp dẫn (khoảng 2-3 câu, tối đa 250 ký tự), nêu bật giá trị thực tiễn cho học viên.\n"
                    + "Chỉ trả về JSON định dạng duy nhất: {\"categoryId\": <id>, \"categoryName\": \"<name>\", \"suggestedDescription\": \"<đoạn mô tả ngắn>\"} không kèm giải thích hay markdown.";

            String requestBody = "{"
                    + "\"contents\":[{\"parts\":[{\"text\":\"" + escapeJson(prompt) + "\"}]}],"
                    + "\"generationConfig\":{\"responseMimeType\":\"application/json\",\"thinkingConfig\":{\"thinkingBudget\":0},\"temperature\":0.2}"
                    + "}";

            String[] candidateModels = MODEL.equals("gemini-2.5-flash-lite")
                    ? new String[]{"gemini-2.5-flash-lite", "gemini-2.5-flash", "gemini-flash-latest"}
                    : new String[]{MODEL, "gemini-2.5-flash-lite"};

            for (String modelName : candidateModels) {
                String url = "https://generativelanguage.googleapis.com/v1beta/models/" + modelName + ":generateContent?key=" + API_KEY;
                HttpRequest req = HttpRequest.newBuilder()
                        .uri(URI.create(url))
                        .header("Content-Type", "application/json")
                        .timeout(Duration.ofSeconds(TIMEOUT_SECONDS))
                        .POST(HttpRequest.BodyPublishers.ofString(requestBody, StandardCharsets.UTF_8))
                        .build();

                HttpResponse<String> resp = HTTP_CLIENT.send(req, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
                if (resp.statusCode() == 200) {
                    String body = resp.body();
                    String idStr = extractField(body, "categoryId");
                    String nameStr = extractField(body, "categoryName");
                    String descStr = extractField(body, "suggestedDescription");

                    if (idStr != null && nameStr != null) {
                        long catId = Long.parseLong(idStr);
                        return new CategoryResult(catId, nameStr, descStr != null ? descStr.trim() : null);
                    }
                } else if (resp.statusCode() != 429 && resp.statusCode() != 503) {
                    LOGGER.log(Level.WARNING, "Gemini API ({0}) trả về HTTP {1}: {2}", new Object[]{modelName, resp.statusCode(), resp.body()});
                    break;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi khi gọi Gemini AI để phân loại khóa học (sẽ fallback về heuristic): {0}", e.getMessage());
        }

        return null;
    }

    /**
     * Tự động viết mô tả tóm tắt khóa học chuyên nghiệp bằng Gemini AI:
     * @param courseTitle Tiêu đề khóa học
     * @param categoryName Tên danh mục (tùy chọn)
     * @return Đoạn văn bản mô tả (hoặc null nếu lỗi)
     */
    public static String generateDescription(String courseTitle, String categoryName) {
        if (!isAvailable() || courseTitle == null || courseTitle.trim().isEmpty()) {
            return null;
        }

        try {
            String prompt = "Bạn là chuyên gia giáo dục. Hãy viết 1 đoạn mô tả tóm tắt khóa học ngắn gọn, chuyên nghiệp và hấp dẫn (khoảng 2-3 câu, tối đa 220 ký tự) cho khóa học: \""
                    + escapeJson(courseTitle.trim()) + "\""
                    + (categoryName != null && !categoryName.trim().isEmpty() ? " thuộc danh mục \"" + escapeJson(categoryName.trim()) + "\"" : "")
                    + ". Nêu bật lợi ích thực tế cho học viên.\n"
                    + "Chỉ trả về JSON duy nhất: {\"description\": \"<nội dung mô tả>\"} không kèm định dạng markdown.";

            String requestBody = "{"
                    + "\"contents\":[{\"parts\":[{\"text\":\"" + escapeJson(prompt) + "\"}]}],"
                    + "\"generationConfig\":{\"responseMimeType\":\"application/json\",\"thinkingConfig\":{\"thinkingBudget\":0},\"temperature\":0.3}"
                    + "}";

            String[] candidateModels = MODEL.equals("gemini-2.5-flash-lite")
                    ? new String[]{"gemini-2.5-flash-lite", "gemini-2.5-flash", "gemini-flash-latest"}
                    : new String[]{MODEL, "gemini-2.5-flash-lite"};

            for (String modelName : candidateModels) {
                String url = "https://generativelanguage.googleapis.com/v1beta/models/" + modelName + ":generateContent?key=" + API_KEY;
                HttpRequest req = HttpRequest.newBuilder()
                        .uri(URI.create(url))
                        .header("Content-Type", "application/json")
                        .timeout(Duration.ofSeconds(TIMEOUT_SECONDS))
                        .POST(HttpRequest.BodyPublishers.ofString(requestBody, StandardCharsets.UTF_8))
                        .build();

                HttpResponse<String> resp = HTTP_CLIENT.send(req, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
                if (resp.statusCode() == 200) {
                    String desc = extractField(resp.body(), "description");
                    if (desc != null && !desc.trim().isEmpty()) {
                        return desc.trim();
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi khi gọi Gemini AI sinh mô tả khóa học: {0}", e.getMessage());
        }
        return null;
    }

    private static String extractField(String json, String field) {
        Pattern p = Pattern.compile("\\\\?\"" + Pattern.quote(field) + "\\\\?\"\\s*:\\s*(?:\\\\?\"(.*?)(?<!\\\\)\\\\?\"|([0-9]+))", Pattern.DOTALL);
        Matcher m = p.matcher(json);
        if (m.find()) {
            String val = m.group(1) != null ? m.group(1) : m.group(2);
            if (val != null) {
                return val.replace("\\n", "\n")
                          .replace("\\\"", "\"")
                          .replace("\\\\", "\\");
            }
        }
        return null;
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", " ")
                .replace("\r", " ")
                .replace("\t", " ");
    }
}
