-- Rollback Migration 09: Khôi phục ràng buộc 1 đáp án duy nhất cho mỗi câu hỏi
ALTER TABLE quiz_answers DROP CONSTRAINT IF EXISTS uq_quiz_answers_attempt_question_option;
ALTER TABLE quiz_answers ADD CONSTRAINT uq_quiz_answers_attempt_question 
    UNIQUE (quiz_attempt_id, question_id);

