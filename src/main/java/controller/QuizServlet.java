package controller;

import dao.CourseDao;
import dao.LessonDao;
import dao.LessonProgressDao;
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
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import service.CourseService;
import service.QuizService;

/**
 * ==============================================================================
 * CỤM CHỨC NĂNG: 4_Quiz-Based Studying
 * PHỤ TRÁCH: NhatNH (Nguyễn Hồng Nhật)
 * USE CASES:
 *   - Quiz List (SRS II.5.1.1)
 *   - Quiz Detail & Editor (SRS II.5.1.2)
 *   - Question List & Question Bank (SRS II.5.2.1)
 *   - Create Quiz Questions (Expert)
 *   - Quiz Taking & Quiz Result (Student)
 * URL PATTERN: /quizzes/*
 * ==============================================================================
 */
@WebServlet(name = "QuizServlet", urlPatterns = {"/quizzes/*"})
public class QuizServlet extends HttpServlet {
    private QuizService quizService;
    private CourseService courseService;
    private ModuleDao moduleDao;

    @Override
    public void init() throws ServletException {
        this.quizService = new QuizService(
                new QuizDao(), new QuestionDao(), new QuizAttemptDao(), new RegistrationDao()
        );
        this.courseService = new CourseService(
                new CourseDao(), new ModuleDao(), new LessonDao(),
                new LessonProgressDao(), new RegistrationDao()
        );
        this.moduleDao = new ModuleDao();
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

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        switch (action) {
            case "list":
                showQuizList(req, resp);
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
            case "question-bank":
                showQuestionBank(req, resp);
                break;
            case "question-detail":
                showQuestionDetail(req, resp);
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
            case "reorder-questions":
                reorderQuestions(req, resp);
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
            courseId = Long.parseLong(courseIdStr.trim());
        } else if (moduleIdStr != null && !moduleIdStr.trim().isEmpty()) {
            try (java.sql.Connection con = util.DbConnection.getConnection()) {
                long modId = Long.parseLong(moduleIdStr.trim());
                req.setAttribute("selectedModuleId", modId);
                java.util.Optional<entity.Module> modOpt = moduleDao.findById(con, modId);
                if (modOpt.isPresent()) {
                    courseId = modOpt.get().getCourseId();
                }
            } catch (Exception ignored) {
            }
        }

        if (courseId != null) {
            CourseDto course = courseService.getCourseDetail(courseId);
            // Đảm bảo mỗi quiz trong các modules đều có danh sách câu hỏi chính xác
            for (ModuleDto m : course.getModules()) {
                m.setQuizzes(quizService.getQuizzes(m.getId()));
            }
            req.setAttribute("course", course);
            req.setAttribute("courseId", courseId);
        } else if (moduleIdStr != null && !moduleIdStr.trim().isEmpty()) {
            long moduleId = Long.parseLong(moduleIdStr.trim());
            List<QuizDto> quizzes = quizService.getQuizzes(moduleId);
            req.setAttribute("quizzes", quizzes);
            req.setAttribute("moduleId", moduleId);
        }

        req.getRequestDispatcher("/WEB-INF/views/quiz/list.jsp").forward(req, resp);
    }

    private void showQuizDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String quizIdStr = req.getParameter("id");
        String courseIdStr = req.getParameter("courseId");
        if (quizIdStr != null) {
            long quizId = Long.parseLong(quizIdStr);
            QuizDto quiz = quizService.getQuizDetail(quizId);
            req.setAttribute("quiz", quiz);

            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                req.setAttribute("courseId", Long.parseLong(courseIdStr.trim()));
            } else {
                try (java.sql.Connection con = util.DbConnection.getConnection()) {
                    moduleDao.findById(con, quiz.getModuleId()).ifPresent(m -> req.setAttribute("courseId", m.getCourseId()));
                } catch (Exception ignored) {
                }
            }
        }
        req.getRequestDispatcher("/WEB-INF/views/quiz/detail.jsp").forward(req, resp);
    }

    private void saveQuiz(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String courseIdStr = req.getParameter("courseId");
        QuizDto dto = bindQuiz(req);
        try {
            long id = quizService.saveQuiz(dto);
            String target = req.getContextPath() + "/quizzes/detail?id=" + id;
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                target += "&courseId=" + courseIdStr.trim();
            }
            resp.sendRedirect(target);
        } catch (Exception e) {
            String redirectUrl = req.getContextPath() + "/quizzes/list?";
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                redirectUrl += "courseId=" + courseIdStr.trim();
            } else {
                redirectUrl += "moduleId=" + dto.getModuleId();
            }
            resp.sendRedirect(redirectUrl + "&error=" + java.net.URLEncoder.encode(e.getMessage(), java.nio.charset.StandardCharsets.UTF_8));
        }
    }

    private void deleteQuiz(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String quizIdStr = req.getParameter("id");
        String courseIdStr = req.getParameter("courseId");
        String moduleIdStr = req.getParameter("moduleId");
        if (quizIdStr != null) {
            quizService.deleteQuiz(Long.parseLong(quizIdStr));
        }
        if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/quizzes/list?courseId=" + courseIdStr.trim() + "&success=deleted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/quizzes/list?moduleId=" + moduleIdStr + "&success=deleted");
        }
    }

    private void showQuestionBank(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String moduleIdStr = req.getParameter("moduleId");
        if (moduleIdStr != null) {
            long moduleId = Long.parseLong(moduleIdStr);
            List<QuestionDto> questions = quizService.getQuestionBank(moduleId);
            req.setAttribute("questions", questions);
            req.setAttribute("moduleId", moduleId);
        }
        req.getRequestDispatcher("/WEB-INF/views/quiz/question_bank.jsp").forward(req, resp);
    }

    private void showQuestionDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String qIdStr = req.getParameter("id");
        if (qIdStr != null) {
            long qId = Long.parseLong(qIdStr);
            QuestionDto question = quizService.getQuestion(qId);
            req.setAttribute("question", question);
        }
        req.getRequestDispatcher("/WEB-INF/views/quiz/question_detail.jsp").forward(req, resp);
    }

    private void saveQuestion(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        QuestionDto dto = bindQuestion(req);
        try {
            quizService.saveQuestion(dto);
            resp.sendRedirect(req.getContextPath() + "/quizzes/question-bank?moduleId=" + dto.getModuleId());
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/quizzes/question-bank?moduleId=" + dto.getModuleId() + "&error=" + e.getMessage());
        }
    }

    private void deleteQuestion(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String qIdStr = req.getParameter("id");
        String moduleIdStr = req.getParameter("moduleId");
        if (qIdStr != null) {
            quizService.deleteQuestion(Long.parseLong(qIdStr));
        }
        resp.sendRedirect(req.getContextPath() + "/quizzes/question-bank?moduleId=" + moduleIdStr);
    }

    private void assignQuestion(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        long quizId = Long.parseLong(req.getParameter("quizId"));
        long questionId = Long.parseLong(req.getParameter("questionId"));
        String pointsStr = req.getParameter("points");
        BigDecimal points = pointsStr != null && !pointsStr.trim().isEmpty() ? new BigDecimal(pointsStr.trim()) : BigDecimal.ONE;
        int order = Integer.parseInt(req.getParameter("order"));

        quizService.assignQuestion(quizId, questionId, points, order);
        resp.sendRedirect(req.getContextPath() + "/quizzes/detail?id=" + quizId);
    }

    private void removeQuestion(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        long quizId = Long.parseLong(req.getParameter("quizId"));
        long questionId = Long.parseLong(req.getParameter("questionId"));
        quizService.removeQuestion(quizId, questionId);
        resp.sendRedirect(req.getContextPath() + "/quizzes/detail?id=" + quizId);
    }

    private void reorderQuestions(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        long quizId = Long.parseLong(req.getParameter("quizId"));
        String[] ids = req.getParameterValues("questionIds");
        if (ids != null) {
            List<Long> orderedIds = Arrays.stream(ids).map(Long::parseLong).collect(Collectors.toList());
            quizService.reorderQuestions(quizId, orderedIds);
        }
        resp.sendRedirect(req.getContextPath() + "/quizzes/detail?id=" + quizId);
    }

    private void showAttempt(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long regId = Long.parseLong(req.getParameter("registrationId"));
        long quizId = Long.parseLong(req.getParameter("quizId"));
        QuizAttemptDto attempt = quizService.startAttempt(regId, quizId);
        QuizDto quiz = quizService.getQuizDetail(quizId);

        req.setAttribute("attempt", attempt);
        req.setAttribute("quiz", quiz);
        req.getRequestDispatcher("/WEB-INF/views/quiz/take.jsp").forward(req, resp);
    }

    private void submitAttempt(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        QuizAttemptDto dto = bindAttempt(req);
        QuizResultDto result = quizService.submitAttempt(dto);
        req.getSession().setAttribute("lastQuizResult", result);
        resp.sendRedirect(req.getContextPath() + "/quizzes/result?registrationId=" + dto.getRegistrationId() + "&quizId=" + dto.getQuizId());
    }

    private void showResult(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long regId = Long.parseLong(req.getParameter("registrationId"));
        long quizId = Long.parseLong(req.getParameter("quizId"));
        QuizResultDto result = quizService.getResult(regId, quizId);
        req.setAttribute("result", result);
        req.getRequestDispatcher("/WEB-INF/views/quiz/result.jsp").forward(req, resp);
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
        dto.setPassScore(passScoreStr != null && !passScoreStr.trim().isEmpty() ? new BigDecimal(passScoreStr.trim()) : BigDecimal.valueOf(50.0));
        String timeLimitStr = req.getParameter("timeLimitMinutes");
        dto.setTimeLimitMinutes(timeLimitStr != null && !timeLimitStr.trim().isEmpty() ? Integer.parseInt(timeLimitStr.trim()) : null);
        String orderStr = req.getParameter("orderIndex");
        dto.setOrderIndex(orderStr != null && !orderStr.trim().isEmpty() ? Integer.parseInt(orderStr.trim()) : 1);
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
        dto.setDefaultPoints(pointsStr != null && !pointsStr.trim().isEmpty() ? new BigDecimal(pointsStr.trim()) : BigDecimal.ONE);

        String[] optionTexts = req.getParameterValues("optionText");
        String correctIndexStr = req.getParameter("correctOption");
        int correctIndex = (correctIndexStr != null && !correctIndexStr.trim().isEmpty()) ? Integer.parseInt(correctIndexStr) : -1;

        if (optionTexts != null) {
            for (int i = 0; i < optionTexts.length; i++) {
                boolean isCorrect = (i == correctIndex);
                dto.getOptions().add(new AnswerOptionDto(null, dto.getId(), optionTexts[i], isCorrect, i + 1));
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
                String selectedOptStr = req.getParameter("question_" + qId);
                Long selectedOpt = (selectedOptStr != null && !selectedOptStr.trim().isEmpty()) ? Long.parseLong(selectedOptStr) : null;
                dto.getAnswers().add(new QuizAnswerDto(qId, selectedOpt, false, BigDecimal.ZERO));
            }
        }
        return dto;
    }
}
