<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Kết quả bài kiểm tra - ${result.quizTitle}" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-6">
                <div class="card p-5 text-center shadow-sm">
                    <c:choose>
                        <c:when test="${result.passStatus}">
                            <i class="bi bi-patch-check-fill text-success fs-1 mb-2"></i>
                            <h3 class="fw-bold text-success mb-1">Chúc mừng! Bạn đã vượt qua bài thi!</h3>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-x-circle-fill text-danger fs-1 mb-2"></i>
                            <h3 class="fw-bold text-danger mb-1">Rất tiếc! Bạn chưa đạt điểm yêu cầu</h3>
                        </c:otherwise>
                    </c:choose>
                    <p class="text-muted small">${result.quizTitle}</p>

                    <div class="bg-light p-4 rounded-3 my-4">
                        <div class="row">
                            <div class="col-6 border-end">
                                <h2 class="fw-bold text-primary mb-0">${result.totalScore} / ${result.maxScore}</h2>
                                <small class="text-muted">Tổng điểm đạt được</small>
                            </div>
                            <div class="col-6">
                                <h2 class="fw-bold text-dark mb-0">${result.percentage}%</h2>
                                <small class="text-muted">Tỉ lệ hoàn thành</small>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/registrations/my" class="btn btn-outline-primary px-4">
                            <i class="bi bi-arrow-left me-1"></i>Về khóa học của tôi
                        </a>
                        <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${param.registrationId}" class="btn btn-primary px-4">
                            Tiếp tục học
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
