# 🎓 Courson LMS - Nền Tảng Quản Lý Học Trực Tuyến

<div align="center">

[![Java Version](https://img.shields.io/badge/Java-17-orange.svg?logo=openjdk&logoColor=white)](https://openjdk.org/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10%20(Servlet%206.0)-red.svg)](https://jakarta.ee/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14%2B-blue.svg?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-10.1%2B-yellow.svg?logo=apachetomcat&logoColor=white)](https://tomcat.apache.org/)
[![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple.svg?logo=bootstrap&logoColor=white)](https://getbootstrap.com/)
[![License](https://img.shields.io/badge/License-Academic%20Project-green.svg)](#)

**Dự án Thực tế Môn SWP391 - Nhóm SE2051-NET Group 5 | Đại Học FPT**

[Tính Năng](#-tính-năng-nổi-bật) • [Kiến Trúc](#-kiến-trúc-hệ-thống) • [Cơ Sở Dữ Liệu](#-cơ-sở-dữ-liệu) • [Cài Đặt & Chạy](#-hướng-dẫn-cài-đặt--chạy-trên-máy) • [Tài Khoản Thử Nghiệm](#-tài-khoản-thử-nghiệm)

</div>

---

## 📖 1. Giới thiệu dự án

**Courson LMS** là giải pháp nền tảng học tập trực tuyến (Learning Management System) toàn diện, được thiết kế theo mô hình **MVC chuẩn** kết hợp **Service - DAO Pattern** trên nền tảng **Jakarta Servlet 6.0 / JSP 3.1** và **PostgreSQL**. Hệ thống đáp ứng đầy đủ chu trình học tập từ khám phá khóa học, ghi danh, xem bài giảng video, theo dõi tiến độ đến làm bài kiểm tra trắc nghiệm và cấp chứng chỉ.

---

## 🌟 2. Tính năng nổi bật

### 👨‍🎓 Dành cho Học viên (Student)
* **Khám phá & Tìm kiếm:** Duyệt danh mục khóa học, tìm kiếm theo từ khóa và lọc theo chuyên mục (Nhân tướng học, Tử Vi, Chiêm tinh, Web...).
* **Ghi danh & Thanh toán:** Đăng ký khóa học linh hoạt (khóa học miễn phí hoặc thanh toán giả lập qua SePay/VNPay).
* **Không gian học tập tương tác (Learning Workspace):**
  * Tự động điều hướng và phát video bài giảng chất lượng cao (tích hợp YouTube Embed và Auto-Thumbnail).
  * Hiển thị danh mục chương học trực quan, đánh dấu trạng thái hoàn thành từng bài.
  * Cập nhật tiến độ hoàn thành khóa học (%) theo thời gian thực.
* **Hệ thống Kiểm tra & Đánh giá (Quiz Engine):**
  * Làm bài thi trắc nghiệm theo thời gian giới hạn (đếm ngược).
  * Tự động chấm điểm, hiển thị kết quả đậu/trượt (Pass/Fail) và xem lại đáp án chi tiết.

### 👨‍🏫 Dành cho Chuyên gia & Giảng viên (Expert / Instructor)
* **Quản lý nội dung:** Tạo chương học (Modules), bài giảng (Lessons) kèm tài liệu và video đa phương tiện.
* **Ngân hàng câu hỏi (Question Bank):** Quản lý tập trung câu hỏi trắc nghiệm đơn, trắc nghiệm nhiều lựa chọn, đúng/sai theo từng chuyên đề.
* **Thiết lập Đề thi (Quiz Management):** Tạo bài kiểm tra, cấu hình thời gian làm bài, điểm qua môn và gán câu hỏi từ ngân hàng câu hỏi.

### 👔 Dành cho Quản lý & Quản trị viên (Manager / Admin)
* **Quản lý Khóa học:** Phê duyệt, xuất bản (Publish), ẩn hoặc lưu trữ (Archive) khóa học.
* **Quản lý Người dùng:** Phân quyền vai trò (Admin, Manager, Expert, Student), kích hoạt hoặc khóa tài khoản (Active/Banned).
* **Cài đặt Hệ thống (System Settings):** Quản lý động các danh mục khóa học (Course Categories) và nhóm vai trò (User Roles).

---

## 🏗️ 3. Kiến trúc hệ thống

Dự án áp dụng mô hình phân lớp rõ ràng (Layered Architecture):

```
                       ┌───────────────────────────────┐
                       │   Trình Duyệt (Web Browser)   │
                       └───────────────┬───────────────┘
                                       │ HTTP / HTTPS
                                       ▼
                       ┌───────────────────────────────┐
                       │   Security Filters            │
                       │ (Encoding, Auth, Access Ctrl) │
                       └───────────────┬───────────────┘
                                       ▼
                       ┌───────────────────────────────┐
                       │   Controllers (Servlets)      │
                       │  Auth, Course, Lesson, Quiz   │
                       └───────────────┬───────────────┘
                                       ▼
                       ┌───────────────────────────────┐
                       │   Service Layer (Business)    │
                       │ AuthService, CourseService... │
                       └───────────────┬───────────────┘
                                       ▼
                       ┌───────────────────────────────┐
                       │   Data Access Objects (DAO)   │
                       │   UserDao, CourseDao, QuizDao │
                       └───────────────┬───────────────┘
                                       ▼
                       ┌───────────────────────────────┐
                       │   PostgreSQL Database         │
                       └───────────────────────────────┘
```

---

## 🗄️ 4. Cơ sở dữ liệu (PostgreSQL)

Hệ thống bao gồm **13 bảng chuẩn hóa** ràng buộc toàn vẹn dữ liệu:

| STT | Tên bảng | Chức năng chính |
| :---: | :--- | :--- |
| **1** | `settings` | Quản lý danh mục khóa học (`COURSE_CATEGORY`) và vai trò người dùng (`USER_ROLE`). |
| **2** | `users` | Lưu trữ tài khoản, mật khẩu băm BCrypt, vai trò và thông tin cá nhân. |
| **3** | `courses` | Thông tin khóa học, giá, danh mục, trạng thái (DRAFT/PUBLISHED/ARCHIVED). |
| **4** | `modules` | Các chương mục trong một khóa học, sắp xếp theo thứ tự `order_index`. |
| **5** | `lessons` | Bài học chi tiết (nội dung HTML, URL video embed, tài liệu đính kèm). |
| **6** | `quizzes` | Đề thi trắc nghiệm theo chương, thời lượng và điểm chuẩn (`pass_score`). |
| **7** | `questions` | Ngân hàng câu hỏi trắc nghiệm thuộc từng module. |
| **8** | `answer_options` | Các phương án trả lời và cờ đáp án đúng (`is_correct`). |
| **9** | `quiz_questions` | Liên kết câu hỏi vào đề thi kèm điểm số tương ứng. |
| **10** | `registrations` | Đơn đăng ký học, mã thanh toán, tiến độ học tập và trạng thái truy cập. |
| **11** | `lesson_progress` | Ghi nhận trạng thái hoàn thành của từng bài học theo từng lượt đăng ký. |
| **12** | `quiz_attempts` | Lịch sử các lần làm bài thi của học viên (điểm số, thời gian, kết quả). |
| **13** | `quiz_answers` | Chi tiết lựa chọn của học viên cho từng câu hỏi trong lần thi. |

---

## 📁 5. Cấu trúc thư mục mã nguồn

```
SE2051-NET_SWP391_G5/
├── database/
│   ├── schema.sql                 # Cấu trúc CSDL PostgreSQL chuẩn
│   ├── seed_full_courses.sql      # Dữ liệu mẫu 118 bài giảng & Quiz
│   ├── fetch_playlists.py         # Script tự động trích xuất YouTube Playlist
│   └── generate_full_courses_sql.py # Script sinh dữ liệu SQL tự động
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── controller/        # Jakarta Servlets xử lý Request
│   │   │   ├── dao/               # Tương tác CSDL qua JDBC
│   │   │   ├── dto/               # Data Transfer Objects
│   │   │   ├── entity/            # Thực thể ánh xạ CSDL & Enums
│   │   │   ├── filter/            # Bộ lọc bảo mật & xác thực
│   │   │   ├── service/           # Nghiệp vụ nghiệp vụ (Business Logic)
│   │   │   └── util/              # Tiện ích DbConnection, PasswordUtil, v.v.
│   │   ├── resources/
│   │   │   └── db.properties      # Cấu hình kết nối CSDL PostgreSQL
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml        # Cấu hình Web Application
│   │       │   └── views/         # Giao diện JSP (Admin, Auth, Course, Quiz, v.v.)
│   │       └── index.html         # Trang chuyển tiếp mặc định
├── pom.xml                        # Cấu hình Maven & dependencies
└── README.md                      # Tài liệu hướng dẫn dự án
```

---

## 🚀 6. Hướng dẫn cài đặt & Chạy trên máy

### Yêu cầu hệ thống
* **Java Development Kit (JDK):** Phiên bản **17** trở lên.
* **Apache Maven:** Phiên bản **3.8+**.
* **Apache Tomcat:** Phiên bản **10.1+** (hỗ trợ Jakarta Servlet 6.0).
* **PostgreSQL:** Phiên bản **14+** (cổng mặc định `5432`).

### Các bước thực hiện:

#### Bước 1: Khởi tạo Cơ sở dữ liệu
1. Mở công cụ quản trị PostgreSQL (pgAdmin hoặc terminal `psql`):
   ```sql
   CREATE DATABASE courson_db;
   ```
2. Thực thi file schema và nạp dữ liệu:
   ```bash
   psql -U postgres -d courson_db -f database/schema.sql
   psql -U postgres -d courson_db -f database/seed_full_courses.sql
   ```

#### Bước 2: Cấu hình kết nối CSDL
Chỉnh sửa thông tin kết nối trong file `src/main/resources/db.properties`:
```properties
db.url=jdbc:postgresql://localhost:5432/courson_db
db.user=postgres
db.password=sa
```

#### Bước 3: Biên dịch & Đóng gói WAR
Sử dụng Maven để build ứng dụng:
```bash
mvn clean package -DskipTests
```
*File `Courson.war` sẽ được tạo ra tại thư mục `target/Courson.war`.*

#### Bước 4: Deploy & Khởi động trên Tomcat 10
* Copy file `target/Courson.war` vào thư mục `webapps/` của Apache Tomcat.
* Khởi động Tomcat bằng lệnh:
  ```bash
  # Windows
  catalina.bat run
  # Linux/MacOS
  ./catalina.sh run
  ```
* Mở trình duyệt và truy cập: **[http://localhost:8080/Courson/](http://localhost:8080/Courson/)**

---

## 🔑 7. Tài khoản thử nghiệm

Tất cả tài khoản mẫu dưới đây đều dùng mật khẩu mặc định: `admin123`

| Vai trò | Tên đăng nhập | Email | Quyền hạn & Chức năng thử nghiệm |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` | `admin@courson.edu.vn` | Quản lý người dùng, cài đặt danh mục hệ thống |
| **Manager** | `manager1` | `manager@courson.edu.vn` | Quản lý, kiểm duyệt và xuất bản khóa học |
| **Expert** | `expert1` | `expert@courson.edu.vn` | Tạo chương học, soạn bài giảng, ngân hàng câu hỏi & quiz |
| **Student** | `student1` | `student@courson.edu.vn` | Đã kích hoạt sẵn 3 khóa học mẫu (118 bài giảng) để học & thi |

---

## 👥 Thành viên nhóm phát triển

* **Môn học:** SWP391 - Software Development Project
* **Lớp:** SE2051-NET
* **Nhóm:** Group 5
* **Giảng viên hướng dẫn:** FPT University

---
<div align="center">
  <i>© 2026 Courson LMS. Built with ❤️ for educational purposes.</i>
</div>
