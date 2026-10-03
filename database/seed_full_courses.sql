BEGIN;

-- 1. Tạo các danh mục khóa học nếu chưa có
INSERT INTO settings (type, name, value, priority, status, description) VALUES
    ('COURSE_CATEGORY', 'Nhân tướng học & Nhân trắc học', 'PHYSIOGNOMY', 4, 'ACTIVE', 'Kiến thức nhân tướng học, diện mạo và nhân trắc học ứng dụng'),
    ('COURSE_CATEGORY', 'Tử Vi & Phong Thủy', 'TU_VI', 5, 'ACTIVE', 'Nghiên cứu lá số Tử Vi, âm dương ngũ hành và giải đoán vận hạn'),
    ('COURSE_CATEGORY', 'Chiêm Tinh & Cung Hoàng Đạo', 'ASTROLOGY', 6, 'ACTIVE', 'Khám phá bí mật 12 cung hoàng đạo và chiêm tinh học ứng dụng')
ON CONFLICT (type, name) DO NOTHING;

-- Xóa sạch registrations, quiz_answers, quiz_attempts, lesson_progress liên quan
DELETE FROM quiz_answers;
DELETE FROM quiz_attempts;
DELETE FROM lesson_progress;
DELETE FROM registrations;
DELETE FROM courses WHERE id IN (1, 2, 3) OR title IN (
    'Nhân Tướng Học Ứng Dụng - Thầy Viên Minh',
    '[TVK6] Nhập Môn Tử Vi Đẩu Số & Học Thuyết Ngũ Hành',
    'Bí Mật Tính Cách 12 Cung Hoàng Đạo'
);

-- =====================================================================
-- KHÓA HỌC 1: Nhân Tướng Học Ứng Dụng - Thầy Viên Minh (17 bài giảng)
-- =====================================================================
INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at)
VALUES (
    1,
    'Nhân Tướng Học Ứng Dụng - Thầy Viên Minh',
    (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = 'PHYSIOGNOMY' LIMIT 1),
    'COURSE_CATEGORY',
    'Khóa học chuyên sâu về Nhân Tướng Học do Thầy Viên Minh giảng dạy. Hướng dẫn toàn diện phương pháp quan sát diện mạo, ngũ quan, thần thái, cốt cách, tam đình lục phủ để thấu hiểu bản thân và đối nhân xử thế hiệu quả trong công việc và cuộc sống.',
    0,
    'PUBLISHED',
    2,
    3,
    now(),
    now()
);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (1, 1, 'Căn Bản Nhân Tướng & Tam Đình Ngũ Nhạc', 1, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (1, 1, 'Buổi 10.2   Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 10.2   Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/WVPVpNDKUwM', NULL, 1, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (2, 1, 'Buổi 10.1   Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 10.1   Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/gJS-1C78Jy0', NULL, 2, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (3, 1, 'Buổi 9.3   Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 9.3   Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/SMaG-tqSzFM', NULL, 3, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (4, 1, 'Buổi 9.2   Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 9.2   Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/o0JaN_PR02k', NULL, 4, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (5, 1, 'Buổi 9.1   Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 9.1   Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/J_brIB4a2Ac', NULL, 5, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (6, 1, 'Buổi 8.2  Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 8.2  Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/ELfzK_P9itU', NULL, 6, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (7, 1, 'Buổi 8.1   Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 8.1   Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/PH6wuaVaPas', NULL, 7, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (8, 1, 'Buổi 7.2 Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 7.2 Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/OlpMbs2O7a4', NULL, 8, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (1, 1, 'Kiểm tra trắc nghiệm: Căn Bản Nhân Tướng & Tam Đình Ngũ Nhạc', 80, 15, 9, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (1, 1, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Căn Bản Nhân Tướng & Tam Đình Ngũ Nhạc'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(1, 1, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(2, 1, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(3, 1, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (1, 1, 1, 1, 1, 5);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (2, 1, 'Giải Mã Ngũ Quan & Diện Mạo', 2, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (9, 2, 'Buổi 7.1   Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 7.1   Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/HTWpazK7cfg', NULL, 1, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (10, 2, 'Buổi 6   Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 6   Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/d7PrIAR795I', NULL, 2, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (11, 2, 'Buổi 5 Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 5 Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/UEPVm5rgD9k', NULL, 3, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (12, 2, 'Buổi 4.2   Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 4.2   Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/ivk5mxi8se8', NULL, 4, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (13, 2, 'Buổi 4.1 Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 4.1 Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/2unyEyuhXAY', NULL, 5, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (14, 2, 'Buổi 4.3   Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 4.3   Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/-brBeGzy1n4', NULL, 6, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (15, 2, 'Buổi 3 Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 3 Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/9zTEtiStPPo', NULL, 7, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (16, 2, 'Buổi 2  Nhân tướng học thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 2  Nhân tướng học thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/SzutjAxwzmY', NULL, 8, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (2, 2, 'Kiểm tra trắc nghiệm: Giải Mã Ngũ Quan & Diện Mạo', 80, 15, 9, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (2, 2, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Giải Mã Ngũ Quan & Diện Mạo'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(4, 2, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(5, 2, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(6, 2, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (2, 2, 2, 2, 1, 5);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (3, 1, 'Khí Sắc, Tâm Tướng & Ứng Dụng Đời Sống', 3, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (17, 3, 'Buổi 1  Nhân tướng học  thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 1  Nhân tướng học  thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/eSJJffB1tbQ', NULL, 1, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (3, 3, 'Kiểm tra trắc nghiệm: Khí Sắc, Tâm Tướng & Ứng Dụng Đời Sống', 80, 15, 2, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (3, 3, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Khí Sắc, Tâm Tướng & Ứng Dụng Đời Sống'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(7, 3, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(8, 3, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(9, 3, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (3, 3, 3, 3, 1, 5);
-- =====================================================================
-- KHÓA HỌC 2: [TVK6] Nhập Môn Tử Vi Đẩu Số & Học Thuyết Ngũ Hành (38 bài giảng)
-- =====================================================================
INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at)
VALUES (
    2,
    '[TVK6] Nhập Môn Tử Vi Đẩu Số & Học Thuyết Ngũ Hành',
    (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = 'TU_VI' LIMIT 1),
    'COURSE_CATEGORY',
    'Khóa học [TVK6] cung cấp kiến thức nền tảng vững chắc về lá số Tử Vi, cơ cấu 12 cung bản mệnh, quy luật can chi, âm dương ngũ hành và phương pháp giải đoán lá số logic, khoa học.',
    0,
    'PUBLISHED',
    2,
    3,
    now(),
    now()
);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (4, 2, 'Nhập Môn Lá Số Tử Vi & Học Thuyết Ngũ Hành', 1, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (18, 4, '[TVK6] Buổi 1: Các thành phần chính của lá số Tử Vi - Học thuyết Ngũ Hành', '<p>Bài giảng: <strong>[TVK6] Buổi 1: Các thành phần chính của lá số Tử Vi - Học thuyết Ngũ Hành</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/p3HlEXDp0vU', NULL, 1, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (19, 4, '[TVK6] Buổi 2: Khai thác dữ kiện [Nhật Can] trong phần Mệnh Bàn', '<p>Bài giảng: <strong>[TVK6] Buổi 2: Khai thác dữ kiện [Nhật Can] trong phần Mệnh Bàn</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/8YvC-MAzpSE', NULL, 2, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (20, 4, '[TVK6] Buổi 4: Mệnh chủ, thân chủ, thân cư. Phân tích mệnh bàn ở vài lá số (tài liệu trong mô tả).', '<p>Bài giảng: <strong>[TVK6] Buổi 4: Mệnh chủ, thân chủ, thân cư. Phân tích mệnh bàn ở vài lá số (tài liệu trong mô tả).</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/ELKpsxNXwWw', NULL, 3, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (21, 4, '[TVK6] Buổi 5: Ý nghĩa và chức năng cung mệnh, cung thân. Mệnh vô chính diệu, thân vô chính diệu.', '<p>Bài giảng: <strong>[TVK6] Buổi 5: Ý nghĩa và chức năng cung mệnh, cung thân. Mệnh vô chính diệu, thân vô chính diệu.</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/sUGXawNG-OM', NULL, 4, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (22, 4, '[TVK6] Buổi 3: Ý nghĩa ngũ hành Mệnh và ngũ hành Cục, tương quan Mệnh và Cục (tài liệu ở mô tả).', '<p>Bài giảng: <strong>[TVK6] Buổi 3: Ý nghĩa ngũ hành Mệnh và ngũ hành Cục, tương quan Mệnh và Cục (tài liệu ở mô tả).</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/rw2635o7m00', NULL, 5, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (23, 4, '[TVK6] Buổi 6: Ý nghĩa 12 cung. Tính chất cung tật, điền, nô, phúc VCD (đọc thêm ở mô tả).', '<p>Bài giảng: <strong>[TVK6] Buổi 6: Ý nghĩa 12 cung. Tính chất cung tật, điền, nô, phúc VCD (đọc thêm ở mô tả).</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/tkj0n4-J-Vg', NULL, 6, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (24, 4, '[TVK6] Buổi 7: Ý nghĩa cung tài bạch, quan lộc, thiên di, phu thê, phụ mẫu, tử tức, huynh đệ (VCD)', '<p>Bài giảng: <strong>[TVK6] Buổi 7: Ý nghĩa cung tài bạch, quan lộc, thiên di, phu thê, phụ mẫu, tử tức, huynh đệ (VCD)</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/X1pDetjJYWU', NULL, 7, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (25, 4, '[TVK6] Buổi 8: Ý nghĩa Địa Chi của 12 cung', '<p>Bài giảng: <strong>[TVK6] Buổi 8: Ý nghĩa Địa Chi của 12 cung</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/hw6upgLjLL0', NULL, 8, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (26, 4, '[TVK6] Buổi 10: Bốn cung Thìn, Tuất, Sửu, Mùi và tính chất Thiên La - Địa Võng', '<p>Bài giảng: <strong>[TVK6] Buổi 10: Bốn cung Thìn, Tuất, Sửu, Mùi và tính chất Thiên La - Địa Võng</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Ps5hEegQ4ew', NULL, 9, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (27, 4, '[TVK6] Buổi 9: Địa chi - mật mã nằm trong vị trí cung (P1)', '<p>Bài giảng: <strong>[TVK6] Buổi 9: Địa chi - mật mã nằm trong vị trí cung (P1)</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/xoWqHDgoeTs', NULL, 10, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (4, 4, 'Kiểm tra trắc nghiệm: Nhập Môn Lá Số Tử Vi & Học Thuyết Ngũ Hành', 80, 15, 11, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (4, 4, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Nhập Môn Lá Số Tử Vi & Học Thuyết Ngũ Hành'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(10, 4, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(11, 4, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(12, 4, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (4, 4, 4, 4, 1, 5);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (5, 2, 'Hệ Thống 12 Cung & Can Chi Bản Mệnh', 2, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (28, 5, '[TVK6] Buổi 11: Các yếu tố cơ bản cần nắm về Chính Tinh.', '<p>Bài giảng: <strong>[TVK6] Buổi 11: Các yếu tố cơ bản cần nắm về Chính Tinh.</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Jop8vDcTx0k', NULL, 1, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (29, 5, '[TVK6] Buổi 12: Tính chất 4 nhóm Chính Tinh bộ Dương', '<p>Bài giảng: <strong>[TVK6] Buổi 12: Tính chất 4 nhóm Chính Tinh bộ Dương</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/29QIWM8y28M', NULL, 2, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (30, 5, '[TVK6] Buổi 13: Phân tích một vài lá số của Chính Tinh bộ Dương, tính chất bốn nhóm Chính Tinh bộ Âm', '<p>Bài giảng: <strong>[TVK6] Buổi 13: Phân tích một vài lá số của Chính Tinh bộ Dương, tính chất bốn nhóm Chính Tinh bộ Âm</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/f9Yk5cIhM5U', NULL, 3, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (31, 5, '[TVK6] Buổi 14: Sao Tử Vi', '<p>Bài giảng: <strong>[TVK6] Buổi 14: Sao Tử Vi</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/lzxaWz2k6co', NULL, 4, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (32, 5, '[TVK6] Buổi 15: Sao Thiên Phủ (full) và sao Thiên Tướng (1)', '<p>Bài giảng: <strong>[TVK6] Buổi 15: Sao Thiên Phủ (full) và sao Thiên Tướng (1)</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/En_HDux9r7U', NULL, 5, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (33, 5, '[TVK6] Buổi 16: Sao Thiên Tướng và sao Liêm Trinh', '<p>Bài giảng: <strong>[TVK6] Buổi 16: Sao Thiên Tướng và sao Liêm Trinh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/JPRLIvV9-4I', NULL, 6, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (34, 5, 'Buổi 17 (P1): Các yếu tố cần lưu ý về Liêm Trinh. Tính cách của sao Liêm Trinh.', '<p>Bài giảng: <strong>Buổi 17 (P1): Các yếu tố cần lưu ý về Liêm Trinh. Tính cách của sao Liêm Trinh.</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/5UkpT7oQpBA', NULL, 7, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (35, 5, 'Buổi 17 (P2): Năng lực, vấn đề của sao Liêm Trinh. Sự kết hợp của Liêm Trinh với các chính phụ tinh', '<p>Bài giảng: <strong>Buổi 17 (P2): Năng lực, vấn đề của sao Liêm Trinh. Sự kết hợp của Liêm Trinh với các chính phụ tinh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/ULDS9_i-Gu4', NULL, 8, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (36, 5, '[TVK6] Buổi 18: Sao Vũ Khúc', '<p>Bài giảng: <strong>[TVK6] Buổi 18: Sao Vũ Khúc</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/uMg9dSQwdc0', NULL, 9, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (37, 5, '[TVK6] Buổi 20: Sao Thất Sát', '<p>Bài giảng: <strong>[TVK6] Buổi 20: Sao Thất Sát</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/3wRSQRonZE8', NULL, 10, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (5, 5, 'Kiểm tra trắc nghiệm: Hệ Thống 12 Cung & Can Chi Bản Mệnh', 80, 15, 11, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (5, 5, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Hệ Thống 12 Cung & Can Chi Bản Mệnh'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(13, 5, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(14, 5, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(15, 5, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (5, 5, 5, 5, 1, 5);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (6, 2, 'Luận Giải Chính Tinh & Phụ Tinh', 3, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (38, 6, '[TVK6] Buổi 19: Sao Tham Lang', '<p>Bài giảng: <strong>[TVK6] Buổi 19: Sao Tham Lang</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/_JMXa1F3PXA', NULL, 1, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (39, 6, '[TVK6] Buổi 21: Sao Phá Quân', '<p>Bài giảng: <strong>[TVK6] Buổi 21: Sao Phá Quân</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/yjyXsDIpgn0', NULL, 2, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (40, 6, '[TVK6] Buổi 22: Sao Thiên Cơ', '<p>Bài giảng: <strong>[TVK6] Buổi 22: Sao Thiên Cơ</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/SXogSLi16us', NULL, 3, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (41, 6, '[TVK6] Buổi 23: Sao Thiên Đồng', '<p>Bài giảng: <strong>[TVK6] Buổi 23: Sao Thiên Đồng</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/sY1aNgu_FFE', NULL, 4, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (42, 6, '[TVK6] Buổi 24: Sao Thái Âm', '<p>Bài giảng: <strong>[TVK6] Buổi 24: Sao Thái Âm</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/LcuKXbWjTTQ', NULL, 5, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (43, 6, '[TVK6] Buổi 25: Sao Thiên Lương', '<p>Bài giảng: <strong>[TVK6] Buổi 25: Sao Thiên Lương</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/4PqoGYDjJf0', NULL, 6, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (44, 6, '[TVK6] Buổi 26: Sao Cự Môn', '<p>Bài giảng: <strong>[TVK6] Buổi 26: Sao Cự Môn</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/NroEGFaqHXI', NULL, 7, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (45, 6, '[TVK6] Buổi 27: Sao Thái Dương (đọc thêm trong mô tả)', '<p>Bài giảng: <strong>[TVK6] Buổi 27: Sao Thái Dương (đọc thêm trong mô tả)</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/fB1qHuFNVO8', NULL, 8, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (46, 6, '[TVK6] Buổi 28: Sơ lược hệ thống chính phụ tinh, phương pháp luận Thiên - Địa - Nhân', '<p>Bài giảng: <strong>[TVK6] Buổi 28: Sơ lược hệ thống chính phụ tinh, phương pháp luận Thiên - Địa - Nhân</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/IYB3ZkpK750', NULL, 9, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (47, 6, '[TVK6] Buổi 29: Luận đoán về Địa Lợi và Nhân Hòa. Khái niệm Tứ Hóa trong Tử Vi.', '<p>Bài giảng: <strong>[TVK6] Buổi 29: Luận đoán về Địa Lợi và Nhân Hòa. Khái niệm Tứ Hóa trong Tử Vi.</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/b5ZA1-D-etI', NULL, 10, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (6, 6, 'Kiểm tra trắc nghiệm: Luận Giải Chính Tinh & Phụ Tinh', 80, 15, 11, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (6, 6, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Luận Giải Chính Tinh & Phụ Tinh'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(16, 6, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(17, 6, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(18, 6, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (6, 6, 6, 6, 1, 5);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (7, 2, 'Kỹ Thuật Luận Đoán & Workshop Chuyên Sâu', 4, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (48, 7, '[Workshop - TVK6] Phân tích lá số Alexander Hamilton và Lý Tiểu Long (Phủ Tướng Triều Viên)', '<p>Bài giảng: <strong>[Workshop - TVK6] Phân tích lá số Alexander Hamilton và Lý Tiểu Long (Phủ Tướng Triều Viên)</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/uhM9ZFkJTRI', NULL, 1, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (49, 7, '[TVK6] Buổi 30: Tứ Hóa (tiếp theo) và vòng Lộc Tồn', '<p>Bài giảng: <strong>[TVK6] Buổi 30: Tứ Hóa (tiếp theo) và vòng Lộc Tồn</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/DgMKxNpe7tQ', NULL, 2, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (50, 7, '[TVK6] Buổi 31: Tính chất của Sát Tinh. Sát Tinh dẫn dắt con người đến bài học gì trong cuộc đời?', '<p>Bài giảng: <strong>[TVK6] Buổi 31: Tính chất của Sát Tinh. Sát Tinh dẫn dắt con người đến bài học gì trong cuộc đời?</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Mg_CgBafpR0', NULL, 3, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (51, 7, '[TVK6] Buổi 32: Tính chất và giải pháp cho bộ Linh Xương Đà Vũ. Ý nghĩa của Lục Cát Tinh.', '<p>Bài giảng: <strong>[TVK6] Buổi 32: Tính chất và giải pháp cho bộ Linh Xương Đà Vũ. Ý nghĩa của Lục Cát Tinh.</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/-UXjtpC4qM4', NULL, 4, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (52, 7, '[TVK6 - Workshop] Ý nghĩa và sức mạnh của Bại Tinh. Phúc Tinh, Thiện Tinh và các cặp sao nhân quả.', '<p>Bài giảng: <strong>[TVK6 - Workshop] Ý nghĩa và sức mạnh của Bại Tinh. Phúc Tinh, Thiện Tinh và các cặp sao nhân quả.</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/hlLj8Hoqkb4', NULL, 5, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (53, 7, '[TVK6] [Workshop] Tính chất và ý nghĩa của Vòng Trường Sinh', '<p>Bài giảng: <strong>[TVK6] [Workshop] Tính chất và ý nghĩa của Vòng Trường Sinh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/dzrbc0s71W0', NULL, 6, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (54, 7, '[TVK6] [Workshop] Các kỹ thuật luận đoán vận hạn trong Tử Vi', '<p>Bài giảng: <strong>[TVK6] [Workshop] Các kỹ thuật luận đoán vận hạn trong Tử Vi</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/ASXphEG1g0Y', NULL, 7, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (55, 7, '[TVK6] [Workshop] Thập Nhị Huyền Đồ trong Tử Vi (đọc thêm ở mô tả)', '<p>Bài giảng: <strong>[TVK6] [Workshop] Thập Nhị Huyền Đồ trong Tử Vi (đọc thêm ở mô tả)</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/agQ62jP4i7E', NULL, 8, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (7, 7, 'Kiểm tra trắc nghiệm: Kỹ Thuật Luận Đoán & Workshop Chuyên Sâu', 80, 15, 9, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (7, 7, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Kỹ Thuật Luận Đoán & Workshop Chuyên Sâu'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(19, 7, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(20, 7, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(21, 7, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (7, 7, 7, 7, 1, 5);
-- =====================================================================
-- KHÓA HỌC 3: Bí Mật Tính Cách 12 Cung Hoàng Đạo (63 bài giảng)
-- =====================================================================
INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at)
VALUES (
    3,
    'Bí Mật Tính Cách 12 Cung Hoàng Đạo',
    (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = 'ASTROLOGY' LIMIT 1),
    'COURSE_CATEGORY',
    'Khám phá bí mật tính cách thực sự, ưu điểm, nhược điểm, phong cách tư duy, tình cảm và sự tương hợp giữa 12 Cung Hoàng Đạo qua chuỗi bài giảng phân tích sinh động từ Xà Phu Channel.',
    0,
    'PUBLISHED',
    2,
    3,
    now(),
    now()
);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (8, 3, 'Truyền Thuyết & Bản Chất 12 Cung Hoàng Đạo', 1, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (56, 8, 'Vạch Trần Tính Cách Thật Của 12 Cung Hoàng Đạo - Bí mật 12 cung hoàng đạo - Xà Phu Channel', '<p>Bài giảng: <strong>Vạch Trần Tính Cách Thật Của 12 Cung Hoàng Đạo - Bí mật 12 cung hoàng đạo - Xà Phu Channel</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/qJYOYE3uzJc', NULL, 1, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (57, 8, 'Truyền Thuyết Ra Đời 12 Cung Hoàng Đạo - Bắt Nguồn Từ Thần Thoại Hy Lạp', '<p>Bài giảng: <strong>Truyền Thuyết Ra Đời 12 Cung Hoàng Đạo - Bắt Nguồn Từ Thần Thoại Hy Lạp</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Ns_SjNO-Htc', NULL, 2, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (58, 8, '12 Quái Vật Hiện Thân Cho 12 Cung Hoàng Đạo - Có Cả Quái Vật Bí Ẩn Trong Thần Thoại Hy Lạp', '<p>Bài giảng: <strong>12 Quái Vật Hiện Thân Cho 12 Cung Hoàng Đạo - Có Cả Quái Vật Bí Ẩn Trong Thần Thoại Hy Lạp</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/nxjgkRn3L7A', NULL, 3, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (59, 8, 'Ý Nghĩa Biểu Tượng Bí Ẩn Của 12 Cung Hoàng Đạo - Bắt Nguồn Từ Thần Thoại Hy Lạp', '<p>Bài giảng: <strong>Ý Nghĩa Biểu Tượng Bí Ẩn Của 12 Cung Hoàng Đạo - Bắt Nguồn Từ Thần Thoại Hy Lạp</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/xGD2IDacKg4', NULL, 4, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (60, 8, '12 Vị Thần Ai Cập Bảo Hộ 12 Cung Hoàng Đạo - Bất Ngờ Nhất Cung Được "Thần Ch.ế.t" Che Chở', '<p>Bài giảng: <strong>12 Vị Thần Ai Cập Bảo Hộ 12 Cung Hoàng Đạo - Bất Ngờ Nhất Cung Được "Thần Ch.ế.t" Che Chở</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/hlPS4H7cpEs', NULL, 5, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (61, 8, 'Tử Vi Tháng 7/2020 của 12 Cung Hoàng Đạo - Kim Ngưu chớp thời cơ, Sư Tử áp lực căng thẳng', '<p>Bài giảng: <strong>Tử Vi Tháng 7/2020 của 12 Cung Hoàng Đạo - Kim Ngưu chớp thời cơ, Sư Tử áp lực căng thẳng</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/eftl-GLgPrI', NULL, 6, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (62, 8, 'Đã Tìm Thấy THẾ GIỚI của 12 Cung Hoàng Đạo - Xà Phu Channel - Kênh mới của Top 1 Khám Phá', '<p>Bài giảng: <strong>Đã Tìm Thấy THẾ GIỚI của 12 Cung Hoàng Đạo - Xà Phu Channel - Kênh mới của Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Gqe1q_l0Y8E', NULL, 7, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (63, 8, 'Bí Ẩn Cung Xà Phu - Cung Hoàng Đạo Thứ 13 Khiến Hàng Triệu Người Thay Đổi Chòm Sao', '<p>Bài giảng: <strong>Bí Ẩn Cung Xà Phu - Cung Hoàng Đạo Thứ 13 Khiến Hàng Triệu Người Thay Đổi Chòm Sao</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/BTcZueBj-FM', NULL, 8, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (64, 8, 'Vạch Trần Tính Cách 12 Cung Hoàng Đạo', '<p>Bài giảng: <strong>Vạch Trần Tính Cách 12 Cung Hoàng Đạo</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/jZBTaqOhAtE', NULL, 9, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (65, 8, 'Hành Tinh Cai Trị 12 Cung Hoàng Đạo Trong Hệ Mặt Trời - Top 1 Khám Phá', '<p>Bài giảng: <strong>Hành Tinh Cai Trị 12 Cung Hoàng Đạo Trong Hệ Mặt Trời - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/mYA9IY7ZvcU', NULL, 10, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (66, 8, '4 Nhóm Nguyên Tố Của 12 Cung Hoàng Đạo: Lửa - Nước - Đất - Khí [Top 1 Khám Phá]', '<p>Bài giảng: <strong>4 Nhóm Nguyên Tố Của 12 Cung Hoàng Đạo: Lửa - Nước - Đất - Khí [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/hrhbqK2BVOE', NULL, 11, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (67, 8, 'Thiên Thần Hộ Mệnh Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Thiên Thần Hộ Mệnh Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/TEvRW3alnw4', NULL, 12, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (68, 8, 'Loài Hoa Tượng Trưng Cho 12 Cung Hoàng Đạo Đem Lại Thành Công - Top 1 Khám Phá', '<p>Bài giảng: <strong>Loài Hoa Tượng Trưng Cho 12 Cung Hoàng Đạo Đem Lại Thành Công - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/AXY-GZrzXLc', NULL, 13, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (8, 8, 'Kiểm tra trắc nghiệm: Truyền Thuyết & Bản Chất 12 Cung Hoàng Đạo', 80, 15, 14, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (8, 8, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Truyền Thuyết & Bản Chất 12 Cung Hoàng Đạo'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(22, 8, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(23, 8, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(24, 8, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (8, 8, 8, 8, 1, 5);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (9, 3, 'Tình Yêu, Nghề Nghiệp & Bí Mật Tính Cách', 2, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (69, 9, '12 Cặp Đôi Hoàng Đạo Hợp Yêu Nhau Nhất Trong 12 Chòm Sao - Top 1 Khám Phá', '<p>Bài giảng: <strong>12 Cặp Đôi Hoàng Đạo Hợp Yêu Nhau Nhất Trong 12 Chòm Sao - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Ferc-VdkDqo', NULL, 1, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (70, 9, 'Tiết Lộ Chỉ Số IQ Của 12 Cung Hoàng Đạo - Ai Là Người Thông Minh Nhất [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Tiết Lộ Chỉ Số IQ Của 12 Cung Hoàng Đạo - Ai Là Người Thông Minh Nhất [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/g1qCo-PXHLs', NULL, 2, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (71, 9, 'Quái Vật Thần Thoại Hy Lạp Hiện Thân Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Quái Vật Thần Thoại Hy Lạp Hiện Thân Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/zW57RxnvAcc', NULL, 3, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (72, 9, 'Bật Mí Công Việc Nghề Nghiệp Phù Hợp Với 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Bật Mí Công Việc Nghề Nghiệp Phù Hợp Với 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/3VhvidgwsD0', NULL, 4, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (73, 9, 'Mỹ Nhân Trung Quốc Đại Diện Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Mỹ Nhân Trung Quốc Đại Diện Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Dlm6k9mGv-4', NULL, 5, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (74, 9, 'Sự Thật Bị Giấu Kín Về 12 Cung Hoàng Đạo Cực Ít Người Biết - Top 1 Khám Phá', '<p>Bài giảng: <strong>Sự Thật Bị Giấu Kín Về 12 Cung Hoàng Đạo Cực Ít Người Biết - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/8Q6HRIoXxok', NULL, 6, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (75, 9, 'Vạch Trần Con Người Thật Của NAM - NỮ 12 Cung Hoàng Đạo [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Vạch Trần Con Người Thật Của NAM - NỮ 12 Cung Hoàng Đạo [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/ybBBVpEslMw', NULL, 7, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (76, 9, 'Khám Phá Tính Cách Đặc Biệt của "Cung Hoàng Đạo Lai" - Bạn có phải là 1 sao lai? [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Khám Phá Tính Cách Đặc Biệt của "Cung Hoàng Đạo Lai" - Bạn có phải là 1 sao lai? [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Ogd-K8PyDkw', NULL, 8, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (77, 9, '12 Cung Hoàng Đạo Là Ai Trong Thế Giới Phù Thủy Harry Potter? - Top 1 Khám Phá', '<p>Bài giảng: <strong>12 Cung Hoàng Đạo Là Ai Trong Thế Giới Phù Thủy Harry Potter? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/3pfWOL5caxc', NULL, 9, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (78, 9, 'Mỹ Nam Hàn Quốc Nổi Tiếng Đại Diện Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Mỹ Nam Hàn Quốc Nổi Tiếng Đại Diện Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/SuhuvS6sDBQ', NULL, 10, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (79, 9, 'Đồ Vật Hộ Thân Đem Lại May Mắn Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Đồ Vật Hộ Thân Đem Lại May Mắn Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/NZN_mPnVeX0', NULL, 11, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (80, 9, '12 Cung Hoàng Đạo Là Ai Trong Doraemon - Bất Ngờ Nhân Vật Nobita [Top 1 Khám Phá]', '<p>Bài giảng: <strong>12 Cung Hoàng Đạo Là Ai Trong Doraemon - Bất Ngờ Nhân Vật Nobita [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/lVTvPVG_HL4', NULL, 12, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (81, 9, 'Xếp Hạng Nhan Sắc Xinh Trai Đẹp Gái Của 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Xếp Hạng Nhan Sắc Xinh Trai Đẹp Gái Của 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/XUI9G1tZEk4', NULL, 13, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (9, 9, 'Kiểm tra trắc nghiệm: Tình Yêu, Nghề Nghiệp & Bí Mật Tính Cách', 80, 15, 14, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (9, 9, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Tình Yêu, Nghề Nghiệp & Bí Mật Tính Cách'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(25, 9, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(26, 9, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(27, 9, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (9, 9, 9, 9, 1, 5);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (10, 3, 'Xếp Hạng & Khám Phá Thế Giới Hoàng Đạo', 3, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (82, 10, 'Bạn Có Sinh Vào Ngày May Mắn Tài Lộc Nhất Trong Năm Không? - Top 1 Khám Phá', '<p>Bài giảng: <strong>Bạn Có Sinh Vào Ngày May Mắn Tài Lộc Nhất Trong Năm Không? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/24td4plWKis', NULL, 1, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (83, 10, 'Siêu Anh Hùng Nào Đại Diện Cho Cung Hoàng Đạo Của Bạn? - Top 1 Khám Phá', '<p>Bài giảng: <strong>Siêu Anh Hùng Nào Đại Diện Cho Cung Hoàng Đạo Của Bạn? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/RiTZqoezN9M', NULL, 2, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (84, 10, 'Kiếp Trước Của 12 Cung Hoàng Đạo Là Người Thế Nào? Top 1 Khám Phá', '<p>Bài giảng: <strong>Kiếp Trước Của 12 Cung Hoàng Đạo Là Người Thế Nào? Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/ngifys0CSQw', NULL, 3, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (85, 10, '12 Cung Hoàng Đạo Là POKEMON Huyền Thoại Nào? - Top 1 Khám Phá', '<p>Bài giảng: <strong>12 Cung Hoàng Đạo Là POKEMON Huyền Thoại Nào? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/JaJNeMpA70M', NULL, 4, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (86, 10, '12 Cung Hoàng Đạo Khi Hóa Thân Thành 12 Con Giáp - Top 1 Khám Phá', '<p>Bài giảng: <strong>12 Cung Hoàng Đạo Khi Hóa Thân Thành 12 Con Giáp - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/WxU3q_g0O1g', NULL, 5, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (87, 10, 'Bùng Nổ Tinh Yêu Của 12 Cung Hoàng Đạo Năm 2021 - Nhất Là Cung Bạch Dương [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Bùng Nổ Tinh Yêu Của 12 Cung Hoàng Đạo Năm 2021 - Nhất Là Cung Bạch Dương [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/khW6dT398OQ', NULL, 6, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (88, 10, 'Màu Sắc May Mắn 2021 Của 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Màu Sắc May Mắn 2021 Của 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/TJDbORuivS8', NULL, 7, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (89, 10, 'Loài Vật Nào Đại Diện Cho 12 Cung Hoàng Đạo? - Top 1 Khám Phá', '<p>Bài giảng: <strong>Loài Vật Nào Đại Diện Cho 12 Cung Hoàng Đạo? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/4qrpACrGxsQ', NULL, 8, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (90, 10, '12 Cung Hoàng Đạo Là Nhân Vật Nào Trong Thám Tử Lừng Danh Conan? - Top 1 Khám Phá', '<p>Bài giảng: <strong>12 Cung Hoàng Đạo Là Nhân Vật Nào Trong Thám Tử Lừng Danh Conan? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/RjliAma30IM', NULL, 9, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (91, 10, '12 Cung Hoàng Đạo Học Giỏi Nhất Môn Học Nào? - Top 1 Khám Phá', '<p>Bài giảng: <strong>12 Cung Hoàng Đạo Học Giỏi Nhất Môn Học Nào? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/HF9GMooInYA', NULL, 10, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (92, 10, 'Nhân Vật Cổ Tích Nào Hiện Thân Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Nhân Vật Cổ Tích Nào Hiện Thân Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/vPJGtSf42U4', NULL, 11, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (93, 10, '12 Cung Hoàng Đạo Là Nhân Vật Phản Diện Disney Nào? - Top 1 Khám Phá', '<p>Bài giảng: <strong>12 Cung Hoàng Đạo Là Nhân Vật Phản Diện Disney Nào? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/ccJqe0Rk8sA', NULL, 12, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (94, 10, 'Quốc Gia Nào Đại Diện Cho 12 Cung Hoàng Đạo? - Top 1 Khám Phá', '<p>Bài giảng: <strong>Quốc Gia Nào Đại Diện Cho 12 Cung Hoàng Đạo? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/2XJQv91Ioqk', NULL, 13, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (10, 10, 'Kiểm tra trắc nghiệm: Xếp Hạng & Khám Phá Thế Giới Hoàng Đạo', 80, 15, 14, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (10, 10, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Xếp Hạng & Khám Phá Thế Giới Hoàng Đạo'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(28, 10, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(29, 10, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(30, 10, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (10, 10, 10, 10, 1, 5);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (11, 3, 'Giải Mã Chi Tiết Từng Chòm Sao', 4, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (95, 11, 'Những Cặp Đôi Hợp Yêu Nhau Nhất Trong 12 Cung Hoàng Đạo - Top 1 Khám phá', '<p>Bài giảng: <strong>Những Cặp Đôi Hợp Yêu Nhau Nhất Trong 12 Cung Hoàng Đạo - Top 1 Khám phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/gCLIceyH_Fs', NULL, 1, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (96, 11, 'Giải Mã Cung Bạch Dương – Chú Cừu Trẻ Con Mở Đầu Vòng Tròn Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Giải Mã Cung Bạch Dương – Chú Cừu Trẻ Con Mở Đầu Vòng Tròn Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/F1qaldxvjbA', NULL, 2, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (97, 11, '12 Cung Hoàng Đạo Là Thiên Thần Hay Ác Q.u.ỷ? - Top 1 Khám Phá', '<p>Bài giảng: <strong>12 Cung Hoàng Đạo Là Thiên Thần Hay Ác Q.u.ỷ? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/kluQiKtQOzI', NULL, 3, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (98, 11, 'KIM NGƯU - Chú Trâu Zeus Và Ý Nghĩa Biểu Tượng Trong 12 Cung Hoàng Đạo [Top 1 Khám Phá]', '<p>Bài giảng: <strong>KIM NGƯU - Chú Trâu Zeus Và Ý Nghĩa Biểu Tượng Trong 12 Cung Hoàng Đạo [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/t0AqKct0gcc', NULL, 4, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (99, 11, '12 Cung Hoàng Đạo Là Nhân Vật Nào Trong One Piece Và Naruto? - Top 1 Khám Phá', '<p>Bài giảng: <strong>12 Cung Hoàng Đạo Là Nhân Vật Nào Trong One Piece Và Naruto? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/pMUXGQNWFlM', NULL, 5, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (100, 11, 'SONG TỬ - Kẻ Đa Nhân Cách Nhất 12 Chòm Cao [Top 1 Khám Phá]', '<p>Bài giảng: <strong>SONG TỬ - Kẻ Đa Nhân Cách Nhất 12 Chòm Cao [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/qqVjZfwUggE', NULL, 6, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (101, 11, 'Bí Ẩn Lá Bài TAROT Đại Diện Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Bí Ẩn Lá Bài TAROT Đại Diện Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/i9uEzE7ig2s', NULL, 7, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (102, 11, 'Giải Mã Cự Giải - Chú Cua Đa Sầu Bậc Nhất 12 Cung Hoàng Đạo [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Giải Mã Cự Giải - Chú Cua Đa Sầu Bậc Nhất 12 Cung Hoàng Đạo [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/ZvbUi8m2-n4', NULL, 8, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (103, 11, '12 Cung Hoàng Đạo Là Nhân Vật Nào Trong Tây Du Ký? - Top 1 Khám Phá', '<p>Bài giảng: <strong>12 Cung Hoàng Đạo Là Nhân Vật Nào Trong Tây Du Ký? - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/lYmsFdmzFqg', NULL, 9, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (104, 11, 'Giải Mã Sư Tử - Chúa Tể Muôn Loài Được Zeus Che Chở trong 12 Cung Hoàng Đạo - Top 1 Khám phá', '<p>Bài giảng: <strong>Giải Mã Sư Tử - Chúa Tể Muôn Loài Được Zeus Che Chở trong 12 Cung Hoàng Đạo - Top 1 Khám phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/fm9GX2ZJfm4', NULL, 10, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (105, 11, 'Phép Thuật Bí Ẩn Của 12 Cung Hoàng Đạo Khi Ở Trong Thế Giới Huyền Huyễn - Top 1 Khám Phá', '<p>Bài giảng: <strong>Phép Thuật Bí Ẩn Của 12 Cung Hoàng Đạo Khi Ở Trong Thế Giới Huyền Huyễn - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Wdk9CD7CicY', NULL, 11, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (106, 11, 'Giải Mã Xử Nữ - Trinh Nữ Cầu Toàn Săm Soi Nhất 12 Cung Hoàng Đạo', '<p>Bài giảng: <strong>Giải Mã Xử Nữ - Trinh Nữ Cầu Toàn Săm Soi Nhất 12 Cung Hoàng Đạo</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/asCZyNhIjTc', NULL, 12, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (107, 11, 'Công Chúa DISNEY Đại Diện Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Công Chúa DISNEY Đại Diện Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/tFTMFLyewJ0', NULL, 13, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (11, 11, 'Kiểm tra trắc nghiệm: Giải Mã Chi Tiết Từng Chòm Sao', 80, 15, 14, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (11, 11, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Giải Mã Chi Tiết Từng Chòm Sao'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(31, 11, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(32, 11, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(33, 11, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (11, 11, 11, 11, 1, 5);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (12, 3, 'Bí Ẩn Tarot & Tương Lai 12 Chòm Sao', 5, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (108, 12, 'Giãi Mã Thiên Bình - Cán Cân Công Lý Và Xinh Đẹp Bậc Nhất 12 Cung Hoàng Đạo [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Giãi Mã Thiên Bình - Cán Cân Công Lý Và Xinh Đẹp Bậc Nhất 12 Cung Hoàng Đạo [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Du-C52Zb9Wo', NULL, 1, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (109, 12, 'Báu Vật Đá Quý Mang Lại Sức Mạnh Đại Diện Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Báu Vật Đá Quý Mang Lại Sức Mạnh Đại Diện Cho 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/lyq_3s98l7A', NULL, 2, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (110, 12, 'Giãi Mã BỌ CẠP - Nguy Hiểm Và Thông Minh Nhất 12 Cung Hoàng Đạo [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Giãi Mã BỌ CẠP - Nguy Hiểm Và Thông Minh Nhất 12 Cung Hoàng Đạo [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/AZ3Ae3no9gg', NULL, 3, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (111, 12, 'Xếp Hạng Chỉ Số Cảm Xúc EQ Của 12 Cung Hoàng Đạo -  Ai Là Kẻ Mạnh Nhất? [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Xếp Hạng Chỉ Số Cảm Xúc EQ Của 12 Cung Hoàng Đạo -  Ai Là Kẻ Mạnh Nhất? [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Gb8VAPW_O8w', NULL, 4, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (112, 12, 'NHÂN MÃ - Chú Ngựa Hoang Của Nữ Thần Artemis Yêu Tự Do Nhất 12 Cung Hoàng Đạo [Top 1 Khám Phá]', '<p>Bài giảng: <strong>NHÂN MÃ - Chú Ngựa Hoang Của Nữ Thần Artemis Yêu Tự Do Nhất 12 Cung Hoàng Đạo [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/v598khWhIIo', NULL, 5, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (113, 12, 'Giải Mã Ma Kết - Chú Dê Biển Chăm Chỉ Nhưng Khô Khan Nhất 12 Cung Hoàng Đạo [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Giải Mã Ma Kết - Chú Dê Biển Chăm Chỉ Nhưng Khô Khan Nhất 12 Cung Hoàng Đạo [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/oqxAl4CmUyo', NULL, 6, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (114, 12, 'Bật Mí Vũ Khí Ch.ế.t Người Trên Cơ Thể Của 12 Cung Hoàng Đạo - Top 1 Khám Phá', '<p>Bài giảng: <strong>Bật Mí Vũ Khí Ch.ế.t Người Trên Cơ Thể Của 12 Cung Hoàng Đạo - Top 1 Khám Phá</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/2CK4Ij1JXbU', NULL, 7, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (115, 12, 'Giải Mã Bảo Bình - Dị Nhân Độc Đáo Và Khác Biệt Nhất Trong 12 Cung Hoàng Đạo [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Giải Mã Bảo Bình - Dị Nhân Độc Đáo Và Khác Biệt Nhất Trong 12 Cung Hoàng Đạo [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/vuoSW8IsfVE', NULL, 8, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (116, 12, 'Xếp Hạng Độ May Mắn Của 12 Cung Hoàng Đạo - Bất Ngờ Vị Trí Số 1 [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Xếp Hạng Độ May Mắn Của 12 Cung Hoàng Đạo - Bất Ngờ Vị Trí Số 1 [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Me6cw7p5pAU', NULL, 9, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (117, 12, 'Giải Mã Song Ngư - “Não Cá Vàng” Được Nam Thần Biển Cả Poseidon Bảo Trợ [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Giải Mã Song Ngư - “Não Cá Vàng” Được Nam Thần Biển Cả Poseidon Bảo Trợ [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/y36ZfCSJL_k', NULL, 10, now(), now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (118, 12, 'Chọn 1 Lá Bài TAROT: Vợ/ Chồng Tương Lai Của Bạn Là Người Như Thế Nào? [Top 1 Khám Phá]', '<p>Bài giảng: <strong>Chọn 1 Lá Bài TAROT: Vợ/ Chồng Tương Lai Của Bạn Là Người Như Thế Nào? [Top 1 Khám Phá]</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/Sx-MOYRMjgw', NULL, 11, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (12, 12, 'Kiểm tra trắc nghiệm: Bí Ẩn Tarot & Tương Lai 12 Chòm Sao', 80, 15, 12, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (12, 12, 'Nội dung trọng tâm được nhấn mạnh trong chương ''Bí Ẩn Tarot & Tương Lai 12 Chòm Sao'' là gì?', 'SINGLE_CHOICE', 5, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
(34, 12, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
(35, 12, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
(36, 12, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (12, 12, 12, 12, 1, 5);

-- =====================================================================
-- Gán sẵn 3 khóa học cho tài khoản học viên student1 (id=4)
-- =====================================================================
INSERT INTO registrations (id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at) VALUES
(1, 4, 1, now(), 0, 'ACTIVE', NULL, NULL, 0, 'FREE', now()),
(2, 4, 2, now(), 0, 'ACTIVE', NULL, NULL, 0, 'FREE', now()),
(3, 4, 3, now(), 0, 'ACTIVE', NULL, NULL, 0, 'FREE', now())
ON CONFLICT (user_id, course_id) DO UPDATE SET status = 'ACTIVE', payment_status = 'FREE';

-- Cập nhật tất cả sequences
SELECT setval('settings_id_seq', (SELECT COALESCE(MAX(id), 1) FROM settings));
SELECT setval('courses_id_seq', (SELECT COALESCE(MAX(id), 1) FROM courses));
SELECT setval('modules_id_seq', (SELECT COALESCE(MAX(id), 1) FROM modules));
SELECT setval('lessons_id_seq', (SELECT COALESCE(MAX(id), 1) FROM lessons));
SELECT setval('quizzes_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quizzes));
SELECT setval('questions_id_seq', (SELECT COALESCE(MAX(id), 1) FROM questions));
SELECT setval('answer_options_id_seq', (SELECT COALESCE(MAX(id), 1) FROM answer_options));
SELECT setval('quiz_questions_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quiz_questions));
SELECT setval('registrations_id_seq', (SELECT COALESCE(MAX(id), 1) FROM registrations));

COMMIT;
