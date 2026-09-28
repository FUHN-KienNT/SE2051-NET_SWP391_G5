<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản lý bài thi (Quiz List) - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Top bar -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1"><i class="bi bi-patch-question me-2"></i>Danh sách Bài thi / Kiểm tra (Quiz List)</h3>
                <p class="text-muted small mb-0">Quản lý các bài trắc nghiệm, thời gian làm bài và điểm đạt (Màn hình II.5.1.1)</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/quizzes/question-bank?moduleId=${moduleId}" class="btn btn-outline-info">
                    <i class="bi bi-bank me-1"></i>Ngân hàng câu hỏi
                </a>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newQuizModal">
                    <i class="bi bi-plus-lg me-1"></i>Tạo bài Quiz mới
                </button>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty quizzes}">
                <div class="card p-5 text-center border-0 shadow-sm rounded-3">
                    <i class="bi bi-journal-x fs-1 text-muted mb-3"></i>
                    <h5>Chưa có bài Quiz nào trong chương này!</h5>
                    <p class="text-muted small">Hãy bấm nút "Tạo bài Quiz mới" để thiết lập bài kiểm tra cho học viên.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Thứ tự</th>
                                    <th>Tiêu đề bài thi</th>
                                    <th>Điểm đạt (Pass Score)</th>
                                    <th>Thời gian làm bài</th>
                                    <th>Số lượng câu hỏi</th>
                                    <th class="text-end">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="q" items="${quizzes}">
                                    <tr>
                                        <td><span class="badge bg-light text-dark border">#${q.orderIndex}</span></td>
                                        <td class="fw-bold">${q.title}</td>
                                        <td><span class="badge bg-success-subtle text-success border">${q.passScore}%</span></td>
                                        <td>${q.timeLimitMinutes != null ? q.timeLimitMinutes.concat(' phút') : 'Không giới hạn'}</td>
                                        <td>${q.questions.size()} câu</td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/quizzes/detail?id=${q.id}" class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-pencil-square me-1"></i>Chi tiết &amp; Gán câu hỏi
                                            </a>
                                            <a href="${pageContext.request.contextPath}/quizzes/delete?id=${q.id}&moduleId=${q.moduleId}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa bài thi này?');">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- Modal Create Quiz -->
<div class="modal fade" id="newQuizModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/quizzes/save" method="POST">
                <input type="hidden" name="moduleId" value="${moduleId}">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Tạo bài kiểm tra mới (Quiz)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên bài thi <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required placeholder="Ví dụ: Kiểm tra kiến thức chương 1">
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Điểm đạt (0 - 100%) <span class="text-danger">*</span></label>
                            <input type="number" step="1" name="passScore" value="50" min="0" max="100" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Thời lượng (Phút)</label>
                            <input type="number" name="timeLimitMinutes" value="15" min="1" class="form-control" placeholder="Để trống nếu không giới hạn">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Thứ tự hiển thị</label>
                        <input type="number" name="orderIndex" value="1" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold">Lưu &amp; Tiếp tục</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
