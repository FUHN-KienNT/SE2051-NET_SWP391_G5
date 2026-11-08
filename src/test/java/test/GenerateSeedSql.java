package test;

import org.junit.jupiter.api.Test;
import service.CourseService;
import dto.LessonDto;
import util.DbConnection;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class GenerateSeedSql {

    private String sqlEscape(String s) {
        if (s == null) return "";
        return s.replace("'", "''").trim();
    }

    private static class CourseConfig {
        int id;
        String title;
        String categoryValue;
        String description;
        double price;
        String status;
        String moderationNote;
        String archiveNotice;
        boolean isFeatured;
        CourseService.YoutubePlaylistData playlistData;
        String[] chapterNames;
    }

    @Test
    public void generateAndApplyMasterSeed() throws Exception {
        System.out.println("Fetching all 8 real playlists from YouTube...");

        CourseService.YoutubePlaylistData plPhysiognomy = CourseService.fetchYoutubePlaylistData("PLgw7NgEtgW9GgLhLHr_4_aTweO43fc1NZ"); // Course 1: Nhân tướng học (17 videos)
        CourseService.YoutubePlaylistData plPython       = CourseService.fetchYoutubePlaylistData("PLNcg_FV9n7qZGfFl2ANI_zISzNp257Lwn"); // Course 2: Python (47 videos)
        CourseService.YoutubePlaylistData plAstrology    = CourseService.fetchYoutubePlaylistData("PLE9UreaMKBTddxDZmBRONm4_rtKiWdcEt"); // Course 3: 12 Cung hoàng đạo (12 videos - Draft rejected)
        CourseService.YoutubePlaylistData plJavaSpring   = CourseService.fetchYoutubePlaylistData("PL2xsxmVse9IaxzE8Mght4CFltGOqcG6FC"); // Course 4: Java Spring Boot 3 (35 videos - Pending review)
        CourseService.YoutubePlaylistData plDotNet       = CourseService.fetchYoutubePlaylistData("PLRLJQuuRRcFlaITD5F6XKQJxOt8QgCNAg"); // Course 5: .NET (41 videos - Pending payment 299k)
        CourseService.YoutubePlaylistData plChinese      = CourseService.fetchYoutubePlaylistData("PLbGRE6dBnYmIqmsQO3u-7DJzwt7IC6X6W"); // Course 6: Tiếng Trung (74 videos - Paid 350k)
        CourseService.YoutubePlaylistData plPsychology   = CourseService.fetchYoutubePlaylistData("PLiQu6a8739oGBO6dtC-pQWh38R_Ia5YBs"); // Course 7: Tâm lý học (18 videos - Completed 100%)
        CourseService.YoutubePlaylistData plMusic        = CourseService.fetchYoutubePlaylistData("PLWZbSylYag6FZRqeLHNjmIr2Lb1TLWLbD"); // Course 8: Nhạc lý Guitar (51 videos - Archived)

        List<CourseConfig> configs = new ArrayList<>();

        // Course 1
        CourseConfig c1 = new CourseConfig();
        c1.id = 1;
        c1.title = "Nhân Tướng Học Thầy Viên Minh - Khái Niệm Nền Tảng Đến Ứng Dụng";
        c1.categoryValue = "PHYSIOGNOMY";
        c1.description = "Khóa học Nhân tướng học ứng dụng do Thầy Viên Minh trực tiếp giảng dạy. Hướng dẫn toàn diện phương pháp quan sát diện mạo, cốt cách, thần thái và ngũ quan ứng dụng trong đời sống.";
        c1.price = 0;
        c1.status = "PUBLISHED";
        c1.isFeatured = true;
        c1.playlistData = plPhysiognomy;
        c1.chapterNames = new String[]{
            "Chương 1: Cốt cách & Nền tảng Nhân tướng học",
            "Chương 2: Luận giải Ngũ quan & Thần khí Ứng dụng"
        };
        configs.add(c1);

        // Course 2
        CourseConfig c2 = new CourseConfig();
        c2.id = 2;
        c2.title = "Python Ultimate Course - Từ Cơ Bản Đến Nâng Cao";
        c2.categoryValue = "PROGRAMMING";
        c2.description = "Khóa học Python trực quan số 1 từ cơ bản đến nâng cao. Giảng dạy chi tiết cú pháp, biến, kiểu dữ liệu, cấu trúc điều khiển, vòng lặp, hàm và tư duy thuật toán bằng Python.";
        c2.price = 0;
        c2.status = "PUBLISHED";
        c2.isFeatured = true;
        c2.playlistData = plPython;
        c2.chapterNames = new String[]{
            "Chương 1: Nhập môn & Cài đặt môi trường Python",
            "Chương 2: Biến, Kiểu dữ liệu & Chuỗi ký tự",
            "Chương 3: Cấu trúc điều khiển & Vòng lặp For / While",
            "Chương 4: Hàm, Module & Cấu trúc dữ liệu nâng cao",
            "Chương 5: Lập trình hướng đối tượng & Xử lý lỗi"
        };
        configs.add(c2);

        // Course 3
        CourseConfig c3 = new CourseConfig();
        c3.id = 3;
        c3.title = "Bí Mật Tính Cách & Chiêm Tinh 12 Cung Hoàng Đạo";
        c3.categoryValue = "ASTROLOGY";
        c3.description = "Khám phá thế giới chiêm tinh học phương Tây qua 12 chòm sao hoàng đạo: tính cách cốt lõi, điểm mạnh yếu, xu hướng tình cảm và con đường sự nghiệp.";
        c3.price = 0;
        c3.status = "DRAFT";
        c3.moderationNote = "Khóa học chưa đạt yêu cầu kiểm duyệt: Chương 1 còn thiếu bài tập trắc nghiệm và mô tả chi tiết của từng cung. Đề nghị Chuyên gia bổ sung trước khi gửi duyệt lại.";
        c3.isFeatured = false;
        c3.playlistData = plAstrology;
        c3.chapterNames = new String[]{
            "Chương 1: Các Cung Hoàng Đạo Tiên Phong (Lửa & Đất)",
            "Chương 2: Các Cung Hoàng Đạo Kiên Định & Biến Đổi (Khí & Nước)"
        };
        configs.add(c3);

        // Course 4
        CourseConfig c4 = new CourseConfig();
        c4.id = 4;
        c4.title = "Lộ Trình Java Spring Boot 3 Cho Người Mới Bắt Đầu";
        c4.categoryValue = "PROGRAMMING";
        c4.description = "Lộ trình lập trình backend Java Spring Boot 3 bài bản nhất: Dependency Injection, Spring Data JPA, Hibernate, RESTful API và Spring Security 6.";
        c4.price = 199000;
        c4.status = "PENDING_REVIEW";
        c4.isFeatured = false;
        c4.playlistData = plJavaSpring;
        c4.chapterNames = new String[]{
            "Chương 1: Nền tảng Java Core & Cài đặt Spring Boot 3",
            "Chương 2: Spring Data JPA, Hibernate & CSDL Quan hệ",
            "Chương 3: Xây dựng RESTful API & Service Layer",
            "Chương 4: Bảo mật với Spring Security & Triển khai thực chiến"
        };
        configs.add(c4);

        // Course 5
        CourseConfig c5 = new CourseConfig();
        c5.id = 5;
        c5.title = "Học Lập Trình .NET & C# Nền Tảng Đến Chuyên Sâu";
        c5.categoryValue = "PROGRAMMING";
        c5.description = "Học lập trình nền tảng .NET và ngôn ngữ C# hiện đại. Tự tay xây dựng ứng dụng console, Web API với ASP.NET Core và Entity Framework Core.";
        c5.price = 299000;
        c5.status = "PUBLISHED";
        c5.isFeatured = true;
        c5.playlistData = plDotNet;
        c5.chapterNames = new String[]{
            "Chương 1: Làm quen .NET & Cài đặt Visual Studio",
            "Chương 2: Cú pháp ngôn ngữ C# & Kiểu dữ liệu nền tảng",
            "Chương 3: Lập trình hướng đối tượng OOP với C#",
            "Chương 4: Xây dựng ứng dụng & Web API với .NET Core"
        };
        configs.add(c5);

        // Course 6
        CourseConfig c6 = new CourseConfig();
        c6.id = 6;
        c6.title = "Nhập Môn Tự Học Tiếng Trung Từ Con Số 0";
        c6.categoryValue = "LANGUAGES";
        c6.description = "Khóa học tiếng Trung sơ cấp chi tiết và dễ hiểu nhất: hệ thống phiên âm Pinyin, 4 thanh điệu, quy tắc viết chữ Hán và các câu giao tiếp căn bản.";
        c6.price = 350000;
        c6.status = "PUBLISHED";
        c6.isFeatured = true;
        c6.playlistData = plChinese;
        c6.chapterNames = new String[]{
            "Chương 1: Hệ thống Phiên âm Pinyin & Bảng chữ cái",
            "Chương 2: 4 Thanh điệu & Kỹ thuật phát âm chuẩn",
            "Chương 3: Quy tắc viết các nét cơ bản chữ Hán",
            "Chương 4: Các bộ thủ chữ Hán thông dụng",
            "Chương 5: Từ vựng & Đàm thoại giao tiếp sơ cấp (Phần 1)",
            "Chương 6: Từ vựng & Đàm thoại giao tiếp sơ cấp (Phần 2)",
            "Chương 7: Ngữ pháp căn bản & Đàm thoại thực tế"
        };
        configs.add(c6);

        // Course 7
        CourseConfig c7 = new CourseConfig();
        c7.id = 7;
        c7.title = "Tâm Lý Học Đại Cương: Bản Chất Con Người & Hành Vi";
        c7.categoryValue = "SOFT_SKILLS";
        c7.description = "Nghiên cứu bản chất hiện tượng tâm lý người, quy luật cảm giác, tri giác, trí nhớ, tư duy, cảm xúc, khí chất và cấu trúc nhân cách.";
        c7.price = 199000;
        c7.status = "PUBLISHED";
        c7.isFeatured = false;
        c7.playlistData = plPsychology;
        c7.chapterNames = new String[]{
            "Chương 1: Bản chất hiện tượng tâm lý người & Nhận thức cảm tính",
            "Chương 2: Quá trình nhận thức lý tính, Cảm xúc & Nhân cách"
        };
        configs.add(c7);

        // Course 8
        CourseConfig c8 = new CourseConfig();
        c8.id = 8;
        c8.title = "Khóa Học Nhạc Lý Cơ Bản & Thực Hành Guitar";
        c8.categoryValue = "ART_CREATIVE";
        c8.description = "Khóa học nhạc lý bài bản kết hợp thực hành guitar. Khóa học đã lưu trữ nội dung và đóng cổng đăng ký mới. Học viên đã sở hữu được học tập trọn đời.";
        c8.price = 0;
        c8.status = "ARCHIVED";
        c8.archiveNotice = "Khóa học đã đóng đăng ký mới. Học viên đã sở hữu có quyền truy cập học tập trọn đời.";
        c8.isFeatured = false;
        c8.playlistData = plMusic;
        c8.chapterNames = new String[]{
            "Chương 1: Khuông nhạc, Khóa nhạc & Nhịp phách",
            "Chương 2: Cao độ, Trường độ & Vị trí nốt trên cần đàn",
            "Chương 3: Đọc tiết tấu, nốt móc đơn & móc kép",
            "Chương 4: Chùm nốt, dấu hóa & đảo phách",
            "Chương 5: Điệu thức, hợp âm & thực hành đệm hát"
        };
        configs.add(c8);

        StringBuilder sb = new StringBuilder();
        sb.append("-- =====================================================================\n");
        sb.append("-- COURSON LMS - MASTER TESTING SEED (CHÍNH THỨC VỚI 100% VIDEO THẬT TỪ 8 PLAYLISTS)\n");
        sb.append("-- Tổng cộng trích xuất đầy đủ 295 bài học từ 8 Playlist YouTube thật.\n");
        sb.append("-- =====================================================================\n\n");
        sb.append("BEGIN;\n\n");

        sb.append("-- 1. Thiết lập danh mục hệ thống\n");
        sb.append("INSERT INTO settings (type, name, value, priority, status, description) VALUES\n");
        sb.append("    ('COURSE_CATEGORY', 'Lập trình',               'PROGRAMMING',  1, 'ACTIVE', 'Phát triển phần mềm, web, kiến trúc hệ thống và AI'),\n");
        sb.append("    ('COURSE_CATEGORY', 'Nhân tướng học',         'PHYSIOGNOMY',  2, 'ACTIVE', 'Nhân tướng học, quan sát diện mạo và nhân trắc học ứng dụng'),\n");
        sb.append("    ('COURSE_CATEGORY', 'Chiêm tinh học',         'ASTROLOGY',    3, 'ACTIVE', 'Bí mật 12 cung hoàng đạo, các hành tinh và chiêm tinh'),\n");
        sb.append("    ('COURSE_CATEGORY', 'Tâm lý & Kỹ năng mềm',    'SOFT_SKILLS',  4, 'ACTIVE', 'Tâm lý học đại cương, hành vi con người và kỹ năng'),\n");
        sb.append("    ('COURSE_CATEGORY', 'Ngoại ngữ',              'LANGUAGES',    5, 'ACTIVE', 'Tiếng Anh, Tiếng Trung, Tiếng Nhật, Ngoại ngữ giao tiếp'),\n");
        sb.append("    ('COURSE_CATEGORY', 'Nghệ thuật & Sáng tạo',   'ART_CREATIVE', 6, 'ACTIVE', 'Nhạc lý, guitar, thanh nhạc, sáng tác và nghệ thuật')\n");
        sb.append("ON CONFLICT (type, name) DO NOTHING;\n\n");

        sb.append("-- 2. Dọn dẹp dữ liệu cũ theo ràng buộc khóa ngoại\n");
        sb.append("DELETE FROM quiz_answers;\n");
        sb.append("DELETE FROM quiz_attempts;\n");
        sb.append("DELETE FROM lesson_progress;\n");
        sb.append("DELETE FROM registrations;\n");
        sb.append("DELETE FROM quiz_questions;\n");
        sb.append("DELETE FROM answer_options;\n");
        sb.append("DELETE FROM questions;\n");
        sb.append("DELETE FROM quizzes;\n");
        sb.append("DELETE FROM lessons;\n");
        sb.append("DELETE FROM modules;\n");
        sb.append("DELETE FROM courses;\n");
        sb.append("DELETE FROM password_reset_tokens;\n");
        sb.append("DELETE FROM email_verification_tokens;\n\n");

        sb.append("-- 3. Khởi tạo 5 tài khoản thử nghiệm chuẩn (mật khẩu: '123' hoặc 'admin123')\n");
        sb.append("DELETE FROM users WHERE id IN (1, 2, 3, 4, 5);\n");
        sb.append("INSERT INTO users (id, username, email, password_hash, full_name, role_id, role_type, auth_provider, status, phone, birth_date) VALUES\n");
        sb.append("    (1, 'admin', 'admin@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', 'Quản trị viên Hệ thống', 5, 'USER_ROLE', 'LOCAL', 'ACTIVE', '0901234567', '1990-01-01'),\n");
        sb.append("    (2, 'manager1', 'manager@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', 'Quản lý Khóa học', 3, 'USER_ROLE', 'LOCAL', 'ACTIVE', '0912345678', '1992-05-15'),\n");
        sb.append("    (3, 'expert1', 'expert@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', 'Chuyên gia Giảng viên', 4, 'USER_ROLE', 'LOCAL', 'ACTIVE', '0923456789', '1988-10-20'),\n");
        sb.append("    (4, 'student1', 'student@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', 'Nguyễn Văn A', 2, 'USER_ROLE', 'LOCAL', 'ACTIVE', '0934567890', '2002-12-12'),\n");
        sb.append("    (5, 'student2', 'student2@courson.edu.vn', '$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS', 'Trần Thị B', 2, 'USER_ROLE', 'LOCAL', 'ACTIVE', '0945678901', '2003-08-20')\n");
        sb.append("ON CONFLICT (id) DO UPDATE SET password_hash = EXCLUDED.password_hash, status = 'ACTIVE';\n\n");

        int globalModuleId = 1;
        int globalLessonId = 1;

        // Lưu danh sách lesson ID theo từng course để thiết lập progress chính xác
        List<List<Integer>> courseLessonIds = new ArrayList<>();
        for (int i = 0; i <= 8; i++) {
            courseLessonIds.add(new ArrayList<>());
        }

        // Tạo 8 Khóa học
        for (CourseConfig cfg : configs) {
            sb.append("-- COURSE ").append(cfg.id).append(": ").append(cfg.title).append(" [").append(cfg.status).append("]\n");
            sb.append("INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, ");
            if (cfg.moderationNote != null) sb.append("moderation_note, ");
            if (cfg.archiveNotice != null) sb.append("archive_at, archive_notice, ");
            sb.append("is_featured, created_at, updated_at)\n");

            sb.append("VALUES (").append(cfg.id).append(", '").append(sqlEscape(cfg.title)).append("',\n");
            sb.append("        (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = '").append(cfg.categoryValue).append("' LIMIT 1),\n");
            sb.append("        'COURSE_CATEGORY',\n");
            sb.append("        '").append(sqlEscape(cfg.description)).append("',\n");
            sb.append("        ").append((long) cfg.price).append(", '").append(cfg.status).append("', 2, 3, ");
            if (cfg.moderationNote != null) {
                sb.append("'").append(sqlEscape(cfg.moderationNote)).append("', ");
            }
            if (cfg.archiveNotice != null) {
                sb.append("now() - interval '1 month', '").append(sqlEscape(cfg.archiveNotice)).append("', ");
            }
            sb.append(cfg.isFeatured).append(", now() - interval '30 days', now() - interval '2 days');\n\n");

            List<LessonDto> lessons = cfg.playlistData.getLessons();
            int totalLessonsInPl = lessons.size();
            int numChapters = cfg.chapterNames.length;
            int baseSize = totalLessonsInPl / numChapters;
            int remainder = totalLessonsInPl % numChapters;

            int lessonIdx = 0;
            List<Integer> thisCourseLessons = courseLessonIds.get(cfg.id);

            for (int chap = 0; chap < numChapters; chap++) {
                int modId = globalModuleId++;
                int chapSize = baseSize + (chap < remainder ? 1 : 0);

                sb.append("INSERT INTO modules (id, course_id, title, order_index, created_at) VALUES\n");
                sb.append("    (").append(modId).append(", ").append(cfg.id).append(", '").append(sqlEscape(cfg.chapterNames[chap])).append("', ").append(chap + 1).append(", now() - interval '30 days');\n\n");

                sb.append("INSERT INTO lessons (id, module_id, title, content, video_url, order_index, is_active, created_at, updated_at) VALUES\n");
                for (int order = 1; order <= chapSize; order++) {
                    LessonDto dto = lessons.get(lessonIdx++);
                    int lId = globalLessonId++;
                    thisCourseLessons.add(lId);

                    sb.append("    (").append(lId).append(", ").append(modId).append(", '")
                            .append(sqlEscape(dto.getTitle())).append("', '<p>Bài học trực tuyến trích xuất từ khóa học chính thức: ")
                            .append(sqlEscape(dto.getTitle())).append("</p>', '")
                            .append(dto.getVideoUrl()).append("', ").append(order).append(", true, now() - interval '30 days', now())");

                    if (order < chapSize) {
                        sb.append(",\n");
                    } else {
                        sb.append(";\n\n");
                    }
                }
            }
        }

        // Quizzes cho Course 1 và Course 7
        sb.append("-- QUIZZES CHO COURSE 1 VÀ COURSE 7\n");
        sb.append("INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)\n");
        sb.append("VALUES (1, 1, 'Trắc nghiệm: Kiến thức Nền tảng Nhân tướng', 75, 15, 1, now() - interval '10 days', now()),\n");
        sb.append("       (2, (SELECT id FROM modules WHERE course_id = 7 ORDER BY id DESC LIMIT 1), 'Đánh giá cuối khóa: Bản chất Tâm lý học', 80, 20, 1, now() - interval '15 days', now());\n\n");

        sb.append("INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at) VALUES\n");
        sb.append("    (1, 1, 'Trong nhân tướng học, yếu tố nào phản ánh nội tâm sâu sắc nhất?', 'SINGLE_CHOICE', 50, now()),\n");
        sb.append("    (2, 1, 'Thần khí tốt thể hiện qua đặc điểm nào sau đây?', 'SINGLE_CHOICE', 50, now()),\n");
        sb.append("    (3, (SELECT id FROM modules WHERE course_id = 7 ORDER BY id DESC LIMIT 1), 'Tâm lý người có nguồn gốc cốt lõi từ đâu?', 'SINGLE_CHOICE', 100, now());\n\n");

        sb.append("INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES\n");
        sb.append("    (1, 1, 'Ánh mắt và thần sắc', true, 1),\n");
        sb.append("    (2, 1, 'Trang phục bên ngoài', false, 2),\n");
        sb.append("    (3, 1, 'Chiều cao cơ thể', false, 3),\n");
        sb.append("    (4, 1, 'Màu tóc', false, 4),\n");
        sb.append("    (5, 2, 'Ánh mắt sáng, điềm tĩnh và giọng nói rõ ràng', true, 1),\n");
        sb.append("    (6, 2, 'Ánh mắt đảo liên tục', false, 2),\n");
        sb.append("    (7, 2, 'Nói năng hấp tấp', false, 3),\n");
        sb.append("    (8, 2, 'Sắc diện u tối', false, 4),\n");
        sb.append("    (9, 3, 'Hiện thực khách quan phản ánh qua não bộ con người', true, 1),\n");
        sb.append("    (10, 3, 'Tự nhiên sinh ra không chịu ảnh hưởng từ môi trường', false, 2),\n");
        sb.append("    (11, 3, 'Chỉ do gen di truyền quyết định hoàn toàn', false, 3),\n");
        sb.append("    (12, 3, 'Không có nguồn gốc rõ ràng', false, 4);\n\n");

        sb.append("INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points) VALUES\n");
        sb.append("    (1, 1, 1, 1, 1, 50),\n");
        sb.append("    (2, 1, 2, 1, 2, 50),\n");
        sb.append("    (3, 2, 3, (SELECT id FROM modules WHERE course_id = 7 ORDER BY id DESC LIMIT 1), 1, 100);\n\n");

        // Registrations & Progress cho student1
        List<Integer> c1Lessons = courseLessonIds.get(1); // 17 bài
        List<Integer> c3Lessons = courseLessonIds.get(3); // 12 bài
        List<Integer> c7Lessons = courseLessonIds.get(7); // 18 bài
        List<Integer> c8Lessons = courseLessonIds.get(8); // 51 bài

        // Course 1: đã hoàn thành 8 bài trên tổng 17 bài
        double c1Pct = Math.round((8.0 / c1Lessons.size()) * 10000.0) / 100.0;
        // Course 3: đã hoàn thành 2 bài trên tổng 12 bài
        double c3Pct = Math.round((2.0 / c3Lessons.size()) * 10000.0) / 100.0;
        // Course 7: hoàn thành 100%
        double c7Pct = 100.00;
        // Course 8: đã hoàn thành 10 bài trên tổng 51 bài
        double c8Pct = Math.round((10.0 / c8Lessons.size()) * 10000.0) / 100.0;

        sb.append("-- REGISTRATIONS & TIẾN ĐỘ THỰC TẾ CỦA STUDENT1\n");
        sb.append("INSERT INTO registrations (id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at) VALUES\n");
        sb.append("    (1, 4, 1, now() - interval '10 days', ").append(c1Pct).append(", 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '10 days'),\n");
        sb.append("    (2, 4, 3, now() - interval '8 days',  ").append(c3Pct).append(", 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '8 days'),\n");
        sb.append("    (3, 4, 5, now() - interval '2 days',    0.00,  'PENDING',   'VNPAY',  'VNP_TEST_PENDING', 299000, 'PENDING', NULL),\n");
        sb.append("    (4, 4, 7, now() - interval '20 days',").append(c7Pct).append(", 'COMPLETED', 'VNPAY',  'VNP_TEST_SUCCESS', 199000, 'SUCCESS', now() - interval '20 days'),\n");
        sb.append("    (5, 4, 8, now() - interval '40 days', ").append(c8Pct).append(", 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '40 days');\n\n");

        // Tiến độ Course 1: 8 bài completed, bài thứ 9 in-progress
        sb.append("-- Tiến độ chi tiết Course 1 (8 bài COMPLETED, 1 bài IN_PROGRESS)\n");
        sb.append("INSERT INTO lesson_progress (registration_id, lesson_id, status, user_note, updated_at, completed_at) VALUES\n");
        for (int i = 0; i < 8; i++) {
            sb.append("    (1, ").append(c1Lessons.get(i)).append(", 'COMPLETED', 'Đã hoàn thành xuất sắc bài học số ")
                    .append(i + 1).append(".', now() - interval '").append(8 - i).append(" days', now() - interval '")
                    .append(8 - i).append(" days'),\n");
        }
        sb.append("    (1, ").append(c1Lessons.get(8)).append(", 'IN_PROGRESS', 'Đang học dở bài số 9...', now() - interval '2 hours', NULL);\n\n");

        // Tiến độ Course 3: 2 bài completed, bài 3 in-progress
        sb.append("-- Tiến độ chi tiết Course 3 (2 bài COMPLETED, 1 bài IN_PROGRESS)\n");
        sb.append("INSERT INTO lesson_progress (registration_id, lesson_id, status, user_note, updated_at, completed_at) VALUES\n");
        sb.append("    (2, ").append(c3Lessons.get(0)).append(", 'COMPLETED', 'Đã ghi nhớ tính cách cung Bạch Dương', now() - interval '5 days', now() - interval '5 days'),\n");
        sb.append("    (2, ").append(c3Lessons.get(1)).append(", 'COMPLETED', 'Đã ghi nhớ tính cách cung Kim Ngưu', now() - interval '4 days', now() - interval '4 days'),\n");
        sb.append("    (2, ").append(c3Lessons.get(2)).append(", 'IN_PROGRESS', 'Đang khám phá cung Song Tử', now() - interval '1 hour', NULL);\n\n");

        // Tiến độ Course 7: Toàn bộ 18 bài COMPLETED!
        sb.append("-- Tiến độ chi tiết Course 7 (Hoàn thành 100% - toàn bộ ").append(c7Lessons.size()).append(" bài)\n");
        sb.append("INSERT INTO lesson_progress (registration_id, lesson_id, status, user_note, updated_at, completed_at) VALUES\n");
        for (int i = 0; i < c7Lessons.size(); i++) {
            sb.append("    (4, ").append(c7Lessons.get(i)).append(", 'COMPLETED', 'Đã hoàn thành bài học số ")
                    .append(i + 1).append(" trong giáo trình.', now() - interval '").append(18 - i).append(" days', now() - interval '")
                    .append(18 - i).append(" days')");
            if (i < c7Lessons.size() - 1) {
                sb.append(",\n");
            } else {
                sb.append(";\n\n");
            }
        }

        // Tiến độ Course 8: 10 bài completed
        sb.append("-- Tiến độ chi tiết Course 8 (10 bài COMPLETED, 1 bài IN_PROGRESS)\n");
        sb.append("INSERT INTO lesson_progress (registration_id, lesson_id, status, user_note, updated_at, completed_at) VALUES\n");
        for (int i = 0; i < 10; i++) {
            sb.append("    (5, ").append(c8Lessons.get(i)).append(", 'COMPLETED', 'Đã nắm vững kỹ năng nhạc lý bài ")
                    .append(i + 1).append(".', now() - interval '").append(30 - i * 2).append(" days', now() - interval '")
                    .append(30 - i * 2).append(" days'),\n");
        }
        sb.append("    (5, ").append(c8Lessons.get(10)).append(", 'IN_PROGRESS', 'Đang luyện tập bài 11...', now() - interval '1 day', NULL);\n\n");

        // Lịch sử làm bài trắc nghiệm
        sb.append("-- LỊCH SỬ TRẮC NGHIỆM CỦA STUDENT1\n");
        sb.append("INSERT INTO quiz_attempts (id, registration_id, quiz_id, submitted_at, total_score, pass_status) VALUES\n");
        sb.append("    (1, 1, 1, now() - interval '5 days', 100.00, true),\n");
        sb.append("    (2, 4, 2, now() - interval '1 day', 100.00, true);\n\n");
        sb.append("INSERT INTO quiz_answers (quiz_attempt_id, question_id, selected_option_id, is_correct, score) VALUES\n");
        sb.append("    (1, 1, 1, true, 50.00),\n");
        sb.append("    (1, 2, 5, true, 50.00),\n");
        sb.append("    (2, 3, 9, true, 100.00);\n\n");

        // Đồng bộ sequence
        sb.append("-- ĐỒNG BỘ LẠI SEQUENCE POSTGRESQL\n");
        sb.append("SELECT setval(pg_get_serial_sequence('users', 'id'), COALESCE((SELECT MAX(id) FROM users), 1));\n");
        sb.append("SELECT setval(pg_get_serial_sequence('courses', 'id'), COALESCE((SELECT MAX(id) FROM courses), 1));\n");
        sb.append("SELECT setval(pg_get_serial_sequence('modules', 'id'), COALESCE((SELECT MAX(id) FROM modules), 1));\n");
        sb.append("SELECT setval(pg_get_serial_sequence('lessons', 'id'), COALESCE((SELECT MAX(id) FROM lessons), 1));\n");
        sb.append("SELECT setval(pg_get_serial_sequence('registrations', 'id'), COALESCE((SELECT MAX(id) FROM registrations), 1));\n");
        sb.append("SELECT setval(pg_get_serial_sequence('quizzes', 'id'), COALESCE((SELECT MAX(id) FROM quizzes), 1));\n");
        sb.append("SELECT setval(pg_get_serial_sequence('questions', 'id'), COALESCE((SELECT MAX(id) FROM questions), 1));\n");
        sb.append("SELECT setval(pg_get_serial_sequence('answer_options', 'id'), COALESCE((SELECT MAX(id) FROM answer_options), 1));\n");
        sb.append("SELECT setval(pg_get_serial_sequence('quiz_questions', 'id'), COALESCE((SELECT MAX(id) FROM quiz_questions), 1));\n");
        sb.append("SELECT setval(pg_get_serial_sequence('quiz_attempts', 'id'), COALESCE((SELECT MAX(id) FROM quiz_attempts), 1));\n");
        sb.append("SELECT setval(pg_get_serial_sequence('quiz_answers', 'id'), COALESCE((SELECT MAX(id) FROM quiz_answers), 1));\n");
        sb.append("SELECT setval(pg_get_serial_sequence('lesson_progress', 'id'), COALESCE((SELECT MAX(id) FROM lesson_progress), 1));\n\n");

        sb.append("COMMIT;\n");

        String sql = sb.toString();

        // 1. Write to database/seed_test_master.sql
        File f1 = new File("database/seed_test_master.sql");
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(f1), StandardCharsets.UTF_8)) {
            writer.write(sql);
        }
        System.out.println("Written to " + f1.getAbsolutePath());

        // 2. Write to src/main/resources/database/seed_test_master.sql
        File f2 = new File("src/main/resources/database/seed_test_master.sql");
        f2.getParentFile().mkdirs();
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(f2), StandardCharsets.UTF_8)) {
            writer.write(sql);
        }
        System.out.println("Written to " + f2.getAbsolutePath());

        // 3. Write to Tomcat webapps
        File f3 = new File("C:/Program Files/Apache Software Foundation/Tomcat 10.1/webapps/Courson/WEB-INF/classes/database/seed_test_master.sql");
        if (f3.getParentFile().exists()) {
            try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(f3), StandardCharsets.UTF_8)) {
                writer.write(sql);
            }
            System.out.println("Written to " + f3.getAbsolutePath());
        }

        // 4. Execute on PostgreSQL
        System.out.println("Executing full seed SQL on courson_db...");
        try (Connection conn = DbConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("ALL 295 REAL LESSONS SUCCESSFULLY IMPORTED INTO DATABASE!");
        }
    }
}
