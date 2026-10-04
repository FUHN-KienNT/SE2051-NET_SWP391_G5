-- Seed dynamic & diverse course categories into settings
INSERT INTO settings (type, name, value, priority, status, description)
VALUES 
('COURSE_CATEGORY', 'Lập trình Di động (Mobile App)', 'MOBILE_DEV', 7, 'ACTIVE', 'Phát triển ứng dụng di động Flutter, React Native, iOS, Android'),
('COURSE_CATEGORY', 'An ninh Mạng & Bảo mật (Cybersecurity)', 'CYBER_SECURITY', 8, 'ACTIVE', 'Bảo mật hệ thống, an toàn thông tin, kiểm thử xâm nhập'),
('COURSE_CATEGORY', 'DevOps & Điện toán Đám mây (Cloud)', 'DEVOPS_CLOUD', 9, 'ACTIVE', 'AWS, Azure, Docker, Kubernetes, CI/CD Pipelines'),
('COURSE_CATEGORY', 'Thiết kế Đồ họa & UI/UX', 'DESIGN_UIUX', 10, 'ACTIVE', 'Figma, Adobe Photoshop, Illustrator, UI/UX Design'),
('COURSE_CATEGORY', 'Marketing Kỹ thuật số (Digital Marketing)', 'DIGITAL_MARKETING', 11, 'ACTIVE', 'SEO, SEM, Social Media Marketing, Content Marketing'),
('COURSE_CATEGORY', 'Kinh doanh & Quản trị Doanh nghiệp', 'BUSINESS_MGMT', 12, 'ACTIVE', 'Khởi nghiệp, quản trị vận hành, lãnh đạo doanh nghiệp'),
('COURSE_CATEGORY', 'Ngoại ngữ & Luyện thi', 'LANGUAGES', 13, 'ACTIVE', 'Tiếng Anh giao tiếp, luyện thi IELTS, TOEIC, Tiếng Nhật, Hàn'),
('COURSE_CATEGORY', 'Tài chính & Đầu tư Cá nhân', 'FINANCE_INVEST', 14, 'ACTIVE', 'Quản lý tài chính cá nhân, đầu tư chứng khoán'),
('COURSE_CATEGORY', 'Nhiếp ảnh & Sản xuất Video', 'PHOTO_VIDEO', 15, 'ACTIVE', 'Quay dựng phim, biên tập video CapCut, Premiere, nhiếp ảnh'),
('COURSE_CATEGORY', 'Âm nhạc & Nghệ thuật', 'MUSIC_ART', 16, 'ACTIVE', 'Thanh nhạc, piano, guitar, hội họa')
ON CONFLICT (type, name) DO NOTHING;
