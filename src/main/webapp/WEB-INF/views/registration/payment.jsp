<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Thanh toán trực tuyến - Courson LMS" />
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
    .checkout-step-done {
        background-color: #ecfdf5;
        color: #059669;
        border: 1px solid #a7f3d0;
        text-decoration: none;
    }
    .payment-option-card {
        border: 1.5px solid #e2e8f0;
        border-radius: 12px;
        padding: 16px 20px;
        transition: all 0.2s ease-in-out;
        background: #ffffff;
    }
    .payment-option-card.active {
        border-color: #0284c7;
        background-color: #f0f9ff;
    }
    .payment-option-card.disabled-option {
        opacity: 0.6;
        background-color: #f8fafc;
        cursor: not-allowed !important;
        border-style: dashed;
    }
    .payment-option-card.disabled-option * {
        cursor: not-allowed !important;
    }
</style>

<main class="main-content py-5 bg-light-subtle">
    <div class="container">
        <!-- Step Progress Breadcrumb -->
        <div class="d-flex justify-content-center align-items-center gap-3 mb-4">
            <a href="${pageContext.request.contextPath}/registrations/checkout?courseId=${course.id}" class="checkout-step-pill checkout-step-done">
                <i class="bi bi-check-circle-fill"></i> 1. Thiết lập đơn hàng
            </a>
            <i class="bi bi-chevron-right text-muted small"></i>
            <span class="checkout-step-pill checkout-step-active">
                <i class="bi bi-credit-card-fill"></i> 2. Thanh toán trực tuyến
            </span>
        </div>

        <div class="row justify-content-center g-4">
            <div class="col-lg-8">
                <!-- Flash Messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${errorMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i><c:out value="${successMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Expired Alert & Action -->
                <div id="expiredAlert" class="alert alert-danger d-flex flex-wrap align-items-center justify-content-between p-3 rounded-3 shadow-sm mb-4 ${isExpired ? '' : 'd-none'}">
                    <div class="d-flex align-items-center gap-2 mb-2 mb-md-0">
                        <i class="bi bi-exclamation-octagon-fill fs-4 text-danger"></i>
                        <div>
                            <strong class="d-block text-danger">Phiên thanh toán đã hết hạn (quá 15 phút)!</strong>
                            <span class="small text-muted">Vui lòng bấm nút bên cạnh để làm mới phiên và đồng bộ lại thời gian với cổng thanh toán.</span>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/registrations/renew-session" method="POST" class="m-0">
                        <input type="hidden" name="courseId" value="${course.id}">
                        <button type="submit" class="btn btn-danger btn-sm fw-semibold shadow-sm px-3 py-2">
                            <i class="bi bi-arrow-clockwise me-1"></i>Tạo phiên thanh toán mới
                        </button>
                    </form>
                </div>

                <!-- Order Timer Banner -->
                <div class="card border-0 shadow-sm rounded-4 p-3 mb-4 bg-white ${isExpired ? 'border-start border-4 border-danger' : 'border-start border-4 border-warning'}">
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle ${isExpired ? 'bg-danger-subtle text-danger' : 'bg-warning-subtle text-warning'} d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                                <i class="bi bi-clock-history fs-4"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-0 text-dark">Thời gian hoàn tất thanh toán</h6>
                                <p class="text-muted small mb-0">
                                    Thời gian còn lại: 
                                    <strong id="timerCountdown" class="${isExpired ? 'text-danger' : 'text-primary'} font-monospace fs-6">
                                        <c:choose>
                                            <c:when test="${isExpired}">00:00 (Hết hạn)</c:when>
                                            <c:otherwise>--:--</c:otherwise>
                                        </c:choose>
                                    </strong>
                                </p>
                            </div>
                        </div>
                        <div class="text-end">
                            <span class="badge bg-light text-muted border px-2.5 py-1.5 font-monospace">Mã đơn: #${paymentCode}</span>
                        </div>
                    </div>
                </div>

                <!-- Order Summary Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white">
                    <div class="d-flex flex-wrap justify-content-between align-items-center border-bottom pb-3 mb-3 gap-2">
                        <div>
                            <span class="badge bg-primary-subtle text-primary mb-1">Khóa học đăng ký</span>
                            <h5 class="fw-bold text-dark mb-0">${course.title}</h5>
                        </div>
                        <div class="text-md-end">
                            <div class="text-muted small">Số tiền cần thanh toán</div>
                            <div class="fs-3 fw-bold text-primary">
                                <fmt:formatNumber value="${finalAmount}" pattern="#,###" /> VNĐ
                            </div>
                        </div>
                    </div>

                    <div class="row g-3 small text-muted">
                        <div class="col-sm-6">
                            <i class="bi bi-person-fill text-primary me-1.5"></i>Học viên: 
                            <strong class="text-dark"><c:out value="${not empty certName ? certName : sessionScope.CURRENT_USER.fullName}" /></strong>
                        </div>
                        <div class="col-sm-6">
                            <i class="bi bi-envelope text-primary me-1.5"></i>Tài khoản học: 
                            <strong class="text-dark">${sessionScope.CURRENT_USER.email}</strong>
                        </div>
                    </div>
                </div>

                <!-- Payment Methods Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
                    <h5 class="fw-bold text-dark mb-4">Chọn phương thức thanh toán</h5>

                    <form id="paymentForm" action="${pageContext.request.contextPath}/registrations/vnpay-create" method="POST">
                        <input type="hidden" name="courseId" value="${course.id}">
                        <input type="hidden" name="bankCode" value="NCB">

                        <!-- Payment Method Options -->
                        <div class="d-flex flex-column gap-3 mb-4">
                            <!-- 1. Cổng thanh toán VNPAY (Khả dụng) -->
                            <label class="payment-option-card active d-flex align-items-center justify-content-between cursor-pointer" for="methodVnPay">
                                <div class="d-flex align-items-center gap-3">
                                    <input class="form-check-input mt-0 fs-5" type="radio" name="paymentMethod" id="methodVnPay" value="VNPAY" checked>
                                    <div class="rounded-3 bg-primary bg-opacity-10 text-primary d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                                        <i class="bi bi-credit-card-2-front-fill fs-4"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark">Cổng thanh toán VNPAY</div>
                                        <div class="text-muted small">Thẻ ATM / Tài khoản ngân hàng nội địa / VNPAY-QR</div>
                                    </div>
                                </div>
                                <span class="badge bg-success-subtle text-success border border-success-subtle px-2.5 py-1">Khả dụng</span>
                            </label>

                            <!-- 2. Cổng thanh toán SePay (Chưa khả dụng - Tooltip on hover) -->
                            <div class="payment-option-card disabled-option d-flex align-items-center justify-content-between"
                                 data-bs-toggle="tooltip" data-bs-placement="top" title="SEpay chưa khả dụng">
                                <div class="d-flex align-items-center gap-3">
                                    <input class="form-check-input mt-0 fs-5" type="radio" name="paymentMethod" id="methodSePay" value="SEPAY" disabled>
                                    <div class="rounded-3 bg-secondary bg-opacity-10 text-secondary d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                                        <i class="bi bi-qr-code-scan fs-4"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-secondary">Cổng thanh toán SePay</div>
                                        <div class="text-muted small">Quét mã QR chuyển khoản ngân hàng 24/7</div>
                                    </div>
                                </div>
                                <span class="badge bg-secondary-subtle text-secondary border px-2.5 py-1">Chưa khả dụng</span>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <c:choose>
                            <c:when test="${isExpired}">
                                <button type="button" id="btnSubmitPayment" class="btn btn-secondary btn-lg w-100 fw-bold py-3.5 d-flex align-items-center justify-content-center gap-2 rounded-3 opacity-50" disabled style="cursor: not-allowed;">
                                    <i class="bi bi-x-circle me-1"></i>
                                    <span>Phiên thanh toán đã hết hạn</span>
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="submit" id="btnSubmitPayment" class="btn btn-primary btn-lg w-100 fw-bold shadow-sm py-3.5 d-flex align-items-center justify-content-center gap-2 rounded-3" style="background: #0284c7; border-color: #0284c7; font-size: 1.05rem;">
                                    <i class="bi bi-box-arrow-up-right fs-5"></i>
                                    <span>Tiến hành thanh toán (<fmt:formatNumber value="${finalAmount}" pattern="#,###" /> VNĐ)</span>
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </form>

                    <!-- Navigation Footer -->
                    <div class="d-flex flex-wrap justify-content-between align-items-center pt-4 mt-4 border-top gap-2">
                        <a href="${pageContext.request.contextPath}/registrations/checkout?courseId=${course.id}" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại bước trước
                        </a>
                        <div class="text-muted small">
                            <i class="bi bi-shield-lock-fill text-success me-1"></i>Bảo mật SSL 256-bit
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    // Khởi tạo Bootstrap tooltips để hiển thị tooltip khi di chuột vào SePay
    document.addEventListener('DOMContentLoaded', function () {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    });

    // Đồng bộ thời gian đếm ngược chính xác với thời gian phiên và VNPay
    let secondsLeft = ${remainingSeconds != null ? remainingSeconds : 0};
    const timerEl = document.getElementById('timerCountdown');
    const submitBtn = document.getElementById('btnSubmitPayment');
    const expiredAlert = document.getElementById('expiredAlert');

    function renderTimer() {
        if (secondsLeft <= 0) {
            timerEl.innerText = '00:00 (Hết hạn)';
            timerEl.className = 'text-danger font-monospace fs-6';
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.className = 'btn btn-secondary btn-lg w-100 fw-bold py-3.5 d-flex align-items-center justify-content-center gap-2 rounded-3 opacity-50';
                submitBtn.style.cursor = 'not-allowed';
                submitBtn.innerHTML = '<i class="bi bi-x-circle me-1"></i><span>Phiên thanh toán đã hết hạn</span>';
            }
            if (expiredAlert) {
                expiredAlert.classList.remove('d-none');
            }
            return;
        }

        const m = Math.floor(secondsLeft / 60);
        const s = secondsLeft % 60;
        timerEl.innerText = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
    }

    renderTimer();

    if (secondsLeft > 0) {
        const timerInterval = setInterval(function() {
            secondsLeft--;
            renderTimer();
            if (secondsLeft <= 0) {
                clearInterval(timerInterval);
            }
        }, 1000);
    }
</script>

<jsp:include page="../common/footer.jsp" />
