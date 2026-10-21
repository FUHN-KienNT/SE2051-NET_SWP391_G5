package util;

import dto.SettingDto;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.ArrayList;
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

    public static class ModuleGroup {
        private final String moduleTitle;
        private final List<Integer> lessonIndices;

        public ModuleGroup(String moduleTitle, List<Integer> lessonIndices) {
            this.moduleTitle = moduleTitle;
            this.lessonIndices = lessonIndices != null ? lessonIndices : new ArrayList<>();
        }

        public String getModuleTitle() {
            return moduleTitle;
        }

        public List<Integer> getLessonIndices() {
            return lessonIndices;
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

    /**
     * Dùng Gemini AI để gợi ý tên Chương học (Module) phù hợp dựa vào tiêu đề khóa học và bài giảng:
     */
    public static String suggestModuleTitle(String courseTitle, String lessonTitle) {
        if (!isAvailable() || (lessonTitle == null && courseTitle == null)) {
            return "Chương 1: Khởi động & Giới thiệu";
        }

        try {
            String prompt = "Bạn là chuyên gia sư phạm. Cho khóa học: \"" + escapeJson(courseTitle != null ? courseTitle : "") + "\""
                    + ", bài học: \"" + escapeJson(lessonTitle != null ? lessonTitle : "") + "\".\\n"
                    + "Hãy gợi ý 1 tên Chương học (Module) ngắn gọn, súc tích (tối đa 40 ký tự, ví dụ: 'Chương 1: Tổng quan & Cài đặt').\\n"
                    + "Chỉ trả về JSON duy nhất: {\\\"moduleTitle\\\": \\\"Chương 1: ...\\\"} không kèm markdown.";

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
                    String title = extractField(resp.body(), "moduleTitle");
                    if (title != null && !title.trim().isEmpty()) {
                        return title.trim();
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi khi gọi Gemini AI gợi ý tên module: {0}", e.getMessage());
        }
        return "Chương 1: Khởi động & Giới thiệu";
    }

    /**
     * Tự động đọc danh sách tiêu đề bài học và dùng Gemini AI để gom nhóm vào các Module (Chương học)
     * hợp lý và khoa học theo đúng tiến trình sư phạm:
     * @param courseTitle Tiêu đề khóa học
     * @param lessonTitles Danh sách tiêu đề các bài học theo thứ tự 1..N
     * @return Danh sách các ModuleGroup (chứa tên module và danh sách chỉ mục bài học 1-based)
     */
    public static List<ModuleGroup> groupLessonsIntoModules(String courseTitle, List<String> lessonTitles) {
        if (lessonTitles == null || lessonTitles.isEmpty()) {
            return new ArrayList<>();
        }
        int total = lessonTitles.size();
        if (total <= 4) {
            List<Integer> all = new ArrayList<>();
            for (int i = 1; i <= total; i++) all.add(i);
            List<ModuleGroup> single = new ArrayList<>();
            single.add(new ModuleGroup("Chương 1: Tổng quan & Bài học", all));
            return single;
        }

        if (isAvailable()) {
            try {
                StringBuilder sb = new StringBuilder();
                sb.append("Bạn là chuyên gia thiết kế chương trình học (Curriculum Designer).\n");
                sb.append("Khóa học: \"").append(escapeJson(courseTitle != null ? courseTitle : "Khóa học")).append("\"\n");
                sb.append("Danh sách ").append(total).append(" bài học theo đúng thứ tự:\n");
                for (int i = 0; i < total; i++) {
                    sb.append(i + 1).append(". ").append(escapeJson(lessonTitles.get(i))).append("\n");
                }
                sb.append("\nNhiệm vụ: Phân tích tiêu đề các bài học và gom nhóm các bài học theo đúng thứ tự thành các Chương học (Module) logic, khoa học (thông thường từ 2 đến 6 chương, mỗi chương có từ 3 đến 8 bài). Tuyệt đối không xáo trộn thứ tự bài học.\n");
                sb.append("Tên mỗi chương bắt đầu bằng 'Chương X: <Tên chủ đề ngắn gọn, súc tích>'.\n");
                sb.append("Chỉ trả về JSON thuần định dạng mảng (không markdown, không giải thích):\n");
                sb.append("[\n  {\"moduleTitle\": \"Chương 1: ...\", \"lessonIndices\": [1, 2, 3]},\n  {\"moduleTitle\": \"Chương 2: ...\", \"lessonIndices\": [4, 5, 6]}\n]\n");
                sb.append("Lưu ý: lessonIndices là mảng số thứ tự bài học từ 1 đến ").append(total).append(". Mọi bài học phải thuộc đúng 1 chương.");

                String requestBody = "{"
                        + "\"contents\":[{\"parts\":[{\"text\":\"" + escapeJson(sb.toString()) + "\"}]}],"
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
                            .timeout(Duration.ofSeconds(TIMEOUT_SECONDS + 2))
                            .POST(HttpRequest.BodyPublishers.ofString(requestBody, StandardCharsets.UTF_8))
                            .build();

                    HttpResponse<String> resp = HTTP_CLIENT.send(req, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
                    if (resp.statusCode() == 200) {
                        String body = resp.body();
                        Pattern pattern = Pattern.compile("\\{\\s*\"moduleTitle\"\\s*:\\s*\"(.*?)\"\\s*,\\s*\"lessonIndices\"\\s*:\\s*\\[([0-9,\\s]+)\\]\\s*\\}", Pattern.DOTALL);
                        Matcher matcher = pattern.matcher(body);
                        List<ModuleGroup> parsedGroups = new ArrayList<>();
                        boolean[] covered = new boolean[total + 1];
                        while (matcher.find()) {
                            String modTitle = matcher.group(1).replace("\\\"", "\"").trim();
                            String idxListStr = matcher.group(2);
                            List<Integer> indices = new ArrayList<>();
                            String[] parts = idxListStr.split(",");
                            for (String p : parts) {
                                try {
                                    int idx = Integer.parseInt(p.trim());
                                    if (idx >= 1 && idx <= total && !covered[idx]) {
                                        indices.add(idx);
                                        covered[idx] = true;
                                    }
                                } catch (NumberFormatException ignored) {}
                            }
                            if (!indices.isEmpty()) {
                                parsedGroups.add(new ModuleGroup(modTitle, indices));
                            }
                        }

                        List<Integer> missed = new ArrayList<>();
                        for (int i = 1; i <= total; i++) {
                            if (!covered[i]) missed.add(i);
                        }
                        if (!missed.isEmpty()) {
                            if (!parsedGroups.isEmpty()) {
                                parsedGroups.get(parsedGroups.size() - 1).getLessonIndices().addAll(missed);
                            } else {
                                parsedGroups.add(new ModuleGroup("Chương 1: Tổng quan & Bài học", missed));
                            }
                        }

                        if (!parsedGroups.isEmpty()) {
                            return parsedGroups;
                        }
                    }
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Lỗi khi gọi Gemini AI gom nhóm module: {0}", e.getMessage());
            }
        }

        // Graceful Fallback: tự động chia thành các module 4-6 bài học
        int perModule = total <= 8 ? 4 : (total <= 15 ? 5 : 6);
        List<ModuleGroup> fallback = new ArrayList<>();
        int modIndex = 1;
        for (int i = 1; i <= total; i += perModule) {
            List<Integer> indices = new ArrayList<>();
            for (int j = i; j < Math.min(i + perModule, total + 1); j++) {
                indices.add(j);
            }
            String title;
            if (modIndex == 1) title = "Chương 1: Khởi động & Nền tảng";
            else if (modIndex == 2) title = "Chương 2: Kiến thức cốt lõi";
            else if (modIndex == 3) title = "Chương 3: Thực hành & Nâng cao";
            else if (modIndex == 4) title = "Chương 4: Xây dựng dự án thực tế";
            else title = "Chương " + modIndex + ": Mở rộng & Hoàn thiện";
            fallback.add(new ModuleGroup(title, indices));
            modIndex++;
        }
        return fallback;
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
