-- =============================================================================
-- Migration: 05_add_is_featured_to_courses.sql
-- Mô tả: Thêm cờ is_featured (gắn cờ khóa học nổi bật hiển thị trên Trang chủ)
-- =============================================================================

BEGIN;

ALTER TABLE courses ADD COLUMN IF NOT EXISTS is_featured boolean NOT NULL DEFAULT false;
CREATE INDEX IF NOT EXISTS idx_courses_is_featured ON courses (is_featured);

-- Đánh dấu mặc định một số khóa học đã PUBLISHED làm khóa học nổi bật ban đầu
UPDATE courses SET is_featured = true WHERE id IN (1, 2, 3) AND status = 'PUBLISHED';

COMMIT;
