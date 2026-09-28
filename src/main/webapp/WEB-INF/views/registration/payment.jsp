<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Thanh toán trực tuyến - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Title -->
        <div class="mb-4 text-center">
            <h3 class="fw-bold mb-1"><i class="bi bi-credit-card-2-front me-2 text-primary"></i>Cổng thanh toán trực tuyến (Online Payment)</h3>
            <p class="text-muted small">Lựa chọn kênh thanh toán an toàn để hoàn tất đăng ký khóa học (Màn hình II.3.2)</p>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <!-- Order summary banner -->
                    <div class="alert alert-info d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <div class="fw-bold fs-6">Đơn hàng: ${course.title}</div>
                            <small>Mã giao dịch: <strong>${paymentCode}</strong></small>
                        </div>
                        <div class="fs-4 fw-bold text-primary">${course.price} VNĐ</div>
                    </div>

                    <!-- Payment methods -->
                    <h5 class="fw-bold mb-3">Chọn phương thức thanh toán:</h5>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <div class="border rounded-3 p-3 bg-light-subtle h-100 position-relative border-primary">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="methodSePay" value="SEPAY" checked>
                                    <label class="form-check-label fw-bold" for="methodSePay">
                                        <i class="bi bi-qr-code-scan text-success me-1"></i>Chuyển khoản QR (VietQR / SePay)
                                    </label>
                                </div>
                                <p class="small text-muted mt-2 mb-0">Quét mã QR qua app ngân hàng bất kỳ, kích hoạt tức thì sau 30 giây.</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="border rounded-3 p-3 bg-light-subtle h-100 position-relative">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="methodVnPay" value="VNPAY">
                                    <label class="form-check-label fw-bold" for="methodVnPay">
                                        <i class="bi bi-shield-check text-primary me-1"></i>Ví điện tử VNPay
                                    </label>
                                </div>
                                <p class="small text-muted mt-2 mb-0">Thanh toán qua cổng thẻ ATM nội địa, thẻ quốc tế Visa/MasterCard hoặc ví VNPay.</p>
                            </div>
                        </div>
                    </div>

                    <!-- VietQR Simulation Box -->
                    <div class="card bg-light border p-4 text-center mb-4">
                        <h6 class="fw-bold text-dark mb-3"><i class="bi bi-upc-scan me-1"></i>Thông tin chuyển khoản</h6>
                        <div class="bg-white p-3 d-inline-block rounded shadow-sm mx-auto mb-3" style="width: 180px; height: 180px;">
                            <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=Courson-${paymentCode}-${course.price}" alt="QR Payment" class="img-fluid">
                        </div>
                        <div class="small">
                            <div>Ngân hàng thụ hưởng: <strong>MB BANK (Ngân hàng Quân Đội)</strong></div>
                            <div>Số tài khoản: <strong>999988886666</strong></div>
                            <div>Chủ tài khoản: <strong>CONG TY COURSON LMS</strong></div>
                            <div>Nội dung chuyển khoản: <span class="badge bg-warning text-dark fs-6">${paymentCode}</span></div>
                        </div>
                    </div>

                    <!-- Confirm button -->
                    <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/registrations/checkout?courseId=${course.id}" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại đơn hàng
                        </a>
                        <form action="${pageContext.request.contextPath}/registrations/confirm-payment" method="POST">
                            <input type="hidden" name="courseId" value="${course.id}">
                            <input type="hidden" name="paymentCode" value="${paymentCode}">
                            <button type="submit" class="btn btn-success btn-lg px-4 fw-semibold">
                                <i class="bi bi-check2-circle me-1"></i>Xác nhận tôi đã thanh toán
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
