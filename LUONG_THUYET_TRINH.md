# 📑 MỤC LỤC TRÌNH DIỄN CODE BẢO VỆ ĐỒ ÁN - COURSON LMS
> **Hướng dẫn:** Chỉ cần giữ phím `Ctrl` và Click chuột vào bất kỳ liên kết nào dưới đây, IDE sẽ tự động mở đúng file và nhảy đến đúng dòng code.

---

## 🎯 LUỒNG: EXPERT DASHBOARD & LẤY BÀI HỌC (END-TO-END)

### 📍 Trạm 1: Điểm phát sinh Request từ Frontend
- [header.jsp (Dòng 568 - Thẻ Link trên Navbar)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/webapp/WEB-INF/views/common/header.jsp#L568)
  - *Giải thích:* Thẻ `<a>` gửi request `GET /Courson/expert/dashboard`.
- [AuthServlet.java (Dòng 356 - Redirect sau khi đăng nhập)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/java/controller/AuthServlet.java#L356)
  - *Giải thích:* Sau khi login thành công với role EXPERT, server trả mã HTTP 302 chuyển hướng về `/expert/dashboard`.

---

### 📍 Trạm 2: Controller tiếp nhận & điều phối
- [LessonServlet.java (Dòng 70 - Phương thức doGet)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/java/controller/LessonServlet.java#L70)
  - *Giải thích:* Đón nhận HTTP GET, bóc tách `pathInfo = "/dashboard"`.
- [LessonServlet.java (Dòng 122 - Switch-case router)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/java/controller/LessonServlet.java#L122)
  - *Giải thích:* Phân loại action "dashboard" gọi hàm `showExpertDashboard`.
- [LessonServlet.java (Dòng 220 - Hàm showExpertDashboard)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/java/controller/LessonServlet.java#L220)
  - *Giải thích:* Đọc Session lấy `currentUser.getId()`, gọi `courseService`, gắn vào `req.setAttribute("courses", courses)` và forward sang JSP.

---

### 📍 Trạm 3: Tầng Nghiệp vụ (Service & Cây Dữ Liệu)
- [CourseService.java (Dòng 350 - Hàm getManagedCourses)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/java/service/CourseService.java#L350)
  - *Giải thích:* Gọi DAO lấy khóa học của giảng viên, rồi lặp qua từng khóa để gọi `buildCourseTree`.
- [CourseService.java (Dòng 1893 - Hàm buildCourseTree)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/java/service/CourseService.java#L1893)
  - *Giải thích:* Gom Khóa học -> Chương (Module) -> Bài học (Lesson) thành đối tượng cây phân cấp.
- [CourseDto.java (Dòng 142 - Hàm tính tổng bài học getTotalLessons)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/java/dto/CourseDto.java#L142)
  - *Giải thích:* Computed Getter tự động đếm tổng số bài học `active = true` trong các module để phục vụ `${c.totalLessons}`.

---

### 📍 Trạm 4: Tầng Truy cập Dữ liệu & Câu lệnh SQL (DAO)
- [CourseDao.java (Dòng 19 - Câu lệnh SQL ORDER BY id DESC)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/java/dao/CourseDao.java#L19)
  - *Giải thích:* Câu lệnh SQL sắp xếp `ORDER BY id DESC` đưa khóa học mới nhất (#47) lên đầu.
- [CourseDao.java (Dòng 122 - Hàm JDBC findByManagerOrExpert)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/java/dao/CourseDao.java#L122)
  - *Giải thích:* Dùng PreparedStatement truyền userId vào câu lệnh SQL để truy vấn PostgreSQL.
- [LessonDao.java (Dòng 14 - Câu lệnh SQL lấy bài học ORDER BY order_index)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/java/dao/LessonDao.java#L14)
  - *Giải thích:* Sắp xếp bài học theo thứ tự tăng dần 1, 2, 3... trong chương.

---

### 📍 Trạm 5: Giao diện JSP hiển thị & Bộ lọc JavaScript
- [dashboard.jsp (Dòng 978 - Vòng lặp hiển thị từng khóa học)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/webapp/WEB-INF/views/expert/dashboard.jsp#L978)
  - *Giải thích:* Thẻ `<c:forEach var="c" items="${courses}">` duyệt từng khóa học và in `${c.totalLessons}`.
- [dashboard.jsp (Dòng 983 - In số thứ tự STT 1, 2, 3, 4)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/webapp/WEB-INF/views/expert/dashboard.jsp#L983)
  - *Giải thích:* In `${status.count}` tự tăng.
- [dashboard.jsp (Dòng 1425 - Hàm JavaScript filterCourses & applyFilters)](file:///d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/webapp/WEB-INF/views/expert/dashboard.jsp#L1425)
  - *Giải thích:* Lọc trực tiếp các dòng `<tr>` bằng `row.style.display` trên trình duyệt theo `data-status`.
