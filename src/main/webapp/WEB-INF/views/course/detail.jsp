<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${course.title} - Chi tiết khóa học" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
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

                <!-- Curriculum -->
                <div class="card p-4 shadow-sm border-0">
                    <h4 class="fw-bold mb-3"><i class="bi bi-list-check me-2"></i>Chương trình học</h4>
                    <c:choose>
                        <c:when test="${empty course.modules}">
                            <p class="text-muted">Nội dung chương trình đang được cập nhật.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="accordion" id="curriculumAccordion">
                                <c:forEach var="m" items="${course.modules}" varStatus="status">
                                    <div class="accordion-item mb-2 border rounded overflow-hidden">
                                        <h2 class="accordion-header">
                                            <button class="accordion-button ${status.first ? '' : 'collapsed'} bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#module${m.id}">
                                                <div class="d-flex justify-content-between align-items-center w-100 me-3">
                                                    <strong>Chương ${m.orderIndex}: ${m.title}</strong>
                                                    <span class="badge bg-secondary-subtle text-dark">${m.lessons.size()} bài học</span>
                                                </div>
                                            </button>
                                        </h2>
                                        <div id="module${m.id}" class="accordion-collapse collapse ${status.first ? 'show' : ''}" data-bs-parent="#curriculumAccordion">
                                            <div class="accordion-body p-0">
                                                <ul class="list-group list-group-flush">
                                                    <c:forEach var="l" items="${m.lessons}">
                                                        <li class="list-group-item d-flex align-items-center gap-3 py-2">
                                                            <img src="${l.thumbnailUrl}" class="rounded shadow-sm" style="width: 72px; height: 42px; object-fit: cover;" alt="${l.title}">
                                                            <div class="flex-grow-1 text-truncate">
                                                                <span class="fw-semibold small d-block text-truncate">Bài ${l.orderIndex}: ${l.title}</span>
                                                                <span class="text-muted" style="font-size: 0.75rem;"><i class="bi bi-camera-video me-1"></i>Video bài giảng</span>
                                                            </div>
                                                            <span class="badge bg-light text-muted border">Bài học</span>
                                                        </li>
                                                    </c:forEach>
                                                    <c:forEach var="q" items="${m.quizzes}">
                                                        <li class="list-group-item d-flex justify-content-between align-items-center py-3 bg-light-subtle">
                                                            <div>
                                                                <i class="bi bi-question-circle-fill text-warning me-2 fs-5"></i>
                                                                <span class="fw-semibold">${q.title}</span>
                                                            </div>
                                                            <span class="badge bg-warning-subtle text-dark border">Bài kiểm tra</span>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Enroll Sidebar -->
            <div class="col-lg-4">
                <div class="card p-4 sticky-top" style="top: 80px;">
                    <div class="text-center mb-3">
                        <span class="fs-2 fw-bold text-success">
                            <c:choose>
                                <c:when test="${course.price <= 0}">Miễn phí</c:when>
                                <c:otherwise>${course.price} VNĐ</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <a href="${pageContext.request.contextPath}/registrations/checkout?courseId=${course.id}" class="btn btn-primary btn-lg w-100 fw-semibold mb-3">
                        <i class="bi bi-lightning-charge-fill me-1"></i>Đăng ký học ngay
                    </a>

                    <div class="small text-muted">
                        <div class="d-flex align-items-center mb-2"><i class="bi bi-check-circle-fill text-success me-2"></i>Truy cập trọn đời tất cả tài liệu</div>
                        <div class="d-flex align-items-center mb-2"><i class="bi bi-check-circle-fill text-success me-2"></i>Học theo tiến độ cá nhân linh hoạt</div>
                        <div class="d-flex align-items-center"><i class="bi bi-check-circle-fill text-success me-2"></i>Cấp chứng nhận hoàn thành khóa học</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
