-- =============================================================================
-- Migration: 04_add_lesson_progress_tracking.sql
-- Mô tả: Thêm các cột tracking created_at và updated_at cho bảng lesson_progress
-- =============================================================================

BEGIN;

ALTER TABLE lesson_progress ADD COLUMN IF NOT EXISTS created_at timestamptz NOT NULL DEFAULT now();
ALTER TABLE lesson_progress ADD COLUMN IF NOT EXISTS updated_at timestamptz NOT NULL DEFAULT now();

COMMIT;
