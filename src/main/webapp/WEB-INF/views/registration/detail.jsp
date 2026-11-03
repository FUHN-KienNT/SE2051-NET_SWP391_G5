<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Chi tiết đăng ký - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container" style="max-width: 920px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="javascript:history.back()" class="text-decoration-none small text-muted"><i class="bi bi-arrow-left"></i> Quay lại</a>
                <h2 class="fw-bold mt-2 mb-0"><i class="bi bi-receipt text-primary me-2"></i>Registration Detail</h2>
            </div>
            <span class="badge text-bg-${registration.status == 'ACTIVE' ? 'success' : (registration.status == 'COMPLETED' ? 'primary' : 'secondary')} fs-6">${registration.status}</span>
        </div>

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <div class="card-body p-4 p-md-5">
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Mã đăng ký</div>
                        <div class="fs-5 fw-bold">#${registration.id}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Ngày đăng ký</div>
                        <div class="fs-5">${registration.formattedRegistrationDate}</div>
                    </div>
                    <div class="col-12"><hr class="my-0"></div>
                    <div class="col-md-6"><div class="text-muted small text-uppercase fw-semibold mb-1">Học viên</div><div class="fs-5 fw-semibold">${registration.userName}</div></div>
                    <div class="col-md-6"><div class="text-muted small text-uppercase fw-semibold mb-1">Khóa học</div><div class="fs-5 fw-semibold">${registration.courseTitle}</div></div>
                    <div class="col-md-6">
                        <div class="text-muted small text-uppercase fw-semibold mb-2">Tiến độ học</div>
                        <div class="d-flex justify-content-between mb-1"><strong>${registration.progressPercentage}%</strong></div>
                        <div class="progress" style="height: 10px;"><div class="progress-bar" style="width: ${registration.progressPercentage}%"></div></div>
                    </div>
                    <div class="col-md-6"><div class="text-muted small text-uppercase fw-semibold mb-1">Trạng thái học</div><span class="badge text-bg-light border fs-6">${registration.status}</span></div>
                    <div class="col-12"><hr class="my-0"></div>
                    <div class="col-md-4"><div class="text-muted small text-uppercase fw-semibold mb-1">Số tiền</div><div class="fs-5 fw-semibold"><fmt:formatNumber value="${registration.paymentAmount}" type="number" /> VNĐ</div></div>
                    <div class="col-md-4"><div class="text-muted small text-uppercase fw-semibold mb-1">Phương thức</div><div class="fs-5">${registration.paymentMethod}</div></div>
                    <div class="col-md-4"><div class="text-muted small text-uppercase fw-semibold mb-1">Trạng thái thanh toán</div><span class="badge text-bg-light border fs-6">${registration.paymentStatus}</span></div>
                    <div class="col-md-6"><div class="text-muted small text-uppercase fw-semibold mb-1">Mã giao dịch</div><div class="font-monospace">${registration.paymentCode}</div></div>
                    <div class="col-md-6"><div class="text-muted small text-uppercase fw-semibold mb-1">Thời điểm thanh toán</div><div><c:choose><c:when test="${not empty registration.paidAt}">${registration.paidAt}</c:when><c:otherwise>Chưa thanh toán</c:otherwise></c:choose></div></div>
                </div>
            </div>
        </div>
    </div>
</main>
<jsp:include page="../common/footer.jsp" />
