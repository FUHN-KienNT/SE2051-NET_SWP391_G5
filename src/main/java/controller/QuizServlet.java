package controller;

import dao.CourseDao;
import dao.ModuleDao;
import dao.QuestionDao;
import dao.QuizAttemptDao;
import dao.QuizDao;
import dao.RegistrationDao;
import dto.AnswerOptionDto;
import dto.CourseDto;
import dto.ModuleDto;
import dto.QuestionDto;
import dto.QuizAnswerDto;
import dto.QuizAttemptDto;
import dto.QuizDto;
import dto.QuizResultDto;
import entity.enums.QuestionType;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import service.QuizService;
import dto.UserDto;
import util.SessionUtil;

@WebServlet(name = "QuizServlet", urlPatterns = { "/quizzes/*" })
public class QuizServlet extends HttpServlet {
    private QuizService quizService;
    private CourseDao courseDao;
    private ModuleDao moduleDao;

    @Override
    public void init() throws ServletException {
        this.courseDao = new CourseDao();
        this.moduleDao = new ModuleDao();
        this.quizService = new QuizService(
                new QuizDao(), new QuestionDao(), new QuizAttemptDao(), new RegistrationDao(),
                this.courseDao, this.moduleDao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "list";
        processAction(action, req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "save";
        processAction(action, req, resp);
    }

    private boolean isStaffOrExpert(UserDto user) {
        if (user == null) return false;
        String role = user.getRoleName();
        if (role == null) return false;
        role = role.trim().toUpperCase();
        return "ADMIN".equals(role) || "MANAGER".equals(role) || "EXPERT".equals(role);
    }

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);

        // [SECURITY DEFENSE]: Chặn triệt để Student truy cập vào các chức năng quản lý bài thi,
        // xem danh sách câu hỏi / đáp án đúng hoặc sửa đề thi.
        boolean isManagementAction = "list".equals(action) || "detail".equals(action)
                || "questions".equals(action)
                || "save".equals(action) || "delete".equals(action)
                || "save-question".equals(action) || "delete-question".equals(action)
                || "assign-question".equals(action) || "remove-question".equals(action);

        if (isManagementAction) {
            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/auth/login");
                return;
            }
            if (!isStaffOrExpert(currentUser)) {
                SessionUtil.setFlashError(req, "Bạn không có quyền quản lý bài thi hoặc xem ngân hàng câu hỏi.");
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
        }

        switch (action) {
            case "list":
                showQuizList(req, resp);
                break;
            case "questions":
                showQuestionBank(req, resp);
                break;
            case "detail":
                showQuizDetail(req, resp);
                break;
            case "save":
                saveQuiz(req, resp);
                break;
            case "delete":
                deleteQuiz(req, resp);
                break;
            case "toggle-active":
                toggleQuizActive(req, resp);
                break;
            case "save-question":
                saveQuestion(req, resp);
                break;
            case "delete-question":
                deleteQuestion(req, resp);
                break;
            case "assign-question":
                assignQuestion(req, resp);
                break;
            case "remove-question":
                removeQuestion(req, resp);
                break;
            case "overview":
                showQuizOverview(req, resp);
                break;
            case "attempt":
                showAttempt(req, resp);
                break;
            case "submit":
                submitAttempt(req, resp);
                break;
            case "result":
                showResult(req, resp);
                break;
            default:
                showQuizList(req, resp);
                break;
        }
    }

    private void showQuizList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseIdStr = req.getParameter("courseId");
        String moduleIdStr = req.getParameter("moduleId");

        Long courseId = null;
        if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
            try {
                courseId = Long.parseLong(courseIdStr.trim());
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Mã khóa học không hợp lệ: " + courseIdStr);
            }
        } else if (moduleIdStr != null && !moduleIdStr.trim().isEmpty()) {
            try {
                long modId = Long.parseLong(moduleIdStr.trim());
                try (java.sql.Connection con = util.DbConnection.getConnection()) {
                    java.util.Optional<entity.Module> modOpt = moduleDao.findById(con, modId);
                    if (modOpt.isPresent()) {
                        courseId = modOpt.get().getCourseId();
                    }
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Mã chương học không hợp lệ: " + moduleIdStr);
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi khi tìm khóa học từ chương: " + e.getMessage());
            }
        }

        if (courseId == null) {
            try (java.sql.Connection con = util.DbConnection.getConnection()) {
                List<entity.Course> allCourses = courseDao.findAll(con);
                if (!allCourses.isEmpty()) {
                    courseId = allCourses.get(0).getId();
                }
            } catch (Exception e) {
                req.setAttribute("error", "Không thể tải danh sách khóa học: " + e.getMessage());
            }
        }

        String tab = req.getParameter("tab");
        if ("questions".equalsIgnoreCase(tab)) {
            resp.sendRedirect(req.getContextPath() + "/quizzes/questions?"
                    + (courseId != null ? "courseId=" + courseId : (moduleIdStr != null ? "moduleId=" + moduleIdStr : "")));
            return;
        }

        if (courseId != null) {
            try {
                String keyword = req.getParameter("keyword");
                if (keyword != null) {
                    keyword = keyword.trim();
                }
                String filterModuleIdStr = req.getParameter("filterModuleId");
                Long filterModuleId = null;
                if (filterModuleIdStr != null && !filterModuleIdStr.trim().isEmpty() && !"all".equalsIgnoreCase(filterModuleIdStr.trim())) {
                    try {
                        filterModuleId = Long.parseLong(filterModuleIdStr.trim());
                    } catch (NumberFormatException ignored) {}
                }
                String filterMode = req.getParameter("filterMode");
                if (filterMode != null) {
                    filterMode = filterMode.trim();
                }

                // Tải nhẹ qua Server-side Filtering: Chỉ tải thông tin Quiz và Modules khớp điều kiện
                CourseDto course = quizService.searchQuizListCourse(courseId, filterModuleId, keyword, filterMode);
                req.setAttribute("course", course);
                req.setAttribute("courseId", courseId);

                // Danh sách toàn bộ chương để render vào dropdown bộ lọc
                List<entity.Module> allModules = quizService.getModulesByCourse(courseId);
                req.setAttribute("allModules", allModules);

                int totalQuizzes = quizService.countQuizzesByCourse(courseId);
                req.setAttribute("totalQuizzes", totalQuizzes);

                int totalQuestions = quizService.countQuestionsByCourse(courseId);
                req.setAttribute("totalQuestions", totalQuestions);

                // Đếm tổng số bài thi hiển thị khớp với kết quả tìm kiếm hiện tại
                int filteredQuizzesCount = 0;
                if (course != null && course.getModules() != null) {
                    for (ModuleDto m : course.getModules()) {
                        filteredQuizzesCount += m.getQuizCount();
                    }
                }
                req.setAttribute("filteredQuizzesCount", filteredQuizzesCount);

                // Lưu lại các tham số filter để giữ trạng thái trên form
                req.setAttribute("keyword", keyword);
                req.setAttribute("filterModuleId", filterModuleId);
                req.setAttribute("filterMode", filterMode);
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi tải thông tin bài thi: " + e.getMessage());
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/quiz/list.jsp").forward(req, resp);
    }

    private void showQuestionBank(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseIdStr = req.getParameter("courseId");
        String moduleIdStr = req.getParameter("moduleId");

        Long courseId = null;
        if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
            try {
                courseId = Long.parseLong(courseIdStr.trim());
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Mã khóa học không hợp lệ: " + courseIdStr);
            }
        } else if (moduleIdStr != null && !moduleIdStr.trim().isEmpty()) {
            try {
                long modId = Long.parseLong(moduleIdStr.trim());
                try (java.sql.Connection con = util.DbConnection.getConnection()) {
                    java.util.Optional<entity.Module> modOpt = moduleDao.findById(con, modId);
                    if (modOpt.isPresent()) {
                        courseId = modOpt.get().getCourseId();
                    }
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Mã chương học không hợp lệ: " + moduleIdStr);
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi khi tìm khóa học từ chương: " + e.getMessage());
            }
        }

        if (courseId == null) {
            try (java.sql.Connection con = util.DbConnection.getConnection()) {
                List<entity.Course> allCourses = courseDao.findAll(con);
                if (!allCourses.isEmpty()) {
                    courseId = allCourses.get(0).getId();
                }
            } catch (Exception e) {
                req.setAttribute("error", "Không thể tải danh sách khóa học: " + e.getMessage());
            }
        }

        if (courseId != null) {
            try {
                String keyword = req.getParameter("keyword");
                if (keyword != null) {
                    keyword = keyword.trim();
                }
                String filterModuleIdStr = req.getParameter("filterModuleId");
                Long filterModuleId = null;
                if (filterModuleIdStr != null && !filterModuleIdStr.trim().isEmpty() && !"all".equalsIgnoreCase(filterModuleIdStr.trim())) {
                    try {
                        filterModuleId = Long.parseLong(filterModuleIdStr.trim());
                    } catch (NumberFormatException ignored) {}
                }
                String questionType = req.getParameter("questionType");
                if (questionType != null) {
                    questionType = questionType.trim();
                    if ("all".equalsIgnoreCase(questionType)) {
                        questionType = null;
                    }
                }

                // Tải chuyên biệt cho Ngân hàng câu hỏi qua Server-side Filtering
                CourseDto course = quizService.searchQuestionBankCourse(courseId, filterModuleId, questionType, keyword);
                req.setAttribute("course", course);
                req.setAttribute("courseId", courseId);

                // Danh sách toàn bộ chương để render vào dropdown bộ lọc
                List<entity.Module> allModules = quizService.getModulesByCourse(courseId);
                req.setAttribute("allModules", allModules);

                int totalQuizzes = quizService.countQuizzesByCourse(courseId);
                req.setAttribute("totalQuizzes", totalQuizzes);

                int totalQuestions = quizService.countQuestionsByCourse(courseId);
                req.setAttribute("totalQuestions", totalQuestions);

                // Đếm tổng số câu hỏi khớp với kết quả tìm kiếm hiện tại
                int filteredQuestionsCount = 0;
                if (course != null && course.getModules() != null) {
                    for (ModuleDto m : course.getModules()) {
                        filteredQuestionsCount += m.getQuestionCount();
                    }
                }
                req.setAttribute("filteredQuestionsCount", filteredQuestionsCount);

                // Lưu lại các tham số filter để giữ trạng thái trên form
                req.setAttribute("keyword", keyword);
                req.setAttribute("filterModuleId", filterModuleId);
                req.setAttribute("questionType", req.getParameter("questionType"));
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi tải ngân hàng câu hỏi: " + e.getMessage());
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/quiz/questions.jsp").forward(req, resp);
    }

    private void showQuizDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String quizIdStr = req.getParameter("id");
        String courseIdStr = req.getParameter("courseId");
        if (quizIdStr == null || quizIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/quizzes/list"
                    + (courseIdStr != null && !courseIdStr.trim().isEmpty() ? "?courseId=" + courseIdStr.trim() : ""));
            return;
        }

        try {
            long quizId = Long.parseLong(quizIdStr.trim());
            QuizDto quiz = quizService.getQuizDetail(quizId);
            req.setAttribute("quiz", quiz);

            Long courseId = null;
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                try {
                    courseId = Long.parseLong(courseIdStr.trim());
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "Mã khóa học không hợp lệ: " + courseIdStr);
                }
            }

            try (java.sql.Connection con = util.DbConnection.getConnection()) {
                java.util.Optional<entity.Module> modOpt = moduleDao.findById(con, quiz.getModuleId());
                if (modOpt.isPresent()) {
                    entity.Module module = modOpt.get();
                    req.setAttribute("currentModule", module);
                    if (courseId == null) {
                        courseId = module.getCourseId();
                    }
                }
            } catch (Exception e) {
                req.setAttribute("error", "Không thể tải thông tin chương học: " + e.getMessage());
            }

            //lay thong tin course
            if (courseId != null) {
                req.setAttribute("courseId", courseId);
                try (java.sql.Connection con = util.DbConnection.getConnection()) {
                    courseDao.findById(con, courseId).ifPresent(c -> {
                        CourseDto cDto = new CourseDto();
                        cDto.setId(c.getId());
                        cDto.setTitle(c.getTitle());
                        req.setAttribute("course", cDto);
                    });
                } catch (Exception e) {
                    req.setAttribute("error", "Không thể tải thông tin khóa học: " + e.getMessage());
                }
            }

            // Danh sách câu hỏi trong ngân hàng của cùng Module
            List<QuestionDto> bankQuestions = quizService.getQuestionBank(quiz.getModuleId());
            req.setAttribute("bankQuestions", bankQuestions);

            java.util.Set<Long> assignedQuestionIds = quiz.getQuestions().stream()
                    .map(QuestionDto::getId)
                    .collect(Collectors.toSet());
            req.setAttribute("assignedQuestionIds", assignedQuestionIds);

        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/quizzes/list?error=" + java.net.URLEncoder.encode(
                    "Không tìm thấy bài thi hoặc lỗi: " + e.getMessage(), java.nio.charset.StandardCharsets.UTF_8));
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/quiz/detail.jsp").forward(req, resp);
    }

    private void saveQuiz(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String courseIdStr = req.getParameter("courseId");
        String from = req.getParameter("from");
        QuizDto dto = null;
        try {
            dto = bindQuiz(req);
            long id = quizService.saveQuiz(dto);

            // Nếu submit từ trang list (hoặc không phải từ detail)
            if ("list".equalsIgnoreCase(from) || !"detail".equalsIgnoreCase(from)) {
                String target = req.getContextPath() + "/quizzes/list?";
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    target += "courseId=" + courseIdStr.trim();
                } else if (dto.getModuleId() != null) {
                    target += "moduleId=" + dto.getModuleId();
                }
                resp.sendRedirect(target + (target.endsWith("?") ? "" : "&") + "success=saved");
                return;
            }

            // Nếu lưu từ trang chi tiết (detail)
            String target = req.getContextPath() + "/quizzes/detail?id=" + id;
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                target += "&courseId=" + courseIdStr.trim();
            }
            resp.sendRedirect(target + "&success=saved");
        } catch (Exception e) {
            String redirectUrl;
            if ("list".equalsIgnoreCase(from) || !"detail".equalsIgnoreCase(from)) {
                redirectUrl = req.getContextPath() + "/quizzes/list?";
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    redirectUrl += "courseId=" + courseIdStr.trim();
                } else if (dto != null && dto.getModuleId() != null) {
                    redirectUrl += "moduleId=" + dto.getModuleId();
                }
            } else if (dto != null && dto.getId() != null && dto.getId() > 0) {
                redirectUrl = req.getContextPath() + "/quizzes/detail?id=" + dto.getId();
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    redirectUrl += "&courseId=" + courseIdStr.trim();
                }
            } else {
                redirectUrl = req.getContextPath() + "/quizzes/list?";
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    redirectUrl += "courseId=" + courseIdStr.trim();
                } else if (dto != null && dto.getModuleId() != null) {
                    redirectUrl += "moduleId=" + dto.getModuleId();
                }
            }
            resp.sendRedirect(redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "error="
                    + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi khi lưu bài thi.", java.nio.charset.StandardCharsets.UTF_8));
        }
    }

    private void deleteQuiz(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String quizIdStr = req.getParameter("id");
        String courseIdStr = req.getParameter("courseId");
        String moduleIdStr = req.getParameter("moduleId");
        try {
            if (quizIdStr != null && !quizIdStr.trim().isEmpty()) {
                quizService.deleteQuiz(Long.parseLong(quizIdStr.trim()));
            }
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                resp.sendRedirect(
                        req.getContextPath() + "/quizzes/list?courseId=" + courseIdStr.trim() + "&success=deleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/quizzes/list?moduleId=" + moduleIdStr + "&success=deleted");
            }
        } catch (Exception e) {
            String redirectUrl = req.getContextPath() + "/quizzes/list?";
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                redirectUrl += "courseId=" + courseIdStr.trim();
            } else {
                redirectUrl += "moduleId=" + moduleIdStr;
            }
            resp.sendRedirect(redirectUrl + "&error="
                    + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi khi xóa bài kiểm tra.", java.nio.charset.StandardCharsets.UTF_8));
        }
    }

    private void toggleQuizActive(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String courseIdStr = req.getParameter("courseId");
        String from = req.getParameter("from");
        try {
            long quizId = Long.parseLong(idStr);
            boolean newStatus = quizService.toggleQuizActive(quizId);
            String successMsg = newStatus ? "activated" : "deactivated";

            if ("detail".equalsIgnoreCase(from)) {
                String target = req.getContextPath() + "/quizzes/detail?id=" + quizId;
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    target += "&courseId=" + courseIdStr.trim();
                }
                resp.sendRedirect(target + "&success=" + successMsg);
                return;
            }

            String target = req.getContextPath() + "/quizzes/list?";
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                target += "courseId=" + courseIdStr.trim();
            }
            resp.sendRedirect(target + (target.endsWith("?") ? "" : "&") + "success=" + successMsg);
        } catch (Exception e) {
            String target = req.getContextPath() + "/quizzes/list?";
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                target += "courseId=" + courseIdStr.trim();
            }
            resp.sendRedirect(target + (target.endsWith("?") ? "" : "&") + "error="
                    + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi cập nhật trạng thái.", java.nio.charset.StandardCharsets.UTF_8));
        }
    }

    private void saveQuestion(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String quizIdStr = req.getParameter("quizId");
        String courseIdStr = req.getParameter("courseId");
        String from = req.getParameter("from");
        QuestionDto dto = null;
        try {
            dto = bindQuestion(req);
            long questionId = quizService.saveQuestion(dto);
            boolean isNewQuestion = (dto.getId() == null || dto.getId() <= 0);

            // Nếu đến từ trang câu hỏi hoặc danh sách, redirect về trang ngân hàng câu hỏi
            if ("questions".equalsIgnoreCase(from) || "list".equalsIgnoreCase(from)) {
                String target = req.getContextPath() + "/quizzes/questions?";
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    target += "courseId=" + courseIdStr.trim();
                } else if (dto.getModuleId() != null) {
                    target += "moduleId=" + dto.getModuleId();
                }
                resp.sendRedirect(target + (target.endsWith("?") ? "" : "&") + "success=question_saved");
                return;
            }

            // Nếu có quizId VÀ câu hỏi mới tạo (từ detail modal), tự động gán câu hỏi này vào Quiz luôn
            if (quizIdStr != null && !quizIdStr.trim().isEmpty()) {
                long quizId = Long.parseLong(quizIdStr.trim());
                String target = req.getContextPath() + "/quizzes/detail?id=" + quizId;
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    target += "&courseId=" + courseIdStr.trim();
                }
                if (isNewQuestion) {
                    BigDecimal points = dto.getDefaultPoints() != null ? dto.getDefaultPoints() : BigDecimal.ONE;
                    quizService.assignQuestion(quizId, questionId, points, 0);
                    resp.sendRedirect(target + "&success=question_created_and_assigned");
                } else {
                    resp.sendRedirect(target + "&success=question_updated");
                }
                return;
            }

            // Mặc định về trang ngân hàng câu hỏi
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/quizzes/questions?courseId=" + courseIdStr.trim()
                        + "&success=question_saved");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/quizzes/questions?moduleId=" + dto.getModuleId()
                    + "&success=question_saved");
        } catch (Exception e) {
            if ("questions".equalsIgnoreCase(from) || "list".equalsIgnoreCase(from)) {
                String target = req.getContextPath() + "/quizzes/questions?";
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    target += "courseId=" + courseIdStr.trim();
                } else {
                    String modParam = (dto != null && dto.getModuleId() != null) ? String.valueOf(dto.getModuleId()) : req.getParameter("moduleId");
                    target += "moduleId=" + modParam;
                }
                resp.sendRedirect(target + (target.endsWith("?") ? "" : "&") + "error="
                        + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi khi lưu câu hỏi.", java.nio.charset.StandardCharsets.UTF_8));
                return;
            }
            if (quizIdStr != null && !quizIdStr.trim().isEmpty()) {
                String target = req.getContextPath() + "/quizzes/detail?id=" + quizIdStr.trim();
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    target += "&courseId=" + courseIdStr.trim();
                }
                resp.sendRedirect(target + "&error="
                        + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi khi lưu câu hỏi.", java.nio.charset.StandardCharsets.UTF_8));
                return;
            }
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                resp.sendRedirect(
                        req.getContextPath() + "/quizzes/questions?courseId=" + courseIdStr.trim() + "&error="
                                + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi khi lưu câu hỏi.", java.nio.charset.StandardCharsets.UTF_8));
                return;
            }
            String modParam = (dto != null && dto.getModuleId() != null) ? String.valueOf(dto.getModuleId()) : req.getParameter("moduleId");
            resp.sendRedirect(
                    req.getContextPath() + "/quizzes/questions?moduleId=" + modParam + "&error="
                            + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi khi lưu câu hỏi.", java.nio.charset.StandardCharsets.UTF_8));
        }
    }

    private void deleteQuestion(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String qIdStr = req.getParameter("id");
        String courseIdStr = req.getParameter("courseId");
        String moduleIdStr = req.getParameter("moduleId");
        try {
            if (qIdStr != null && !qIdStr.trim().isEmpty()) {
                quizService.deleteQuestion(Long.parseLong(qIdStr.trim()));
            }
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/quizzes/questions?courseId=" + courseIdStr.trim()
                        + "&success=question_deleted");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/quizzes/questions?moduleId=" + moduleIdStr
                    + "&success=question_deleted");
        } catch (Exception e) {
            String redirectUrl = req.getContextPath() + "/quizzes/questions?";
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                redirectUrl += "courseId=" + courseIdStr.trim();
            } else {
                redirectUrl += "moduleId=" + moduleIdStr;
            }
            resp.sendRedirect(redirectUrl + "&error="
                    + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi khi xóa câu hỏi.", java.nio.charset.StandardCharsets.UTF_8));
        }
    }

    private void assignQuestion(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String quizIdStr = req.getParameter("quizId");
        String questionIdStr = req.getParameter("questionId");
        String courseIdStr = req.getParameter("courseId");
        if (quizIdStr == null || questionIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/quizzes/list?error="
                    + java.net.URLEncoder.encode("Thiếu tham số hợp lệ để gán câu hỏi.", java.nio.charset.StandardCharsets.UTF_8));
            return;
        }

        try {
            long quizId = Long.parseLong(quizIdStr.trim());
            long questionId = Long.parseLong(questionIdStr.trim());
            String pointsStr = req.getParameter("points");
            BigDecimal points = pointsStr != null && !pointsStr.trim().isEmpty() ? new BigDecimal(pointsStr.trim())
                    : BigDecimal.ONE;
            String orderStr = req.getParameter("order");
            int order = (orderStr != null && !orderStr.trim().isEmpty()) ? Integer.parseInt(orderStr.trim()) : 0;

            quizService.assignQuestion(quizId, questionId, points, order);
            String target = req.getContextPath() + "/quizzes/detail?id=" + quizId;
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                target += "&courseId=" + courseIdStr.trim();
            }
            resp.sendRedirect(target + "&success=assigned");
        } catch (Exception e) {
            String target;
            if (quizIdStr != null && quizIdStr.trim().matches("\\d+")) {
                target = req.getContextPath() + "/quizzes/detail?id=" + quizIdStr.trim();
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    target += "&courseId=" + courseIdStr.trim();
                }
            } else {
                target = req.getContextPath() + "/quizzes/list";
            }
            resp.sendRedirect(target + (target.contains("?") ? "&" : "?") + "error="
                    + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi khi gán câu hỏi.", java.nio.charset.StandardCharsets.UTF_8));
        }
    }

    private void removeQuestion(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String quizIdStr = req.getParameter("quizId");
        String questionIdStr = req.getParameter("questionId");
        String courseIdStr = req.getParameter("courseId");
        if (quizIdStr == null || questionIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/quizzes/list?error="
                    + java.net.URLEncoder.encode("Thiếu tham số hợp lệ.", java.nio.charset.StandardCharsets.UTF_8));
            return;
        }

        try {
            long quizId = Long.parseLong(quizIdStr.trim());
            long questionId = Long.parseLong(questionIdStr.trim());
            quizService.removeQuestion(quizId, questionId);
            String target = req.getContextPath() + "/quizzes/detail?id=" + quizId;
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                target += "&courseId=" + courseIdStr.trim();
            }
            resp.sendRedirect(target + "&success=removed");
        } catch (Exception e) {
            String target;
            if (quizIdStr != null && quizIdStr.trim().matches("\\d+")) {
                target = req.getContextPath() + "/quizzes/detail?id=" + quizIdStr.trim();
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    target += "&courseId=" + courseIdStr.trim();
                }
            } else {
                target = req.getContextPath() + "/quizzes/list";
            }
            resp.sendRedirect(target + (target.contains("?") ? "&" : "?") + "error="
                    + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi khi gỡ câu hỏi.", java.nio.charset.StandardCharsets.UTF_8));
        }
    }

    private Long getAuthorizedStudentId(UserDto currentUser) {
        if (currentUser == null) return null;
        if ("ADMIN".equalsIgnoreCase(currentUser.getRoleName()) || "MANAGER".equalsIgnoreCase(currentUser.getRoleName())) {
            return null; // Admin / Manager có thể xem mọi đơn đăng ký
        }
        return currentUser.getId();
    }

    private void showQuizOverview(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        try {
            long regId = Long.parseLong(req.getParameter("registrationId"));
            long quizId = Long.parseLong(req.getParameter("quizId"));

            Long authUserId = getAuthorizedStudentId(currentUser);
            quizService.validateQuizAccess(regId, quizId, authUserId);

            QuizDto quiz = quizService.getQuizDetail(quizId);
            QuizResultDto lastResult = quizService.getLatestCompletedResult(regId, quizId, authUserId);

            req.setAttribute("quiz", quiz);
            req.setAttribute("registrationId", regId);
            req.setAttribute("lastResult", lastResult);
            req.getRequestDispatcher("/WEB-INF/views/quiz/overview.jsp").forward(req, resp);
        } catch (Exception e) {
            SessionUtil.setFlashError(req, "Không thể tải thông tin bài kiểm tra: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/registrations/my");
        }
    }

    private void showAttempt(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String regIdStr = req.getParameter("registrationId");
        String quizIdStr = req.getParameter("quizId");
        try {
            long regId = Long.parseLong(regIdStr);
            long quizId = Long.parseLong(quizIdStr);
            boolean isRetake = "true".equalsIgnoreCase(req.getParameter("retake"));
            Long authUserId = getAuthorizedStudentId(currentUser);
            QuizAttemptDto attempt = quizService.startAttempt(regId, quizId, isRetake, authUserId);
            QuizDto quiz = quizService.getQuizDetail(quizId);

            // [ANTI-CHEAT DEFENSE]: TUYỆT ĐỐI KHÔNG gửi cờ đáp án đúng (isCorrect) về phía học viên trước khi nộp bài!
            if (quiz != null && quiz.getQuestions() != null) {
                for (QuestionDto q : quiz.getQuestions()) {
                    if (q.getOptions() != null) {
                        for (AnswerOptionDto opt : q.getOptions()) {
                            opt.setCorrect(false);
                        }
                    }
                }
            }

            req.setAttribute("attempt", attempt);
            req.setAttribute("quiz", quiz);
            req.getRequestDispatcher("/WEB-INF/views/quiz/take.jsp").forward(req, resp);
        } catch (Exception e) {
            String redirectUrl;
            if (regIdStr != null && quizIdStr != null) {
                redirectUrl = req.getContextPath() + "/quizzes/overview?registrationId=" + regIdStr.trim() + "&quizId=" + quizIdStr.trim();
            } else {
                redirectUrl = req.getContextPath() + "/registrations/my";
            }
            SessionUtil.setFlashError(req, "Không thể bắt đầu làm bài thi: " + e.getMessage());
            resp.sendRedirect(redirectUrl);
        }
    }

    private void submitAttempt(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String regIdStr = req.getParameter("registrationId");
        String quizIdStr = req.getParameter("quizId");
        try {
            UserDto currentUser = SessionUtil.getCurrentUser(req);
            Long authUserId = getAuthorizedStudentId(currentUser);
            QuizAttemptDto dto = bindAttempt(req);
            QuizResultDto result = quizService.submitAttempt(dto, authUserId);
            req.getSession().setAttribute("lastQuizResult", result);
            resp.sendRedirect(req.getContextPath() + "/quizzes/result?registrationId=" + dto.getRegistrationId()
                    + "&quizId=" + dto.getQuizId());
        } catch (Exception e) {
            String redirectUrl;
            if (regIdStr != null && quizIdStr != null) {
                redirectUrl = req.getContextPath() + "/quizzes/overview?registrationId=" + regIdStr.trim() + "&quizId=" + quizIdStr.trim();
            } else if (regIdStr != null) {
                redirectUrl = req.getContextPath() + "/courses/learn?registrationId=" + regIdStr.trim();
            } else {
                redirectUrl = req.getContextPath() + "/registrations/my";
            }
            SessionUtil.setFlashError(req, "Lỗi khi nộp bài thi: " + e.getMessage());
            resp.sendRedirect(redirectUrl);
        }
    }

    private void showResult(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String regIdStr = req.getParameter("registrationId");
        String quizIdStr = req.getParameter("quizId");
        try {
            long regId = Long.parseLong(regIdStr);
            long quizId = Long.parseLong(quizIdStr);
            UserDto currentUser = SessionUtil.getCurrentUser(req);
            Long authUserId = getAuthorizedStudentId(currentUser);
            QuizResultDto result = quizService.getResult(regId, quizId, authUserId);
            QuizDto quiz = quizService.getQuizDetail(quizId);

            // [LỖ HỔNG 3 VÁ TOÀN DIỆN]: Nếu học viên chưa đạt điểm tối thiểu và không phải Admin/Manager,
            // xóa cờ isCorrect trên các Option trước khi gửi xuống view để chống gian lận khi làm lại!
            boolean isAdminOrManager = currentUser != null && ("ADMIN".equalsIgnoreCase(currentUser.getRoleName()) || "MANAGER".equalsIgnoreCase(currentUser.getRoleName()));
            if (!result.isPassStatus() && !isAdminOrManager) {
                if (quiz != null && quiz.getQuestions() != null) {
                    for (QuestionDto q : quiz.getQuestions()) {
                        if (q.getOptions() != null) {
                            for (AnswerOptionDto opt : q.getOptions()) {
                                opt.setCorrect(false);
                            }
                        }
                    }
                }
            }

            Map<Long, QuizAnswerDto> answerMap = new HashMap<>();
            if (result.getAnswers() != null) {
                for (QuizAnswerDto a : result.getAnswers()) {
                    answerMap.put(a.getQuestionId(), a);
                }
            }

            req.setAttribute("result", result);
            req.setAttribute("quiz", quiz);
            req.setAttribute("answerMap", answerMap);
            req.setAttribute("registrationId", regId);
            req.getRequestDispatcher("/WEB-INF/views/quiz/result.jsp").forward(req, resp);
        } catch (Exception e) {
            String redirectUrl;
            if (regIdStr != null && quizIdStr != null) {
                redirectUrl = req.getContextPath() + "/quizzes/overview?registrationId=" + regIdStr.trim() + "&quizId=" + quizIdStr.trim();
            } else if (regIdStr != null) {
                redirectUrl = req.getContextPath() + "/courses/learn?registrationId=" + regIdStr.trim();
            } else {
                redirectUrl = req.getContextPath() + "/registrations/my";
            }
            SessionUtil.setFlashError(req, "Không thể tải kết quả bài thi: " + e.getMessage());
            resp.sendRedirect(redirectUrl);
        }
    }

    private QuizDto bindQuiz(HttpServletRequest req) {
        QuizDto dto = new QuizDto();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            dto.setId(Long.parseLong(idStr.trim()));
        }
        dto.setModuleId(Long.parseLong(req.getParameter("moduleId")));
        dto.setTitle(req.getParameter("title"));
        String passScoreStr = req.getParameter("passScore");
        dto.setPassScore(passScoreStr != null && !passScoreStr.trim().isEmpty() ? new BigDecimal(passScoreStr.trim())
                : BigDecimal.valueOf(50.0));
        String timeLimitStr = req.getParameter("timeLimitMinutes");
        dto.setTimeLimitMinutes(
                timeLimitStr != null && !timeLimitStr.trim().isEmpty() ? Integer.parseInt(timeLimitStr.trim()) : null);
        String orderStr = req.getParameter("orderIndex");
        dto.setOrderIndex(orderStr != null && !orderStr.trim().isEmpty() ? Integer.parseInt(orderStr.trim()) : 1);
        String from = req.getParameter("from");
        String activeStr = req.getParameter("active");
        if (activeStr != null) {
            dto.setActive("true".equalsIgnoreCase(activeStr) || "1".equals(activeStr) || "on".equalsIgnoreCase(activeStr));
        } else {
            // Cả khi tạo mới hoặc cập nhật mà không tick active thì mặc định là false (Ẩn)
            dto.setActive(false);
        }
        return dto;
    }

    private QuestionDto bindQuestion(HttpServletRequest req) {
        QuestionDto dto = new QuestionDto();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            dto.setId(Long.parseLong(idStr.trim()));
        }
        dto.setModuleId(Long.parseLong(req.getParameter("moduleId")));
        dto.setQuestionText(req.getParameter("questionText"));
        dto.setQuestionType(QuestionType.fromDb(req.getParameter("questionType")));
        String pointsStr = req.getParameter("defaultPoints");
        dto.setDefaultPoints(
                pointsStr != null && !pointsStr.trim().isEmpty() ? new BigDecimal(pointsStr.trim()) : BigDecimal.ONE);

        String[] optionTexts = req.getParameterValues("optionText");
        String[] correctOptions = req.getParameterValues("correctOption");
        java.util.Set<Integer> correctSet = new java.util.HashSet<>();
        if (correctOptions != null) {
            for (String s : correctOptions) {
                if (s != null && !s.trim().isEmpty()) {
                    try {
                        correctSet.add(Integer.parseInt(s.trim()));
                    } catch (NumberFormatException ignored) {}
                }
            }
        }

        if (optionTexts != null) {
            int maxOptions = (dto.getQuestionType() == QuestionType.TRUE_FALSE) ? Math.min(2, optionTexts.length) : optionTexts.length;
            int orderIndex = 1;
            for (int i = 0; i < maxOptions; i++) {
                String rawText = optionTexts[i];
                String text = rawText != null ? rawText.trim() : "";
                boolean isCorrect = correctSet.contains(i);
                if (isCorrect && text.isEmpty()) {
                    throw new IllegalArgumentException("Đáp án được chọn là đáp án đúng không được để trống nội dung.");
                }
                if (!text.isEmpty()) {
                    dto.getOptions().add(new AnswerOptionDto(null, dto.getId(), text, isCorrect, orderIndex++));
                }
            }
        }
        return dto;
    }

    private QuizAttemptDto bindAttempt(HttpServletRequest req) {
        QuizAttemptDto dto = new QuizAttemptDto();
        String idStr = req.getParameter("attemptId");
        if (idStr != null && !idStr.trim().isEmpty()) {
            dto.setId(Long.parseLong(idStr.trim()));
        }
        dto.setRegistrationId(Long.parseLong(req.getParameter("registrationId")));
        dto.setQuizId(Long.parseLong(req.getParameter("quizId")));

        String[] questionIds = req.getParameterValues("questionId");
        if (questionIds != null) {
            for (String qIdStr : questionIds) {
                long qId = Long.parseLong(qIdStr);
                String[] selectedOpts = req.getParameterValues("question_" + qId);
                List<Long> optList = new ArrayList<>();
                if (selectedOpts != null) {
                    for (String val : selectedOpts) {
                        if (val != null && !val.trim().isEmpty()) {
                            try {
                                optList.add(Long.parseLong(val.trim()));
                            } catch (NumberFormatException ignored) {}
                        }
                    }
                }
                QuizAnswerDto ansDto = new QuizAnswerDto();
                ansDto.setQuestionId(qId);
                ansDto.setSelectedOptionIds(optList);
                if (!optList.isEmpty()) {
                    ansDto.setSelectedOptionId(optList.get(0));
                }
                dto.getAnswers().add(ansDto);
            }
        }
        return dto;
    }
}
