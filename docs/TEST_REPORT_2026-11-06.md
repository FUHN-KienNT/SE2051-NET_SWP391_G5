# Báo cáo kiểm thử Courson LMS — 06/11/2026

Đã xác nhận 6 vấn đề: 3 lỗi phân quyền/thanh toán mức cao, 1 lỗi xử lý đầu vào, 1 vấn đề cấu hình email và 1 lỗ hổng trong cách chạy test. Chưa sửa mã nguồn.

## Phạm vi và kết quả

- `mvn test`: BUILD SUCCESS, nhưng không thực thi ba suite dùng hàm `main`.
- Chạy trực tiếp `test.EdgeCaseTestSuite`: **17 đạt, 0 thất bại**.
- Chạy trực tiếp `test.AuthAndResetTestSuite`: **34 đạt, 0 thất bại**.
- Chạy trực tiếp `test.VnPayTestSuite`: **31 đạt, 0 thất bại**.
- Playwright/Chromium: **33 lượt truy cập** dưới Guest, Student, Expert, Manager, Admin; đăng nhập thành công cả 4 vai trò. Có 3 lượt trả HTTP 500 từ 2 đầu vào lỗi. Không ghi nhận JavaScript exception trong các lượt này.
- Các đường `/users`, `/admin/courses`, `/expert/dashboard`, `/registrations/list` chặn Student; `/users` chặn Manager. Guest được chuyển tới đăng nhập khi mở hồ sơ/khóa học cá nhân. Guest không xem được khóa DRAFT thử nghiệm.
- Chạy các test có thay đổi dữ liệu trên database clone `courson_audit_20261106` và Tomcat riêng cổng 18080. Đã dùng class được biên dịch từ workspace hiện tại, đồng bộ JSP. Không triển khai thay đổi lên server 8080.
- Đối chiếu database gốc sau thử nghiệm: quiz 1 giữ tiêu đề gốc; Student không có đăng ký course 2 do thử nghiệm tạo ra.

## 1. [Cao] Tự xác nhận thanh toán mà không có giao dịch ngân hàng

**Vị trí:** `src/main/java/controller/RegistrationServlet.java:198`, đặc biệt dòng 212.

Đăng nhập Student rồi gọi:

```http
GET /Courson/registrations/confirm-payment?courseId=2&paymentCode=AUDIT-NO-BANK-TRANSFER
```

**Quan sát:** HTTP 302 chuyển đến `/courses/learn?registrationId=12`; database clone có `status=ACTIVE`, `payment_status=SUCCESS`, `payment_code=AUDIT-NO-BANK-TRANSFER`. Trang học trả HTTP 200 và hiển thị nội dung bài giảng của khóa giá 299.000 đồng. Không gọi ngân hàng/VNPay.

**Nguyên nhân:** endpoint mô phỏng VietQR vẫn truy cập được trong ứng dụng, lấy mã thanh toán từ client và gọi `updatePayment(...SUCCESS...)`. Cả GET cũng thực thi thay đổi.

**Đề xuất:** chỉ kích hoạt quyền học từ callback đã xác thực hoặc thao tác quản lý được phân quyền. Tách mô phỏng khỏi môi trường dùng thanh toán thật; chặn GET cho thao tác ghi.

## 2. [Cao] Student sửa được bài quiz

**Vị trí:** `src/main/java/controller/QuizServlet.java:229`; `src/main/java/filter/AuthorizationFilter.java` chưa có quy tắc bảo vệ thao tác quản trị quiz.

Đăng nhập `student1`, gửi:

```http
POST /Courson/quizzes/save
Content-Type: application/x-www-form-urlencoded

id=1&moduleId=1&title=AUDIT_STUDENT_CHANGED_QUIZ&orderIndex=1&passScore=50&timeLimitMinutes=15&courseId=1
```

**Quan sát:** HTTP 302 với `success=saved`. Truy vấn database clone xác nhận quiz 1 có tiêu đề `AUDIT_STUDENT_CHANGED_QUIZ`.

**Kỳ vọng:** Student nhận 403, dữ liệu không thay đổi. Expert cần được kiểm tra quyền sở hữu và trạng thái khóa học ở server, không chỉ ẩn nút trên giao diện.

**Đề xuất:** kiểm tra vai trò/quyền sở hữu cho từng action quản trị quiz; thêm test HTTP phủ định bằng tài khoản Student. Các action xóa/gán câu hỏi chưa được thử trong lần này.

## 3. [Cao] Student xem được đáp án đúng trên trang quản trị quiz

**Vị trí:** `src/main/java/controller/QuizServlet.java:160`; `src/main/webapp/WEB-INF/views/quiz/detail.jsp:975`, `:1089`.

**Tái hiện:** đăng nhập `student1`, mở `/Courson/quizzes/detail?id=1`.

**Quan sát:** HTTP 200; DOM có 1 phần tử `[data-correct="true"]` và 1 `.option-card.is-correct`. Trang trả cả câu hỏi và đáp án đúng trước khi thi.

**Đề xuất:** bảo vệ trang quản trị quiz bằng quyền phù hợp; trang làm bài cho Student không nhận trường đáp án đúng trước khi nộp bài. Kiểm tra cả payload HTML, không chỉ trạng thái hiển thị của nút.

## 4. [Trung bình] ID khóa học sai/không tồn tại gây HTTP 500 và lộ stack trace

**Vị trí:** `src/main/java/controller/CourseServlet.java:112`; `src/main/java/service/CourseService.java:159`.

| Đầu vào | Quan sát | Kỳ vọng |
|---|---|---|
| `/courses/detail?id=abc` | 500, `NumberFormatException`, stack trace Tomcat | 400 hoặc trang báo đầu vào không hợp lệ |
| `/courses/detail?id=999999` | 500, `IllegalArgumentException: Không tìm thấy khóa học ID: 999999` | 404 hoặc trang không tìm thấy |

Đã tái hiện trường hợp đầu với cả Guest và Student. Handler không xử lý ngoại lệ parse ID và không tìm thấy bản ghi.

## 5. [Cấu hình/Trung bình] Email reset mật khẩu không gửi được trong môi trường kiểm thử

**Vị trí:** `src/main/java/util/MailUtil.java:234`; lời gọi bất đồng bộ ở `src/main/java/service/PasswordResetService.java:79`.

Auth suite báo PASS cho gửi reset, trong khi log ghi:

```text
SEVERE: Chưa cấu hình tài khoản SMTP (username hoặc password rỗng). Vui lòng kiểm tra mail.properties.
```

Lỗi gửi email không làm suite thất bại. Trong cấu hình được thử, người dùng không nhận được email reset từ luồng này. Đây là vấn đề cấu hình đã quan sát, không phải kết luận dịch vụ SMTP bên ngoài bị lỗi.

**Đề xuất:** cấu hình SMTP cho môi trường chạy, quan sát kết quả gửi bất đồng bộ và kiểm thử email bằng mail sink/test mailbox. Không lấy việc tạo token thành công làm bằng chứng email đã được gửi.

## 6. [Trung bình] `mvn test` thành công nhưng không chạy test nghiệp vụ

**Vị trí:** `pom.xml`; ba class trong `src/test/java/test` dùng `public static void main`, không dùng test framework/annotation.

**Quan sát:** Maven chạy Surefire rồi báo BUILD SUCCESS mà không có số test thực thi. Chỉ sau khi gọi trực tiếp từng class mới có 82 kiểm tra thực sự.

**Đề xuất:** tích hợp JUnit/Surefire hoặc cấu hình chạy các suite rõ ràng trong lifecycle; bảo đảm CI báo số test thực thi. Suite VNPay có thao tác xóa đăng ký/tiến độ đã tồn tại, nên phải dùng database cô lập.

## Bằng chứng

Thư mục `test-evidence-2026-11-06/` chứa kết quả browser, log của ba suite, log tái hiện thanh toán/quiz, kết quả SQL và ảnh chụp. Các ID ở trên là dữ liệu của database clone đã dọn sau kiểm thử.

Tomcat test đã dừng, database clone đã xóa. Thao tác xóa đệ quy thư mục tạm bị cơ chế kiểm duyệt tự động chặn; thư mục `C:/Users/admin/AppData/Local/Temp/courson-audit-20261106` còn lưu bộ chạy test và snapshot database local.

## Giới hạn

Đây là kiểm thử nghiệp vụ có chọn lọc, không phải bảo đảm toàn bộ ứng dụng không còn lỗi. Chưa kiểm thử tải, race condition, mọi thao tác CRUD, Google OAuth, Gemini/YouTube và giao dịch VNPay thật. Khi duyệt các route trên môi trường riêng, đã chặn request ra domain bên ngoài để kiểm tra server và luồng nội bộ ổn định; chưa đánh giá tải CDN hay bố cục responsive. Suite VNPay xác minh logic/chữ ký và vòng đời dữ liệu, không xác nhận tích hợp ngân hàng thực tế.
