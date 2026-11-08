-- =====================================================================
-- COURSON LMS - MASTER TESTING SEED (CHÍNH THỨC VỚI 100% VIDEO THẬT TỪ 8 PLAYLISTS)
-- Tổng cộng trích xuất đầy đủ 295 bài học từ 8 Playlist YouTube thật.
-- =====================================================================

BEGIN;

-- 1. Thiết lập danh mục hệ thống
INSERT INTO settings (type, name, value, priority, status, description) VALUES
    ('COURSE_CATEGORY', 'Lập trình',               'PROGRAMMING',  1, 'ACTIVE', 'Phát triển phần mềm, web, kiến trúc hệ thống và AI'),
    ('COURSE_CATEGORY', 'Nhân tướng học',         'PHYSIOGNOMY',  2, 'ACTIVE', 'Nhân tướng học, quan sát diện mạo và nhân trắc học ứng dụng'),
    ('COURSE_CATEGORY', 'Chiêm tinh học',         'ASTROLOGY',    3, 'ACTIVE', 'Bí mật 12 cung hoàng đạo, các hành tinh và chiêm tinh'),
    ('COURSE_CATEGORY', 'Tâm lý & Kỹ năng mềm',    'SOFT_SKILLS',  4, 'ACTIVE', 'Tâm lý học đại cương, hành vi con người và kỹ năng'),
    ('COURSE_CATEGORY', 'Ngoại ngữ',              'LANGUAGES',    5, 'ACTIVE', 'Tiếng Anh, Tiếng Trung, Tiếng Nhật, Ngoại ngữ giao tiếp'),
    ('COURSE_CATEGORY', 'Nghệ thuật & Sáng tạo',   'ART_CREATIVE', 6, 'ACTIVE', 'Nhạc lý, guitar, thanh nhạc, sáng tác và nghệ thuật')
ON CONFLICT (type, name) DO NOTHING;

-- 2. Dọn dẹp dữ liệu cũ theo ràng buộc khóa ngoại
DELETE FROM quiz_answers;
DELETE FROM quiz_attempts;
DELETE FROM lesson_progress;
DELETE FROM registrations;
DELETE FROM quiz_questions;
DELETE FROM answer_options;
DELETE FROM questions;
DELETE FROM quizzes;
DELETE FROM lessons;
DELETE FROM modules;
DELETE FROM courses;
DELETE FROM password_reset_tokens;
DELETE FROM email_verification_tokens;

-- 3. Khởi tạo 5 tài khoản thử nghiệm chuẩn (mật khẩu: '123' hoặc 'admin123')
DELETE FROM users WHERE id IN (1, 2, 3, 4, 5);
INSERT INTO users (id, username, email, password_hash, full_name, role_id, role_type, auth_provider, status, phone, birth_date) VALUES
    (1, 'admin', 'admin@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', 'Quản trị viên Hệ thống', 5, 'USER_ROLE', 'LOCAL', 'ACTIVE', '0901234567', '1990-01-01'),
    (2, 'manager1', 'manager@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', 'Quản lý Khóa học', 3, 'USER_ROLE', 'LOCAL', 'ACTIVE', '0912345678', '1992-05-15'),
    (3, 'expert1', 'expert@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', 'Chuyên gia Giảng viên', 4, 'USER_ROLE', 'LOCAL', 'ACTIVE', '0923456789', '1988-10-20'),
    (4, 'student1', 'student@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', 'Học viên Nguyễn Văn A (Đã sở hữu khóa)', 2, 'USER_ROLE', 'LOCAL', 'ACTIVE', '0934567890', '2002-12-12'),
    (5, 'student2', 'student2@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', 'Học viên Trần Thị B (Tài khoản mới tinh)', 2, 'USER_ROLE', 'LOCAL', 'ACTIVE', '0945678901', '2003-08-20')
ON CONFLICT (id) DO UPDATE SET password_hash = EXCLUDED.password_hash, status = 'ACTIVE';

-- COURSE 1: Nhân Tướng Học Thầy Viên Minh - Khái Niệm Nền Tảng Đến Ứng Dụng [PUBLISHED]
INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, is_featured, created_at, updated_at)
VALUES (1, 'Nhân Tướng Học Thầy Viên Minh - Khái Niệm Nền Tảng Đến Ứng Dụng',
        (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = 'PHYSIOGNOMY' LIMIT 1),
        'COURSE_CATEGORY',
        'Khóa học Nhân tướng học ứng dụng do Thầy Viên Minh trực tiếp giảng dạy. Hướng dẫn toàn diện phương pháp quan sát diện mạo, cốt cách, thần thái và ngũ quan ứng dụng trong đời sống.',
        0, 'PUBLISHED', 2, 3, true, now() - interval '30 days', now() - interval '2 days');

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (1, 1, 'Chương 1: Cốt cách & Nền tảng Nhân tướng học', 1, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (1, 1, 'Buổi 10.2   Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 10.2   Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/WVPVpNDKUwM', 1, true, now() - interval '30 days', now()),
    (2, 1, 'Buổi 10.1   Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 10.1   Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/gJS-1C78Jy0', 2, true, now() - interval '30 days', now()),
    (3, 1, 'Buổi 9.3   Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 9.3   Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/SMaG-tqSzFM', 3, true, now() - interval '30 days', now()),
    (4, 1, 'Buổi 9.2   Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 9.2   Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/o0JaN_PR02k', 4, true, now() - interval '30 days', now()),
    (5, 1, 'Buổi 9.1   Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 9.1   Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/J_brIB4a2Ac', 5, true, now() - interval '30 days', now()),
    (6, 1, 'Buổi 8.2  Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 8.2  Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/ELfzK_P9itU', 6, true, now() - interval '30 days', now()),
    (7, 1, 'Buổi 8.1   Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 8.1   Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/PH6wuaVaPas', 7, true, now() - interval '30 days', now()),
    (8, 1, 'Buổi 7.2 Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 7.2 Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/OlpMbs2O7a4', 8, true, now() - interval '30 days', now()),
    (9, 1, 'Buổi 7.1   Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 7.1   Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/HTWpazK7cfg', 9, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (2, 1, 'Chương 2: Luận giải Ngũ quan & Thần khí Ứng dụng', 2, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (10, 2, 'Buổi 6   Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 6   Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/d7PrIAR795I', 1, true, now() - interval '30 days', now()),
    (11, 2, 'Buổi 5 Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 5 Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/UEPVm5rgD9k', 2, true, now() - interval '30 days', now()),
    (12, 2, 'Buổi 4.2   Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 4.2   Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/ivk5mxi8se8', 3, true, now() - interval '30 days', now()),
    (13, 2, 'Buổi 4.1 Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 4.1 Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/2unyEyuhXAY', 4, true, now() - interval '30 days', now()),
    (14, 2, 'Buổi 4.3   Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 4.3   Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/-brBeGzy1n4', 5, true, now() - interval '30 days', now()),
    (15, 2, 'Buổi 3 Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 3 Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/9zTEtiStPPo', 6, true, now() - interval '30 days', now()),
    (16, 2, 'Buổi 2  Nhân tướng học thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 2  Nhân tướng học thầy Viên Minh</p>', 'https://www.youtube.com/embed/SzutjAxwzmY', 7, true, now() - interval '30 days', now()),
    (17, 2, 'Buổi 1  Nhân tướng học  thầy Viên Minh', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Buổi 1  Nhân tướng học  thầy Viên Minh</p>', 'https://www.youtube.com/embed/eSJJffB1tbQ', 8, true, now() - interval '30 days', now());

-- COURSE 2: Python Ultimate Course - Từ Cơ Bản Đến Nâng Cao [PUBLISHED]
INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, is_featured, created_at, updated_at)
VALUES (2, 'Python Ultimate Course - Từ Cơ Bản Đến Nâng Cao',
        (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = 'PROGRAMMING' LIMIT 1),
        'COURSE_CATEGORY',
        'Khóa học Python trực quan số 1 từ cơ bản đến nâng cao. Giảng dạy chi tiết cú pháp, biến, kiểu dữ liệu, cấu trúc điều khiển, vòng lặp, hàm và tư duy thuật toán bằng Python.',
        0, 'PUBLISHED', 2, 3, true, now() - interval '30 days', now() - interval '2 days');

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (3, 2, 'Chương 1: Nhập môn & Cài đặt môi trường Python', 1, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (18, 3, 'Python Full Course for Beginners (13 Hours) – From Zero to Hero', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Full Course for Beginners (13 Hours) – From Zero to Hero</p>', 'https://www.youtube.com/embed/Rq5gJVxz55Q', 1, true, now() - interval '30 days', now()),
    (19, 3, 'What is Python (Visually Explained) | How It Works and How to Learn It | #Python Course 1', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: What is Python (Visually Explained) | How It Works and How to Learn It | #Python Course 1</p>', 'https://www.youtube.com/embed/GRNI9T9R8gQ', 2, true, now() - interval '30 days', now()),
    (20, 3, 'How to Install Python and VS Code + BONUS Roadmap! (Step-by-Step) | #Python Course 2', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: How to Install Python and VS Code + BONUS Roadmap! (Step-by-Step) | #Python Course 2</p>', 'https://www.youtube.com/embed/uge4A1LHsNk', 3, true, now() - interval '30 days', now()),
    (21, 3, 'Python Comments: Visually Explained | #Python Course 3', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Comments: Visually Explained | #Python Course 3</p>', 'https://www.youtube.com/embed/GEOnKhm940k', 4, true, now() - interval '30 days', now()),
    (22, 3, 'Python Print Function: Visually Explained | #Python Course 4', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Print Function: Visually Explained | #Python Course 4</p>', 'https://www.youtube.com/embed/IdXTxbBfDbc', 5, true, now() - interval '30 days', now()),
    (23, 3, 'Python Variables: Visually Explained | #Python Course 5', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Variables: Visually Explained | #Python Course 5</p>', 'https://www.youtube.com/embed/YHgkADDCWJg', 6, true, now() - interval '30 days', now()),
    (24, 3, 'Python Input Function: Visually Explained | #Python Course 6', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Input Function: Visually Explained | #Python Course 6</p>', 'https://www.youtube.com/embed/we54H-T1AL0', 7, true, now() - interval '30 days', now()),
    (25, 3, 'Python Data Types: Visually Explained | #Python Course 7', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Data Types: Visually Explained | #Python Course 7</p>', 'https://www.youtube.com/embed/0uY2qNAsAWs', 8, true, now() - interval '30 days', now()),
    (26, 3, 'Python String Functions Explained | Text Manipulation & Cleaning | #Python Course 8', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python String Functions Explained | Text Manipulation & Cleaning | #Python Course 8</p>', 'https://www.youtube.com/embed/Yveo5hCrGLE', 9, true, now() - interval '30 days', now()),
    (27, 3, 'Python Numbers Mastery | Math Functions, Round & Random | #Python Course 9', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Numbers Mastery | Math Functions, Round & Random | #Python Course 9</p>', 'https://www.youtube.com/embed/5ZOxqAGWy70', 10, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (4, 2, 'Chương 2: Biến, Kiểu dữ liệu & Chuỗi ký tự', 2, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (28, 4, 'Python Control Flow: Visually Explained | #Python Course 10', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Control Flow: Visually Explained | #Python Course 10</p>', 'https://www.youtube.com/embed/9XbeXpKMR_E', 1, true, now() - interval '30 days', now()),
    (29, 4, 'Python Boolean Functions | bool, all, any, isinstance | #Python Course 11', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Boolean Functions | bool, all, any, isinstance | #Python Course 11</p>', 'https://www.youtube.com/embed/v8tuWg_rvjE', 2, true, now() - interval '30 days', now()),
    (30, 4, 'Python Comparison Operators (Visually Explained) | #Python Course 12', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Comparison Operators (Visually Explained) | #Python Course 12</p>', 'https://www.youtube.com/embed/OZ7AinsDYVo', 3, true, now() - interval '30 days', now()),
    (31, 4, 'Python Logical Operators (Visually Explained) | and, or, not, Execution Order | #Python Course 13', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Logical Operators (Visually Explained) | and, or, not, Execution Order | #Python Course 13</p>', 'https://www.youtube.com/embed/yFaYylK1yCE', 4, true, now() - interval '30 days', now()),
    (32, 4, 'Python Membership & Identity Operators (Visually Explained) | IN & IS | #Python Course 14', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Membership & Identity Operators (Visually Explained) | IN & IS | #Python Course 14</p>', 'https://www.youtube.com/embed/qtTs03rI7W0', 5, true, now() - interval '30 days', now()),
    (33, 4, 'Python If Elif Else Statements (Visually Explained) | #Python Course 15', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python If Elif Else Statements (Visually Explained) | #Python Course 15</p>', 'https://www.youtube.com/embed/7s-zyoaaBOY', 6, true, now() - interval '30 days', now()),
    (34, 4, 'Python If-Else One Line and Match-Case (Visually Explained) | #Python Course 16', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python If-Else One Line and Match-Case (Visually Explained) | #Python Course 16</p>', 'https://www.youtube.com/embed/wP18POH-uM0', 7, true, now() - interval '30 days', now()),
    (35, 4, 'Python For Loops (Visually Explained) | #Python Course 17', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python For Loops (Visually Explained) | #Python Course 17</p>', 'https://www.youtube.com/embed/HWaQttu8_O0', 8, true, now() - interval '30 days', now()),
    (36, 4, 'Python Break vs Continue vs Pass (Visually Explained) | Control Statements | #Python Course 18', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Break vs Continue vs Pass (Visually Explained) | Control Statements | #Python Course 18</p>', 'https://www.youtube.com/embed/fx8MJxW8wb4', 9, true, now() - interval '30 days', now()),
    (37, 4, 'Python For-Else Loop (Visually Explained) | Hidden Control Flow Trick | #Python Course 19', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python For-Else Loop (Visually Explained) | Hidden Control Flow Trick | #Python Course 19</p>', 'https://www.youtube.com/embed/KlVXZu8V1VM', 10, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (5, 2, 'Chương 3: Cấu trúc điều khiển & Vòng lặp For / While', 3, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (38, 5, 'Python Nested Loops are Easy | A Must-Have Skill for Data Engineers | #Python Course 20', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Nested Loops are Easy | A Must-Have Skill for Data Engineers | #Python Course 20</p>', 'https://www.youtube.com/embed/ck1AzCDs0ss', 1, true, now() - interval '30 days', now()),
    (39, 5, 'Python While Loops (Visually Explained) | For vs While Loops | #Python Course 21', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python While Loops (Visually Explained) | For vs While Loops | #Python Course 21</p>', 'https://www.youtube.com/embed/gD8ePxAhjUM', 2, true, now() - interval '30 days', now()),
    (40, 5, 'Introduction to Data Structures in Python (Visually Explained) | #Python Course 22', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Introduction to Data Structures in Python (Visually Explained) | #Python Course 22</p>', 'https://www.youtube.com/embed/SVjXp22ddFQ', 3, true, now() - interval '30 days', now()),
    (41, 5, 'How to Create a List in Python (Visually Explained) | #Python Course 23', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: How to Create a List in Python (Visually Explained) | #Python Course 23</p>', 'https://www.youtube.com/embed/LWeS6R9IPf4', 4, true, now() - interval '30 days', now()),
    (42, 5, 'How to Access Lists in Python (Indexing & Slicing Explained) | #Python Course 24', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: How to Access Lists in Python (Indexing & Slicing Explained) | #Python Course 24</p>', 'https://www.youtube.com/embed/oPZ5xoKZ6Og', 5, true, now() - interval '30 days', now()),
    (43, 5, 'Python Unpacking (Visually Explained) | Asterisk * and Underscore _ | #Python Course 25', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Unpacking (Visually Explained) | Asterisk * and Underscore _ | #Python Course 25</p>', 'https://www.youtube.com/embed/mSUBfY-Geuc', 6, true, now() - interval '30 days', now()),
    (44, 5, 'How to Explore & Analyze Lists in Python | #Python Course 26', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: How to Explore & Analyze Lists in Python | #Python Course 26</p>', 'https://www.youtube.com/embed/zVt7oaBUsHk', 7, true, now() - interval '30 days', now()),
    (45, 5, 'How to Add, Remove, and Update Lists in Python (Visually Explained) | #Python Course 27', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: How to Add, Remove, and Update Lists in Python (Visually Explained) | #Python Course 27</p>', 'https://www.youtube.com/embed/qtANRuRxiEo', 8, true, now() - interval '30 days', now()),
    (46, 5, 'How to Order Lists in Python (Visually Explained) | sort(), sorted(), reverse() | #Python Course 28', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: How to Order Lists in Python (Visually Explained) | sort(), sorted(), reverse() | #Python Course 28</p>', 'https://www.youtube.com/embed/BUsmwsk8Des', 9, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (6, 2, 'Chương 4: Hàm, Module & Cấu trúc dữ liệu nâng cao', 4, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (47, 6, 'How to Copy Python Lists Safely (Visually Explained) | Shallow Copy vs Deepcopy | #Python Course 29', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: How to Copy Python Lists Safely (Visually Explained) | Shallow Copy vs Deepcopy | #Python Course 29</p>', 'https://www.youtube.com/embed/zBEwm_IBVxI', 1, true, now() - interval '30 days', now()),
    (48, 6, 'How to Combine Lists in Python | 4 Simple Ways and ZIP Visually Explained | #Python Course 30', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: How to Combine Lists in Python | 4 Simple Ways and ZIP Visually Explained | #Python Course 30</p>', 'https://www.youtube.com/embed/9BZu1jgs2Dk', 2, true, now() - interval '30 days', now()),
    (49, 6, 'Python Iterator vs Iterable (Visually Explained) | enumerate, map, filter | #Python Course 31', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Iterator vs Iterable (Visually Explained) | enumerate, map, filter | #Python Course 31</p>', 'https://www.youtube.com/embed/hgQD2znCc_I', 3, true, now() - interval '30 days', now()),
    (50, 6, 'Python Lambda Functions (Visually Explained) | #Python Course 32', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Lambda Functions (Visually Explained) | #Python Course 32</p>', 'https://www.youtube.com/embed/LmTOAMpNYFA', 4, true, now() - interval '30 days', now()),
    (51, 6, 'Python List Comprehension (Visually Explained) | The Cleanest Way to Code | #Python Course 33', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python List Comprehension (Visually Explained) | The Cleanest Way to Code | #Python Course 33</p>', 'https://www.youtube.com/embed/6bHDQtVfsCM', 5, true, now() - interval '30 days', now()),
    (52, 6, '30 Python List Operations in 5 Minutes | #Python Course 34', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 30 Python List Operations in 5 Minutes | #Python Course 34</p>', 'https://www.youtube.com/embed/c3FRTlncSWM', 6, true, now() - interval '30 days', now()),
    (53, 6, 'Python Tuples (Visually Explained) | #Python Course 35', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Tuples (Visually Explained) | #Python Course 35</p>', 'https://www.youtube.com/embed/TTkifjHCPWo', 7, true, now() - interval '30 days', now()),
    (54, 6, 'Python Sets (Visually Explained) | #Python Course 36', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Sets (Visually Explained) | #Python Course 36</p>', 'https://www.youtube.com/embed/D5R9Iq3KaPI', 8, true, now() - interval '30 days', now()),
    (55, 6, 'Python Dictionaries (Visually Explained) | #Python Course 37', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Dictionaries (Visually Explained) | #Python Course 37</p>', 'https://www.youtube.com/embed/rpsYzPv1HiQ', 9, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (7, 2, 'Chương 5: Lập trình hướng đối tượng & Xử lý lỗi', 5, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (56, 7, 'Python Data Structures: When to Use List, Tuple, Set, Dict | #Python Course 38', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Data Structures: When to Use List, Tuple, Set, Dict | #Python Course 38</p>', 'https://www.youtube.com/embed/h-zcj4DmqHk', 1, true, now() - interval '30 days', now()),
    (57, 7, 'Python Functions Made Simple (Visual Explanation) | #Python Course 39', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Functions Made Simple (Visual Explanation) | #Python Course 39</p>', 'https://www.youtube.com/embed/FSYoWPXfJxc', 2, true, now() - interval '30 days', now()),
    (58, 7, 'Python Parameters vs Arguments (Explained Visually) | #Python Course 40', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Parameters vs Arguments (Explained Visually) | #Python Course 40</p>', 'https://www.youtube.com/embed/ysoVpKxefzM', 3, true, now() - interval '30 days', now()),
    (59, 7, 'Python Parameters vs Global vs Local Variables (Visual Explanation) | #Python Course 41', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Parameters vs Global vs Local Variables (Visual Explanation) | #Python Course 41</p>', 'https://www.youtube.com/embed/3TxcPKu9ec4', 4, true, now() - interval '30 days', now()),
    (60, 7, 'Python Positional vs Keyword Arguments Explained | Default Parameters | #Python Course 42', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Positional vs Keyword Arguments Explained | Default Parameters | #Python Course 42</p>', 'https://www.youtube.com/embed/fuqCGh06hRw', 5, true, now() - interval '30 days', now()),
    (61, 7, 'Python *Args and **Kwargs Finally Make Sense | #Python Course 43', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python *Args and **Kwargs Finally Make Sense | #Python Course 43</p>', 'https://www.youtube.com/embed/A9j2V2SPq3g', 6, true, now() - interval '30 days', now()),
    (62, 7, 'Python Return Vs Print() (Visual Explanation) | #Python Course 44', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Return Vs Print() (Visual Explanation) | #Python Course 44</p>', 'https://www.youtube.com/embed/DZ2yBGzvlXk', 7, true, now() - interval '30 days', now()),
    (63, 7, 'Python Functions Types You Must Know (Action, Transform, Validate, Orchestrate) | #Python Course 45', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Python Functions Types You Must Know (Action, Transform, Validate, Orchestrate) | #Python Course 45</p>', 'https://www.youtube.com/embed/aXjwdOaPrMg', 8, true, now() - interval '30 days', now()),
    (64, 7, '8 Python Function Habits That Make Your Code Clean and Professional | #Python Course 46', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 8 Python Function Habits That Make Your Code Clean and Professional | #Python Course 46</p>', 'https://www.youtube.com/embed/QipWozUPnOU', 9, true, now() - interval '30 days', now());

-- COURSE 3: Bí Mật Tính Cách & Chiêm Tinh 12 Cung Hoàng Đạo [DRAFT]
INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, moderation_note, is_featured, created_at, updated_at)
VALUES (3, 'Bí Mật Tính Cách & Chiêm Tinh 12 Cung Hoàng Đạo',
        (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = 'ASTROLOGY' LIMIT 1),
        'COURSE_CATEGORY',
        'Khám phá thế giới chiêm tinh học phương Tây qua 12 chòm sao hoàng đạo: tính cách cốt lõi, điểm mạnh yếu, xu hướng tình cảm và con đường sự nghiệp.',
        0, 'DRAFT', 2, 3, 'Khóa học chưa đạt yêu cầu kiểm duyệt: Chương 1 còn thiếu bài tập trắc nghiệm và mô tả chi tiết của từng cung. Đề nghị Chuyên gia bổ sung trước khi gửi duyệt lại.', false, now() - interval '30 days', now() - interval '2 days');

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (8, 3, 'Chương 1: Các Cung Hoàng Đạo Tiên Phong (Lửa & Đất)', 1, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (65, 8, '12 CUNG HOÀNG ĐẠO| Tập 1: BẠCH DƯƠNG - NGỌN LỬA KHỞI ĐẦU', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO| Tập 1: BẠCH DƯƠNG - NGỌN LỬA KHỞI ĐẦU</p>', 'https://www.youtube.com/embed/1dDFRWSOIcY', 1, true, now() - interval '30 days', now()),
    (66, 8, '12 CUNG HOÀNG ĐẠO|Tập 2: KIM NGƯU - NGƯỜI ĐÀN BÀ ĐẦU TIÊN CỦA NHÂN LOẠI', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO|Tập 2: KIM NGƯU - NGƯỜI ĐÀN BÀ ĐẦU TIÊN CỦA NHÂN LOẠI</p>', 'https://www.youtube.com/embed/mo55W-lQaRY', 2, true, now() - interval '30 days', now()),
    (67, 8, '12 CUNG HOÀNG ĐẠO | Tập 3: SONG TỬ - NHÂN VẬT SONG TÍNH ĐẦU TIÊN', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO | Tập 3: SONG TỬ - NHÂN VẬT SONG TÍNH ĐẦU TIÊN</p>', 'https://www.youtube.com/embed/1P8kaxBqjrs', 3, true, now() - interval '30 days', now()),
    (68, 8, '12 CUNG HOÀNG ĐẠO| Tập 4: CỰ GIẢI - NGƯỜI MẸ CỦA THIÊN HẠ', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO| Tập 4: CỰ GIẢI - NGƯỜI MẸ CỦA THIÊN HẠ</p>', 'https://www.youtube.com/embed/1_Og3WmLhWw', 4, true, now() - interval '30 days', now()),
    (69, 8, '12 CUNG HOÀNG ĐẠO | Tập 5: SƯ TỬ - VỊ VUA CỦA CHÍNH MÌNH', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO | Tập 5: SƯ TỬ - VỊ VUA CỦA CHÍNH MÌNH</p>', 'https://www.youtube.com/embed/113_2SGcoOg', 5, true, now() - interval '30 days', now()),
    (70, 8, '12 CUNG HOÀNG ĐẠO | Tập 6: XỬ NỮ - CON SEN CỦA THIÊN HẠ', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO | Tập 6: XỬ NỮ - CON SEN CỦA THIÊN HẠ</p>', 'https://www.youtube.com/embed/ErgoIxsJB5A', 6, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (9, 3, 'Chương 2: Các Cung Hoàng Đạo Kiên Định & Biến Đổi (Khí & Nước)', 2, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (71, 9, '12 CUNG HOÀNG ĐẠO| Tập 7: THIÊN BÌNH - NƠI MẶT TRỜI CHẾT', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO| Tập 7: THIÊN BÌNH - NƠI MẶT TRỜI CHẾT</p>', 'https://www.youtube.com/embed/dIQpDPxhmVw', 1, true, now() - interval '30 days', now()),
    (72, 9, '12 CUNG HOÀNG ĐẠO | Tập 8: BỌ CẠP - ĐAU KHỔ & TÁI SINH', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO | Tập 8: BỌ CẠP - ĐAU KHỔ & TÁI SINH</p>', 'https://www.youtube.com/embed/BwCDsnJUgBI', 2, true, now() - interval '30 days', now()),
    (73, 9, '12 CUNG HOÀNG ĐẠO| Tập 9: NHÂN MÃ - KẺ NẮM GIỮ VẬN MAY', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO| Tập 9: NHÂN MÃ - KẺ NẮM GIỮ VẬN MAY</p>', 'https://www.youtube.com/embed/MvO4iUnAC2A', 3, true, now() - interval '30 days', now()),
    (74, 9, '12 CUNG HOÀNG ĐẠO| Tập 10: MA KẾT - TRẦM CẢM & NỖ LỰC', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO| Tập 10: MA KẾT - TRẦM CẢM & NỖ LỰC</p>', 'https://www.youtube.com/embed/X5G7uuNaSF0', 4, true, now() - interval '30 days', now()),
    (75, 9, '12 CUNG HOÀNG ĐẠO | Tập 11: BẢO BÌNH - KẺ THỰC TẾ DỊ BIỆT', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO | Tập 11: BẢO BÌNH - KẺ THỰC TẾ DỊ BIỆT</p>', 'https://www.youtube.com/embed/4e8wxkzFkhc', 5, true, now() - interval '30 days', now()),
    (76, 9, '12 CUNG HOÀNG ĐẠO | Tập 12: SONG NGƯ - NAI VÀNG DẪM NÁT RỪNG GIÀ', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: 12 CUNG HOÀNG ĐẠO | Tập 12: SONG NGƯ - NAI VÀNG DẪM NÁT RỪNG GIÀ</p>', 'https://www.youtube.com/embed/U6-71pI3jy4', 6, true, now() - interval '30 days', now());

-- COURSE 4: Lộ Trình Java Spring Boot 3 Cho Người Mới Bắt Đầu [PENDING_REVIEW]
INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, is_featured, created_at, updated_at)
VALUES (4, 'Lộ Trình Java Spring Boot 3 Cho Người Mới Bắt Đầu',
        (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = 'PROGRAMMING' LIMIT 1),
        'COURSE_CATEGORY',
        'Lộ trình lập trình backend Java Spring Boot 3 bài bản nhất: Dependency Injection, Spring Data JPA, Hibernate, RESTful API và Spring Security 6.',
        199000, 'PENDING_REVIEW', 2, 3, false, now() - interval '30 days', now() - interval '2 days');

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (10, 4, 'Chương 1: Nền tảng Java Core & Cài đặt Spring Boot 3', 1, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (77, 10, 'Lộ trình Java Spring boot 3 năm 2024 hiệu quả nhất', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Lộ trình Java Spring boot 3 năm 2024 hiệu quả nhất</p>', 'https://www.youtube.com/embed/H2gquNz1bvs', 1, true, now() - interval '30 days', now()),
    (78, 10, 'Khóa học Java spring boot 3: #1 Hello world', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #1 Hello world</p>', 'https://www.youtube.com/embed/MiHVcukru3U', 2, true, now() - interval '30 days', now()),
    (79, 10, 'Hướng dẫn cài đặt Docker và MySQL trên Docker', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Hướng dẫn cài đặt Docker và MySQL trên Docker</p>', 'https://www.youtube.com/embed/Oa7bpIZ6RxI', 3, true, now() - interval '30 days', now()),
    (80, 10, 'Khóa học Java spring boot 3: #2 Kết nối Database với Spring JPA và tạo API CRUD', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #2 Kết nối Database với Spring JPA và tạo API CRUD</p>', 'https://www.youtube.com/embed/O-3tJAVlwQE', 4, true, now() - interval '30 days', now()),
    (81, 10, 'Khóa học Java spring boot 3: #3 Quản lý Exception tập trung và Validation', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #3 Quản lý Exception tập trung và Validation</p>', 'https://www.youtube.com/embed/dN4Ifu-4PAs', 5, true, now() - interval '30 days', now()),
    (82, 10, 'Khóa học Java spring boot 3: #4 Quản lý Exception nâng cao và cách chuẩn hóa API Response đúng cách', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #4 Quản lý Exception nâng cao và cách chuẩn hóa API Response đúng cách</p>', 'https://www.youtube.com/embed/a9wMrj-JHV4', 6, true, now() - interval '30 days', now()),
    (83, 10, 'Khóa học Java spring boot 3: #5 Sử dụng Lombok và Mapstruct, coding đơn giản vui vẻ hơn', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #5 Sử dụng Lombok và Mapstruct, coding đơn giản vui vẻ hơn</p>', 'https://www.youtube.com/embed/3AIjB50cRzU', 7, true, now() - interval '30 days', now()),
    (84, 10, 'Khóa học Java spring boot 3: #6 Mã hóa mật khẩu an toàn và matching nhanh chóng với Bcrypt', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #6 Mã hóa mật khẩu an toàn và matching nhanh chóng với Bcrypt</p>', 'https://www.youtube.com/embed/i519oXXPtgQ', 8, true, now() - interval '30 days', now()),
    (85, 10, 'Khóa học Java spring boot 3: #7 JWT là gì, cách tạo, ký và xác thực một JWT', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #7 JWT là gì, cách tạo, ký và xác thực một JWT</p>', 'https://www.youtube.com/embed/1XC5WPQkXek', 9, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (11, 4, 'Chương 2: Spring Data JPA, Hibernate & CSDL Quan hệ', 2, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (86, 11, 'Khóa học Java spring boot 3: #8 Kiến trúc Spring Security, cấu hình Authentication với JWT', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #8 Kiến trúc Spring Security, cấu hình Authentication với JWT</p>', 'https://www.youtube.com/embed/lp0XVdrOibk', 1, true, now() - interval '30 days', now()),
    (87, 11, 'Khóa học Java spring boot 3: #9 Phân quyền (Authorization) bằng JWT trong Spring Security', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #9 Phân quyền (Authorization) bằng JWT trong Spring Security</p>', 'https://www.youtube.com/embed/eu3vJZ9W0XQ', 2, true, now() - interval '30 days', now()),
    (88, 11, 'Khóa học Java spring boot 3: #10 Phân quyền (Authorization) với PreAuthorize và PostAuthorize', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #10 Phân quyền (Authorization) với PreAuthorize và PostAuthorize</p>', 'https://www.youtube.com/embed/1V7U1XQ-eSw', 3, true, now() - interval '30 days', now()),
    (89, 11, 'Khóa học Java spring boot 3: #11 Quản lý Exception và trả về Response với HttpCode tùy biến', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #11 Quản lý Exception và trả về Response với HttpCode tùy biến</p>', 'https://www.youtube.com/embed/RkUPQZ_BgJ4', 4, true, now() - interval '30 days', now()),
    (90, 11, 'Khóa học Java spring boot 3: #12 Phân quyền theo Role, Permission, quan hệ ManyToMany trong JPA', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #12 Phân quyền theo Role, Permission, quan hệ ManyToMany trong JPA</p>', 'https://www.youtube.com/embed/GZpO045VNe8', 5, true, now() - interval '30 days', now()),
    (91, 11, 'Khóa học Java spring boot 3: #13 Phân quyền với Role, permission bằng JWT sử dụng @PreAuthorize', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #13 Phân quyền với Role, permission bằng JWT sử dụng @PreAuthorize</p>', 'https://www.youtube.com/embed/vtnUYg5xYu4', 6, true, now() - interval '30 days', now()),
    (92, 11, 'Khóa học Java spring boot 3: #14 Validation bằng custom annotation', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #14 Validation bằng custom annotation</p>', 'https://www.youtube.com/embed/41KffsyxzIg', 7, true, now() - interval '30 days', now()),
    (93, 11, 'Khóa học Java spring boot 3: #15 Validation nâng cao, trích xuất thông tin từ annotation', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #15 Validation nâng cao, trích xuất thông tin từ annotation</p>', 'https://www.youtube.com/embed/n_4EzfSH6z0', 8, true, now() - interval '30 days', now()),
    (94, 11, 'Khóa học Java spring boot 3: #16 logout với JWT token một cách an toàn và đảm bảo hiệu năng', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #16 logout với JWT token một cách an toàn và đảm bảo hiệu năng</p>', 'https://www.youtube.com/embed/ZiHsIJtUtF0', 9, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (12, 4, 'Chương 3: Xây dựng RESTful API & Service Layer', 3, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (95, 12, 'Khóa học Java spring boot 3: #17 refresh JWT token', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #17 refresh JWT token</p>', 'https://www.youtube.com/embed/TYdcc_N4wj4', 1, true, now() - interval '30 days', now()),
    (96, 12, 'Khóa học Java spring boot 3: #18 refresh JWT token (phần 2) align với Oauth2', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #18 refresh JWT token (phần 2) align với Oauth2</p>', 'https://www.youtube.com/embed/iiSNzltukpk', 2, true, now() - interval '30 days', now()),
    (97, 12, 'Khóa học Java spring boot 3: #19 làm quen với UnitTest', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #19 làm quen với UnitTest</p>', 'https://www.youtube.com/embed/8Bs9_PiOQ9o', 3, true, now() - interval '30 days', now()),
    (98, 12, 'Khóa học Java spring boot 3: #20 Isolation trong UnitTest, best practice trong Unit test', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #20 Isolation trong UnitTest, best practice trong Unit test</p>', 'https://www.youtube.com/embed/6axMMPjSf1c', 4, true, now() - interval '30 days', now()),
    (99, 12, 'Khóa học Java spring boot 3: #21 code coverage với JaCoCo và cách tăng code coverage', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #21 code coverage với JaCoCo và cách tăng code coverage</p>', 'https://www.youtube.com/embed/2PavtAVGYhY', 5, true, now() - interval '30 days', now()),
    (100, 12, 'Integration test trong Spring boot 3 với TestContainers', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Integration test trong Spring boot 3 với TestContainers</p>', 'https://www.youtube.com/embed/l_YtIt8b7fE', 6, true, now() - interval '30 days', now()),
    (101, 12, 'Khóa học Java spring boot 3: #22 chuẩn hóa format code với spotless - đã code là phải đẹp', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #22 chuẩn hóa format code với spotless - đã code là phải đẹp</p>', 'https://www.youtube.com/embed/ocrNYYUsb1M', 7, true, now() - interval '30 days', now()),
    (102, 12, 'Khóa học Java spring boot 3: #23 code ngày càng chuyên nghiệp hơn với SonarLint và SonarQube', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #23 code ngày càng chuyên nghiệp hơn với SonarLint và SonarQube</p>', 'https://www.youtube.com/embed/2q3BNSenmsQ', 8, true, now() - interval '30 days', now()),
    (103, 12, 'Khóa học Java spring boot 3: #24 cấu hình CORS và integrate với Front End bằng React JS', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #24 cấu hình CORS và integrate với Front End bằng React JS</p>', 'https://www.youtube.com/embed/p0qAzNmBxeA', 9, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (13, 4, 'Chương 4: Bảo mật với Spring Security & Triển khai thực chiến', 4, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (104, 13, 'Khóa học Java spring boot 3: #25 Unique field trong JPA và bài toán concurrent request.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #25 Unique field trong JPA và bài toán concurrent request.</p>', 'https://www.youtube.com/embed/VPDaC2JtmeM', 1, true, now() - interval '30 days', now()),
    (105, 13, 'Khóa học Java spring boot 3: #26 Tìm hiểu về Profile và biến môi trường', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #26 Tìm hiểu về Profile và biến môi trường</p>', 'https://www.youtube.com/embed/v2aX-gJACRw', 2, true, now() - interval '30 days', now()),
    (106, 13, 'Khóa học Java spring boot 3: #27 Đóng gói và triển khai ứng dụng', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #27 Đóng gói và triển khai ứng dụng</p>', 'https://www.youtube.com/embed/1QtHHtKF4sM', 3, true, now() - interval '30 days', now()),
    (107, 13, 'Khóa học Java spring boot 3: #28 build Docker image', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #28 build Docker image</p>', 'https://www.youtube.com/embed/EkChqwXzbsU', 4, true, now() - interval '30 days', now()),
    (108, 13, 'Khóa học Java spring boot 3: #29 publish Docker image lên Docker Hub', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #29 publish Docker image lên Docker Hub</p>', 'https://www.youtube.com/embed/j2U6Ea-sZCI', 5, true, now() - interval '30 days', now()),
    (109, 13, 'Hướng dẫn đăng ký tài khoàn Amazon AWS hoàn toàn miễn phí mới nhất 2024', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Hướng dẫn đăng ký tài khoàn Amazon AWS hoàn toàn miễn phí mới nhất 2024</p>', 'https://www.youtube.com/embed/JWOscrg9EZ4', 6, true, now() - interval '30 days', now()),
    (110, 13, 'Hướng dẫn deploy ứng dụng lên EC2 của AWS với Docker hoàn toàn miễn phí mới nhất 2024', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Hướng dẫn deploy ứng dụng lên EC2 của AWS với Docker hoàn toàn miễn phí mới nhất 2024</p>', 'https://www.youtube.com/embed/ZZpB4Lgx1rk', 7, true, now() - interval '30 days', now()),
    (111, 13, 'Khóa học Java spring boot 3: #30 Nâng cấp lên Java 25 và Spring boot 4', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Khóa học Java spring boot 3: #30 Nâng cấp lên Java 25 và Spring boot 4</p>', 'https://www.youtube.com/embed/aIJGAsUm9_I', 8, true, now() - interval '30 days', now());

-- COURSE 5: Học Lập Trình .NET & C# Nền Tảng Đến Chuyên Sâu [PUBLISHED]
INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, is_featured, created_at, updated_at)
VALUES (5, 'Học Lập Trình .NET & C# Nền Tảng Đến Chuyên Sâu',
        (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = 'PROGRAMMING' LIMIT 1),
        'COURSE_CATEGORY',
        'Học lập trình nền tảng .NET và ngôn ngữ C# hiện đại. Tự tay xây dựng ứng dụng console, Web API với ASP.NET Core và Entity Framework Core.',
        299000, 'PUBLISHED', 2, 3, true, now() - interval '30 days', now() - interval '2 days');

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (14, 5, 'Chương 1: Làm quen .NET & Cài đặt Visual Studio', 1, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (112, 14, 'Học lập trình .NET - phần 1 - Cài đặt Visual Studio và viết chương trình .NET đầu tiên', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - phần 1 - Cài đặt Visual Studio và viết chương trình .NET đầu tiên</p>', 'https://www.youtube.com/embed/-GHF0aAvKEI', 1, true, now() - interval '30 days', now()),
    (113, 14, 'Học lập trình .NET - Phần 2 - Các kiểu dữ liệu trong .NET', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 2 - Các kiểu dữ liệu trong .NET</p>', 'https://www.youtube.com/embed/YfPjBME1jus', 2, true, now() - interval '30 days', now()),
    (114, 14, 'Học lập trình .NET - Phần 3 - Array', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 3 - Array</p>', 'https://www.youtube.com/embed/JsJNlJgSHr0', 3, true, now() - interval '30 days', now()),
    (115, 14, 'Học lập trình .NET - Phần 4 - Sử dụng các cấu trúc điều khiển', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 4 - Sử dụng các cấu trúc điều khiển</p>', 'https://www.youtube.com/embed/IhijUc2nA6s', 4, true, now() - interval '30 days', now()),
    (116, 14, 'Học lập trình .NET - Phần 5 - Phương thức', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 5 - Phương thức</p>', 'https://www.youtube.com/embed/Lg7n1nyrQTc', 5, true, now() - interval '30 days', now()),
    (117, 14, 'Học lập trình .NET - Phần 6 - Làm việc với exception', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 6 - Làm việc với exception</p>', 'https://www.youtube.com/embed/hCSSPlX5JJM', 6, true, now() - interval '30 days', now()),
    (118, 14, 'Học lập trình .NET - Phần 7 - Stream và File', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 7 - Stream và File</p>', 'https://www.youtube.com/embed/Rn9KEVEbLyE', 7, true, now() - interval '30 days', now()),
    (119, 14, 'Học lập trình .NET - Phần 8 - Sử dụng Collection trong .NET', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 8 - Sử dụng Collection trong .NET</p>', 'https://www.youtube.com/embed/5bYGm7XZDPw', 8, true, now() - interval '30 days', now()),
    (120, 14, 'Học lập trình .NET - Phần 9 - Biểu thức Lambda', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 9 - Biểu thức Lambda</p>', 'https://www.youtube.com/embed/pL0FSKwJEJI', 9, true, now() - interval '30 days', now()),
    (121, 14, 'Học lập trình .NET - Phần 10 - LINQ', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 10 - LINQ</p>', 'https://www.youtube.com/embed/rZFuA9FmDiU', 10, true, now() - interval '30 days', now()),
    (122, 14, 'Học lập trình .NET - Phần 11 - Lập trình hướng đối tượng trong .NET', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 11 - Lập trình hướng đối tượng trong .NET</p>', 'https://www.youtube.com/embed/oiQIS1sFFi0', 11, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (15, 5, 'Chương 2: Cú pháp ngôn ngữ C# & Kiểu dữ liệu nền tảng', 2, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (123, 15, 'Học lập trình .NET - Phần 12 - Đa hình', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 12 - Đa hình</p>', 'https://www.youtube.com/embed/yhgaUBYNGpw', 1, true, now() - interval '30 days', now()),
    (124, 15, 'Học lập trình .NET - Phần 13 - Sử dụng từ khóa Static', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 13 - Sử dụng từ khóa Static</p>', 'https://www.youtube.com/embed/dEkdt2ACPjs', 2, true, now() - interval '30 days', now()),
    (125, 15, 'Học lập trình .NET - Phần 14 - Interface', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 14 - Interface</p>', 'https://www.youtube.com/embed/t7Qt3Ao6VNU', 3, true, now() - interval '30 days', now()),
    (126, 15, 'Học lập trình .NET - Phần 15 - Giải bài tập, unit test, abstract factory và decorator design pattern', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 15 - Giải bài tập, unit test, abstract factory và decorator design pattern</p>', 'https://www.youtube.com/embed/SJL664hxJ-4', 4, true, now() - interval '30 days', now()),
    (127, 15, 'Học lập trình .NET - Phần 16 - Cài đặt SQL Server', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 16 - Cài đặt SQL Server</p>', 'https://www.youtube.com/embed/l6COMMwHU50', 5, true, now() - interval '30 days', now()),
    (128, 15, 'Học lập trình .NET - Phần 17 - Giới thiệu ADO.NET', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 17 - Giới thiệu ADO.NET</p>', 'https://www.youtube.com/embed/oJOk40gm984', 6, true, now() - interval '30 days', now()),
    (129, 15, 'Học lập trình .NET - Phần 18 - CRUD với ADO.NET', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 18 - CRUD với ADO.NET</p>', 'https://www.youtube.com/embed/YANJFeZSKWw', 7, true, now() - interval '30 days', now()),
    (130, 15, 'Học lập trình .NET - Phần 19 - Giải bài tập: chương trình xuất dữ liệu từ database ra file', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 19 - Giải bài tập: chương trình xuất dữ liệu từ database ra file</p>', 'https://www.youtube.com/embed/momdXqVUGtA', 8, true, now() - interval '30 days', now()),
    (131, 15, 'Học lập trình .NET - Phần 20 - Sử dụng Repository pattern', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 20 - Sử dụng Repository pattern</p>', 'https://www.youtube.com/embed/Z7yZ_CPhTdM', 9, true, now() - interval '30 days', now()),
    (132, 15, 'Học lập trình .NET - Phần 21 - Unit of Work', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 21 - Unit of Work</p>', 'https://www.youtube.com/embed/PAVW4gXDeIA', 10, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (16, 5, 'Chương 3: Lập trình hướng đối tượng OOP với C#', 3, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (133, 16, 'Học lập trình .NET - Phần 22 - Sử dụng các chỉ dẫn tiền biên dịch', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 22 - Sử dụng các chỉ dẫn tiền biên dịch</p>', 'https://www.youtube.com/embed/xfqdMIgCd8k', 1, true, now() - interval '30 days', now()),
    (134, 16, 'Học lập trình .NET - Phần 23 - .NET Generic host', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 23 - .NET Generic host</p>', 'https://www.youtube.com/embed/S1u5j6KJ9q4', 2, true, now() - interval '30 days', now()),
    (135, 16, 'Học lập trình .NET - Phần 24 - Logging', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 24 - Logging</p>', 'https://www.youtube.com/embed/V4c40a4crQM', 3, true, now() - interval '30 days', now()),
    (136, 16, 'Học lập trình .NET - Phần 25 - Attribute', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 25 - Attribute</p>', 'https://www.youtube.com/embed/dHZo6Y2Vnng', 4, true, now() - interval '30 days', now()),
    (137, 16, 'Học lập trình .NET - Phần 26 - Sử dụng Configuration', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 26 - Sử dụng Configuration</p>', 'https://www.youtube.com/embed/iOZWVe_kbFg', 5, true, now() - interval '30 days', now()),
    (138, 16, 'Học lập trình .NET - Phần 27 - Dependency Injection', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 27 - Dependency Injection</p>', 'https://www.youtube.com/embed/mWwKjyVEi1w', 6, true, now() - interval '30 days', now()),
    (139, 16, 'Học lập trình .NET - Phần 28 - Caching (và decorator design pattern)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 28 - Caching (và decorator design pattern)</p>', 'https://www.youtube.com/embed/-q6ze5V1sLA', 7, true, now() - interval '30 days', now()),
    (140, 16, 'Học lập trình .NET - Phần 29 - Reflection', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 29 - Reflection</p>', 'https://www.youtube.com/embed/JQx8E1Y_Bac', 8, true, now() - interval '30 days', now()),
    (141, 16, 'Học lập trình .NET - Phần 30 - Làm quen với Thread', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 30 - Làm quen với Thread</p>', 'https://www.youtube.com/embed/eVXktAmwqf8', 9, true, now() - interval '30 days', now()),
    (142, 16, 'Học lập trình .NET - Phần 31 - Sử dụng EventWaitHandle để đồng bộ hoạt động nhiều thread', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 31 - Sử dụng EventWaitHandle để đồng bộ hoạt động nhiều thread</p>', 'https://www.youtube.com/embed/r5cDd0s1qqY', 10, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (17, 5, 'Chương 4: Xây dựng ứng dụng & Web API với .NET Core', 4, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (143, 17, 'Học lập trình .NET - Phần 32 - Sử dụng Semaphore', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 32 - Sử dụng Semaphore</p>', 'https://www.youtube.com/embed/gh4TrZTJIfA', 1, true, now() - interval '30 days', now()),
    (144, 17, 'Học lập trình .NET - Phần 33 -  Sử dụng lock, Monitor để kiểm soát các critical section', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 33 -  Sử dụng lock, Monitor để kiểm soát các critical section</p>', 'https://www.youtube.com/embed/cOMcUJw1u_Q', 2, true, now() - interval '30 days', now()),
    (145, 17, 'Học lập trình .NET - Phần 34 - Xử lý bất đồng bộ với hàm async', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 34 - Xử lý bất đồng bộ với hàm async</p>', 'https://www.youtube.com/embed/J-V95HRPN_4', 3, true, now() - interval '30 days', now()),
    (146, 17, 'Học lập trình .NET - Phần 35 - Sử dụng lớp Task', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 35 - Sử dụng lớp Task</p>', 'https://www.youtube.com/embed/irjccQZO4DM', 4, true, now() - interval '30 days', now()),
    (147, 17, 'Học lập trình .NET - Phần 36 - Lập trình mạng với Socket', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 36 - Lập trình mạng với Socket</p>', 'https://www.youtube.com/embed/T6XJITMtm88', 5, true, now() - interval '30 days', now()),
    (148, 17, 'Học lập trình .NET - Phần 37 - Giải bài tập viết Web server (phần 1)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 37 - Giải bài tập viết Web server (phần 1)</p>', 'https://www.youtube.com/embed/v2s1FjkWReI', 6, true, now() - interval '30 days', now()),
    (149, 17, 'Học lập trình .NET - Phần 38 - Giải bài tập viết Web server (phần 2)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 38 - Giải bài tập viết Web server (phần 2)</p>', 'https://www.youtube.com/embed/Ns7-MptWchg', 7, true, now() - interval '30 days', now()),
    (150, 17, 'Học lập trình .NET - Phần 39 - Giải bài tập viết Web server (phần 3)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 39 - Giải bài tập viết Web server (phần 3)</p>', 'https://www.youtube.com/embed/QG9F0HUXnDE', 8, true, now() - interval '30 days', now()),
    (151, 17, 'Học lập trình .NET - Phần 40 - Giải bài tập viết Web server (phần 4)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 40 - Giải bài tập viết Web server (phần 4)</p>', 'https://www.youtube.com/embed/mfPNxCk7z_w', 9, true, now() - interval '30 days', now()),
    (152, 17, 'Học lập trình .NET - Phần 41 - Sử dụng thư viện HttpClient', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học lập trình .NET - Phần 41 - Sử dụng thư viện HttpClient</p>', 'https://www.youtube.com/embed/MVozXwLv3QI', 10, true, now() - interval '30 days', now());

-- COURSE 6: Nhập Môn Tự Học Tiếng Trung Từ Con Số 0 [PUBLISHED]
INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, is_featured, created_at, updated_at)
VALUES (6, 'Nhập Môn Tự Học Tiếng Trung Từ Con Số 0',
        (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = 'LANGUAGES' LIMIT 1),
        'COURSE_CATEGORY',
        'Khóa học tiếng Trung sơ cấp chi tiết và dễ hiểu nhất: hệ thống phiên âm Pinyin, 4 thanh điệu, quy tắc viết chữ Hán và các câu giao tiếp căn bản.',
        350000, 'PUBLISHED', 2, 3, true, now() - interval '30 days', now() - interval '2 days');

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (18, 6, 'Chương 1: Hệ thống Phiên âm Pinyin & Bảng chữ cái', 1, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (153, 18, 'Bài 1: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 1: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin</p>', 'https://www.youtube.com/embed/c7a2gpVtRIA', 1, true, now() - interval '30 days', now()),
    (154, 18, 'Bài 2: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 2: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/9A1BJ6WE6t8', 2, true, now() - interval '30 days', now()),
    (155, 18, 'Bài 3: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 3: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/looteQKbrRE', 3, true, now() - interval '30 days', now()),
    (156, 18, 'Bài 4: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 4: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/NFZvpFWui0I', 4, true, now() - interval '30 days', now()),
    (157, 18, 'Bài 5: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 5: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/hTrs6z-uqTE', 5, true, now() - interval '30 days', now()),
    (158, 18, 'Bài 6: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 6: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/VlLCaowh_ZY', 6, true, now() - interval '30 days', now()),
    (159, 18, 'Bài 7: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 7: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/MStuxAb-4YM', 7, true, now() - interval '30 days', now()),
    (160, 18, 'Bài 8: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 8: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/pqjwjRVehA8', 8, true, now() - interval '30 days', now()),
    (161, 18, 'Bài 9: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 9: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/LNCWIogBUag', 9, true, now() - interval '30 days', now()),
    (162, 18, 'Bài 10: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 10: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/gfmE_UVq9LY', 10, true, now() - interval '30 days', now()),
    (163, 18, 'Bài 11: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 11: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/tEblLFrStoY', 11, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (19, 6, 'Chương 2: 4 Thanh điệu & Kỹ thuật phát âm chuẩn', 2, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (164, 19, 'Bài 12: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 12: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/arHeNqEs9Ns', 1, true, now() - interval '30 days', now()),
    (165, 19, 'Bài 13: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 13: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/_UElO59VYL0', 2, true, now() - interval '30 days', now()),
    (166, 19, 'Bài 14: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 14: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/HgwUnPpabc8', 3, true, now() - interval '30 days', now()),
    (167, 19, 'Bài 15: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 15: Nhập Môn Tiếng Trung - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/Lh_HIdo4yDg', 4, true, now() - interval '30 days', now()),
    (168, 19, 'Bài 16: Nhập môn Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 16: Nhập môn Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/PcofZx_KOV0', 5, true, now() - interval '30 days', now()),
    (169, 19, 'Bài 17 Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 17 Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/4wfMFi2kKz0', 6, true, now() - interval '30 days', now()),
    (170, 19, 'Bài 18: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 18: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Yangdexin.</p>', 'https://www.youtube.com/embed/WilS3cXBR1I', 7, true, now() - interval '30 days', now()),
    (171, 19, 'Bài 19: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 19: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Học Tiếng Trung</p>', 'https://www.youtube.com/embed/luOZyp-kTao', 8, true, now() - interval '30 days', now()),
    (172, 19, 'Bài 20: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 20: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Học Tiếng Trung</p>', 'https://www.youtube.com/embed/kE5mYRNVloI', 9, true, now() - interval '30 days', now()),
    (173, 19, 'Bài 21: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 21: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Học Tiếng Trung</p>', 'https://www.youtube.com/embed/TZE3ISI7Wfw', 10, true, now() - interval '30 days', now()),
    (174, 19, 'Bài 22: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 22: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung</p>', 'https://www.youtube.com/embed/U5q-ReH0Q8E', 11, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (20, 6, 'Chương 3: Quy tắc viết các nét cơ bản chữ Hán', 3, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (175, 20, 'Bài 23: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 23: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung</p>', 'https://www.youtube.com/embed/eFaAhasCfoE', 1, true, now() - interval '30 days', now()),
    (176, 20, 'Bài 24: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 24: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung</p>', 'https://www.youtube.com/embed/MFAjevUsLjg', 2, true, now() - interval '30 days', now()),
    (177, 20, 'Bài 25: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 25: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung</p>', 'https://www.youtube.com/embed/RqviLA6ZVfI', 3, true, now() - interval '30 days', now()),
    (178, 20, 'Bài 26: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 26: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung</p>', 'https://www.youtube.com/embed/X0aeMyS2ebg', 4, true, now() - interval '30 days', now()),
    (179, 20, 'Bài 27: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 27: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung</p>', 'https://www.youtube.com/embed/MQvsAo--itI', 5, true, now() - interval '30 days', now()),
    (180, 20, 'Bài 28: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 28: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung</p>', 'https://www.youtube.com/embed/FVoOoI9ty2g', 6, true, now() - interval '30 days', now()),
    (181, 20, 'Bài 29: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 29: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung</p>', 'https://www.youtube.com/embed/9kcKTSRLouY', 7, true, now() - interval '30 days', now()),
    (182, 20, 'Bài 30: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 30: Quyển 2 Giáo Trình Hán Ngữ - Chi Tiết - Dễ Hiểu - Bắt Đầu Từ Con Số 0 // Tự Học Tiếng Trung</p>', 'https://www.youtube.com/embed/mpcRWUp8C98', 8, true, now() - interval '30 days', now()),
    (183, 20, 'Bài 3 Quyển 3 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 3 Quyển 3 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.</p>', 'https://www.youtube.com/embed/KKSDoZ3i5m8', 9, true, now() - interval '30 days', now()),
    (184, 20, 'Bài 1 Quyển 3 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 1 Quyển 3 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.</p>', 'https://www.youtube.com/embed/sHN0f2TAY0g', 10, true, now() - interval '30 days', now()),
    (185, 20, 'Học Tiếng Trung Qua Bài Diễn Thuyết Của Dịch Dương Thiên Tỉ | Ôn thi HSK cùng Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học Tiếng Trung Qua Bài Diễn Thuyết Của Dịch Dương Thiên Tỉ | Ôn thi HSK cùng Yangdexin.</p>', 'https://www.youtube.com/embed/Ss3KZvxu_Vg', 11, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (21, 6, 'Chương 4: Các bộ thủ chữ Hán thông dụng', 4, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (186, 21, 'Bài 1 Quyển 4 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 1 Quyển 4 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.</p>', 'https://www.youtube.com/embed/4HcxlWnw8pw', 1, true, now() - interval '30 days', now()),
    (187, 21, 'Bài 4 Quyển 4 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 4 Quyển 4 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.</p>', 'https://www.youtube.com/embed/YOFdfYo-jmc', 2, true, now() - interval '30 days', now()),
    (188, 21, 'Bài 6 Quyển 5 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 6 Quyển 5 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.</p>', 'https://www.youtube.com/embed/CN-wZ-6y7k4', 3, true, now() - interval '30 days', now()),
    (189, 21, 'Bài 8 Quyển 5 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 8 Quyển 5 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.</p>', 'https://www.youtube.com/embed/ooKR-0yJvrA', 4, true, now() - interval '30 days', now()),
    (190, 21, 'Bài 14 Quyển 6 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 14 Quyển 6 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.</p>', 'https://www.youtube.com/embed/8QOqlC8jD5Q', 5, true, now() - interval '30 days', now()),
    (191, 21, 'Bài 19 Quyển 6 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bài 19 Quyển 6 Giáo Trình Hán Ngữ 6 Quyển (Demo Video) | Siêu Chi Tiết, Dễ Hiểu // Yangdexin.</p>', 'https://www.youtube.com/embed/hc9HzWjMPoI', 6, true, now() - interval '30 days', now()),
    (192, 21, 'Học Xong 10 Bài Nhập Môn Tiếng Trung Có Thể Nói Những Gì?! ~ Tự Học Tiếng Trung Cùng Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học Xong 10 Bài Nhập Môn Tiếng Trung Có Thể Nói Những Gì?! ~ Tự Học Tiếng Trung Cùng Yangdexin.</p>', 'https://www.youtube.com/embed/irs5RlDw5Bg', 7, true, now() - interval '30 days', now()),
    (193, 21, 'Cùng Yangdexin Chơi Game Ôn Tập Bộ Thủ, Chữ Hán Trong Quyển 1 Hán Ngữ // Tự Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Cùng Yangdexin Chơi Game Ôn Tập Bộ Thủ, Chữ Hán Trong Quyển 1 Hán Ngữ // Tự Học Tiếng Trung</p>', 'https://www.youtube.com/embed/_Ronch-okh4', 8, true, now() - interval '30 days', now()),
    (194, 21, 'Ôn Tập Ngữ Pháp Quyển 1 Hán Ngữ // Lưu Ý Khi Dùng Lượng Từ ~ Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Ôn Tập Ngữ Pháp Quyển 1 Hán Ngữ // Lưu Ý Khi Dùng Lượng Từ ~ Yangdexin.</p>', 'https://www.youtube.com/embed/tbGxD1dmoGE', 9, true, now() - interval '30 days', now()),
    (195, 21, 'Muốn Giỏi Tiếng Trung Phải Học Chắc Phát Âm ~ Video Đầu Tiên Cần Xem // Yangdexin.', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Muốn Giỏi Tiếng Trung Phải Học Chắc Phát Âm ~ Video Đầu Tiên Cần Xem // Yangdexin.</p>', 'https://www.youtube.com/embed/dIUjMv0ktSY', 10, true, now() - interval '30 days', now()),
    (196, 21, 'Ôn tập Phát âm Tiếng Trung cùng Yangdexin // Tự Học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Ôn tập Phát âm Tiếng Trung cùng Yangdexin // Tự Học Tiếng Trung</p>', 'https://www.youtube.com/embed/Z9Ud_qcghBk', 11, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (22, 6, 'Chương 5: Từ vựng & Đàm thoại giao tiếp sơ cấp (Phần 1)', 5, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (197, 22, 'Đọc Bài Khoá cũng phải có phương pháp nha | Tự học Tiếng Trung ~ Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Đọc Bài Khoá cũng phải có phương pháp nha | Tự học Tiếng Trung ~ Yangdexin</p>', 'https://www.youtube.com/embed/D6Y2xS2uLng', 1, true, now() - interval '30 days', now()),
    (198, 22, 'Đôi nét về Tiếng Trung, tâm sự chuyện học Tiếng Trung sẽ có Tương Lai ra sao?! Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Đôi nét về Tiếng Trung, tâm sự chuyện học Tiếng Trung sẽ có Tương Lai ra sao?! Yangdexin</p>', 'https://www.youtube.com/embed/Ie9L1NjYCcg', 2, true, now() - interval '30 days', now()),
    (199, 22, 'Học Tiếng Trung cần chọn Giáo Trình nào cho Chuẩn?! | Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học Tiếng Trung cần chọn Giáo Trình nào cho Chuẩn?! | Yangdexin</p>', 'https://www.youtube.com/embed/B9Y8j5AJjN4', 3, true, now() - interval '30 days', now()),
    (200, 22, 'Tự Học Tiếng Trung nhất định phải xem video này // Thanh 4 trong Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Tự Học Tiếng Trung nhất định phải xem video này // Thanh 4 trong Tiếng Trung</p>', 'https://www.youtube.com/embed/4DQY3Ozrtgw', 4, true, now() - interval '30 days', now()),
    (201, 22, 'Chia sẻ Phương Pháp Học và Ôn thi HSK | Yangdexin x Workshop Xin Vía Trạng Nguyên', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Chia sẻ Phương Pháp Học và Ôn thi HSK | Yangdexin x Workshop Xin Vía Trạng Nguyên</p>', 'https://www.youtube.com/embed/pX792TebfGc', 5, true, now() - interval '30 days', now()),
    (202, 22, 'Kinh nghiệm học chữ hán 9 năm của Yangdexin chia sẻ tới bạn!', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Kinh nghiệm học chữ hán 9 năm của Yangdexin chia sẻ tới bạn!</p>', 'https://www.youtube.com/embed/4NM96PCuzYQ', 6, true, now() - interval '30 days', now()),
    (203, 22, 'Mong video này đến được với những ai đang cần nó! | Luyện khẩu ngữ - luyện nói tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Mong video này đến được với những ai đang cần nó! | Luyện khẩu ngữ - luyện nói tiếng Trung</p>', 'https://www.youtube.com/embed/1XCa_b9f0sE', 7, true, now() - interval '30 days', now()),
    (204, 22, 'Lưu vào danh sách phát', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Lưu vào danh sách phát</p>', 'https://www.youtube.com/embed/MFceGCQcZXg', 8, true, now() - interval '30 days', now()),
    (205, 22, 'Bí quyết phát âm Z C S từ Yangdexin | Tự học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bí quyết phát âm Z C S từ Yangdexin | Tự học Tiếng Trung</p>', 'https://www.youtube.com/embed/v5sAClf7gTk', 9, true, now() - interval '30 days', now()),
    (206, 22, 'Bí quyết phát âm J Q X từ Yangdexin | Tự học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bí quyết phát âm J Q X từ Yangdexin | Tự học Tiếng Trung</p>', 'https://www.youtube.com/embed/GA8KsAX476M', 10, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (23, 6, 'Chương 6: Từ vựng & Đàm thoại giao tiếp sơ cấp (Phần 2)', 6, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (207, 23, 'Bí quyết phát âm Zh Ch Sh R từ Yangdexin | Tự học Tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bí quyết phát âm Zh Ch Sh R từ Yangdexin | Tự học Tiếng Trung</p>', 'https://www.youtube.com/embed/L4BaioI3lAc', 1, true, now() - interval '30 days', now()),
    (208, 23, 'Âm Hán Việt quan trọng đến thế nào trong việc học tiếng Trung!? | Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Âm Hán Việt quan trọng đến thế nào trong việc học tiếng Trung!? | Yangdexin</p>', 'https://www.youtube.com/embed/9gAX8iqEq18', 2, true, now() - interval '30 days', now()),
    (209, 23, 'Học tiếng Trung KHÔNG được bỏ qua THANH NHẸ đâu!!! | Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học tiếng Trung KHÔNG được bỏ qua THANH NHẸ đâu!!! | Yangdexin</p>', 'https://www.youtube.com/embed/S3nn2c3b9OU', 3, true, now() - interval '30 days', now()),
    (210, 23, 'Video Hướng dẫn cách học (Bắt buộc phải xem) | Khoá học Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Video Hướng dẫn cách học (Bắt buộc phải xem) | Khoá học Yangdexin</p>', 'https://www.youtube.com/embed/TFASazw01bw', 4, true, now() - interval '30 days', now()),
    (211, 23, 'Học tiếng Trung xong Bài 1 phải xem video này để PHÁT ÂM ĐÚNG | Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học tiếng Trung xong Bài 1 phải xem video này để PHÁT ÂM ĐÚNG | Yangdexin</p>', 'https://www.youtube.com/embed/RDb12NKX0wk', 5, true, now() - interval '30 days', now()),
    (212, 23, 'Bao giờ học tiếng Trung là muộn? Học xong làm cái gì?! | Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bao giờ học tiếng Trung là muộn? Học xong làm cái gì?! | Yangdexin</p>', 'https://www.youtube.com/embed/n1MOxXRy-6g', 6, true, now() - interval '30 days', now()),
    (213, 23, 'HSK là gì? Học tiếng Trung - Ôn thi HSK sao cho hiệu quả?! | Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: HSK là gì? Học tiếng Trung - Ôn thi HSK sao cho hiệu quả?! | Yangdexin</p>', 'https://www.youtube.com/embed/d4n9jFczfRc', 7, true, now() - interval '30 days', now()),
    (214, 23, 'NHẤT ĐỊNH PHẢI LƯU LẠI ~ Học tiếng Trung Bắt Đầu Từ Con Số 0 // Pre 01 ~ Khoá học Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: NHẤT ĐỊNH PHẢI LƯU LẠI ~ Học tiếng Trung Bắt Đầu Từ Con Số 0 // Pre 01 ~ Khoá học Yangdexin</p>', 'https://www.youtube.com/embed/JLwy7yGjbj4', 8, true, now() - interval '30 days', now()),
    (215, 23, 'Học tiếng Trung Bắt Đầu Từ Con Số 0 (Pre 02) ~ NHẤT ĐỊNH PHẢI LƯU LẠI // Khoá học Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học tiếng Trung Bắt Đầu Từ Con Số 0 (Pre 02) ~ NHẤT ĐỊNH PHẢI LƯU LẠI // Khoá học Yangdexin</p>', 'https://www.youtube.com/embed/FG2Aebh_Ne0', 9, true, now() - interval '30 days', now()),
    (216, 23, 'NHẤT ĐỊNH PHẢI LƯU LẠI // Học tiếng Trung Siêu dễ | Pre 03 ~ Khoá học Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: NHẤT ĐỊNH PHẢI LƯU LẠI // Học tiếng Trung Siêu dễ | Pre 03 ~ Khoá học Yangdexin</p>', 'https://www.youtube.com/embed/phnL7fSFOm4', 10, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (24, 6, 'Chương 7: Ngữ pháp căn bản & Đàm thoại thực tế', 7, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (217, 24, 'Phương pháp LUYỆN NGHE - PHÁT ÂM - PHẢN XẠ với BÀI KHOÁ // Tự học Tiếng Trung ~ Khoá học Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Phương pháp LUYỆN NGHE - PHÁT ÂM - PHẢN XẠ với BÀI KHOÁ // Tự học Tiếng Trung ~ Khoá học Yangdexin</p>', 'https://www.youtube.com/embed/ds0YqxtG4W8', 1, true, now() - interval '30 days', now()),
    (218, 24, 'Tự học tiếng Trung NHẤT ĐỊNH PHẢI XEM!!! Quy tắc & Bí quyết phát âm /yi ya ye wo wa yu yun yuan/', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Tự học tiếng Trung NHẤT ĐỊNH PHẢI XEM!!! Quy tắc & Bí quyết phát âm /yi ya ye wo wa yu yun yuan/</p>', 'https://www.youtube.com/embed/q8nFkcrs3YU', 2, true, now() - interval '30 days', now()),
    (219, 24, 'Bí quyết phát âm tiếng Trung | Âm cuốn lưỡi /r/ | Khoá học tiếng Trung Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Bí quyết phát âm tiếng Trung | Âm cuốn lưỡi /r/ | Khoá học tiếng Trung Yangdexin</p>', 'https://www.youtube.com/embed/_E01Ir_OhpQ', 3, true, now() - interval '30 days', now()),
    (220, 24, 'Demo Bài giảng 01 - Khoá học Yangdexin (mới) theo HSK 3.0 | Tự học tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Demo Bài giảng 01 - Khoá học Yangdexin (mới) theo HSK 3.0 | Tự học tiếng Trung</p>', 'https://www.youtube.com/embed/YQY12bOouRY', 4, true, now() - interval '30 days', now()),
    (221, 24, 'Cách đọc số từ 01 đến 99 trong tiếng Trung | Phân tích chữ Hán chi tiết | Tự học tiếng Trung', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Cách đọc số từ 01 đến 99 trong tiếng Trung | Phân tích chữ Hán chi tiết | Tự học tiếng Trung</p>', 'https://www.youtube.com/embed/oC0yz2aS8Ng', 5, true, now() - interval '30 days', now()),
    (222, 24, 'Tự học tiếng Trung | Phương vị từ và kiến thức nâng cao | Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Tự học tiếng Trung | Phương vị từ và kiến thức nâng cao | Yangdexin</p>', 'https://www.youtube.com/embed/BhXr8mgFseQ', 6, true, now() - interval '30 days', now()),
    (223, 24, 'Học tiếng Trung được gì mà giờ ai cũng đổ xô đi học vậy?', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Học tiếng Trung được gì mà giờ ai cũng đổ xô đi học vậy?</p>', 'https://www.youtube.com/embed/GO_yl_SKLbE', 7, true, now() - interval '30 days', now()),
    (224, 24, 'Chữ Giản thể và chữ Phồn thể là gì?!', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Chữ Giản thể và chữ Phồn thể là gì?!</p>', 'https://www.youtube.com/embed/CBql8KJ-kEo', 8, true, now() - interval '30 days', now()),
    (225, 24, 'KHOÁ HỌC YANGDEXIN theo HSK 3.0 - Một khoá học với vô cùng nhiều tâm huyết từ Yangdexin Team', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: KHOÁ HỌC YANGDEXIN theo HSK 3.0 - Một khoá học với vô cùng nhiều tâm huyết từ Yangdexin Team</p>', 'https://www.youtube.com/embed/H_cjfuRbVYc', 9, true, now() - interval '30 days', now()),
    (226, 24, 'Những lời khuyên chân thành gửi tới những ai đang (hoặc chuẩn bị) học tiếng Trung | Yangdexin', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Những lời khuyên chân thành gửi tới những ai đang (hoặc chuẩn bị) học tiếng Trung | Yangdexin</p>', 'https://www.youtube.com/embed/1VxVYfbaXZE', 10, true, now() - interval '30 days', now());

-- COURSE 7: Tâm Lý Học Đại Cương: Bản Chất Con Người & Hành Vi [PUBLISHED]
INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, is_featured, created_at, updated_at)
VALUES (7, 'Tâm Lý Học Đại Cương: Bản Chất Con Người & Hành Vi',
        (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = 'SOFT_SKILLS' LIMIT 1),
        'COURSE_CATEGORY',
        'Nghiên cứu bản chất hiện tượng tâm lý người, quy luật cảm giác, tri giác, trí nhớ, tư duy, cảm xúc, khí chất và cấu trúc nhân cách.',
        199000, 'PUBLISHED', 2, 3, false, now() - interval '30 days', now() - interval '2 days');

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (25, 7, 'Chương 1: Bản chất hiện tượng tâm lý người & Nhận thức cảm tính', 1, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (227, 25, '[HCMUTE] Tâm lý học nghề nghiệp - Giới thiệu', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học nghề nghiệp - Giới thiệu</p>', 'https://www.youtube.com/embed/xa94dTeB09E', 1, true, now() - interval '30 days', now()),
    (228, 25, '[Tâm lý đại cương] Bản chất tâm lý người (1)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [Tâm lý đại cương] Bản chất tâm lý người (1)</p>', 'https://www.youtube.com/embed/U9bYBKUngbk', 2, true, now() - interval '30 days', now()),
    (229, 25, '[HCMUTE]  Tâm lý học - Bản chất TL người (2)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE]  Tâm lý học - Bản chất TL người (2)</p>', 'https://www.youtube.com/embed/WQFLUjc2JO0', 3, true, now() - interval '30 days', now()),
    (230, 25, '[HCMUTE] TLHĐC Tóm tắt C1', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] TLHĐC Tóm tắt C1</p>', 'https://www.youtube.com/embed/wunLNmHhaDk', 4, true, now() - interval '30 days', now()),
    (231, 25, '[HCMUTE] Tâm lý học - Khái niệm cảm giác và tri giác', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Khái niệm cảm giác và tri giác</p>', 'https://www.youtube.com/embed/0rdpfycU0-0', 5, true, now() - interval '30 days', now()),
    (232, 25, '[HCMUTE] Tâm lý học - Qui luật cảm giác', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Qui luật cảm giác</p>', 'https://www.youtube.com/embed/TZZJStiY7CI', 6, true, now() - interval '30 days', now()),
    (233, 25, '[HCMUTE] Tâm lý học - Qui luật tri giác', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Qui luật tri giác</p>', 'https://www.youtube.com/embed/yvce1NW52EU', 7, true, now() - interval '30 days', now()),
    (234, 25, '[HCMUTE] Tâm lý học - Trí nhớ (1)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Trí nhớ (1)</p>', 'https://www.youtube.com/embed/5Typgs4qVGE', 8, true, now() - interval '30 days', now()),
    (235, 25, '[HCMUTE] Tâm lý học - Trí nhớ (2)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Trí nhớ (2)</p>', 'https://www.youtube.com/embed/FzZrytPguAk', 9, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (26, 7, 'Chương 2: Quá trình nhận thức lý tính, Cảm xúc & Nhân cách', 2, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (236, 26, '[HCMUTE] Tâm lý học - Trí nhớ (3)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Trí nhớ (3)</p>', 'https://www.youtube.com/embed/mUjegUSAmf0', 1, true, now() - interval '30 days', now()),
    (237, 26, '[HCMUTE] Tâm lý học - Tư duy', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Tư duy</p>', 'https://www.youtube.com/embed/KOUEi1nu_u4', 2, true, now() - interval '30 days', now()),
    (238, 26, '[HCMUTE] Tâm lý học - Tưởng tượng', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Tưởng tượng</p>', 'https://www.youtube.com/embed/Vzgo9MlYtLo', 3, true, now() - interval '30 days', now()),
    (239, 26, '[HCMUTE] Tâm lý học - Tình cảm (1)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Tình cảm (1)</p>', 'https://www.youtube.com/embed/dj0TdknvzwY', 4, true, now() - interval '30 days', now()),
    (240, 26, '[HCMUTE] Tâm lý học - Tình cảm (2)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Tình cảm (2)</p>', 'https://www.youtube.com/embed/efyRFD8xmDs', 5, true, now() - interval '30 days', now()),
    (241, 26, '[HCMUTE] Tâm lý học - Khí chất', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Khí chất</p>', 'https://www.youtube.com/embed/SE3KgO_uz0Q', 6, true, now() - interval '30 days', now()),
    (242, 26, '[HCMUTE] Tâm lý học - Xu hướng', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Xu hướng</p>', 'https://www.youtube.com/embed/pn98qT-kIok', 7, true, now() - interval '30 days', now()),
    (243, 26, '[HCMUTE] Tâm lý học - Tính cách', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Tính cách</p>', 'https://www.youtube.com/embed/Bho0fiM68Ks', 8, true, now() - interval '30 days', now()),
    (244, 26, '[HCMUTE] Tâm lý học - Năng lực', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [HCMUTE] Tâm lý học - Năng lực</p>', 'https://www.youtube.com/embed/lVTKs9JuygY', 9, true, now() - interval '30 days', now());

-- COURSE 8: Khóa Học Nhạc Lý Cơ Bản & Thực Hành Guitar [ARCHIVED]
INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, archive_at, archive_notice, is_featured, created_at, updated_at)
VALUES (8, 'Khóa Học Nhạc Lý Cơ Bản & Thực Hành Guitar',
        (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = 'ART_CREATIVE' LIMIT 1),
        'COURSE_CATEGORY',
        'Khóa học nhạc lý bài bản kết hợp thực hành guitar. Khóa học đã lưu trữ nội dung và đóng cổng đăng ký mới. Học viên đã sở hữu được học tập trọn đời.',
        0, 'ARCHIVED', 2, 3, now() - interval '1 month', 'Khóa học đã đóng đăng ký mới. Học viên đã sở hữu có quyền truy cập học tập trọn đời.', false, now() - interval '30 days', now() - interval '2 days');

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (27, 8, 'Chương 1: Khuông nhạc, Khóa nhạc & Nhịp phách', 1, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (245, 27, 'KHÓA HỌC NHẠC LÝ CƠ BẢN  & THỰC HÀNH - Miễn phí (Giới thiệu khóa học)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: KHÓA HỌC NHẠC LÝ CƠ BẢN  & THỰC HÀNH - Miễn phí (Giới thiệu khóa học)</p>', 'https://www.youtube.com/embed/SJmr-UOTs-w', 1, true, now() - interval '30 days', now()),
    (246, 27, 'Giới thiệu sách guitar số hóa - Sách học guitar - 300k', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: Giới thiệu sách guitar số hóa - Sách học guitar - 300k</p>', 'https://www.youtube.com/embed/6Tq6jTOVdaQ', 2, true, now() - interval '30 days', now()),
    (247, 27, 'BÀI 1: KHUÔNG NHẠC & KHÓA NHẠC [Khóa học Nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 1: KHUÔNG NHẠC & KHÓA NHẠC [Khóa học Nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/-hgNPBlysx0', 3, true, now() - interval '30 days', now()),
    (248, 27, 'BÀI 2: NHỊP - PHÁCH - TEMPO [Phần 1] [Khóa học Nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 2: NHỊP - PHÁCH - TEMPO [Phần 1] [Khóa học Nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/2YN7GLzsTtA', 4, true, now() - interval '30 days', now()),
    (249, 27, 'BÀI 2: NHỊP - PHÁCH - TEMPO [Phần 2] [Khóa học Nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 2: NHỊP - PHÁCH - TEMPO [Phần 2] [Khóa học Nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/a0ZhyrOlBSA', 5, true, now() - interval '30 days', now()),
    (250, 27, 'BÀI 3: CAO ĐỘ - TRƯỜNG ĐỘ - CƯỜNG ĐỘ - ÂM SẮC [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 3: CAO ĐỘ - TRƯỜNG ĐỘ - CƯỜNG ĐỘ - ÂM SẮC [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/k624yn1VoK4', 6, true, now() - interval '30 days', now()),
    (251, 27, 'BÀI 4: VỊ TRÍ 7 NỐT NHẠC TRÊN KHUÔNG NHẠC [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 4: VỊ TRÍ 7 NỐT NHẠC TRÊN KHUÔNG NHẠC [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/0fdYodhXH0o', 7, true, now() - interval '30 days', now()),
    (252, 27, 'BÀI 5: NỐT TRÒN - TRẮNG - ĐEN [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 5: NỐT TRÒN - TRẮNG - ĐEN [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/8TM5IkAq7Y4', 8, true, now() - interval '30 days', now()),
    (253, 27, 'VỊ TRÍ CÁC NỐT NHẠC TRÊN GUITAR VÀ KHUÔNG NHẠC (Hướng dẫn Cơ bản)', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: VỊ TRÍ CÁC NỐT NHẠC TRÊN GUITAR VÀ KHUÔNG NHẠC (Hướng dẫn Cơ bản)</p>', 'https://www.youtube.com/embed/RZP3BByAcT8', 9, true, now() - interval '30 days', now()),
    (254, 27, 'THỰC HÀNH BÀI 5 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 5 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/3kuE35rZUVI', 10, true, now() - interval '30 days', now()),
    (255, 27, 'BÀI 6: DẤU CHẤM DÔI & NỐT MÓC ĐƠN [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 6: DẤU CHẤM DÔI & NỐT MÓC ĐƠN [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/SBJnVKZwr3Y', 11, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (28, 8, 'Chương 2: Cao độ, Trường độ & Vị trí nốt trên cần đàn', 2, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (256, 28, 'THỰC HÀNH BÀI 6 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 6 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/QaGHkOE7n-o', 1, true, now() - interval '30 days', now()),
    (257, 28, 'BÀI 7: THỰC HÀNH TIẾT TẤU MÓC ĐƠN [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 7: THỰC HÀNH TIẾT TẤU MÓC ĐƠN [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/6WTM07lk_ro', 2, true, now() - interval '30 days', now()),
    (258, 28, 'THỰC HÀNH BÀI 7 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 7 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/zXomAzNLtAo', 3, true, now() - interval '30 days', now()),
    (259, 28, 'BÀI 8 THỰC HÀNH VIẾT TIẾT TẤU [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 8 THỰC HÀNH VIẾT TIẾT TẤU [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/869Kdykbu48', 4, true, now() - interval '30 days', now()),
    (260, 28, 'BÀI 9: THỰC HÀNH ĐỌC TIẾT TẤU - Phần 1 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 9: THỰC HÀNH ĐỌC TIẾT TẤU - Phần 1 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/OznRTUTWXAY', 5, true, now() - interval '30 days', now()),
    (261, 28, 'BÀI 9: THỰC HÀNH ĐỌC TIẾT TẤU - Phần 2 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 9: THỰC HÀNH ĐỌC TIẾT TẤU - Phần 2 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/zJp5AgHlkg0', 6, true, now() - interval '30 days', now()),
    (262, 28, 'THỰC HÀNH BÀI 9 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 9 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/nZlU80RMmQk', 7, true, now() - interval '30 days', now()),
    (263, 28, 'BÀI 10: CHÙM 4 VÀ NỐT MÓC KÉP [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 10: CHÙM 4 VÀ NỐT MÓC KÉP [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/wR7V6ZthlTk', 8, true, now() - interval '30 days', now()),
    (264, 28, 'THỰC HÀNH BÀI 10 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 10 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/sBshACGcEBc', 9, true, now() - interval '30 days', now()),
    (265, 28, 'BÀI 11 (Phần 1): CÁC DẠNG TIẾT TẤU TỪ CHÙM 4 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 11 (Phần 1): CÁC DẠNG TIẾT TẤU TỪ CHÙM 4 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/I474Eh3DEjY', 10, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (29, 8, 'Chương 3: Đọc tiết tấu, nốt móc đơn & móc kép', 3, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (266, 29, 'THỰC HÀNH BÀI 11 - Phần 1 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 11 - Phần 1 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/PkEMV44BGzY', 1, true, now() - interval '30 days', now()),
    (267, 29, 'BÀI 11 (Phần 2): CÁC DẠNG TIẾT TẤU TỪ CHÙM 4 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 11 (Phần 2): CÁC DẠNG TIẾT TẤU TỪ CHÙM 4 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/oJ8Ag2C5C7U', 2, true, now() - interval '30 days', now()),
    (268, 29, 'THỰC HÀNH BÀI 11 - Phần 2 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 11 - Phần 2 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/P4Ows9NQ7Pg', 3, true, now() - interval '30 days', now()),
    (269, 29, 'BÀI 12: LIÊN 3 ĐƠN [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 12: LIÊN 3 ĐƠN [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/p-U76ueA8oU', 4, true, now() - interval '30 days', now()),
    (270, 29, 'THỰC HÀNH BÀI 12 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 12 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/RwbbEsLxOdA', 5, true, now() - interval '30 days', now()),
    (271, 29, 'BÀI 13: DẤU LẶNG TRÒN - TRẮNG - ĐEN [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 13: DẤU LẶNG TRÒN - TRẮNG - ĐEN [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/KlZUwZJc7wo', 6, true, now() - interval '30 days', now()),
    (272, 29, 'THỰC HÀNH BÀI 13 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 13 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/bebhzkWNK8s', 7, true, now() - interval '30 days', now()),
    (273, 29, 'BÀI 14: LẶNG ĐƠN [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 14: LẶNG ĐƠN [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/2p0LP0VYqGc', 8, true, now() - interval '30 days', now()),
    (274, 29, 'THỰC HÀNH BÀI 14 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 14 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/yQNPBSKn67k', 9, true, now() - interval '30 days', now()),
    (275, 29, 'BÀI 15: DẤU LẶNG KÉP [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 15: DẤU LẶNG KÉP [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/4z-o41dwBO4', 10, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (30, 8, 'Chương 4: Chùm nốt, dấu hóa & đảo phách', 4, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (276, 30, 'THỰC HÀNH BÀI 15 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 15 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/qEdXtyccw9c', 1, true, now() - interval '30 days', now()),
    (277, 30, 'BÀI 16: DẤU NỐI (Phần 1) [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 16: DẤU NỐI (Phần 1) [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/3Y6I-AG2Dmk', 2, true, now() - interval '30 days', now()),
    (278, 30, 'THỰC HÀNH BÀI 16 (Phần 1) [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 16 (Phần 1) [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/No-Hn-4EkAw', 3, true, now() - interval '30 days', now()),
    (279, 30, 'BÀI 16: DẤU NỐI (Phần 2) [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 16: DẤU NỐI (Phần 2) [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/y9OjXH61su0', 4, true, now() - interval '30 days', now()),
    (280, 30, 'THỰC HÀNH BÀI 16 (Phần 2) [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 16 (Phần 2) [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/_J9EXMjbq2E', 5, true, now() - interval '30 days', now()),
    (281, 30, 'BÀI 17: ĐẢO PHÁCH - DẤU LUYẾN [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 17: ĐẢO PHÁCH - DẤU LUYẾN [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/wlhbhzsbNF4', 6, true, now() - interval '30 days', now()),
    (282, 30, 'THỰC HÀNH BÀI 17 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 17 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/tV80ebVmKU4', 7, true, now() - interval '30 days', now()),
    (283, 30, 'BÀI 18: GIÁ TRỊ NỐT NHẠC [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 18: GIÁ TRỊ NỐT NHẠC [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/7eFEU8b3hrs', 8, true, now() - interval '30 days', now()),
    (284, 30, 'BÀI 19 (P1): GIỚI THIỆU NHỊP 3/8 - 6/8 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 19 (P1): GIỚI THIỆU NHỊP 3/8 - 6/8 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/1mAEdKrvhiU', 9, true, now() - interval '30 days', now()),
    (285, 30, 'THỰC HÀNH BÀI 19 (Phần 1) [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 19 (Phần 1) [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/YwSVldRILHk', 10, true, now() - interval '30 days', now());

INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES
    (31, 8, 'Chương 5: Điệu thức, hợp âm & thực hành đệm hát', 5, now() - interval '30 days');

INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES
    (286, 31, 'BÀI 19 (P2): CÁCH NHỊP CHÂN TRONG NHỊP 6/8 VÀ 3/8', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 19 (P2): CÁCH NHỊP CHÂN TRONG NHỊP 6/8 VÀ 3/8</p>', 'https://www.youtube.com/embed/FpYzipe0A68', 1, true, now() - interval '30 days', now()),
    (287, 31, 'BÀI 19 (P3): CÁCH NHÓM NỐT TRONG NHỊP 6/8 VÀ 3/8', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 19 (P3): CÁCH NHÓM NỐT TRONG NHỊP 6/8 VÀ 3/8</p>', 'https://www.youtube.com/embed/pgXWGmQD_X8', 2, true, now() - interval '30 days', now()),
    (288, 31, 'BÀI 19 (P4): PHƯƠNG PHÁP ĐÁNH SỐ TIẾT TẤU TRONG NHỊP 6/8 VÀ 3/8', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 19 (P4): PHƯƠNG PHÁP ĐÁNH SỐ TIẾT TẤU TRONG NHỊP 6/8 VÀ 3/8</p>', 'https://www.youtube.com/embed/6_uId76v0w0', 3, true, now() - interval '30 days', now()),
    (289, 31, 'BÀI 19 (P5): BÀI TẬP THỰC HÀNH NHỊP 6/8 VÀ 3/8', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 19 (P5): BÀI TẬP THỰC HÀNH NHỊP 6/8 VÀ 3/8</p>', 'https://www.youtube.com/embed/3Ji8YQOap7w', 4, true, now() - interval '30 days', now()),
    (290, 31, 'BÀI 20 (Phần 1): CUNG & DẤU HÓA [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 20 (Phần 1): CUNG & DẤU HÓA [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/j82YOy1-NFg', 5, true, now() - interval '30 days', now()),
    (291, 31, 'BÀI 20 (Phần 2): CUNG & DẤU HÓA [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 20 (Phần 2): CUNG & DẤU HÓA [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/ASdMcegli6s', 6, true, now() - interval '30 days', now()),
    (292, 31, 'THỰC HÀNH BÀI 20 [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 20 [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/LG9PbS3Pbck', 7, true, now() - interval '30 days', now()),
    (293, 31, 'BÀI 21: HÓA BIỂU [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: BÀI 21: HÓA BIỂU [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/rd6idEOxqLY', 8, true, now() - interval '30 days', now()),
    (294, 31, 'THỰC HÀNH BÀI 21 [Khóa học Nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: THỰC HÀNH BÀI 21 [Khóa học Nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/woeDjLW9IDY', 9, true, now() - interval '30 days', now()),
    (295, 31, '[Kết thúc khóa học] BÀI 22: DẤU HỒI TẤU [Khóa học nhạc lý cơ bản & thực hành]', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: [Kết thúc khóa học] BÀI 22: DẤU HỒI TẤU [Khóa học nhạc lý cơ bản & thực hành]</p>', 'https://www.youtube.com/embed/PB7zp_J-JXA', 10, true, now() - interval '30 days', now());

-- QUIZZES CHO TOÀN BỘ 31 CHƯƠNG HỌC CỦA 8 KHÓA HỌC
INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, is_active, created_at, updated_at) VALUES
    (1, 1, 'Kiểm tra trắc nghiệm: Cốt cách & Nền tảng Nhân tướng học', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (2, 2, 'Kiểm tra trắc nghiệm: Luận giải Ngũ quan & Thần khí Ứng dụng', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (3, 3, 'Kiểm tra trắc nghiệm: Nhập môn & Cài đặt môi trường Python', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (4, 4, 'Kiểm tra trắc nghiệm: Biến, Kiểu dữ liệu & Chuỗi ký tự', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (5, 5, 'Kiểm tra trắc nghiệm: Cấu trúc điều khiển & Vòng lặp For / While', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (6, 6, 'Kiểm tra trắc nghiệm: Hàm, Module & Cấu trúc dữ liệu nâng cao', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (7, 7, 'Kiểm tra trắc nghiệm: Lập trình hướng đối tượng & Xử lý lỗi', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (8, 8, 'Kiểm tra trắc nghiệm: Các Cung Hoàng Đạo Tiên Phong (Lửa & Đất)', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (9, 9, 'Kiểm tra trắc nghiệm: Các Cung Hoàng Đạo Kiên Định & Biến Đổi (Khí & Nước)', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (10, 10, 'Kiểm tra trắc nghiệm: Nền tảng Java Core & Cài đặt Spring Boot 3', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (11, 11, 'Kiểm tra trắc nghiệm: Spring Data JPA, Hibernate & CSDL Quan hệ', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (12, 12, 'Kiểm tra trắc nghiệm: Xây dựng RESTful API & Service Layer', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (13, 13, 'Kiểm tra trắc nghiệm: Bảo mật với Spring Security & Triển khai thực chiến', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (14, 14, 'Kiểm tra trắc nghiệm: Làm quen .NET & Cài đặt Visual Studio', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (15, 15, 'Kiểm tra trắc nghiệm: Cú pháp ngôn ngữ C# & Kiểu dữ liệu nền tảng', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (16, 16, 'Kiểm tra trắc nghiệm: Lập trình hướng đối tượng OOP với C#', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (17, 17, 'Kiểm tra trắc nghiệm: Xây dựng ứng dụng & Web API với .NET Core', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (18, 18, 'Kiểm tra trắc nghiệm: Hệ thống Phiên âm Pinyin & Bảng chữ cái', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (19, 19, 'Kiểm tra trắc nghiệm: 4 Thanh điệu & Kỹ thuật phát âm chuẩn', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (20, 20, 'Kiểm tra trắc nghiệm: Quy tắc viết các nét cơ bản chữ Hán', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (21, 21, 'Kiểm tra trắc nghiệm: Các bộ thủ chữ Hán thông dụng', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (22, 22, 'Kiểm tra trắc nghiệm: Từ vựng & Đàm thoại giao tiếp sơ cấp (Phần 1)', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (23, 23, 'Kiểm tra trắc nghiệm: Từ vựng & Đàm thoại giao tiếp sơ cấp (Phần 2)', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (24, 24, 'Kiểm tra trắc nghiệm: Ngữ pháp căn bản & Đàm thoại thực tế', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (25, 25, 'Kiểm tra trắc nghiệm: Bản chất hiện tượng tâm lý người & Nhận thức cảm tính', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (26, 26, 'Kiểm tra trắc nghiệm: Quá trình nhận thức lý tính, Cảm xúc & Nhân cách', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (27, 27, 'Kiểm tra trắc nghiệm: Khuông nhạc, Khóa nhạc & Nhịp phách', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (28, 28, 'Kiểm tra trắc nghiệm: Cao độ, Trường độ & Vị trí nốt trên cần đàn', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (29, 29, 'Kiểm tra trắc nghiệm: Đọc tiết tấu, nốt móc đơn & móc kép', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (30, 30, 'Kiểm tra trắc nghiệm: Chùm nốt, dấu hóa & đảo phách', 75.00, 15, 1, true, now() - interval '10 days', now()),
    (31, 31, 'Kiểm tra trắc nghiệm: Điệu thức, hợp âm & thực hành đệm hát', 75.00, 15, 1, true, now() - interval '10 days', now());

INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at) VALUES
    (1, 1, 'Trong nhân tướng học, yếu tố nào phản ánh nội tâm sâu sắc nhất?', 'SINGLE_CHOICE', 50.00, now()),
    (2, 1, 'Thần khí tốt thể hiện qua đặc điểm nào sau đây?', 'SINGLE_CHOICE', 50.00, now()),
    (3, 2, 'Ngũ quan trong nhân tướng học bao gồm những bộ phận nào?', 'SINGLE_CHOICE', 50.00, now()),
    (4, 2, 'Cung Tài Bạch trên khuôn mặt nằm ở vị trí nào?', 'SINGLE_CHOICE', 50.00, now()),
    (5, 3, 'Phần mở rộng chuẩn của tệp mã nguồn Python là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (6, 3, 'Lệnh nào dùng để in dữ liệu ra màn hình console trong Python?', 'SINGLE_CHOICE', 50.00, now()),
    (7, 4, 'Kiểu dữ liệu nào trong Python là danh sách có thể thay đổi (mutable)?', 'SINGLE_CHOICE', 50.00, now()),
    (8, 4, 'Cách lấy độ dài của một chuỗi hoặc danh sách trong Python là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (9, 5, 'Hàm nào tạo ra một dãy số tuần tự trong vòng lặp for?', 'SINGLE_CHOICE', 50.00, now()),
    (10, 5, 'Từ khóa nào dùng để thoát khỏi vòng lặp ngay lập tức?', 'SINGLE_CHOICE', 50.00, now()),
    (11, 6, 'Từ khóa nào dùng để định nghĩa một hàm trong Python?', 'SINGLE_CHOICE', 50.00, now()),
    (12, 6, 'Cấu trúc dữ liệu lưu trữ cặp khóa - giá trị (Key-Value) trong Python là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (13, 7, 'Phương thức khởi tạo (constructor) của class trong Python có tên là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (14, 7, 'Khối lệnh nào dùng để bắt và xử lý ngoại lệ trong Python?', 'SINGLE_CHOICE', 50.00, now()),
    (15, 8, 'Cung hoàng đạo nào là thủ lĩnh nhóm nguyên tố Lửa?', 'SINGLE_CHOICE', 50.00, now()),
    (16, 8, 'Phẩm chất nổi bật nhất của cung Ma Kết (Capricorn) thuộc nhóm Đất là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (17, 9, 'Bảo Bình (Aquarius) thuộc nhóm nguyên tố nào trong vòng tròn Hoàng Đạo?', 'SINGLE_CHOICE', 50.00, now()),
    (18, 9, 'Đặc tính cảm xúc sâu sắc và trực giác nhạy bén là của nhóm nguyên tố nào?', 'SINGLE_CHOICE', 50.00, now()),
    (19, 10, 'Spring Boot 3 yêu cầu phiên bản Java tối thiểu nào?', 'SINGLE_CHOICE', 50.00, now()),
    (20, 10, 'Annotation chính đặt trên class khởi chạy của ứng dụng Spring Boot là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (21, 11, 'Interface nền tảng trong Spring Data JPA cung cấp sẵn các hàm CRUD là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (22, 11, 'Annotation nào dùng để đánh dấu một Entity ánh xạ bảng CSDL?', 'SINGLE_CHOICE', 50.00, now()),
    (23, 12, 'Annotation nào kết hợp giữa @Controller và @ResponseBody?', 'SINGLE_CHOICE', 50.00, now()),
    (24, 12, 'Phương thức HTTP nào chuẩn mực dùng để tạo mới tài nguyên?', 'SINGLE_CHOICE', 50.00, now()),
    (25, 13, 'Cơ chế nào thường dùng để xác thực không lưu trạng thái (Stateless) cho REST API?', 'SINGLE_CHOICE', 50.00, now()),
    (26, 13, 'Annotation nào dùng để phân quyền trên từng phương thức Service?', 'SINGLE_CHOICE', 50.00, now()),
    (27, 14, 'Môi trường thực thi mã trung gian (Intermediate Language) của .NET có tên là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (28, 14, 'Lệnh CLI nào tạo mới một dự án Web API trong .NET?', 'SINGLE_CHOICE', 50.00, now()),
    (29, 15, 'Từ khóa nào khai báo biến có thể tự suy luận kiểu dữ liệu tại thời điểm biên dịch trong C#?', 'SINGLE_CHOICE', 50.00, now()),
    (30, 15, 'Kiểu dữ liệu nullable trong C# được khai báo bằng ký tự nào?', 'SINGLE_CHOICE', 50.00, now()),
    (31, 16, 'Từ khóa nào dùng để cho phép phương thức ở lớp cha có thể bị ghi đè?', 'SINGLE_CHOICE', 50.00, now()),
    (32, 16, 'C# hỗ trợ đa kế thừa trực tiếp từ nhiều lớp (class) không?', 'SINGLE_CHOICE', 50.00, now()),
    (33, 17, 'Tệp tin nào là điểm khởi đầu cấu hình Dependency Injection trong .NET 6/7/8?', 'SINGLE_CHOICE', 50.00, now()),
    (34, 17, 'Interface nào dùng để đăng ký dịch vụ vòng đời theo từng HTTP Request trong .NET?', 'SINGLE_CHOICE', 50.00, now()),
    (35, 18, 'Pinyin trong tiếng Trung dùng để làm gì?', 'SINGLE_CHOICE', 50.00, now()),
    (36, 18, 'Tiếng Trung phổ thông có bao nhiêu thanh mẫu (phụ âm đầu) chính?', 'SINGLE_CHOICE', 50.00, now()),
    (37, 19, 'Tiếng Trung tiêu chuẩn có bao nhiêu thanh điệu cơ bản?', 'SINGLE_CHOICE', 50.00, now()),
    (38, 19, 'Thanh 1 (Thanh ngang) trong tiếng Trung phát âm như thế nào?', 'SINGLE_CHOICE', 50.00, now()),
    (39, 20, 'Quy tắc viết chữ Hán cơ bản nhất là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (40, 20, 'Nét ''Mác'' trong thư pháp chữ Hán có hướng kéo như thế nào?', 'SINGLE_CHOICE', 50.00, now()),
    (41, 21, 'Bộ ''Nhân'' (人 / 亻) liên quan đến ý nghĩa gì trong chữ Hán?', 'SINGLE_CHOICE', 50.00, now()),
    (42, 21, 'Bộ ''Thủy'' (水 / 氵) biểu thị ý nghĩa liên quan đến gì?', 'SINGLE_CHOICE', 50.00, now()),
    (43, 22, 'Câu chào phổ biến nhất ''Xin chào'' trong tiếng Trung là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (44, 22, 'Từ ''Cảm ơn'' trong tiếng Trung được phát âm là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (45, 23, 'Từ nào trong tiếng Trung có nghĩa là ''Tạm biệt''?', 'SINGLE_CHOICE', 50.00, now()),
    (46, 23, 'Đại từ nhân xưng ngôi thứ nhất số nhiều ''Chúng tôi'' là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (47, 24, 'Trợ từ nghi vấn nào dùng ở cuối câu hỏi Yes/No trong tiếng Trung?', 'SINGLE_CHOICE', 50.00, now()),
    (48, 24, 'Định ngữ bổ nghĩa cho danh từ trong tiếng Trung thường liên kết bởi trợ từ nào?', 'SINGLE_CHOICE', 50.00, now()),
    (49, 25, 'Tâm lý người có nguồn gốc cốt lõi từ đâu?', 'SINGLE_CHOICE', 50.00, now()),
    (50, 25, 'Hình thức nhận thức cảm tính nào phản ánh trọn vẹn các thuộc tính bề ngoài của sự vật?', 'SINGLE_CHOICE', 50.00, now()),
    (51, 26, 'Đặc điểm cơ bản nhất của tư duy là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (52, 26, 'Cấu trúc nhân cách bao gồm những thành tố tâm lý chủ yếu nào?', 'SINGLE_CHOICE', 50.00, now()),
    (53, 27, 'Một khuông nhạc tiêu chuẩn gồm bao nhiêu dòng kẻ và bao nhiêu khe?', 'SINGLE_CHOICE', 50.00, now()),
    (54, 27, 'Khóa nhạc phổ biến nhất dùng cho đàn Guitar và giọng hát là khóa gì?', 'SINGLE_CHOICE', 50.00, now()),
    (55, 28, '7 nốt nhạc cơ bản theo thứ tự cao độ tăng dần là gì?', 'SINGLE_CHOICE', 50.00, now()),
    (56, 28, 'Dây số 6 (dây dày nhất) trên đàn Guitar chuẩn được lên dây theo nốt gì?', 'SINGLE_CHOICE', 50.00, now()),
    (57, 29, '1 nốt tròn có trường độ bằng bao nhiêu nốt đen?', 'SINGLE_CHOICE', 50.00, now()),
    (58, 29, '1 nốt đen có trường độ bằng bao nhiêu nốt móc đơn?', 'SINGLE_CHOICE', 50.00, now()),
    (59, 30, 'Dấu thăng (#) có tác dụng gì đối với cao độ của nốt nhạc?', 'SINGLE_CHOICE', 50.00, now()),
    (60, 30, 'Dấu giáng (b) có tác dụng gì đối với cao độ của nốt nhạc?', 'SINGLE_CHOICE', 50.00, now()),
    (61, 31, 'Hợp âm Đô trưởng (C Major) được cấu tạo từ 3 nốt nhạc nào?', 'SINGLE_CHOICE', 50.00, now()),
    (62, 31, 'Hợp âm La thứ (Am) mang tính chất âm thanh như thế nào?', 'SINGLE_CHOICE', 50.00, now());

INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
    (1, 1, 'Ánh mắt và thần sắc', true, 1),
    (2, 1, 'Trang phục bên ngoài', false, 2),
    (3, 1, 'Chiều cao cơ thể', false, 3),
    (4, 1, 'Màu tóc', false, 4),
    (5, 2, 'Ánh mắt sáng, điềm tĩnh và giọng nói rõ ràng', true, 1),
    (6, 2, 'Ánh mắt đảo liên tục', false, 2),
    (7, 2, 'Nói năng hấp tấp', false, 3),
    (8, 2, 'Sắc diện u tối', false, 4),
    (9, 3, 'Mắt, tai, mũi, miệng, lông mày', true, 1),
    (10, 3, 'Trán, cằm, má, mũi, mắt', false, 2),
    (11, 3, 'Tóc, tai, mắt, miệng, răng', false, 3),
    (12, 3, 'Mũi, họng, mắt, trán, cằm', false, 4),
    (13, 4, 'Đỉnh mũi và hai cánh mũi', true, 1),
    (14, 4, 'Ấn đường giữa hai lông mày', false, 2),
    (15, 4, 'Nhân trung dưới mũi', false, 3),
    (16, 4, 'Địa các vùng cằm', false, 4),
    (17, 5, '.py', true, 1),
    (18, 5, '.python', false, 2),
    (19, 5, '.pt', false, 3),
    (20, 5, '.pyw', false, 4),
    (21, 6, 'print()', true, 1),
    (22, 6, 'System.out.println()', false, 2),
    (23, 6, 'console.log()', false, 3),
    (24, 6, 'echo()', false, 4),
    (25, 7, 'list', true, 1),
    (26, 7, 'tuple', false, 2),
    (27, 7, 'str', false, 3),
    (28, 7, 'int', false, 4),
    (29, 8, 'len()', true, 1),
    (30, 8, 'size()', false, 2),
    (31, 8, 'length()', false, 3),
    (32, 8, 'count()', false, 4),
    (33, 9, 'range()', true, 1),
    (34, 9, 'seq()', false, 2),
    (35, 9, 'series()', false, 3),
    (36, 9, 'list_range()', false, 4),
    (37, 10, 'break', true, 1),
    (38, 10, 'continue', false, 2),
    (39, 10, 'pass', false, 3),
    (40, 10, 'exit', false, 4),
    (41, 11, 'def', true, 1),
    (42, 11, 'function', false, 2),
    (43, 11, 'func', false, 3),
    (44, 11, 'define', false, 4),
    (45, 12, 'dict', true, 1),
    (46, 12, 'set', false, 2),
    (47, 12, 'tuple', false, 3),
    (48, 12, 'array', false, 4),
    (49, 13, '__init__', true, 1),
    (50, 13, '__new__', false, 2),
    (51, 13, '__construct__', false, 3),
    (52, 13, 'create()', false, 4),
    (53, 14, 'try...except', true, 1),
    (54, 14, 'try...catch', false, 2),
    (55, 14, 'try...error', false, 3),
    (56, 14, 'check...handle', false, 4),
    (57, 15, 'Bạch Dương (Aries)', true, 1),
    (58, 15, 'Kim Ngưu (Taurus)', false, 2),
    (59, 15, 'Song Tử (Gemini)', false, 3),
    (60, 15, 'Cự Giải (Cancer)', false, 4),
    (61, 16, 'Kỷ luật, kiên định và thực tế', true, 1),
    (62, 16, 'Nóng nảy bốc đồng', false, 2),
    (63, 16, 'Mơ mộng viển vông', false, 3),
    (64, 16, 'Thiếu quyết đoán', false, 4),
    (65, 17, 'Khí (Air)', true, 1),
    (66, 17, 'Nước (Water)', false, 2),
    (67, 17, 'Lửa (Fire)', false, 3),
    (68, 17, 'Đất (Earth)', false, 4),
    (69, 18, 'Nước (Water)', true, 1),
    (70, 18, 'Khí (Air)', false, 2),
    (71, 18, 'Đất (Earth)', false, 3),
    (72, 18, 'Lửa (Fire)', false, 4),
    (73, 19, 'Java 17', true, 1),
    (74, 19, 'Java 8', false, 2),
    (75, 19, 'Java 11', false, 3),
    (76, 19, 'Java 14', false, 4),
    (77, 20, '@SpringBootApplication', true, 1),
    (78, 20, '@EnableAutoConfiguration', false, 2),
    (79, 20, '@Configuration', false, 3),
    (80, 20, '@SpringBootApp', false, 4),
    (81, 21, 'JpaRepository', true, 1),
    (82, 21, 'CrudService', false, 2),
    (83, 21, 'HibernateDao', false, 3),
    (84, 21, 'EntityManagerHelper', false, 4),
    (85, 22, '@Entity', true, 1),
    (86, 22, '@TableMapping', false, 2),
    (87, 22, '@Model', false, 3),
    (88, 22, '@DatabaseRecord', false, 4),
    (89, 23, '@RestController', true, 1),
    (90, 23, '@ApiController', false, 2),
    (91, 23, '@WebEndpoint', false, 3),
    (92, 23, '@ServiceRest', false, 4),
    (93, 24, 'POST', true, 1),
    (94, 24, 'GET', false, 2),
    (95, 24, 'PUT', false, 3),
    (96, 24, 'PATCH', false, 4),
    (97, 25, 'JWT (JSON Web Token)', true, 1),
    (98, 25, 'HTTP Basic Session', false, 2),
    (99, 25, 'Cookie Session ID', false, 3),
    (100, 25, 'Kerberos Ticket', false, 4),
    (101, 26, '@PreAuthorize', true, 1),
    (102, 26, '@SecureCheck', false, 2),
    (103, 26, '@RoleAllowedOnly', false, 3),
    (104, 26, '@PermitRole', false, 4),
    (105, 27, 'CLR (Common Language Runtime)', true, 1),
    (106, 27, 'JVM', false, 2),
    (107, 27, 'V8 Engine', false, 3),
    (108, 27, 'Mono Hub', false, 4),
    (109, 28, 'dotnet new webapi', true, 1),
    (110, 28, 'dotnet create api', false, 2),
    (111, 28, 'dotnet init web', false, 3),
    (112, 28, 'dotnet make rest', false, 4),
    (113, 29, 'var', true, 1),
    (114, 29, 'dynamic', false, 2),
    (115, 29, 'auto', false, 3),
    (116, 29, 'val', false, 4),
    (117, 30, 'int?', true, 1),
    (118, 30, 'int*', false, 2),
    (119, 30, 'int&', false, 3),
    (120, 30, 'int!', false, 4),
    (121, 31, 'virtual', true, 1),
    (122, 31, 'override', false, 2),
    (123, 31, 'abstract', false, 3),
    (124, 31, 'extendable', false, 4),
    (125, 32, 'Không, chỉ hỗ trợ đa kế thừa Interface', true, 1),
    (126, 32, 'Có, không giới hạn số lớp', false, 2),
    (127, 32, 'Có, tối đa 2 lớp', false, 3),
    (128, 32, 'Chỉ hỗ trợ khi dùng từ khóa partial', false, 4),
    (129, 33, 'Program.cs', true, 1),
    (130, 33, 'Startup.cs', false, 2),
    (131, 33, 'Web.config', false, 3),
    (132, 33, 'App.json', false, 4),
    (133, 34, 'AddScoped', true, 1),
    (134, 34, 'AddSingleton', false, 2),
    (135, 34, 'AddTransient', false, 3),
    (136, 34, 'AddScopedLifetime', false, 4),
    (137, 35, 'Ghi lại cách phát âm bằng ký tự Latinh', true, 1),
    (138, 35, 'Quy định nét vẽ chữ Hán', false, 2),
    (139, 35, 'Dịch nghĩa sang tiếng Anh', false, 3),
    (140, 35, 'Đếm số nét chữ', false, 4),
    (141, 36, '21', true, 1),
    (142, 36, '24', false, 2),
    (143, 36, '18', false, 3),
    (144, 36, '26', false, 4),
    (145, 37, '4 thanh điệu chính và 1 thanh nhẹ', true, 1),
    (146, 37, '3 thanh điệu', false, 2),
    (147, 37, '5 thanh điệu', false, 3),
    (148, 37, '6 thanh điệu', false, 4),
    (149, 38, 'Cao và đều (55)', true, 1),
    (150, 38, 'Từ cao xuống thấp', false, 2),
    (151, 38, 'Từ thấp lên cao', false, 3),
    (152, 38, 'Xuống thấp rồi lên cao', false, 4),
    (153, 39, 'Từ trên xuống dưới, từ trái sang phải', true, 1),
    (154, 39, 'Từ phải sang trái, từ dưới lên trên', false, 2),
    (155, 39, 'Tùy ý người viết', false, 3),
    (156, 39, 'Nét dọc trước nét ngang sau', false, 4),
    (157, 40, 'Kéo xiên từ trên trái xuống dưới phải', true, 1),
    (158, 40, 'Kéo thẳng từ trên xuống', false, 2),
    (159, 40, 'Kéo ngang từ trái qua phải', false, 3),
    (160, 40, 'Kéo móc ngược lên', false, 4),
    (161, 41, 'Con người', true, 1),
    (162, 41, 'Cây cối', false, 2),
    (163, 41, 'Nước', false, 3),
    (164, 41, 'Lửa', false, 4),
    (165, 42, 'Nước, sông hồ, chất lỏng', true, 1),
    (166, 42, 'Kim loại', false, 2),
    (167, 42, 'Đất đai', false, 3),
    (168, 42, 'Gió bão', false, 4),
    (169, 43, 'Nǐ hǎo (你好)', true, 1),
    (170, 43, 'Xièxie (谢谢)', false, 2),
    (171, 43, 'Zàijiàn (再见)', false, 3),
    (172, 43, 'Duìbuqǐ (对不起)', false, 4),
    (173, 44, 'Xièxie (谢谢)', true, 1),
    (174, 44, 'Bù kèqi (不客气)', false, 2),
    (175, 44, 'Nǐ hǎo (你好)', false, 3),
    (176, 44, 'Méi guānxi (没关系)', false, 4),
    (177, 45, 'Zàijiàn (再见)', true, 1),
    (178, 45, 'Qǐng (请)', false, 2),
    (179, 45, 'Hǎo (好)', false, 3),
    (180, 45, 'Shì (是)', false, 4),
    (181, 46, 'Wǒmen (我们)', true, 1),
    (182, 46, 'Nǐmen (你们)', false, 2),
    (183, 46, 'Tāmen (他们)', false, 3),
    (184, 46, 'Dàjiā (大家)', false, 4),
    (185, 47, 'Ma (吗)', true, 1),
    (186, 47, 'Ne (呢)', false, 2),
    (187, 47, 'Ba (吧)', false, 3),
    (188, 47, 'De (的)', false, 4),
    (189, 48, 'De (的)', true, 1),
    (190, 48, 'Le (了)', false, 2),
    (191, 48, 'Zhe (着)', false, 3),
    (192, 48, 'Guò (过)', false, 4),
    (193, 49, 'Hiện thực khách quan phản ánh qua não bộ con người', true, 1),
    (194, 49, 'Tự nhiên sinh ra không chịu ảnh hưởng từ môi trường', false, 2),
    (195, 49, 'Chỉ do gen di truyền quyết định hoàn toàn', false, 3),
    (196, 49, 'Không có nguồn gốc rõ ràng', false, 4),
    (197, 50, 'Tri giác', true, 1),
    (198, 50, 'Cảm giác', false, 2),
    (199, 50, 'Tư duy', false, 3),
    (200, 50, 'Tưởng tượng', false, 4),
    (201, 51, 'Tính gián tiếp và tính khái quát', true, 1),
    (202, 51, 'Chỉ phản ánh thuộc tính riêng lẻ', false, 2),
    (203, 51, 'Phản ánh trực tiếp bằng giác quan', false, 3),
    (204, 51, 'Không có tính trừu tượng', false, 4),
    (205, 52, 'Xu hướng, tính cách, khí chất và năng lực', true, 1),
    (206, 52, 'Chiều cao, cân nặng và ngoại hình', false, 2),
    (207, 52, 'Sở thích và trang phục', false, 3),
    (208, 52, 'Trí nhớ và giọng nói', false, 4),
    (209, 53, '5 dòng kẻ và 4 khe', true, 1),
    (210, 53, '4 dòng kẻ và 5 khe', false, 2),
    (211, 53, '6 dòng kẻ và 5 khe', false, 3),
    (212, 53, '5 dòng kẻ và 5 khe', false, 4),
    (213, 54, 'Khóa Sol (G Clef)', true, 1),
    (214, 54, 'Khóa Fa (F Clef)', false, 2),
    (215, 54, 'Khóa Đô (C Clef)', false, 3),
    (216, 54, 'Khóa La (A Clef)', false, 4),
    (217, 55, 'Đô, Rê, Mi, Fa, Sol, La, Si', true, 1),
    (218, 55, 'La, Si, Đô, Rê, Mi, Fa, Sol', false, 2),
    (219, 55, 'Sol, Fa, Mi, Rê, Đô, Si, La', false, 3),
    (220, 55, 'Mi, Sol, Si, Rê, Fa, La, Đô', false, 4),
    (221, 56, 'Nốt Mi (E)', true, 1),
    (222, 56, 'Nốt La (A)', false, 2),
    (223, 56, 'Nốt Rê (D)', false, 3),
    (224, 56, 'Nốt Sol (G)', false, 4),
    (225, 57, '4 nốt đen', true, 1),
    (226, 57, '2 nốt đen', false, 2),
    (227, 57, '8 nốt đen', false, 3),
    (228, 57, '16 nốt đen', false, 4),
    (229, 58, '2 nốt móc đơn', true, 1),
    (230, 58, '4 nốt móc đơn', false, 2),
    (231, 58, '3 nốt móc đơn', false, 3),
    (232, 58, '1 nốt móc đơn', false, 4),
    (233, 59, 'Tăng cao độ lên nửa cung (1/2 cung)', true, 1),
    (234, 59, 'Giảm cao độ nửa cung', false, 2),
    (235, 59, 'Tăng cao độ lên 1 cung', false, 3),
    (236, 59, 'Giữ nguyên cao độ', false, 4),
    (237, 60, 'Giảm cao độ xuống nửa cung (1/2 cung)', true, 1),
    (238, 60, 'Tăng cao độ nửa cung', false, 2),
    (239, 60, 'Giảm cao độ 1 cung', false, 3),
    (240, 60, 'Hủy bỏ dấu thăng', false, 4),
    (241, 61, 'Đô - Mi - Sol (C - E - G)', true, 1),
    (242, 61, 'Đô - Fa - La (C - F - A)', false, 2),
    (243, 61, 'Rê - Fa - La (D - F - A)', false, 3),
    (244, 61, 'Mi - Sol - Si (E - G - B)', false, 4),
    (245, 62, 'U buồn, trầm lắng, êm dịu', true, 1),
    (246, 62, 'Vui tươi, rộn rã, hùng tráng', false, 2),
    (247, 62, 'Chói chang, gay gắt', false, 3),
    (248, 62, 'Căng thẳng, hồi hộp', false, 4);

INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points) VALUES
    (1, 1, 1, 1, 1, 50.00),
    (2, 1, 2, 1, 2, 50.00),
    (3, 2, 3, 2, 1, 50.00),
    (4, 2, 4, 2, 2, 50.00),
    (5, 3, 5, 3, 1, 50.00),
    (6, 3, 6, 3, 2, 50.00),
    (7, 4, 7, 4, 1, 50.00),
    (8, 4, 8, 4, 2, 50.00),
    (9, 5, 9, 5, 1, 50.00),
    (10, 5, 10, 5, 2, 50.00),
    (11, 6, 11, 6, 1, 50.00),
    (12, 6, 12, 6, 2, 50.00),
    (13, 7, 13, 7, 1, 50.00),
    (14, 7, 14, 7, 2, 50.00),
    (15, 8, 15, 8, 1, 50.00),
    (16, 8, 16, 8, 2, 50.00),
    (17, 9, 17, 9, 1, 50.00),
    (18, 9, 18, 9, 2, 50.00),
    (19, 10, 19, 10, 1, 50.00),
    (20, 10, 20, 10, 2, 50.00),
    (21, 11, 21, 11, 1, 50.00),
    (22, 11, 22, 11, 2, 50.00),
    (23, 12, 23, 12, 1, 50.00),
    (24, 12, 24, 12, 2, 50.00),
    (25, 13, 25, 13, 1, 50.00),
    (26, 13, 26, 13, 2, 50.00),
    (27, 14, 27, 14, 1, 50.00),
    (28, 14, 28, 14, 2, 50.00),
    (29, 15, 29, 15, 1, 50.00),
    (30, 15, 30, 15, 2, 50.00),
    (31, 16, 31, 16, 1, 50.00),
    (32, 16, 32, 16, 2, 50.00),
    (33, 17, 33, 17, 1, 50.00),
    (34, 17, 34, 17, 2, 50.00),
    (35, 18, 35, 18, 1, 50.00),
    (36, 18, 36, 18, 2, 50.00),
    (37, 19, 37, 19, 1, 50.00),
    (38, 19, 38, 19, 2, 50.00),
    (39, 20, 39, 20, 1, 50.00),
    (40, 20, 40, 20, 2, 50.00),
    (41, 21, 41, 21, 1, 50.00),
    (42, 21, 42, 21, 2, 50.00),
    (43, 22, 43, 22, 1, 50.00),
    (44, 22, 44, 22, 2, 50.00),
    (45, 23, 45, 23, 1, 50.00),
    (46, 23, 46, 23, 2, 50.00),
    (47, 24, 47, 24, 1, 50.00),
    (48, 24, 48, 24, 2, 50.00),
    (49, 25, 49, 25, 1, 50.00),
    (50, 25, 50, 25, 2, 50.00),
    (51, 26, 51, 26, 1, 50.00),
    (52, 26, 52, 26, 2, 50.00),
    (53, 27, 53, 27, 1, 50.00),
    (54, 27, 54, 27, 2, 50.00),
    (55, 28, 55, 28, 1, 50.00),
    (56, 28, 56, 28, 2, 50.00),
    (57, 29, 57, 29, 1, 50.00),
    (58, 29, 58, 29, 2, 50.00),
    (59, 30, 59, 30, 1, 50.00),
    (60, 30, 60, 30, 2, 50.00),
    (61, 31, 61, 31, 1, 50.00),
    (62, 31, 62, 31, 2, 50.00);

-- ĐĂNG KÝ KHÓA HỌC CHO TÀI KHOẢN STUDENT1 (ID=4)
INSERT INTO registrations (id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at) VALUES
    (1, 4, 1, now() - interval '10 days', 47.06, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '10 days'),
    (2, 4, 2, now() - interval '9 days',  25.00, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '9 days'),
    (3, 4, 3, now() - interval '8 days',  16.67, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '8 days'),
    (4, 4, 4, now() - interval '7 days',  10.00, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '7 days'),
    (5, 4, 5, now() - interval '2 days',    0.00,  'PENDING',   'VNPAY',  'VNP_TEST_PENDING', 299000, 'PENDING', NULL),
    (6, 4, 6, now() - interval '6 days',  15.00, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '6 days'),
    (7, 4, 7, now() - interval '20 days',100.0, 'COMPLETED', 'VNPAY',  'VNP_TEST_SUCCESS', 199000, 'SUCCESS', now() - interval '20 days'),
    (8, 4, 8, now() - interval '40 days', 19.61, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '40 days');

-- TIẾN ĐỘ HỌC TẬP MẪU CHO STUDENT1
INSERT INTO lesson_progress (registration_id, lesson_id, status, user_note, updated_at, completed_at) VALUES
    (1, 1, 'COMPLETED', 'Đã nắm vững cốt cách nhân tướng học.', now() - interval '8 days', now() - interval '8 days'),
    (1, 2, 'COMPLETED', 'Đã hiểu rõ ngũ quan và tam đình.', now() - interval '7 days', now() - interval '7 days'),
    (1, 3, 'IN_PROGRESS', 'Đang thực hành quan sát thần khí.', now() - interval '2 hours', NULL),
    (2, 18, 'COMPLETED', 'Đã cài đặt Python và VS Code thành công.', now() - interval '7 days', now() - interval '7 days'),
    (3, 65, 'COMPLETED', 'Đã ghi nhớ tính cách cung Bạch Dương.', now() - interval '5 days', now() - interval '5 days'),
    (4, 77, 'COMPLETED', 'Đã thiết lập dự án Spring Boot 3.', now() - interval '4 days', now() - interval '4 days'),
    (6, 153, 'COMPLETED', 'Đã phát âm chuẩn thanh mẫu pinyin.', now() - interval '3 days', now() - interval '3 days'),
    (7, 227, 'COMPLETED', 'Đã hiểu bản chất hiện tượng tâm lý người.', now() - interval '18 days', now() - interval '18 days'),
    (8, 245, 'COMPLETED', 'Đã nhớ vị trí các nốt trên khuông nhạc.', now() - interval '25 days', now() - interval '25 days');

-- LỊCH SỬ TRẮC NGHIỆM MẪU
INSERT INTO quiz_attempts (id, registration_id, quiz_id, submitted_at, total_score, pass_status) VALUES
    (1, 1, 1, now() - interval '5 days', 100.00, true),
    (2, 7, 25, now() - interval '1 day', 100.00, true);

INSERT INTO quiz_answers (quiz_attempt_id, question_id, selected_option_id, is_correct, score) VALUES
    (1, 1, 1, true, 50.00),
    (1, 2, 5, true, 50.00),
    (2, 49, 193, true, 50.00),
    (2, 50, 197, true, 50.00)
ON CONFLICT (quiz_attempt_id, question_id, selected_option_id) DO UPDATE SET is_correct = true, score = 50.00;

-- ĐỒNG BỘ LẠI SEQUENCE POSTGRESQL
SELECT setval(pg_get_serial_sequence('users', 'id'), COALESCE((SELECT MAX(id) FROM users), 1));
SELECT setval(pg_get_serial_sequence('courses', 'id'), COALESCE((SELECT MAX(id) FROM courses), 1));
SELECT setval(pg_get_serial_sequence('modules', 'id'), COALESCE((SELECT MAX(id) FROM modules), 1));
SELECT setval(pg_get_serial_sequence('lessons', 'id'), COALESCE((SELECT MAX(id) FROM lessons), 1));
SELECT setval(pg_get_serial_sequence('registrations', 'id'), COALESCE((SELECT MAX(id) FROM registrations), 1));
SELECT setval(pg_get_serial_sequence('quizzes', 'id'), COALESCE((SELECT MAX(id) FROM quizzes), 1));
SELECT setval(pg_get_serial_sequence('questions', 'id'), COALESCE((SELECT MAX(id) FROM questions), 1));
SELECT setval(pg_get_serial_sequence('answer_options', 'id'), COALESCE((SELECT MAX(id) FROM answer_options), 1));
SELECT setval(pg_get_serial_sequence('quiz_questions', 'id'), COALESCE((SELECT MAX(id) FROM quiz_questions), 1));
SELECT setval(pg_get_serial_sequence('quiz_attempts', 'id'), COALESCE((SELECT MAX(id) FROM quiz_attempts), 1));
SELECT setval(pg_get_serial_sequence('quiz_answers', 'id'), COALESCE((SELECT MAX(id) FROM quiz_answers), 1));
SELECT setval(pg_get_serial_sequence('lesson_progress', 'id'), COALESCE((SELECT MAX(id) FROM lesson_progress), 1));

COMMIT;
