-- Migration 08: Thêm cột is_active cho bảng quizzes để hỗ trợ ẩn/hiện bài kiểm tra đối với học viên
ALTER TABLE quizzes ADD COLUMN IF NOT EXISTS is_active boolean NOT NULL DEFAULT true;

