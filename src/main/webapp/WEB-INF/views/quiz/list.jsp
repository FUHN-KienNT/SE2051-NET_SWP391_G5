<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản lý bài thi (Quiz List) - ${not empty course ? course.title : 'Courson LMS'}" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-4">
    <div class="container-fluid px-4">
        <!-- Breadcrumb Navigation -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/expert/dashboard" class="text-decoration-none">
                        <i class="bi bi-mortarboard me-1"></i>Expert Dashboard
                    </a>
                </li>
                <c:if test="${not empty course}">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="text-decoration-none">
                            ${course.title}
                        </a>
                    </li>
                </c:if>
                <li class="breadcrumb-item active" aria-current="page">Quản lý Quiz &amp; Bài kiểm tra</li>
            </ol>
        </nav>

        <!-- Alert messages -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'deleted'}">Đã xóa bài kiểm tra thành công!</c:when>
                    <c:otherwise>Thao tác thành công!</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Top Header Bar -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1">
                    <i class="bi bi-patch-question text-warning me-2"></i>
                    <c:choose>
                        <c:when test="${not empty course}">Đề cương Bài thi &amp; Quiz: ${course.title}</c:when>
                        <c:otherwise>Danh sách Bài thi / Kiểm tra (Quiz List)</c:otherwise>
                    </c:choose>
                </h3>
                <p class="text-muted small mb-0">Quản lý các bài trắc nghiệm, thời lượng làm bài và điểm đạt phân bổ theo từng chương học (Màn hình II.5.1.1)</p>
            </div>
            <div class="d-flex gap-2">
                <c:if test="${not empty course}">
                    <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-outline-primary">
                        <i class="bi bi-journal-text me-1"></i>Nội dung bài học
                    </a>
                </c:if>
                <c:if test="${not empty course and not empty course.modules}">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newQuizModal" onclick="openCreateQuizModal('')">
                        <i class="bi bi-plus-lg me-1"></i>Tạo bài Quiz mới
                    </button>
                </c:if>
                <c:if test="${empty course and not empty moduleId}">
                    <a href="${pageContext.request.contextPath}/quizzes/question-bank?moduleId=${moduleId}" class="btn btn-outline-info">
                        <i class="bi bi-bank me-1"></i>Ngân hàng câu hỏi
                    </a>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newQuizModal" onclick="openCreateQuizModal('${moduleId}')">
                        <i class="bi bi-plus-lg me-1"></i>Tạo bài Quiz mới
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Main Content Area -->
        <c:choose>
            <%-- TH1: Hiển thị theo Khóa học (Course), chia Card theo từng Module --%>
            <c:when test="${not empty course}">
                <c:choose>
                    <c:when test="${empty course.modules}">
                        <div class="card p-5 text-center border-0 shadow-sm rounded-3">
                            <i class="bi bi-folder2-open fs-1 text-muted mb-3"></i>
                            <h5>Khóa học này chưa có chương học nào!</h5>
                            <p class="text-muted small">Hãy tạo chương học (Modules) trước để có thể thiết lập bài kiểm tra cho từng chương.</p>
                            <div>
                                <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-primary">
                                    <i class="bi bi-plus-circle me-1"></i>Đi đến Quản lý Chương &amp; Bài học
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row g-4">
                            <c:forEach var="m" items="${course.modules}">
                                <div class="col-12" id="module-${m.id}">
                                    <div class="card border-0 shadow-sm rounded-3 overflow-hidden ${selectedModuleId == m.id ? 'border border-warning' : ''}">
                                        <!-- Module Header -->
                                        <div class="card-header bg-light py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="badge bg-primary">Chương ${m.orderIndex}</span>
                                                <h5 class="fw-bold mb-0 text-dark">${m.title}</h5>
                                                <span class="badge bg-secondary-subtle text-secondary border ms-1">
                                                    ${not empty m.quizzes ? m.quizzes.size() : 0} bài quiz
                                                </span>
                                            </div>
                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/quizzes/question-bank?moduleId=${m.id}&courseId=${course.id}" 
                                                   class="btn btn-sm btn-outline-info" title="Quản lý ngân hàng câu hỏi của chương này">
                                                    <i class="bi bi-bank me-1"></i>Ngân hàng câu hỏi
                                                </a>
                                                <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#newQuizModal" 
                                                        onclick="openCreateQuizModal('${m.id}')">
                                                    <i class="bi bi-plus-lg me-1"></i>Thêm Quiz
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Module Quizzes Body -->
                                        <div class="card-body p-0">
                                            <c:choose>
                                                <c:when test="${empty m.quizzes}">
                                                    <div class="p-4 text-center text-muted small">
                                                        <i class="bi bi-journal-x me-1"></i>Chưa có bài Quiz nào trong chương này. Bấm <strong>"Thêm Quiz"</strong> ở trên để tạo bài kiểm tra.
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="table-responsive">
                                                        <table class="table table-hover align-middle mb-0">
                                                            <thead class="table-light small text-uppercase text-muted">
                                                                <tr>
                                                                    <th style="width: 80px;" class="ps-3">Thứ tự</th>
                                                                    <th>Tiêu đề bài thi</th>
                                                                    <th>Điểm đạt</th>
                                                                    <th>Thời lượng</th>
                                                                    <th class="text-end pe-3">Hành động</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="q" items="${m.quizzes}">
                                                                    <tr>
                                                                        <td class="ps-3">
                                                                            <span class="badge bg-light text-dark border">#${q.orderIndex}</span>
                                                                        </td>
                                                                        <td>
                                                                            <strong class="text-dark">${q.title}</strong>
                                                                        </td>
                                                                        <td>
                                                                            <span class="badge bg-success-subtle text-success border px-2 py-1">
                                                                                <i class="bi bi-check-circle me-1"></i>${q.passScore}%
                                                                            </span>
                                                                        </td>
                                                                        <td>
                                                                            <span class="text-muted">
                                                                                <i class="bi bi-clock me-1"></i>
                                                                                <c:choose>
                                                                                    <c:when test="${q.timeLimitMinutes != null and q.timeLimitMinutes > 0}">
                                                                                        ${q.timeLimitMinutes} phút
                                                                                    </c:when>
                                                                                    <c:otherwise>Không giới hạn</c:otherwise>
                                                                                </c:choose>
                                                                            </span>
                                                                        </td>
                                                                        <td class="text-end pe-3">
                                                                            <a href="${pageContext.request.contextPath}/quizzes/detail?id=${q.id}&courseId=${course.id}" 
                                                                               class="btn btn-sm btn-outline-primary me-1" title="Chi tiết cấu hình và gán câu hỏi">
                                                                                <i class="bi bi-pencil-square me-1"></i>Chi tiết &amp; Gán câu hỏi
                                                                            </a>
                                                                            <a href="${pageContext.request.contextPath}/quizzes/delete?id=${q.id}&courseId=${course.id}&moduleId=${m.id}" 
                                                                               class="btn btn-sm btn-outline-danger" 
                                                                               onclick="return confirm('Bạn có chắc chắn muốn xóa bài thi này? Tất cả câu hỏi được gán cũng sẽ bị gỡ bỏ.');"
                                                                               title="Xóa bài thi">
                                                                                <i class="bi bi-trash"></i>
                                                                            </a>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:when>

            <%-- TH2: Fallback hiển thị theo 1 Module đơn lẻ (nếu chỉ truyền moduleId) --%>
            <c:otherwise>
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
                                            <th>Điểm đạt</th>
                                            <th>Thời gian làm bài</th>
                                            <th class="text-end">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="q" items="${quizzes}">
                                            <tr>
                                                <td><span class="badge bg-light text-dark border">#${q.orderIndex}</span></td>
                                                <td class="fw-bold">${q.title}</td>
                                                <td><span class="badge bg-success-subtle text-success border">${q.passScore}%</span></td>
                                                <td>${q.timeLimitMinutes != null ? q.timeLimitMinutes : 'Không giới hạn'}</td>
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
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- Modal Create Quiz -->
<div class="modal fade" id="newQuizModal" tabindex="-1" aria-labelledby="newQuizModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/quizzes/save" method="POST">
                <c:if test="${not empty course}">
                    <input type="hidden" name="courseId" value="${course.id}">
                </c:if>

                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold" id="newQuizModalLabel">
                        <i class="bi bi-plus-circle text-primary me-2"></i>Tạo bài kiểm tra mới (Quiz)
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <!-- Chọn Module (Chương học) -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Thuộc chương học <span class="text-danger">*</span></label>
                        <c:choose>
                            <c:when test="${not empty course and not empty course.modules}">
                                <select name="moduleId" id="modalModuleSelect" class="form-select" required>
                                    <c:forEach var="moduleItem" items="${course.modules}">
                                        <option value="${moduleItem.id}" ${selectedModuleId == moduleItem.id ? 'selected' : ''}>
                                            Chương ${moduleItem.orderIndex}: ${moduleItem.title}
                                        </option>
                                    </c:forEach>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="moduleId" id="modalModuleSelect" value="${moduleId}">
                                <input type="text" class="form-control" value="Chương hiện tại (#${moduleId})" disabled>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên bài thi <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required placeholder="Ví dụ: Kiểm tra trắc nghiệm chương 1">
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Điểm đạt (0 - 100%) <span class="text-danger">*</span></label>
                            <input type="number" step="1" name="passScore" value="50" min="0" max="100" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Thời lượng (Phút)</label>
                            <input type="number" name="timeLimitMinutes" value="15" min="1" class="form-control" placeholder="Trống = Không giới hạn">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Thứ tự hiển thị</label>
                        <input type="number" name="orderIndex" value="1" min="1" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold px-4">
                        <i class="bi bi-save me-1"></i>Lưu bài thi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openCreateQuizModal(moduleId) {
    if (moduleId) {
        var select = document.getElementById('modalModuleSelect');
        if (select) {
            select.value = moduleId;
        }
    }
}
</script>

<jsp:include page="../common/footer.jsp" />
