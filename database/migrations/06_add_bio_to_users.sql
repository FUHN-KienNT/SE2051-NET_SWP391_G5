-- =============================================================================
-- Migration: 06_add_bio_to_users.sql
-- Mô tả: Thêm cột bio (tiểu sử/mô tả bản thân, tối đa 250 từ) cho bảng users
-- =============================================================================

BEGIN;

ALTER TABLE users ADD COLUMN IF NOT EXISTS bio text;

COMMIT;
