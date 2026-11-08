<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Kết quả bài kiểm tra - ${result.quizTitle}" />
<jsp:include page="../common/header.jsp" />

<c:set var="curRegId" value="${not empty registrationId ? registrationId : param.registrationId}" />
<c:set var="curQuizId" value="${not empty quiz ? quiz.id : param.quizId}" />

<main class="main-content py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- BREADCRUMB / BACK LINK -->
                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/quizzes/overview?registrationId=${curRegId}&quizId=${curQuizId}" class="text-decoration-none text-muted small">
                        <i class="bi bi-arrow-left me-1"></i>Về trang tổng quan bài thi
                    </a>
                </div>

                <!-- 1. SUMMARY CARD -->
                <div class="card p-4 p-md-5 text-center shadow-sm border-0 rounded-3 mb-4">
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

                    <div class="bg-light p-4 rounded-3 my-4 border">
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

                    <div class="d-flex flex-wrap justify-content-center gap-2">
                        <a href="${pageContext.request.contextPath}/quizzes/attempt?registrationId=${curRegId}&quizId=${curQuizId}&retake=true" 
                           class="btn btn-warning px-4 shadow-sm"
                           onclick="return confirm('Lưu ý: Làm lại bài thi sẽ xóa bài làm cũ và ghi đè kết quả mới. Bạn có chắc chắn muốn làm lại?');">
                            <i class="bi bi-arrow-repeat me-1"></i>Làm lại bài thi
                        </a>
                        <a href="${pageContext.request.contextPath}/quizzes/overview?registrationId=${curRegId}&quizId=${curQuizId}" 
                           class="btn btn-outline-secondary px-4">
                            <i class="bi bi-info-circle me-1"></i>Tổng quan bài thi
                        </a>
                        <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${curRegId}" class="btn btn-primary px-4 shadow-sm">
                            <i class="bi bi-book me-1"></i>Tiếp tục học
                        </a>
                    </div>
                </div>

                <!-- 2. DETAILED QUESTION REVIEW -->
                <c:if test="${quiz != null && not empty quiz.questions}">
                    <div class="card p-4 shadow-sm border-0 rounded-3 mb-4">
                        <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
                            <h5 class="fw-bold text-dark mb-0">
                                <i class="bi bi-journal-check me-2 text-primary"></i>Xem lại chi tiết bài làm
                            </h5>
                            <span class="badge bg-secondary-subtle text-secondary border small">
                                ${quiz.questions.size()} câu hỏi
                            </span>
                        </div>

                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="q" items="${quiz.questions}" varStatus="status">
                                <c:set var="userAns" value="${answerMap != null ? answerMap[q.id] : null}" />
                                <c:set var="isCorrect" value="${userAns != null && userAns.correct}" />

                                <div class="border rounded-3 p-3 ${isCorrect ? 'border-success-subtle bg-success-subtle bg-opacity-10' : 'border-danger-subtle bg-danger-subtle bg-opacity-10'}">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h6 class="fw-bold mb-0">
                                            <span class="text-primary me-1">Câu ${status.count}:</span>
                                            ${q.questionText}
                                        </h6>
                                        <div class="d-flex align-items-center gap-1.5 flex-shrink-0 ms-2">
                                            <c:choose>
                                                <c:when test="${isCorrect}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle small">
                                                        <i class="bi bi-check-circle-fill me-1"></i>Đúng (+${userAns.score} đ)
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle small">
                                                        <i class="bi bi-x-circle-fill me-1"></i>Sai (0 đ)
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="d-flex flex-column gap-1 mt-3">
                                        <c:forEach var="opt" items="${q.options}">
                                            <c:set var="isSelected" value="${userAns != null && userAns.hasSelectedOption(opt.id)}" />
                                            <div class="p-2 rounded-2 d-flex align-items-center justify-content-between text-break 
                                                ${opt.correct ? 'bg-success-subtle border border-success' : (isSelected ? 'bg-danger-subtle border border-danger' : 'bg-light border border-light-subtle')}">
                                                <div class="d-flex align-items-center gap-2">
                                                    <c:choose>
                                                        <c:when test="${opt.correct}">
                                                            <i class="bi bi-check-circle-fill text-success fs-6"></i>
                                                        </c:when>
                                                        <c:when test="${isSelected}">
                                                            <i class="bi bi-x-circle-fill text-danger fs-6"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="bi bi-circle text-muted fs-6"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="${opt.correct ? 'fw-bold text-success' : (isSelected ? 'text-danger' : 'text-dark')}">
                                                        ${opt.optionText}
                                                    </span>
                                                </div>
                                                <div class="d-flex align-items-center gap-1">
                                                    <c:if test="${isSelected}">
                                                        <span class="badge bg-primary text-white" style="font-size: 11px;">
                                                            Lựa chọn của bạn
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${opt.correct}">
                                                        <span class="badge bg-success text-white" style="font-size: 11px;">
                                                            Đáp án đúng
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</main>

<script>
    // Dọn dẹp an toàn bộ nhớ đệm đáp án sau khi đã nộp bài thành công vào CSDL
    (function() {
        const quizId = '${quiz.id}';
        const regId = '${registrationId}';
        localStorage.removeItem('courson_quiz_answers_' + quizId + '_' + regId);
        localStorage.removeItem('courson_quiz_timer_' + quizId + '_' + regId);
    })();
</script>

<jsp:include page="../common/footer.jsp" />
