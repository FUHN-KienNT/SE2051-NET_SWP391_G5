# Báo cáo kiểm thử Courson LMS — 07/11/2026

## Kết luận
Chưa đủ ổn định/an toàn để dùng thật. Build, test nghiệp vụ và tải đọc nhẹ đạt, nhưng tái hiện được 3 lỗi bảo mật nghiêm trọng, 1 lỗi HTTP 500 và 1 lỗi điều hướng. Chưa sửa mã ứng dụng.

## Kiểm tra đã đạt
- `mvn clean verify`: BUILD SUCCESS, 3 JUnit suite, 0 fail/error/skip; bên trong có 82 kiểm tra PASS (không phải 82 JUnit test độc lập).
- Playwright/Chromium: 33 lượt mở trang, 4 lần đăng nhập thành công cho Student/Expert/Manager/Admin và 5 request bổ sung, tổng 42 bản ghi.
- Dashboard các vai trò, catalog, hồ sơ, học khóa thường/khóa lưu trữ hoạt động ở các lượt đã thử. Ghi chú lưu thành công, đăng ký không tồn tại bị từ chối.
- Student bị chặn users/admin/expert và quản trị quiz; SQL xác nhận quiz 1 không bị sửa. Course ID sai/không tồn tại và khóa DRAFT chuyển về catalog, không còn HTTP 500 ở các trường hợp đã thử hôm trước.
- confirm-payment với mã tự đặt giữ course 5 ở PENDING/PENDING, không mở quyền học.
- Tải đọc: 300 request, 10 đồng thời, 17,896 giây, 300/300 HTTP 200; p50 613ms, p95 1157ms, max 4664ms. Route: home, catalog, course detail, login. Chỉ là tải ngắn, chưa chứng minh độ bền dài hạn/tải ghi.
- Hash của 4 class AuthServlet/RegistrationServlet/DevSeedServlet/CourseServlet sau build trùng bản triển khai trên đĩa của Tomcat 8080. Không xác minh JVM 8080 đã nạp lại các class này.

## 1. [Nghiêm trọng] Khách chưa đăng nhập reset toàn bộ dữ liệu
Vị trí: DevSeedServlet.java:16, :23; AuthenticationFilter.java:33.

GET `/Courson/api/dev/reset-seed` bằng context mới, không có cookie đăng nhập, trả HTTP 200, JSON success=true. Trước request, user 5 của clone có tên AUDIT_RESET_SENTINEL, Student có đăng ký course 6 phát sinh từ thử nghiệm. Sau request, tên trở về seed và đăng ký biến mất. Seed chứa DELETE các bảng khóa học, đăng ký, bài thi, tiến độ và token.

Cần bỏ endpoint reset khỏi bản chạy thông thường; công cụ nội bộ phải có cấu hình bật rõ ràng, phân quyền và bảo vệ thao tác ghi. Không dùng GET để reset.

## 2. [Nghiêm trọng] Trả link reset mật khẩu cho người yêu cầu
Vị trí: AuthServlet.java:439; forgot-password-check-email.jsp:360, :368.

Khách POST forgot-password với email student2@courson.edu.vn nhận HTML chứa link reset-password kèm token hợp lệ. Dùng token đổi mật khẩu rồi đăng nhập bằng mật khẩu mới thành công (302 tới registrations/my), không cần mở hộp thư.

SMTP audit trỏ về loopback cổng đóng để không gửi thư thật. Đã xác nhận đường fallback khi SMTP lỗi cho phép chiếm tài khoản. Chưa xác minh cùng hành vi khi SMTP thật gửi thành công.

Cần bỏ token/link reset khỏi HTML và response dành cho người yêu cầu; link chỉ được gửi tới hộp thư chủ tài khoản.

## 3. [Cao] Voucher không hợp lệ vẫn giảm toàn bộ học phí
Vị trí: RegistrationServlet.java:190, :206, :208.

Student POST `/registrations/checkout` với courseId=6, voucherCode=INVALID_AUDIT_CODE, discountAmount=350000. Course giá 350.000đ nhưng SQL xác nhận đăng ký mới ACTIVE/FREE, payment_amount=0. Mở `/courses/learn?registrationId=15` bằng phiên Student trả 200, giữ đúng URL, hiển thị trình ghi chú bài học.

Cần tính giảm giá từ voucher hợp lệ phía server, không tin discountAmount của client; kiểm tra giá cuối tại service đăng ký/thanh toán.

## 4. [Trung bình] ID tiến độ sai gây HTTP 500, lộ stack trace
Vị trí: CourseServlet.java:304.

Student POST `/courses/update-progress` với registrationId=abc, lessonId=1, status=COMPLETED nhận 500, NumberFormatException và stack trace Tomcat. Cần parse/kiểm tra ID và trả 400 có kiểm soát.

## 5. [Thấp] Checkout điều hướng bằng tham số không được hỗ trợ
Vị trí: RegistrationServlet.java:236; CourseServlet.showLearn.

Checkout miễn phí chuyển tới `/courses/learn?courseId=6` nhưng trang học cần registrationId. Thử courseId=1 với tài khoản đã có quyền học vẫn bị chuyển về registrations/my. Dùng registrationId hợp lệ thì vào được bài học. Cần thống nhất tham số.

## Môi trường và giới hạn
WAR mới build chạy trên Tomcat riêng cổng 18080, database clone audit_stability_20261107. Không chạy reset-seed, đổi mật khẩu hay test ghi trên database gốc/server 8080. Giữ nguyên các thay đổi chưa commit có sẵn.

Đợt browser chính chặn domain ngoài localhost nên có 2 lỗi Quill is not defined do chặn CDN. Kiểm tra lại trang học với mạng bình thường: Quill tải được, không có pageerror; chỉ 2 request quảng cáo YouTube lỗi DNS. Không coi lỗi Quill trong đợt chặn CDN là lỗi ứng dụng ở điều kiện mạng bình thường.

Chưa kiểm tra email/VNPay thật, Google OAuth, Gemini, tải ghi/thanh toán đồng thời, mọi CRUD, responsive hay chạy bền nhiều giờ. Test nghiệp vụ không chứng minh dịch vụ ngoài hoạt động.

## Bằng chứng
Thư mục test-evidence-2026-11-07 chứa log Maven, JSON browser/security/load/targeted, SQL trước/sau reset, so sánh deployment, ảnh và script .cjs tái hiện. Script có đường dẫn local cần chỉnh theo máy và chỉ chạy với database cô lập.

## Dọn dẹp
Tomcat audit đã dừng và database clone đã xóa. Giữ báo cáo/bằng chứng trong docs. Cơ chế duyệt tự động chặn lệnh dọn có xóa thư mục tạm đệ quy với lý do chung blocked by policy; không thực hiện lại thao tác xóa đó. Thư mục C:/Users/admin/AppData/Local/Temp/courson-stability-20261107 vẫn còn, chứa snapshot database và bộ chạy test. Không thay đổi mã nguồn ứng dụng.
