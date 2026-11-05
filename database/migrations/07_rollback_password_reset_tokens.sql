-- Rollback Migration 07: Xoá bảng password_reset_tokens
DROP TABLE IF EXISTS password_reset_tokens CASCADE;
