-- =====================================================================
-- Courson LMS - Master Consolidated Seed Data
-- Bao gồm: Categories, 3 Khóa học đầy đủ (118 bài giảng),
-- 12 Quizzes chuẩn hóa, 48 Câu hỏi & 192 Phương án trả lời,
-- Đăng ký học viên, Tiến độ học mẫu & Lịch sử thi thử nghiệm.
-- =====================================================================
BEGIN;

-- 1. Tạo các danh mục khóa học bổ sung nếu chưa tồn tại
INSERT INTO settings (type, name, value, priority, status, description) VALUES
    ('COURSE_CATEGORY', 'Nhân tướng học & Nhân trắc học', 'PHYSIOGNOMY', 4, 'ACTIVE', 'Kiến thức nhân tướng học, diện mạo và nhân trắc học ứng dụng'),
    ('COURSE_CATEGORY', 'Tử Vi & Phong Thủy', 'TU_VI', 5, 'ACTIVE', 'Nghiên cứu lá số Tử Vi, âm dương ngũ hành và giải đoán vận hạn'),
    ('COURSE_CATEGORY', 'Chiêm Tinh & Cung Hoàng Đạo', 'ASTROLOGY', 6, 'ACTIVE', 'Khám phá bí mật 12 cung hoàng đạo và chiêm tinh học ứng dụng')
ON CONFLICT (type, name) DO NOTHING;

-- 2. Xóa sạch dữ liệu bài thi, tiến độ, đăng ký và khóa học cũ để nạp mới đồng bộ
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
VALUES (1, 1, 'Kiểm tra trắc nghiệm: Căn Bản Nhân Tướng & Tam Đình Ngũ Nhạc', 75, 15, 1, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (1, 1, 'Trong nhân tướng học, ''Tam Đình'' trên khuôn mặt con người bao gồm những bộ vị nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (1, 1, 'Thượng đình (chân tóc đến lông mày), Trung đình (lông mày đến đầu mũi), Hạ đình (nhân trung đến cằm)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (2, 1, 'Tiền đình (trán), Hậu đình (gáy), Trung đình (hai bên gò má)', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (3, 1, 'Thượng đình (mắt và trán), Trung đình (miệng và cằm), Hạ đình (tai và cổ)', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (4, 1, 'Thiên đình (đỉnh đầu), Địa đình (vùng cằm), Nhân đình (vùng mũi)', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (1, 1, 1, 1, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (2, 1, '''Ngũ Nhạc'' trong diện tướng tương ứng với 5 ngọn núi biểu trưng cho 5 bộ vị trọng yếu nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (5, 2, 'Trán (Nam Nhạc), Cằm (Bắc Nhạc), Mũi (Trung Nhạc), Gò má trái (Đông Nhạc), Gò má phải (Tây Nhạc)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (6, 2, 'Hai tai, Hai mắt và Khuôn miệng', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (7, 2, 'Đỉnh đầu, Thái dương trái, Thái dương phải, Cằm và Cổ', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (8, 2, 'Trán, Sống mũi, Nhân trung, Môi trên và Môi dưới', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (2, 1, 2, 1, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (3, 1, 'Ý nghĩa chính của bộ vị ''Thượng Đình'' (từ chân tóc đến lông mày) phản ánh điều gì về đương số?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (9, 3, 'Tiền vận (thời niên thiếu, sự nghiệp ban đầu) cùng năng lực tư duy, trí tuệ và phúc ấm tổ tiên', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (10, 3, 'Hậu vận từ tuổi 50 trở đi cùng con cái và điền sản', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (11, 3, 'Tình trạng tài chính và khả năng tích lũy tài sản lúc trung niên', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (12, 3, 'Sức khỏe nội tạng và tuổi thọ tuyệt đối', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (3, 1, 3, 1, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (4, 1, 'Yếu tố cốt lõi nhất để một khuôn mặt đạt tiêu chuẩn ''Ngũ Nhạc triều quy'' là gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (13, 4, 'Bốn ngọn núi Đông - Tây - Nam - Bắc đều chầu về ngọn núi Trung Nhạc (Mũi) với tỉ lệ cân phân, đắc cách', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (14, 4, 'Mũi phải thật cao nhọn và lấn át hoàn toàn trán và cằm', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (15, 4, 'Hai gò má phải phẳng lì, không nổi khối so với sống mũi', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (16, 4, 'Trán và cằm phải vuông vức tuyệt đối không có độ cong tự nhiên', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (4, 1, 4, 1, 4, 25);
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
VALUES (2, 2, 'Kiểm tra trắc nghiệm: Giải Mã Ngũ Quan & Diện Mạo', 75, 15, 2, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (5, 2, '''Ngũ Quan'' trong nhân tướng học gồm có 5 giác quan và cơ quan nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (17, 5, 'Lông mày (Bảo thọ quan), Mắt (Giám sát quan), Tai (Thái thính quan), Mũi (Thẩm biện quan), Miệng (Xuất nạp quan)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (18, 5, 'Tóc, Râu, Lông mày, Móng tay và Răng', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (19, 5, 'Mắt, Mũi, Miệng, Lưỡi và Da thịt', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (20, 5, 'Trán, Cằm, Gò má, Thái dương và Nhân trung', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (5, 2, 5, 2, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (6, 2, 'Tướng ''Giám sát quan'' (Đôi mắt) được coi là quý tướng và phản ánh tâm hồn thanh khiết khi có đặc điểm nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (21, 6, 'Tròng đen trắng phân minh, ánh mắt sáng có thần khí nhưng ẩn tàng, không lộ hung quang', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (22, 6, 'Mắt lộ tam bạch hoặc tứ bạch, lòng trắng nhiều hơn lòng đen', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (23, 6, 'Mắt luôn đảo liên tục, ánh nhìn sắc lẹm và trừng trộ', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (24, 6, 'Mắt lờ đờ không có tiêu cự rõ ràng', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (6, 2, 6, 2, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (7, 2, 'Bộ vị ''Ấn Đường'' (nằm giữa hai đầu lông mày) mang ý nghĩa phong thủy và nhân tướng là gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (25, 7, 'Cửa ngõ của vận khí (Cung Mệnh), thể hiện độ rộng mở của tâm trí và vận hạn hiện tại', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (26, 7, 'Cung Phu Thê phản ánh hạnh phúc gia đình', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (27, 7, 'Cung Nô Bộc phản ánh mối quan hệ với cấp dưới và bạn bè', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (28, 7, 'Cung Tử Tức phản ánh đường con cái', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (7, 2, 7, 2, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (8, 2, 'Đặc điểm của một ''Thẩm biện quan'' (Mũi) đắc cách biểu trưng cho tài lộc dồi dào là gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (29, 8, 'Sống mũi thẳng đầy đặn, chuẩn đầu (chóp mũi) tròn trịa, hai cánh mũi (dực đình) dày dặn và kín đáo', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (30, 8, 'Sống mũi gồ ghề, đầu mũi nhọn hoắt và lỗ mũi hếch lên trên', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (31, 8, 'Cánh mũi mỏng manh, nhìn trực diện thấy rõ toàn bộ lỗ mũi', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (32, 8, 'Mũi lệch nghiêng sang một bên so với trục đối xứng khuôn mặt', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (8, 2, 8, 2, 4, 25);
INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES (3, 1, 'Khí Sắc, Tâm Tướng & Ứng Dụng Đời Sống', 3, now());
INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES (17, 3, 'Buổi 1  Nhân tướng học  thầy Viên Minh', '<p>Bài giảng: <strong>Buổi 1  Nhân tướng học  thầy Viên Minh</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>', 'https://www.youtube.com/embed/eSJJffB1tbQ', NULL, 1, now(), now());
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES (3, 3, 'Kiểm tra trắc nghiệm: Khí Sắc, Tâm Tướng & Ứng Dụng Đời Sống', 75, 15, 3, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (9, 3, 'Câu châm ngôn nổi tiếng ''Tướng tùy tâm sinh, tướng tùy tâm diệt'' mang hàm nghĩa giáo dục gì trong nhân tướng học?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (33, 9, 'Diện mạo và khí sắc con người có thể biến chuyển tích cực thông qua việc tu dưỡng tâm tính, đạo đức và lối sống', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (34, 9, 'Tướng mạo là bất biến từ khi sinh ra và không bao giờ thay đổi theo thời gian', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (35, 9, 'Chỉ cần phẫu thuật thẩm mỹ thay đổi hình tướng là số phận tự động giàu sang', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (36, 9, 'Tâm hồn không có liên hệ gì đến thần thái và ánh mắt bên ngoài', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (9, 3, 9, 3, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (10, 3, 'Trong việc quan sát ''Khí sắc'', sắc diện nào báo hiệu cơ thể dồi dào sinh lực và tinh thần phấn chấn thuận lợi?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (37, 10, 'Sắc hồng hào nhuận sáng, ẩn hiện dưới da tựa như ngọc bích', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (38, 10, 'Sắc xám xịt như tro tàn hoặc ám đen ở vùng trán và ấn đường', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (39, 10, 'Sắc trắng bệch như vôi bột, không có huyết sắc', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (40, 10, 'Sắc đỏ rực bất thường bừng bừng như lửa thiêu đốt', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (10, 3, 10, 3, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (11, 3, 'Khi ứng dụng quan sát nhân tướng trong tuyển dụng và đối nhân xử thế, điều quan trọng hàng đầu cần tránh là gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (41, 11, 'Phán xét một chiều định kiến qua một nét tướng đơn lẻ mà không xét tổng thể ''Tâm tướng'' và thần thái', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (42, 11, 'Lắng nghe giọng nói và xem tướng đi đứng cử chỉ', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (43, 11, 'Quan sát cách họ đối xử với người yếu thế hơn mình', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (44, 11, 'Xem xét sự hòa nhã trong nụ cười và ánh mắt', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (11, 3, 11, 3, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (12, 3, 'Thần thái (Thần khí) của một người thành tựu vững bền thường bộc lộ rõ nhất qua yếu tố nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (45, 12, 'Điềm tĩnh, tự tại, ánh mắt trầm ổn và lời nói đi đôi với việc làm', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (46, 12, 'Nói to át giọng người khác, cử chỉ hung hăng vội vã', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (47, 12, 'Hay liếc ngang liếc dọc và luôn tỏ ra bí hiểm', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (48, 12, 'Cười cợt thiếu kiểm soát trong mọi hoàn cảnh', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (12, 3, 12, 3, 4, 25);
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
VALUES (4, 4, 'Kiểm tra trắc nghiệm: Nhập Môn Lá Số Tử Vi & Học Thuyết Ngũ Hành', 75, 15, 1, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (13, 4, 'Học thuyết Ngũ Hành trong tử vi bao gồm 5 yếu tố nào theo vòng tương sinh thuận chiều?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (49, 13, 'Mộc sinh Hỏa, Hỏa sinh Thổ, Thổ sinh Kim, Kim sinh Thủy, Thủy sinh Mộc', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (50, 13, 'Kim sinh Mộc, Mộc sinh Thổ, Thổ sinh Thủy, Thủy sinh Hỏa, Hỏa sinh Kim', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (51, 13, 'Hỏa sinh Thủy, Thủy sinh Kim, Kim sinh Thổ, Thổ sinh Mộc', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (52, 13, 'Thủy sinh Thổ, Thổ sinh Kim, Kim sinh Hỏa, Hỏa sinh Mộc', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (13, 4, 13, 4, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (14, 4, 'Hệ thống Can Chi dùng để an lá số Tử Vi gồm bao nhiêu Thiên Can và bao nhiêu Địa Chi?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (53, 14, '10 Thiên Can và 12 Địa Chi', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (54, 14, '12 Thiên Can và 10 Địa Chi', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (55, 14, '8 Thiên Can và 8 Địa Chi', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (56, 14, '12 Thiên Can và 12 Địa Chi', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (14, 4, 14, 4, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (15, 4, 'Bốn yếu tố thời gian bắt buộc phải có để thiết lập một lá số Tử Vi chuẩn xác là gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (57, 15, 'Giờ sinh, ngày sinh, tháng sinh và năm sinh (tính theo Âm lịch hoặc quy đổi chuẩn xác) kèm giới tính', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (58, 15, 'Chỉ cần ngày tháng năm sinh Dương lịch, không cần giờ sinh', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (59, 15, 'Giờ sinh, nhóm máu, nơi sinh và năm sinh', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (60, 15, 'Tên tuổi của cha mẹ và thời điểm cất tiếng khóc chào đời', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (15, 4, 15, 4, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (16, 4, 'Cặp quan hệ tương khắc nào sau đây là chuẩn xác theo quy luật Ngũ Hành?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (61, 16, 'Kim khắc Mộc, Mộc khắc Thổ, Thổ khắc Thủy, Thủy khắc Hỏa, Hỏa khắc Kim', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (62, 16, 'Kim khắc Hỏa, Hỏa khắc Thủy, Thủy khắc Kim', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (63, 16, 'Thổ khắc Mộc, Mộc khắc Kim, Kim khắc Thủy', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (64, 16, 'Mộc khắc Thủy, Thủy khắc Hỏa, Hỏa khắc Thổ', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (16, 4, 16, 4, 4, 25);
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
VALUES (5, 5, 'Kiểm tra trắc nghiệm: Hệ Thống 12 Cung & Can Chi Bản Mệnh', 75, 15, 2, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (17, 5, 'Trên bàn cờ lá số Tử Vi, 12 cung chức vị tượng trưng cho các phương diện cuộc đời bắt đầu bằng cung trọng tâm nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (65, 17, 'Cung Mệnh', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (66, 17, 'Cung Tài Bạch', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (67, 17, 'Cung Quan Lộc', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (68, 17, 'Cung Thiên Di', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (17, 5, 17, 5, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (18, 5, '''Tam hợp Mệnh'' là sự phối hợp mật thiết giữa ba cung vị then chốt nào quyết định thành bại cuộc đời?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (69, 18, 'Cung Mệnh, Cung Quan Lộc và Cung Tài Bạch (Mệnh - Tài - Quan)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (70, 18, 'Cung Mệnh, Cung Phụ Mẫu và Cung Huynh Đệ', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (71, 18, 'Cung Mệnh, Cung Thiên Di và Cung Phu Thê', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (72, 18, 'Cung Mệnh, Cung Phúc Đức và Cung Điền Trạch', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (18, 5, 18, 5, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (19, 5, 'Cung Thân trong lá số Tử Vi đại diện cho điều gì và bắt đầu chi phối mạnh mẽ từ giai đoạn nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (73, 19, 'Hậu vận, hành động thực tế của đương số và bắt đầu chi phối rõ nét từ tuổi trung niên (sau 30 tuổi)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (74, 19, 'Tuổi thơ ấu từ 1 đến 15 tuổi', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (75, 19, 'Tiền tài của cha mẹ truyền lại', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (76, 19, 'Trạng thái sức khỏe thể chất trong năm sinh', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (19, 5, 19, 5, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (20, 5, 'Cung xung chiếu trực tiếp với Cung Mệnh trên vòng 12 Địa Chi là cung nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (77, 20, 'Cung Thiên Di (phản ánh môi trường xã hội bên ngoài khi xuất hành ra ngoài)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (78, 20, 'Cung Tật Ách (phản ánh bệnh tật tai ương)', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (79, 20, 'Cung Phu Thê (phản ánh bạn đời hôn phối)', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (80, 20, 'Cung Nô Bộc (phản ánh bạn bè cộng sự)', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (20, 5, 20, 5, 4, 25);
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
VALUES (6, 6, 'Kiểm tra trắc nghiệm: Luận Giải Chính Tinh & Phụ Tinh', 75, 15, 3, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (21, 6, 'Trong Tử Vi Đẩu Số có tổng cộng bao nhiêu Chính Tinh (các ngôi sao lớn quyết định tính chất cốt lõi)?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (81, 21, '14 Chính Tinh (thuộc hai chòm Tử Vi và Thiên Phủ)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (82, 21, '10 Chính Tinh', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (83, 21, '12 Chính Tinh', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (84, 21, '18 Chính Tinh', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (21, 6, 21, 6, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (22, 6, 'Ngôi sao nào được mệnh danh là ''Đế tinh'' (Vua của các vì sao), tượng trưng cho quyền uy, đức độ và khả năng lãnh đạo?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (85, 22, 'Sao Tử Vi', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (86, 22, 'Sao Thất Sát', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (87, 22, 'Sao Cự Môn', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (88, 22, 'Sao Tham Lang', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (22, 6, 22, 6, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (23, 6, 'Bộ ''Tứ Hóa'' - bốn biến hóa then chốt mang lại vận hội và thách thức trong lá số Tử Vi gồm những sao nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (89, 23, 'Hóa Khoa, Hóa Quyền, Hóa Lộc, Hóa Kỵ', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (90, 23, 'Hóa Tinh, Hóa Khí, Hóa Thần, Hóa Sát', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (91, 23, 'Hóa Tài, Hóa Phúc, Hóa Thọ, Hóa Khang', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (92, 23, 'Hóa Sinh, Hóa Thành, Hóa Hoại, Hóa Diệt', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (23, 6, 23, 6, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (24, 6, 'Bộ ''Lục Sát Tinh'' trong Tử Vi mang tính chất xung phá, rèn luyện tôi luyện bản lĩnh gồm những sao nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (93, 24, 'Kình Dương, Đà La, Hỏa Tinh, Linh Tinh, Địa Không, Địa Kiếp', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (94, 24, 'Văn Xương, Văn Khúc, Tả Phụ, Hữu Bật, Thiên Khôi, Thiên Việt', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (95, 24, 'Đào Hoa, Hồng Loan, Hỷ Thần, Thiên Hỷ, Long Trì, Phượng Các', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (96, 24, 'Lộc Tồn, Thiên Mã, Quốc Ấn, Đường Phù, Hóa Lộc, Hóa Quyền', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (24, 6, 24, 6, 4, 25);
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
VALUES (7, 7, 'Kiểm tra trắc nghiệm: Kỹ Thuật Luận Đoán & Workshop Chuyên Sâu', 75, 15, 4, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (25, 7, 'Nguyên tắc quan trọng khi luận giải một cung vị bất kỳ trên lá số Tử Vi là phải phối hợp những yếu tố nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (97, 25, 'Cung vị chính tinh đắc hãm, tam phương tứ chính (cung chiếu, hai cung tam hợp) và giáp cung', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (98, 25, 'Chỉ nhìn duy nhất 1 ngôi sao tại cung đó mà không cần xem các cung liên quan', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (99, 25, 'Bỏ qua hoàn toàn ngũ hành nạp âm của bản mệnh và cung an sao', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (100, 25, 'Chỉ xét ngày sinh Dương lịch mà không xét can chi năm tháng', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (25, 7, 25, 7, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (26, 7, 'Khái niệm ''Đại Hạn'' trong Tử Vi chỉ chu kỳ vận hạn kéo dài bao nhiêu năm?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (101, 26, 'Chu kỳ 10 năm', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (102, 26, 'Chu kỳ 1 năm', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (103, 26, 'Chu kỳ 5 năm', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (104, 26, 'Chu kỳ 12 năm', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (26, 7, 26, 7, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (27, 7, 'Khi gặp cách cục ''Hung tinh đắc địa'' trên lá số, người có ý chí kiên định thường đạt được điều gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (105, 27, 'Phát dã như lôi, biến khó khăn nghịch cảnh thành bàn đạp để tạo dựng thành tựu đột phá', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (106, 27, 'Luôn luôn thất bại thảm hại không bao giờ vực dậy được', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (107, 27, 'Sống an nhàn thụ động không cần phải nỗ lực học tập', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (108, 27, 'Tránh né mọi va chạm và chỉ làm công việc tĩnh lặng', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (27, 7, 27, 7, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (28, 7, 'Đạo đức nghề nghiệp căn bản của một chuyên gia hoặc người nghiên cứu Tử Vi chân chính là gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (109, 28, 'Giúp người khác thấu hiểu điểm mạnh điểm yếu, định hướng tu tâm dưỡng đức và vượt qua vận hạn bằng trí tuệ, tránh mê tín dọa dẫm', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (110, 28, 'Phán những điều ma mị rùng rợn để trục lợi cúng bái giải hạn vô căn cứ', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (111, 28, 'Khẳng định số phận là tuyệt đối không thể thay đổi bằng nỗ lực cá nhân', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (112, 28, 'Khuyên học viên bỏ mặc công việc chờ đợi số trời an bài', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (28, 7, 28, 7, 4, 25);
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
VALUES (8, 8, 'Kiểm tra trắc nghiệm: Truyền Thuyết & Bản Chất 12 Cung Hoàng Đạo', 75, 15, 1, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (29, 8, '12 Cung Hoàng Đạo trong Chiêm tinh học phương Tây được chia đều thành 4 nhóm nguyên tố tự nhiên nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (113, 29, 'Lửa (Fire), Đất (Earth), Khí (Air), Nước (Water)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (114, 29, 'Kim, Mộc, Thủy, Hỏa', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (115, 29, 'Trời, Đất, Biển, Rừng', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (116, 29, 'Sắt, Gỗ, Đá, Bụi', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (29, 8, 29, 8, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (30, 8, 'Nhóm 3 cung hoàng đạo thuộc nguyên tố ''Lửa'' (Fire) tràn đầy nhiệt huyết và tính tiên phong gồm những cung nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (117, 30, 'Bạch Dương (Aries), Sư Tử (Leo), Nhân Mã (Sagittarius)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (118, 30, 'Kim Ngưu, Xử Nữ, Ma Kết', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (119, 30, 'Song Tử, Thiên Bình, Bảo Bình', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (120, 30, 'Cự Giải, Bọ Cạp, Song Ngư', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (30, 8, 30, 8, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (31, 8, 'Vòng Hoàng Đạo bắt đầu bằng cung nào vào thời điểm điểm phân mùa xuân (Xuân phân ~21/03)?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (121, 31, 'Bạch Dương (Aries)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (122, 31, 'Kim Ngưu (Taurus)', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (123, 31, 'Ma Kết (Capricorn)', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (124, 31, 'Song Ngư (Pisces)', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (31, 8, 31, 8, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (32, 8, 'Đặc tính chung nổi bật nhất của nhóm cung nguyên tố ''Đất'' (Kim Ngưu, Xử Nữ, Ma Kết) là gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (125, 32, 'Thực tế, kiên định, đáng tin cậy và có tư duy tổ chức logic vững vàng', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (126, 32, 'Bốc đồng, nóng nảy và thích mạo hiểm không tính toán', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (127, 32, 'Mộng mơ, cảm xúc lấn át lý trí và hay thay đổi tâm trạng', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (128, 32, 'Tùy hứng, tự do bay bổng và ghét mọi nguyên tắc ổn định', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (32, 8, 32, 8, 4, 25);
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
VALUES (9, 9, 'Kiểm tra trắc nghiệm: Tình Yêu, Nghề Nghiệp & Bí Mật Tính Cách', 75, 15, 2, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (33, 9, 'Trong mối quan hệ tình cảm, các cung cùng nhóm nguyên tố nào thường tạo nên sự đồng điệu sâu sắc về mặt cảm xúc và sự thấu cảm?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (129, 33, 'Nhóm nguyên tố Nước (Cự Giải, Bọ Cạp, Song Ngư)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (130, 33, 'Nhóm nguyên tố Đất và Lửa xung khắc trực diện', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (131, 33, 'Nhóm Khí và Đất', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (132, 33, 'Bất kỳ cung nào không phân biệt tính chất', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (33, 9, 33, 9, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (34, 9, 'Nhóm cung Khí (Song Tử, Thiên Bình, Bảo Bình) thường phát huy tối đa tiềm năng bản thân trong những lĩnh vực nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (133, 34, 'Truyền thông, ngoại giao, nghiên cứu ý tưởng, công nghệ sáng tạo và viết lách', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (134, 34, 'Lao động thể lực nặng nhọc mang tính lặp đi lặp lại', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (135, 34, 'Các công việc cô lập hoàn toàn không tiếp xúc trao đổi với con người', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (136, 34, 'Chỉ làm việc rập khuôn theo mẫu cũ không cải tiến', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (34, 9, 34, 9, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (35, 9, 'Cung hoàng đạo nào được mệnh danh là ''Bậc thầy ngoại giao'', luôn hướng tới sự hòa hợp, công bằng và thẩm mỹ tao nhã?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (137, 35, 'Thiên Bình (Libra)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (138, 35, 'Bạch Dương (Aries)', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (139, 35, 'Bọ Cạp (Scorpio)', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (140, 35, 'Ma Kết (Capricorn)', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (35, 9, 35, 9, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (36, 9, 'Thách thức lớn nhất trong tình cảm của nhóm cung nguyên tố Lửa (Bạch Dương, Sư Tử, Nhân Mã) là gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (141, 36, 'Tính hiếu thắng, cái tôi lớn và thiếu kiên nhẫn khi xảy ra bất đồng', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (142, 36, 'Quá khép kín, không bao giờ bày tỏ cảm xúc ra bên ngoài', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (143, 36, 'Luôn luôn do dự phụ thuộc hoàn toàn vào ý kiến của người khác', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (144, 36, 'Không có ngọn lửa nhiệt huyết trong tình yêu', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (36, 9, 36, 9, 4, 25);
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
VALUES (10, 10, 'Kiểm tra trắc nghiệm: Xếp Hạng & Khám Phá Thế Giới Hoàng Đạo', 75, 15, 3, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (37, 10, 'Cung hoàng đạo nào thường đứng đầu bảng về tính kỷ luật, sự kiên trì và tham vọng xây dựng sự nghiệp bền bỉ?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (145, 37, 'Ma Kết (Capricorn)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (146, 37, 'Nhân Mã (Sagittarius)', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (147, 37, 'Song Ngư (Pisces)', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (148, 37, 'Song Tử (Gemini)', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (37, 10, 37, 10, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (38, 10, 'Chòm sao nào nổi tiếng với sự sâu sắc, trực giác tâm lý sắc bén và ý chí kiên cường tự tái sinh sau nghịch cảnh?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (149, 38, 'Bọ Cạp (Scorpio / Thiên Yết)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (150, 38, 'Kim Ngưu (Taurus)', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (151, 38, 'Cự Giải (Cancer)', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (152, 38, 'Sư Tử (Leo)', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (38, 10, 38, 10, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (39, 10, 'Đặc điểm nổi trội nhất giúp cung Song Tử (Gemini) thích nghi xuất sắc trong mọi môi trường xã hội là gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (153, 39, 'Khả năng ngôn ngữ hoạt bát, sự tò mò học hỏi nhanh và tính linh hoạt cao', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (154, 39, 'Tính bảo thủ và trung thành tuyệt đối với một thói quen cố định', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (155, 39, 'Sức chịu đựng thể lực vượt trội không cần giao tiếp', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (156, 39, 'Luôn giữ im lặng tuyệt đối trước mọi cuộc tranh luận', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (39, 10, 39, 10, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (40, 10, 'Cung hoàng đạo nào biểu trưng cho sự ấm áp của gia đình, bản năng che chở nuôi dưỡng và trí nhớ tình cảm tuyệt vời?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (157, 40, 'Cự Giải (Cancer)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (158, 40, 'Bảo Bình (Aquarius)', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (159, 40, 'Bạch Dương (Aries)', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (160, 40, 'Nhân Mã (Sagittarius)', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (40, 10, 40, 10, 4, 25);
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
VALUES (11, 11, 'Kiểm tra trắc nghiệm: Giải Mã Chi Tiết Từng Chòm Sao', 75, 15, 4, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (41, 11, 'Chòm sao Bảo Bình (Aquarius) được cai quản bởi Thiên Vương Tinh (Uranus) mang phẩm chất độc đáo nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (161, 41, 'Tư duy đột phá, tầm nhìn thời đại, tinh thần nhân đạo và yêu chuộng tự do cá nhân', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (162, 41, 'Thích bắt chước người khác và tuân phục tuyệt đối giáo điều cũ', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (163, 41, 'Đam mê quyền lực vật chất danh vị truyền thống', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (164, 41, 'Luôn phụ thuộc tinh thần vào người xung quanh', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (41, 11, 41, 11, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (42, 11, 'Biểu tượng của chòm sao Kim Ngưu (Taurus) gắn liền với hình tượng gì và phản ánh giá trị gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (165, 42, 'Con Bò Đực kiên định, phản ánh sự vững chãi, kiên nhẫn và thưởng thức giá trị vật chất ổn định', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (166, 42, 'Cán cân công lý cân bằng lý trí', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (167, 42, 'Con Cua với lớp vỏ phòng thủ nhạy cảm', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (168, 42, 'Nhân Mã cầm cung tên bay nhảy tự do', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (42, 11, 42, 11, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (43, 11, 'Sư Tử (Leo) được cai quản bởi Mặt Trời rực rỡ, điểm mạnh cốt lõi trong tính cách của họ là gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (169, 43, 'Sự hào hiệp, tự tin, khả năng truyền cảm hứng và tinh thần lãnh đạo đầy phong thái', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (170, 43, 'Luôn thích lùi vào bóng tối và không dám đứng trước đám đông', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (171, 43, 'Sự hà tiện chi li từng đồng xu lẻ', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (172, 43, 'Hay nghi ngờ đố kỵ với sự thành công của người khác', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (43, 11, 43, 11, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (44, 11, 'Chòm sao Song Ngư (Pisces) - cung hoàng đạo cuối cùng trên vòng Hoàng Đạo - kết tinh vẻ đẹp tinh thần nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (173, 44, 'Lòng từ bi bao dung, trí tưởng tượng phong phú và khả năng kết nối tâm linh sâu sắc', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (174, 44, 'Tính toán lạnh lùng và chỉ tin vào những gì nhìn thấy trước mắt', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (175, 44, 'Tính cạnh tranh gay gắt khốc liệt trong công việc', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (176, 44, 'Sự thực dụng tuyệt đối về tiền bạc', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (44, 11, 44, 11, 4, 25);
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
VALUES (12, 12, 'Kiểm tra trắc nghiệm: Bí Ẩn Tarot & Tương Lai 12 Chòm Sao', 75, 15, 5, now(), now());
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (45, 12, 'Trong sự kết hợp giữa Chiêm tinh học và bài Tarot, các lá bài Ẩn chính (Major Arcana) đại diện cho điều gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (177, 45, 'Các nguyên mẫu tâm lý học, những bài học chuyển hóa lớn của cuộc đời và các chòm sao tương ứng', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (178, 45, 'Chỉ là những lá bài bói toán ngẫu nhiên không có tính hệ thống', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (179, 45, 'Những quy định pháp luật xã hội hiện đại', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (180, 45, 'Các chỉ số đo lường tài chính kinh doanh thuần túy', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (45, 12, 45, 12, 1, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (46, 12, 'Lá bài Tarot ''The Emperor'' (Hoàng Đế) tương ứng với cung hoàng đạo tiên phong nào thể hiện ý chí khai phá và trật tự?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (181, 46, 'Bạch Dương (Aries)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (182, 46, 'Song Ngư (Pisces)', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (183, 46, 'Cự Giải (Cancer)', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (184, 46, 'Thiên Bình (Libra)', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (46, 12, 46, 12, 2, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (47, 12, 'Lá bài ''The Star'' (Ngôi Sao) mang thông điệp về niềm hy vọng, cảm hứng tương lai và chữa lành kết nối trực tiếp với cung nào?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (185, 47, 'Bảo Bình (Aquarius)', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (186, 47, 'Kim Ngưu (Taurus)', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (187, 47, 'Ma Kết (Capricorn)', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (188, 47, 'Bọ Cạp (Scorpio)', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (47, 12, 47, 12, 3, 25);
INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES (48, 12, 'Mục tiêu tối hậu của việc nghiên cứu Chiêm Tinh Học và các bộ môn biểu tượng đối với con người hiện đại là gì?', 'SINGLE_CHOICE', 25, now());
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (189, 48, 'Tự nhận thức sâu sắc bản thân (Self-awareness), phát huy sở trường, khắc phục khuyết điểm và sống hài hòa', true, 1);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (190, 48, 'Dự đoán cứng nhắc ngày giờ gặp rủi ro để trốn tránh thực tế cuộc sống', false, 2);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (191, 48, 'Tin vào định mệnh an bài và buông xuôi không cần cố gắng học tập lao động', false, 3);
INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES (192, 48, 'Dùng để phán xét và cô lập người khác trong các mối quan hệ xã hội', false, 4);
INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES (48, 12, 48, 12, 4, 25);

-- =====================================================================
-- 3. Đăng ký khóa học mặc định cho tài khoản học viên student1 (id=4)
-- =====================================================================
INSERT INTO registrations (id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at) VALUES
(1, 4, 1, now() - interval '3 days', 24.00, 'ACTIVE', NULL, NULL, 0, 'FREE', now() - interval '3 days'),
(2, 4, 2, now() - interval '2 days', 0.00, 'ACTIVE', NULL, NULL, 0, 'FREE', now() - interval '2 days'),
(3, 4, 3, now() - interval '1 day',  0.00, 'ACTIVE', NULL, NULL, 0, 'FREE', now() - interval '1 day')
ON CONFLICT (user_id, course_id) DO UPDATE SET status = 'ACTIVE', payment_status = 'FREE';

-- 4. Tiến độ học thử nghiệm (student1 đã học xong 4 bài đầu của Khóa học 1)
INSERT INTO lesson_progress (registration_id, lesson_id, status, completed_at) VALUES
(1, 1, 'COMPLETED', now() - interval '2 days'),
(1, 2, 'COMPLETED', now() - interval '2 days'),
(1, 3, 'COMPLETED', now() - interval '1 day'),
(1, 4, 'COMPLETED', now() - interval '1 day')
ON CONFLICT (registration_id, lesson_id) DO UPDATE SET status = 'COMPLETED', completed_at = now();

-- 5. Lịch sử bài làm kiểm tra mẫu (student1 đã hoàn thành Quiz 1 với điểm số 100/100 tuyệt đối)
INSERT INTO quiz_attempts (id, registration_id, quiz_id, submitted_at, total_score, pass_status) VALUES
(1, 1, 1, now() - interval '1 day', 100.00, true)
ON CONFLICT (registration_id, quiz_id) DO UPDATE SET total_score = 100.00, pass_status = true;

-- Chi tiết đáp án học viên chọn cho Quiz 1 (Các câu hỏi 1, 2, 3, 4 đều chọn đúng phương án 1, 5, 9, 13)
INSERT INTO quiz_answers (quiz_attempt_id, question_id, selected_option_id, is_correct, score) VALUES
(1, 1, 1, true, 25.00),
(1, 2, 5, true, 25.00),
(1, 3, 9, true, 25.00),
(1, 4, 13, true, 25.00)
ON CONFLICT (quiz_attempt_id, question_id) DO UPDATE SET selected_option_id = EXCLUDED.selected_option_id, is_correct = true, score = 25.00;

-- =====================================================================
-- 6. Cập nhật tất cả các sequences của PostgreSQL
-- =====================================================================
SELECT setval('settings_id_seq', (SELECT COALESCE(MAX(id), 1) FROM settings));
SELECT setval('users_id_seq', (SELECT COALESCE(MAX(id), 1) FROM users));
SELECT setval('courses_id_seq', (SELECT COALESCE(MAX(id), 1) FROM courses));
SELECT setval('modules_id_seq', (SELECT COALESCE(MAX(id), 1) FROM modules));
SELECT setval('lessons_id_seq', (SELECT COALESCE(MAX(id), 1) FROM lessons));
SELECT setval('quizzes_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quizzes));
SELECT setval('questions_id_seq', (SELECT COALESCE(MAX(id), 1) FROM questions));
SELECT setval('answer_options_id_seq', (SELECT COALESCE(MAX(id), 1) FROM answer_options));
SELECT setval('quiz_questions_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quiz_questions));
SELECT setval('registrations_id_seq', (SELECT COALESCE(MAX(id), 1) FROM registrations));
SELECT setval('lesson_progress_id_seq', (SELECT COALESCE(MAX(id), 1) FROM lesson_progress));
SELECT setval('quiz_attempts_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quiz_attempts));
SELECT setval('quiz_answers_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quiz_answers));

COMMIT;
