<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Chi tiết đơn đăng ký #${registration.id} - Courson LMS" />
<jsp:include page="../common/header.jsp" />

<main class="main-content py-5">
    <div class="container" style="max-width: 920px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="${pageContext.request.contextPath}/registrations/list" class="text-decoration-none small text-muted">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách đăng ký
                </a>
                <h2 class="fw-bold mt-2 mb-0">
                    <i class="bi bi-receipt text-primary me-2"></i>Chi tiết đơn đăng ký #${registration.id}
                </h2>
            </div>
            <c:choose>
                <c:when test="${registration.status == 'ACTIVE'}">
                    <span class="badge text-bg-success fs-6"><i class="bi bi-check-circle me-1"></i>Đang học (ACTIVE)</span>
                </c:when>
                <c:when test="${registration.status == 'COMPLETED'}">
                    <span class="badge text-bg-primary fs-6"><i class="bi bi-trophy me-1"></i>Hoàn thành (COMPLETED)</span>
                </c:when>
                <c:otherwise>
                    <span class="badge text-bg-secondary fs-6">${registration.status}</span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <div class="card-body p-4 p-md-5">
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Mã đăng ký</div>
                        <div class="fs-5 fw-bold text-dark">#${registration.id}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Ngày đăng ký</div>
                        <div class="fs-5 text-dark">${registration.formattedRegistrationDate}</div>
                    </div>

                    <div class="col-12"><hr class="my-0"></div>

                    <div class="col-md-6">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Học viên</div>
                        <div class="fs-5 fw-semibold text-dark">${registration.userName}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Khóa học</div>
                        <div class="fs-5 fw-semibold text-primary">
                            <a href="${pageContext.request.contextPath}/course/detail?id=${registration.courseId}" class="text-decoration-none hover-primary">
                                ${registration.courseTitle}
                            </a>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="text-muted small text-uppercase fw-semibold mb-2">Tiến độ học tập</div>
                        <div class="d-flex justify-content-between mb-1">
                            <strong class="text-dark">${registration.progressPercentage}%</strong>
                        </div>
                        <div class="progress" style="height: 10px;">
                            <div class="progress-bar bg-success" role="progressbar" style="width: 0%;" data-progress="${registration.progressPercentage}"></div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Trạng thái học</div>
                        <span class="badge text-bg-light border fs-6 text-dark">${registration.status}</span>
                    </div>

                    <div class="col-12"><hr class="my-0"></div>

                    <div class="col-md-4">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Số tiền thanh toán</div>
                        <div class="fs-5 fw-bold text-success">
                            <c:choose>
                                <c:when test="${registration.paymentAmount <= 0}">Miễn phí (0 VNĐ)</c:when>
                                <c:otherwise><fmt:formatNumber value="${registration.paymentAmount}" type="number" /> VNĐ</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Phương thức thanh toán</div>
                        <div class="fs-5 text-dark">
                            <i class="bi bi-credit-card-2-front me-1 text-primary"></i>${not empty registration.paymentMethod ? registration.paymentMethod : 'Mặc định'}
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Trạng thái thanh toán</div>
                        <c:choose>
                            <c:when test="${registration.paymentStatus == 'SUCCESS' || registration.paymentStatus == 'FREE'}">
                                <span class="badge text-bg-success fs-6"><i class="bi bi-check-circle me-1"></i>Thành công</span>
                            </c:when>
                            <c:when test="${registration.paymentStatus == 'PENDING'}">
                                <span class="badge text-bg-warning fs-6"><i class="bi bi-hourglass-split me-1"></i>Chờ xử lý</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge text-bg-danger fs-6"><i class="bi bi-x-circle me-1"></i>Thất bại</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="col-md-6">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Mã giao dịch / Payment Code</div>
                        <div class="font-monospace text-dark bg-light p-2 rounded border small">${registration.paymentCode}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted small text-uppercase fw-semibold mb-1">Thời điểm thanh toán</div>
                        <div class="text-dark">
                            <c:choose>
                                <c:when test="${not empty registration.paidAt}">${registration.paidAt}</c:when>
                                <c:otherwise><span class="text-muted fst-italic">Chưa thanh toán</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-5 pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/registrations/list" class="btn btn-outline-secondary px-4 rounded-pill">
                        <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                    </a>
                    <c:if test="${registration.paymentStatus == 'PENDING'}">
                        <form action="${pageContext.request.contextPath}/registrations/update-status" method="POST" class="d-inline"
                              onsubmit="return confirm('Bạn có chắc chắn muốn xác nhận duyệt đơn đăng ký này sang trạng thái ĐÃ THANH TOÁN?');">
                            <input type="hidden" name="id" value="${registration.id}">
                            <input type="hidden" name="status" value="SUCCESS">
                            <button type="submit" class="btn btn-success px-4 rounded-pill">
                                <i class="bi bi-check-circle me-1"></i>Xác nhận đã thanh toán
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('[data-progress]').forEach(function(el) {
            var val = el.getAttribute('data-progress');
            if (val !== null && val !== '') {
                el.style.width = Math.min(Math.max(parseFloat(val) || 0, 0), 100) + '%';
            }
        });
    });
</script>

<jsp:include page="../common/footer.jsp" />
