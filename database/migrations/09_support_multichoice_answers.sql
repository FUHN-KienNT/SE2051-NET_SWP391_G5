-- Migration 09: Nới lỏng ràng buộc quiz_answers để hỗ trợ câu hỏi Multiple Choice (nhiều đáp án)
-- Cho phép một học sinh chọn nhiều phương án trong cùng một câu hỏi thuộc cùng một lần thi

ALTER TABLE quiz_answers DROP CONSTRAINT IF EXISTS uq_quiz_answers_attempt_question;
ALTER TABLE quiz_answers DROP CONSTRAINT IF EXISTS uq_quiz_answers_attempt_question_option;

-- Ràng buộc mới: một phương án không được chọn trùng lặp 2 lần trong cùng một câu hỏi của 1 lượt thi
ALTER TABLE quiz_answers ADD CONSTRAINT uq_quiz_answers_attempt_question_option 
    UNIQUE (quiz_attempt_id, question_id, selected_option_id);

