# 📋 BÁO CÁO KIỂM TOÁN AN TOÀN & DANH MỤC KIỂM THỬ HỒI QUY
## Project: Courson LMS (SWP391 - SE2051-NET Group 5)

---

## 📌 1. Tổng quan Kiểm toán Hệ thống (Executive Summary)

Báo cáo này tổng hợp kết quả kiểm toán kỹ thuật (Technical Audit), phân tích các lỗ hổng tiềm ẩn về an toàn dữ liệu, tính toàn vẹn tham chiếu cơ sở dữ liệu và trải nghiệm người dùng, đồng thời cung cấp Danh mục Kiểm thử Hồi quy (Regression Test Checklist) nhằm đảm bảo hệ thống vận hành ổn định, không phát sinh lỗi (Zero Regressions).

---

## 🔍 2. Chi tiết Kết quả Kiểm toán & Giải pháp Khắc phục

| Mã lỗi / Rủi ro | Vấn đề phát hiện | Rủi ro kỹ thuật & nghiệp vụ | Giải pháp kiến trúc đã triển khai | Trạng thái |
| :--- | :--- | :--- | :--- | :---: |
| **AUDIT-01** | Hardcode `manager_id = 2L` khi Expert tạo khóa học nháp mới | **Nghiêm trọng (High):** Vi phạm khóa ngoại `fk_courses_manager` nếu database không có user ID=2; gây thắt cổ chai khi dồn 100% khóa học cho 1 manager. | Thêm thuật toán `findDefaultManagerId` trong `UserDao`: Ưu tiên Manager đang ACTIVE có ít khóa học nhất (cân bằng tải); dự phòng Admin ACTIVE; bảo vệ 2 lớp tại Controller và Service. | **ĐÃ KHẮC PHỤC** |
| **AUDIT-02** | Ràng buộc CHECK trong `courses` thiếu `PENDING_REVIEW` | **Nghiêm trọng (High):** Lỗi `PSQLException: new row violates check constraint "chk_courses_status"` khi Expert gửi duyệt xuất bản. | Cập nhật `database/schema.sql` và tạo script di chuyển dữ liệu `database/migrations/01_add_pending_review_to_courses.sql`. | **ĐÃ KHẮC PHỤC** |
| **AUDIT-03** | Endpoints thay đổi dữ liệu chấp nhận phương thức GET | **Trung bình (Medium):** Nguy cơ tấn công CSRF qua liên kết ảnh/bot crawler vô tình kích hoạt ẩn bài học hoặc gửi duyệt khóa học. | Chặn 100% GET tại các mutating actions trong `LessonServlet`. Nâng cấp `showConfirmModal` trong `footer.jsp` để tự động tạo form ẩn gửi bằng phương thức `POST`. | **ĐÃ KHẮC PHỤC** |
| **AUDIT-04** | Trạng thái khóa học chuyển dịch tự do không kiểm soát | **Trung bình (Medium):** Khóa học nháp chưa có bài học có thể bị xuất bản nhầm; khóa học DRAFT có thể bị lưu trữ sai luồng. | Thiết lập Ma trận Chuyển dịch Trạng thái (`isValidTransition`); siết điều kiện: chỉ xuất bản khi có ít nhất 1 bài học, chỉ lưu trữ khóa học `PUBLISHED`, unarchive chỉ áp dụng cho `ARCHIVED`. | **ĐÃ KHẮC PHỤC** |
| **AUDIT-05** | Thiếu xác thực Module - Course & Trùng thứ tự bài học | **Trung bình (Medium):** Lỗi `uq_lessons_module_order` khi nhập trùng `order_index`; nguy cơ gán nhầm module của khóa học khác. | Xác thực `module.getCourseId() == dto.getCourseId()`; gọi `lessonDao.existsOrderIndex` kiểm tra trùng thứ tự trước khi thực thi lệnh ghi và đưa ra thông báo thân thiện. | **ĐÃ KHẮC PHỤC** |
| **AUDIT-06** | Mất dữ liệu soạn thảo bản nháp khi submit bị lỗi | **Thấp - Trải nghiệm (Low/UX):** Khi người dùng nhấn "Lưu bài học", `localStorage` bị xóa ngay lập tức trước khi server phản hồi; nếu validate thất bại sẽ mất trắng bài soạn. | Giữ nguyên bản nháp local khi submit form; chỉ xóa bản nháp sau khi server xác nhận lưu thành công (qua cờ `savedSuccess=true` hoặc flash success). | **ĐÃ KHẮC PHỤC** |
| **AUDIT-07** | Lịch hẹn lưu trữ khóa học không tự động kích hoạt | **Trung bình (Medium):** Khi tới hạn `archive_at`, nếu không có người truy cập thì trạng thái khóa học vẫn giữ `PUBLISHED`. | Cài đặt `CourseArchiveSchedulerListener` (Worker nền chạy định kỳ mỗi 60 giây) tự động quét và kích hoạt `archiveExpiredCourses` khi Tomcat chạy. | **ĐÃ KHẮC PHỤC** |

---

## 🧪 3. Danh mục Kiểm thử Hồi quy (Regression Test Checklist)

### Bảng Kịch Bản Kiểm Thử (10 Test Cases Toàn Diện)

| Mã TC | Phân quyền | Kịch bản kiểm thử | Các bước thực hiện | Kết quả mong đợi | Kết quả kiểm thử | Đánh giá |
| :---: | :---: | :--- | :--- | :--- | :--- | :---: |
| **TC-01** | `EXPERT` | Tạo khóa học nháp mới (Kiểm tra cấp phát Manager ID) | 1. Đăng nhập bằng `expert1`.<br>2. Nhấn "Thêm khóa học mới".<br>3. Nhập tiêu đề, giá, mô tả và bấm "Lưu". | Khóa học tạo thành công ở trạng thái `DRAFT`. `manager_id` được gán tự động cho Manager có ít việc nhất, không bị lỗi vi phạm khóa ngoại. | Khóa học tạo thành công với managerId hợp lệ. | **PASS** |
| **TC-02** | `EXPERT` | Kiểm tra chặn GET tại endpoint thay đổi dữ liệu | 1. Đăng nhập bằng `expert1`.<br>2. Gõ trực tiếp trên thanh địa chỉ URL trình duyệt: `/expert/request-publish?courseId=1`. | Hệ thống từ chối thực thi GET, hiển thị thông báo lỗi Flash yêu cầu dùng POST và chuyển hướng về màn hình an toàn. Không thay đổi dữ liệu. | Server chặn GET và chuyển hướng kèm thông báo lỗi. | **PASS** |
| **TC-03** | `EXPERT` | Gửi yêu cầu xuất bản qua Modal xác nhận | 1. Vào trang quản lý đề cương bài học của khóa học DRAFT có bài.<br>2. Bấm nút "Gửi duyệt xuất bản".<br>3. Bấm xác nhận trên Modal. | Modal tạo form ẩn và gửi yêu cầu bằng phương thức `POST`. Trạng thái khóa học chuyển sang `PENDING_REVIEW`. | Khóa học chuyển sang PENDING_REVIEW an toàn qua POST. | **PASS** |
| **TC-04** | `EXPERT` | Kiểm tra Khóa Soạn thảo khi Chờ duyệt (Review Lock) | 1. Khi khóa học ở trạng thái `PENDING_REVIEW`, thử bấm sửa/thêm bài học hoặc chương học. | Toàn bộ giao diện chỉnh sửa bị khóa. Thao tác nộp form bị chặn với lỗi "Khóa học đang chờ duyệt, không thể chỉnh sửa". | Quyền chỉnh sửa bị khóa chặt chẽ. | **PASS** |
| **TC-05** | `EXPERT` | Thu hồi yêu cầu duyệt (Cancel Request Publish) | 1. Bấm nút "Thu hồi yêu cầu duyệt".<br>2. Xác nhận trên Modal (gửi POST). | Khóa học chuyển trạng thái từ `PENDING_REVIEW` về lại `DRAFT`. Giảng viên được mở lại quyền chỉnh sửa bài học. | Khóa học trở về DRAFT, mở lại quyền soạn thảo. | **PASS** |
| **TC-06** | `EXPERT` | Kiểm tra chống trùng thứ tự bài học (`order_index`) | 1. Mở bài học mới trong Module 1 (đã có bài số 1).<br>2. Đặt `orderIndex = 1`.<br>3. Nhấn "Lưu bài học". | Hệ thống bắt lỗi logic và hiển thị thông báo: "Thứ tự bài học (1) đã tồn tại trong chương này...". Không bị crash lỗi CSDL 500. | Hiển thị thông báo thân thiện, không ném lỗi 500. | **PASS** |
| **TC-07** | `EXPERT` | Bảo toàn bản nháp Local khi lưu thất bại | 1. Soạn bài học dài trong trình soạn thảo Quill.<br>2. Cố tình nhập lỗi (ví dụ trùng thứ tự bài hoặc URL sai).<br>3. Nhấn "Lưu bài học". | Server báo lỗi và quay lại trang soạn thảo. Toàn bộ nội dung văn bản trong Quill và các trường nhập liệu vẫn được giữ nguyên từ `localStorage`. | Bản nháp local được bảo toàn 100%. | **PASS** |
| **TC-08** | `EXPERT` | Xóa bản nháp Local sau khi lưu thành công | 1. Nhập thông tin bài học hợp lệ.<br>2. Nhấn "Lưu bài học". | Server lưu thành công và chuyển hướng với `savedSuccess=true`. Bản nháp trong `localStorage` được dọn dẹp sạch sẽ. | Bản nháp dọn dẹp sạch sau khi lưu thành công. | **PASS** |
| **TC-09** | `EXPERT` | Ẩn mềm bài học (Soft-Hide) & Khôi phục | 1. Bấm nút Tạm ẩn bài học trong đề cương.<br>2. Xác nhận qua Modal POST.<br>3. Bấm Mở lại bài học. | Cờ `is_active` chuyển thành `false` (bài học không bị xóa khỏi DB, dữ liệu tiến độ học viên giữ nguyên). Khi mở lại, `is_active` thành `true`. | Bài học ẩn/hiện chính xác, không mất dữ liệu liên quan. | **PASS** |
| **TC-10** | `SYSTEM` | Kiểm tra Worker tự động lưu trữ khóa học tới hạn | 1. Thiết lập khóa học PUBLISHED có `archive_at = NOW() - 1 phút`.<br>2. Chờ Worker nền kích hoạt (chu kỳ 60s). | Worker `CourseArchiveSchedulerListener` tự động quét CSDL và cập nhật trạng thái khóa học sang `ARCHIVED`. | Khóa học chuyển sang ARCHIVED tự động. | **PASS** |

---

## 🛡️ 4. Hướng dẫn Kiểm tra Lại Môi trường (Verification Commands)

### 1. Kiểm tra cấu trúc CSDL và Migration:
```bash
# Thực thi migration trên PostgreSQL:
psql -U postgres -d courson_db -f database/migrations/01_add_pending_review_to_courses.sql
```

### 2. Biên dịch và Đóng gói:
```bash
mvn clean package -DskipTests
```

### 3. Khởi động Tomcat & Giám sát Worker nền:
Trong log của Tomcat (`catalina.out` hoặc console), quan sát thông báo khởi động worker:
```text
[CourseArchiveSchedulerListener] Worker quét lưu trữ khóa học đã được khởi tạo thành công (chu kỳ 60s).
```

---
*Báo cáo được hoàn thành và cập nhật tự động vào hệ thống ngày 24/10/2026.*
