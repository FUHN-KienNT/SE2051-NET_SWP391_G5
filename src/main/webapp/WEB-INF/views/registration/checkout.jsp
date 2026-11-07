<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Cấu hình đơn hàng & Chứng chỉ - Courson LMS" />
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
    .voucher-pill {
        cursor: pointer;
        transition: all 0.15s ease;
        user-select: none;
    }
    .voucher-pill:hover {
        background-color: #e0e7ff !important;
        border-color: #818cf8 !important;
        transform: translateY(-1px);
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
            <input type="hidden" id="appliedVoucherCode" name="voucherCode" value="">
            <input type="hidden" id="appliedDiscountAmount" name="discountAmount" value="0">

            <div class="row justify-content-center g-4">
                <!-- LEFT COLUMN: Order Configuration & Learner Info (60%) -->
                <div class="col-lg-7">
                    <!-- 1. Thông tin học viên & In chứng chỉ -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white">
                        <div class="d-flex align-items-center gap-2 mb-3 border-bottom pb-2">
                            <i class="bi bi-mortarboard-fill text-primary fs-5"></i>
                            <h5 class="fw-bold mb-0">1. Thông tin học viên & Giấy chứng nhận tốt nghiệp</h5>
                        </div>
                        <p class="text-muted small mb-3">
                            Thông tin này sẽ được in trực tiếp lên <strong>Chứng nhận hoàn thành khóa học điện tử</strong> sau khi bạn vượt qua bài thi trắc nghiệm.
                        </p>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Họ và tên in trên chứng nhận <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-person-badge text-muted"></i></span>
                                <input type="text" class="form-control border-start-0" name="certificateName" 
                                       value="${sessionScope.CURRENT_USER.fullName}" required placeholder="Ví dụ: Nguyễn Văn An">
                            </div>
                            <div class="form-text small">Khuyên dùng họ tên tiếng Việt đầy đủ có dấu để chứng chỉ có hiệu lực học thuật.</div>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Email nhận thông báo học tập <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                                    <input type="email" class="form-control border-start-0" name="studentEmail" 
                                           value="${sessionScope.CURRENT_USER.email}" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Số điện thoại liên hệ & Mentor hỗ trợ</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-telephone text-muted"></i></span>
                                    <input type="text" class="form-control border-start-0" name="studentPhone" 
                                           value="${sessionScope.CURRENT_USER.phone}" placeholder="Ví dụ: 0912 345 678">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Quyền lợi kèm theo & Tùy chọn hóa đơn VAT -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white">
                        <div class="d-flex align-items-center gap-2 mb-3 border-bottom pb-2">
                            <i class="bi bi-stars text-warning fs-5"></i>
                            <h5 class="fw-bold mb-0">2. Quyền lợi học tập bổ trợ (Included Benefits)</h5>
                        </div>

                        <div class="d-flex flex-column gap-2.5 mb-3">
                            <div class="d-flex align-items-start gap-2 text-dark small">
                                <i class="bi bi-check-circle-fill text-success mt-0.5"></i>
                                <span>Truy cập trọn đời tất cả bài giảng và bài tập thực hành trên mọi thiết bị.</span>
                            </div>
                            <div class="d-flex align-items-start gap-2 text-dark small">
                                <i class="bi bi-check-circle-fill text-success mt-0.5"></i>
                                <span>Tặng kèm tài liệu Slide bài giảng & Source Code mẫu dự án (Miễn phí 100%).</span>
                            </div>
                            <div class="d-flex align-items-start gap-2 text-dark small">
                                <i class="bi bi-check-circle-fill text-success mt-0.5"></i>
                                <span>Tham gia cộng đồng học viên & diễn đàn hỏi đáp độc quyền với Giảng viên.</span>
                            </div>
                        </div>

                        <!-- VAT Invoice Toggle -->
                        <div class="border-top pt-3">
                            <div class="form-check form-switch mb-2">
                                <input class="form-check-input" type="checkbox" id="requestVatSwitch" name="requestVat" onchange="toggleVatForm()">
                                <label class="form-check-label fw-semibold small" for="requestVatSwitch">
                                    Yêu cầu xuất Hóa đơn điện tử VAT (Dành cho Doanh nghiệp / Tổ chức)
                                </label>
                            </div>

                            <div id="vatFormFields" class="p-3 bg-light rounded-3 mt-2" style="display: none;">
                                <div class="mb-2">
                                    <label class="form-label small fw-semibold">Tên Công ty / Đơn vị</label>
                                    <input type="text" class="form-control form-control-sm" name="vatCompany" placeholder="Ví dụ: Công ty TNHH Giải pháp Phần mềm...">
                                </div>
                                <div class="row g-2 mb-2">
                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold">Mã số thuế (MST)</label>
                                        <input type="text" class="form-control form-control-sm" name="vatTaxCode" placeholder="Ví dụ: 0101234567">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold">Địa chỉ công ty</label>
                                        <input type="text" class="form-control form-control-sm" name="vatAddress" placeholder="Địa chỉ theo giấy ĐKKD">
                                    </div>
                                </div>
                                <div class="text-muted" style="font-size: 11px;">Hóa đơn VAT điện tử sẽ được kế toán Courson gửi về email học viên trong vòng 48h.</div>
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

                <!-- RIGHT COLUMN: Course Summary & Voucher Coupon (40%) -->
                <div class="col-lg-5">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white position-sticky" style="top: 24px;">
                        <h5 class="fw-bold mb-3 border-bottom pb-2">Đơn hàng của bạn</h5>

                        <!-- Course info card -->
                        <div class="d-flex gap-3 align-items-center mb-3">
                            <div class="rounded-3 bg-primary-subtle text-primary d-flex align-items-center justify-content-center" style="width: 76px; height: 56px;">
                                <i class="bi bi-journal-code fs-3"></i>
                            </div>
                            <div class="flex-grow-1 overflow-hidden">
                                <h6 class="fw-bold text-dark text-truncate mb-1" title="${course.title}">${course.title}</h6>
                                <div class="text-muted small"><i class="bi bi-clock me-1"></i>Học trọn đời &bull; Online 24/7</div>
                            </div>
                        </div>

                        <!-- VOUCHER / COUPON SECTION -->
                        <div class="mb-4">
                            <label class="form-label small fw-semibold text-dark"><i class="bi bi-ticket-perforated me-1 text-primary"></i>Mã giảm giá / Voucher</label>
                            <div class="input-group mb-2">
                                <input type="text" id="voucherInput" class="form-control text-uppercase" placeholder="Nhập mã ưu đãi..." style="letter-spacing: 1px;">
                                <button type="button" class="btn btn-outline-primary fw-semibold px-3" onclick="applyVoucher()">
                                    Áp dụng
                                </button>
                            </div>

                            <!-- Alert message -->
                            <div id="voucherAlert" class="small mt-1" style="display: none;"></div>

                            <!-- CONDITIONAL LOYALTY VOUCHER (Chỉ mở khóa khi hoàn thành >= 1 khóa học) -->
                            <c:choose>
                                <c:when test="${not empty loyaltyVoucher}">
                                    <div class="mt-2.5 p-2.5 rounded-3 bg-success-subtle border border-success-subtle d-flex align-items-center justify-content-between flex-wrap gap-2">
                                        <div class="d-flex align-items-center gap-2 small">
                                            <span class="fs-5">🎁</span>
                                            <div>
                                                <div class="fw-bold text-success" style="font-size: 0.8125rem;">Thưởng hoàn thành khóa học (${completedCoursesCount} khóa đã xong):</div>
                                                <div class="text-muted" style="font-size: 0.74rem;">Hệ thống tặng riêng bạn 01 mã ưu đãi ngẫu nhiên</div>
                                            </div>
                                        </div>
                                        <button type="button" class="btn btn-sm btn-success fw-bold font-monospace px-2.5 py-1 rounded-pill shadow-xs" onclick="setVoucherPreset('${loyaltyVoucher}')" style="font-size: 0.78rem;">
                                            <i class="bi bi-tag-fill me-1"></i>${loyaltyVoucherLabel} &bull; Dùng ngay
                                        </button>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="mt-2 text-muted small d-flex align-items-center gap-1.5 py-1.5 px-2.5 rounded-3 bg-light border" style="font-size: 0.78rem;">
                                        <i class="bi bi-gift text-primary fs-6"></i>
                                        <span>Hoàn thành <strong>1 khóa học bất kỳ</strong> để mở khóa mã giảm giá ngẫu nhiên tri ân học viên!</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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
                            <div class="d-flex justify-content-between py-1 small" id="discountRow" style="display: none;">
                                <span class="text-success"><i class="bi bi-tag-fill me-1"></i>Giảm giá ưu đãi:</span>
                                <span id="discountDisplay" class="fw-semibold text-success">- 0 VNĐ</span>
                            </div>
                            <div class="border-top my-2"></div>
                            <div class="d-flex justify-content-between align-items-center">
                                <strong class="text-dark">Tổng thanh toán:</strong>
                                <strong id="finalPriceDisplay" class="fs-4 text-primary">
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
    const originalPrice = ${course.price != null ? course.price : 0};

    function toggleVatForm() {
        const sw = document.getElementById('requestVatSwitch');
        const box = document.getElementById('vatFormFields');
        box.style.display = sw.checked ? 'block' : 'none';
    }

    function setVoucherPreset(code) {
        document.getElementById('voucherInput').value = code;
        applyVoucher();
    }

    function applyVoucher() {
        const input = document.getElementById('voucherInput');
        const alertBox = document.getElementById('voucherAlert');
        const discountRow = document.getElementById('discountRow');
        const discountDisplay = document.getElementById('discountDisplay');
        const finalPriceDisplay = document.getElementById('finalPriceDisplay');
        const appliedVoucherInput = document.getElementById('appliedVoucherCode');
        const appliedDiscountInput = document.getElementById('appliedDiscountAmount');

        const code = (input.value || '').trim().toUpperCase();
        if (!code) {
            alertBox.style.display = 'block';
            alertBox.className = 'small text-danger mt-1';
            alertBox.innerHTML = '<i class="bi bi-exclamation-circle me-1"></i>Vui lòng nhập mã giảm giá!';
            return;
        }

        if (originalPrice <= 0) {
            alertBox.style.display = 'block';
            alertBox.className = 'small text-info mt-1';
            alertBox.innerHTML = '<i class="bi bi-info-circle me-1"></i>Khóa học này đang miễn phí, không cần áp dụng mã!';
            return;
        }

        let discount = 0;
        let msg = '';

        if (code === 'COURSON10') {
            discount = Math.round(originalPrice * 0.10);
            msg = 'Đã áp dụng mã <strong>COURSON10</strong> (-10%) thành công!';
        } else if (code === 'SWP391') {
            discount = 50000;
            msg = 'Đã áp dụng mã <strong>SWP391</strong> (-50.000 VNĐ) thành công!';
        } else if (code === 'VIPMEMBER') {
            discount = 100000;
            msg = 'Đã áp dụng mã <strong>VIPMEMBER</strong> (-100.000 VNĐ) thành công!';
        } else {
            alertBox.style.display = 'block';
            alertBox.className = 'small text-danger mt-1';
            alertBox.innerHTML = '<i class="bi bi-x-circle me-1"></i>Mã giảm giá không hợp lệ hoặc đã hết hạn!';
            return;
        }

        if (discount > originalPrice) discount = originalPrice;
        const finalPrice = Math.max(0, originalPrice - discount);

        // Update displays
        appliedVoucherInput.value = code;
        appliedDiscountInput.value = discount;

        discountDisplay.innerText = '- ' + discount.toLocaleString('vi-VN') + ' VNĐ';
        discountRow.style.display = 'flex';

        if (finalPrice === 0) {
            finalPriceDisplay.innerText = 'Miễn phí';
        } else {
            finalPriceDisplay.innerText = finalPrice.toLocaleString('vi-VN') + ' VNĐ';
        }

        alertBox.style.display = 'block';
        alertBox.className = 'small text-success mt-1 fw-semibold';
        alertBox.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i>' + msg;
    }
</script>

<jsp:include page="../common/footer.jsp" />