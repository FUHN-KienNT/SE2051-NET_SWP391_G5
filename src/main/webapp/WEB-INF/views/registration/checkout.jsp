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
                            <div class="form-text small">Khuyên dùng họ tên tiếng Việt đầy đủ có dấu để chứng chỉ được công nhận chuẩn mực.</div>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Email tài khoản</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                                    <input type="email" class="form-control border-start-0 bg-light" value="${sessionScope.CURRENT_USER.email}" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Số điện thoại liên hệ (Hỗ trợ học vụ)</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-telephone text-muted"></i></span>
                                    <input type="tel" class="form-control border-start-0" name="studentPhone" 
                                           value="${sessionScope.CURRENT_USER.phone}" placeholder="Ví dụ: 0912345678">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Quyền lợi học tập bổ trợ & Hóa đơn VAT -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white">
                        <div class="d-flex align-items-center gap-2 mb-3 border-bottom pb-2">
                            <i class="bi bi-award-fill text-primary fs-5"></i>
                            <h5 class="fw-bold mb-0">2. Quyền lợi học tập & Hóa đơn</h5>
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
    function toggleVatForm() {
        const sw = document.getElementById('requestVatSwitch');
        const box = document.getElementById('vatFormFields');
        box.style.display = sw.checked ? 'block' : 'none';
    }
</script>

<jsp:include page="../common/footer.jsp" />
