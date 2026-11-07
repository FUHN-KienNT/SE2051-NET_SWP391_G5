<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="Làm bài kiểm tra - ${quiz.title}" />
        <jsp:include page="../common/header.jsp" />

        <main class="main-content py-5">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card p-4 mb-4">
                            <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
                                <div>
                                    <span class="badge bg-warning-subtle text-dark border">Bài kiểm tra</span>
                                    <h3 class="fw-bold mt-1 mb-0">${quiz.title}</h3>
                                </div>
                                <div class="text-end text-muted small">
                                    <div>Điểm đạt: <strong>${quiz.passScore} điểm</strong></div>
                                    <c:if test="${quiz.timeLimitMinutes != null}">
                                        <div>Thời gian: <strong>${quiz.timeLimitMinutes} phút</strong></div>
                                    </c:if>
                                </div>
                            </div>

                            <form action="${pageContext.request.contextPath}/quizzes/submit" method="POST">
                                <input type="hidden" name="attemptId" value="${attempt.id}">
                                <input type="hidden" name="registrationId" value="${attempt.registrationId}">
                                <input type="hidden" name="quizId" value="${attempt.quizId}">

                                <c:forEach var="q" items="${quiz.questions}" varStatus="status">
                                    <input type="hidden" name="questionId" value="${q.id}">
                                    <div class="card p-3 mb-3 bg-light-subtle">
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <h6 class="fw-bold mb-0">
                                                <span class="text-primary me-1">Câu ${status.count}:</span>
                                                ${q.questionText}
                                            </h6>
                                            <div class="d-flex align-items-center gap-1.5 flex-shrink-0 ms-2">
                                                <c:choose>
                                                    <c:when test="${q.questionType == 'MULTI_CHOICE'}">
                                                        <span
                                                            class="badge bg-primary-subtle text-primary border border-primary-subtle small">
                                                            <i class="bi bi-ui-checks me-1"></i>Chọn nhiều đáp án
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${q.questionType == 'TRUE_FALSE'}">
                                                        <span
                                                            class="badge bg-secondary-subtle text-secondary border small">Đúng
                                                            / Sai</span>
                                                    </c:when>
                                                </c:choose>
                                                <span class="badge bg-secondary-subtle text-secondary small">
                                                    ${q.assignedPoints != null ? q.assignedPoints : q.defaultPoints}
                                                    điểm
                                                </span>
                                            </div>
                                        </div>
                                        <div class="d-flex flex-column gap-2">
                                            <c:forEach var="opt" items="${q.options}">
                                                <div class="form-check">
                                                    <c:choose>
                                                        <c:when test="${q.questionType == 'MULTI_CHOICE'}">
                                                            <input class="form-check-input" type="checkbox"
                                                                name="question_${q.id}" id="opt_${opt.id}"
                                                                value="${opt.id}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <input class="form-check-input" type="radio"
                                                                name="question_${q.id}" id="opt_${opt.id}"
                                                                value="${opt.id}">
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <label class="form-check-label" for="opt_${opt.id}">
                                                        ${opt.optionText}
                                                    </label>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:forEach>

                                <div class="text-end mt-4">
                                    <button type="submit" class="btn btn-primary btn-lg px-5 fw-semibold"
                                        onclick="return confirm('Bạn có chắc chắn muốn nộp bài thi?');">
                                        <i class="bi bi-send-check me-1"></i>Nộp bài kiểm tra
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <jsp:include page="../common/footer.jsp" />