<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="${quiz.title} - Chi tiết bài thi - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
        --accent-gradient: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
        --surface-subtle: #f8fafc;
        --border-color: #e2e8f0;
    }

    /* Hero Banner */
    .quiz-hero-card {
        background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
        border: 1px solid var(--border-color);
        border-radius: 18px;
        box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
    }

    /* KPI Cards */
    .kpi-card {
        background: #ffffff;
        border: 1px solid var(--border-color);
        border-radius: 16px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    }
    .kpi-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 20px -4px rgba(0, 0, 0, 0.08);
        border-color: #cbd5e1;
    }
    .kpi-icon-wrapper {
        width: 48px;
        height: 48px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 12px;
        font-size: 1.4rem;
    }

    /* Question Item Card */
    .question-card {
        background: #ffffff;
        border: 1px solid var(--border-color);
        border-radius: 14px;
        transition: all 0.2s ease-in-out;
    }
    .question-card:hover {
        border-color: #93c5fd;
        box-shadow: 0 6px 16px rgba(59, 130, 246, 0.08);
    }

    .option-pill {
        border-radius: 10px;
        padding: 0.6rem 0.85rem;
        transition: all 0.15s ease;
    }
    .option-pill.correct {
        background-color: #ecfdf5;
        border: 1px solid #10b981;
        color: #065f46;
    }
    .option-pill.regular {
        background-color: #f8fafc;
        border: 1px solid #e2e8f0;
        color: #334155;
    }

    .badge-soft-primary {
        background-color: #eff6ff;
        color: #1d4ed8;
        border: 1px solid #bfdbfe;
    }
    .badge-soft-warning {
        background-color: #fffbeb;
        color: #b45309;
        border: 1px solid #fde68a;
    }
    .badge-soft-success {
        background-color: #ecfdf5;
        color: #047857;
        border: 1px solid #a7f3d0;
    }
    .badge-soft-info {
        background-color: #f0fdfa;
        color: #0f766e;
        border: 1px solid #99f6e4;
    }
</style>

<main class="main-content py-4 bg-light min-vh-100">
    <div class="container-xl">
        <!-- Toast / Alerts -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 rounded-3 mb-4 d-flex align-items-center" role="alert">
                <i class="bi bi-check-circle-fill fs-5 me-2 text-success"></i>
                <div>
                    <c:choose>
                        <c:when test="${param.success == 'saved'}">
                            <strong>Thành công!</strong> Đã lưu và cập nhật cấu hình bài thi.
                        </c:when>
                        <c:when test="${param.success == 'assigned'}">
                            <strong>Thành công!</strong> Đã thêm câu hỏi vào bài thi.
                        </c:when>
                        <c:when test="${param.success == 'removed'}">
                            <strong>Đã gỡ!</strong> Đã xóa câu hỏi khỏi bài thi này thành công.
                        </c:when>
                        <c:when test="${param.success == 'reordered'}">
                            <strong>Đã lưu!</strong> Thứ tự các câu hỏi đã được cập nhật.
                        </c:when>
                        <c:when test="${param.success == 'question_created_and_assigned'}">
                            <strong>Tuyệt vời!</strong> Đã tạo câu hỏi mới và tự động gán vào bài thi.
                        </c:when>
                        <c:otherwise>
                            <strong>Thành công!</strong> Thao tác đã được hoàn tất.
                        </c:otherwise>
                    </c:choose>
                </div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 rounded-3 mb-4 d-flex align-items-center" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5 me-2 text-danger"></i>
                <div>
                    <strong>Có lỗi xảy ra:</strong> <c:out value="${param.error}" />
                </div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Breadcrumb Navigation -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0 py-2 px-3 bg-white rounded-3 shadow-sm border border-light">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/expert/dashboard" class="text-decoration-none text-muted">
                        <i class="bi bi-house-door me-1"></i>Expert Dashboard
                    </a>
                </li>
                <li class="breadcrumb-item">
                    <c:url var="quizListUrl" value="/quizzes/list">
                        <c:choose>
                            <c:when test="${not empty courseId}">
                                <c:param name="courseId" value="${courseId}"/>
                            </c:when>
                            <c:otherwise>
                                <c:param name="moduleId" value="${quiz.moduleId}"/>
                            </c:otherwise>
                        </c:choose>
                    </c:url>
                    <a href="${quizListUrl}" class="text-decoration-none text-muted">Danh sách Quiz</a>
                </li>
                <c:if test="${not empty course}">
                    <li class="breadcrumb-item text-muted">
                        <c:out value="${course.title}" />
                    </li>
                </c:if>
                <li class="breadcrumb-item active text-primary fw-semibold" aria-current="page">
                    <c:out value="${quiz.title}" />
                </li>
            </ol>
        </nav>

        <!-- Hero Header Card -->
        <div class="card quiz-hero-card p-4 mb-4">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-2 flex-wrap">
                        <span class="badge badge-soft-primary px-2.5 py-1.5 rounded-pill fw-semibold">
                            <i class="bi bi-patch-question me-1"></i>Bài kiểm tra #${quiz.orderIndex}
                        </span>
                        <c:if test="${not empty currentModule}">
                            <span class="badge badge-soft-info px-2.5 py-1.5 rounded-pill fw-semibold">
                                <i class="bi bi-folder2-open me-1"></i>Chương: ${currentModule.title}
                            </span>
                        </c:if>
                        <c:choose>
                            <c:when test="${empty quiz.questions}">
                                <span class="badge bg-warning-subtle text-warning border border-warning-subtle px-2.5 py-1.5 rounded-pill fw-semibold">
                                    <i class="bi bi-exclamation-circle me-1"></i>Chưa có câu hỏi
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-soft-success px-2.5 py-1.5 rounded-pill fw-semibold">
                                    <i class="bi bi-check-circle me-1"></i>Sẵn sàng hoạt động
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <h2 class="fw-bold mb-1 text-dark">${quiz.title}</h2>
                    <p class="text-muted small mb-0">
                        Quản lý nội dung câu hỏi, điều chỉnh cấu hình và phân bổ điểm số cho bài kiểm tra
                    </p>
                </div>
                <div class="d-flex gap-2 flex-wrap">
                    <a href="${quizListUrl}" class="btn btn-outline-secondary rounded-pill px-3 fw-medium">
                        <i class="bi bi-arrow-left me-1"></i>Danh sách bài thi
                    </a>
                    <c:if test="${not empty quiz.questions}">
                        <a href="${pageContext.request.contextPath}/course/detail?id=${not empty courseId ? courseId : 1}" 
                           target="_blank" class="btn btn-outline-primary rounded-pill px-3 fw-medium" title="Xem khóa học">
                            <i class="bi bi-box-arrow-up-right me-1"></i>Khóa học
                        </a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- 4 KPI Summary Cards -->
        <div class="row g-3 mb-4">
            <!-- Total Questions -->
            <div class="col-sm-6 col-lg-3">
                <div class="card kpi-card p-3 h-100">
                    <div class="d-flex align-items-center">
                        <div class="kpi-icon-wrapper bg-primary-subtle text-primary me-3">
                            <i class="bi bi-question-diamond"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-semibold">Tổng số câu hỏi</div>
                            <div class="fs-4 fw-bold text-dark">
                                ${not empty quiz.questions ? fn:length(quiz.questions) : 0} <span class="fs-6 fw-normal text-muted">câu</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Total Points -->
            <div class="col-sm-6 col-lg-3">
                <div class="card kpi-card p-3 h-100">
                    <div class="d-flex align-items-center">
                        <div class="kpi-icon-wrapper bg-success-subtle text-success me-3">
                            <i class="bi bi-award"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-semibold">Tổng điểm bài thi</div>
                            <div class="fs-4 fw-bold text-dark">
                                ${quiz.totalPoints} <span class="fs-6 fw-normal text-muted">điểm</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Passing Score -->
            <div class="col-sm-6 col-lg-3">
                <div class="card kpi-card p-3 h-100">
                    <div class="d-flex align-items-center">
                        <div class="kpi-icon-wrapper bg-warning-subtle text-warning me-3">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-semibold">Điểm đạt tối thiểu</div>
                            <div class="fs-4 fw-bold text-dark">
                                ${quiz.passScore}% 
                                <span class="fs-6 fw-normal text-muted">(${quiz.passingPoints} đ)</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Time Limit -->
            <div class="col-sm-6 col-lg-3">
                <div class="card kpi-card p-3 h-100">
                    <div class="d-flex align-items-center">
                        <div class="kpi-icon-wrapper bg-info-subtle text-info me-3">
                            <i class="bi bi-stopwatch"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-semibold">Thời lượng làm bài</div>
                            <div class="fs-4 fw-bold text-dark">
                                <c:choose>
                                    <c:when test="${not empty quiz.timeLimitMinutes && quiz.timeLimitMinutes > 0}">
                                        ${quiz.timeLimitMinutes} <span class="fs-6 fw-normal text-muted">phút</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="fs-6 fw-semibold text-secondary">Tự do</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
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
                <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                    <div class="d-flex align-items-center mb-3">
                        <div class="kpi-icon-wrapper bg-primary-subtle text-primary me-2.5" style="width: 36px; height: 36px; font-size: 1.1rem;">
                            <i class="bi bi-gear-fill"></i>
                        </div>
                        <h5 class="fw-bold mb-0 text-dark">Cấu hình bài thi</h5>
                    </div>
                    <hr class="mt-2 mb-3 text-muted opacity-25">

                    <form action="${pageContext.request.contextPath}/quizzes/save" method="POST">
                        <input type="hidden" name="id" value="${quiz.id}">
                        <input type="hidden" name="moduleId" value="${quiz.moduleId}">
                        <c:if test="${not empty courseId}">
                            <input type="hidden" name="courseId" value="${courseId}">
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Tên bài thi <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control rounded-3" value="${quiz.title}" required placeholder="Nhập tên bài thi...">
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Tỉ lệ đạt tối thiểu (%) <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="number" name="passScore" class="form-control rounded-start-3" value="${quiz.passScore}" min="0" max="100" required>
                                <span class="input-group-text rounded-end-3 bg-light text-muted">%</span>
                            </div>
                            <small class="text-muted">Học viên cần đạt từ ${quiz.passScore}% số điểm để qua bài thi.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Thời lượng thi (Phút)</label>
                            <div class="input-group">
                                <input type="number" name="timeLimitMinutes" class="form-control rounded-start-3" value="${quiz.timeLimitMinutes}" placeholder="Để trống nếu không giới hạn">
                                <span class="input-group-text rounded-end-3 bg-light text-muted">phút</span>
                            </div>
                            <small class="text-muted">Để trống hoặc nhập 0 nếu không giới hạn thời gian.</small>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-semibold text-secondary">Thứ tự hiển thị <span class="text-danger">*</span></label>
                            <input type="number" name="orderIndex" class="form-control rounded-3" value="${quiz.orderIndex}" min="1" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2.5 rounded-pill fw-semibold shadow-sm">
                            <i class="bi bi-save me-1.5"></i>Lưu cấu hình bài thi
                        </button>
                    </form>
                </div>

                <!-- Info Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                    <h6 class="fw-bold mb-3 text-secondary text-uppercase small">
                        <i class="bi bi-info-circle me-1.5"></i>Thông tin liên kết
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
                        <c:url var="questionBankUrl" value="/quizzes/question-bank">
                            <c:param name="moduleId" value="${quiz.moduleId}"/>
                            <c:param name="quizId" value="${quiz.id}"/>
                            <c:if test="${not empty courseId}">
                                <c:param name="courseId" value="${courseId}"/>
                            </c:if>
                        </c:url>
                        <a href="${questionBankUrl}" class="btn btn-outline-info rounded-pill py-2 small fw-semibold">
                            <i class="bi bi-bank me-1.5"></i>Mở Ngân hàng câu hỏi riêng
                        </a>

                        <button type="button" class="btn btn-outline-danger rounded-pill py-2 small fw-semibold" 
                                data-bs-toggle="modal" data-bs-target="#deleteQuizModal">
                            <i class="bi bi-trash me-1.5"></i>Xóa bài thi này
                        </button>
                    </div>
                </div>
            </div>

            <!-- Right Column: Quiz Questions Management (col-lg-8) -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <!-- Card Header -->
                    <div class="card-header bg-white py-3.5 px-4 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 border-bottom">
                        <div>
                            <h5 class="fw-bold mb-0 text-dark">
                                <i class="bi bi-list-check text-primary me-2"></i>Danh sách câu hỏi trong bài thi
                            </h5>
                            <small class="text-muted">
                                Tổng cộng: <strong>${not empty quiz.questions ? fn:length(quiz.questions) : 0}</strong> câu hỏi | Điểm tối đa: <strong>${quiz.totalPoints}</strong> đ
                            </small>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="button" class="btn btn-primary rounded-pill btn-sm px-3 fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#pickFromBankModal">
                                <i class="bi bi-plus-circle me-1"></i>Thêm từ Ngân hàng
                            </button>
                            <button type="button" class="btn btn-outline-primary rounded-pill btn-sm px-3 fw-semibold" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                                <i class="bi bi-pencil-square me-1"></i>Tạo câu hỏi mới
                            </button>
                        </div>
                    </div>

                    <!-- Questions List Body -->
                    <div class="card-body p-4">
                        <c:choose>
                            <c:when test="${empty quiz.questions}">
                                <!-- Empty state -->
                                <div class="text-center py-5">
                                    <div class="bg-primary-subtle text-primary rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 72px; height: 72px; font-size: 2rem;">
                                        <i class="bi bi-patch-question"></i>
                                    </div>
                                    <h5 class="fw-bold text-dark mb-1">Bài thi này chưa có câu hỏi nào</h5>
                                    <p class="text-muted small mb-4 mx-auto" style="max-width: 420px;">
                                        Học viên sẽ không thể làm bài nếu bài thi trống. Hãy thêm câu hỏi từ Ngân hàng câu hỏi có sẵn hoặc tạo câu hỏi mới ngay bây giờ.
                                    </p>
                                    <div class="d-flex justify-content-center gap-2">
                                        <button type="button" class="btn btn-primary rounded-pill px-4 fw-semibold" data-bs-toggle="modal" data-bs-target="#pickFromBankModal">
                                            <i class="bi bi-plus-circle me-1"></i>Chọn từ Ngân hàng
                                        </button>
                                        <button type="button" class="btn btn-outline-secondary rounded-pill px-4 fw-semibold" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                                            <i class="bi bi-pencil-square me-1"></i>Tạo câu hỏi mới
                                        </button>
                                    </div>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="d-flex flex-column gap-3">
                                    <c:forEach var="qq" items="${quiz.questions}" varStatus="status">
                                        <div class="question-card p-3.5">
                                            <div class="d-flex justify-content-between align-items-start gap-2 mb-2.5">
                                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                                    <span class="badge bg-dark text-white rounded-pill px-2.5 py-1">
                                                        Câu #${status.index + 1}
                                                    </span>
                                                    <span class="badge badge-soft-primary rounded-pill px-2.5 py-1">
                                                        <c:choose>
                                                            <c:when test="${qq.questionType == 'SINGLE_CHOICE'}">1 Đáp án</c:when>
                                                            <c:when test="${qq.questionType == 'MULTI_CHOICE'}">Nhiều đáp án</c:when>
                                                            <c:when test="${qq.questionType == 'TRUE_FALSE'}">Đúng / Sai</c:when>
                                                            <c:otherwise>${qq.questionType}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <span class="badge badge-soft-success rounded-pill px-2.5 py-1 fw-bold">
                                                        <i class="bi bi-star-fill text-warning me-1"></i>
                                                        ${not empty qq.assignedPoints ? qq.assignedPoints : (not empty qq.points ? qq.points : qq.defaultPoints)} điểm
                                                    </span>
                                                </div>

                                                <!-- Action Buttons -->
                                                <div class="d-flex align-items-center gap-1.5">
                                                    <!-- Edit Points Modal Trigger -->
                                                    <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-2.5 py-1" 
                                                            data-bs-toggle="modal" data-bs-target="#editPointsModal_${qq.id}" title="Đổi điểm câu hỏi">
                                                        <i class="bi bi-pencil-fill me-1"></i>Điểm
                                                    </button>

                                                    <!-- Remove Question Form -->
                                                    <c:url var="removeUrl" value="/quizzes/remove-question">
                                                        <c:param name="quizId" value="${quiz.id}"/>
                                                        <c:param name="questionId" value="${qq.id}"/>
                                                        <c:if test="${not empty courseId}">
                                                            <c:param name="courseId" value="${courseId}"/>
                                                        </c:if>
                                                    </c:url>
                                                    <a href="${removeUrl}" class="btn btn-sm btn-outline-danger rounded-pill px-2.5 py-1" 
                                                       onclick="return confirm('Bạn có chắc muốn gỡ câu hỏi này khỏi bài thi? (Câu hỏi vẫn được giữ nguyên trong Ngân hàng câu hỏi)');"
                                                       title="Gỡ câu hỏi khỏi bài thi">
                                                        <i class="bi bi-trash"></i> Gỡ
                                                    </a>
                                                </div>
                                            </div>

                                            <!-- Question Text -->
                                            <h6 class="fw-bold text-dark mb-3">
                                                <c:out value="${qq.questionText}" />
                                            </h6>

                                            <!-- Question Options (Answers) -->
                                            <c:if test="${not empty qq.options}">
                                                <div class="row g-2 pt-2 border-top">
                                                    <c:forEach var="opt" items="${qq.options}" varStatus="optStatus">
                                                        <div class="col-md-6">
                                                            <div class="option-pill ${opt.correct ? 'correct' : 'regular'} d-flex align-items-center justify-content-between small">
                                                                <div class="d-flex align-items-center overflow-hidden">
                                                                    <i class="bi ${opt.correct ? 'bi-check-circle-fill text-success fs-6' : 'bi-circle text-muted'} me-2 flex-shrink-0"></i>
                                                                    <span class="text-truncate fw-medium">
                                                                        <c:out value="${opt.optionText}" />
                                                                    </span>
                                                                </div>
                                                                <c:if test="${opt.correct}">
                                                                    <span class="badge bg-success-subtle text-success border border-success-subtle ms-2 flex-shrink-0">
                                                                        Đúng
                                                                    </span>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Modal Edit Points for Question -->
                                        <div class="modal fade" id="editPointsModal_${qq.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered modal-sm">
                                                <div class="modal-content rounded-4 border-0 shadow">
                                                    <form action="${pageContext.request.contextPath}/quizzes/assign-question" method="POST">
                                                        <input type="hidden" name="quizId" value="${quiz.id}">
                                                        <input type="hidden" name="questionId" value="${qq.id}">
                                                        <c:if test="${not empty courseId}">
                                                            <input type="hidden" name="courseId" value="${courseId}">
                                                        </c:if>
                                                        <input type="hidden" name="order" value="${qq.quizOrderIndex}">

                                                        <div class="modal-header border-0 pb-0">
                                                            <h6 class="modal-title fw-bold">Cập nhật điểm câu hỏi</h6>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body py-3">
                                                            <p class="small text-muted mb-2 text-truncate" title="${qq.questionText}">
                                                                ${qq.questionText}
                                                            </p>
                                                            <label class="form-label small fw-semibold text-secondary">Điểm số trong bài thi</label>
                                                            <div class="input-group">
                                                                <input type="number" step="0.5" min="0.5" name="points" 
                                                                       class="form-control rounded-start-3" 
                                                                       value="${not empty qq.assignedPoints ? qq.assignedPoints : (not empty qq.points ? qq.points : qq.defaultPoints)}" required>
                                                                <span class="input-group-text rounded-end-3 bg-light text-muted">điểm</span>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer border-0 pt-0">
                                                            <button type="button" class="btn btn-light rounded-pill btn-sm" data-bs-dismiss="modal">Hủy</button>
                                                            <button type="submit" class="btn btn-primary rounded-pill btn-sm fw-semibold">Lưu điểm</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
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
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-bottom py-3">
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
                            <button type="button" class="btn btn-primary btn-sm rounded-pill px-3" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
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
                                <div class="card border rounded-3 p-3 ${isAlreadyAssigned ? 'bg-light opacity-75' : 'bg-white shadow-sm'}">
                                    <div class="d-flex justify-content-between align-items-start gap-2 mb-2">
                                        <div class="d-flex align-items-center gap-2 flex-wrap">
                                            <span class="badge bg-secondary-subtle text-secondary rounded-pill px-2 py-1">
                                                #${bStatus.index + 1}
                                            </span>
                                            <span class="badge badge-soft-primary rounded-pill px-2 py-1">
                                                <c:choose>
                                                    <c:when test="${bq.questionType == 'SINGLE_CHOICE'}">1 Đáp án</c:when>
                                                    <c:when test="${bq.questionType == 'MULTI_CHOICE'}">Nhiều đáp án</c:when>
                                                    <c:when test="${bq.questionType == 'TRUE_FALSE'}">Đúng / Sai</c:when>
                                                    <c:otherwise>${bq.questionType}</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="badge badge-soft-success rounded-pill px-2 py-1">
                                                Mặc định: ${bq.defaultPoints} đ
                                            </span>
                                        </div>

                                        <!-- Assign Action Button / Badge -->
                                        <div>
                                            <c:choose>
                                                <c:when test="${isAlreadyAssigned}">
                                                    <span class="badge bg-secondary-subtle text-secondary border px-2.5 py-1.5 rounded-pill">
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
                                                        <button type="submit" class="btn btn-sm btn-primary rounded-pill px-3 fw-semibold shadow-sm">
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
                                    <div class="row g-1.5 pt-1">
                                        <c:forEach var="bOpt" items="${bq.options}">
                                            <div class="col-md-6">
                                                <div class="small p-1.5 rounded border ${bOpt.correct ? 'bg-success-subtle border-success-subtle text-success fw-semibold' : 'bg-light text-muted'}">
                                                    <i class="bi ${bOpt.correct ? 'bi-check-circle-fill' : 'bi-circle'} me-1.5"></i>
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

            <div class="modal-footer border-top py-2.5 px-4 bg-light">
                <button type="button" class="btn btn-secondary rounded-pill btn-sm px-3" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal 2: Create New Question directly and auto assign to Quiz -->
<div class="modal fade" id="newQuestionModal" tabindex="-1" aria-labelledby="newQuestionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content rounded-4 border-0 shadow">
            <form action="${pageContext.request.contextPath}/quizzes/save-question" method="POST">
                <input type="hidden" name="moduleId" value="${quiz.moduleId}">
                <input type="hidden" name="quizId" value="${quiz.id}">
                <c:if test="${not empty courseId}">
                    <input type="hidden" name="courseId" value="${courseId}">
                </c:if>

                <div class="modal-header border-bottom py-3">
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
                        <label class="form-label small fw-semibold text-secondary">Nội dung câu hỏi <span class="text-danger">*</span></label>
                        <textarea name="questionText" rows="3" class="form-control rounded-3" required placeholder="Nhập nội dung câu hỏi trắc nghiệm ở đây..."></textarea>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-secondary">Loại câu hỏi</label>
                            <select name="questionType" class="form-select rounded-3">
                                <option value="SINGLE_CHOICE" selected>Trắc nghiệm 1 đáp án (Single Choice)</option>
                                <option value="TRUE_FALSE">Đúng / Sai (True / False)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-secondary">Điểm số của câu hỏi</label>
                            <div class="input-group">
                                <input type="number" step="0.5" min="0.5" name="defaultPoints" value="1.0" class="form-control rounded-start-3" required>
                                <span class="input-group-text rounded-end-3 bg-light text-muted">điểm</span>
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

                <div class="modal-footer border-top py-2.5 px-4 bg-light">
                    <button type="button" class="btn btn-secondary rounded-pill btn-sm px-3" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary rounded-pill btn-sm px-4 fw-semibold shadow-sm">
                        <i class="bi bi-save me-1"></i>Tạo và gán vào Quiz
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal 3: Delete Quiz Confirmation -->
<div class="modal fade" id="deleteQuizModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-body text-center p-4">
                <div class="bg-danger-subtle text-danger rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 56px; height: 56px; font-size: 1.6rem;">
                    <i class="bi bi-trash"></i>
                </div>
                <h5 class="fw-bold text-dark mb-1">Xác nhận xóa bài thi?</h5>
                <p class="small text-muted mb-4">
                    Thao tác này sẽ xóa vĩnh viễn bài thi <strong>"${quiz.title}"</strong>. Các câu hỏi trong ngân hàng vẫn được giữ nguyên.
                </p>
                <div class="d-flex justify-content-center gap-2">
                    <button type="button" class="btn btn-light rounded-pill px-3" data-bs-dismiss="modal">Hủy</button>
                    <c:url var="deleteQuizUrl" value="/quizzes/delete">
                        <c:param name="id" value="${quiz.id}"/>
                        <c:if test="${not empty courseId}">
                            <c:param name="courseId" value="${courseId}"/>
                        </c:if>
                        <c:if test="${empty courseId}">
                            <c:param name="moduleId" value="${quiz.moduleId}"/>
                        </c:if>
                    </c:url>
                    <a href="${deleteQuizUrl}" class="btn btn-danger rounded-pill px-3 fw-semibold">
                        Xóa bài thi
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
