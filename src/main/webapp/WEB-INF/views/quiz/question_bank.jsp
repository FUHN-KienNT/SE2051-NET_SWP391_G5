<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Ngân hàng câu hỏi - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Top bar -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1"><i class="bi bi-bank me-2"></i>Ngân hàng Câu hỏi (Question Bank)</h3>
                <p class="text-muted small mb-0">Quản lý kho câu hỏi trắc nghiệm tái sử dụng cho các bài kiểm tra (Màn hình II.5.2.1)</p>
            </div>
            <div class="d-flex gap-2">
                <c:if test="${not empty param.quizId}">
                    <a href="${pageContext.request.contextPath}/quizzes/detail?id=${param.quizId}" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i>Quay lại bài thi
                    </a>
                </c:if>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                    <i class="bi bi-plus-lg me-1"></i>Tạo câu hỏi mới
                </button>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty questions}">
                <div class="card p-5 text-center border-0 shadow-sm rounded-3">
                    <i class="bi bi-question-diamond fs-1 text-muted mb-3"></i>
                    <h5>Ngân hàng câu hỏi của chương này đang trống!</h5>
                    <p class="text-muted small">Hãy bấm "Tạo câu hỏi mới" để thêm câu hỏi trắc nghiệm vào kho lưu trữ.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach var="q" items="${questions}" varStatus="status">
                        <div class="col-12">
                            <div class="card border-0 shadow-sm rounded-3 p-4">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle me-2">Câu #${status.index + 1}</span>
                                        <span class="badge bg-light text-dark border me-2">${q.questionType}</span>
                                        <span class="badge bg-secondary-subtle text-secondary border">Điểm: ${q.defaultPoints}</span>
                                        <h5 class="fw-bold mt-2 mb-0">${q.questionText}</h5>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <c:if test="${not empty param.quizId}">
                                            <form action="${pageContext.request.contextPath}/quizzes/assign-question" method="POST" class="d-inline">
                                                <input type="hidden" name="quizId" value="${param.quizId}">
                                                <input type="hidden" name="questionId" value="${q.id}">
                                                <input type="hidden" name="points" value="${q.defaultPoints}">
                                                <input type="hidden" name="order" value="1">
                                                <button type="submit" class="btn btn-sm btn-success">
                                                    <i class="bi bi-plus-circle me-1"></i>Gán vào bài thi
                                                </button>
                                            </form>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/quizzes/delete-question?id=${q.id}&moduleId=${moduleId}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có chắc muốn xóa câu hỏi này khỏi ngân hàng câu hỏi?');">
                                            <i class="bi bi-trash"></i> Xóa
                                        </a>
                                    </div>
                                </div>

                                <!-- Answers display -->
                                <div class="row g-2 pt-2 border-top">
                                    <c:forEach var="opt" items="${q.options}">
                                        <div class="col-md-6">
                                            <div class="p-2 rounded border ${opt.correct ? 'bg-success-subtle border-success' : 'bg-light'} small">
                                                <i class="bi ${opt.correct ? 'bi-check-circle-fill text-success' : 'bi-circle'} me-2"></i>
                                                <span class="${opt.correct ? 'fw-bold text-success' : ''}">${opt.optionText}</span>
                                                <c:if test="${opt.correct}">
                                                    <span class="badge bg-success float-end">Đáp án đúng</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- Modal Create Question with 4 Options -->
<div class="modal fade" id="newQuestionModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/quizzes/save-question" method="POST">
                <input type="hidden" name="moduleId" value="${moduleId}">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Thêm câu hỏi mới vào Ngân hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Nội dung câu hỏi <span class="text-danger">*</span></label>
                        <textarea name="questionText" rows="3" class="form-control" required placeholder="Nhập câu hỏi ở đây..."></textarea>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Loại câu hỏi</label>
                            <select name="questionType" class="form-select">
                                <option value="SINGLE_CHOICE">Trắc nghiệm 1 đáp án (Single Choice)</option>
                                <option value="TRUE_FALSE">Đúng / Sai (True / False)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Điểm mặc định</label>
                            <input type="number" step="0.5" name="defaultPoints" value="1.0" class="form-control" required>
                        </div>
                    </div>

                    <!-- 4 Options -->
                    <label class="form-label small fw-semibold text-primary">Các lựa chọn trả lời (Chọn radio để đánh dấu đáp án đúng):</label>
                    <div class="mb-2 input-group">
                        <div class="input-group-text">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="0" required checked>
                        </div>
                        <span class="input-group-text fw-bold">A</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Đáp án A" required>
                    </div>

                    <div class="mb-2 input-group">
                        <div class="input-group-text">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="1">
                        </div>
                        <span class="input-group-text fw-bold">B</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Đáp án B" required>
                    </div>

                    <div class="mb-2 input-group">
                        <div class="input-group-text">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="2">
                        </div>
                        <span class="input-group-text fw-bold">C</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Đáp án C">
                    </div>

                    <div class="mb-3 input-group">
                        <div class="input-group-text">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="3">
                        </div>
                        <span class="input-group-text fw-bold">D</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Đáp án D">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold">Lưu vào ngân hàng câu hỏi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
