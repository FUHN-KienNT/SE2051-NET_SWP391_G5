<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Thanh toán Cổng VNPay - Courson LMS" />
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
    .vnpay-method-card {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 14px;
        padding: 20px 24px;
    }
</style>

<main class="main-content py-5 bg-light-subtle">
    <div class="container">
        <!-- Step Progress Breadcrumb -->
        <div class="d-flex justify-content-center align-items-center gap-3 mb-4">
            <a href="${pageContext.request.contextPath}/registrations/checkout?courseId=${course.id}" class="checkout-step-pill checkout-step-done">
                <i class="bi bi-check-circle-fill"></i> 1. Đã thiết lập đơn hàng (Checkout)
            </a>
            <i class="bi bi-chevron-right text-muted small"></i>
            <span class="checkout-step-pill checkout-step-active">
                <i class="bi bi-credit-card-fill"></i> 2. Thanh toán Cổng VNPay (Online Payment)
            </span>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="row justify-content-center mb-3">
                <div class="col-lg-8">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${errorMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="row justify-content-center g-4">
            <div class="col-lg-8">
                <!-- Order Timer Banner -->
                <div class="card border-0 shadow-sm rounded-4 p-3 mb-4 bg-white border-start border-4 border-warning">
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle bg-warning-subtle text-warning d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                                <i class="bi bi-hourglass-split fs-4"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-0 text-dark">Đơn hàng đang chờ thanh toán</h6>
                                <p class="text-muted small mb-0">Chỗ học của bạn được giữ trong <strong id="timerCountdown" class="text-danger font-monospace fs-6">14:59</strong> phút</p>
                            </div>
                        </div>
                        <div class="text-end">
                            <span class="badge bg-light text-muted border px-2.5 py-1.5 font-monospace">Mã đơn: #${paymentCode}</span>
                        </div>
                    </div>
                </div>

                <!-- Order Confirmation Summary Card -->
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
                        <div class="col-sm-4">
                            <i class="bi bi-person-badge text-primary me-1.5"></i>Tên trên chứng chỉ: 
                            <strong class="text-dark">${certName}</strong>
                        </div>
                        <div class="col-sm-4">
                            <i class="bi bi-envelope text-primary me-1.5"></i>Tài khoản học: 
                            <strong class="text-dark">${sessionScope.CURRENT_USER.email}</strong>
                        </div>
                        <div class="col-sm-4">
                            <i class="bi bi-shield-check text-success me-1.5"></i>Bảo vệ quyền lợi: <strong class="text-dark">Học trọn đời</strong>
                        </div>
                    </div>
                </div>

                <!-- DIRECT VNPAY PAYMENT PORTAL (NO VIETQR) -->
                <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
                    <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge bg-primary px-2.5 py-1.5 fs-6 rounded-2"><i class="bi bi-bank me-1"></i>VNPAY</span>
                            <div>
                                <h5 class="fw-bold mb-0 text-dark">Cổng thanh toán Trực tuyến VNPAY</h5>
                                <div class="text-muted small">Chuyển hướng trực tiếp đến trang nhập Thẻ Ngân hàng NCB (không qua bước trung gian)</div>
                            </div>
                        </div>
                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">Tự động kích hoạt</span>
                    </div>

                    <!-- VNPAY METHOD OVERVIEW CARD -->
                    <div class="vnpay-method-card mb-4 d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle bg-primary bg-opacity-10 text-primary d-flex align-items-center justify-content-center flex-shrink-0" style="width: 52px; height: 52px;">
                                <i class="bi bi-credit-card-2-front-fill fs-3"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-1 text-dark">Thẻ ATM / Tài khoản Ngân hàng (VNPAY NCB)</h6>
                                <p class="text-muted small mb-0">Chuyển hướng trực tiếp đến Cổng thanh toán Quốc gia VNPAY & Ngân hàng NCB</p>
                            </div>
                        </div>
                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2.5 py-1.5 fw-semibold font-monospace">
                            <i class="bi bi-shield-check me-1"></i>Kích hoạt tức thì
                        </span>
                    </div>

                    <!-- DIRECT SUBMIT FORM TO VNPAY GATEWAY -->
                    <form action="${pageContext.request.contextPath}/registrations/vnpay-create" method="POST" class="mb-2">
                        <input type="hidden" name="courseId" value="${course.id}">
                        <input type="hidden" name="bankCode" value="NCB">
                        <button type="submit" class="btn btn-primary btn-lg w-100 fw-bold shadow-sm py-3.5 d-flex align-items-center justify-content-center gap-2 rounded-3" style="background: #0284c7; border-color: #0284c7; font-size: 1.05rem;">
                            <i class="bi bi-box-arrow-up-right fs-5"></i>
                            <span>Tiến hành thanh toán ngay (<fmt:formatNumber value="${finalAmount}" pattern="#,###" /> VNĐ)</span>
                        </button>
                    </form>

                    <!-- Security & Navigation Footer -->
                    <div class="d-flex flex-wrap justify-content-between align-items-center pt-4 mt-4 border-top gap-2">
                        <a href="${pageContext.request.contextPath}/registrations/checkout?courseId=${course.id}" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại bước Cấu hình (Checkout)
                        </a>
                        <div class="d-flex align-items-center gap-3 text-muted small">
                            <span><i class="bi bi-shield-lock-fill text-success me-1"></i>Bảo mật SSL/TLS 256-bit</span>
                            <span><i class="bi bi-patch-check-fill text-primary me-1"></i>Chuẩn PCI-DSS Level 1</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    // 1. Countdown timer 15:00
    let secondsLeft = 15 * 60;
    const timerEl = document.getElementById('timerCountdown');
    const interval = setInterval(function() {
        secondsLeft--;
        if (secondsLeft <= 0) {
            clearInterval(interval);
            timerEl.innerText = '00:00 (Hết hạn)';
            return;
        }
        const m = Math.floor(secondsLeft / 60);
        const s = secondsLeft % 60;
        timerEl.innerText = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
    }, 1000);
</script>

<jsp:include page="../common/footer.jsp" />
