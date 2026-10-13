<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="${quiz.title} - Quản lý bài thi - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<style>
    /* Quiz Detail Modern Styles */
    .kpi-card {
        border-radius: 0.75rem;
        border: 1px solid #e2e8f0;
        background: #ffffff;
        transition: transform 0.15s ease, box-shadow 0.15s ease;
    }
    .kpi-card:hover {
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
    }
    .kpi-icon-box {
        width: 42px;
        height: 42px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.25rem;
    }

    .sticky-config-sidebar {
        position: sticky;
        top: 1.5rem;
        z-index: 10;
    }

    .preset-pill {
        cursor: pointer;
        font-size: 0.75rem;
        padding: 0.2rem 0.55rem;
        border-radius: 20px;
        border: 1px solid #cbd5e1;
        background-color: #f8fafc;
        color: #475569;
        transition: all 0.15s ease;
        user-select: none;
    }
    .preset-pill:hover {
        background-color: var(--cf-orange-light, #FFF5EB);
        border-color: var(--primary-color, #F38020);
        color: var(--primary-color, #F38020);
    }

    .question-item-card {
        border: 1px solid #e2e8f0;
        border-radius: 0.85rem;
        background: #ffffff;
        transition: all 0.2s ease;
    }
    .question-item-card:hover {
        border-color: #cbd5e1;
        box-shadow: 0 6px 12px -2px rgba(0, 0, 0, 0.06);
    }

    .option-card {
        border-radius: 0.6rem;
        padding: 0.65rem 0.85rem;
        border: 1px solid #e2e8f0;
        background-color: #f8fafc;
        font-size: 0.875rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        transition: all 0.15s ease;
    }
    .option-card.is-correct {
        background-color: #ecfdf5;
        border-color: #a7f3d0;
        color: #065f46;
        font-weight: 500;
    }
    .option-letter-badge {
        width: 24px;
        height: 24px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 0.75rem;
        font-weight: 700;
        flex-shrink: 0;
    }

    .bank-question-row {
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        transition: background-color 0.15s ease, border-color 0.15s ease;
    }
    .bank-question-row:hover {
        border-color: #cbd5e1;
        background-color: #fafafa;
    }

    .search-filter-box {
        background: #f8fafc;
        border-radius: 0.75rem;
        border: 1px solid #e2e8f0;
        padding: 0.75rem 1rem;
    }
</style>

<main class="main-content py-4 py-lg-5">
    <div class="container">

        <!-- Breadcrumb Navigation Tinh gọn -->
        <nav class="mb-3" aria-label="breadcrumb">
            <ol class="breadcrumb py-1 px-0 mb-0 small">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/expert/dashboard" class="text-decoration-none text-muted">
                        Dashboard
                    </a>
                </li>
                <c:if test="${not empty course}">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}" class="text-decoration-none text-muted">
                            ${course.title}
                        </a>
                    </li>
                </c:if>
                <c:if test="${not empty currentModule}">
                    <li class="breadcrumb-item text-muted">
                        Chương ${currentModule.orderIndex}
                    </li>
                </c:if>
                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">
                    ${quiz.title}
                </li>
            </ol>
        </nav>

        <!-- System Alerts -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 rounded-3 mb-3 d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                <div class="flex-grow-1 small">
                    <c:choose>
                        <c:when test="${param.success == 'saved'}">Đã lưu và cập nhật cấu hình bài kiểm tra.</c:when>
                        <c:when test="${param.success == 'assigned'}">Đã thêm câu hỏi vào bài kiểm tra.</c:when>
                        <c:when test="${param.success == 'removed'}">Đã gỡ câu hỏi khỏi bài thi (câu hỏi vẫn nằm trong Ngân hàng).</c:when>
                        <c:when test="${param.success == 'question_created_and_assigned'}">Đã tạo câu hỏi mới và tự động gán vào bài kiểm tra.</c:when>
                        <c:otherwise>Thao tác đã được hoàn tất thành công.</c:otherwise>
                    </c:choose>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 rounded-3 mb-3 d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                <div class="flex-grow-1 small">
                    <c:out value="${param.error}" />
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Header Top Bar Tối giản & Đồng bộ -->
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <c:if test="${not empty currentModule}">
                        <span class="badge bg-light text-dark border fw-semibold">Chương ${currentModule.orderIndex}</span>
                    </c:if>
                    <h3 class="fw-bold mb-0 text-dark">
                        <i class="bi bi-patch-question-fill text-primary me-2"></i><c:out value="${quiz.title}" />
                    </h3>
                </div>
                <p class="text-muted small mb-0">
                    Quản lý cấu hình bài kiểm tra trắc nghiệm và danh sách câu hỏi
                </p>
            </div>

            <div class="d-flex align-items-center gap-2">
                <c:url var="backQuizListUrl" value="/quizzes/list">
                    <c:if test="${not empty courseId}"><c:param name="courseId" value="${courseId}"/></c:if>
                </c:url>
                <a href="${backQuizListUrl}" class="btn btn-outline-secondary btn-sm fw-semibold px-3 py-2 rounded-3">
                    <i class="bi bi-arrow-left me-1"></i>Danh sách Quiz
                </a>
                <button type="button" class="btn btn-outline-primary btn-sm fw-semibold px-3 py-2 rounded-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#pickFromBankModal">
                    <i class="bi bi-bank me-1"></i>Từ Ngân hàng
                </button>
                <button type="button" class="btn btn-primary btn-sm fw-semibold px-3 py-2 rounded-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                    <i class="bi bi-plus-lg me-1"></i>Thêm câu hỏi
                </button>
            </div>
        </div>

        <!-- 4 KPI Stat Cards Tinh gọn -->
        <div class="row g-3 mb-4">
            <!-- 1. Total Questions -->
            <div class="col-6 col-lg-3">
                <div class="card kpi-card p-3 h-100">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-medium">Số câu hỏi</span>
                            <h4 class="fw-bold mb-0 text-dark mt-1">
                                ${not empty quiz.questions ? fn:length(quiz.questions) : 0} <span class="fs-6 fw-normal text-muted">câu</span>
                            </h4>
                        </div>
                        <div class="kpi-icon-box bg-primary-subtle text-primary">
                            <i class="bi bi-question-diamond-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 2. Total Points -->
            <div class="col-6 col-lg-3">
                <div class="card kpi-card p-3 h-100">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-medium">Tổng điểm</span>
                            <h4 class="fw-bold mb-0 text-success mt-1">
                                ${quiz.totalPoints} <span class="fs-6 fw-normal text-muted">điểm</span>
                            </h4>
                        </div>
                        <div class="kpi-icon-box bg-success-subtle text-success">
                            <i class="bi bi-award-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 3. Passing Score -->
            <div class="col-6 col-lg-3">
                <div class="card kpi-card p-3 h-100">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-medium">Điểm qua môn</span>
                            <h4 class="fw-bold mb-0 text-warning-emphasis mt-1">
                                ${quiz.passScore}% <span class="fs-6 fw-normal text-muted">(${quiz.passingPoints} đ)</span>
                            </h4>
                        </div>
                        <div class="kpi-icon-box bg-warning-subtle text-warning">
                            <i class="bi bi-shield-check"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4. Time Limit -->
            <div class="col-6 col-lg-3">
                <div class="card kpi-card p-3 h-100">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-medium">Thời lượng</span>
                            <h4 class="fw-bold mb-0 text-dark mt-1">
                                <c:choose>
                                    <c:when test="${not empty quiz.timeLimitMinutes && quiz.timeLimitMinutes > 0}">
                                        ${quiz.timeLimitMinutes} <span class="fs-6 fw-normal text-muted">phút</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="fs-6 fw-semibold text-secondary">Tự do</span>
                                    </c:otherwise>
                                </c:choose>
                            </h4>
                        </div>
                        <div class="kpi-icon-box bg-info-subtle text-info">
                            <i class="bi bi-stopwatch-fill"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Area: 2 Columns Layout -->
        <div class="row g-4">

            <!-- LEFT COLUMN: Quiz Settings & Actions (col-lg-4) -->
            <div class="col-lg-4">
                <div class="sticky-config-sidebar d-flex flex-column gap-4">

                    <!-- Form Card: Cấu hình bài thi -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <div class="d-flex align-items-center justify-content-between pb-3 mb-3 border-bottom">
                            <div class="d-flex align-items-center gap-2">
                                <div class="bg-primary-subtle text-primary p-2 rounded-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                                    <i class="bi bi-sliders fs-5"></i>
                                </div>
                                <h5 class="fw-bold mb-0 text-dark">Cấu hình bài thi</h5>
                            </div>
                            <span class="badge bg-light text-muted border">Chỉnh sửa</span>
                        </div>

                        <form action="${pageContext.request.contextPath}/quizzes/save" method="POST" id="quizSettingsForm">
                            <input type="hidden" name="id" value="${quiz.id}">
                            <input type="hidden" name="moduleId" value="${quiz.moduleId}">
                            <c:if test="${not empty courseId}">
                                <input type="hidden" name="courseId" value="${courseId}">
                            </c:if>

                            <!-- Quiz Title -->
                            <div class="mb-3">
                                <label class="form-label small fw-semibold text-secondary">
                                    Tên bài thi <span class="text-danger">*</span>
                                </label>
                                <input type="text" name="title" class="form-control rounded-3" value="${quiz.title}" required placeholder="Ví dụ: Quiz 1 - Khái niệm cơ bản...">
                            </div>

                            <!-- Pass Score with Quick Presets -->
                            <div class="mb-3">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <label class="form-label small fw-semibold text-secondary mb-0">
                                        Tỉ lệ đạt tối thiểu (%) <span class="text-danger">*</span>
                                    </label>
                                    <span class="text-muted small" id="calculatedPassPointsText">${quiz.passingPoints} / ${quiz.totalPoints} đ</span>
                                </div>
                                <div class="input-group">
                                    <input type="number" id="passScoreInput" name="passScore" class="form-control rounded-start-3" value="${quiz.passScore}" min="0" max="100" step="1" required>
                                    <span class="input-group-text bg-light text-muted rounded-end-3 fw-bold">%</span>
                                </div>
                                <!-- Preset Pills -->
                                <div class="d-flex flex-wrap gap-1 mt-2">
                                    <span class="preset-pill" onclick="setPassScorePreset(40)">40%</span>
                                    <span class="preset-pill" onclick="setPassScorePreset(50)">50%</span>
                                    <span class="preset-pill" onclick="setPassScorePreset(60)">60%</span>
                                    <span class="preset-pill" onclick="setPassScorePreset(70)">70%</span>
                                    <span class="preset-pill" onclick="setPassScorePreset(80)">80%</span>
                                </div>
                                <div class="form-text small text-muted mt-1">
                                    Nhập giá trị từ 0 đến 100%. Học viên cần đạt tỉ lệ này để vượt qua bài thi.
                                </div>
                            </div>

                            <!-- Time Limit with Presets -->
                            <div class="mb-3">
                                <label class="form-label small fw-semibold text-secondary">
                                    Thời lượng thi (Phút)
                                </label>
                                <div class="input-group">
                                    <input type="number" id="timeLimitInput" name="timeLimitMinutes" class="form-control rounded-start-3" value="${quiz.timeLimitMinutes}" min="0" placeholder="Để trống nếu không giới hạn">
                                    <span class="input-group-text bg-light text-muted rounded-end-3">phút</span>
                                </div>
                                <!-- Preset Pills -->
                                <div class="d-flex flex-wrap gap-1 mt-2">
                                    <span class="preset-pill" onclick="setTimeLimitPreset('')">Không giới hạn</span>
                                    <span class="preset-pill" onclick="setTimeLimitPreset(15)">15 phút</span>
                                    <span class="preset-pill" onclick="setTimeLimitPreset(30)">30 phút</span>
                                    <span class="preset-pill" onclick="setTimeLimitPreset(45)">45 phút</span>
                                    <span class="preset-pill" onclick="setTimeLimitPreset(60)">60 phút</span>
                                </div>
                                <div class="form-text small text-muted mt-1">
                                    Để trống hoặc nhập 0 để làm bài không giới hạn thời gian.
                                </div>
                            </div>

                            <!-- Order Index -->
                            <div class="mb-4">
                                <label class="form-label small fw-semibold text-secondary">
                                    Thứ tự hiển thị trong chương <span class="text-danger">*</span>
                                </label>
                                <input type="number" name="orderIndex" class="form-control rounded-3" value="${quiz.orderIndex}" min="1" required>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 fw-semibold rounded-3 py-2 shadow-sm">
                                <i class="bi bi-check-lg me-1"></i>Lưu thay đổi cấu hình
                            </button>
                        </form>
                    </div>

                    <!-- Meta Information & Secondary Actions -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <h6 class="fw-bold mb-3 text-secondary text-uppercase small d-flex align-items-center gap-2">
                            <i class="bi bi-info-circle-fill text-primary"></i>Thông tin liên kết
                        </h6>

                        <div class="d-flex flex-column gap-2 small">
                            <div class="d-flex justify-content-between align-items-center py-1 border-bottom">
                                <span class="text-muted">Mã Quiz ID:</span>
                                <span class="fw-semibold text-dark">#${quiz.id}</span>
                            </div>
                            <c:if test="${not empty currentModule}">
                                <div class="d-flex justify-content-between align-items-center py-1 border-bottom">
                                    <span class="text-muted">Chương học:</span>
                                    <span class="fw-semibold text-end text-truncate" style="max-width: 180px;" title="${currentModule.title}">
                                        ${currentModule.title}
                                    </span>
                                </div>
                            </c:if>
                            <c:if test="${not empty course}">
                                <div class="d-flex justify-content-between align-items-center py-1 border-bottom">
                                    <span class="text-muted">Khóa học:</span>
                                    <span class="fw-semibold text-end text-truncate" style="max-width: 180px;" title="${course.title}">
                                        ${course.title}
                                    </span>
                                </div>
                            </c:if>
                            <div class="d-flex justify-content-between align-items-center py-1">
                                <span class="text-muted">Ngân hàng của chương:</span>
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle fw-semibold">
                                    ${not empty bankQuestions ? fn:length(bankQuestions) : 0} câu hỏi có sẵn
                                </span>
                            </div>
                        </div>

                        <div class="d-grid gap-2 mt-4 pt-3 border-top">
                            <c:url var="courseQuestionsUrl" value="/quizzes/list">
                                <c:if test="${not empty courseId}">
                                    <c:param name="courseId" value="${courseId}"/>
                                </c:if>
                                <c:param name="tab" value="questions"/>
                            </c:url>
                            <a href="${courseQuestionsUrl}" class="btn btn-outline-secondary btn-sm fw-semibold rounded-3 py-2 text-start">
                                <i class="bi bi-database me-2 text-primary"></i>Xem Ngân hàng câu hỏi
                            </a>

                            <button type="button" class="btn btn-outline-danger btn-sm fw-semibold rounded-3 py-2 text-start" data-bs-toggle="modal" data-bs-target="#deleteQuizModal">
                                <i class="bi bi-trash3 me-2"></i>Xóa bài thi này
                            </button>
                        </div>
                    </div>

                </div>
            </div>

            <!-- RIGHT COLUMN: Quiz Questions Management (col-lg-8) -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">

                    <!-- Right Column Header -->
                    <div class="card-header bg-white py-3 px-4 border-bottom">
                        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3">
                            <div>
                                <h5 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                                    <span class="text-primary"><i class="bi bi-card-checklist"></i></span>
                                    Danh sách câu hỏi trong bài thi
                                </h5>
                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle fw-semibold">
                                        <i class="bi bi-patch-question me-1"></i><span id="renderedQuestionsCount">${not empty quiz.questions ? fn:length(quiz.questions) : 0}</span> câu hỏi
                                    </span>
                                    <span class="badge bg-success-subtle text-success border border-success-subtle fw-semibold">
                                        <i class="bi bi-star-fill text-warning me-1"></i>Tổng: ${quiz.totalPoints} điểm
                                    </span>
                                </div>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-sm btn-outline-primary fw-semibold px-3 py-1.5 rounded-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#pickFromBankModal">
                                    <i class="bi bi-bank me-1"></i>Từ Ngân hàng
                                </button>
                                <button type="button" class="btn btn-sm btn-success fw-semibold px-3 py-1.5 rounded-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                                    <i class="bi bi-plus-lg me-1"></i>Thêm câu hỏi
                                </button>
                            </div>
                        </div>

                        <!-- Live Search & Filter Bar for Assigned Questions -->
                        <c:if test="${not empty quiz.questions}">
                            <div class="row g-2 mt-3 pt-3 border-top align-items-center">
                                <div class="col-sm-7 col-12">
                                    <div class="input-group input-group-sm">
                                        <span class="input-group-text bg-light border-end-0 text-muted">
                                            <i class="bi bi-search"></i>
                                        </span>
                                        <input type="text" id="quizQuestionSearchInput" class="form-control border-start-0 bg-light" placeholder="Tìm câu hỏi trong bài thi...">
                                        <button class="btn btn-outline-secondary border-start-0" type="button" id="clearQuizSearchBtn" style="display:none;" onclick="clearQuizQuestionSearch()">
                                            <i class="bi bi-x"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="col-sm-5 col-12">
                                    <select id="quizQuestionTypeFilter" class="form-select form-select-sm bg-light">
                                        <option value="ALL">Tất cả dạng câu hỏi</option>
                                        <option value="SINGLE_CHOICE">1 Đáp án (Single Choice)</option>
                                        <option value="MULTI_CHOICE">Nhiều đáp án (Multi Choice)</option>
                                        <option value="TRUE_FALSE">Đúng / Sai (True / False)</option>
                                    </select>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Questions List Body -->
                    <div class="card-body p-4">
                        <c:choose>
                            <c:when test="${empty quiz.questions}">
                                <!-- Empty state -->
                                <div class="text-center py-5 px-3">
                                    <div class="bg-primary-subtle text-primary rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 72px; height: 72px;">
                                        <i class="bi bi-patch-question display-6"></i>
                                    </div>
                                    <h5 class="fw-bold text-dark mb-1">Chưa có câu hỏi nào trong bài thi này</h5>
                                    <p class="text-muted small mb-4 mx-auto" style="max-width: 460px;">
                                        Bài thi chưa thể cho học viên làm nếu chưa có câu hỏi. Bạn có thể chọn các câu hỏi có sẵn từ ngân hàng của chương hoặc tạo câu hỏi mới ngay bây giờ.
                                    </p>
                                    <div class="d-flex justify-content-center flex-wrap gap-2">
                                        <button type="button" class="btn btn-primary fw-semibold px-3 py-2 rounded-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#pickFromBankModal">
                                            <i class="bi bi-bank me-1"></i>Chọn từ Ngân hàng câu hỏi
                                        </button>
                                        <button type="button" class="btn btn-outline-secondary fw-semibold px-3 py-2 rounded-3" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                                            <i class="bi bi-plus-circle me-1"></i>Tạo câu hỏi mới
                                        </button>
                                    </div>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="d-flex flex-column gap-3" id="quizQuestionsContainer">
                                    <c:forEach var="qq" items="${quiz.questions}" varStatus="status">
                                        <div class="question-item-card p-3 p-md-4" 
                                             data-question-text="${fn:toLowerCase(fn:escapeXml(qq.questionText))}"
                                             data-question-type="${qq.questionType}">

                                            <!-- Question Card Header -->
                                            <div class="d-flex justify-content-between align-items-start gap-2 mb-3">
                                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                                    <!-- Question Index Badge -->
                                                    <span class="badge bg-light text-dark border px-2.5 py-1.5 fw-bold">
                                                        Câu #${status.index + 1}
                                                    </span>

                                                    <!-- Question Type Badge -->
                                                    <c:choose>
                                                        <c:when test="${qq.questionType == 'SINGLE_CHOICE'}">
                                                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                                                                <i class="bi bi-ui-radios me-1"></i>1 Đáp án
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${qq.questionType == 'MULTI_CHOICE'}">
                                                            <span class="badge bg-purple-subtle text-purple border border-purple-subtle px-2 py-1" style="background-color: #f3e8ff; color: #7e22ce; border-color: #e9d5ff !important;">
                                                                <i class="bi bi-ui-checks me-1"></i>Nhiều đáp án
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${qq.questionType == 'TRUE_FALSE'}">
                                                            <span class="badge bg-info-subtle text-info-emphasis border border-info-subtle px-2 py-1">
                                                                <i class="bi bi-toggle-on me-1"></i>Đúng / Sai
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary-subtle text-secondary border px-2 py-1">
                                                                ${qq.questionType}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <!-- Points Badge -->
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2.5 py-1.5 fw-bold">
                                                        <i class="bi bi-award-fill text-warning me-1"></i>${not empty qq.assignedPoints ? qq.assignedPoints : (not empty qq.points ? qq.points : qq.defaultPoints)} điểm
                                                    </span>
                                                </div>

                                                <!-- Action Buttons: Edit Points & Remove -->
                                                <div class="d-flex align-items-center gap-1">
                                                    <button type="button" class="btn btn-sm btn-outline-secondary rounded-3 py-1 px-2.5 fw-semibold" 
                                                            onclick="openEditPointsModal('${qq.id}', '${qq.quizOrderIndex}', '${not empty qq.assignedPoints ? qq.assignedPoints : (not empty qq.points ? qq.points : qq.defaultPoints)}', '${fn:escapeXml(qq.questionText)}')"
                                                            title="Sửa điểm số cho câu hỏi này trong bài thi">
                                                        <i class="bi bi-pencil-square me-1"></i>Sửa điểm
                                                    </button>

                                                    <c:url var="removeUrl" value="/quizzes/remove-question">
                                                        <c:param name="quizId" value="${quiz.id}"/>
                                                        <c:param name="questionId" value="${qq.id}"/>
                                                        <c:if test="${not empty courseId}">
                                                            <c:param name="courseId" value="${courseId}"/>
                                                        </c:if>
                                                    </c:url>
                                                    <a href="${removeUrl}" class="btn btn-sm btn-outline-danger rounded-3 py-1 px-2.5 fw-semibold" 
                                                       onclick="return confirm('Bạn có chắc muốn gỡ câu hỏi này khỏi bài thi? (Câu hỏi vẫn được giữ nguyên an toàn trong Ngân hàng câu hỏi)');"
                                                       title="Gỡ khỏi bài thi">
                                                        <i class="bi bi-trash3 me-1"></i>Gỡ
                                                    </a>
                                                </div>
                                            </div>

                                            <!-- Question Title / Content -->
                                            <div class="fw-semibold text-dark mb-3 fs-6 lh-base">
                                                <c:out value="${qq.questionText}" />
                                            </div>

                                            <!-- Question Options Grid -->
                                            <c:if test="${not empty qq.options}">
                                                <div class="row g-2 pt-2 border-top">
                                                    <c:forEach var="opt" items="${qq.options}" varStatus="optStatus">
                                                        <c:set var="letter" value="${optStatus.index == 0 ? 'A' : (optStatus.index == 1 ? 'B' : (optStatus.index == 2 ? 'C' : (optStatus.index == 3 ? 'D' : optStatus.index + 1)))}" />
                                                        <div class="col-md-6">
                                                            <div class="option-card ${opt.correct ? 'is-correct' : ''}">
                                                                <span class="option-letter-badge ${opt.correct ? 'bg-success text-white' : 'bg-light border text-muted'}">
                                                                    ${letter}
                                                                </span>
                                                                <span class="flex-grow-1 text-truncate" title="<c:out value="${opt.optionText}" />">
                                                                    <c:out value="${opt.optionText}" />
                                                                </span>
                                                                <c:if test="${opt.correct}">
                                                                    <span class="badge bg-success text-white py-1 px-2 flex-shrink-0" style="font-size: 0.7rem;">
                                                                        <i class="bi bi-check2 me-1"></i>Đáp án đúng
                                                                    </span>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>

                                    <!-- Filter no-match notice -->
                                    <div id="noQuizQuestionMatchNotice" class="text-center py-4 d-none">
                                        <i class="bi bi-funnel text-muted fs-2 d-block mb-2"></i>
                                        <h6 class="fw-bold text-dark mb-1">Không tìm thấy câu hỏi phù hợp với bộ lọc</h6>
                                        <p class="text-muted small mb-2">Hãy thử tìm từ khóa khác hoặc thiết lập lại bộ lọc.</p>
                                        <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearQuizQuestionSearch()">
                                            <i class="bi bi-arrow-clockwise me-1"></i>Đặt lại tìm kiếm
                                        </button>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </div>

        </div>
    </div>
</main>

<!-- ======================================================= -->
<!-- MODAL 1: CHỌN CÂU HỎI TỪ NGÂN HÀNG CỦA CHƯƠNG            -->
<!-- ======================================================= -->
<div class="modal fade" id="pickFromBankModal" tabindex="-1" aria-labelledby="pickFromBankModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-header py-3 px-4 border-bottom bg-light">
                <div>
                    <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2" id="pickFromBankModalLabel">
                        <span class="text-primary"><i class="bi bi-bank"></i></span>
                        Ngân hàng câu hỏi của chương
                    </h5>
                    <small class="text-muted">Chọn các câu hỏi để gán vào bài thi "${quiz.title}"</small>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-4">
                <c:choose>
                    <c:when test="${empty bankQuestions}">
                        <div class="text-center py-5">
                            <div class="bg-light text-muted rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 64px; height: 64px;">
                                <i class="bi bi-inbox fs-2"></i>
                            </div>
                            <h6 class="fw-bold text-dark mb-1">Ngân hàng câu hỏi của chương này đang trống</h6>
                            <p class="text-muted small mb-3">
                                Chưa có câu hỏi nào được tạo trong ngân hàng câu hỏi của chương học này.
                            </p>
                            <button type="button" class="btn btn-primary btn-sm fw-semibold rounded-3 px-3 py-2" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                                <i class="bi bi-plus-lg me-1"></i>Tạo câu hỏi mới ngay
                            </button>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <!-- Filter Bar inside Bank Modal -->
                        <div class="search-filter-box mb-3">
                            <div class="row g-2 align-items-center">
                                <div class="col-sm-7">
                                    <div class="input-group input-group-sm">
                                        <span class="input-group-text bg-white border-end-0 text-muted">
                                            <i class="bi bi-search"></i>
                                        </span>
                                        <input type="text" id="bankSearchInput" class="form-control border-start-0" placeholder="Tìm câu hỏi trong ngân hàng...">
                                    </div>
                                </div>
                                <div class="col-sm-5">
                                    <select id="bankStatusFilter" class="form-select form-select-sm">
                                        <option value="ALL">Tất cả (${fn:length(bankQuestions)} câu)</option>
                                        <option value="UNASSIGNED">Chưa thêm vào bài thi</option>
                                        <option value="ASSIGNED">Đã có trong bài thi</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Bank Questions List -->
                        <div class="d-flex flex-column gap-3" id="bankQuestionsContainer">
                            <c:forEach var="bq" items="${bankQuestions}" varStatus="bStatus">
                                <c:set var="isAlreadyAssigned" value="${assignedQuestionIds.contains(bq.id)}" />
                                <div class="bank-question-row p-3 ${isAlreadyAssigned ? 'bg-light opacity-75' : 'bg-white'}"
                                     data-bank-text="${fn:toLowerCase(fn:escapeXml(bq.questionText))}"
                                     data-bank-assigned="${isAlreadyAssigned ? 'true' : 'false'}">

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
                                                Điểm chuẩn: ${bq.defaultPoints} đ
                                            </span>
                                        </div>

                                        <!-- Assign Action Button / Status Badge -->
                                        <div>
                                            <c:choose>
                                                <c:when test="${isAlreadyAssigned}">
                                                    <span class="badge bg-secondary-subtle text-secondary border px-2.5 py-1.5">
                                                        <i class="bi bi-check2-all me-1"></i>Đã trong bài thi
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
                                                        <button type="submit" class="btn btn-sm btn-primary fw-semibold px-2.5 py-1 rounded-3 shadow-sm">
                                                            <i class="bi bi-plus-lg me-1"></i>Thêm vào Quiz
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="fw-semibold text-dark mb-2 small lh-base">
                                        <c:out value="${bq.questionText}" />
                                    </div>

                                    <!-- Options preview -->
                                    <div class="row g-1 pt-1">
                                        <c:forEach var="bOpt" items="${bq.options}" varStatus="bOptStatus">
                                            <c:set var="letter" value="${bOptStatus.index == 0 ? 'A' : (bOptStatus.index == 1 ? 'B' : (bOptStatus.index == 2 ? 'C' : 'D'))}" />
                                            <div class="col-md-6">
                                                <div class="small p-1.5 rounded border ${bOpt.correct ? 'bg-success-subtle border-success-subtle text-success fw-medium' : 'bg-light text-muted'} d-flex align-items-center gap-1">
                                                    <span class="badge ${bOpt.correct ? 'bg-success text-white' : 'bg-secondary text-white'}" style="font-size: 0.65rem;">
                                                        ${letter}
                                                    </span>
                                                    <span class="text-truncate">
                                                        <c:out value="${bOpt.optionText}" />
                                                    </span>
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

            <div class="modal-footer py-2.5 px-4 bg-light border-top">
                <button type="button" class="btn btn-secondary btn-sm fw-semibold rounded-3" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- ======================================================= -->
<!-- MODAL 2: TẠO CÂU HỎI MỚI VÀ TỰ ĐỘNG GÁN VÀO QUIZ        -->
<!-- ======================================================= -->
<div class="modal fade" id="newQuestionModal" tabindex="-1" aria-labelledby="newQuestionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <form action="${pageContext.request.contextPath}/quizzes/save-question" method="POST" id="newQuestionForm">
                <input type="hidden" name="moduleId" value="${quiz.moduleId}">
                <input type="hidden" name="quizId" value="${quiz.id}">
                <c:if test="${not empty courseId}">
                    <input type="hidden" name="courseId" value="${courseId}">
                </c:if>

                <div class="modal-header py-3 px-4 bg-light border-bottom">
                    <div>
                        <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2" id="newQuestionModalLabel">
                            <span class="text-success"><i class="bi bi-patch-plus-fill"></i></span>
                            Tạo câu hỏi mới và thêm vào bài thi
                        </h5>
                        <small class="text-muted">Câu hỏi sẽ được lưu vào ngân hàng của chương và tự động gán vào bài thi này</small>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <!-- Question Text -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">
                            Nội dung câu hỏi <span class="text-danger">*</span>
                        </label>
                        <textarea name="questionText" rows="3" class="form-control rounded-3" required placeholder="Nhập nội dung câu hỏi trắc nghiệm ở đây..."></textarea>
                    </div>

                    <!-- Type and Points -->
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-secondary">Loại câu hỏi</label>
                            <select name="questionType" id="newQuestionTypeSelect" class="form-select rounded-3" onchange="handleQuestionTypeChange(this.value)">
                                <option value="SINGLE_CHOICE" selected>Trắc nghiệm 1 đáp án (Single Choice)</option>
                                <option value="TRUE_FALSE">Đúng / Sai (True / False)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-secondary">
                                Điểm số của câu hỏi <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <input type="number" step="0.5" min="0.5" name="defaultPoints" id="newQuestionPointsInput" value="1.0" class="form-control rounded-start-3" required>
                                <span class="input-group-text bg-light text-muted rounded-end-3">điểm</span>
                            </div>
                            <div class="form-text small text-muted">Điểm số phải lớn hơn 0 (ví dụ: 1.0, 2.0).</div>
                        </div>
                    </div>

                    <!-- Options Area -->
                    <label class="form-label small fw-semibold text-primary mb-2 d-flex align-items-center gap-1">
                        <i class="bi bi-ui-radios"></i>
                        <span>Các phương án trả lời (Tích chọn radio vào đáp án đúng):</span>
                    </label>

                    <div id="optionsContainer">
                        <!-- Option A -->
                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden" id="optGroupA">
                            <div class="input-group-text bg-white border-end-0">
                                <input class="form-check-input mt-0" type="radio" name="correctOption" value="0" checked title="Chọn làm đáp án đúng">
                            </div>
                            <span class="input-group-text bg-light fw-bold text-primary border-start-0 border-end-0" style="min-width: 40px; justify-content: center;">A</span>
                            <input type="text" name="optionText" id="optTextA" class="form-control border-start-0" placeholder="Nhập nội dung đáp án A..." required>
                        </div>

                        <!-- Option B -->
                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden" id="optGroupB">
                            <div class="input-group-text bg-white border-end-0">
                                <input class="form-check-input mt-0" type="radio" name="correctOption" value="1" title="Chọn làm đáp án đúng">
                            </div>
                            <span class="input-group-text bg-light fw-bold text-primary border-start-0 border-end-0" style="min-width: 40px; justify-content: center;">B</span>
                            <input type="text" name="optionText" id="optTextB" class="form-control border-start-0" placeholder="Nhập nội dung đáp án B..." required>
                        </div>

                        <!-- Option C -->
                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden" id="optGroupC">
                            <div class="input-group-text bg-white border-end-0">
                                <input class="form-check-input mt-0" type="radio" name="correctOption" value="2" title="Chọn làm đáp án đúng">
                            </div>
                            <span class="input-group-text bg-light fw-bold text-primary border-start-0 border-end-0" style="min-width: 40px; justify-content: center;">C</span>
                            <input type="text" name="optionText" id="optTextC" class="form-control border-start-0" placeholder="Nhập nội dung đáp án C (tùy chọn)...">
                        </div>

                        <!-- Option D -->
                        <div class="mb-3 input-group shadow-sm rounded-3 overflow-hidden" id="optGroupD">
                            <div class="input-group-text bg-white border-end-0">
                                <input class="form-check-input mt-0" type="radio" name="correctOption" value="3" title="Chọn làm đáp án đúng">
                            </div>
                            <span class="input-group-text bg-light fw-bold text-primary border-start-0 border-end-0" style="min-width: 40px; justify-content: center;">D</span>
                            <input type="text" name="optionText" id="optTextD" class="form-control border-start-0" placeholder="Nhập nội dung đáp án D (tùy chọn)...">
                        </div>
                    </div>
                </div>

                <div class="modal-footer py-2.5 px-4 bg-light border-top">
                    <button type="button" class="btn btn-secondary btn-sm fw-semibold rounded-3" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary btn-sm fw-semibold rounded-3 px-3 shadow-sm">
                        <i class="bi bi-save me-1"></i>Tạo câu hỏi và gán vào bài thi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ======================================================= -->
<!-- MODAL 3: CẬP NHẬT ĐIỂM SỐ CỦA CÂU HỎI TRONG BÀI THI     -->
<!-- ======================================================= -->
<div class="modal fade" id="editPointsModal" tabindex="-1" aria-labelledby="editPointsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <form action="${pageContext.request.contextPath}/quizzes/assign-question" method="POST">
                <input type="hidden" name="quizId" value="${quiz.id}">
                <input type="hidden" name="questionId" id="editModalQuestionId" value="">
                <c:if test="${not empty courseId}">
                    <input type="hidden" name="courseId" value="${courseId}">
                </c:if>
                <input type="hidden" name="order" id="editModalOrder" value="0">

                <div class="modal-header py-3 px-3 bg-light border-bottom">
                    <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2" id="editPointsModalLabel">
                        <span class="text-primary"><i class="bi bi-award"></i></span>
                        Cập nhật điểm câu hỏi
                    </h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-3">
                    <div class="p-2.5 rounded-3 bg-light border mb-3 small text-muted text-truncate" id="editModalQuestionText"></div>
                    <label class="form-label small fw-semibold text-secondary">Điểm số trong bài thi này</label>
                    <div class="input-group">
                        <input type="number" step="0.5" min="0.5" name="points" id="editModalPoints" class="form-control rounded-start-3" required>
                        <span class="input-group-text bg-light text-muted rounded-end-3">điểm</span>
                    </div>
                    <div class="form-text small text-muted mt-1">Điểm này chỉ áp dụng cho bài thi này.</div>
                </div>

                <div class="modal-footer py-2 px-3 bg-light border-top">
                    <button type="button" class="btn btn-secondary btn-sm fw-semibold rounded-3" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary btn-sm fw-semibold rounded-3 px-3">Lưu điểm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ======================================================= -->
<!-- MODAL 4: XÁC NHẬN XÓA BÀI THI                            -->
<!-- ======================================================= -->
<div class="modal fade" id="deleteQuizModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-body text-center p-4">
                <div class="bg-danger-subtle text-danger rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px; font-size: 1.75rem;">
                    <i class="bi bi-trash3-fill"></i>
                </div>
                <h5 class="fw-bold text-dark mb-1">Xác nhận xóa bài thi?</h5>
                <p class="small text-muted mb-4">
                    Thao tác này sẽ xóa bài thi <strong>"${quiz.title}"</strong>. Các câu hỏi trong ngân hàng vẫn được giữ nguyên an toàn.
                </p>
                <div class="d-flex justify-content-center gap-2">
                    <button type="button" class="btn btn-secondary btn-sm fw-semibold rounded-3 px-3" data-bs-dismiss="modal">Hủy</button>
                    <c:url var="deleteQuizUrl" value="/quizzes/delete">
                        <c:param name="id" value="${quiz.id}"/>
                        <c:if test="${not empty courseId}">
                            <c:param name="courseId" value="${courseId}"/>
                        </c:if>
                        <c:if test="${empty courseId}">
                            <c:param name="moduleId" value="${quiz.moduleId}"/>
                        </c:if>
                    </c:url>
                    <a href="${deleteQuizUrl}" class="btn btn-danger btn-sm fw-semibold rounded-3 px-3">
                        <i class="bi bi-trash3 me-1"></i>Xóa bài thi
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 1. Preset helpers for Pass Score and Time Limit
    function setPassScorePreset(val) {
        const input = document.getElementById('passScoreInput');
        if (input) {
            input.value = val;
            updateCalculatedPassPoints();
        }
    }

    function setTimeLimitPreset(val) {
        const input = document.getElementById('timeLimitInput');
        if (input) {
            input.value = val;
        }
    }

    function updateCalculatedPassPoints() {
        const passScoreInput = document.getElementById('passScoreInput');
        const textElem = document.getElementById('calculatedPassPointsText');
        const totalPoints = parseFloat("${quiz.totalPoints}") || 0;
        if (passScoreInput && textElem && totalPoints > 0) {
            const pct = parseFloat(passScoreInput.value) || 0;
            const pts = (totalPoints * pct / 100).toFixed(1);
            textElem.textContent = pts + " / " + totalPoints + " đ";
        }
    }

    const passInput = document.getElementById('passScoreInput');
    if (passInput) {
        passInput.addEventListener('input', updateCalculatedPassPoints);
    }

    // 2. Open Edit Points Modal
    function openEditPointsModal(questionId, order, points, questionText) {
        document.getElementById('editModalQuestionId').value = questionId;
        document.getElementById('editModalOrder').value = order || 0;
        document.getElementById('editModalPoints').value = points;
        document.getElementById('editModalQuestionText').textContent = questionText;
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('editPointsModal'));
        modal.show();
    }

    // 3. Dynamic adjustment for New Question Modal (Single Choice vs True/False)
    function handleQuestionTypeChange(type) {
        const optC = document.getElementById('optGroupC');
        const optD = document.getElementById('optGroupD');
        const textA = document.getElementById('optTextA');
        const textB = document.getElementById('optTextB');

        if (type === 'TRUE_FALSE') {
            if (optC) optC.style.display = 'none';
            if (optD) optD.style.display = 'none';
            if (textA) textA.value = 'Đúng (True)';
            if (textB) textB.value = 'Sai (False)';
        } else {
            if (optC) optC.style.display = 'flex';
            if (optD) optD.style.display = 'flex';
            if (textA && textA.value === 'Đúng (True)') textA.value = '';
            if (textB && textB.value === 'Sai (False)') textB.value = '';
        }
    }

    // 4. Live Search & Filter for Quiz Questions (Right Column)
    const quizSearchInput = document.getElementById('quizQuestionSearchInput');
    const quizTypeFilter = document.getElementById('quizQuestionTypeFilter');
    const clearSearchBtn = document.getElementById('clearQuizSearchBtn');
    const questionCards = document.querySelectorAll('.question-item-card');
    const noMatchNotice = document.getElementById('noQuizQuestionMatchNotice');
    const countBadge = document.getElementById('renderedQuestionsCount');

    function filterQuizQuestions() {
        if (!questionCards || questionCards.length === 0) return;

        const term = quizSearchInput ? quizSearchInput.value.trim().toLowerCase() : '';
        const selectedType = quizTypeFilter ? quizTypeFilter.value : 'ALL';

        if (clearSearchBtn) {
            clearSearchBtn.style.display = term.length > 0 ? 'inline-block' : 'none';
        }

        let visibleCount = 0;
        questionCards.forEach(card => {
            const cardText = card.getAttribute('data-question-text') || '';
            const cardType = card.getAttribute('data-question-type') || '';

            const matchText = (term === '' || cardText.includes(term));
            const matchType = (selectedType === 'ALL' || cardType === selectedType);

            if (matchText && matchType) {
                card.style.display = '';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        if (countBadge) {
            countBadge.textContent = visibleCount;
        }

        if (noMatchNotice) {
            if (visibleCount === 0) {
                noMatchNotice.classList.remove('d-none');
            } else {
                noMatchNotice.classList.add('d-none');
            }
        }
    }

    function clearQuizQuestionSearch() {
        if (quizSearchInput) quizSearchInput.value = '';
        if (quizTypeFilter) quizTypeFilter.value = 'ALL';
        filterQuizQuestions();
    }

    if (quizSearchInput) {
        quizSearchInput.addEventListener('input', filterQuizQuestions);
    }
    if (quizTypeFilter) {
        quizTypeFilter.addEventListener('change', filterQuizQuestions);
    }

    // 5. Live Search & Filter for Bank Questions (Inside Modal 1)
    const bankSearchInput = document.getElementById('bankSearchInput');
    const bankStatusFilter = document.getElementById('bankStatusFilter');
    const bankRows = document.querySelectorAll('.bank-question-row');

    function filterBankQuestions() {
        if (!bankRows || bankRows.length === 0) return;

        const term = bankSearchInput ? bankSearchInput.value.trim().toLowerCase() : '';
        const filterStatus = bankStatusFilter ? bankStatusFilter.value : 'ALL';

        bankRows.forEach(row => {
            const rowText = row.getAttribute('data-bank-text') || '';
            const isAssigned = row.getAttribute('data-bank-assigned') === 'true';

            const matchText = (term === '' || rowText.includes(term));
            let matchStatus = true;
            if (filterStatus === 'UNASSIGNED') {
                matchStatus = !isAssigned;
            } else if (filterStatus === 'ASSIGNED') {
                matchStatus = isAssigned;
            }

            if (matchText && matchStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    if (bankSearchInput) {
        bankSearchInput.addEventListener('input', filterBankQuestions);
    }
    if (bankStatusFilter) {
        bankStatusFilter.addEventListener('change', filterBankQuestions);
    }

    // 6. Client boundary validation for BUG_QUIZ_01 and BUG_QUIZ_02
    const quizForm = document.getElementById('quizSettingsForm');
    if (quizForm) {
        quizForm.addEventListener('submit', function(e) {
            const passScore = parseFloat(document.getElementById('passScoreInput').value);
            if (isNaN(passScore) || passScore < 0 || passScore > 100) {
                e.preventDefault();
                alert('Tỉ lệ đạt tối thiểu (%) phải nằm trong khoảng từ 0% đến 100%.');
            }
        });
    }

    const newQForm = document.getElementById('newQuestionForm');
    if (newQForm) {
        newQForm.addEventListener('submit', function(e) {
            const ptsInput = document.getElementById('newQuestionPointsInput');
            if (ptsInput) {
                const pts = parseFloat(ptsInput.value);
                if (isNaN(pts) || pts <= 0) {
                    e.preventDefault();
                    alert('Điểm số của câu hỏi phải lớn hơn 0.');
                }
            }
        });
    }
</script>

<jsp:include page="../common/footer.jsp" />
