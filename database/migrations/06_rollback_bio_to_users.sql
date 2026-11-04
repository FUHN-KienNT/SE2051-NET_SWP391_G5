-- =============================================================================
-- Rollback Migration: 06_rollback_bio_to_users.sql
-- Mô tả: Xóa cột bio khỏi bảng users
-- =============================================================================

BEGIN;

ALTER TABLE users DROP COLUMN IF EXISTS bio;

COMMIT;
