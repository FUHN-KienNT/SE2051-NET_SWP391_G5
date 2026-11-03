-- =============================================================================
-- Rollback Migration: 04_rollback_lesson_progress_tracking.sql
-- Mô tả: Xóa các cột tracking created_at và updated_at khỏi bảng lesson_progress
-- =============================================================================

BEGIN;

ALTER TABLE lesson_progress DROP COLUMN IF EXISTS updated_at;
ALTER TABLE lesson_progress DROP COLUMN IF EXISTS created_at;

COMMIT;
