<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Chi tiết bài thi - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Breadcrumb -->
        <nav class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/expert/dashboard">Expert Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/quizzes/list?${not empty courseId ? 'courseId='.concat(courseId) : 'moduleId='.concat(quiz.moduleId)}">Danh sách Quiz</a></li>
                <li class="breadcrumb-item active">${quiz.title}</li>
            </ol>
        </nav>

        <div class="row g-4">
            <!-- Top: Quiz Info Form -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-gear-fill text-primary me-2"></i>Cấu hình bài thi</h5>
                    <form action="${pageContext.request.contextPath}/quizzes/save" method="POST">
                        <input type="hidden" name="id" value="${quiz.id}">
                        <input type="hidden" name="moduleId" value="${quiz.moduleId}">
                        <c:if test="${not empty courseId}">
                            <input type="hidden" name="courseId" value="${courseId}">
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Tên bài thi <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control" value="${quiz.title}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Điểm đạt tối thiểu (0-100%)</label>
                            <input type="number" name="passScore" class="form-control" value="${quiz.passScore}" min="0" max="100" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Thời lượng (Phút)</label>
                            <input type="number" name="timeLimitMinutes" class="form-control" value="${quiz.timeLimitMinutes}">
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Thứ tự bài thi</label>
                            <input type="number" name="orderIndex" class="form-control" value="${quiz.orderIndex}" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-semibold">
                            <i class="bi bi-save me-1"></i>Cập nhật thông tin
                        </button>
                    </form>
                </div>
            </div>

            <!-- Bottom: Questions in Quiz -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="fw-bold mb-0"><i class="bi bi-question-circle text-warning me-2"></i>Câu hỏi trong bài thi</h5>
                            <small class="text-muted">Tổng cộng: ${quiz.questions.size()} câu hỏi</small>
                        </div>
                        <a href="${pageContext.request.contextPath}/quizzes/question-bank?moduleId=${quiz.moduleId}&quizId=${quiz.id}" class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-plus-circle me-1"></i>Thêm câu hỏi từ Ngân hàng
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>STT</th>
                                    <th>Nội dung câu hỏi</th>
                                    <th>Loại câu hỏi</th>
                                    <th>Điểm số</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty quiz.questions}">
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">
                                                Bài thi này chưa có câu hỏi nào. Hãy bấm "Thêm câu hỏi từ Ngân hàng" để đưa câu hỏi vào bài thi.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="qq" items="${quiz.questions}" varStatus="status">
                                            <tr>
                                                <td>#${status.index + 1}</td>
                                                <td class="fw-semibold">${qq.questionText}</td>
                                                <td><span class="badge bg-light text-dark border">${qq.questionType}</span></td>
                                                <td><strong>${qq.points}</strong> đ</td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/quizzes/remove-question?quizId=${quiz.id}&questionId=${qq.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có muốn gỡ câu hỏi này khỏi bài thi không?');">
                                                        <i class="bi bi-trash"></i> Gỡ
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
