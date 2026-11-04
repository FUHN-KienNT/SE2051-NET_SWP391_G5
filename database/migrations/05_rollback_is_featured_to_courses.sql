-- =============================================================================
-- Rollback Migration: 05_rollback_is_featured_to_courses.sql
-- Mô tả: Gỡ bỏ cờ is_featured và chỉ mục tương ứng khỏi bảng courses
-- =============================================================================

BEGIN;

DROP INDEX IF EXISTS idx_courses_is_featured;
ALTER TABLE courses DROP COLUMN IF EXISTS is_featured;

COMMIT;
