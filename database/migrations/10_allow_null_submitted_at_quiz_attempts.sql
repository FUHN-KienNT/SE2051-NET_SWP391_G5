-- Migration 10: Cho phép submitted_at nhận giá trị NULL khi học viên đang làm bài thi
ALTER TABLE quiz_attempts ALTER COLUMN submitted_at DROP NOT NULL;

