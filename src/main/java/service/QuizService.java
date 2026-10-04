package service;

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
import entity.AnswerOption;
import entity.Question;
import entity.Quiz;
import entity.QuizAnswer;
import entity.QuizAttempt;
import entity.QuizQuestion;
import entity.Registration;
import entity.enums.RegistrationStatus;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import util.DbConnection;
import util.ValidationUtil;

public class QuizService {
    private final QuizDao quizDao;
    private final QuestionDao questionDao;
    private final QuizAttemptDao quizAttemptDao;
    private final RegistrationDao registrationDao;

    public QuizService(QuizDao quizDao, QuestionDao questionDao,
                       QuizAttemptDao quizAttemptDao, RegistrationDao registrationDao) {
        this.quizDao = quizDao;
        this.questionDao = questionDao;
        this.quizAttemptDao = quizAttemptDao;
        this.registrationDao = registrationDao;
    }

    public List<QuizDto> getQuizzes(long moduleId) {
        try (Connection con = DbConnection.getConnection()) {
            List<Quiz> quizzes = quizDao.findByModuleId(con, moduleId);
            List<QuizDto> dtos = new ArrayList<>();
            for (Quiz q : quizzes) {
                dtos.add(getQuizDetail(q.getId()));
            }
            return dtos;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách bài thi: " + e.getMessage(), e);
        }
    }

    public QuizDto getQuizDetail(long quizId) {
        try (Connection con = DbConnection.getConnection()) {
            Quiz quiz = quizDao.findById(con, quizId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài thi ID: " + quizId));
            QuizDto dto = new QuizDto();
            dto.setId(quiz.getId());
            dto.setModuleId(quiz.getModuleId());
            dto.setTitle(quiz.getTitle());
            dto.setPassScore(quiz.getPassScore());
            dto.setTimeLimitMinutes(quiz.getTimeLimitMinutes());
            dto.setOrderIndex(quiz.getOrderIndex());

            List<QuizQuestion> assignments = quizDao.findAssignments(con, quizId);
            for (QuizQuestion qq : assignments) {
                Optional<Question> qOpt = questionDao.findById(con, qq.getQuestionId());
                if (qOpt.isPresent()) {
                    Question q = qOpt.get();
                    QuestionDto qDto = new QuestionDto();
                    qDto.setId(q.getId());
                    qDto.setModuleId(q.getModuleId());
                    qDto.setQuestionText(q.getQuestionText());
                    qDto.setQuestionType(q.getQuestionType());
                    qDto.setDefaultPoints(q.getDefaultPoints());
                    qDto.setAssignedPoints(qq.getPoints());
                    qDto.setQuizOrderIndex(qq.getOrderIndex());

                    List<AnswerOption> options = questionDao.findOptions(con, q.getId());
                    for (AnswerOption opt : options) {
                        qDto.getOptions().add(new AnswerOptionDto(
                                opt.getId(), opt.getQuestionId(), opt.getOptionText(),
                                opt.isCorrect(), opt.getOrderIndex()
                        ));
                    }
                    dto.getQuestions().add(qDto);
                }
            }
            return dto;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy chi tiết bài thi: " + e.getMessage(), e);
        }
    }

    public long saveQuiz(QuizDto dto) {
        if (dto == null || dto.getModuleId() == null) {
            throw new IllegalArgumentException("Thông tin bài thi không hợp lệ.");
        }
        ValidationUtil.requireText(dto.getTitle(), "Tiêu đề bài thi");
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                long id;
                if (dto.getId() != null && dto.getId() > 0) {
                    Quiz q = quizDao.findById(con, dto.getId())
                            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài thi cần cập nhật."));
                    q.setTitle(dto.getTitle().trim());
                    q.setPassScore(dto.getPassScore() != null ? dto.getPassScore() : BigDecimal.valueOf(50.0));
                    q.setTimeLimitMinutes(dto.getTimeLimitMinutes());
                    q.setOrderIndex(dto.getOrderIndex());
                    quizDao.update(con, q);
                    id = q.getId();
                } else {
                    Quiz q = new Quiz();
                    q.setModuleId(dto.getModuleId());
                    q.setTitle(dto.getTitle().trim());
                    q.setPassScore(dto.getPassScore() != null ? dto.getPassScore() : BigDecimal.valueOf(50.0));
                    q.setTimeLimitMinutes(dto.getTimeLimitMinutes());
                    q.setOrderIndex(dto.getOrderIndex());
                    id = quizDao.insert(con, q);
                }
                con.commit();
                return id;
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lưu bài thi: " + e.getMessage(), e);
        }
    }

    public void deleteQuiz(long quizId) {
        try (Connection con = DbConnection.getConnection()) {
            boolean deleted = quizDao.delete(con, quizId);
            if (!deleted) {
                throw new IllegalArgumentException("Không tìm thấy bài thi cần xóa.");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi xóa bài thi: " + e.getMessage(), e);
        }
    }

    public List<QuestionDto> getQuestionBank(long moduleId) {
        try (Connection con = DbConnection.getConnection()) {
            List<Question> list = questionDao.findByModuleId(con, moduleId);
            List<QuestionDto> dtos = new ArrayList<>();
            for (Question q : list) {
                QuestionDto qDto = new QuestionDto();
                qDto.setId(q.getId());
                qDto.setModuleId(q.getModuleId());
                qDto.setQuestionText(q.getQuestionText());
                qDto.setQuestionType(q.getQuestionType());
                qDto.setDefaultPoints(q.getDefaultPoints());

                List<AnswerOption> options = questionDao.findOptions(con, q.getId());
                for (AnswerOption opt : options) {
                    qDto.getOptions().add(new AnswerOptionDto(
                            opt.getId(), opt.getQuestionId(), opt.getOptionText(),
                            opt.isCorrect(), opt.getOrderIndex()
                    ));
                }
                dtos.add(qDto);
            }
            return dtos;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy ngân hàng câu hỏi: " + e.getMessage(), e);
        }
    }

    public QuestionDto getQuestion(long questionId) {
        try (Connection con = DbConnection.getConnection()) {
            Question q = questionDao.findById(con, questionId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy câu hỏi ID: " + questionId));
            QuestionDto dto = new QuestionDto();
            dto.setId(q.getId());
            dto.setModuleId(q.getModuleId());
            dto.setQuestionText(q.getQuestionText());
            dto.setQuestionType(q.getQuestionType());
            dto.setDefaultPoints(q.getDefaultPoints());

            List<AnswerOption> options = questionDao.findOptions(con, q.getId());
            for (AnswerOption opt : options) {
                dto.getOptions().add(new AnswerOptionDto(
                        opt.getId(), opt.getQuestionId(), opt.getOptionText(),
                        opt.isCorrect(), opt.getOrderIndex()
                ));
            }
            return dto;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi truy xuất câu hỏi: " + e.getMessage(), e);
        }
    }

    public long saveQuestion(QuestionDto dto) {
        validateQuestion(dto);
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                long qId;
                if (dto.getId() != null && dto.getId() > 0) {
                    Question q = questionDao.findById(con, dto.getId())
                            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy câu hỏi cần sửa."));
                    q.setQuestionText(dto.getQuestionText().trim());
                    q.setQuestionType(dto.getQuestionType());
                    q.setDefaultPoints(dto.getDefaultPoints());
                    questionDao.update(con, q);
                    qId = q.getId();
                } else {
                    Question q = new Question();
                    q.setModuleId(dto.getModuleId());
                    q.setQuestionText(dto.getQuestionText().trim());
                    q.setQuestionType(dto.getQuestionType());
                    q.setDefaultPoints(dto.getDefaultPoints());
                    qId = questionDao.insert(con, q);
                }

                if (dto.getOptions() != null) {
                    List<AnswerOption> entityOptions = new ArrayList<>();
                    for (AnswerOptionDto optDto : dto.getOptions()) {
                        entityOptions.add(new AnswerOption(
                                null, qId, optDto.getOptionText(), optDto.isCorrect(), optDto.getOrderIndex()
                        ));
                    }
                    questionDao.replaceOptions(con, qId, entityOptions);
                }
                con.commit();
                return qId;
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lưu câu hỏi: " + e.getMessage(), e);
        }
    }

    public void deleteQuestion(long questionId) {
        try (Connection con = DbConnection.getConnection()) {
            boolean deleted = questionDao.delete(con, questionId);
            if (!deleted) {
                throw new IllegalArgumentException("Không tìm thấy câu hỏi cần xóa.");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi xóa câu hỏi: " + e.getMessage(), e);
        }
    }

    public void assignQuestion(long quizId, long questionId, BigDecimal points, int order) {
        ensureSameModule(quizId, questionId);
        try (Connection con = DbConnection.getConnection()) {
            Quiz quiz = quizDao.findById(con, quizId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài thi."));

            List<QuizQuestion> currentList = quizDao.findAssignments(con, quizId);
            int effectiveOrder = order;
            boolean alreadyAssigned = false;
            for (QuizQuestion qq : currentList) {
                if (qq.getQuestionId().equals(questionId)) {
                    alreadyAssigned = true;
                    if (effectiveOrder <= 0) {
                        effectiveOrder = qq.getOrderIndex();
                    }
                    break;
                }
            }

            if (!alreadyAssigned) {
                if (effectiveOrder <= 0) {
                    effectiveOrder = quizDao.getNextOrderIndex(con, quizId);
                } else {
                    final int checkOrder = effectiveOrder;
                    boolean orderExists = currentList.stream().anyMatch(q -> q.getOrderIndex() == checkOrder);
                    if (orderExists) {
                        effectiveOrder = quizDao.getNextOrderIndex(con, quizId);
                    }
                }
            }

            QuizQuestion qq = new QuizQuestion(null, quizId, questionId, quiz.getModuleId(), effectiveOrder, points);
            quizDao.saveAssignment(con, qq);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi gán câu hỏi vào bài thi: " + e.getMessage(), e);
        }
    }

    public void removeQuestion(long quizId, long questionId) {
        try (Connection con = DbConnection.getConnection()) {
            quizDao.deleteAssignment(con, quizId, questionId);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi loại bỏ câu hỏi khỏi bài thi: " + e.getMessage(), e);
        }
    }

    public void reorderQuestions(long quizId, List<Long> orderedIds) {
        try (Connection con = DbConnection.getConnection()) {
            List<QuizQuestion> items = new ArrayList<>();
            for (int i = 0; i < orderedIds.size(); i++) {
                QuizQuestion qq = new QuizQuestion();
                qq.setQuizId(quizId);
                qq.setQuestionId(orderedIds.get(i));
                qq.setOrderIndex(i + 1);
                items.add(qq);
            }
            quizDao.reorderAssignments(con, quizId, items);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi sắp xếp câu hỏi trong bài thi: " + e.getMessage(), e);
        }
    }

    public QuizAttemptDto startAttempt(long registrationId, long quizId) {
        try (Connection con = DbConnection.getConnection()) {
            Registration reg = registrationDao.findById(con, registrationId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đơn đăng ký."));
            if (reg.getStatus() != RegistrationStatus.ACTIVE && reg.getStatus() != RegistrationStatus.COMPLETED) {
                throw new IllegalStateException("Đơn đăng ký không hoạt động.");
            }

            QuizAttempt attempt = new QuizAttempt();
            attempt.setRegistrationId(registrationId);
            attempt.setQuizId(quizId);
            attempt.setSubmittedAt(null);
            attempt.setTotalScore(BigDecimal.ZERO);
            attempt.setPassStatus(false);
            long id = quizAttemptDao.upsertAttempt(con, attempt);
            attempt.setId(id);

            QuizAttemptDto dto = new QuizAttemptDto();
            dto.setId(id);
            dto.setRegistrationId(registrationId);
            dto.setQuizId(quizId);
            dto.setSubmittedAt(null);
            dto.setTotalScore(BigDecimal.ZERO);
            dto.setPassStatus(false);
            return dto;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi bắt đầu bài làm thi: " + e.getMessage(), e);
        }
    }

    public QuizResultDto submitAttempt(QuizAttemptDto dto) {
        if (dto == null || dto.getQuizId() == null) {
            throw new IllegalArgumentException("Dữ liệu nộp bài không hợp lệ.");
        }
        try (Connection con = DbConnection.getConnection()) {
            Quiz quiz = quizDao.findById(con, dto.getQuizId())
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài thi."));
            List<QuizQuestion> assignments = quizDao.findAssignments(con, quiz.getId());

            List<QuizAnswer> gradedAnswers = new ArrayList<>();
            BigDecimal totalScore = BigDecimal.ZERO;
            BigDecimal maxScore = BigDecimal.ZERO;

            for (QuizQuestion qq : assignments) {
                maxScore = maxScore.add(qq.getPoints());
                Question question = questionDao.findById(con, qq.getQuestionId()).orElse(null);
                if (question != null) {
                    QuizAnswerDto submittedAns = null;
                    if (dto.getAnswers() != null) {
                        for (QuizAnswerDto a : dto.getAnswers()) {
                            if (a.getQuestionId().equals(qq.getQuestionId())) {
                                submittedAns = a;
                                break;
                            }
                        }
                    }
                    QuizAnswer graded = gradeAnswer(question, submittedAns, qq.getPoints());
                    gradedAnswers.add(graded);
                    totalScore = totalScore.add(graded.getScore());
                }
            }

            BigDecimal percentage = BigDecimal.ZERO;
            if (maxScore.compareTo(BigDecimal.ZERO) > 0) {
                percentage = totalScore.multiply(BigDecimal.valueOf(100.0)).divide(maxScore, 2, RoundingMode.HALF_UP);
            }
            BigDecimal passScore = quiz.getPassScore() != null ? quiz.getPassScore() : BigDecimal.valueOf(50.0);
            boolean pass = totalScore.compareTo(passScore) >= 0 || percentage.compareTo(passScore) >= 0;

            QuizAttempt attempt = new QuizAttempt();
            attempt.setId(dto.getId());
            attempt.setRegistrationId(dto.getRegistrationId());
            attempt.setQuizId(dto.getQuizId());
            attempt.setSubmittedAt(OffsetDateTime.now());
            attempt.setTotalScore(totalScore);
            attempt.setPassStatus(pass);

            saveAttemptTransaction(attempt, gradedAnswers);

            return calculateResult(attempt, gradedAnswers, quiz.getTitle(), maxScore);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi nộp bài thi: " + e.getMessage(), e);
        }
    }

    public QuizResultDto getResult(long registrationId, long quizId) {
        try (Connection con = DbConnection.getConnection()) {
            Quiz quiz = quizDao.findById(con, quizId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài thi."));
            Optional<QuizAttempt> attemptOpt = quizAttemptDao.findByRegistrationAndQuiz(con, registrationId, quizId);
            if (!attemptOpt.isPresent()) {
                throw new IllegalArgumentException("Chưa có lượt làm bài nào cho bài thi này.");
            }
            QuizAttempt attempt = attemptOpt.get();
            List<QuizAnswer> answers = quizAttemptDao.findAnswers(con, attempt.getId());

            List<QuizQuestion> assignments = quizDao.findAssignments(con, quizId);
            BigDecimal maxScore = assignments.stream()
                    .map(QuizQuestion::getPoints)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            return calculateResult(attempt, answers, quiz.getTitle(), maxScore);
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy kết quả bài thi: " + e.getMessage(), e);
        }
    }

    private void validateQuestion(QuestionDto dto) {
        if (dto == null) {
            throw new IllegalArgumentException("Dữ liệu câu hỏi trống.");
        }
        ValidationUtil.requireText(dto.getQuestionText(), "Nội dung câu hỏi");
        if (dto.getQuestionType() == null) {
            throw new IllegalArgumentException("Loại câu hỏi không được để trống.");
        }
    }

    private void ensureSameModule(long quizId, long questionId) {
        try (Connection con = DbConnection.getConnection()) {
            Quiz quiz = quizDao.findById(con, quizId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài thi."));
            Question question = questionDao.findById(con, questionId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy câu hỏi."));
            if (!quiz.getModuleId().equals(question.getModuleId())) {
                throw new IllegalArgumentException("Câu hỏi và bài thi phải thuộc cùng một chương học.");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi kiểm tra tính tương thích chương học: " + e.getMessage(), e);
        }
    }

    private QuizAnswer gradeAnswer(Question question, QuizAnswerDto submitted, BigDecimal assignedPoints) {
        QuizAnswer answer = new QuizAnswer();
        answer.setQuestionId(question.getId());
        answer.setScore(BigDecimal.ZERO);
        answer.setCorrect(false);

        if (submitted != null && submitted.getSelectedOptionId() != null) {
            answer.setSelectedOptionId(submitted.getSelectedOptionId());
            try (Connection con = DbConnection.getConnection()) {
                List<AnswerOption> options = questionDao.findOptions(con, question.getId());
                for (AnswerOption opt : options) {
                    if (opt.getId().equals(submitted.getSelectedOptionId()) && opt.isCorrect()) {
                        answer.setCorrect(true);
                        answer.setScore(assignedPoints != null ? assignedPoints : question.getDefaultPoints());
                        break;
                    }
                }
            } catch (SQLException ignored) {
            }
        }
        return answer;
    }

    private QuizResultDto calculateResult(QuizAttempt attempt, List<QuizAnswer> answers, String quizTitle, BigDecimal maxScore) {
        QuizResultDto result = new QuizResultDto();
        result.setQuizTitle(quizTitle);
        result.setTotalScore(attempt.getTotalScore());
        result.setMaxScore(maxScore);
        BigDecimal percentage = BigDecimal.ZERO;
        if (maxScore != null && maxScore.compareTo(BigDecimal.ZERO) > 0) {
            percentage = attempt.getTotalScore().multiply(BigDecimal.valueOf(100.0)).divide(maxScore, 2, RoundingMode.HALF_UP);
        }
        result.setPercentage(percentage);
        result.setPassStatus(attempt.isPassStatus());

        List<QuizAnswerDto> answerDtos = new ArrayList<>();
        for (QuizAnswer a : answers) {
            answerDtos.add(new QuizAnswerDto(a.getQuestionId(), a.getSelectedOptionId(), a.isCorrect(), a.getScore()));
        }
        result.setAnswers(answerDtos);
        return result;
    }

    private void saveAttemptTransaction(QuizAttempt attempt, List<QuizAnswer> answers) {
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                long attemptId = quizAttemptDao.upsertAttempt(con, attempt);
                for (QuizAnswer a : answers) {
                    a.setQuizAttemptId(attemptId);
                }
                quizAttemptDao.replaceAnswers(con, attemptId, answers);
                con.commit();
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lưu giao dịch kết quả thi: " + e.getMessage(), e);
        }
    }
}
