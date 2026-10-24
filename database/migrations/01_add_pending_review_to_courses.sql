-- =============================================================================
-- Migration: 01_add_pending_review_to_courses.sql
-- Mô tả: Cập nhật ràng buộc toàn vẹn chk_courses_status để hỗ trợ trạng thái PENDING_REVIEW
-- Ngày tạo: 2026-10-24
-- =============================================================================

BEGIN;

-- 1. Xóa ràng buộc kiểm tra cũ
ALTER TABLE courses DROP CONSTRAINT IF EXISTS chk_courses_status;

-- 2. Thêm ràng buộc kiểm tra mới hỗ trợ đầy đủ 4 trạng thái:
-- DRAFT, PENDING_REVIEW, PUBLISHED, ARCHIVED
ALTER TABLE courses ADD CONSTRAINT chk_courses_status 
    CHECK (status IN ('DRAFT', 'PENDING_REVIEW', 'PUBLISHED', 'ARCHIVED'));

COMMIT;
