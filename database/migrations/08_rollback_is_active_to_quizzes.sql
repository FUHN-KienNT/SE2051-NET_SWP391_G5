-- Rollback Migration 08: Xóa cột is_active khỏi bảng quizzes
ALTER TABLE quizzes DROP COLUMN IF EXISTS is_active;

