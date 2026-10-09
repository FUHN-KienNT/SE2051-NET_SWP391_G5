/*
  Courson LMS - Microsoft SQL Server schema
  Run this script in SQL Server Management Studio as a login allowed to create databases.
*/
IF DB_ID(N'courson_db') IS NULL CREATE DATABASE courson_db;
GO
USE courson_db;
GO

DROP TABLE IF EXISTS quiz_answers;
DROP TABLE IF EXISTS quiz_attempts;
DROP TABLE IF EXISTS lesson_progress;
DROP TABLE IF EXISTS registrations;
DROP TABLE IF EXISTS quiz_questions;
DROP TABLE IF EXISTS answer_options;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS quizzes;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS modules;
DROP TABLE IF EXISTS email_verification_tokens;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS settings;
GO

CREATE TABLE settings (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    type VARCHAR(30) NOT NULL, name NVARCHAR(100) NOT NULL, value NVARCHAR(255),
    priority INT NOT NULL DEFAULT 0, status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    description NVARCHAR(255), created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    CONSTRAINT uq_settings_type_name UNIQUE (type, name),
    CONSTRAINT uq_settings_id_type UNIQUE (id, type),
    CONSTRAINT chk_settings_type CHECK (type IN ('USER_ROLE','COURSE_CATEGORY')),
    CONSTRAINT chk_settings_status CHECK (status IN ('ACTIVE','INACTIVE'))
);

CREATE TABLE users (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE, email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255), full_name NVARCHAR(100) NOT NULL,
    role_id BIGINT NOT NULL, role_type VARCHAR(30) NOT NULL DEFAULT 'USER_ROLE',
    auth_provider VARCHAR(20) NOT NULL, status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    CONSTRAINT fk_users_role FOREIGN KEY (role_id, role_type) REFERENCES settings (id, type),
    CONSTRAINT chk_users_role_type CHECK (role_type = 'USER_ROLE'),
    CONSTRAINT chk_users_auth_provider CHECK (auth_provider IN ('LOCAL','GOOGLE')),
    CONSTRAINT chk_users_status CHECK (status IN ('ACTIVE','INACTIVE','BANNED')),
    CONSTRAINT chk_users_password CHECK ((auth_provider = 'LOCAL' AND password_hash IS NOT NULL) OR auth_provider = 'GOOGLE')
);

CREATE TABLE email_verification_tokens (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, user_id BIGINT NOT NULL,
    token_hash VARCHAR(128) NOT NULL UNIQUE, expires_at DATETIMEOFFSET NOT NULL,
    used BIT NOT NULL DEFAULT 0, created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    CONSTRAINT fk_verification_token_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE courses (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, title NVARCHAR(200) NOT NULL,
    category_id BIGINT, category_type VARCHAR(30) NOT NULL DEFAULT 'COURSE_CATEGORY',
    description NVARCHAR(MAX), price DECIMAL(12,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT', manager_id BIGINT NOT NULL, expert_id BIGINT,
    created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(), updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    CONSTRAINT fk_courses_category FOREIGN KEY (category_id, category_type) REFERENCES settings (id, type),
    CONSTRAINT fk_courses_manager FOREIGN KEY (manager_id) REFERENCES users(id),
    CONSTRAINT fk_courses_expert FOREIGN KEY (expert_id) REFERENCES users(id),
    CONSTRAINT chk_courses_status CHECK (status IN ('DRAFT','PUBLISHED','ARCHIVED')),
    CONSTRAINT chk_courses_price CHECK (price >= 0)
);

CREATE TABLE modules (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, course_id BIGINT NOT NULL, title NVARCHAR(200) NOT NULL,
    order_index INT NOT NULL, created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    CONSTRAINT fk_modules_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT uq_modules_course_order UNIQUE (course_id, order_index)
);

CREATE TABLE lessons (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, module_id BIGINT NOT NULL, title NVARCHAR(200) NOT NULL,
    content NVARCHAR(MAX), video_url VARCHAR(500), document_url VARCHAR(500), order_index INT NOT NULL,
    created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(), updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    CONSTRAINT fk_lessons_module FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE,
    CONSTRAINT uq_lessons_module_order UNIQUE (module_id, order_index)
);

CREATE TABLE quizzes (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, module_id BIGINT NOT NULL, title NVARCHAR(200) NOT NULL,
    pass_score DECIMAL(5,2) NOT NULL, time_limit_minutes INT, order_index INT NOT NULL,
    created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(), updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    CONSTRAINT fk_quizzes_module FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE,
    CONSTRAINT uq_quizzes_module_order UNIQUE (module_id, order_index),
    CONSTRAINT uq_quizzes_id_module UNIQUE (id, module_id), CONSTRAINT chk_quizzes_pass_score CHECK (pass_score BETWEEN 0 AND 100)
);

CREATE TABLE questions (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, module_id BIGINT NOT NULL, question_text NVARCHAR(MAX) NOT NULL,
    question_type VARCHAR(20) NOT NULL, default_points DECIMAL(5,2) NOT NULL DEFAULT 1,
    created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    CONSTRAINT fk_questions_module FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE,
    CONSTRAINT uq_questions_id_module UNIQUE (id, module_id),
    CONSTRAINT chk_questions_type CHECK (question_type IN ('SINGLE_CHOICE','MULTI_CHOICE','TRUE_FALSE')),
    CONSTRAINT chk_questions_points CHECK (default_points > 0)
);

CREATE TABLE answer_options (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, question_id BIGINT NOT NULL, option_text NVARCHAR(500) NOT NULL,
    is_correct BIT NOT NULL DEFAULT 0, order_index INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_answer_options_question FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

CREATE TABLE quiz_questions (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, quiz_id BIGINT NOT NULL, question_id BIGINT NOT NULL, module_id BIGINT NOT NULL,
    order_index INT NOT NULL, points DECIMAL(5,2) NOT NULL,
    CONSTRAINT fk_quiz_questions_quiz FOREIGN KEY (quiz_id, module_id) REFERENCES quizzes(id, module_id) ON DELETE CASCADE,
    CONSTRAINT fk_quiz_questions_question FOREIGN KEY (question_id, module_id) REFERENCES questions(id, module_id),
    CONSTRAINT uq_quiz_questions_quiz_question UNIQUE (quiz_id, question_id),
    CONSTRAINT uq_quiz_questions_quiz_order UNIQUE (quiz_id, order_index), CONSTRAINT chk_quiz_questions_points CHECK (points > 0)
);

CREATE TABLE registrations (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, user_id BIGINT NOT NULL, course_id BIGINT NOT NULL,
    registration_date DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(), progress_percentage DECIMAL(5,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING', payment_method VARCHAR(20), payment_code VARCHAR(100),
    payment_amount DECIMAL(12,2) NOT NULL DEFAULT 0, payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING', paid_at DATETIMEOFFSET,
    CONSTRAINT fk_registrations_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_registrations_course FOREIGN KEY (course_id) REFERENCES courses(id),
    CONSTRAINT uq_registrations_user_course UNIQUE (user_id, course_id),
    CONSTRAINT chk_registrations_status CHECK (status IN ('PENDING','ACTIVE','COMPLETED','CANCELLED')),
    CONSTRAINT chk_registrations_progress CHECK (progress_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_registrations_payment_method CHECK (payment_method IS NULL OR payment_method IN ('SEPAY','VNPAY')),
    CONSTRAINT chk_registrations_payment_status CHECK (payment_status IN ('FREE','PENDING','SUCCESS','FAILED')),
    CONSTRAINT chk_registrations_payment_amount CHECK (payment_amount >= 0),
    CONSTRAINT chk_registrations_paid_fields CHECK (payment_status <> 'SUCCESS' OR (payment_code IS NOT NULL AND paid_at IS NOT NULL)),
    CONSTRAINT chk_registrations_access CHECK (status NOT IN ('ACTIVE','COMPLETED') OR payment_status IN ('SUCCESS','FREE'))
);

CREATE TABLE lesson_progress (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, registration_id BIGINT NOT NULL, lesson_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'NOT_STARTED', completed_at DATETIMEOFFSET,
    CONSTRAINT fk_lesson_progress_registration FOREIGN KEY (registration_id) REFERENCES registrations(id),
    CONSTRAINT fk_lesson_progress_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    CONSTRAINT uq_lesson_progress_registration_lesson UNIQUE (registration_id, lesson_id),
    CONSTRAINT chk_lesson_progress_status CHECK (status IN ('NOT_STARTED','IN_PROGRESS','COMPLETED'))
);

CREATE TABLE quiz_attempts (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, registration_id BIGINT NOT NULL, quiz_id BIGINT NOT NULL,
    submitted_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(), total_score DECIMAL(6,2) NOT NULL, pass_status BIT NOT NULL,
    CONSTRAINT fk_quiz_attempts_registration FOREIGN KEY (registration_id) REFERENCES registrations(id) ON DELETE CASCADE,
    CONSTRAINT fk_quiz_attempts_quiz FOREIGN KEY (quiz_id) REFERENCES quizzes(id),
    CONSTRAINT uq_quiz_attempts_registration_quiz UNIQUE (registration_id, quiz_id), CONSTRAINT chk_quiz_attempts_score CHECK (total_score >= 0)
);

CREATE TABLE quiz_answers (
    id BIGINT IDENTITY(1,1) PRIMARY KEY, quiz_attempt_id BIGINT NOT NULL, question_id BIGINT NOT NULL,
    selected_option_id BIGINT, is_correct BIT NOT NULL DEFAULT 0, score DECIMAL(5,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_quiz_answers_attempt FOREIGN KEY (quiz_attempt_id) REFERENCES quiz_attempts(id) ON DELETE CASCADE,
    CONSTRAINT fk_quiz_answers_question FOREIGN KEY (question_id) REFERENCES questions(id),
    CONSTRAINT fk_quiz_answers_option FOREIGN KEY (selected_option_id) REFERENCES answer_options(id),
    CONSTRAINT uq_quiz_answers_attempt_question UNIQUE (quiz_attempt_id, question_id)
);
GO

CREATE UNIQUE INDEX uq_registrations_payment_code ON registrations(payment_code) WHERE payment_code IS NOT NULL;
CREATE INDEX idx_courses_category_id ON courses(category_id);
CREATE INDEX idx_registrations_user_id ON registrations(user_id);
CREATE INDEX idx_registrations_course_id ON registrations(course_id);
CREATE INDEX idx_lesson_progress_registration_id ON lesson_progress(registration_id);
GO

INSERT INTO settings (type, name, value, priority, status, description) VALUES
('USER_ROLE', N'Guest', 'GUEST', 1, 'ACTIVE', N'Khách truy cập'),
('USER_ROLE', N'Student', 'STUDENT', 2, 'ACTIVE', N'Học viên'),
('USER_ROLE', N'Manager', 'MANAGER', 3, 'ACTIVE', N'Quản lý khóa học'),
('USER_ROLE', N'Expert', 'EXPERT', 4, 'ACTIVE', N'Chuyên gia nội dung'),
('USER_ROLE', N'Admin', 'ADMIN', 5, 'ACTIVE', N'Quản trị hệ thống'),
('COURSE_CATEGORY', N'Lập trình Web', 'WEB_DEV', 1, 'ACTIVE', N'Khóa học phát triển Web'),
('COURSE_CATEGORY', N'Khoa học Dữ liệu & AI', 'DATA_AI', 2, 'ACTIVE', N'Khóa học dữ liệu và AI'),
('COURSE_CATEGORY', N'Kỹ năng mềm', 'SOFT_SKILLS', 3, 'ACTIVE', N'Khóa học kỹ năng mềm');

INSERT INTO users (username, email, password_hash, full_name, role_id, role_type, auth_provider, status) VALUES
('admin', 'admin@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', N'Quản trị viên Hệ thống', 5, 'USER_ROLE', 'LOCAL', 'ACTIVE'),
('manager1', 'manager@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', N'Quản lý Khóa học', 3, 'USER_ROLE', 'LOCAL', 'ACTIVE'),
('expert1', 'expert@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', N'Chuyên gia Nội dung', 4, 'USER_ROLE', 'LOCAL', 'ACTIVE'),
('student1', 'student@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', N'Học viên Nguyễn Văn A', 2, 'USER_ROLE', 'LOCAL', 'ACTIVE');
GO
