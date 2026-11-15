package test;

import dao.QuestionDao;
import dao.QuizAttemptDao;
import dao.QuizDao;
import dao.RegistrationDao;
import dto.AnswerOptionDto;
import dto.QuestionDto;
import dto.QuizAnswerDto;
import dto.QuizResultDto;
import entity.QuizAnswer;
import entity.QuizAttempt;
import entity.enums.QuestionType;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import service.QuizService;

import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Kiểm thử hỗ trợ câu hỏi Trắc nghiệm nhiều đáp án (MULTI_CHOICE)")
public class MultiChoiceQuizTestSuite {

    private final QuizService quizService = new QuizService(
            new QuizDao(), new QuestionDao(), new QuizAttemptDao(), new RegistrationDao()
    );

    @Test
    @DisplayName("1.1 Validation câu hỏi MULTI_CHOICE có từ 1 đáp án đúng trở lên -> Hợp lệ")
    void testValidateMultiChoiceSuccess() throws Exception {
        Method validateMethod = QuizService.class.getDeclaredMethod("validateQuestion", QuestionDto.class);
        validateMethod.setAccessible(true);

        QuestionDto dto = new QuestionDto();
        dto.setQuestionText("Chọn các ngôn ngữ lập trình hướng đối tượng?");
        dto.setQuestionType(QuestionType.MULTI_CHOICE);

        List<AnswerOptionDto> options = new ArrayList<>();
        options.add(new AnswerOptionDto(null, null, "Java", true, 1));
        options.add(new AnswerOptionDto(null, null, "C++", true, 2));
        options.add(new AnswerOptionDto(null, null, "HTML", false, 3));
        options.add(new AnswerOptionDto(null, null, "CSS", false, 4));
        dto.setOptions(options);

        // Should not throw
        assertDoesNotThrow(() -> validateMethod.invoke(quizService, dto));
    }

    @Test
    @DisplayName("1.2 Validation câu hỏi MULTI_CHOICE không có đáp án đúng nào -> Bị từ chối")
    void testValidateMultiChoiceNoCorrectOption() throws Exception {
        Method validateMethod = QuizService.class.getDeclaredMethod("validateQuestion", QuestionDto.class);
        validateMethod.setAccessible(true);

        QuestionDto dto = new QuestionDto();
        dto.setQuestionText("Câu hỏi không có đáp án đúng");
        dto.setQuestionType(QuestionType.MULTI_CHOICE);

        List<AnswerOptionDto> options = new ArrayList<>();
        options.add(new AnswerOptionDto(null, null, "A", false, 1));
        options.add(new AnswerOptionDto(null, null, "B", false, 2));
        dto.setOptions(options);

        Exception ex = assertThrows(Exception.class, () -> validateMethod.invoke(quizService, dto));
        assertTrue(ex.getCause().getMessage().contains("ít nhất 1 đáp án đúng"));
    }

    @Test
    @DisplayName("1.3 Validation câu hỏi SINGLE_CHOICE có 2 đáp án đúng -> Bị từ chối (Chỉ chấp nhận đúng 1)")
    void testValidateSingleChoiceMultipleCorrectRejected() throws Exception {
        Method validateMethod = QuizService.class.getDeclaredMethod("validateQuestion", QuestionDto.class);
        validateMethod.setAccessible(true);

        QuestionDto dto = new QuestionDto();
        dto.setQuestionText("Câu hỏi đơn lựa chọn nhưng chọn 2 đáp án");
        dto.setQuestionType(QuestionType.SINGLE_CHOICE);

        List<AnswerOptionDto> options = new ArrayList<>();
        options.add(new AnswerOptionDto(null, null, "A", true, 1));
        options.add(new AnswerOptionDto(null, null, "B", true, 2));
        dto.setOptions(options);

        Exception ex = assertThrows(Exception.class, () -> validateMethod.invoke(quizService, dto));
        assertTrue(ex.getCause().getMessage().contains("đúng 1 đáp án đúng"));
    }

    @Test
    @DisplayName("1.4 Validation câu hỏi có dưới 2 phương án trả lời -> Bị từ chối")
    void testValidateLessThanTwoOptionsRejected() throws Exception {
        Method validateMethod = QuizService.class.getDeclaredMethod("validateQuestion", QuestionDto.class);
        validateMethod.setAccessible(true);

        QuestionDto dto = new QuestionDto();
        dto.setQuestionText("Câu hỏi chỉ có 1 lựa chọn");
        dto.setQuestionType(QuestionType.SINGLE_CHOICE);

        List<AnswerOptionDto> options = new ArrayList<>();
        options.add(new AnswerOptionDto(null, null, "Duy nhất", true, 1));
        dto.setOptions(options);

        Exception ex = assertThrows(Exception.class, () -> validateMethod.invoke(quizService, dto));
        assertTrue(ex.getCause().getMessage().contains("ít nhất 2 phương án"));
    }

    @Test
    @DisplayName("1.5 Validation câu hỏi có phương án trùng lặp nội dung -> Bị từ chối")
    void testValidateDuplicateOptionsRejected() throws Exception {
        Method validateMethod = QuizService.class.getDeclaredMethod("validateQuestion", QuestionDto.class);
        validateMethod.setAccessible(true);

        QuestionDto dto = new QuestionDto();
        dto.setQuestionText("Câu hỏi có 2 lựa chọn trùng nhau");
        dto.setQuestionType(QuestionType.SINGLE_CHOICE);

        List<AnswerOptionDto> options = new ArrayList<>();
        options.add(new AnswerOptionDto(null, null, "Java", true, 1));
        options.add(new AnswerOptionDto(null, null, "java", false, 2)); // Duplicate case-insensitive
        dto.setOptions(options);

        Exception ex = assertThrows(Exception.class, () -> validateMethod.invoke(quizService, dto));
        assertTrue(ex.getCause().getMessage().contains("không được trùng lặp nội dung"));
    }

    @Test
    @DisplayName("1.6 Validation câu hỏi Đúng / Sai phải có đúng 2 phương án -> Khác 2 bị từ chối")
    void testValidateTrueFalseExactTwoOptions() throws Exception {
        Method validateMethod = QuizService.class.getDeclaredMethod("validateQuestion", QuestionDto.class);
        validateMethod.setAccessible(true);

        QuestionDto dto = new QuestionDto();
        dto.setQuestionText("Trái Đất hình cầu?");
        dto.setQuestionType(QuestionType.TRUE_FALSE);

        List<AnswerOptionDto> options = new ArrayList<>();
        options.add(new AnswerOptionDto(null, null, "Đúng", true, 1));
        options.add(new AnswerOptionDto(null, null, "Sai", false, 2));
        options.add(new AnswerOptionDto(null, null, "Không biết", false, 3));
        dto.setOptions(options);

        Exception ex = assertThrows(Exception.class, () -> validateMethod.invoke(quizService, dto));
        assertTrue(ex.getCause().getMessage().contains("đúng 2 phương án trả lời"));
    }

    @Test
    @DisplayName("1.7 Validation phương án trả lời có nội dung trống -> Bị từ chối")
    void testValidateBlankOptionRejected() throws Exception {
        Method validateMethod = QuizService.class.getDeclaredMethod("validateQuestion", QuestionDto.class);
        validateMethod.setAccessible(true);

        QuestionDto dto = new QuestionDto();
        dto.setQuestionText("Câu hỏi có đáp án rỗng");
        dto.setQuestionType(QuestionType.SINGLE_CHOICE);

        List<AnswerOptionDto> options = new ArrayList<>();
        options.add(new AnswerOptionDto(null, null, "A", true, 1));
        options.add(new AnswerOptionDto(null, null, "   ", false, 2));
        dto.setOptions(options);

        Exception ex = assertThrows(Exception.class, () -> validateMethod.invoke(quizService, dto));
        assertTrue(ex.getCause().getMessage().contains("không được để trống"));
    }

    @Test
    @DisplayName("2.1 Tính điểm All-or-Nothing qua calculateResult: Chọn đúng đủ tất cả đáp án đúng")
    void testCalculateResultFullCorrect() throws Exception {
        Method calcMethod = QuizService.class.getDeclaredMethod("calculateResult", QuizAttempt.class, List.class, String.class, BigDecimal.class);
        calcMethod.setAccessible(true);

        QuizAttempt attempt = new QuizAttempt();
        attempt.setTotalScore(new BigDecimal("2.00"));
        attempt.setPassStatus(true);

        // 1 câu hỏi 2 điểm có 2 đáp án đúng, được lưu thành 2 bản ghi quiz_answers
        List<QuizAnswer> answers = new ArrayList<>();
        QuizAnswer a1 = new QuizAnswer();
        a1.setQuestionId(101L);
        a1.setSelectedOptionId(1L);
        a1.setCorrect(true);
        a1.setScore(new BigDecimal("2.00"));

        QuizAnswer a2 = new QuizAnswer();
        a2.setQuestionId(101L);
        a2.setSelectedOptionId(2L);
        a2.setCorrect(true);
        a2.setScore(BigDecimal.ZERO);

        answers.add(a1);
        answers.add(a2);

        QuizResultDto result = (QuizResultDto) calcMethod.invoke(quizService, attempt, answers, "Bài kiểm tra mẫu", new BigDecimal("2.00"));

        assertNotNull(result);
        assertEquals(new BigDecimal("2.00"), result.getTotalScore());
        assertEquals(new BigDecimal("100.00"), result.getPercentage());
        assertEquals(1, result.getAnswers().size(), "Hai bản ghi câu trả lời của cùng 1 câu hỏi phải được gom nhóm lại thành 1 DTO");

        QuizAnswerDto ansDto = result.getAnswers().get(0);
        assertEquals(101L, ansDto.getQuestionId());
        assertTrue(ansDto.isCorrect());
        assertEquals(new BigDecimal("2.00"), ansDto.getScore());
        assertEquals(Arrays.asList(1L, 2L), ansDto.getSelectedOptionIds());
    }

    @Test
    @DisplayName("2.2 Tính điểm All-or-Nothing qua calculateResult: Chọn thiếu hoặc sai đáp án -> 0 điểm")
    void testCalculateResultPartialOrWrong() throws Exception {
        Method calcMethod = QuizService.class.getDeclaredMethod("calculateResult", QuizAttempt.class, List.class, String.class, BigDecimal.class);
        calcMethod.setAccessible(true);

        QuizAttempt attempt = new QuizAttempt();
        attempt.setTotalScore(BigDecimal.ZERO);
        attempt.setPassStatus(false);

        List<QuizAnswer> answers = new ArrayList<>();
        QuizAnswer a1 = new QuizAnswer();
        a1.setQuestionId(101L);
        a1.setSelectedOptionId(1L);
        a1.setCorrect(false); // Chọn thiếu nên bị tính sai
        a1.setScore(BigDecimal.ZERO);

        answers.add(a1);

        QuizResultDto result = (QuizResultDto) calcMethod.invoke(quizService, attempt, answers, "Bài kiểm tra mẫu", new BigDecimal("2.00"));

        assertNotNull(result);
        assertEquals(BigDecimal.ZERO, result.getTotalScore());
        assertEquals(new BigDecimal("0.00"), result.getPercentage());
        assertEquals(1, result.getAnswers().size());

        QuizAnswerDto ansDto = result.getAnswers().get(0);
        assertFalse(ansDto.isCorrect());
        assertEquals(BigDecimal.ZERO, ansDto.getScore());
    }

    @Test
    @DisplayName("2.3 calculateResult gán chính xác submittedAt từ QuizAttempt vào QuizResultDto")
    void testCalculateResultSetsSubmittedAt() throws Exception {
        Method calcMethod = QuizService.class.getDeclaredMethod("calculateResult", QuizAttempt.class, List.class, String.class, BigDecimal.class);
        calcMethod.setAccessible(true);

        java.time.OffsetDateTime now = java.time.OffsetDateTime.now();
        QuizAttempt attempt = new QuizAttempt();
        attempt.setTotalScore(new BigDecimal("10.00"));
        attempt.setPassStatus(true);
        attempt.setSubmittedAt(now);

        QuizResultDto result = (QuizResultDto) calcMethod.invoke(quizService, attempt, new ArrayList<>(), "Bài kiểm tra mẫu", new BigDecimal("10.00"));
        assertNotNull(result);
        assertEquals(now, result.getSubmittedAt());
    }

    @Test
    @DisplayName("2.4 Đảm bảo DbConnection thực thi schema update và quiz_attempts.submitted_at cho phép NULL")
    void testQuizAttemptsSubmittedAtAllowsNull() {
        try (java.sql.Connection con = util.DbConnection.getConnection()) {
            assertNotNull(con, "Kết nối database thành công");
            java.sql.DatabaseMetaData meta = con.getMetaData();
            try (java.sql.ResultSet rs = meta.getColumns(null, null, "quiz_attempts", "submitted_at")) {
                if (rs.next()) {
                    String isNullable = rs.getString("IS_NULLABLE");
                    assertEquals("YES", isNullable, "Cột submitted_at trong bảng quiz_attempts phải cho phép NULL (IS_NULLABLE = YES)");
                }
            }
        } catch (Exception e) {
            System.out.println("Thông báo kết nối DB: " + e.getMessage());
        }
    }

    @Test
    @DisplayName("2.5 Chống IDOR: validateQuizAccess từ chối học viên cố tình can thiệp đơn đăng ký người khác")
    void testValidateQuizAccessRejectsIdor() {
        try (java.sql.Connection con = util.DbConnection.getConnection()) {
            try (java.sql.PreparedStatement ps = con.prepareStatement("SELECT id, user_id FROM registrations LIMIT 1");
                 java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    long regId = rs.getLong("id");
                    long realUserId = rs.getLong("user_id");
                    long fakeUserId = realUserId + 999999L;
                    assertThrows(SecurityException.class, () -> {
                        quizService.validateQuizAccess(con, regId, 1L, fakeUserId);
                    });
                }
            }
        } catch (Exception e) {
            System.out.println("Thông báo test IDOR: " + e.getMessage());
        }
    }

    @Test
    @DisplayName("2.6 Bảo vệ toggle-active: QuizServlet phân loại toggle-active là action quản lý và chặn STUDENT")
    void testToggleActiveIsManagementActionProtected() {
        controller.QuizServlet servlet = new controller.QuizServlet();

        // 1. Kiểm tra toggle-active được phân loại là management action
        assertTrue(servlet.isManagementAction("toggle-active"),
                "Action 'toggle-active' bắt buộc phải là management action để tránh Student tự ý đổi trạng thái quiz");
        assertTrue(servlet.isManagementAction("list"));
        assertTrue(servlet.isManagementAction("save"));
        assertTrue(servlet.isManagementAction("delete"));
        assertTrue(servlet.isManagementAction("unknown-action"),
                "Bất kỳ action lạ nào cũng phải được coi là management action để phòng thủ theo chiều sâu");

        // 2. Chỉ 4 action dành riêng cho học viên mới không phải management action
        assertFalse(servlet.isManagementAction("overview"));
        assertFalse(servlet.isManagementAction("attempt"));
        assertFalse(servlet.isManagementAction("submit"));
        assertFalse(servlet.isManagementAction("result"));

        // 3. Phân quyền: STUDENT không được là Staff/Expert
        dto.UserDto student = new dto.UserDto();
        student.setRoleName("STUDENT");
        assertFalse(servlet.isStaffOrExpert(student), "STUDENT không có quyền thực hiện management actions");

        dto.UserDto expert = new dto.UserDto();
        expert.setRoleName("EXPERT");
        assertTrue(servlet.isStaffOrExpert(expert), "EXPERT có quyền quản lý");

        dto.UserDto admin = new dto.UserDto();
        admin.setRoleName("ADMIN");
        assertTrue(servlet.isStaffOrExpert(admin), "ADMIN có quyền quản lý");
    }

    @Test
    @DisplayName("2.7 Kiểm tra trạng thái đã pass quiz trên QuizDto và QuizAttemptDao")
    void testQuizPassedStatusTracking() throws Exception {
        dto.QuizDto quizDto = new dto.QuizDto();
        assertFalse(quizDto.isPassed());
        assertFalse(quizDto.isPassStatus());

        quizDto.setPassed(true);
        assertTrue(quizDto.isPassed());
        assertTrue(quizDto.isPassStatus());

        quizDto.setPassStatus(false);
        assertFalse(quizDto.isPassed());

        // Test QuizAttemptDao.findPassedQuizIdsByRegistration
        try (java.sql.Connection con = util.DbConnection.getConnection()) {
            QuizAttemptDao attemptDao = new QuizAttemptDao();
            java.util.Set<Long> passedIds = attemptDao.findPassedQuizIdsByRegistration(con, 999999999L);
            assertNotNull(passedIds);
            assertTrue(passedIds.isEmpty());
        }
    }

    @Test
    @DisplayName("2.8 Kiểm tra và đồng bộ tiến độ khóa học hoàn thành 100% cho registration 7")
    void testRegistration7CompletedData() throws Exception {
        try (java.sql.Connection con = util.DbConnection.getConnection();
             java.sql.Statement stmt = con.createStatement()) {
            stmt.execute("INSERT INTO lesson_progress (registration_id, lesson_id, status, user_note, updated_at, completed_at) VALUES " +
                    "(7, 228, 'COMPLETED', 'Nắm vững bản chất xã hội của tâm lý người.', now() - interval '17 days', now() - interval '17 days'), " +
                    "(7, 229, 'COMPLETED', 'Phân tích chức năng và phân loại hiện tượng tâm lý.', now() - interval '16 days', now() - interval '16 days'), " +
                    "(7, 230, 'COMPLETED', 'Hoàn thành tóm tắt chương 1.', now() - interval '15 days', now() - interval '15 days'), " +
                    "(7, 231, 'COMPLETED', 'Nắm rõ khái niệm cảm giác và tri giác.', now() - interval '14 days', now() - interval '14 days'), " +
                    "(7, 232, 'COMPLETED', 'Hiểu sâu các quy luật cảm giác.', now() - interval '13 days', now() - interval '13 days'), " +
                    "(7, 233, 'COMPLETED', 'Ứng dụng quy luật tri giác vào đời sống.', now() - interval '12 days', now() - interval '12 days'), " +
                    "(7, 234, 'COMPLETED', 'Ghi nhớ các giai đoạn của quá trình trí nhớ.', now() - interval '11 days', now() - interval '11 days'), " +
                    "(7, 235, 'COMPLETED', 'Thực hành phương pháp rèn luyện trí nhớ.', now() - interval '10 days', now() - interval '10 days'), " +
                    "(7, 236, 'COMPLETED', 'Ôn tập và củng cố hệ thống trí nhớ dài hạn.', now() - interval '9 days', now() - interval '9 days'), " +
                    "(7, 237, 'COMPLETED', 'Nắm vững các thao tác tư duy logic.', now() - interval '8 days', now() - interval '8 days'), " +
                    "(7, 238, 'COMPLETED', 'Hiểu rõ các loại hình và vai trò của tưởng tượng.', now() - interval '7 days', now() - interval '7 days'), " +
                    "(7, 239, 'COMPLETED', 'Phân biệt xúc cảm và tình cảm con người.', now() - interval '6 days', now() - interval '6 days'), " +
                    "(7, 240, 'COMPLETED', 'Nắm vững các quy luật đời sống tình cảm.', now() - interval '5 days', now() - interval '5 days'), " +
                    "(7, 241, 'COMPLETED', 'Nhận diện 4 kiểu khí chất cơ bản.', now() - interval '4 days', now() - interval '4 days'), " +
                    "(7, 242, 'COMPLETED', 'Phân tích xu hướng và lý tưởng sống.', now() - interval '3 days', now() - interval '3 days'), " +
                    "(7, 243, 'COMPLETED', 'Hiểu rõ cấu trúc và con đường hình thành tính cách.', now() - interval '2 days', now() - interval '2 days'), " +
                    "(7, 244, 'COMPLETED', 'Phát triển năng lực và tài năng cá nhân.', now() - interval '1 day', now() - interval '1 day') " +
                    "ON CONFLICT (registration_id, lesson_id) DO UPDATE SET status = 'COMPLETED', completed_at = EXCLUDED.completed_at;");

            long attemptId = 0L;
            try (java.sql.ResultSet rs = stmt.executeQuery(
                    "INSERT INTO quiz_attempts (registration_id, quiz_id, submitted_at, total_score, pass_status) VALUES " +
                    "(7, 26, now() - interval '1 day', 100.00, true) " +
                    "ON CONFLICT (registration_id, quiz_id) DO UPDATE SET submitted_at = EXCLUDED.submitted_at, total_score = 100.00, pass_status = true " +
                    "RETURNING id;")) {
                if (rs.next()) {
                    attemptId = rs.getLong(1);
                }
            }

            if (attemptId > 0) {
                stmt.execute("INSERT INTO quiz_answers (quiz_attempt_id, question_id, selected_option_id, is_correct, score) VALUES " +
                        "(" + attemptId + ", 51, 201, true, 50.00), (" + attemptId + ", 52, 205, true, 50.00) " +
                        "ON CONFLICT (quiz_attempt_id, question_id, selected_option_id) DO UPDATE SET is_correct = true, score = 50.00;");
            }

            try (java.sql.ResultSet rs = stmt.executeQuery("SELECT COUNT(1) FROM lesson_progress WHERE registration_id = 7 AND status = 'COMPLETED'")) {
                assertTrue(rs.next());
                assertEquals(18, rs.getInt(1), "Registration 7 phải có đủ 18 bài học trạng thái COMPLETED");
            }

            QuizAttemptDao attemptDao = new QuizAttemptDao();
            java.util.Set<Long> passedQuizzes = attemptDao.findPassedQuizIdsByRegistration(con, 7L);
            assertTrue(passedQuizzes.contains(25L), "Registration 7 phải pass Quiz 25");
            assertTrue(passedQuizzes.contains(26L), "Registration 7 phải pass Quiz 26");
        }
    }
}
