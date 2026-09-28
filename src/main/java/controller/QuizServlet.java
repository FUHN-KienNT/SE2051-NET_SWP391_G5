package controller;

import dao.QuestionDao;
import dao.QuizAttemptDao;
import dao.QuizDao;
import dao.RegistrationDao;
import dto.AnswerOptionDto;
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
import service.QuizService;

@WebServlet(name = "QuizServlet", urlPatterns = {"/quizzes/*"})
public class QuizServlet extends HttpServlet {
    private QuizService quizService;

    @Override
    public void init() throws ServletException {
        this.quizService = new QuizService(
                new QuizDao(), new QuestionDao(), new QuizAttemptDao(), new RegistrationDao()
        );
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
        String moduleIdStr = req.getParameter("moduleId");
        if (moduleIdStr != null) {
            long moduleId = Long.parseLong(moduleIdStr);
            List<QuizDto> quizzes = quizService.getQuizzes(moduleId);
            req.setAttribute("quizzes", quizzes);
            req.setAttribute("moduleId", moduleId);
        }
        req.getRequestDispatcher("/WEB-INF/views/quiz/list.jsp").forward(req, resp);
    }

    private void showQuizDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String quizIdStr = req.getParameter("id");
        if (quizIdStr != null) {
            long quizId = Long.parseLong(quizIdStr);
            QuizDto quiz = quizService.getQuizDetail(quizId);
            req.setAttribute("quiz", quiz);
        }
        req.getRequestDispatcher("/WEB-INF/views/quiz/detail.jsp").forward(req, resp);
    }

    private void saveQuiz(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        QuizDto dto = bindQuiz(req);
        try {
            long id = quizService.saveQuiz(dto);
            resp.sendRedirect(req.getContextPath() + "/quizzes/detail?id=" + id);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/quizzes/list?moduleId=" + dto.getModuleId() + "&error=" + e.getMessage());
        }
    }

    private void deleteQuiz(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String quizIdStr = req.getParameter("id");
        String moduleIdStr = req.getParameter("moduleId");
        if (quizIdStr != null) {
            quizService.deleteQuiz(Long.parseLong(quizIdStr));
        }
        resp.sendRedirect(req.getContextPath() + "/quizzes/list?moduleId=" + moduleIdStr);
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
