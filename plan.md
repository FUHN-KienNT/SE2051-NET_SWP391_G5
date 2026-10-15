# Plan: Refactor Quiz Management Data Access

## 1. Mục tiêu

Làm cho phần Quiz Management dễ hiểu, dễ bảo trì và truy vấn hiệu quả
hơn mà **không tạo thêm nhiều class, DTO, Service hoặc DAO không cần
thiết**.

Các mục tiêu cụ thể:

-   Mỗi màn hình chỉ tải dữ liệu mà màn hình đó thực sự cần.
-   Giữ kiến trúc hiện tại: `Servlet → Service → DAO → Database`.
-   Tránh dùng luồng dựng toàn bộ cây `Course → Modules → Quizzes` cho
    những màn hình chỉ cần danh sách quiz hoặc vài trường thông tin.
-   Tránh truy vấn lặp theo từng module/câu hỏi khi có thể lấy dữ liệu
    theo lô.
-   Giữ nguyên hành vi, phân quyền và giao diện hiện có trong quá trình
    refactor.
-   Chỉ thêm phương thức hoặc class khi chúng giải quyết một trách nhiệm
    rõ ràng.

> Lưu ý: Đây là kế hoạch refactor dựa trên các luồng code đã thảo luận.
> Trước khi sửa, cần kiểm tra code hiện tại, các call site và schema
> database để xác nhận tên phương thức, quan hệ bảng và hành vi thực tế.

## 2. Nguyên tắc thiết kế

### 2.1. Lấy dữ liệu theo use case, không theo cây object lớn nhất

Không phải màn hình nào cũng cần một `CourseDto` đầy đủ chứa toàn bộ
module và quiz.

-   Quiz List cần danh sách quiz và các trường dùng để hiển thị/lọc.
-   Quiz Detail cần thông tin của một quiz, câu hỏi đã gán, đáp án/điểm
    số liên quan và dữ liệu bổ sung mà màn hình thực sự dùng.
-   Course overview hoặc màn hình tổng quan mới nên dựng cây khóa học
    nếu thực sự cần cây đó.

### 2.2. Giữ đúng trách nhiệm của từng tầng

-   **Servlet:** đọc và validate request parameters ở mức đầu vào, gọi
    Service, đưa dữ liệu vào request/session phù hợp và
    forward/redirect.
-   **Service:** điều phối use case, kiểm tra quy tắc nghiệp vụ và quyền
    truy cập theo thiết kế hiện có.
-   **DAO:** truy vấn database bằng `PreparedStatement`, ánh xạ kết quả
    sang Entity hoặc dữ liệu truy vấn phù hợp.
-   **DTO/View model hiện có:** cung cấp dữ liệu cần cho view; không tạo
    DTO mới nếu DTO hiện tại đã đáp ứng tốt.
-   **JSP/JavaScript:** hiển thị và tương tác UI; không chứa truy vấn
    database hay nghiệp vụ phức tạp.

### 2.3. Không tối ưu quá sớm

Không bắt buộc phải có pagination, query mới, DTO mới hoặc class mới nếu
quy mô dữ liệu và yêu cầu hiện tại chưa cần. Ưu tiên loại bỏ việc tải dữ
liệu thừa trước, sau đó đo số truy vấn và thời gian thực thi.

## 3. Luồng dữ liệu mục tiêu

### 3.1. Quiz List

Luồng mục tiêu:

`QuizServlet → QuizService.getQuizList(...) → QuizDao → Database → JSP`

Danh sách nên được lấy trực tiếp theo phạm vi cần hiển thị, chẳng hạn
`courseId`, `moduleId`, keyword hoặc điều kiện filter. Tên phương thức
bên trên là tên đề xuất; nên tuân theo naming convention hiện có của
repository.

Quiz List không nên gọi phương thức dựng toàn bộ cây khóa học chỉ để lấy
danh sách quiz nếu nó không cần dữ liệu cây đó.

Các trường cần lấy nên giới hạn ở những gì trang sử dụng, ví dụ:

-   quiz ID và title;
-   module ID/tên module nếu UI hiển thị;
-   trạng thái hoặc metadata nếu có trên màn hình;
-   các trường phục vụ sort/filter thực tế.

Không lấy câu hỏi, options hoặc chi tiết quiz cho từng hàng trong danh
sách nếu người dùng chỉ cần mở trang detail để xem chúng.

### 3.2. Quiz Detail

Luồng mục tiêu:

`QuizServlet → QuizService.getQuizDetail(quizId) → các DAO cần thiết → JSP`

Chỉ lấy:

-   thông tin quiz và cấu hình;
-   danh sách câu hỏi đã gán vào quiz;
-   đáp án/options và điểm số cần hiển thị;
-   thông tin module/course tối thiểu nếu view cần hiển thị breadcrumb
    hoặc ngữ cảnh;
-   question bank riêng nếu trang có chức năng thêm câu hỏi từ bank.

Không gọi `CourseService.getCourseDetail()` chỉ để lấy một vài trường
course/module nếu phương thức đó dựng cả cây dữ liệu lớn. Trước tiên
kiểm tra xem đã có phương thức truy vấn tối thiểu trong code chưa; nếu
chưa, cân nhắc một query nhỏ hoặc tái sử dụng DAO hiện có. Tránh tạo cả
một hệ thống lớp mới chỉ cho vài trường.

Nếu câu hỏi đã gán và question bank có thể trùng nhau, xác định rõ mục
đích của mỗi danh sách và loại trừ các câu hỏi đã gán ở đúng tầng truy
vấn hoặc service. Không tải cùng một tập dữ liệu hai lần rồi lọc lại nếu
query có thể trả về kết quả phù hợp ngay từ đầu.

### 3.3. Tổng số quiz

Nếu `CourseDto.getTotalQuizzes()` đang cộng `m.getQuizzes().size()` trên
cây module, giữ cách này ở màn hình vốn đã có cây dữ liệu và cần tổng từ
cây đó.

Nếu một trang chỉ cần con số tổng mà không cần danh sách đầy đủ, dùng
query `COUNT(*)` có điều kiện trong DAO là lựa chọn phù hợp hơn. Không
tạo một DAO/class riêng chỉ để thực hiện một phép đếm; thêm phương thức
vào DAO phù hợp hiện có.

Cần bảo đảm điều kiện đếm giống với điều kiện danh sách: cùng
course/module, trạng thái và phạm vi quyền truy cập nếu các yếu tố này
ảnh hưởng đến kết quả.

## 4. Filter và phân trang

### Giai đoạn đầu

Nếu mỗi course chỉ có ít quiz và toàn bộ danh sách đã được tải hợp lý,
có thể lọc/sắp xếp trên frontend để tránh thêm request và backend code
không cần thiết.

### Khi cần truy vấn server

Nếu danh sách lớn, cần tìm kiếm trên toàn bộ dữ liệu hoặc cần phân
trang, gửi query parameters đến Servlet, ví dụ:

`GET /quiz/list?courseId=10&moduleId=3&keyword=java&page=1&pageSize=20`

Quy tắc triển khai:

-   Validate `courseId`, `moduleId`, `page` và `pageSize`; dùng giá trị
    mặc định hợp lệ khi tham số tùy chọn bị thiếu.
-   Không nối chuỗi input trực tiếp vào SQL; dùng `PreparedStatement`.
-   Chỉ thêm các điều kiện lọc thực sự được UI hỗ trợ.
-   Giữ filter khi chuyển trang.
-   Nếu có pagination, dùng query đếm tổng phù hợp để hiển thị tổng số
    trang; không tải tất cả quiz chỉ để đếm.
-   Không thêm AJAX/API riêng nếu request GET thông thường và
    server-rendered JSP đã đáp ứng nhu cầu.

## 5. Rà soát truy vấn và nguy cơ N+1

Trước khi tối ưu, ghi lại các DAO được gọi trong một lần mở Quiz List và
Quiz Detail.

Kiểm tra các dấu hiệu:

-   Lặp qua modules rồi mỗi module gọi một query lấy quiz.
-   Lặp qua questions rồi mỗi question gọi một query lấy options.
-   Lặp qua quizzes rồi mỗi quiz gọi một query lấy question count.
-   Truy vấn lại course/module trong khi thông tin đó đã có trong kết
    quả trước đó.

Nếu có N+1 và dữ liệu đủ lớn để ảnh hưởng, ưu tiên một trong các cách
sau:

1.  Lấy danh sách bằng một query có điều kiện hoặc JOIN phù hợp.
2.  Lấy dữ liệu liên quan theo lô bằng `IN (...)` và nhóm kết quả trong
    Java.
3.  Dùng aggregate query cho count/sum nếu chỉ cần số liệu tổng hợp.

Không nên dùng JOIN một cách máy móc: JOIN nhiều quan hệ một-nhiều có
thể nhân bản hàng và làm kết quả sai hoặc tốn bộ nhớ. Khi dùng JOIN,
kiểm tra số lượng hàng và mapping. Dùng `DISTINCT` chỉ khi đúng với
semantics, không dùng để che lỗi join.

Không cần xây generic repository, query builder hay một abstraction mới
chỉ để tránh vài dòng SQL lặp lại.

## 6. Kế hoạch thực hiện theo từng bước

### Bước 1 --- Chụp lại hành vi hiện tại

-   Ghi lại các màn hình Quiz List, Quiz Detail, create/edit quiz và
    thao tác thêm/xóa câu hỏi.
-   Ghi lại filter, sort, quyền truy cập và các thông báo hiện có.
-   Xác định các class/method thực tế được gọi từ từng Servlet.
-   Đọc các DAO và SQL liên quan trước khi quyết định thay đổi.

**Kết quả:** có bản đồ call flow và danh sách hành vi cần giữ nguyên.

### Bước 2 --- Tối giản Quiz List

-   Xác định chính xác các trường JSP đang dùng.
-   Kiểm tra danh sách quiz hiện lấy từ đâu và có gọi
    `buildCourseTree()` hay không.
-   Nếu đang dựng toàn bộ cây chỉ để lấy quiz, thay bằng phương thức
    list query trong `QuizDao` hiện có hoặc bổ sung một method rõ nghĩa
    vào DAO đó.
-   Thêm/điều chỉnh method Service chỉ khi cần giữ quy tắc nghiệp vụ
    hoặc điều phối.
-   Giữ Servlet mỏng; không đưa SQL vào Servlet.
-   Không tạo DTO mới nếu DTO hiện tại đủ trường. Nếu Entity đang được
    truyền thẳng tới view và điều đó đã là quy ước của dự án, không đổi
    toàn bộ chỉ trong lần refactor này.

**Tiêu chí hoàn tất:** Quiz List hiển thị đúng dữ liệu, không tải câu
hỏi/options không cần thiết và không dựng course tree nếu không có nhu
cầu thực sự.

### Bước 3 --- Tối giản Quiz Detail

-   Liệt kê dữ liệu mà `detail.jsp` thực sự sử dụng.
-   Tách rõ quiz questions (đã gán) và question bank (có thể thêm).
-   Kiểm tra các lời gọi lấy course/module; chỉ lấy metadata cần thiết.
-   Kiểm tra việc lấy options và điểm số có truy vấn riêng theo từng câu
    hỏi hay không.
-   Nếu có N+1 đáng kể, thay bằng truy vấn theo lô hoặc JOIN có mapping
    đúng.
-   Giữ nguyên hành vi create/update/remove assignment và thứ tự câu
    hỏi.

**Tiêu chí hoàn tất:** một lần mở trang không tải trùng cùng tập dữ liệu
không cần thiết; mọi câu hỏi, options, điểm số và thứ tự vẫn chính xác.

### Bước 4 --- Xử lý tổng số quiz

-   Xác định mỗi nơi cần tổng số quiz hay danh sách quiz.
-   Giữ getter tính từ `modules` ở nơi cây module đã được dựng.
-   Dùng aggregate query trong DAO khi màn hình chỉ cần count và không
    cần danh sách.
-   Không gọi query count riêng nếu đã có đầy đủ danh sách phù hợp và
    count đó không gây vấn đề.

**Tiêu chí hoàn tất:** tổng số quiz khớp với filter/phạm vi hiển thị và
không cần tải dữ liệu lớn chỉ để đếm.

### Bước 5 --- Thêm filter theo nhu cầu thật

-   Bắt đầu với các filter có trong UI hiện tại.
-   Với danh sách nhỏ đã tải: frontend filter có thể đủ.
-   Với danh sách lớn hoặc pagination: server-side filter.
-   Chỉ bổ sung điều kiện SQL cho các filter cần thiết.
-   Không thêm API/AJAX mới trừ khi UX cần cập nhật không tải lại trang.

**Tiêu chí hoàn tất:** filter kết hợp đúng, không làm mất course/module
scope, không bypass quyền truy cập và giữ filter khi chuyển trang nếu có
pagination.

### Bước 6 --- Đo và dọn code

-   Đếm số lần DAO/query được gọi khi mở từng trang.
-   Kiểm tra log SQL ở môi trường phát triển nếu có.
-   Xóa method/import/attribute cũ chỉ sau khi tìm toàn bộ call sites và
    xác nhận không còn dùng.
-   Không xóa method chung nếu màn hình khác còn cần nó.
-   Không tạo thêm lớp trung gian chỉ chuyển tiếp một lời gọi mà không
    thêm trách nhiệm.

**Tiêu chí hoàn tất:** luồng dễ đọc hơn, truy vấn giảm hoặc chỉ lấy đúng
dữ liệu cần thiết, không có code dead mới.

## 7. Kiểm thử hồi quy bắt buộc

### Quiz List

-   Course có nhiều module và quiz.
-   Module không có quiz.
-   Course không có quiz.
-   Filter trả về kết quả và không có kết quả.
-   Module/course ID không hợp lệ.
-   Người dùng không có quyền truy cập.
-   Tổng quiz đúng theo phạm vi và điều kiện lọc.

### Quiz Detail

-   Quiz không có câu hỏi.
-   Quiz có nhiều câu hỏi và options.
-   Question bank có câu hỏi đã gán và chưa gán.
-   Thêm/xóa câu hỏi và đổi thứ tự.
-   Điểm số/tổng điểm/pass score đúng.
-   Quiz hoặc ID liên quan không tồn tại.
-   Người dùng không có quyền xem/chỉnh sửa.

### Hiệu năng và dữ liệu

-   So sánh số query trước/sau trên cùng dữ liệu.
-   Kiểm tra không có truy vấn theo từng hàng nếu có thể lấy theo lô.
-   Kiểm tra không nhân bản quiz/question khi JOIN.
-   Kiểm tra SQL injection cơ bản bằng cách bảo đảm tất cả tham số đều
    bind qua `PreparedStatement`.

## 8. Không làm trong đợt refactor này

Để tránh phát sinh code thừa, không nên đồng thời:

-   Viết lại toàn bộ kiến trúc MVC.
-   Chuyển dự án sang REST API hoặc framework khác.
-   Tạo generic repository/query builder.
-   Tạo DTO riêng cho mọi bảng hoặc mọi phương thức.
-   Thêm cache khi chưa đo được vấn đề.
-   Thêm pagination nếu quy mô dữ liệu và yêu cầu chưa cần.
-   Thay đổi schema database nếu không có yêu cầu nghiệp vụ.
-   Refactor các module ngoài Quiz Management khi không liên quan.

## 9. Checklist review pull request

-   [ ] Mỗi màn hình chỉ lấy dữ liệu thực sự sử dụng.
-   [ ] Không gọi `buildCourseTree()` chỉ để lấy danh sách quiz hoặc vài
    trường metadata.
-   [ ] Servlet không chứa SQL hoặc logic nghiệp vụ phức tạp.
-   [ ] Service không trở thành nơi tự truy vấn JDBC trực tiếp nếu kiến
    trúc đang quy định DAO phụ trách.
-   [ ] DAO dùng `PreparedStatement`.
-   [ ] Không có N+1 không cần thiết ở quiz/questions/options.
-   [ ] Không tạo DTO/Service/DAO mới nếu có thể mở rộng class hiện tại
    một cách rõ ràng.
-   [ ] Không xóa method dùng chung trước khi kiểm tra call sites.
-   [ ] Tổng số quiz và filter trả về đúng phạm vi.
-   [ ] Quyền truy cập và các thao tác quản lý quiz không bị thay đổi
    ngoài dự kiến.
-   [ ] Các test hồi quy đều pass.

## 10. Thứ tự ưu tiên cuối cùng

1.  **Ưu tiên cao nhất:** vẽ đúng call flow và xác định dữ liệu JSP
    dùng.
2.  **Tiếp theo:** tách query cho Quiz List khỏi luồng dựng cây khóa học
    nếu hiện tại đang dùng chung không cần thiết.
3.  **Tiếp theo:** kiểm tra Quiz Detail có truy vấn lặp cho
    questions/options hay không và tối ưu theo lô nếu cần.
4.  **Sau đó:** chuẩn hóa filter/count theo nhu cầu thực tế.
5.  **Cuối cùng:** dọn code cũ và đo lại.

Nguyên tắc xuyên suốt: **tối giản luồng dữ liệu trước, tối ưu số truy
vấn dựa trên bằng chứng, và chỉ thêm code khi nó làm rõ trách nhiệm hoặc
đáp ứng một yêu cầu thực sự.**
