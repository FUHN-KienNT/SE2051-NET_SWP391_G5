<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="${quiz.title} - Chi tiết bài thi - Courson LMS" />
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
                        <a href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}" class="text-decoration-none">
                            ${course.title}
                        </a>
                    </li>
                </c:if>
                <li class="breadcrumb-item active" aria-current="page">
                    ${quiz.title}
                </li>
            </ol>
        </nav>

        <!-- System Alerts Đồng bộ -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'saved'}">
                        Đã lưu và cập nhật cấu hình bài kiểm tra thành công!
                    </c:when>
                    <c:when test="${param.success == 'assigned'}">
                        Đã thêm câu hỏi vào bài kiểm tra!
                    </c:when>
                    <c:when test="${param.success == 'removed'}">
                        Đã gỡ câu hỏi khỏi bài kiểm tra (câu hỏi vẫn nằm trong Ngân hàng câu hỏi).
                    </c:when>
                    <c:when test="${param.success == 'question_created_and_assigned'}">
                        Đã tạo câu hỏi mới và tự động gán vào bài kiểm tra!
                    </c:when>
                    <c:otherwise>Thao tác đã được hoàn tất thành công.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${param.error}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Header Top Bar Đồng bộ Dashboard, Lesson List, Quiz List -->
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <c:if test="${not empty currentModule}">
                        <span class="badge bg-light text-dark border fw-semibold">Chương ${currentModule.orderIndex}: ${currentModule.title}</span>
                    </c:if>
                    <h3 class="fw-bold mb-0">
                        <i class="bi bi-patch-question-fill text-primary me-2"></i>${quiz.title}
                    </h3>
                </div>
                <p class="text-muted small mb-0">
                    Quản lý cấu hình bài thi, thiết lập câu hỏi và phân bổ điểm số (Màn hình II.5.2)
                </p>
            </div>
            <div class="d-flex gap-2">
                <c:url var="backQuizListUrl" value="/quizzes/list">
                    <c:if test="${not empty courseId}"><c:param name="courseId" value="${courseId}"/></c:if>
                </c:url>
                <a href="${backQuizListUrl}" class="btn btn-outline-secondary fw-semibold">
                    <i class="bi bi-arrow-left me-1"></i>Danh sách Quiz
                </a>
                <button type="button" class="btn btn-primary fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#pickFromBankModal">
                    <i class="bi bi-plus-circle me-1"></i>Thêm từ Ngân hàng
                </button>
                <button type="button" class="btn btn-success fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                    <i class="bi bi-patch-plus-fill me-1"></i>Tạo câu hỏi mới
                </button>
            </div>
        </div>

        <!-- 4 KPI Stat Cards Đồng bộ Dashboard -->
        <div class="row g-3 mb-4">
            <!-- Total Questions -->
            <div class="col-sm-6 col-lg-3">
                <div class="card border-0 shadow-sm rounded-3 p-3 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small fw-semibold">Tổng số câu hỏi</div>
                            <h3 class="fw-bold mb-0 mt-1">
                                ${not empty quiz.questions ? fn:length(quiz.questions) : 0} <span class="fs-6 fw-normal text-muted">câu</span>
                            </h3>
                        </div>
                        <div class="bg-primary-subtle text-primary p-3 rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                            <i class="bi bi-question-diamond fs-4"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Total Points -->
            <div class="col-sm-6 col-lg-3">
                <div class="card border-0 shadow-sm rounded-3 p-3 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small fw-semibold">Tổng điểm bài thi</div>
                            <h3 class="fw-bold mb-0 mt-1">
                                ${quiz.totalPoints} <span class="fs-6 fw-normal text-muted">điểm</span>
                            </h3>
                        </div>
                        <div class="bg-success-subtle text-success p-3 rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                            <i class="bi bi-award fs-4"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Passing Score -->
            <div class="col-sm-6 col-lg-3">
                <div class="card border-0 shadow-sm rounded-3 p-3 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small fw-semibold">Điểm đạt tối thiểu</div>
                            <h3 class="fw-bold mb-0 mt-1">
                                ${quiz.passScore}% <span class="fs-6 fw-normal text-muted">(${quiz.passingPoints} đ)</span>
                            </h3>
                        </div>
                        <div class="bg-warning-subtle text-warning p-3 rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                            <i class="bi bi-shield-check fs-4"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Time Limit -->
            <div class="col-sm-6 col-lg-3">
                <div class="card border-0 shadow-sm rounded-3 p-3 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small fw-semibold">Thời lượng thi</div>
                            <h3 class="fw-bold mb-0 mt-1">
                                <c:choose>
                                    <c:when test="${not empty quiz.timeLimitMinutes && quiz.timeLimitMinutes > 0}">
                                        ${quiz.timeLimitMinutes} <span class="fs-6 fw-normal text-muted">phút</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="fs-6 fw-semibold text-secondary">Tự do</span>
                                    </c:otherwise>
                                </c:choose>
                            </h3>
                        </div>
                        <div class="bg-info-subtle text-info p-3 rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                            <i class="bi bi-stopwatch fs-4"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Area: 2 Columns -->
        <div class="row g-4">
            <!-- Left Column: Quiz Setting Form & Actions (col-lg-4) -->
            <div class="col-lg-4">
                <!-- Config Card -->
                <div class="card border-0 shadow-sm rounded-3 p-4 mb-4">
                    <div class="d-flex align-items-center mb-3">
                        <div class="bg-primary-subtle text-primary p-2 rounded-circle me-2 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                            <i class="bi bi-gear-fill"></i>
                        </div>
                        <h5 class="fw-bold mb-0 text-dark">Cấu hình bài thi</h5>
                    </div>

                    <form action="${pageContext.request.contextPath}/quizzes/save" method="POST">
                        <input type="hidden" name="id" value="${quiz.id}">
                        <input type="hidden" name="moduleId" value="${quiz.moduleId}">
                        <c:if test="${not empty courseId}">
                            <input type="hidden" name="courseId" value="${courseId}">
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Tên bài thi <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control" value="${quiz.title}" required placeholder="Nhập tên bài thi...">
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Tỉ lệ đạt tối thiểu (%) <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="number" name="passScore" class="form-control" value="${quiz.passScore}" min="0" max="100" required>
                                <span class="input-group-text bg-light text-muted">%</span>
                            </div>
                            <div class="form-text small">Học viên cần đạt từ ${quiz.passScore}% số điểm để qua bài thi.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Thời lượng thi (Phút)</label>
                            <div class="input-group">
                                <input type="number" name="timeLimitMinutes" class="form-control" value="${quiz.timeLimitMinutes}" placeholder="Để trống nếu không giới hạn">
                                <span class="input-group-text bg-light text-muted">phút</span>
                            </div>
                            <div class="form-text small">Để trống hoặc nhập 0 nếu không giới hạn thời gian.</div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-semibold">Thứ tự hiển thị <span class="text-danger">*</span></label>
                            <input type="number" name="orderIndex" class="form-control" value="${quiz.orderIndex}" min="1" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-semibold shadow-sm">
                            <i class="bi bi-save me-1"></i>Lưu cấu hình bài thi
                        </button>
                    </form>
                </div>

                <!-- Info Card -->
                <div class="card border-0 shadow-sm rounded-3 p-4 mb-4">
                    <h6 class="fw-bold mb-3 text-secondary text-uppercase small">
                        <i class="bi bi-info-circle me-1"></i>Thông tin liên kết
                    </h6>
                    <ul class="list-unstyled mb-0 small">
                        <li class="d-flex justify-content-between py-2 border-bottom">
                            <span class="text-muted">Mã Quiz ID:</span>
                            <span class="fw-semibold">#${quiz.id}</span>
                        </li>
                        <c:if test="${not empty currentModule}">
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Chương học:</span>
                                <span class="fw-semibold text-end">${currentModule.title}</span>
                            </li>
                        </c:if>
                        <c:if test="${not empty course}">
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Khóa học:</span>
                                <span class="fw-semibold text-end">${course.title}</span>
                            </li>
                        </c:if>
                        <li class="d-flex justify-content-between py-2">
                            <span class="text-muted">Ngân hàng câu hỏi:</span>
                            <span class="fw-semibold text-primary">
                                ${not empty bankQuestions ? fn:length(bankQuestions) : 0} câu hỏi có sẵn
                            </span>
                        </li>
                    </ul>

                    <div class="d-grid gap-2 mt-4 pt-2 border-top">
                        <c:url var="courseQuestionsUrl" value="/quizzes/list">
                            <c:if test="${not empty courseId}">
                                <c:param name="courseId" value="${courseId}"/>
                            </c:if>
                            <c:param name="tab" value="questions"/>
                        </c:url>
                        <a href="${courseQuestionsUrl}" class="btn btn-outline-primary btn-sm fw-semibold">
                            <i class="bi bi-database me-1"></i>Xem Ngân hàng câu hỏi khóa học
                        </a>

                        <button type="button" class="btn btn-outline-danger btn-sm fw-semibold" 
                                data-bs-toggle="modal" data-bs-target="#deleteQuizModal">
                            <i class="bi bi-trash me-1"></i>Xóa bài thi này
                        </button>
                    </div>
                </div>
            </div>

            <!-- Right Column: Quiz Questions Management (col-lg-8) -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                    <!-- Card Header -->
                    <div class="card-header bg-white py-3 px-4 d-flex flex-wrap justify-content-between align-items-center gap-2 border-bottom">
                        <div>
                            <h5 class="fw-bold mb-0 text-dark">
                                <i class="bi bi-list-check text-primary me-2"></i>Danh sách câu hỏi trong bài thi
                            </h5>
                            <small class="text-muted">
                                Tổng cộng: <strong>${not empty quiz.questions ? fn:length(quiz.questions) : 0}</strong> câu hỏi | Điểm tối đa: <strong>${quiz.totalPoints}</strong> đ
                            </small>
                        </div>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-primary btn-sm fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#pickFromBankModal">
                                <i class="bi bi-plus-circle me-1"></i>Thêm từ Ngân hàng
                            </button>
                            <button type="button" class="btn btn-success btn-sm fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                                <i class="bi bi-patch-plus-fill me-1"></i>Tạo câu hỏi mới
                            </button>
                        </div>
                    </div>

                    <!-- Questions List Body -->
                    <div class="card-body p-4">
                        <c:choose>
                            <c:when test="${empty quiz.questions}">
                                <!-- Empty state -->
                                <div class="text-center py-5">
                                    <i class="bi bi-patch-question display-4 text-muted mb-3 d-block"></i>
                                    <h5 class="fw-bold text-dark mb-1">Bài thi này chưa có câu hỏi nào</h5>
                                    <p class="text-muted small mb-4 mx-auto" style="max-width: 450px;">
                                        Học viên sẽ không thể làm bài nếu bài thi trống. Hãy thêm câu hỏi từ Ngân hàng câu hỏi có sẵn hoặc tạo câu hỏi mới ngay.
                                    </p>
                                    <div class="d-flex justify-content-center gap-2">
                                        <button type="button" class="btn btn-primary fw-semibold" data-bs-toggle="modal" data-bs-target="#pickFromBankModal">
                                            <i class="bi bi-plus-circle me-1"></i>Chọn từ Ngân hàng
                                        </button>
                                        <button type="button" class="btn btn-outline-secondary fw-semibold" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                                            <i class="bi bi-pencil-square me-1"></i>Tạo câu hỏi mới
                                        </button>
                                    </div>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="d-flex flex-column gap-3">
                                    <c:forEach var="qq" items="${quiz.questions}" varStatus="status">
                                        <div class="card border rounded-3 p-3 shadow-none bg-white">
                                            <div class="d-flex justify-content-between align-items-start gap-2 mb-2">
                                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                                    <span class="badge bg-light text-dark border fw-semibold">
                                                        Câu #${status.index + 1}
                                                    </span>
                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                                        <c:choose>
                                                            <c:when test="${qq.questionType == 'SINGLE_CHOICE'}">1 Đáp án</c:when>
                                                            <c:when test="${qq.questionType == 'MULTI_CHOICE'}">Nhiều đáp án</c:when>
                                                            <c:when test="${qq.questionType == 'TRUE_FALSE'}">Đúng / Sai</c:when>
                                                            <c:otherwise>${qq.questionType}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle fw-bold">
                                                        <i class="bi bi-star-fill text-warning me-1"></i>
                                                        ${not empty qq.assignedPoints ? qq.assignedPoints : (not empty qq.points ? qq.points : qq.defaultPoints)} điểm
                                                    </span>
                                                </div>

                                                <!-- Action Buttons -->
                                                <div class="d-flex align-items-center gap-2">
                                                    <!-- Edit Points Modal Trigger -->
                                                    <button type="button" class="btn btn-sm btn-outline-secondary" 
                                                            onclick="openEditPointsModal('${qq.id}', '${qq.quizOrderIndex}', '${not empty qq.assignedPoints ? qq.assignedPoints : (not empty qq.points ? qq.points : qq.defaultPoints)}', '${fn:escapeXml(qq.questionText)}')"
                                                            title="Đổi điểm câu hỏi">
                                                        <i class="bi bi-pencil-fill me-1"></i>Sửa điểm
                                                    </button>

                                                    <!-- Remove Question Link -->
                                                    <c:url var="removeUrl" value="/quizzes/remove-question">
                                                        <c:param name="quizId" value="${quiz.id}"/>
                                                        <c:param name="questionId" value="${qq.id}"/>
                                                        <c:if test="${not empty courseId}">
                                                            <c:param name="courseId" value="${courseId}"/>
                                                        </c:if>
                                                    </c:url>
                                                    <a href="${removeUrl}" class="btn btn-sm btn-outline-danger" 
                                                       onclick="return confirm('Bạn có chắc muốn gỡ câu hỏi này khỏi bài thi? (Câu hỏi vẫn được giữ nguyên trong Ngân hàng)');"
                                                       title="Gỡ câu hỏi khỏi bài thi">
                                                        <i class="bi bi-trash"></i> Gỡ
                                                    </a>
                                                </div>
                                            </div>

                                            <!-- Question Text -->
                                            <h6 class="fw-bold text-dark mb-2">
                                                <c:out value="${qq.questionText}" />
                                            </h6>

                                            <!-- Question Options (Answers) -->
                                            <c:if test="${not empty qq.options}">
                                                <div class="row g-2 pt-2 border-top">
                                                    <c:forEach var="opt" items="${qq.options}">
                                                        <div class="col-md-6">
                                                            <div class="p-2 rounded-3 border ${opt.correct ? 'bg-success-subtle border-success-subtle text-success fw-semibold' : 'bg-light border text-dark'} d-flex align-items-center justify-content-between small">
                                                                <div class="d-flex align-items-center overflow-hidden">
                                                                    <i class="bi ${opt.correct ? 'bi-check-circle-fill text-success' : 'bi-circle text-muted'} me-2 flex-shrink-0"></i>
                                                                    <span class="text-truncate">
                                                                        <c:out value="${opt.optionText}" />
                                                                    </span>
                                                                </div>
                                                                <c:if test="${opt.correct}">
                                                                    <span class="badge bg-success text-white ms-2 flex-shrink-0">
                                                                        Đúng
                                                                    </span>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Modal 1: Pick Questions from Module Question Bank -->
<div class="modal fade" id="pickFromBankModal" tabindex="-1" aria-labelledby="pickFromBankModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0 shadow rounded-3">
            <div class="modal-header py-3">
                <div>
                    <h5 class="modal-title fw-bold text-dark" id="pickFromBankModalLabel">
                        <i class="bi bi-bank text-primary me-2"></i>Ngân hàng câu hỏi của chương
                    </h5>
                    <small class="text-muted">Chọn các câu hỏi để gán vào bài thi "${quiz.title}"</small>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-4">
                <c:choose>
                    <c:when test="${empty bankQuestions}">
                        <div class="text-center py-5">
                            <i class="bi bi-inbox text-muted display-4 d-block mb-3"></i>
                            <h6 class="fw-bold text-dark">Ngân hàng câu hỏi của chương này đang trống</h6>
                            <p class="text-muted small mb-3">
                                Chưa có câu hỏi nào được lưu trữ trong ngân hàng của chương học này.
                            </p>
                            <button type="button" class="btn btn-primary btn-sm fw-semibold" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                                <i class="bi bi-plus-lg me-1"></i>Tạo câu hỏi mới ngay
                            </button>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <p class="small text-muted mb-3">
                            Tìm thấy <strong>${fn:length(bankQuestions)}</strong> câu hỏi trong ngân hàng của chương này.
                        </p>

                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="bq" items="${bankQuestions}" varStatus="bStatus">
                                <c:set var="isAlreadyAssigned" value="${assignedQuestionIds.contains(bq.id)}" />
                                <div class="card border rounded-3 p-3 ${isAlreadyAssigned ? 'bg-light opacity-75' : 'bg-white shadow-none'}">
                                    <div class="d-flex justify-content-between align-items-start gap-2 mb-2">
                                        <div class="d-flex align-items-center gap-2 flex-wrap">
                                            <span class="badge bg-light text-dark border">
                                                #${bStatus.index + 1}
                                            </span>
                                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                                <c:choose>
                                                    <c:when test="${bq.questionType == 'SINGLE_CHOICE'}">1 Đáp án</c:when>
                                                    <c:when test="${bq.questionType == 'MULTI_CHOICE'}">Nhiều đáp án</c:when>
                                                    <c:when test="${bq.questionType == 'TRUE_FALSE'}">Đúng / Sai</c:when>
                                                    <c:otherwise>${bq.questionType}</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="badge bg-success-subtle text-success border border-success-subtle">
                                                Mặc định: ${bq.defaultPoints} đ
                                            </span>
                                        </div>

                                        <!-- Assign Action Button / Badge -->
                                        <div>
                                            <c:choose>
                                                <c:when test="${isAlreadyAssigned}">
                                                    <span class="badge bg-secondary-subtle text-secondary border px-2.5 py-1.5">
                                                        <i class="bi bi-check2 me-1"></i>Đã trong bài thi
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${pageContext.request.contextPath}/quizzes/assign-question" method="POST" class="d-inline">
                                                        <input type="hidden" name="quizId" value="${quiz.id}">
                                                        <input type="hidden" name="questionId" value="${bq.id}">
                                                        <input type="hidden" name="points" value="${bq.defaultPoints}">
                                                        <c:if test="${not empty courseId}">
                                                            <input type="hidden" name="courseId" value="${courseId}">
                                                        </c:if>
                                                        <button type="submit" class="btn btn-sm btn-primary fw-semibold shadow-sm">
                                                            <i class="bi bi-plus-lg me-1"></i>Thêm vào Quiz
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <h6 class="fw-semibold text-dark mb-2">
                                        <c:out value="${bq.questionText}" />
                                    </h6>

                                    <!-- Options preview -->
                                    <div class="row g-2 pt-1">
                                        <c:forEach var="bOpt" items="${bq.options}">
                                            <div class="col-md-6">
                                                <div class="small p-1.5 rounded border ${bOpt.correct ? 'bg-success-subtle border-success-subtle text-success fw-semibold' : 'bg-light text-muted'}">
                                                    <i class="bi ${bOpt.correct ? 'bi-check-circle-fill' : 'bi-circle'} me-1"></i>
                                                    <c:out value="${bOpt.optionText}" />
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="modal-footer py-2 bg-light">
                <button type="button" class="btn btn-secondary btn-sm fw-semibold" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal 2: Create New Question directly and auto assign to Quiz -->
<div class="modal fade" id="newQuestionModal" tabindex="-1" aria-labelledby="newQuestionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow rounded-3">
            <form action="${pageContext.request.contextPath}/quizzes/save-question" method="POST">
                <input type="hidden" name="moduleId" value="${quiz.moduleId}">
                <input type="hidden" name="quizId" value="${quiz.id}">
                <c:if test="${not empty courseId}">
                    <input type="hidden" name="courseId" value="${courseId}">
                </c:if>

                <div class="modal-header py-3">
                    <div>
                        <h5 class="modal-title fw-bold text-dark" id="newQuestionModalLabel">
                            <i class="bi bi-pencil-square text-primary me-2"></i>Tạo câu hỏi mới và thêm vào bài thi
                        </h5>
                        <small class="text-muted">Câu hỏi sẽ được lưu vào ngân hàng của chương và tự động gán vào bài thi này</small>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Nội dung câu hỏi <span class="text-danger">*</span></label>
                        <textarea name="questionText" rows="3" class="form-control" required placeholder="Nhập nội dung câu hỏi trắc nghiệm ở đây..."></textarea>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Loại câu hỏi</label>
                            <select name="questionType" class="form-select">
                                <option value="SINGLE_CHOICE" selected>Trắc nghiệm 1 đáp án (Single Choice)</option>
                                <option value="TRUE_FALSE">Đúng / Sai (True / False)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Điểm số của câu hỏi</label>
                            <div class="input-group">
                                <input type="number" step="0.5" min="0.5" name="defaultPoints" value="1.0" class="form-control" required>
                                <span class="input-group-text bg-light text-muted">điểm</span>
                            </div>
                        </div>
                    </div>

                    <label class="form-label small fw-semibold text-primary mb-2">
                        <i class="bi bi-ui-radios me-1"></i>Các phương án trả lời (Tích chọn radio để chỉ định đáp án đúng):
                    </label>

                    <div class="mb-2 input-group shadow-sm">
                        <div class="input-group-text bg-white">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="0" checked title="Chọn làm đáp án đúng">
                        </div>
                        <span class="input-group-text bg-light fw-bold text-primary">A</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Nhập nội dung đáp án A..." required>
                    </div>

                    <div class="mb-2 input-group shadow-sm">
                        <div class="input-group-text bg-white">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="1" title="Chọn làm đáp án đúng">
                        </div>
                        <span class="input-group-text bg-light fw-bold text-primary">B</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Nhập nội dung đáp án B..." required>
                    </div>

                    <div class="mb-2 input-group shadow-sm">
                        <div class="input-group-text bg-white">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="2" title="Chọn làm đáp án đúng">
                        </div>
                        <span class="input-group-text bg-light fw-bold text-primary">C</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Nhập nội dung đáp án C (tùy chọn)...">
                    </div>

                    <div class="mb-3 input-group shadow-sm">
                        <div class="input-group-text bg-white">
                            <input class="form-check-input mt-0" type="radio" name="correctOption" value="3" title="Chọn làm đáp án đúng">
                        </div>
                        <span class="input-group-text bg-light fw-bold text-primary">D</span>
                        <input type="text" name="optionText" class="form-control" placeholder="Nhập nội dung đáp án D (tùy chọn)...">
                    </div>
                </div>

                <div class="modal-footer py-2 bg-light">
                    <button type="button" class="btn btn-secondary btn-sm fw-semibold" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary btn-sm fw-semibold shadow-sm">
                        <i class="bi bi-save me-1"></i>Tạo và gán vào Quiz
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal 3: Reusable Edit Points Modal (Duy nhất 1 modal, không lặp HTML) -->
<div class="modal fade" id="editPointsModal" tabindex="-1" aria-labelledby="editPointsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow rounded-3">
            <form action="${pageContext.request.contextPath}/quizzes/assign-question" method="POST">
                <input type="hidden" name="quizId" value="${quiz.id}">
                <input type="hidden" name="questionId" id="editModalQuestionId" value="">
                <c:if test="${not empty courseId}">
                    <input type="hidden" name="courseId" value="${courseId}">
                </c:if>
                <input type="hidden" name="order" id="editModalOrder" value="0">

                <div class="modal-header py-3">
                    <h6 class="modal-title fw-bold text-dark" id="editPointsModalLabel">
                        <i class="bi bi-pencil-square text-primary me-1"></i>Cập nhật điểm câu hỏi
                    </h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body py-3">
                    <p class="small text-muted mb-2 text-truncate" id="editModalQuestionText"></p>
                    <label class="form-label small fw-semibold">Điểm số trong bài thi</label>
                    <div class="input-group">
                        <input type="number" step="0.5" min="0.5" name="points" id="editModalPoints" class="form-control" required>
                        <span class="input-group-text bg-light text-muted">điểm</span>
                    </div>
                </div>
                <div class="modal-footer py-2 bg-light">
                    <button type="button" class="btn btn-secondary btn-sm fw-semibold" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary btn-sm fw-semibold">Lưu điểm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal 4: Delete Quiz Confirmation -->
<div class="modal fade" id="deleteQuizModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow rounded-3">
            <div class="modal-body text-center p-4">
                <div class="bg-danger-subtle text-danger rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 56px; height: 56px; font-size: 1.6rem;">
                    <i class="bi bi-trash"></i>
                </div>
                <h5 class="fw-bold text-dark mb-1">Xác nhận xóa bài thi?</h5>
                <p class="small text-muted mb-4">
                    Thao tác này sẽ xóa vĩnh viễn bài thi <strong>"${quiz.title}"</strong>. Các câu hỏi trong ngân hàng vẫn được giữ nguyên.
                </p>
                <div class="d-flex justify-content-center gap-2">
                    <button type="button" class="btn btn-secondary btn-sm fw-semibold" data-bs-dismiss="modal">Hủy</button>
                    <c:url var="deleteQuizUrl" value="/quizzes/delete">
                        <c:param name="id" value="${quiz.id}"/>
                        <c:if test="${not empty courseId}">
                            <c:param name="courseId" value="${courseId}"/>
                        </c:if>
                        <c:if test="${empty courseId}">
                            <c:param name="moduleId" value="${quiz.moduleId}"/>
                        </c:if>
                    </c:url>
                    <a href="${deleteQuizUrl}" class="btn btn-danger btn-sm fw-semibold">
                        Xóa bài thi
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function openEditPointsModal(questionId, order, points, questionText) {
        document.getElementById('editModalQuestionId').value = questionId;
        document.getElementById('editModalOrder').value = order || 0;
        document.getElementById('editModalPoints').value = points;
        document.getElementById('editModalQuestionText').textContent = questionText;
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('editPointsModal'));
        modal.show();
    }
</script>

<jsp:include page="../common/footer.jsp" />
