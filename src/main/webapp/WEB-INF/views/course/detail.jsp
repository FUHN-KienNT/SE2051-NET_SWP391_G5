<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${course.title} - Chi tiết khóa học" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Notice Before Archiving Banner -->
        <c:if test="${course.archiveScheduled}">
            <div class="alert alert-warning border border-warning shadow-sm rounded-3 mb-4 py-3 px-4 d-flex align-items-center gap-3">
                <i class="bi bi-exclamation-triangle-fill fs-2 text-warning flex-shrink-0"></i>
                <div class="flex-grow-1">
                    <h5 class="fw-bold mb-1 text-dark">Thông báo: Khóa học sắp chuyển sang chế độ Lưu trữ</h5>
                    <p class="mb-0 small text-dark">
                        Khóa học này dự kiến sẽ chính thức ngừng nhận học viên mới và chuyển sang chế độ Lưu trữ vào ngày <strong>${course.formattedArchiveAt}</strong> (còn <strong>${course.daysUntilArchive}</strong> ngày).
                        <c:if test="${not empty course.archiveNotice}">
                            <br><span class="fw-semibold">Lời nhắn từ Chuyên gia:</span> "${course.archiveNotice}"
                        </c:if>
                        <br><em class="text-muted">* Lưu ý: Sinh viên đăng ký trước thời hạn này vẫn được toàn quyền sở hữu và học tập trọn đời.</em>
                    </p>
                </div>
            </div>
        </c:if>

        <c:if test="${course.archived}">
            <div class="alert alert-secondary border shadow-sm rounded-3 mb-4 py-3 px-4 d-flex align-items-center gap-3">
                <i class="bi bi-archive-fill fs-2 text-secondary flex-shrink-0"></i>
                <div class="flex-grow-1">
                    <h5 class="fw-bold mb-1 text-dark">Khóa học này đã được Lưu trữ</h5>
                    <p class="mb-0 small text-muted">
                        Khóa học hiện đã ngừng nhận học viên mới. 
                        <c:if test="${not empty course.archiveNotice}">
                            <span><strong>Thông báo:</strong> "${course.archiveNotice}"</span><br>
                        </c:if>
                        Học viên đã mua trước đây vẫn được đảm bảo toàn bộ quyền truy cập và học tập bình thường.
                    </p>
                </div>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Course Info -->
            <div class="col-lg-8">
                <div class="card p-0 mb-4 overflow-hidden border-0 shadow-sm">
                    <img src="${course.thumbnailUrl}" class="w-100" style="height: 320px; object-fit: cover;" alt="${course.title}" onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1200&auto=format&fit=crop&q=60'">
                    <div class="p-4">
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle align-self-start mb-2">
                            ${course.categoryName != null ? course.categoryName : "Khóa học"}
                        </span>
                        <h2 class="fw-bold mb-3">${course.title}</h2>
                        <p class="lead text-muted fs-6 mb-4">${course.description}</p>
                        
                        <div class="d-flex gap-4 border-top pt-3 small text-muted">
                            <div><i class="bi bi-person me-1"></i>Chuyên gia: <strong>${course.expertName != null ? course.expertName : "Đội ngũ Courson"}</strong></div>
                            <div><i class="bi bi-collection-play me-1"></i>Tổng bài giảng: <strong>${course.totalLessons} bài</strong></div>
                            <div><i class="bi bi-clock me-1"></i>Trạng thái: <strong>${course.status}</strong></div>
                        </div>
                    </div>
                </div>

                <!-- Curriculum: Streamlined Direct Lesson List -->
                <div class="card p-4 shadow-sm border-0">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3 pb-2 border-bottom">
                        <div>
                            <h4 class="fw-bold mb-0"><i class="bi bi-play-circle-fill text-danger me-2"></i>Danh sách bài giảng (${course.totalLessons} bài học)</h4>
                            <p class="text-muted small mb-0">Theo dõi toàn bộ các video bài học tuần tự theo tên</p>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <input type="text" id="lessonSearchInput" class="form-control form-control-sm" placeholder="Tìm tên bài học..." style="max-width: 220px;" onkeyup="filterLessonList()">
                            <span class="badge bg-primary-subtle text-primary border">${course.totalLessons} bài</span>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${course.totalLessons == 0}">
                            <div class="p-4 text-center text-muted">
                                <i class="bi bi-journal-x fs-2 text-muted d-block mb-2"></i>
                                Nội dung khóa học đang được cập nhật.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:set var="globalLessonIndex" value="1" />
                            <div class="list-group list-group-flush rounded-3 border overflow-hidden" id="directLessonList">
                                <c:forEach var="m" items="${course.modules}">
                                    <c:forEach var="l" items="${m.lessons}">
                                        <div class="list-group-item d-flex align-items-center gap-3 py-2 px-3 list-group-item-action lesson-row" data-title="${l.title.toLowerCase()}">
                                            <span class="badge bg-light text-muted border text-center flex-shrink-0" style="width: 32px; font-size: 0.8rem;">
                                                #${globalLessonIndex}
                                            </span>
                                            <div class="position-relative flex-shrink-0" style="width: 84px; height: 48px;">
                                                <img src="${l.thumbnailUrl}" class="w-100 h-100 rounded shadow-sm" style="object-fit: cover;" alt="${l.title}"
                                                     onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                                <span class="position-absolute bottom-0 end-0 bg-dark bg-opacity-75 text-white px-1 rounded-1" style="font-size: 9px;">
                                                    <i class="bi bi-play-fill"></i>
                                                </span>
                                            </div>
                                            <div class="flex-grow-1 text-truncate">
                                                <span class="fw-semibold text-dark d-block text-truncate">
                                                    Bài ${globalLessonIndex}: ${l.title}
                                                </span>
                                                <span class="text-muted" style="font-size: 0.75rem;">
                                                    <i class="bi bi-folder2 text-primary me-1"></i>${m.title} &bull; <i class="bi bi-camera-video text-danger ms-1 me-1"></i>Video bài giảng
                                                </span>
                                            </div>
                                            <span class="badge bg-light text-secondary border flex-shrink-0">
                                                <i class="bi bi-play-circle me-1"></i>Bài học
                                            </span>
                                        </div>
                                        <c:set var="globalLessonIndex" value="${globalLessonIndex + 1}" />
                                    </c:forEach>

                                    <c:forEach var="q" items="${m.quizzes}">
                                        <div class="list-group-item d-flex justify-content-between align-items-center py-2 px-3 bg-warning bg-opacity-10 border-top lesson-row" data-title="${q.title.toLowerCase()}">
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="bi bi-patch-question-fill text-warning fs-5"></i>
                                                <div>
                                                    <span class="fw-semibold text-dark d-block">${q.title}</span>
                                                    <small class="text-muted">Chương: ${m.title} &bull; Điểm đạt: ${q.passScore}% &bull; Thời gian: ${q.timeLimitMinutes} phút</small>
                                                </div>
                                            </div>
                                            <span class="badge bg-warning text-dark">Bài kiểm tra</span>
                                        </div>
                                    </c:forEach>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <script>
                    function filterLessonList() {
                        const input = document.getElementById('lessonSearchInput').value.toLowerCase().trim();
                        const rows = document.querySelectorAll('#directLessonList .lesson-row');
                        rows.forEach(function(row) {
                            const title = row.getAttribute('data-title') || '';
                            if (!input || title.includes(input)) {
                                row.style.display = '';
                            } else {
                                row.style.display = 'none';
                            }
                        });
                    }
                </script>
            </div>

            <!-- Action Sidebar (Role-based CTAs) -->
            <div class="col-lg-4">
                <div class="card p-4 sticky-top border-0 shadow-sm rounded-3" style="top: 80px;">
                    <div class="text-center mb-3">
                        <span class="fs-2 fw-bold text-success">
                            <c:choose>
                                <c:when test="${course.price <= 0}">Miễn phí</c:when>
                                <c:otherwise>${course.price} VNĐ</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <c:choose>
                        <%-- 1. Đã sở hữu khóa học (Học viên đã mua trước đây) --%>
                        <c:when test="${hasCourseAccess && userRegistrationId != null}">
                            <div class="alert alert-success py-2 px-3 small mb-3 text-center">
                                <i class="bi bi-check-circle-fill me-1"></i>Bạn đã sở hữu khóa học này!
                            </div>
                            <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${userRegistrationId}" class="btn btn-success btn-lg w-100 fw-semibold mb-3 shadow-sm">
                                <i class="bi bi-play-circle-fill me-1"></i>Vào học ngay
                            </a>
                            <div class="small text-muted">
                                <div class="d-flex align-items-center mb-2"><i class="bi bi-check-circle-fill text-success me-2"></i>Quyền học tập trọn đời được bảo lưu</div>
                                <div class="d-flex align-items-center mb-2"><i class="bi bi-check-circle-fill text-success me-2"></i>Tiếp tục bài học dở dang và làm bài tập</div>
                            </div>
                        </c:when>

                        <%-- 2. Khóa học đã lưu trữ (ngừng nhận học viên mới) --%>
                        <c:when test="${course.archived}">
                            <button class="btn btn-secondary btn-lg w-100 fw-semibold mb-3" disabled>
                                <i class="bi bi-slash-circle me-1"></i>Đã ngừng nhận học viên
                            </button>
                            <div class="alert alert-secondary py-2 px-3 small mb-0 text-center text-muted">
                                Khóa học này hiện đã lưu trữ và không còn nhận học viên mới.
                            </div>
                        </c:when>

                        <%-- 3. GUEST hoặc STUDENT chưa mua: Được quyền đăng ký học --%>
                        <c:when test="${sessionScope.CURRENT_USER == null || sessionScope.CURRENT_USER.roleName == 'STUDENT'}">
                            <a href="${pageContext.request.contextPath}/registrations/checkout?courseId=${course.id}" class="btn btn-primary btn-lg w-100 fw-semibold mb-3">
                                <i class="bi bi-lightning-charge-fill me-1"></i>Đăng ký học ngay
                            </a>
                            <div class="small text-muted">
                                <div class="d-flex align-items-center mb-2"><i class="bi bi-check-circle-fill text-success me-2"></i>Truy cập trọn đời tất cả tài liệu</div>
                                <div class="d-flex align-items-center mb-2"><i class="bi bi-check-circle-fill text-success me-2"></i>Học theo tiến độ cá nhân linh hoạt</div>
                                <div class="d-flex align-items-center"><i class="bi bi-check-circle-fill text-success me-2"></i>Cấp chứng nhận hoàn thành khóa học</div>
                            </div>
                        </c:when>

                        <%-- B. EXPERT: Chuyển sang nút quản lý nội dung bài giảng --%>
                        <c:when test="${sessionScope.CURRENT_USER.roleName == 'EXPERT'}">
                            <div class="alert alert-info py-2 px-3 small mb-3">
                                <i class="bi bi-info-circle me-1"></i>Bạn đang đăng nhập với quyền <strong>Chuyên gia nội dung</strong>.
                            </div>
                            <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-warning btn-lg w-100 fw-semibold mb-2 text-dark">
                                <i class="bi bi-pencil-square me-1"></i>Soạn thảo bài học khóa này
                            </a>
                            <a href="${pageContext.request.contextPath}/expert/dashboard" class="btn btn-outline-secondary w-100">
                                <i class="bi bi-speedometer2 me-1"></i>Expert Studio
                            </a>
                        </c:when>

                        <%-- C. MANAGER / ADMIN: Chuyển sang nút quản trị khóa học --%>
                        <c:otherwise>
                            <div class="alert alert-danger py-2 px-3 small mb-3">
                                <i class="bi bi-shield-lock me-1"></i>Bạn đang đăng nhập với quyền <strong>${sessionScope.CURRENT_USER.roleName}</strong>.
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/course-detail?id=${course.id}" class="btn btn-danger btn-lg w-100 fw-semibold mb-2">
                                <i class="bi bi-gear-fill me-1"></i>Quản trị thông tin khóa học
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-secondary w-100">
                                <i class="bi bi-collection me-1"></i>Danh sách khóa học quản trị
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
