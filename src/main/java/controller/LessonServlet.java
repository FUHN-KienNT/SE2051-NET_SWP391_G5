package controller;

import dao.CourseDao;
import dao.LessonDao;
import dao.LessonProgressDao;
import dao.ModuleDao;
import dao.RegistrationDao;
import dto.CourseDto;
import dto.LessonDto;
import dto.ModuleDto;
import dto.UserDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import service.CourseService;
import util.SessionUtil;

/**
 * Controller phụ trách các màn hình Lesson Management (BF-04) của Toàn:
 * - Expert Dashboard (II.4.3)
 * - Lesson List (II.4.1)
 * - Lesson Detail / Editor (II.4.1)
 */
@WebServlet(name = "LessonServlet", urlPatterns = {"/expert/*"})
public class LessonServlet extends HttpServlet {
    private CourseService courseService;

    // =========================================================================
    // 1. VÒNG ĐỜI & ĐIỀU HƯỚNG REQUEST (LIFECYCLE & ROUTING)
    // =========================================================================

    /**
     * Khởi tạo Servlet: Tạo đối tượng CourseService và nạp các DAO truy vấn CSDL.
     * Hàm này chỉ chạy 1 lần duy nhất khi Tomcat nạp Servlet vào bộ nhớ.
     */
    @Override
    public void init() throws ServletException {
        this.courseService = new CourseService(
                new CourseDao(), new ModuleDao(), new LessonDao(),
                new LessonProgressDao(), new RegistrationDao()
        );
    }

    /**
     * Tiếp nhận tất cả các HTTP GET request (truy cập xem trang từ trình duyệt).
     * Bóc tách action từ URL (ví dụ: /expert/lessons -> action = "lessons").
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "dashboard";
        processAction(action, req, resp);
    }

    /**
     * Tiếp nhận tất cả các HTTP POST request (khi người dùng nộp form lưu/xóa dữ liệu).
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "dashboard";
        processAction(action, req, resp);
    }

    /**
     * Bộ phân loại hành động (Router Switchboard):
     * Điều hướng request đến hàm xử lý tương ứng dựa vào tên action.
     */
    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // [Xử lý Flash Messages]: Lấy thông báo lỗi/thành công từ Session (nếu có) và nạp vào Request, tự động xóa khỏi Session
        String flashError = SessionUtil.popFlashError(req);
        if (flashError != null) {
            req.setAttribute("errorMessage", flashError);
        }
        String flashSuccess = SessionUtil.popFlashSuccess(req);
        if (flashSuccess != null) {
            req.setAttribute("successMessage", flashSuccess);
        }

        switch (action) {
            case "dashboard":
                showExpertDashboard(req, resp);
                break;
            case "lessons":
                showLessonList(req, resp);
                break;
            case "lesson-detail":
                showLessonDetail(req, resp);
                break;
            case "save-lesson":
                saveLesson(req, resp);
                break;
            case "delete-lesson":
                deleteLesson(req, resp);
                break;
            case "save-module":
                saveModule(req, resp);
                break;
            case "delete-module":
                deleteModule(req, resp);
                break;
            case "save-course":
                saveCourse(req, resp);
                break;
            case "batch-save-lessons":
                batchSaveLessons(req, resp);
                break;
            case "delete-course":
                deleteCourse(req, resp);
                break;
            case "get-course":
                getCourseJson(req, resp);
                break;
            case "save-lesson-draft":
                saveLessonDraft(req, resp);
                break;
            case "get-lesson-draft":
                getLessonDraft(req, resp);
                break;
            case "preview-batch-videos":
                previewBatchVideos(req, resp);
                break;
            default:
                showExpertDashboard(req, resp);
                break;
        }
    }

    // =========================================================================
    // 2. NHÓM QUẢN LÝ EXPERT DASHBOARD & KHÓA HỌC (COURSE MANAGEMENT)
    // =========================================================================

    /**
     * [Màn hình II.4.3] Hiển thị trang Expert Dashboard:
     * - Kiểm tra phiên đăng nhập (Session).
     * - Lấy danh sách khóa học thuộc quyền phụ trách của Expert hiện tại.
     * - Lấy danh mục thể loại khóa học để phục vụ form tạo khóa học mới.
     * - Chuyển tiếp (forward) dữ liệu sang views/expert/dashboard.jsp.
     */
    private void showExpertDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        List<CourseDto> courses = courseService.getManagedCourses(currentUser.getId());
        List<dto.SettingDto> categories = courseService.getCategories();
        req.setAttribute("courses", courses);
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/WEB-INF/views/expert/dashboard.jsp").forward(req, resp);
    }

    /**
     * [Tối ưu hiệu năng & Indexed Query]:
     * Lấy trực tiếp thông tin 1 khóa học bằng index (ID) duy nhất trong CSDL
     * trả về JSON để hiển thị lên Modal sửa khóa học thay vì phải tải toàn bộ thông tin
     * tất cả các khóa học vào DOM.
     */
    private void getCourseJson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"error\":\"Vui lòng đăng nhập để tiếp tục.\"}");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"error\":\"Thiếu ID khóa học cần lấy thông tin.\"}");
            return;
        }

        try {
            long courseId = Long.parseLong(idStr.trim());
            // [IDOR Defense]: Kiểm tra quyền hạn của Expert đối với khóa học
            courseService.checkCourseOwnership(courseId, currentUser);

            // Truy vấn trực tiếp bản ghi bằng index khóa chính trong CSDL O(1)
            CourseDto course = courseService.getCourseById(courseId);

            resp.setContentType("application/json;charset=UTF-8");
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"id\":").append(course.getId()).append(",");
            json.append("\"title\":\"").append(escapeJson(course.getTitle())).append("\",");
            json.append("\"categoryId\":").append(course.getCategoryId() != null ? course.getCategoryId() : "null").append(",");
            json.append("\"categoryName\":\"").append(escapeJson(course.getCategoryName())).append("\",");
            json.append("\"price\":").append(course.getPrice() != null ? course.getPrice() : "0").append(",");
            json.append("\"status\":\"").append(course.getStatus() != null ? course.getStatus().name() : "DRAFT").append("\",");
            json.append("\"description\":\"").append(escapeJson(course.getDescription())).append("\"");
            json.append("}");

            resp.getWriter().write(json.toString());
        } catch (SecurityException se) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"error\":\"" + escapeJson(se.getMessage()) + "\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }

    /**
     * [Tự động lưu nháp sau mỗi 5 phút - Backup Session]:
     * Nhận yêu cầu tự động lưu bản nháp từ màn hình soạn thảo bài học,
     * lưu trữ tạm thời trong Session để bảo toàn dữ liệu tránh mất mát bài khi chưa kịp ấn lưu.
     */
    private void saveLessonDraft(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"error\":\"Chưa đăng nhập\"}");
            return;
        }

        String courseId = req.getParameter("courseId");
        String lessonId = req.getParameter("lessonId");
        String title = req.getParameter("title");
        String moduleId = req.getParameter("moduleId");
        String orderIndex = req.getParameter("orderIndex");
        String videoUrl = req.getParameter("videoUrl");
        String documentUrl = req.getParameter("documentUrl");
        String content = req.getParameter("content");

        String draftKey = "draft_lesson_" + (courseId != null ? courseId : "0") + "_" + (lessonId != null && !lessonId.trim().isEmpty() ? lessonId.trim() : "new");
        java.util.Map<String, String> draft = new java.util.HashMap<>();
        draft.put("courseId", courseId != null ? courseId : "");
        draft.put("lessonId", lessonId != null ? lessonId : "");
        draft.put("title", title != null ? title : "");
        draft.put("moduleId", moduleId != null ? moduleId : "");
        draft.put("orderIndex", orderIndex != null ? orderIndex : "1");
        draft.put("videoUrl", videoUrl != null ? videoUrl : "");
        draft.put("documentUrl", documentUrl != null ? documentUrl : "");
        draft.put("content", content != null ? content : "");
        draft.put("savedAt", java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy")));

        req.getSession().setAttribute(draftKey, draft);

        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{\"success\":true,\"savedAt\":\"" + draft.get("savedAt") + "\"}");
    }

    /**
     * [Khôi phục bản nháp từ Session]:
     */
    private void getLessonDraft(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String courseId = req.getParameter("courseId");
        String lessonId = req.getParameter("lessonId");
        String draftKey = "draft_lesson_" + (courseId != null ? courseId : "0") + "_" + (lessonId != null && !lessonId.trim().isEmpty() ? lessonId.trim() : "new");

        @SuppressWarnings("unchecked")
        java.util.Map<String, String> draft = (java.util.Map<String, String>) req.getSession().getAttribute(draftKey);
        resp.setContentType("application/json;charset=UTF-8");
        if (draft == null) {
            resp.getWriter().write("{\"exists\":false}");
            return;
        }
        StringBuilder json = new StringBuilder("{\"exists\":true");
        for (java.util.Map.Entry<String, String> entry : draft.entrySet()) {
            json.append(",\"").append(entry.getKey()).append("\":\"").append(escapeJson(entry.getValue())).append("\"");
        }
        json.append("}");
        resp.getWriter().write(json.toString());
    }

    /**
     * [AJAX API]: Xem trước danh sách bài học bóc tách từ nhiều URL hoặc Playlist YouTube.
     * Tag tìm kiếm: #YOUTUBE_PLAYLIST_IMPORT #PREVIEW_BATCH
     */
    private void previewBatchVideos(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String batchText = req.getParameter("batchText");
        List<LessonDto> lessons = CourseService.parseBatchVideoText(batchText);

        resp.setContentType("application/json;charset=UTF-8");
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < lessons.size(); i++) {
            LessonDto l = lessons.get(i);
            if (i > 0) sb.append(",");
            String vidId = "";
            if (l.getVideoUrl() != null && l.getVideoUrl().contains("/embed/")) {
                vidId = l.getVideoUrl().substring(l.getVideoUrl().lastIndexOf("/embed/") + 7);
            }
            sb.append("{")
              .append("\"orderIndex\":").append(l.getOrderIndex()).append(",")
              .append("\"title\":\"").append(escapeJson(l.getTitle())).append("\",")
              .append("\"videoUrl\":\"").append(escapeJson(l.getVideoUrl())).append("\",")
              .append("\"videoId\":\"").append(escapeJson(vidId)).append("\"")
              .append("}");
        }
        sb.append("]");
        resp.getWriter().write(sb.toString());
    }

    /**
     * Tạo mới hoặc Cập nhật thông tin Khóa học:
     * - [IDOR Defense]: Nếu chỉnh sửa khóa học cũ (id != null), kiểm tra quyền sở hữu của user.
     * - Đọc các tham số: tiêu đề, mô tả, danh mục, giá học phí.
     * - Khóa học do Expert tạo mới luôn có trạng thái DRAFT chờ Manager duyệt.
     * - Nếu có kèm danh sách link video (batchVideoText) thì tự động bóc tách tạo bài học ngay.
     * - [Flash Message]: Dùng session flash attributes thay vì truyền error qua URL.
     */
    private void saveCourse(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        CourseDto dto = new CourseDto();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            long courseId = Long.parseLong(idStr.trim());
            try {
                // [IDOR Defense]: Kiểm tra quyền sở hữu khóa học trước khi sửa
                courseService.checkCourseOwnership(courseId, currentUser);
                dto.setId(courseId);
                CourseDto existing = courseService.getCourseDetail(dto.getId());
                dto.setStatus(existing.getStatus());
                dto.setManagerId(existing.getManagerId());
            } catch (SecurityException se) {
                SessionUtil.setFlashError(req, se.getMessage());
                resp.sendRedirect(req.getContextPath() + "/expert/dashboard");
                return;
            } catch (Exception ignored) {
                dto.setStatus(entity.enums.CourseStatus.DRAFT);
            }
        } else {
            // Khóa học mới tạo bởi Expert luôn ở trạng thái DRAFT để chờ Quản lý duyệt
            dto.setStatus(entity.enums.CourseStatus.DRAFT);
            dto.setManagerId(2L); // ID Manager mặc định
        }

        dto.setTitle(req.getParameter("title"));
        dto.setDescription(req.getParameter("description"));
        String catIdStr = req.getParameter("categoryId");
        String customCategory = req.getParameter("customCategory");
        if (customCategory != null && !customCategory.trim().isEmpty()) {
            dto.setCategoryId(courseService.getOrCreateCategory(customCategory));
        } else if (catIdStr != null && !catIdStr.trim().isEmpty() && !"__NEW__".equalsIgnoreCase(catIdStr.trim())) {
            dto.setCategoryId(Long.parseLong(catIdStr.trim()));
        } else {
            dto.setCategoryId(6L);
        }
        String priceStr = req.getParameter("price");
        dto.setPrice(priceStr != null && !priceStr.trim().isEmpty() ? new java.math.BigDecimal(priceStr.trim()) : java.math.BigDecimal.ZERO);
        dto.setExpertId(currentUser.getId());

        try {
            long savedId = courseService.saveCourse(dto);

            // Kiểm tra nếu có nhập danh sách link video hàng loạt kèm theo
            String batchText = req.getParameter("batchVideoText");
            if (batchText != null && !batchText.trim().isEmpty()) {
                List<LessonDto> lessons = CourseService.parseBatchVideoText(batchText);
                if (!lessons.isEmpty()) {
                    courseService.saveBatchLessons(savedId, null, lessons);
                }
            }

            SessionUtil.setFlashSuccess(req, "Khởi tạo khóa học thành công! Hãy bắt đầu thêm các chương và bài học bên dưới.");
            resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + savedId);
        } catch (Exception e) {
            SessionUtil.setFlashError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/expert/dashboard");
        }
    }

    /**
     * Nhập hàng loạt bài giảng (Batch Import) từ Playlist / nhiều link YouTube:
     * - [IDOR Defense]: Kiểm tra quyền sở hữu khóa học và chương học.
     * - Bóc tách danh sách URL YouTube từ chuỗi text.
     * - Tự động tạo bài giảng và gán vào Module chỉ định (hoặc tự tạo Module mới).
     */
    private void batchSaveLessons(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String courseIdStr = req.getParameter("courseId");
        String moduleIdStr = req.getParameter("moduleId");
        String batchText = req.getParameter("batchText");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/expert/dashboard");
            return;
        }

        long courseId = Long.parseLong(courseIdStr.trim());
        Long moduleId = (moduleIdStr != null && !moduleIdStr.trim().isEmpty()) ? Long.parseLong(moduleIdStr.trim()) : null;

        try {
            // [IDOR Defense]: Kiểm tra quyền sở hữu
            courseService.checkCourseOwnership(courseId, currentUser);
            if (moduleId != null) {
                courseService.checkModuleOwnership(moduleId, currentUser);
            }

            List<LessonDto> lessons = CourseService.parseBatchVideoText(batchText);
            int count = courseService.saveBatchLessons(courseId, moduleId, lessons);
            SessionUtil.setFlashSuccess(req, "Đã nhập và khởi tạo thành công " + count + " bài học từ danh sách video YouTube!");
            resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + courseId);
        } catch (SecurityException se) {
            SessionUtil.setFlashError(req, se.getMessage());
            resp.sendRedirect(req.getContextPath() + "/expert/dashboard");
        } catch (Exception e) {
            SessionUtil.setFlashError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + courseId);
        }
    }

    /**
     * Xóa Khóa học:
     * - [IDOR Defense]: Chỉ cho phép xóa nếu user sở hữu khóa học hoặc là Admin.
     * - Quay trở lại trang Expert Dashboard kèm thông báo xóa thành công.
     */
    private void deleteCourse(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                long courseId = Long.parseLong(idStr.trim());
                // [IDOR Defense]: Kiểm tra quyền sở hữu
                courseService.checkCourseOwnership(courseId, currentUser);
                courseService.deleteCourse(courseId);
                SessionUtil.setFlashSuccess(req, "Đã xóa khóa học thành công!");
            } catch (Exception e) {
                SessionUtil.setFlashError(req, e.getMessage());
            }
        }
        resp.sendRedirect(req.getContextPath() + "/expert/dashboard");
    }

    // =========================================================================
    // 3. NHÓM QUẢN LÝ BÀI HỌC & CHƯƠNG MỤC (LESSON & MODULE MANAGEMENT)
    // =========================================================================

    /**
     * [Màn hình II.4.1] Hiển thị Danh sách Bài học (Lesson List):
     * - [IDOR Defense]: Xác thực user có quyền quản lý khóa học này không.
     * - Lấy toàn bộ chi tiết khóa học (bao gồm cấu trúc cây Modules -> Lessons).
     * - Chuyển tiếp sang views/expert/lesson_list.jsp.
     */
    private void showLessonList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
            try {
                long courseId = Long.parseLong(courseIdStr.trim());
                // [IDOR Defense]: Kiểm tra quyền sở hữu
                courseService.checkCourseOwnership(courseId, currentUser);

                CourseDto course = courseService.getCourseDetail(courseId);
                req.setAttribute("course", course);
                req.getRequestDispatcher("/WEB-INF/views/expert/lesson_list.jsp").forward(req, resp);
                return;
            } catch (SecurityException se) {
                SessionUtil.setFlashError(req, se.getMessage());
                resp.sendRedirect(req.getContextPath() + "/expert/dashboard");
                return;
            } catch (Exception e) {
                SessionUtil.setFlashError(req, "Không tìm thấy khóa học: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/expert/dashboard");
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/expert/dashboard");
    }

    /**
     * [Màn hình II.4.1] Hiển thị Trình soạn thảo Bài học (Lesson Detail / Editor):
     * - [IDOR Defense]: Kiểm tra quyền sở hữu đối với Course, Module và Lesson.
     * - [Tối ưu hiệu năng]: Thay vì tải toàn bộ cây dữ liệu khóa học rồi duyệt vòng lặp,
     *   chỉ lấy danh sách Modules tóm tắt và gọi trực tiếp getLessonById (O(1)).
     * - Chuyển tiếp sang views/expert/lesson_detail.jsp.
     */
    private void showLessonDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String courseIdStr = req.getParameter("courseId");
        String moduleIdStr = req.getParameter("moduleId");
        String lessonIdStr = req.getParameter("lessonId");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/expert/dashboard");
            return;
        }

        try {
            long courseId = Long.parseLong(courseIdStr.trim());
            // [IDOR Defense]: Kiểm tra quyền sở hữu khóa học
            courseService.checkCourseOwnership(courseId, currentUser);

            // [Tối ưu hiệu năng]: Chỉ lấy thông tin khóa học và danh sách modules gọn nhẹ
            CourseDto course = courseService.getCourseSummaryWithModules(courseId);
            req.setAttribute("course", course);

            // Kiểm tra xem là chế độ Chỉnh sửa hay Tạo mới
            if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
                long lessonId = Long.parseLong(lessonIdStr.trim());
                // [IDOR Defense]: Kiểm tra quyền sở hữu bài học
                courseService.checkLessonOwnership(lessonId, currentUser);

                // [Tối ưu hiệu năng]: Lấy trực tiếp Lesson theo ID trong O(1) từ DAO
                LessonDto lesson = courseService.getLessonById(lessonId);
                req.setAttribute("lesson", lesson);
                req.setAttribute("selectedModuleId", lesson.getModuleId());
            } else if (moduleIdStr != null && !moduleIdStr.trim().isEmpty()) {
                long moduleId = Long.parseLong(moduleIdStr.trim());
                // [IDOR Defense]: Kiểm tra quyền sở hữu chương học
                courseService.checkModuleOwnership(moduleId, currentUser);
                req.setAttribute("selectedModuleId", moduleId);
            }

            req.getRequestDispatcher("/WEB-INF/views/expert/lesson_detail.jsp").forward(req, resp);
        } catch (SecurityException se) {
            SessionUtil.setFlashError(req, se.getMessage());
            resp.sendRedirect(req.getContextPath() + "/expert/dashboard");
        } catch (Exception e) {
            SessionUtil.setFlashError(req, "Lỗi nạp bài học: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + courseIdStr);
        }
    }

    /**
     * Lưu thông tin Bài học (Thêm mới hoặc Cập nhật):
     * - [IDOR Defense]: Kiểm tra quyền sở hữu chương và bài học.
     * - [Validation]: Kiểm tra đầy đủ qua tầng Service.
     * - [Flash Message]: Lưu thông báo an toàn qua Session, không đính kèm lỗi thô lên URL.
     */
    private void saveLesson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String courseIdStr = req.getParameter("courseId");
        try {
            LessonDto dto = new LessonDto();
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                long lessonId = Long.parseLong(idStr.trim());
                // [IDOR Defense]: Kiểm tra quyền sở hữu bài học trước khi sửa
                courseService.checkLessonOwnership(lessonId, currentUser);
                dto.setId(lessonId);
            }

            String moduleId = req.getParameter("moduleId");
            if (moduleId != null && !moduleId.trim().isEmpty()) {
                long modId = Long.parseLong(moduleId.trim());
                // [IDOR Defense]: Kiểm tra quyền sở hữu chương học trước khi lưu
                courseService.checkModuleOwnership(modId, currentUser);
                dto.setModuleId(modId);
            }

            dto.setTitle(req.getParameter("title"));
            dto.setContent(req.getParameter("content"));
            dto.setVideoUrl(req.getParameter("videoUrl"));
            dto.setDocumentUrl(req.getParameter("documentUrl"));
            String orderStr = req.getParameter("orderIndex");
            dto.setOrderIndex(orderStr != null && !orderStr.trim().isEmpty() ? Integer.parseInt(orderStr.trim()) : 1);

            courseService.saveLesson(dto);

            // [Xóa bản nháp]: Khi người dùng đã lưu thành công bài học, xóa bỏ draft trong session
            String draftKey = "draft_lesson_" + (courseIdStr != null ? courseIdStr : "0") + "_" + (dto.getId() != null ? dto.getId() : "new");
            req.getSession().removeAttribute(draftKey);

            // [Flash Attribute chống XSS]: Lưu thông báo an toàn qua session
            SessionUtil.setFlashSuccess(req, "Đã lưu thông tin bài học thành công!");
            resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + courseIdStr);
        } catch (Exception e) {
            // [Flash Attribute chống XSS]: Không truyền error string thô qua URL
            SessionUtil.setFlashError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + (courseIdStr != null ? courseIdStr : ""));
        }
    }

    /**
     * Xóa Bài học:
     * - [IDOR Defense]: Kiểm tra quyền sở hữu bài học trước khi xóa.
     */
    private void deleteLesson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String lessonIdStr = req.getParameter("lessonId");
        String courseIdStr = req.getParameter("courseId");
        try {
            if (lessonIdStr != null) {
                long lessonId = Long.parseLong(lessonIdStr.trim());
                // [IDOR Defense]: Kiểm tra quyền sở hữu bài học trước khi xóa
                courseService.checkLessonOwnership(lessonId, currentUser);
                courseService.deleteLesson(lessonId);
                SessionUtil.setFlashSuccess(req, "Đã xóa bài học thành công!");
            }
        } catch (Exception e) {
            SessionUtil.setFlashError(req, e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + (courseIdStr != null ? courseIdStr : ""));
    }

    /**
     * Tạo mới hoặc Cập nhật Chương học (Module):
     * - [IDOR Defense]: Kiểm tra quyền sở hữu khóa học và chương học.
     */
    private void saveModule(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String courseId = req.getParameter("courseId");
        try {
            ModuleDto dto = new ModuleDto();
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                long modId = Long.parseLong(idStr.trim());
                // [IDOR Defense]: Kiểm tra quyền sở hữu chương học
                courseService.checkModuleOwnership(modId, currentUser);
                dto.setId(modId);
            }
            if (courseId != null && !courseId.trim().isEmpty()) {
                long cId = Long.parseLong(courseId.trim());
                // [IDOR Defense]: Kiểm tra quyền sở hữu khóa học
                courseService.checkCourseOwnership(cId, currentUser);
                dto.setCourseId(cId);
            }
            dto.setTitle(req.getParameter("title"));
            String orderStr = req.getParameter("orderIndex");
            dto.setOrderIndex(orderStr != null && !orderStr.trim().isEmpty() ? Integer.parseInt(orderStr.trim()) : 1);

            courseService.saveModule(dto);
            SessionUtil.setFlashSuccess(req, "Đã lưu chương học thành công!");
        } catch (Exception e) {
            SessionUtil.setFlashError(req, e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + (courseId != null ? courseId : ""));
    }

    /**
     * Xóa Chương học (Module):
     * - [IDOR Defense]: Kiểm tra quyền sở hữu chương học trước khi xóa.
     */
    private void deleteModule(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String moduleIdStr = req.getParameter("moduleId");
        String courseIdStr = req.getParameter("courseId");
        try {
            if (moduleIdStr != null) {
                long modId = Long.parseLong(moduleIdStr.trim());
                // [IDOR Defense]: Kiểm tra quyền sở hữu chương học
                courseService.checkModuleOwnership(modId, currentUser);
                courseService.deleteModule(modId);
                SessionUtil.setFlashSuccess(req, "Đã xóa chương học thành công!");
            }
        } catch (Exception e) {
            SessionUtil.setFlashError(req, e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/expert/lessons?courseId=" + (courseIdStr != null ? courseIdStr : ""));
    }
}
