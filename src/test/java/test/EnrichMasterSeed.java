package test;

import org.junit.jupiter.api.Test;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Statement;
import util.DbConnection;

public class EnrichMasterSeed {

    private static class ModuleInfo {
        int id;
        int courseId;
        String name;
        String q1Text;
        String q1Opt1, q1Opt2, q1Opt3, q1Opt4;
        String q2Text;
        String q2Opt1, q2Opt2, q2Opt3, q2Opt4;

        ModuleInfo(int id, int courseId, String name,
                   String q1Text, String q1Opt1, String q1Opt2, String q1Opt3, String q1Opt4,
                   String q2Text, String q2Opt1, String q2Opt2, String q2Opt3, String q2Opt4) {
            this.id = id;
            this.courseId = courseId;
            this.name = name;
            this.q1Text = q1Text;
            this.q1Opt1 = q1Opt1; this.q1Opt2 = q1Opt2; this.q1Opt3 = q1Opt3; this.q1Opt4 = q1Opt4;
            this.q2Text = q2Text;
            this.q2Opt1 = q2Opt1; this.q2Opt2 = q2Opt2; this.q2Opt3 = q2Opt3; this.q2Opt4 = q2Opt4;
        }
    }

    @Test
    public void generateEnrichedMasterSeed() throws Exception {
        ModuleInfo[] modules = new ModuleInfo[] {
            // Course 1: Nhân tướng học
            new ModuleInfo(1, 1, "Cốt cách & Nền tảng Nhân tướng học",
                "Trong nhân tướng học, yếu tố nào phản ánh nội tâm sâu sắc nhất?", "Ánh mắt và thần sắc", "Trang phục bên ngoài", "Chiều cao cơ thể", "Màu tóc",
                "Thần khí tốt thể hiện qua đặc điểm nào sau đây?", "Ánh mắt sáng, điềm tĩnh và giọng nói rõ ràng", "Ánh mắt đảo liên tục", "Nói năng hấp tấp", "Sắc diện u tối"),
            new ModuleInfo(2, 1, "Luận giải Ngũ quan & Thần khí Ứng dụng",
                "Ngũ quan trong nhân tướng học bao gồm những bộ phận nào?", "Mắt, tai, mũi, miệng, lông mày", "Trán, cằm, má, mũi, mắt", "Tóc, tai, mắt, miệng, răng", "Mũi, họng, mắt, trán, cằm",
                "Cung Tài Bạch trên khuôn mặt nằm ở vị trí nào?", "Đỉnh mũi và hai cánh mũi", "Ấn đường giữa hai lông mày", "Nhân trung dưới mũi", "Địa các vùng cằm"),

            // Course 2: Python
            new ModuleInfo(3, 2, "Nhập môn & Cài đặt môi trường Python",
                "Phần mở rộng chuẩn của tệp mã nguồn Python là gì?", ".py", ".python", ".pt", ".pyw",
                "Lệnh nào dùng để in dữ liệu ra màn hình console trong Python?", "print()", "System.out.println()", "console.log()", "echo()"),
            new ModuleInfo(4, 2, "Biến, Kiểu dữ liệu & Chuỗi ký tự",
                "Kiểu dữ liệu nào trong Python là danh sách có thể thay đổi (mutable)?", "list", "tuple", "str", "int",
                "Cách lấy độ dài của một chuỗi hoặc danh sách trong Python là gì?", "len()", "size()", "length()", "count()"),
            new ModuleInfo(5, 2, "Cấu trúc điều khiển & Vòng lặp For / While",
                "Hàm nào tạo ra một dãy số tuần tự trong vòng lặp for?", "range()", "seq()", "series()", "list_range()",
                "Từ khóa nào dùng để thoát khỏi vòng lặp ngay lập tức?", "break", "continue", "pass", "exit"),
            new ModuleInfo(6, 2, "Hàm, Module & Cấu trúc dữ liệu nâng cao",
                "Từ khóa nào dùng để định nghĩa một hàm trong Python?", "def", "function", "func", "define",
                "Cấu trúc dữ liệu lưu trữ cặp khóa - giá trị (Key-Value) trong Python là gì?", "dict", "set", "tuple", "array"),
            new ModuleInfo(7, 2, "Lập trình hướng đối tượng & Xử lý lỗi",
                "Phương thức khởi tạo (constructor) của class trong Python có tên là gì?", "__init__", "__new__", "__construct__", "create()",
                "Khối lệnh nào dùng để bắt và xử lý ngoại lệ trong Python?", "try...except", "try...catch", "try...error", "check...handle"),

            // Course 3: Chiêm tinh 12 Cung Hoàng Đạo
            new ModuleInfo(8, 3, "Các Cung Hoàng Đạo Tiên Phong (Lửa & Đất)",
                "Cung hoàng đạo nào là thủ lĩnh nhóm nguyên tố Lửa?", "Bạch Dương (Aries)", "Kim Ngưu (Taurus)", "Song Tử (Gemini)", "Cự Giải (Cancer)",
                "Phẩm chất nổi bật nhất của cung Ma Kết (Capricorn) thuộc nhóm Đất là gì?", "Kỷ luật, kiên định và thực tế", "Nóng nảy bốc đồng", "Mơ mộng viển vông", "Thiếu quyết đoán"),
            new ModuleInfo(9, 3, "Các Cung Hoàng Đạo Kiên Định & Biến Đổi (Khí & Nước)",
                "Bảo Bình (Aquarius) thuộc nhóm nguyên tố nào trong vòng tròn Hoàng Đạo?", "Khí (Air)", "Nước (Water)", "Lửa (Fire)", "Đất (Earth)",
                "Đặc tính cảm xúc sâu sắc và trực giác nhạy bén là của nhóm nguyên tố nào?", "Nước (Water)", "Khí (Air)", "Đất (Earth)", "Lửa (Fire)"),

            // Course 4: Java Spring Boot 3
            new ModuleInfo(10, 4, "Nền tảng Java Core & Cài đặt Spring Boot 3",
                "Spring Boot 3 yêu cầu phiên bản Java tối thiểu nào?", "Java 17", "Java 8", "Java 11", "Java 14",
                "Annotation chính đặt trên class khởi chạy của ứng dụng Spring Boot là gì?", "@SpringBootApplication", "@EnableAutoConfiguration", "@Configuration", "@SpringBootApp"),
            new ModuleInfo(11, 4, "Spring Data JPA, Hibernate & CSDL Quan hệ",
                "Interface nền tảng trong Spring Data JPA cung cấp sẵn các hàm CRUD là gì?", "JpaRepository", "CrudService", "HibernateDao", "EntityManagerHelper",
                "Annotation nào dùng để đánh dấu một Entity ánh xạ bảng CSDL?", "@Entity", "@TableMapping", "@Model", "@DatabaseRecord"),
            new ModuleInfo(12, 4, "Xây dựng RESTful API & Service Layer",
                "Annotation nào kết hợp giữa @Controller và @ResponseBody?", "@RestController", "@ApiController", "@WebEndpoint", "@ServiceRest",
                "Phương thức HTTP nào chuẩn mực dùng để tạo mới tài nguyên?", "POST", "GET", "PUT", "PATCH"),
            new ModuleInfo(13, 4, "Bảo mật với Spring Security & Triển khai thực chiến",
                "Cơ chế nào thường dùng để xác thực không lưu trạng thái (Stateless) cho REST API?", "JWT (JSON Web Token)", "HTTP Basic Session", "Cookie Session ID", "Kerberos Ticket",
                "Annotation nào dùng để phân quyền trên từng phương thức Service?", "@PreAuthorize", "@SecureCheck", "@RoleAllowedOnly", "@PermitRole"),

            // Course 5: .NET & C#
            new ModuleInfo(14, 5, "Làm quen .NET & Cài đặt Visual Studio",
                "Môi trường thực thi mã trung gian (Intermediate Language) của .NET có tên là gì?", "CLR (Common Language Runtime)", "JVM", "V8 Engine", "Mono Hub",
                "Lệnh CLI nào tạo mới một dự án Web API trong .NET?", "dotnet new webapi", "dotnet create api", "dotnet init web", "dotnet make rest"),
            new ModuleInfo(15, 5, "Cú pháp ngôn ngữ C# & Kiểu dữ liệu nền tảng",
                "Từ khóa nào khai báo biến có thể tự suy luận kiểu dữ liệu tại thời điểm biên dịch trong C#?", "var", "dynamic", "auto", "val",
                "Kiểu dữ liệu nullable trong C# được khai báo bằng ký tự nào?", "int?", "int*", "int&", "int!"),
            new ModuleInfo(16, 5, "Lập trình hướng đối tượng OOP với C#",
                "Từ khóa nào dùng để cho phép phương thức ở lớp cha có thể bị ghi đè?", "virtual", "override", "abstract", "extendable",
                "C# hỗ trợ đa kế thừa trực tiếp từ nhiều lớp (class) không?", "Không, chỉ hỗ trợ đa kế thừa Interface", "Có, không giới hạn số lớp", "Có, tối đa 2 lớp", "Chỉ hỗ trợ khi dùng từ khóa partial"),
            new ModuleInfo(17, 5, "Xây dựng ứng dụng & Web API với .NET Core",
                "Tệp tin nào là điểm khởi đầu cấu hình Dependency Injection trong .NET 6/7/8?", "Program.cs", "Startup.cs", "Web.config", "App.json",
                "Interface nào dùng để đăng ký dịch vụ vòng đời theo từng HTTP Request trong .NET?", "AddScoped", "AddSingleton", "AddTransient", "AddScopedLifetime"),

            // Course 6: Tiếng Trung sơ cấp
            new ModuleInfo(18, 6, "Hệ thống Phiên âm Pinyin & Bảng chữ cái",
                "Pinyin trong tiếng Trung dùng để làm gì?", "Ghi lại cách phát âm bằng ký tự Latinh", "Quy định nét vẽ chữ Hán", "Dịch nghĩa sang tiếng Anh", "Đếm số nét chữ",
                "Tiếng Trung phổ thông có bao nhiêu thanh mẫu (phụ âm đầu) chính?", "21", "24", "18", "26"),
            new ModuleInfo(19, 6, "4 Thanh điệu & Kỹ thuật phát âm chuẩn",
                "Tiếng Trung tiêu chuẩn có bao nhiêu thanh điệu cơ bản?", "4 thanh điệu chính và 1 thanh nhẹ", "3 thanh điệu", "5 thanh điệu", "6 thanh điệu",
                "Thanh 1 (Thanh ngang) trong tiếng Trung phát âm như thế nào?", "Cao và đều (55)", "Từ cao xuống thấp", "Từ thấp lên cao", "Xuống thấp rồi lên cao"),
            new ModuleInfo(20, 6, "Quy tắc viết các nét cơ bản chữ Hán",
                "Quy tắc viết chữ Hán cơ bản nhất là gì?", "Từ trên xuống dưới, từ trái sang phải", "Từ phải sang trái, từ dưới lên trên", "Tùy ý người viết", "Nét dọc trước nét ngang sau",
                "Nét 'Mác' trong thư pháp chữ Hán có hướng kéo như thế nào?", "Kéo xiên từ trên trái xuống dưới phải", "Kéo thẳng từ trên xuống", "Kéo ngang từ trái qua phải", "Kéo móc ngược lên"),
            new ModuleInfo(21, 6, "Các bộ thủ chữ Hán thông dụng",
                "Bộ 'Nhân' (人 / 亻) liên quan đến ý nghĩa gì trong chữ Hán?", "Con người", "Cây cối", "Nước", "Lửa",
                "Bộ 'Thủy' (水 / 氵) biểu thị ý nghĩa liên quan đến gì?", "Nước, sông hồ, chất lỏng", "Kim loại", "Đất đai", "Gió bão"),
            new ModuleInfo(22, 6, "Từ vựng & Đàm thoại giao tiếp sơ cấp (Phần 1)",
                "Câu chào phổ biến nhất 'Xin chào' trong tiếng Trung là gì?", "Nǐ hǎo (你好)", "Xièxie (谢谢)", "Zàijiàn (再见)", "Duìbuqǐ (对不起)",
                "Từ 'Cảm ơn' trong tiếng Trung được phát âm là gì?", "Xièxie (谢谢)", "Bù kèqi (不客气)", "Nǐ hǎo (你好)", "Méi guānxi (没关系)"),
            new ModuleInfo(23, 6, "Từ vựng & Đàm thoại giao tiếp sơ cấp (Phần 2)",
                "Từ nào trong tiếng Trung có nghĩa là 'Tạm biệt'?", "Zàijiàn (再见)", "Qǐng (请)", "Hǎo (好)", "Shì (是)",
                "Đại từ nhân xưng ngôi thứ nhất số nhiều 'Chúng tôi' là gì?", "Wǒmen (我们)", "Nǐmen (你们)", "Tāmen (他们)", "Dàjiā (大家)"),
            new ModuleInfo(24, 6, "Ngữ pháp căn bản & Đàm thoại thực tế",
                "Trợ từ nghi vấn nào dùng ở cuối câu hỏi Yes/No trong tiếng Trung?", "Ma (吗)", "Ne (呢)", "Ba (吧)", "De (的)",
                "Định ngữ bổ nghĩa cho danh từ trong tiếng Trung thường liên kết bởi trợ từ nào?", "De (的)", "Le (了)", "Zhe (着)", "Guò (过)"),

            // Course 7: Tâm lý học
            new ModuleInfo(25, 7, "Bản chất hiện tượng tâm lý người & Nhận thức cảm tính",
                "Tâm lý người có nguồn gốc cốt lõi từ đâu?", "Hiện thực khách quan phản ánh qua não bộ con người", "Tự nhiên sinh ra không chịu ảnh hưởng từ môi trường", "Chỉ do gen di truyền quyết định hoàn toàn", "Không có nguồn gốc rõ ràng",
                "Hình thức nhận thức cảm tính nào phản ánh trọn vẹn các thuộc tính bề ngoài của sự vật?", "Tri giác", "Cảm giác", "Tư duy", "Tưởng tượng"),
            new ModuleInfo(26, 7, "Quá trình nhận thức lý tính, Cảm xúc & Nhân cách",
                "Đặc điểm cơ bản nhất của tư duy là gì?", "Tính gián tiếp và tính khái quát", "Chỉ phản ánh thuộc tính riêng lẻ", "Phản ánh trực tiếp bằng giác quan", "Không có tính trừu tượng",
                "Cấu trúc nhân cách bao gồm những thành tố tâm lý chủ yếu nào?", "Xu hướng, tính cách, khí chất và năng lực", "Chiều cao, cân nặng và ngoại hình", "Sở thích và trang phục", "Trí nhớ và giọng nói"),

            // Course 8: Nhạc lý cơ bản & Guitar
            new ModuleInfo(27, 8, "Khuông nhạc, Khóa nhạc & Nhịp phách",
                "Một khuông nhạc tiêu chuẩn gồm bao nhiêu dòng kẻ và bao nhiêu khe?", "5 dòng kẻ và 4 khe", "4 dòng kẻ và 5 khe", "6 dòng kẻ và 5 khe", "5 dòng kẻ và 5 khe",
                "Khóa nhạc phổ biến nhất dùng cho đàn Guitar và giọng hát là khóa gì?", "Khóa Sol (G Clef)", "Khóa Fa (F Clef)", "Khóa Đô (C Clef)", "Khóa La (A Clef)"),
            new ModuleInfo(28, 8, "Cao độ, Trường độ & Vị trí nốt trên cần đàn",
                "7 nốt nhạc cơ bản theo thứ tự cao độ tăng dần là gì?", "Đô, Rê, Mi, Fa, Sol, La, Si", "La, Si, Đô, Rê, Mi, Fa, Sol", "Sol, Fa, Mi, Rê, Đô, Si, La", "Mi, Sol, Si, Rê, Fa, La, Đô",
                "Dây số 6 (dây dày nhất) trên đàn Guitar chuẩn được lên dây theo nốt gì?", "Nốt Mi (E)", "Nốt La (A)", "Nốt Rê (D)", "Nốt Sol (G)"),
            new ModuleInfo(29, 8, "Đọc tiết tấu, nốt móc đơn & móc kép",
                "1 nốt tròn có trường độ bằng bao nhiêu nốt đen?", "4 nốt đen", "2 nốt đen", "8 nốt đen", "16 nốt đen",
                "1 nốt đen có trường độ bằng bao nhiêu nốt móc đơn?", "2 nốt móc đơn", "4 nốt móc đơn", "3 nốt móc đơn", "1 nốt móc đơn"),
            new ModuleInfo(30, 8, "Chùm nốt, dấu hóa & đảo phách",
                "Dấu thăng (#) có tác dụng gì đối với cao độ của nốt nhạc?", "Tăng cao độ lên nửa cung (1/2 cung)", "Giảm cao độ nửa cung", "Tăng cao độ lên 1 cung", "Giữ nguyên cao độ",
                "Dấu giáng (b) có tác dụng gì đối với cao độ của nốt nhạc?", "Giảm cao độ xuống nửa cung (1/2 cung)", "Tăng cao độ nửa cung", "Giảm cao độ 1 cung", "Hủy bỏ dấu thăng"),
            new ModuleInfo(31, 8, "Điệu thức, hợp âm & thực hành đệm hát",
                "Hợp âm Đô trưởng (C Major) được cấu tạo từ 3 nốt nhạc nào?", "Đô - Mi - Sol (C - E - G)", "Đô - Fa - La (C - F - A)", "Rê - Fa - La (D - F - A)", "Mi - Sol - Si (E - G - B)",
                "Hợp âm La thứ (Am) mang tính chất âm thanh như thế nào?", "U buồn, trầm lắng, êm dịu", "Vui tươi, rộn rã, hùng tráng", "Chói chang, gay gắt", "Căng thẳng, hồi hộp")
        };

        // Đọc phần đầu của file seed_test_master.sql (từ đầu đến hết dòng 555)
        File origFile = new File("database/seed_test_master.sql");
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(origFile), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("-- QUIZZES CHO COURSE 1 VÀ COURSE 7")) {
                    break;
                }
                sb.append(line).append("\n");
            }
        }

        // Tạo phần QUIZZES cho toàn bộ 31 Modules
        sb.append("-- QUIZZES CHO TOÀN BỘ 31 CHƯƠNG HỌC CỦA 8 KHÓA HỌC\n");
        sb.append("INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, is_active, created_at, updated_at) VALUES\n");
        for (int i = 0; i < modules.length; i++) {
            ModuleInfo m = modules[i];
            sb.append("    (").append(m.id).append(", ").append(m.id).append(", 'Kiểm tra trắc nghiệm: ")
              .append(m.name.replace("'", "''")).append("', 75.00, 15, 1, true, now() - interval '10 days', now())");
            if (i < modules.length - 1) {
                sb.append(",\n");
            } else {
                sb.append(";\n\n");
            }
        }

        // Tạo 62 Questions (mỗi quiz 2 câu hỏi)
        sb.append("INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at) VALUES\n");
        int qId = 1;
        for (int i = 0; i < modules.length; i++) {
            ModuleInfo m = modules[i];
            sb.append("    (").append(qId++).append(", ").append(m.id).append(", '").append(m.q1Text.replace("'", "''")).append("', 'SINGLE_CHOICE', 50.00, now()),\n");
            sb.append("    (").append(qId++).append(", ").append(m.id).append(", '").append(m.q2Text.replace("'", "''")).append("', 'SINGLE_CHOICE', 50.00, now())");
            if (i < modules.length - 1) {
                sb.append(",\n");
            } else {
                sb.append(";\n\n");
            }
        }

        // Tạo 248 Options (mỗi question 4 options)
        sb.append("INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES\n");
        int optId = 1;
        for (int i = 0; i < modules.length; i++) {
            ModuleInfo m = modules[i];
            int currQ1 = i * 2 + 1;
            int currQ2 = i * 2 + 2;

            // Q1 options
            sb.append("    (").append(optId++).append(", ").append(currQ1).append(", '").append(m.q1Opt1.replace("'", "''")).append("', true, 1),\n");
            sb.append("    (").append(optId++).append(", ").append(currQ1).append(", '").append(m.q1Opt2.replace("'", "''")).append("', false, 2),\n");
            sb.append("    (").append(optId++).append(", ").append(currQ1).append(", '").append(m.q1Opt3.replace("'", "''")).append("', false, 3),\n");
            sb.append("    (").append(optId++).append(", ").append(currQ1).append(", '").append(m.q1Opt4.replace("'", "''")).append("', false, 4),\n");

            // Q2 options
            sb.append("    (").append(optId++).append(", ").append(currQ2).append(", '").append(m.q2Opt1.replace("'", "''")).append("', true, 1),\n");
            sb.append("    (").append(optId++).append(", ").append(currQ2).append(", '").append(m.q2Opt2.replace("'", "''")).append("', false, 2),\n");
            sb.append("    (").append(optId++).append(", ").append(currQ2).append(", '").append(m.q2Opt3.replace("'", "''")).append("', false, 3),\n");
            sb.append("    (").append(optId++).append(", ").append(currQ2).append(", '").append(m.q2Opt4.replace("'", "''")).append("', false, 4)");

            if (i < modules.length - 1) {
                sb.append(",\n");
            } else {
                sb.append(";\n\n");
            }
        }

        // Tạo 62 Quiz_Questions
        sb.append("INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points) VALUES\n");
        int qqId = 1;
        for (int i = 0; i < modules.length; i++) {
            ModuleInfo m = modules[i];
            int qzId = m.id;
            int currQ1 = i * 2 + 1;
            int currQ2 = i * 2 + 2;

            sb.append("    (").append(qqId++).append(", ").append(qzId).append(", ").append(currQ1).append(", ").append(m.id).append(", 1, 50.00),\n");
            sb.append("    (").append(qqId++).append(", ").append(qzId).append(", ").append(currQ2).append(", ").append(m.id).append(", 2, 50.00)");
            if (i < modules.length - 1) {
                sb.append(",\n");
            } else {
                sb.append(";\n\n");
            }
        }

        // Tạo Đăng ký cho student1 (id=4) cho toàn bộ 8 khóa học
        sb.append("-- ĐĂNG KÝ KHÓA HỌC CHO TÀI KHOẢN STUDENT1 (ID=4)\n");
        sb.append("INSERT INTO registrations (id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at) VALUES\n");
        sb.append("    (1, 4, 1, now() - interval '10 days', 47.06, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '10 days'),\n");
        sb.append("    (2, 4, 2, now() - interval '9 days',  25.00, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '9 days'),\n");
        sb.append("    (3, 4, 3, now() - interval '8 days',  16.67, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '8 days'),\n");
        sb.append("    (4, 4, 4, now() - interval '7 days',  10.00, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '7 days'),\n");
        sb.append("    (5, 4, 5, now() - interval '2 days',    0.00,  'PENDING',   'VNPAY',  'VNP_TEST_PENDING', 299000, 'PENDING', NULL),\n");
        sb.append("    (6, 4, 6, now() - interval '6 days',  15.00, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '6 days'),\n");
        sb.append("    (7, 4, 7, now() - interval '20 days',100.0, 'COMPLETED', 'VNPAY',  'VNP_TEST_SUCCESS', 199000, 'SUCCESS', now() - interval '20 days'),\n");
        sb.append("    (8, 4, 8, now() - interval '40 days', 19.61, 'ACTIVE',    NULL,     NULL,               0,      'FREE',    now() - interval '40 days');\n\n");

        // Tiến độ mẫu
        sb.append("-- TIẾN ĐỘ HỌC TẬP MẪU CHO STUDENT1\n");
        sb.append("INSERT INTO lesson_progress (registration_id, lesson_id, status, user_note, updated_at, completed_at) VALUES\n");
        sb.append("    (1, 1, 'COMPLETED', 'Đã nắm vững cốt cách nhân tướng học.', now() - interval '8 days', now() - interval '8 days'),\n");
        sb.append("    (1, 2, 'COMPLETED', 'Đã hiểu rõ ngũ quan và tam đình.', now() - interval '7 days', now() - interval '7 days'),\n");
        sb.append("    (1, 3, 'IN_PROGRESS', 'Đang thực hành quan sát thần khí.', now() - interval '2 hours', NULL),\n");
        sb.append("    (2, 18, 'COMPLETED', 'Đã cài đặt Python và VS Code thành công.', now() - interval '7 days', now() - interval '7 days'),\n");
        sb.append("    (3, 65, 'COMPLETED', 'Đã ghi nhớ tính cách cung Bạch Dương.', now() - interval '5 days', now() - interval '5 days'),\n");
        sb.append("    (4, 77, 'COMPLETED', 'Đã thiết lập dự án Spring Boot 3.', now() - interval '4 days', now() - interval '4 days'),\n");
        sb.append("    (6, 153, 'COMPLETED', 'Đã phát âm chuẩn thanh mẫu pinyin.', now() - interval '3 days', now() - interval '3 days'),\n");
        sb.append("    (7, 227, 'COMPLETED', 'Đã hiểu bản chất hiện tượng tâm lý người.', now() - interval '18 days', now() - interval '18 days'),\n");
        sb.append("    (8, 245, 'COMPLETED', 'Đã nhớ vị trí các nốt trên khuông nhạc.', now() - interval '25 days', now() - interval '25 days');\n\n");

        // Lịch sử làm bài trắc nghiệm mẫu
        sb.append("-- LỊCH SỬ TRẮC NGHIỆM MẪU\n");
        sb.append("INSERT INTO quiz_attempts (id, registration_id, quiz_id, submitted_at, total_score, pass_status) VALUES\n");
        sb.append("    (1, 1, 1, now() - interval '5 days', 100.00, true),\n");
        sb.append("    (2, 7, 25, now() - interval '1 day', 100.00, true);\n\n");

        sb.append("INSERT INTO quiz_answers (quiz_attempt_id, question_id, selected_option_id, is_correct, score) VALUES\n");
        sb.append("    (1, 1, 1, true, 50.00),\n");
        sb.append("    (1, 2, 5, true, 50.00),\n");
        sb.append("    (2, 49, 193, true, 50.00),\n");
        sb.append("    (2, 50, 197, true, 50.00)\n");
        sb.append("ON CONFLICT (quiz_attempt_id, question_id, selected_option_id) DO UPDATE SET is_correct = true, score = 50.00;\n\n");

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

        String fullSql = sb.toString();

        // 1. Lưu ra database/seed_test_master.sql
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(new File("database/seed_test_master.sql")), StandardCharsets.UTF_8)) {
            writer.write(fullSql);
        }

        // 2. Lưu ra src/main/resources/database/seed_test_master.sql
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(new File("src/main/resources/database/seed_test_master.sql")), StandardCharsets.UTF_8)) {
            writer.write(fullSql);
        }

        // 3. Đồng bộ luôn sang database/seed.sql và database/seed_full_courses.sql để nhất quán
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(new File("database/seed.sql")), StandardCharsets.UTF_8)) {
            writer.write(fullSql);
        }
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(new File("database/seed_full_courses.sql")), StandardCharsets.UTF_8)) {
            writer.write(fullSql);
        }

        // 4. Thực thi trực tiếp lên PostgreSQL courson_db
        try (Connection con = DbConnection.getConnection();
             Statement stmt = con.createStatement()) {
            stmt.execute(fullSql);
        }
        System.out.println("MASTER SEED VỚI TOÀN BỘ 8 KHÓA HỌC VÀ 31 BÀI QUIZ ĐÃ ĐƯỢC ÁP DỤNG THÀNH CÔNG!");
    }
}
