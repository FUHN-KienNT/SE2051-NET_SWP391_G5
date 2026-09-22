<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Khóa học của tôi - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="mb-4">
            <h3 class="fw-bold mb-1">Khóa học của tôi</h3>
            <p class="text-muted small">Tiếp tục hành trình học tập và hoàn thành các mục tiêu của bạn</p>
        </div>

        <c:choose>
            <c:when test="${empty registrations}">
                <div class="card p-5 text-center">
                    <i class="bi bi-mortarboard fs-1 text-muted mb-2"></i>
                    <h5>Bạn chưa đăng ký khóa học nào!</h5>
                    <p class="text-muted">Hãy tham khảo kho khóa học phong phú của chúng tôi để bắt đầu.</p>
                    <div>
                        <a href="${pageContext.request.contextPath}/courses/catalog" class="btn btn-primary px-4">
                            Khám phá khóa học
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                    <c:forEach var="r" items="${registrations}">
                        <div class="col">
                            <div class="card h-100">
                                <div class="card-body d-flex flex-column">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class="badge ${r.status == 'ACTIVE' ? 'bg-success' : (r.status == 'COMPLETED' ? 'bg-primary' : 'bg-warning text-dark')}">
                                            ${r.status}
                                        </span>
                                        <small class="text-muted">${r.paymentStatus}</small>
                                    </div>
                                    <h5 class="card-title fw-bold">${r.courseTitle}</h5>
                                    
                                    <div class="my-3">
                                        <div class="d-flex justify-content-between small text-muted mb-1">
                                            <span>Tiến độ hoàn thành</span>
                                            <span><strong>${r.progressPercentage}%</strong></span>
                                        </div>
                                        <div class="progress" style="height: 6px;">
                                            <div class="progress-bar bg-success" role="progressbar" style="width: ${r.progressPercentage}%"></div>
                                        </div>
                                    </div>

                                    <div class="mt-auto pt-3 border-top">
                                        <c:choose>
                                            <c:when test="${r.status == 'ACTIVE' || r.status == 'COMPLETED'}">
                                                <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${r.id}" class="btn btn-primary w-100">
                                                    <i class="bi bi-play-circle me-1"></i>Tiếp tục học
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-warning py-1 px-2 small mb-0 text-center">
                                                    Chờ xác nhận thanh toán (${r.paymentCode})
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
