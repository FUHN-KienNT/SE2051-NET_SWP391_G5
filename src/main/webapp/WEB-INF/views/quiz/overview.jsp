<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Tổng quan bài kiểm tra - ${quiz.title}" />
<jsp:include page="../common/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- BREADCRUMB / BACK LINK -->
                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registrationId}" class="text-decoration-none text-muted small">
                        <i class="bi bi-arrow-left me-1"></i>Quay lại bài học
                    </a>
                </div>

                <!-- MAIN CARD -->
                <div class="card shadow-sm border-0 rounded-3 p-4 mb-4">
                    <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-4">
                        <div>
                            <span class="badge bg-warning-subtle text-dark border px-2 py-1 mb-2">
                                <i class="bi bi-patch-question me-1"></i>Bài kiểm tra
                            </span>
                            <h2 class="fw-bold mb-0 text-dark">${quiz.title}</h2>
                        </div>
                        <c:choose>
                            <c:when test="${lastResult != null && lastResult.passStatus}">
                                <span class="badge bg-success fs-6 px-3 py-2 shadow-sm">
                                    <i class="bi bi-check-circle-fill me-1"></i>Đã đạt
                                </span>
                            </c:when>
                            <c:when test="${lastResult != null && !lastResult.passStatus}">
                                <span class="badge bg-danger fs-6 px-3 py-2 shadow-sm">
                                    <i class="bi bi-x-circle-fill me-1"></i>Chưa đạt
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary-subtle text-secondary fs-6 px-3 py-2 border">
                                    <i class="bi bi-clock me-1"></i>Chưa làm
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- QUIZ SPECS -->
                    <div class="row g-3 mb-4 text-center">
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border h-100">
                                <i class="bi bi-question-circle text-primary fs-3 d-block mb-1"></i>
                                <span class="d-block text-muted small">Số câu hỏi</span>
                                <strong class="fs-5 text-dark">${quiz.questions != null ? quiz.questions.size() : 0} câu</strong>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border h-100">
                                <i class="bi bi-stopwatch text-danger fs-3 d-block mb-1"></i>
                                <span class="d-block text-muted small">Thời gian</span>
                                <strong class="fs-5 text-dark">
                                    <c:choose>
                                        <c:when test="${quiz.timeLimitMinutes != null && quiz.timeLimitMinutes > 0}">
                                            ${quiz.timeLimitMinutes} phút
                                        </c:when>
                                        <c:otherwise>Không giới hạn</c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border h-100">
                                <i class="bi bi-award text-success fs-3 d-block mb-1"></i>
                                <span class="d-block text-muted small">Điểm đạt</span>
                                <strong class="fs-5 text-dark">${quiz.passScore} điểm</strong>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border h-100">
                                <i class="bi bi-ui-checks-grid text-warning fs-3 d-block mb-1"></i>
                                <span class="d-block text-muted small">Hình thức</span>
                                <strong class="fs-6 text-dark d-block mt-1">Trắc nghiệm</strong>
                            </div>
                        </div>
                    </div>

                    <!-- PREVIOUS ATTEMPT INFO (IF ANY) -->
                    <c:if test="${lastResult != null}">
                        <div class="alert ${lastResult.passStatus ? 'alert-success border-success-subtle' : 'alert-danger border-danger-subtle'} rounded-3 p-3 mb-4">
                            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2">
                                <div>
                                    <h6 class="fw-bold mb-1">
                                        <i class="bi ${lastResult.passStatus ? 'bi-check2-circle' : 'bi-exclamation-circle'} me-1"></i>
                                        Kết quả lần làm gần nhất
                                    </h6>
                                    <div class="small">
                                        Điểm số: <strong>${lastResult.totalScore} / ${lastResult.maxScore}</strong> 
                                        (${lastResult.percentage}%) - 
                                        Trạng thái: <strong>${lastResult.passStatus ? 'Đạt' : 'Chưa đạt'}</strong>
                                    </div>
                                </div>
                                <a href="${pageContext.request.contextPath}/quizzes/result?registrationId=${registrationId}&quizId=${quiz.id}" 
                                   class="btn btn-sm ${lastResult.passStatus ? 'btn-success' : 'btn-danger'} px-3 shadow-sm">
                                    <i class="bi bi-eye me-1"></i>Xem lại chi tiết bài làm
                                </a>
                            </div>
                        </div>
                    </c:if>

                    <!-- INSTRUCTIONS -->
                    <div class="bg-light-subtle border rounded-3 p-3 mb-4">
                        <h6 class="fw-bold text-dark mb-2">
                            <i class="bi bi-info-circle me-1 text-primary"></i>Lưu ý trước khi làm bài:
                        </h6>
                        <ul class="text-muted small mb-0 ps-3">
                            <li>Đảm bảo đường truyền internet ổn định trong suốt quá trình làm bài.</li>
                            <c:if test="${quiz.timeLimitMinutes != null && quiz.timeLimitMinutes > 0}">
                                <li>Đồng hồ đếm ngược sẽ tự động chạy ngay khi bạn bắt đầu. Hệ thống sẽ <strong>tự động nộp bài</strong> khi hết thời gian.</li>
                            </c:if>
                            <li>Hệ thống hỗ trợ <strong>làm lại bài thi nhiều lần</strong>. Khi làm lại, kết quả và điểm số mới sẽ <strong>ghi đè lên kết quả cũ</strong>.</li>
                        </ul>
                    </div>

                    <!-- ACTION BUTTONS -->
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                        <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registrationId}" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại bài học
                        </a>

                        <c:choose>
                            <c:when test="${lastResult == null}">
                                <a href="${pageContext.request.contextPath}/quizzes/attempt?registrationId=${registrationId}&quizId=${quiz.id}" 
                                   class="btn btn-primary btn-lg px-5 shadow-sm fw-semibold">
                                    <i class="bi bi-play-circle me-1"></i>Bắt đầu làm bài
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/quizzes/attempt?registrationId=${registrationId}&quizId=${quiz.id}&retake=true" 
                                   class="btn btn-warning btn-lg px-5 shadow-sm fw-semibold text-dark"
                                   onclick="return confirm('Lưu ý: Làm lại bài thi sẽ xóa bài làm cũ và ghi đè kết quả mới vào hệ thống. Bạn có chắc chắn muốn làm lại?');">
                                    <i class="bi bi-arrow-repeat me-1"></i>Làm lại bài thi
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />

