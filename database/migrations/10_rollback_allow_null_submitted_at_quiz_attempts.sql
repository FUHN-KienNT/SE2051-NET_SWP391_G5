-- Rollback Migration 10: Khôi phục NOT NULL cho submitted_at
ALTER TABLE quiz_attempts ALTER COLUMN submitted_at SET NOT NULL;

