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
<!--checkoutP-->
        <form id="checkoutForm" action="${pageContext.request.contextPath}/registrations/checkout" method="POST">

            <input type="hidden" name="courseId" value="${course.id}">

            <div class="row justify-content-center g-4">

                <!-- LEFT COLUMN: Order Configuration & Learner Info (60%) -->
                <div class="col-lg-7">
                    <!-- 1. THÔNG TIN NGƯỜI HỌC (XEM LẠI & CHỈNH SỬA) -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white">
                        <div class="d-flex align-items-center justify-content-between mb-3 border-bottom pb-2">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-person-vcard text-primary fs-5"></i>
                                <h5 class="fw-bold mb-0">Thông tin người học</h5>
                            </div>
                            <a href="${pageContext.request.contextPath}/profile" target="_blank" class="text-primary small text-decoration-none" title="Xem hoặc chỉnh sửa hồ sơ chi tiết">
                                <i class="bi bi-box-arrow-up-right me-1"></i>Hồ sơ cá nhân
                            </a>
                        </div>
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-dark">Họ và tên hiển thị <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-person text-muted"></i></span>
                                    <input type="text" name="certificateName" class="form-control border-start-0" 
                                           value="<c:out value='${sessionScope.CURRENT_USER.fullName}'/>" required
                                           placeholder="Nhập họ và tên đầy đủ">
                                </div>
                                <div class="form-text text-muted" style="font-size: 11px;">
                                    Tên hiển thị và in trên chứng chỉ khi hoàn thành khóa học.
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-dark">Số điện thoại liên hệ</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-telephone text-muted"></i></span>
                                    <input type="tel" name="studentPhone" class="form-control border-start-0" 
                                           value="<c:out value='${sessionScope.CURRENT_USER.phone}'/>" 
                                           placeholder="VD: 0912345678">
                                </div>
                                <div class="form-text text-muted" style="font-size: 11px;">
                                    Dùng để nhận hỗ trợ kỹ thuật hoặc thông báo khẩn cấp từ giảng viên.
                                </div>
                            </div>

                            <div class="col-12">
                                <label class="form-label small fw-semibold text-dark">Email tài khoản Courson</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                                    <input type="email" class="form-control border-start-0 bg-light text-muted" 
                                           value="<c:out value='${sessionScope.CURRENT_USER.email}'/>" readonly>
                                </div>
                                <div class="form-text text-muted" style="font-size: 11px;">
                                    Khóa học sẽ được kích hoạt trực tiếp vào email này (đổi email tại <a href="${pageContext.request.contextPath}/profile" target="_blank">Hồ sơ cá nhân</a>).
                                </div>
                            </div>

                            <div class="col-12 pt-1">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="updateProfile" id="syncProfile" value="true" checked>
                                    <label class="form-check-label small text-muted" for="syncProfile">
                                        Đồng bộ và cập nhật thông tin này vào <strong>Hồ sơ cá nhân (Profile)</strong> của tôi
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Quyền lợi học viên -->

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

                    <!-- 3. Cam kết quy chế đào tạo (BẮT BUỘC HỌC VIÊN TÍCH CHỌN CHỦ ĐỘNG) -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white border-start border-4 border-primary">
                        <div class="d-flex align-items-start gap-3">
                            <div class="form-check pt-0.5">
                                <input class="form-check-input fs-5" type="checkbox" id="agreeTerms" name="agreeTerms" required style="cursor: pointer;">
                            </div>
                            <div>
                                <label class="form-check-label fw-semibold text-dark mb-1" for="agreeTerms" style="cursor: pointer;">
                                    Tôi đã đọc và cam kết tuân thủ Quy chế đào tạo của Courson LMS <span class="text-danger">*</span>
                                </label>
                                <div class="text-muted small">
                                    Tôi cam kết tôn trọng bản quyền nội dung video bài giảng, không sao chép hoặc chia sẻ trái phép và đồng ý với các chính sách đào tạo của nền tảng.
                                </div>
                                <div class="text-danger small mt-2" id="agreeHint">
                                    <i class="bi bi-info-circle me-1"></i>Vui lòng tích chọn cam kết trên để kích hoạt nút thanh toán.
                                </div>
                            </div>
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
                                    <button type="submit" id="btnSubmitCheckout" class="btn btn-success btn-lg fw-semibold shadow-sm py-3 d-flex align-items-center justify-content-center gap-2 opacity-50" disabled style="cursor: not-allowed;">
                                        <i class="bi bi-check-circle fs-5"></i>
                                        <span>Xác nhận & Bắt đầu học ngay (Miễn phí)</span>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" id="btnSubmitCheckout" class="btn btn-primary btn-lg fw-semibold shadow-sm py-3 d-flex align-items-center justify-content-center gap-2 opacity-50" disabled style="cursor: not-allowed;">
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
    document.addEventListener('DOMContentLoaded', function() {
        const agreeCheck = document.getElementById('agreeTerms');
        const submitBtn = document.getElementById('btnSubmitCheckout');
        const agreeHint = document.getElementById('agreeHint');

        function updateSubmitState() {
            if (agreeCheck && submitBtn) {
                const isChecked = agreeCheck.checked;
                submitBtn.disabled = !isChecked;
                if (isChecked) {
                    submitBtn.classList.remove('opacity-50');
                    submitBtn.style.cursor = 'pointer';
                    if (agreeHint) {
                        agreeHint.classList.add('text-success');
                        agreeHint.classList.remove('text-danger');
                        agreeHint.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i>Đã xác nhận cam kết. Bạn có thể tiến hành thanh toán.';
                    }
                } else {
                    submitBtn.classList.add('opacity-50');
                    submitBtn.style.cursor = 'not-allowed';
                    if (agreeHint) {
                        agreeHint.classList.remove('text-success');
                        agreeHint.classList.add('text-danger');
                        agreeHint.innerHTML = '<i class="bi bi-info-circle me-1"></i>Vui lòng tích chọn cam kết trên để kích hoạt nút thanh toán.';
                    }
                }
            }
        }

        if (agreeCheck) {
            agreeCheck.addEventListener('change', updateSubmitState);
            updateSubmitState();
        }
    });
</script>

<jsp:include page="../common/footer.jsp" />

