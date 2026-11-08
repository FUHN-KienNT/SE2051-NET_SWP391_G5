<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Cấu hình đơn hàng & Chứng chỉ - Courson LMS" />

<fmt:setLocale value="en_US" />

<jsp:include page="../common/header.jsp" />

<style>

    .checkout-step-pill {

        display: inline-flex;

        align-items: center;

        gap: 8px;

        padding: 6px 16px;

        border-radius: 999px;

        font-size: 13px;

        font-weight: 600;

    }

    .checkout-step-active {

        background-color: #eff6ff;

        color: #2563eb;

        border: 1px solid #bfdbfe;

    }

    .checkout-step-idle {

        background-color: #f3f4f6;

        color: #6b7280;

    }

</style>

<main class="main-content py-5 bg-light-subtle">

    <div class="container">

        <!-- Step Progress Breadcrumb -->

        <div class="d-flex justify-content-center align-items-center gap-3 mb-4">

            <span class="checkout-step-pill checkout-step-active">

                <i class="bi bi-1-circle-fill"></i> 1. Thiết lập đơn hàng & Chứng chỉ (Checkout)

            </span>

            <i class="bi bi-chevron-right text-muted small"></i>

            <span class="checkout-step-pill checkout-step-idle">

                <i class="bi bi-2-circle"></i> 2. Thanh toán trực tuyến (Payment)

            </span>

        </div>

        <c:if test="${not empty errorMessage}">

            <div class="row justify-content-center mb-3">

                <div class="col-lg-10">

                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">

                        <i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${errorMessage}" />

                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>

                    </div>

                </div>

            </div>

        </c:if>

        <form id="checkoutForm" action="${pageContext.request.contextPath}/registrations/checkout" method="POST">

            <input type="hidden" name="courseId" value="${course.id}">

            <div class="row justify-content-center g-4">

                <!-- LEFT COLUMN: Order Configuration & Learner Info (60%) -->

                <div class="col-lg-7">

                    <input type="hidden" name="certificateName" value="<c:out value='${sessionScope.CURRENT_USER.fullName}'/>">

                    <input type="hidden" name="studentPhone" value="<c:out value='${sessionScope.CURRENT_USER.phone}'/>">

                    <!-- Quyền lợi học viên -->

                    <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white">

                        <div class="d-flex align-items-center gap-2 mb-3 border-bottom pb-2">

                            <i class="bi bi-award-fill text-primary fs-5"></i>

                            <h5 class="fw-bold mb-0">Quyền lợi học viên</h5>

                        </div>

                        <div class="row g-3 mb-4">

                            <div class="col-md-4">

                                <div class="p-3 rounded-3 bg-light text-center h-100">

                                    <i class="bi bi-infinity text-primary fs-3 mb-1 d-block"></i>

                                    <span class="fw-semibold small d-block">Truy cập trọn đời</span>

                                    <span class="text-muted" style="font-size: 11px;">Học mọi lúc mọi nơi trên mọi thiết bị</span>

                                </div>

                            </div>

                            <div class="col-md-4">

                                <div class="p-3 rounded-3 bg-light text-center h-100">

                                    <i class="bi bi-file-earmark-arrow-down-fill text-success fs-3 mb-1 d-block"></i>

                                    <span class="fw-semibold small d-block">Tài liệu kèm theo</span>

                                    <span class="text-muted" style="font-size: 11px;">Trọn bộ slide bài giảng và mã nguồn</span>

                                </div>

                            </div>

                            <div class="col-md-4">

                                <div class="p-3 rounded-3 bg-light text-center h-100">

                                    <i class="bi bi-patch-check-fill text-warning fs-3 mb-1 d-block"></i>

                                    <span class="fw-semibold small d-block">Chứng chỉ Courson</span>

                                    <span class="text-muted" style="font-size: 11px;">Chứng chỉ có mã tra cứu điện tử</span>

                                </div>

                            </div>

                        </div>

                    </div>

                    <!-- 3. Cam kết quy chế đào tạo -->

                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">

                        <div class="form-check">

                            <input class="form-check-input" type="checkbox" id="agreeTerms" required checked>

                            <label class="form-check-label small text-muted" for="agreeTerms">

                                Tôi cam kết tuân thủ <strong>Quy chế đào tạo</strong>, tôn trọng bản quyền video bài giảng và đồng ý với chính sách học vụ của Courson LMS.

                            </label>

                        </div>

                    </div>

                </div>

                <!-- RIGHT COLUMN: Course Summary (40%) -->

                <div class="col-lg-5">

                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white sticky-top" style="top: 24px;">

                        <h5 class="fw-bold mb-3 border-bottom pb-2">Tóm tắt đơn hàng</h5>

                        <!-- Course Mini Card -->

                        <div class="d-flex align-items-center gap-3 p-3 rounded-3 bg-light mb-4">

                            <div class="rounded-3 bg-primary bg-opacity-10 text-primary p-2.5 d-flex align-items-center justify-content-center" style="width: 52px; height: 52px;">

                                <i class="bi bi-journal-code fs-3"></i>

                            </div>

                            <div class="flex-grow-1 overflow-hidden">

                                <h6 class="fw-bold text-dark text-truncate mb-1" title="${course.title}">${course.title}</h6>

                                <div class="text-muted small"><i class="bi bi-clock me-1"></i>Học trọn đời &bull; Online 24/7</div>

                            </div>

                        </div>

                        <!-- PRICE BREAKDOWN TABLE -->

                        <div class="bg-light rounded-3 p-3 mb-4">

                            <div class="d-flex justify-content-between py-1 text-muted small">

                                <span>Giá niêm yết:</span>

                                <span class="fw-semibold text-dark">

                                    <c:choose>

                                        <c:when test="${course.price > 0}"><fmt:formatNumber value="${course.price}" pattern="#,###" /> VNĐ</c:when>

                                        <c:otherwise>0 VNĐ</c:otherwise>

                                    </c:choose>

                                </span>

                            </div>

                            <div class="border-top my-2"></div>

                            <div class="d-flex justify-content-between align-items-center">

                                <strong class="text-dark">Tổng thanh toán:</strong>

                                <strong class="fs-4 text-primary">

                                    <c:choose>

                                        <c:when test="${course.price > 0}"><fmt:formatNumber value="${course.price}" pattern="#,###" /> VNĐ</c:when>

                                        <c:otherwise>Miễn phí</c:otherwise>

                                    </c:choose>

                                </strong>

                            </div>

                        </div>

                        <!-- ACTION BUTTONS -->

                        <div class="d-grid gap-2">

                            <c:choose>

                                <c:when test="${course.price <= 0}">

                                    <button type="submit" class="btn btn-success btn-lg fw-semibold shadow-sm py-3 d-flex align-items-center justify-content-center gap-2">

                                        <i class="bi bi-check-circle fs-5"></i>

                                        <span>Xác nhận & Bắt đầu học ngay (Miễn phí)</span>

                                    </button>

                                </c:when>

                                <c:otherwise>

                                    <button type="submit" class="btn btn-primary btn-lg fw-semibold shadow-sm py-3 d-flex align-items-center justify-content-center gap-2">

                                        <span>Xác nhận đơn & Tiến hành thanh toán</span>

                                        <i class="bi bi-arrow-right fs-5"></i>

                                    </button>

                                </c:otherwise>

                            </c:choose>

                            <a href="${pageContext.request.contextPath}/courses/detail?id=${course.id}" class="btn btn-link text-muted btn-sm text-decoration-none text-center mt-1">

                                <i class="bi bi-arrow-left me-1"></i>Quay lại trang chi tiết khóa học

                            </a>

                        </div>

                    </div>

                </div>

            </div>

        </form>

    </div>

</main>

<script>

</script>

<jsp:include page="../common/footer.jsp" />

