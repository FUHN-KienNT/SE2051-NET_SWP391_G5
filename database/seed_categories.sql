-- Seed concise & general course categories into settings
INSERT INTO settings (type, name, value, priority, status, description)
VALUES 
('COURSE_CATEGORY', 'Lập trình', 'PROGRAMMING', 1, 'ACTIVE', 'Khoá học lập trình, thuật toán, phát triển phần mềm'),
('COURSE_CATEGORY', 'Khoa học Dữ liệu & AI', 'DATA_AI', 2, 'ACTIVE', 'Trí tuệ nhân tạo, phân tích dữ liệu, Machine Learning'),
('COURSE_CATEGORY', 'Thiết kế', 'DESIGN', 3, 'ACTIVE', 'Thiết kế đồ họa, UI/UX, mỹ thuật số'),
('COURSE_CATEGORY', 'Kinh doanh', 'BUSINESS', 4, 'ACTIVE', 'Quản trị kinh doanh, khởi nghiệp, lãnh đạo doanh nghiệp'),
('COURSE_CATEGORY', 'Marketing', 'MARKETING', 5, 'ACTIVE', 'Marketing số, truyền thông, tiếp thị và thương hiệu'),
('COURSE_CATEGORY', 'Ngoại ngữ', 'LANGUAGES', 6, 'ACTIVE', 'Tiếng Anh giao tiếp, TOEIC, IELTS, Tiếng Nhật, Hàn, Hoa'),
('COURSE_CATEGORY', 'Kỹ năng mềm', 'SOFT_SKILLS', 7, 'ACTIVE', 'Kỹ năng giao tiếp, làm việc nhóm, tư duy phản biện'),
('COURSE_CATEGORY', 'Tài chính', 'FINANCE', 8, 'ACTIVE', 'Quản lý tài chính cá nhân, đầu tư'),
('COURSE_CATEGORY', 'Nghệ thuật & Sáng tạo', 'ART_CREATIVE', 9, 'ACTIVE', 'Nhiếp ảnh, quay dựng video, âm nhạc, hội họa'),
('COURSE_CATEGORY', 'Nhân tướng học', 'PHYSIOGNOMY', 10, 'ACTIVE', 'Kiến thức nhân tướng học, diện mạo và nhân trắc học ứng dụng'),
('COURSE_CATEGORY', 'Tử Vi & Phong Thủy', 'TU_VI', 11, 'ACTIVE', 'Nghiên cứu lá số Tử Vi, âm dương ngũ hành và giải đoán vận hạn'),
('COURSE_CATEGORY', 'Chiêm tinh học', 'ASTROLOGY', 12, 'ACTIVE', 'Khám phá bí mật 12 cung hoàng đạo và chiêm tinh học ứng dụng')
ON CONFLICT (type, name) DO NOTHING;
