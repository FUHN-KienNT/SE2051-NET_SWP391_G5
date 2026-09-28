<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Xác nhận đơn hàng - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Title -->
        <div class="mb-4 text-center">
            <h3 class="fw-bold mb-1"><i class="bi bi-cart-check me-2 text-primary"></i>Xác nhận đăng ký khóa học (Course Checkout)</h3>
            <p class="text-muted small">Kiểm tra thông tin chi tiết đơn hàng trước khi tiến hành thanh toán (Màn hình II.3.1)</p>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3 p-4 mb-4">
                    <h5 class="fw-bold mb-3 border-bottom pb-2">Thông tin khóa học đã chọn</h5>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="fw-bold text-primary mb-1">${course.title}</h5>
                            <p class="text-muted small mb-0">${course.description}</p>
                        </div>
                        <div class="text-end">
                            <span class="fs-4 fw-bold text-success">
                                <c:choose>
                                    <c:when test="${course.price <= 0}">Miễn phí</c:when>
                                    <c:otherwise>${course.price} VNĐ</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <div class="p-3 bg-light rounded-3 mb-4">
                        <div class="row g-2 small">
                            <div class="col-6"><i class="bi bi-person me-2 text-primary"></i>Người mua: <strong>${sessionScope.CURRENT_USER.fullName}</strong></div>
                            <div class="col-6"><i class="bi bi-envelope me-2 text-primary"></i>Email: <strong>${sessionScope.CURRENT_USER.email}</strong></div>
                            <div class="col-6"><i class="bi bi-infinity me-2 text-success"></i>Thời hạn truy cập: <strong>Trọn đời</strong></div>
                            <div class="col-6"><i class="bi bi-award me-2 text-warning"></i>Chứng nhận: <strong>Có (Sau khi hoàn thành)</strong></div>
                        </div>
                    </div>

                    <!-- Price summary table -->
                    <h5 class="fw-bold mb-3 border-bottom pb-2">Chi tiết học phí</h5>
                    <div class="d-flex justify-content-between py-2 border-bottom">
                        <span class="text-muted">Giá niêm yết</span>
                        <span>${course.price > 0 ? course.price.concat(' VNĐ') : '0 VNĐ'}</span>
                    </div>
                    <div class="d-flex justify-content-between py-2 border-bottom">
                        <span class="text-muted">Giảm giá / Ưu đãi</span>
                        <span class="text-success">- 0 VNĐ</span>
                    </div>
                    <div class="d-flex justify-content-between py-3 mb-4">
                        <strong class="fs-5">Tổng thanh toán:</strong>
                        <strong class="fs-4 text-primary">${course.price > 0 ? course.price.concat(' VNĐ') : 'Miễn phí'}</strong>
                    </div>

                    <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/courses/detail?id=${course.id}" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại
                        </a>

                        <c:choose>
                            <c:when test="${course.price <= 0}">
                                <form action="${pageContext.request.contextPath}/registrations/enroll" method="POST">
                                    <input type="hidden" name="courseId" value="${course.id}">
                                    <button type="submit" class="btn btn-success btn-lg px-4 fw-semibold">
                                        <i class="bi bi-check-circle me-1"></i>Kích hoạt học ngay (Miễn phí)
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/registrations/payment?courseId=${course.id}" class="btn btn-primary btn-lg px-4 fw-semibold">
                                    <i class="bi bi-credit-card me-1"></i>Tiếp tục thanh toán (Payment)
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
