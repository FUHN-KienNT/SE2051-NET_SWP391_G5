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
}
