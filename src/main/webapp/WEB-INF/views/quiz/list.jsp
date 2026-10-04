<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Khảo thí & Ngân hàng câu hỏi - ${not empty course ? course.title : 'Courson LMS'}" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">

        <!-- Breadcrumb Navigation Đồng bộ -->
        <nav class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/expert/dashboard" class="text-decoration-none">
                        Expert Dashboard
                    </a>
                </li>
                <c:if test="${not empty course}">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="text-decoration-none">
                            ${course.title}
                        </a>
                    </li>
                </c:if>
                <li class="breadcrumb-item active" aria-current="page">
                    Quản lý Quiz &amp; Ngân hàng câu hỏi
                </li>
            </ol>
        </nav>

        <!-- System Alerts Đồng bộ -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'deleted'}">Đã xóa bài kiểm tra thành công.</c:when>
                    <c:when test="${param.success == 'saved'}">Đã lưu thông tin cấu hình bài kiểm tra thành công.</c:when>
                    <c:when test="${param.success == 'question_saved'}">Đã lưu câu hỏi vào ngân hàng thành công!</c:when>
                    <c:when test="${param.success == 'question_deleted'}">Đã xóa câu hỏi khỏi ngân hàng thành công!</c:when>
                    <c:otherwise>Thao tác đã được ghi nhận thành công.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Header Top Bar Đồng bộ Dashboard & Lesson List -->
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div>
                <h3 class="fw-bold mb-1">
                    <i class="bi bi-patch-question-fill text-primary me-2"></i>Khảo thí &amp; Ngân hàng câu hỏi: ${course.title}
                </h3>
                <p class="text-muted small mb-0">
                    Quản lý các bài kiểm tra trắc nghiệm theo chương và kho câu hỏi tập trung (Màn hình II.5.1)
                </p>
            </div>
            <div class="d-flex gap-2">
                <c:if test="${not empty course}">
                    <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-outline-secondary fw-semibold">
                        <i class="bi bi-journal-text me-1 text-primary"></i>Soạn Bài học
                    </a>
                    <button type="button" class="btn btn-primary fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#quizModal" onclick="openCreateQuizModal('')">
                        <i class="bi bi-plus-circle-fill me-1"></i>Tạo bài Quiz mới
                    </button>
                    <button type="button" class="btn btn-success fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#questionModal" onclick="openCreateQuestionModal('')">
                        <i class="bi bi-patch-plus-fill me-1"></i>Thêm câu hỏi
                    </button>
                </c:if>
            </div>
        </div>

        <!-- 2 Main Tabs Navigation Đồng bộ -->
        <ul class="nav nav-tabs mb-4" id="assessmentTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active fw-semibold" id="pills-quizzes-tab" data-bs-toggle="tab" data-bs-target="#pills-quizzes" type="button" role="tab">
                    <i class="bi bi-patch-question me-1.5 text-primary"></i>Đề thi &amp; Bài kiểm tra
                    <c:if test="${not empty course}">
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill ms-2">${course.totalQuizzes}</span>
                    </c:if>
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-semibold" id="pills-questions-tab" data-bs-toggle="tab" data-bs-target="#pills-questions" type="button" role="tab">
                    <i class="bi bi-database me-1.5 text-warning"></i>Ngân hàng câu hỏi
                    <span class="badge bg-secondary-subtle text-secondary border rounded-pill ms-2" id="totalQuestionsBadge">
                        ${not empty courseQuestions ? fn:length(courseQuestions) : 0}
                    </span>
                </button>
            </li>
        </ul>

        <!-- Tab Content -->
        <div class="tab-content" id="assessmentTabsContent">

            <!-- ========================================== -->
            <!-- TAB 1: DANH SÁCH BÀI QUIZ THEO CHƯƠNG      -->
            <!-- ========================================== -->
            <div class="tab-pane fade show active" id="pills-quizzes" role="tabpanel">
                <c:choose>
                    <c:when test="${empty course or empty course.modules}">
                        <div class="card p-5 text-center border-0 shadow-sm rounded-3 mb-4">
                            <i class="bi bi-folder-x display-4 text-muted mb-3"></i>
                            <h5 class="fw-bold text-dark">Khóa học này chưa có chương học nào!</h5>
                            <p class="text-muted small mb-3">Bạn cần tạo ít nhất một chương học để có thể thiết lập các bài kiểm tra trắc nghiệm.</p>
                            <div>
                                <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-primary fw-semibold">
                                    <i class="bi bi-plus-circle me-1"></i>Tạo chương học ngay
                                </a>
                            </div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="row g-4">
                            <c:forEach var="m" items="${course.modules}">
                                <div class="col-12">
                                    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                                        <!-- Module Header Bar -->
                                        <div class="card-header bg-white py-3 d-flex flex-wrap justify-content-between align-items-center gap-2 border-bottom">
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="badge bg-light text-dark border fw-semibold">Chương ${m.orderIndex}</span>
                                                <h5 class="fw-bold mb-0 text-dark">${m.title}</h5>
                                                <span class="badge bg-light text-muted border ms-1">
                                                    ${not empty m.quizzes ? fn:length(m.quizzes) : 0} quiz
                                                </span>
                                            </div>

                                            <div class="d-flex gap-2">
                                                <button type="button" class="btn btn-sm btn-outline-success" onclick="openCreateQuestionModal('${m.id}')" data-bs-toggle="modal" data-bs-target="#questionModal">
                                                    <i class="bi bi-plus-circle me-1"></i>Thêm câu hỏi vào chương
                                                </button>
                                                <button type="button" class="btn btn-sm btn-primary fw-semibold shadow-sm" onclick="openCreateQuizModal('${m.id}')" data-bs-toggle="modal" data-bs-target="#quizModal">
                                                    <i class="bi bi-plus-lg me-1"></i>Tạo Quiz
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Quizzes Table -->
                                        <div class="card-body p-0">
                                            <c:choose>
                                                <c:when test="${empty m.quizzes}">
                                                    <div class="p-4 text-center text-muted small">
                                                        Chưa có bài Quiz nào trong chương này. Bấm "Tạo Quiz" để thêm bài kiểm tra đánh giá.
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="table-responsive">
                                                        <table class="table table-hover align-middle mb-0">
                                                            <thead class="table-light">
                                                                <tr>
                                                                    <th style="width: 80px;" class="ps-3">Thứ tự</th>
                                                                    <th>Tiêu đề bài thi (Quiz Title)</th>
                                                                    <th style="width: 160px;" class="text-center">Điểm đạt tối thiểu</th>
                                                                    <th style="width: 170px;" class="text-center">Thời lượng</th>
                                                                    <th style="width: 220px;" class="text-end pe-3">Hành động</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="q" items="${m.quizzes}">
                                                                    <tr>
                                                                        <td class="ps-3">
                                                                            <span class="badge bg-light text-dark border">#${q.orderIndex}</span>
                                                                        </td>
                                                                        <td>
                                                                            <div class="d-flex align-items-center">
                                                                                <div class="bg-primary-subtle text-primary rounded-3 p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                                                                                    <i class="bi bi-file-earmark-check"></i>
                                                                                </div>
                                                                                <div>
                                                                                    <a href="${pageContext.request.contextPath}/quizzes/detail?id=${q.id}&courseId=${course.id}" class="fw-bold text-dark text-decoration-none">
                                                                                        ${q.title}
                                                                                    </a>
                                                                                    <span class="small text-muted d-block">Mã đề: #${q.id}</span>
                                                                                </div>
                                                                            </div>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2.5 py-1">
                                                                                <i class="bi bi-check2-circle me-1"></i>${q.passScore}%
                                                                            </span>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <c:choose>
                                                                                <c:when test="${q.timeLimitMinutes != null and q.timeLimitMinutes > 0}">
                                                                                    <span class="badge bg-light text-dark border px-2.5 py-1">
                                                                                        <i class="bi bi-clock me-1 text-primary"></i>${q.timeLimitMinutes} phút
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="badge bg-light text-muted border px-2.5 py-1">Không giới hạn</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                        <td class="text-end pe-3">
                                                                            <div class="d-inline-flex align-items-center justify-content-end gap-1">
                                                                                <a href="${pageContext.request.contextPath}/quizzes/detail?id=${q.id}&courseId=${course.id}" 
                                                                                   class="btn btn-sm btn-primary shadow-sm" title="Soạn câu hỏi">
                                                                                    <i class="bi bi-sliders2-vertical me-1"></i>Soạn câu hỏi
                                                                                </a>
                                                                                <button type="button" class="btn btn-sm btn-outline-secondary" 
                                                                                        onclick="openEditQuizModal('${q.id}', '${m.id}', '${fn:escapeXml(q.title)}', '${q.passScore}', '${q.timeLimitMinutes != null ? q.timeLimitMinutes : ''}', '${q.orderIndex}')"
                                                                                        data-bs-toggle="modal" data-bs-target="#quizModal"
                                                                                        title="Sửa thông tin">
                                                                                    <i class="bi bi-gear"></i>
                                                                                </button>
                                                                                <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                                        onclick="openDeleteQuizModal('${q.id}', '${fn:escapeXml(q.title)}', '${course.id}', '${m.id}')"
                                                                                        data-bs-toggle="modal" data-bs-target="#deleteQuizModal"
                                                                                        title="Xóa bài Quiz">
                                                                                    <i class="bi bi-trash"></i>
                                                                                </button>
                                                                            </div>
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
            </div>

            <!-- ========================================== -->
            <!-- TAB 2: NGÂN HÀNG CÂU HỎI (QUESTION LIST)   -->
            <!-- ========================================== -->
            <div class="tab-pane fade" id="pills-questions" role="tabpanel">
                <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                    <!-- Filter Toolbar -->
                    <div class="card-header bg-white py-3 border-bottom">
                        <div class="row g-3 align-items-center justify-content-between">
                            <div class="col-md-5 col-12">
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-search"></i></span>
                                    <input type="text" id="questionSearchInput" class="form-control border-start-0" placeholder="Tìm câu hỏi theo nội dung...">
                                </div>
                            </div>

                            <div class="col-md-4 col-sm-6">
                                <select id="questionModuleFilter" class="form-select">
                                    <option value="all">Tất cả chương học</option>
                                    <c:forEach var="moduleItem" items="${course.modules}">
                                        <option value="${moduleItem.id}">Chương ${moduleItem.orderIndex}: ${moduleItem.title}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-3 col-sm-6 text-md-end">
                                <button type="button" class="btn btn-success fw-semibold shadow-sm w-100 w-md-auto" onclick="openCreateQuestionModal('')" data-bs-toggle="modal" data-bs-target="#questionModal">
                                    <i class="bi bi-plus-lg me-1"></i>Thêm câu hỏi mới
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Questions Table -->
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty courseQuestions}">
                                <div class="p-5 text-center text-muted">
                                    <i class="bi bi-patch-question display-4 d-block mb-3 opacity-50"></i>
                                    <h5 class="fw-bold text-dark">Chưa có câu hỏi nào trong ngân hàng!</h5>
                                    <p class="small text-muted mb-3">Tạo các câu hỏi trắc nghiệm để tái sử dụng và gán vào các bài thi của khóa học.</p>
                                    <button type="button" class="btn btn-primary fw-semibold btn-sm" onclick="openCreateQuestionModal('')" data-bs-toggle="modal" data-bs-target="#questionModal">
                                        <i class="bi bi-plus-lg me-1"></i>Tạo câu hỏi đầu tiên
                                    </button>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0" id="questionsTable">
                                        <thead class="table-light">
                                            <tr>
                                                <th style="width: 70px;" class="ps-3">ID</th>
                                                <th>Nội dung câu hỏi &amp; Đáp án</th>
                                                <th style="width: 180px;">Chương học</th>
                                                <th style="width: 140px;" class="text-center">Loại câu hỏi</th>
                                                <th style="width: 90px;" class="text-center">Điểm</th>
                                                <th style="width: 90px;" class="text-end pe-3">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="q" items="${courseQuestions}">
                                                <tr class="question-row" data-module-id="${q.moduleId}" data-text="${fn:toLowerCase(q.questionText)}">
                                                    <td class="ps-3 text-muted fw-semibold">#${q.id}</td>
                                                    <td>
                                                        <h6 class="fw-bold text-dark mb-2">${q.questionText}</h6>
                                                        <div class="d-flex flex-wrap gap-1">
                                                            <c:forEach var="opt" items="${q.options}">
                                                                <span class="badge ${opt.correct ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-light text-dark border'} p-1.5 small fw-normal">
                                                                    <i class="bi ${opt.correct ? 'bi-check-circle-fill text-success' : 'bi-circle text-muted'} me-1"></i>
                                                                    ${opt.optionText}
                                                                </span>
                                                            </c:forEach>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-light text-dark border text-truncate d-inline-block" style="max-width: 170px;">
                                                            ${q.moduleTitle}
                                                        </span>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                                                            <c:choose>
                                                                <c:when test="${q.questionType == 'TRUE_FALSE'}">Đúng / Sai</c:when>
                                                                <c:otherwise>1 Đáp án</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td class="text-center fw-semibold text-secondary">${q.defaultPoints} đ</td>
                                                    <td class="text-end pe-3 text-nowrap">
                                                        <a href="${pageContext.request.contextPath}/quizzes/delete-question?id=${q.id}&courseId=${course.id}" 
                                                           class="btn btn-sm btn-outline-danger"
                                                           onclick="return confirm('Bạn có chắc chắn muốn xóa câu hỏi này khỏi ngân hàng câu hỏi?');"
                                                           title="Xóa câu hỏi">
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

        </div>
    </div>
</main>

<!-- Modal: Tạo mới & Chỉnh sửa Quiz Đồng bộ -->
<div class="modal fade" id="quizModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form id="quizForm" action="${pageContext.request.contextPath}/quizzes/save" method="POST">
                <input type="hidden" name="id" id="modalQuizId" value="">
                <c:if test="${not empty course}">
                    <input type="hidden" name="courseId" value="${course.id}">
                </c:if>

                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="quizModalLabel">Tạo bài kiểm tra mới (Quiz)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Thuộc chương học <span class="text-danger">*</span></label>
                        <select name="moduleId" id="modalModuleSelect" class="form-select" required>
                            <c:forEach var="m" items="${course.modules}">
                                <option value="${m.id}">Chương ${m.orderIndex}: ${m.title}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên bài kiểm tra <span class="text-danger">*</span></label>
                        <input type="text" name="title" id="modalQuizTitle" class="form-control" placeholder="Nhập tên bài Quiz..." required>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Điểm đạt tối thiểu (%)</label>
                            <div class="input-group">
                                <input type="number" name="passScore" id="modalQuizPassScore" class="form-control" value="50" min="0" max="100" required>
                                <span class="input-group-text bg-light text-muted">%</span>
                            </div>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Thời lượng (Phút)</label>
                            <div class="input-group">
                                <input type="number" name="timeLimitMinutes" id="modalQuizTimeLimit" class="form-control" value="15" min="1">
                                <span class="input-group-text bg-light text-muted">phút</span>
                            </div>
                        </div>
                    </div>

                    <div class="mb-2">
                        <label class="form-label small fw-semibold">Thứ tự hiển thị <span class="text-danger">*</span></label>
                        <input type="number" name="orderIndex" id="modalQuizOrderIndex" class="form-control" value="1" min="1" required>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold shadow-sm" id="submitQuizBtn">Lưu bài thi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Xác nhận xóa Quiz -->
<div class="modal fade" id="deleteQuizModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow">
            <div class="modal-body text-center p-4">
                <i class="bi bi-trash text-danger display-4 d-block mb-3"></i>
                <h5 class="fw-bold mb-1">Xác nhận xóa bài thi?</h5>
                <p class="small text-muted mb-4" id="deleteQuizTitle">Thao tác này sẽ xóa bài kiểm tra khỏi khóa học.</p>
                <div class="d-flex justify-content-center gap-2">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <a href="#" id="confirmDeleteLink" class="btn btn-danger fw-semibold">Xóa bài thi</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Thêm câu hỏi mới vào Ngân hàng của Khóa học -->
<div class="modal fade" id="questionModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/quizzes/save-question" method="POST">
                <input type="hidden" name="id" id="modalQId" value="">
                <c:if test="${not empty course}">
                    <input type="hidden" name="courseId" value="${course.id}">
                </c:if>

                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Tạo câu hỏi mới vào Ngân hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Thuộc chương học <span class="text-danger">*</span></label>
                        <select name="moduleId" id="modalQModuleSelect" class="form-select" required>
                            <c:forEach var="m" items="${course.modules}">
                                <option value="${m.id}">Chương ${m.orderIndex}: ${m.title}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Nội dung câu hỏi <span class="text-danger">*</span></label>
                        <textarea name="questionText" id="modalQText" rows="3" class="form-control" required placeholder="Nhập nội dung câu hỏi trắc nghiệm..."></textarea>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Loại câu hỏi</label>
                            <select name="questionType" id="modalQType" class="form-select">
                                <option value="SINGLE_CHOICE" selected>Trắc nghiệm 1 đáp án</option>
                                <option value="TRUE_FALSE">Đúng / Sai</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Điểm mặc định</label>
                            <div class="input-group">
                                <input type="number" step="0.5" min="0.5" name="defaultPoints" id="modalQPoints" value="1.0" class="form-control" required>
                                <span class="input-group-text bg-light text-muted">điểm</span>
                            </div>
                        </div>
                    </div>

                    <label class="form-label small fw-semibold text-primary mb-2">
                        <i class="bi bi-ui-radios me-1"></i>Các phương án trả lời (Tích chọn radio đáp án đúng):
                    </label>

                    <div class="mb-2 input-group">
                        <div class="input-group-text bg-white">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="0" checked title="Chọn làm đáp án đúng">
                        </div>
                        <span class="input-group-text bg-light fw-bold text-primary">A</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Đáp án A..." required>
                    </div>

                    <div class="mb-2 input-group">
                        <div class="input-group-text bg-white">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="1" title="Chọn làm đáp án đúng">
                        </div>
                        <span class="input-group-text bg-light fw-bold text-primary">B</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Đáp án B..." required>
                    </div>

                    <div class="mb-2 input-group">
                        <div class="input-group-text bg-white">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="2" title="Chọn làm đáp án đúng">
                        </div>
                        <span class="input-group-text bg-light fw-bold text-primary">C</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Đáp án C (tùy chọn)...">
                    </div>

                    <div class="mb-3 input-group">
                        <div class="input-group-text bg-white">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="3" title="Chọn làm đáp án đúng">
                        </div>
                        <span class="input-group-text bg-light fw-bold text-primary">D</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Đáp án D (tùy chọn)...">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success fw-semibold shadow-sm">Lưu vào ngân hàng</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Kích hoạt tab nếu có query param ?tab=questions
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('tab') === 'questions') {
            const questionsTabBtn = document.getElementById('pills-questions-tab');
            if (questionsTabBtn) {
                bootstrap.Tab.getOrCreateInstance(questionsTabBtn).show();
            }
        }

        // Live search & Module filter cho Tab Ngân hàng câu hỏi
        const qSearch = document.getElementById('questionSearchInput');
        const qModFilter = document.getElementById('questionModuleFilter');
        if (qSearch && qModFilter) {
            function filterQuestions() {
                const kw = qSearch.value.trim().toLowerCase();
                const modId = qModFilter.value;
                const rows = document.querySelectorAll('.question-row');
                rows.forEach(function (row) {
                    const rowText = row.getAttribute('data-text') || '';
                    const rowMod = row.getAttribute('data-module-id') || '';
                    const matchKw = (kw === '' || rowText.includes(kw));
                    const matchMod = (modId === 'all' || modId === rowMod);
                    row.classList.toggle('d-none', !(matchKw && matchMod));
                });
            }
            qSearch.addEventListener('input', filterQuestions);
            qModFilter.addEventListener('change', filterQuestions);
        }
    });

    function openCreateQuizModal(moduleId) {
        const idInput = document.getElementById('modalQuizId');
        if (idInput) idInput.value = '';
        const titleLabel = document.getElementById('quizModalLabel');
        if (titleLabel) titleLabel.textContent = 'Tạo bài kiểm tra mới (Quiz)';
        const titleInput = document.getElementById('modalQuizTitle');
        if (titleInput) titleInput.value = '';
        const passScoreInput = document.getElementById('modalQuizPassScore');
        if (passScoreInput) passScoreInput.value = '50';
        const timeLimitInput = document.getElementById('modalQuizTimeLimit');
        if (timeLimitInput) timeLimitInput.value = '15';
        const orderInput = document.getElementById('modalQuizOrderIndex');
        if (orderInput) orderInput.value = '1';
        if (moduleId) {
            const modSelect = document.getElementById('modalModuleSelect');
            if (modSelect) modSelect.value = moduleId;
        }
        const modalEl = document.getElementById('quizModal');
        if (modalEl) {
            bootstrap.Modal.getOrCreateInstance(modalEl).show();
        }
    }

    function openEditQuizModal(id, moduleId, title, passScore, timeLimit, orderIndex) {
        const idInput = document.getElementById('modalQuizId');
        if (idInput) idInput.value = id;
        const titleLabel = document.getElementById('quizModalLabel');
        if (titleLabel) titleLabel.textContent = 'Cập nhật bài kiểm tra #' + id;
        const titleInput = document.getElementById('modalQuizTitle');
        if (titleInput) titleInput.value = title || '';
        const passScoreInput = document.getElementById('modalQuizPassScore');
        if (passScoreInput) passScoreInput.value = passScore || '50';
        const timeLimitInput = document.getElementById('modalQuizTimeLimit');
        if (timeLimitInput) timeLimitInput.value = timeLimit || '';
        const orderInput = document.getElementById('modalQuizOrderIndex');
        if (orderInput) orderInput.value = orderIndex || '1';
        if (moduleId) {
            const modSelect = document.getElementById('modalModuleSelect');
            if (modSelect) modSelect.value = moduleId;
        }
        const modalEl = document.getElementById('quizModal');
        if (modalEl) {
            bootstrap.Modal.getOrCreateInstance(modalEl).show();
        }
    }

    function openDeleteQuizModal(id, title, courseId, moduleId) {
        const titleEl = document.getElementById('deleteQuizTitle');
        if (titleEl) titleEl.textContent = 'Bạn có chắc chắn muốn xóa bài thi "' + title + '"?';
        let deleteUrl = '${pageContext.request.contextPath}/quizzes/delete?id=' + id;
        if (courseId) deleteUrl += '&courseId=' + courseId;
        if (moduleId) deleteUrl += '&moduleId=' + moduleId;
        const link = document.getElementById('confirmDeleteLink');
        if (link) link.href = deleteUrl;
        const modalEl = document.getElementById('deleteQuizModal');
        if (modalEl) {
            bootstrap.Modal.getOrCreateInstance(modalEl).show();
        }
    }

    function openCreateQuestionModal(moduleId) {
        const qId = document.getElementById('modalQId');
        if (qId) qId.value = '';
        const qText = document.getElementById('modalQText');
        if (qText) qText.value = '';
        const qPoints = document.getElementById('modalQPoints');
        if (qPoints) qPoints.value = '1.0';
        if (moduleId) {
            const modSelect = document.getElementById('modalQModuleSelect');
            if (modSelect) modSelect.value = moduleId;
        }
        const modalEl = document.getElementById('questionModal');
        if (modalEl) {
            bootstrap.Modal.getOrCreateInstance(modalEl).show();
        }
    }
</script>
