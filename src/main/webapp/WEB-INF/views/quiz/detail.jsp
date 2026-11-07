<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

                <c:set var="pageTitle" value="${quiz.title} - Quản lý bài thi - Courson LMS" />
                <jsp:include page="../common/header.jsp" />

                <style>
                    /* ==========================================================================
   MODERN SAAS DESIGN SYSTEM (Synchronized with Expert Studio & Lesson List)
   ========================================================================== */
                    :root {
                        --saas-bg: #f8fafc;
                        --saas-card-bg: #ffffff;
                        --saas-border: #e2e8f0;
                        --saas-border-subtle: #f1f5f9;
                        --saas-text-heading: #0f172a;
                        --saas-text-body: #334155;
                        --saas-text-muted: #64748b;
                        --saas-primary: #0f172a;
                        --saas-primary-hover: #1e293b;
                        --saas-accent: #2563eb;
                        --saas-accent-hover: #1d4ed8;
                        --saas-radius-sm: 6px;
                        --saas-radius-md: 10px;
                        --saas-radius-lg: 14px;
                        --saas-radius-xl: 18px;
                        --saas-shadow-xs: 0 1px 2px 0 rgba(0, 0, 0, 0.03);
                        --saas-shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.06), 0 1px 2px -1px rgba(0, 0, 0, 0.04);
                        --saas-shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.06), 0 2px 4px -2px rgba(0, 0, 0, 0.04);
                    }

                    body {
                        background-color: var(--saas-bg);
                        color: var(--saas-text-body);
                    }

                    /* Breadcrumbs */
                    .saas-breadcrumb {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        font-size: 0.8125rem;
                        color: var(--saas-text-muted);
                        margin-bottom: 16px;
                    }

                    .saas-breadcrumb a {
                        color: var(--saas-text-muted);
                        text-decoration: none;
                        transition: color 0.15s ease;
                    }

                    .saas-breadcrumb a:hover {
                        color: var(--saas-text-heading);
                    }

                    .saas-breadcrumb .separator {
                        color: #cbd5e1;
                        font-size: 0.75rem;
                    }

                    .saas-breadcrumb .current {
                        color: var(--saas-text-heading);
                        font-weight: 500;
                    }

                    /* Page Header */
                    .saas-header {
                        display: flex;
                        flex-wrap: wrap;
                        justify-content: space-between;
                        align-items: center;
                        gap: 16px;
                        margin-bottom: 24px;
                    }

                    .saas-title {
                        font-size: 1.5rem;
                        font-weight: 700;
                        letter-spacing: -0.025em;
                        color: var(--saas-text-heading);
                        margin: 0;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .saas-subtitle {
                        font-size: 0.875rem;
                        color: var(--saas-text-muted);
                        margin-top: 4px;
                        margin-bottom: 0;
                    }

                    /* Icons */
                    .saas-stat-icon {
                        width: 36px;
                        height: 36px;
                        border-radius: var(--saas-radius-md);
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.125rem;
                    }

                    .saas-icon-blue {
                        background: #eff6ff;
                        color: #2563eb;
                    }

                    .saas-icon-emerald {
                        background: #ecfdf5;
                        color: #059669;
                    }

                    .saas-icon-amber {
                        background: #fffbeb;
                        color: #d97706;
                    }

                    .saas-icon-slate {
                        background: #f1f5f9;
                        color: #475569;
                    }

                    /* SaaS Cards */
                    .saas-card {
                        background: var(--saas-card-bg);
                        border: 1px solid var(--saas-border);
                        border-radius: var(--saas-radius-lg);
                        box-shadow: var(--saas-shadow-sm);
                        overflow: hidden;
                    }

                    /* Sticky sidebar */
                    .sticky-config-sidebar {
                        position: sticky;
                        top: 1.5rem;
                        z-index: 10;
                    }

                    /* Preset Pills */
                    .preset-pill {
                        cursor: pointer;
                        font-size: 0.75rem;
                        font-weight: 500;
                        padding: 3px 10px;
                        border-radius: 9999px;
                        border: 1px solid var(--saas-border);
                        background-color: #ffffff;
                        color: var(--saas-text-body);
                        transition: all 0.15s ease;
                        user-select: none;
                    }

                    .preset-pill:hover {
                        background-color: #eff6ff;
                        border-color: #bfdbfe;
                        color: var(--saas-accent);
                    }

                    /* Question Item Card */
                    .question-item-card {
                        border: 1px solid var(--saas-border);
                        border-radius: var(--saas-radius-lg);
                        background: #ffffff;
                        transition: border-color 0.15s ease, box-shadow 0.15s ease;
                    }

                    .question-item-card:hover {
                        border-color: #cbd5e1;
                        box-shadow: var(--saas-shadow-md);
                    }

                    /* Modern Points Editor Pill */
                    .points-editor-pill {
                        display: inline-flex;
                        align-items: center;
                        background: #f8fafc;
                        border: 1px solid var(--saas-border);
                        border-radius: 9999px;
                        padding: 2px 6px 2px 10px;
                        gap: 4px;
                        transition: all 0.15s ease;
                        height: 30px;
                    }

                    .points-editor-pill:hover {
                        background: #ffffff;
                        border-color: #cbd5e1;
                    }

                    .points-editor-pill:focus-within {
                        background: #ffffff;
                        border-color: var(--saas-accent);
                        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
                    }

                    .points-editor-pill .points-icon {
                        color: #f59e0b;
                        font-size: 0.875rem;
                        display: flex;
                        align-items: center;
                    }

                    .points-editor-pill input.points-inline-input {
                        width: 44px;
                        height: 22px;
                        padding: 0;
                        border: none;
                        background: transparent;
                        font-weight: 700;
                        font-size: 0.85rem;
                        text-align: center;
                        color: var(--saas-text-heading);
                        outline: none;
                        -moz-appearance: textfield;
                        appearance: textfield;
                    }

                    .points-editor-pill input.points-inline-input::-webkit-outer-spin-button,
                    .points-editor-pill input.points-inline-input::-webkit-inner-spin-button {
                        -webkit-appearance: none;
                        margin: 0;
                    }

                    .points-editor-pill .points-unit {
                        font-size: 0.75rem;
                        font-weight: 600;
                        color: var(--saas-text-muted);
                        margin-right: 2px;
                    }

                    .points-editor-pill .btn-save-point {
                        width: 22px;
                        height: 22px;
                        border-radius: 50%;
                        border: none;
                        padding: 0;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 0.75rem;
                        background: #e2e8f0;
                        color: #64748b;
                        cursor: pointer;
                        transition: all 0.15s ease;
                    }

                    .points-editor-pill .btn-save-point:hover {
                        background: #059669;
                        color: #ffffff;
                        transform: scale(1.1);
                    }

                    .points-editor-pill .btn-save-point.is-dirty {
                        background: #059669 !important;
                        color: #ffffff !important;
                        box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.35);
                        animation: pulseSaveBtn 1.5s infinite;
                    }

                    @keyframes pulseSaveBtn {

                        0%,
                        100% {
                            transform: scale(1);
                        }

                        50% {
                            transform: scale(1.15);
                        }
                    }

                    /* Option Cards */
                    .option-card {
                        border-radius: 8px;
                        padding: 10px 14px;
                        border: 1px solid var(--saas-border);
                        background-color: #f8fafc;
                        font-size: 0.875rem;
                        display: flex;
                        align-items: center;
                        gap: 8px;
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

                    /* Bank questions list */
                    .bank-question-row {
                        border: 1px solid var(--saas-border);
                        border-radius: var(--saas-radius-md);
                        transition: background-color 0.15s ease, border-color 0.15s ease;
                    }

                    .bank-question-row:hover {
                        border-color: #cbd5e1;
                        background-color: #f8fafc;
                    }

                    .search-filter-box {
                        background: #f8fafc;
                        border-radius: var(--saas-radius-md);
                        border: 1px solid var(--saas-border);
                        padding: 12px 16px;
                    }

                    /* Buttons */
                    .btn-saas-primary {
                        background: #0f172a;
                        color: #ffffff;
                        border: 1px solid #0f172a;
                        font-weight: 600;
                        font-size: 0.8125rem;
                        padding: 7px 14px;
                        border-radius: 8px;
                        transition: all 0.15s ease;
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        text-decoration: none;
                        box-shadow: var(--saas-shadow-xs);
                        cursor: pointer;
                    }

                    .btn-saas-primary:hover {
                        background: #1e293b;
                        color: #ffffff;
                        border-color: #1e293b;
                    }

                    .btn-saas-outline {
                        background: #ffffff;
                        color: #334155;
                        border: 1px solid var(--saas-border);
                        font-weight: 500;
                        font-size: 0.8125rem;
                        padding: 7px 14px;
                        border-radius: 8px;
                        transition: all 0.15s ease;
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        text-decoration: none;
                        box-shadow: var(--saas-shadow-xs);
                        cursor: pointer;
                    }

                    .btn-saas-outline:hover {
                        background: #f8fafc;
                        color: #0f172a;
                        border-color: #cbd5e1;
                    }

                    .btn-saas-outline-emerald {
                        background: #ffffff;
                        color: #059669;
                        border: 1px solid #a7f3d0;
                        font-weight: 600;
                        font-size: 0.8125rem;
                        padding: 7px 14px;
                        border-radius: 8px;
                        transition: all 0.15s ease;
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        text-decoration: none;
                        cursor: pointer;
                    }

                    .btn-saas-outline-emerald:hover {
                        background: #ecfdf5;
                        color: #047857;
                        border-color: #6ee7b7;
                    }

                    .btn-icon-action {
                        width: 32px;
                        height: 32px;
                        border-radius: 8px;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        border: 1px solid var(--saas-border);
                        background: #ffffff;
                        color: #64748b;
                        transition: all 0.15s ease;
                        cursor: pointer;
                        font-size: 0.875rem;
                        text-decoration: none;
                    }

                    .btn-icon-action:hover {
                        background: #f1f5f9;
                        color: #0f172a;
                        border-color: #cbd5e1;
                    }

                    .btn-icon-action.text-danger:hover {
                        background: #fef2f2;
                        color: #dc2626 !important;
                        border-color: #fecaca;
                    }

                    /* Status Badges */
                    .saas-badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 4px 10px;
                        border-radius: 9999px;
                        font-size: 0.75rem;
                        font-weight: 600;
                        letter-spacing: 0.02em;
                        white-space: nowrap;
                    }

                    .badge-dot {
                        width: 6px;
                        height: 6px;
                        border-radius: 50%;
                    }

                    .saas-badge-published {
                        background: #ecfdf5;
                        color: #065f46;
                        border: 1px solid #a7f3d0;
                    }

                    .saas-badge-published .badge-dot {
                        background: #10b981;
                    }

                    .saas-badge-pending {
                        background: #fffbeb;
                        color: #92400e;
                        border: 1px solid #fde68a;
                    }

                    .saas-badge-pending .badge-dot {
                        background: #f59e0b;
                    }

                    .saas-badge-draft {
                        background: #f1f5f9;
                        color: #334155;
                        border: 1px solid #cbd5e1;
                    }

                    .saas-badge-draft .badge-dot {
                        background: #64748b;
                    }

                    .saas-badge-blue {
                        background: #eff6ff;
                        color: #1d4ed8;
                        border: 1px solid #bfdbfe;
                    }

                    .saas-badge-blue .badge-dot {
                        background: #2563eb;
                    }

                    /* Modals */
                    .modal-content.saas-modal {
                        border-radius: 16px;
                        border: 1px solid var(--saas-border);
                        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
                        overflow: hidden;
                    }

                    .modal-header.saas-modal-header {
                        background: #ffffff;
                        border-bottom: 1px solid var(--saas-border);
                        padding: 18px 24px;
                    }

                    .modal-footer.saas-modal-footer {
                        background: #f8fafc;
                        border-top: 1px solid var(--saas-border);
                        padding: 14px 24px;
                    }

                    .saas-form-label {
                        font-size: 0.8125rem;
                        font-weight: 600;
                        color: #334155;
                        margin-bottom: 6px;
                    }

                    .saas-form-control {
                        border: 1px solid #cbd5e1;
                        border-radius: 8px;
                        font-size: 0.875rem;
                        padding: 8px 12px;
                        transition: all 0.15s ease;
                    }

                    .saas-form-control:focus {
                        border-color: var(--saas-accent);
                        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
                    }

                    /* Alerts */
                    .saas-alert {
                        border-radius: var(--saas-radius-md);
                        padding: 14px 18px;
                        font-size: 0.875rem;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        margin-bottom: 20px;
                        box-shadow: var(--saas-shadow-xs);
                    }

                    .saas-alert-success {
                        background: #f0fdf4;
                        border: 1px solid #bbf7d0;
                        color: #166534;
                    }

                    .saas-alert-danger {
                        background: #fef2f2;
                        border: 1px solid #fecaca;
                        color: #991b1b;
                    }
                </style>

                <main class="main-content py-4">
                    <div class="container">

                        <!-- Modern SaaS Breadcrumb Navigation -->
                        <nav class="saas-breadcrumb" aria-label="breadcrumb">
                            <a href="${pageContext.request.contextPath}/expert/dashboard">
                                <i class="bi bi-mortarboard-fill me-1 text-primary"></i>Expert Studio
                            </a>
                            <span class="separator">/</span>
                            <c:if test="${not empty course}">
                                <a href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}">
                                    ${course.title}
                                </a>
                                <span class="separator">/</span>
                            </c:if>
                            <c:if test="${not empty currentModule}">
                                <span class="text-muted">Chương ${currentModule.orderIndex}</span>
                                <span class="separator">/</span>
                            </c:if>
                            <span class="current">${quiz.title}</span>
                        </nav>

                        <!-- System Alerts -->
                        <c:if test="${not empty param.success}">
                            <div class="saas-alert saas-alert-success alert-dismissible fade show" role="alert">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="bi bi-check-circle-fill fs-5"></i>
                                    <div>
                                        <c:choose>
                                            <c:when test="${param.success == 'saved'}">Đã lưu và cập nhật cấu hình bài
                                                kiểm tra.</c:when>
                                            <c:when test="${param.success == 'assigned'}">Đã cập nhật câu hỏi / điểm số
                                                trong bài thi thành công.</c:when>
                                            <c:when test="${param.success == 'removed'}">Đã gỡ câu hỏi khỏi bài thi (câu
                                                hỏi vẫn nằm trong Ngân hàng).</c:when>
                                            <c:when test="${param.success == 'question_created_and_assigned'}">Đã tạo
                                                câu hỏi mới và tự động gán vào bài kiểm tra.</c:when>
                                            <c:when test="${param.success == 'activated'}">Đã kích hoạt hiển thị bài thi cho học viên.</c:when>
                                            <c:when test="${param.success == 'deactivated'}">Đã ẩn bài thi đối với học viên.</c:when>
                                            <c:otherwise>Thao tác đã được hoàn tất thành công.</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty param.error or not empty error}">
                            <div class="saas-alert saas-alert-danger alert-dismissible fade show" role="alert">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                                    <div>
                                        <c:out value="${not empty param.error ? param.error : error}" />
                                    </div>
                                </div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Header Top Bar -->
                        <div class="saas-header">
                            <div>
                                <div class="d-flex align-items-center gap-2 mb-1">
                                    <c:if test="${not empty currentModule}">
                                        <span class="badge bg-light text-dark border fw-semibold">Chương
                                            ${currentModule.orderIndex}</span>
                                    </c:if>
                                    <c:choose>
                                        <c:when test="${quiz.active}">
                                            <span class="badge bg-success-subtle text-success border border-success-subtle fw-semibold">
                                                <i class="bi bi-eye-fill me-1"></i>Đang hiển thị
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle fw-semibold">
                                                <i class="bi bi-eye-slash-fill me-1"></i>Đang ẩn
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    <h1 class="saas-title">
                                        <span class="saas-stat-icon saas-icon-blue"
                                            style="width: 36px; height: 36px; border-radius: 10px;">
                                            <i class="bi bi-patch-question-fill"></i>
                                        </span>
                                        <span>
                                            <c:out value="${quiz.title}" />
                                        </span>
                                    </h1>
                                </div>
                                <p class="saas-subtitle">
                                    Quản lý cấu hình bài kiểm tra trắc nghiệm và danh sách câu hỏi
                                </p>
                            </div>

                            <div class="d-flex align-items-center gap-2">
                                <a href="${pageContext.request.contextPath}/quizzes/toggle-active?id=${quiz.id}&courseId=${courseId}&from=detail"
                                   class="btn ${quiz.active ? 'btn-outline-secondary' : 'btn-outline-success'} btn-sm fw-medium d-inline-flex align-items-center gap-1.5"
                                   title="${quiz.active ? 'Tạm ẩn bài thi đối với học viên' : 'Hiển thị bài thi cho học viên làm bài'}">
                                    <i class="bi ${quiz.active ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                    <span>${quiz.active ? 'Ẩn với học viên' : 'Hiện cho học viên'}</span>
                                </a>
                                <c:url var="backQuizListUrl" value="/quizzes/list">
                                    <c:if test="${not empty courseId}">
                                        <c:param name="courseId" value="${courseId}" />
                                    </c:if>
                                </c:url>
                                <a href="${backQuizListUrl}" class="btn-saas-outline">
                                    <i class="bi bi-arrow-left me-1"></i>Danh sách Quiz
                                </a>
                            </div>
                        </div>

                        <!-- Main Content Area: 2 Columns Layout -->
                        <div class="row g-4">

                            <!-- LEFT COLUMN: Quiz Settings & Actions (col-lg-4) -->
                            <div class="col-lg-4">
                                <div class="sticky-config-sidebar d-flex flex-column gap-4">

                                    <!-- Form Card: Cấu hình bài thi -->
                                    <div class="saas-card p-4">
                                        <div
                                            class="d-flex align-items-center justify-content-between pb-3 mb-3 border-bottom">
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="saas-stat-icon saas-icon-blue"
                                                    style="width: 32px; height: 32px; border-radius: 8px;">
                                                    <i class="bi bi-sliders"></i>
                                                </span>
                                                <h5 class="fw-bold mb-0 text-dark">Cấu hình bài thi</h5>
                                            </div>
                                        </div>

                                        <form action="${pageContext.request.contextPath}/quizzes/save" method="POST"
                                            id="quizSettingsForm">
                                            <input type="hidden" name="from" value="detail">
                                            <input type="hidden" name="id" value="${quiz.id}">
                                            <input type="hidden" name="moduleId" value="${quiz.moduleId}">
                                            <c:if test="${not empty courseId}">
                                                <input type="hidden" name="courseId" value="${courseId}">
                                            </c:if>

                                            <!-- Module (Fixed) -->
                                            <c:if test="${not empty currentModule}">
                                                <div class="mb-3">
                                                    <label
                                                        class="saas-form-label d-flex align-items-center justify-content-between">
                                                        <span>Thuộc chương học</span>
                                                        <span class="badge bg-light text-muted border fw-normal"
                                                            style="font-size: 0.725rem;">
                                                            <i class="bi bi-lock-fill me-1 text-secondary"></i>Cố định
                                                        </span>
                                                    </label>
                                                    <div class="form-control saas-form-control bg-light text-secondary d-flex align-items-center gap-2 py-2"
                                                        style="cursor: not-allowed;">
                                                        <i class="bi bi-folder2-open text-primary"></i>
                                                        <span class="text-truncate fw-medium text-dark">
                                                            Chương ${currentModule.orderIndex}:
                                                            <c:out value="${currentModule.title}" />
                                                        </span>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <!-- Quiz Title -->
                                            <div class="mb-3">
                                                <label class="saas-form-label">
                                                    Tên bài thi <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" name="title" class="form-control saas-form-control"
                                                    value="${quiz.title}" required
                                                    placeholder="Ví dụ: Quiz 1 - Khái niệm cơ bản...">
                                            </div>

                                            <!-- Pass Score with Quick Presets -->
                                            <div class="mb-3">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <label class="saas-form-label mb-0">
                                                        Tỉ lệ đạt tối thiểu (%) <span class="text-danger">*</span>
                                                    </label>
                                                    <span class="text-muted small"
                                                        id="calculatedPassPointsText">${quiz.passingPoints} /
                                                        ${quiz.totalPoints} đ</span>
                                                </div>
                                                <div class="input-group">
                                                    <input type="number" id="passScoreInput" name="passScore"
                                                        class="form-control saas-form-control rounded-start-3"
                                                        value="${quiz.passScore}" min="0" max="100" step="1" required>
                                                    <span class="input-group-text bg-light text-muted fw-bold">%</span>
                                                </div>
                                                <!-- Preset Pills -->
                                                <div class="d-flex flex-wrap gap-1 mt-2">
                                                    <span class="preset-pill"
                                                        onclick="setPassScorePreset(40)">40%</span>
                                                    <span class="preset-pill"
                                                        onclick="setPassScorePreset(50)">50%</span>
                                                    <span class="preset-pill"
                                                        onclick="setPassScorePreset(60)">60%</span>
                                                    <span class="preset-pill"
                                                        onclick="setPassScorePreset(70)">70%</span>
                                                    <span class="preset-pill"
                                                        onclick="setPassScorePreset(80)">80%</span>
                                                </div>
                                                <div class="form-text small text-muted mt-1">
                                                    Nhập giá trị từ 0 đến 100%. Học viên cần đạt tỉ lệ này để vượt qua
                                                    bài thi.
                                                </div>
                                            </div>

                                            <!-- Time Limit with Presets -->
                                            <div class="mb-3">
                                                <label class="saas-form-label">
                                                    Thời lượng thi (Phút)
                                                </label>
                                                <div class="input-group">
                                                    <input type="number" id="timeLimitInput" name="timeLimitMinutes"
                                                        class="form-control saas-form-control rounded-start-3"
                                                        value="${quiz.timeLimitMinutes}" min="0"
                                                        placeholder="Để trống nếu không giới hạn">
                                                    <span class="input-group-text bg-light text-muted">phút</span>
                                                </div>
                                                <!-- Preset Pills -->
                                                <div class="d-flex flex-wrap gap-1 mt-2">
                                                    <span class="preset-pill" onclick="setTimeLimitPreset('')">Không
                                                        giới hạn</span>
                                                    <span class="preset-pill" onclick="setTimeLimitPreset(15)">15
                                                        phút</span>
                                                    <span class="preset-pill" onclick="setTimeLimitPreset(30)">30
                                                        phút</span>
                                                    <span class="preset-pill" onclick="setTimeLimitPreset(45)">45
                                                        phút</span>
                                                    <span class="preset-pill" onclick="setTimeLimitPreset(60)">60
                                                        phút</span>
                                                </div>
                                                <div class="form-text small text-muted mt-1">
                                                    Để trống hoặc nhập 0 để làm bài không giới hạn thời gian.
                                                </div>
                                            </div>

                                            <!-- Order Index -->
                                            <div class="mb-3">
                                                <label class="saas-form-label">
                                                    Thứ tự hiển thị trong chương <span class="text-danger">*</span>
                                                </label>
                                                <input type="number" name="orderIndex"
                                                    class="form-control saas-form-control" value="${quiz.orderIndex}"
                                                    min="1" required>
                                            </div>

                                            <!-- Active Status Switch -->
                                            <div class="mb-4 p-3 bg-light rounded-3 border">
                                                <div class="form-check form-switch d-flex align-items-center justify-content-between ps-0 mb-1">
                                                    <label class="form-check-label fw-semibold text-dark mb-0 cursor-pointer" for="quizActiveSwitch">
                                                        <i class="bi ${quiz.active ? 'bi-eye-fill text-success' : 'bi-eye-slash-fill text-secondary'} me-1.5"></i>
                                                        Hiển thị cho học viên
                                                    </label>
                                                    <input class="form-check-input ms-0" type="checkbox" role="switch" id="quizActiveSwitch" name="active" value="true" ${quiz.active ? 'checked' : ''} style="cursor: pointer; width: 2.25em; height: 1.25em;">
                                                </div>
                                                <div class="form-text small text-muted" style="font-size: 0.75rem;">
                                                    Khi bật, học viên có thể nhìn thấy và làm bài thi trong khóa học. Khi tắt, chỉ có Expert nhìn thấy đề thi.
                                                </div>
                                            </div>

                                            <button type="submit"
                                                class="btn-saas-primary w-100 justify-content-center py-2.5">
                                                <i class="bi bi-check-lg me-1"></i>Lưu thay đổi cấu hình
                                            </button>
                                        </form>
                                    </div>

                                    <!-- Meta Information & Secondary Actions -->
                                    <div class="saas-card p-4">
                                        <h6
                                            class="fw-bold mb-3 text-secondary text-uppercase small d-flex align-items-center gap-2">
                                            <i class="bi bi-info-circle-fill text-primary"></i>Thông tin liên kết
                                        </h6>

                                        <div class="d-flex flex-column gap-2 small">
                                            <div
                                                class="d-flex justify-content-between align-items-center py-1 border-bottom">
                                                <span class="text-muted">Mã Quiz ID:</span>
                                                <span class="fw-semibold text-dark">#${quiz.id}</span>
                                            </div>
                                            <div
                                                class="d-flex justify-content-between align-items-center py-1 border-bottom">
                                                <span class="text-muted">Trạng thái:</span>
                                                <c:choose>
                                                    <c:when test="${quiz.active}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle fw-semibold">
                                                            <i class="bi bi-eye-fill me-1"></i>Đang hiển thị
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle fw-semibold">
                                                            <i class="bi bi-eye-slash-fill me-1"></i>Đang ẩn
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <c:if test="${not empty currentModule}">
                                                <div
                                                    class="d-flex justify-content-between align-items-center py-1 border-bottom">
                                                    <span class="text-muted">Chương học:</span>
                                                    <span class="fw-semibold text-end text-truncate"
                                                        style="max-width: 180px;" title="${currentModule.title}">
                                                        ${currentModule.title}
                                                    </span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty course}">
                                                <div
                                                    class="d-flex justify-content-between align-items-center py-1 border-bottom">
                                                    <span class="text-muted">Khóa học:</span>
                                                    <span class="fw-semibold text-end text-truncate"
                                                        style="max-width: 180px;" title="${course.title}">
                                                        ${course.title}
                                                    </span>
                                                </div>
                                            </c:if>
                                            <div class="d-flex justify-content-between align-items-center py-1">
                                                <span class="text-muted">Ngân hàng của chương:</span>
                                                <span class="saas-badge saas-badge-blue">
                                                    <span class="badge-dot"></span>${not empty bankQuestions ?
                                                    fn:length(bankQuestions) : 0} câu hỏi có sẵn
                                                </span>
                                            </div>
                                        </div>

                                        <div class="d-grid gap-2 mt-4 pt-3 border-top">
                                            <c:url var="courseQuestionsUrl" value="/quizzes/questions">
                                                <c:if test="${not empty courseId}">
                                                    <c:param name="courseId" value="${courseId}" />
                                                </c:if>
                                            </c:url>
                                            <a href="${courseQuestionsUrl}"
                                                class="btn-saas-outline justify-content-start py-2">
                                                <i class="bi bi-database me-2 text-primary"></i>Xem Ngân hàng câu hỏi
                                            </a>

                                            <c:choose>
                                                <c:when test="${quiz.attemptCount > 0}">
                                                    <button type="button"
                                                        class="btn-saas-outline text-muted justify-content-start py-2"
                                                        title="Đã có ${quiz.attemptCount} lượt làm bài của học viên"
                                                        onclick="alert('Không thể xóa bài kiểm tra vì đã có ${quiz.attemptCount} lượt làm bài của học viên. Hệ thống cần bảo toàn dữ liệu điểm số và tiến độ học tập!');">
                                                        <i class="bi bi-lock-fill me-2 text-warning"></i>Không thể xóa
                                                        (${quiz.attemptCount} lượt thi)
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button"
                                                        class="btn-saas-outline text-danger justify-content-start py-2"
                                                        data-bs-toggle="modal" data-bs-target="#deleteQuizModal">
                                                        <i class="bi bi-trash3 me-2"></i>Xóa bài thi này
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <!-- RIGHT COLUMN: Quiz Questions Management (col-lg-8) -->
                            <div class="col-lg-8">
                                <div class="saas-card">

                                    <!-- Right Column Header -->
                                    <div class="bg-white py-3 px-4 border-bottom">
                                        <div
                                            class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3">
                                            <div>
                                                <h5 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                                                    <span class="text-primary"><i
                                                            class="bi bi-card-checklist"></i></span>
                                                    Danh sách câu hỏi trong bài thi
                                                </h5>
                                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                                    <span class="saas-badge saas-badge-blue">
                                                        <span class="badge-dot"></span><span
                                                            id="renderedQuestionsCount">${not empty quiz.questions ?
                                                            fn:length(quiz.questions) : 0}</span> câu hỏi
                                                    </span>
                                                    <span class="saas-badge saas-badge-published">
                                                        <span class="badge-dot"></span>Tổng: ${quiz.totalPoints} điểm
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="d-flex gap-2">
                                                <c:choose>
                                                    <c:when test="${quiz.attemptCount > 0}">
                                                        <button type="button" class="btn-saas-outline text-muted"
                                                            onclick="alert('Bài kiểm tra đã có ${quiz.attemptCount} lượt làm bài của học viên. Cấu trúc đề thi đã được khóa.');"
                                                            title="Bài thi đã bị khóa vì có lượt làm bài">
                                                            <i class="bi bi-bank me-1"></i>Từ Ngân hàng
                                                        </button>
                                                        <button type="button" class="btn-saas-outline text-muted"
                                                            onclick="alert('Bài kiểm tra đã có ${quiz.attemptCount} lượt làm bài của học viên. Cấu trúc đề thi đã được khóa.');"
                                                            title="Bài thi đã bị khóa vì có lượt làm bài">
                                                            <i class="bi bi-plus-lg me-1"></i>Thêm câu hỏi
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn-saas-outline"
                                                            data-bs-toggle="modal" data-bs-target="#pickFromBankModal">
                                                            <i class="bi bi-bank me-1"></i>Từ Ngân hàng
                                                        </button>
                                                        <button type="button" class="btn-saas-primary"
                                                            data-bs-toggle="modal" data-bs-target="#newQuestionModal">
                                                            <i class="bi bi-plus-lg me-1"></i>Thêm câu hỏi
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <c:if test="${quiz.attemptCount > 0}">
                                            <div
                                                class="alert alert-warning py-2 px-3 small mt-3 mb-0 d-flex align-items-center gap-2">
                                                <i class="bi bi-shield-lock-fill fs-5 text-warning flex-shrink-0"></i>
                                                <div>
                                                    Bài thi này đã có <strong>${quiz.attemptCount}</strong> lượt làm bài
                                                    của học viên. Cấu trúc câu hỏi và thang điểm đã được khóa bảo vệ để
                                                    bảo toàn dữ liệu lịch sử thi.
                                                </div>
                                            </div>
                                        </c:if>

                                        <!-- Live Search & Filter Bar for Assigned Questions -->
                                        <c:if test="${not empty quiz.questions}">
                                            <div class="row g-2 mt-3 pt-3 border-top align-items-center">
                                                <div class="col-sm-7 col-12">
                                                    <div class="input-group input-group-sm">
                                                        <span class="input-group-text bg-light border-end-0 text-muted">
                                                            <i class="bi bi-search"></i>
                                                        </span>
                                                        <input type="text" id="quizQuestionSearchInput"
                                                            class="form-control border-start-0 bg-light"
                                                            placeholder="Tìm câu hỏi trong bài thi...">
                                                        <button class="btn btn-outline-secondary border-start-0"
                                                            type="button" id="clearQuizSearchBtn" style="display:none;"
                                                            onclick="clearQuizQuestionSearch()">
                                                            <i class="bi bi-x"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="col-sm-5 col-12">
                                                    <select id="quizQuestionTypeFilter"
                                                        class="form-select form-select-sm bg-light">
                                                        <option value="ALL">Tất cả dạng câu hỏi</option>
                                                        <option value="SINGLE_CHOICE">1 Đáp án (Single Choice)</option>
                                                        <option value="MULTI_CHOICE">Nhiều đáp án (Multi Choice)
                                                        </option>
                                                        <option value="TRUE_FALSE">Đúng / Sai (True / False)</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Questions List Body -->
                                    <div class="p-4">
                                        <c:choose>
                                            <c:when test="${empty quiz.questions}">
                                                <!-- Empty state -->
                                                <div class="text-center py-5 px-3">
                                                    <div class="bg-light text-muted rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                                                        style="width: 64px; height: 64px;">
                                                        <i class="bi bi-patch-question fs-2"></i>
                                                    </div>
                                                    <h5 class="fw-bold text-dark mb-1">Chưa có câu hỏi nào trong bài thi
                                                        này</h5>
                                                    <p class="text-muted small mb-4 mx-auto" style="max-width: 460px;">
                                                        Bài thi chưa thể cho học viên làm nếu chưa có câu hỏi. Bạn có
                                                        thể chọn các câu hỏi có sẵn từ ngân hàng của chương hoặc tạo câu
                                                        hỏi mới ngay bây giờ.
                                                    </p>
                                                    <div class="d-flex justify-content-center flex-wrap gap-2">
                                                        <button type="button" class="btn-saas-outline"
                                                            data-bs-toggle="modal" data-bs-target="#pickFromBankModal">
                                                            <i class="bi bi-bank me-1"></i>Chọn từ Ngân hàng câu hỏi
                                                        </button>
                                                        <button type="button" class="btn-saas-primary"
                                                            data-bs-toggle="modal" data-bs-target="#newQuestionModal">
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
                                                            data-question-type="${qq.questionType}" data-q-id="${qq.id}"
                                                            data-q-text="${fn:escapeXml(qq.questionText)}"
                                                            data-q-points="${not empty qq.defaultPoints ? qq.defaultPoints : 1}"
                                                            data-q-type="${qq.questionType}">

                                                            <!-- Hidden Options Data for Edit Modal -->
                                                            <div class="d-none question-options-data">
                                                                <c:forEach var="opt" items="${qq.options}">
                                                                    <span class="q-opt-item"
                                                                        data-text="<c:out value='${opt.optionText}' />"
                                                                        data-correct="${opt.correct}"></span>
                                                                </c:forEach>
                                                            </div>

                                                            <!-- Question Card Header -->
                                                            <div
                                                                class="d-flex justify-content-between align-items-center gap-2 mb-3">
                                                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                                                    <!-- Question Index Badge -->
                                                                    <span
                                                                        class="badge bg-light text-dark border px-2.5 py-1.5 fw-bold"
                                                                        style="font-size: 0.8rem;">
                                                                        Câu #${status.index + 1}
                                                                    </span>

                                                                    <!-- Question Type Badge -->
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${qq.questionType == 'SINGLE_CHOICE'}">
                                                                            <span class="saas-badge saas-badge-blue">
                                                                                <span class="badge-dot"></span>1 Đáp án
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${qq.questionType == 'MULTI_CHOICE'}">
                                                                            <span class="saas-badge saas-badge-pending">
                                                                                <span class="badge-dot"></span>Nhiều đáp
                                                                                án
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${qq.questionType == 'TRUE_FALSE'}">
                                                                            <span class="saas-badge saas-badge-draft">
                                                                                <span class="badge-dot"></span>Đúng /
                                                                                Sai
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="saas-badge saas-badge-draft">
                                                                                ${qq.questionType}
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>

                                                                    <c:choose>
                                                                        <c:when test="${quiz.attemptCount > 0}">
                                                                            <div class="points-editor-pill bg-light border"
                                                                                title="Điểm số đã được cố định vì đã có học viên làm bài">
                                                                                <span class="points-icon text-muted"><i
                                                                                        class="bi bi-lock-fill"></i></span>
                                                                                <span
                                                                                    class="px-2 fw-semibold text-secondary">${not
                                                                                    empty qq.assignedPoints ?
                                                                                    qq.assignedPoints : (not empty
                                                                                    qq.points ? qq.points : (not empty
                                                                                    qq.defaultPoints ? qq.defaultPoints
                                                                                    : 1))}</span>
                                                                                <span class="points-unit">đ</span>
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <!-- Inline Points Edit Form -->
                                                                            <form
                                                                                action="${pageContext.request.contextPath}/quizzes/assign-question"
                                                                                method="POST"
                                                                                class="d-inline-flex align-items-center m-0">
                                                                                <input type="hidden" name="quizId"
                                                                                    value="${quiz.id}">
                                                                                <input type="hidden" name="questionId"
                                                                                    value="${qq.id}">
                                                                                <c:if test="${not empty courseId}">
                                                                                    <input type="hidden" name="courseId"
                                                                                        value="${courseId}">
                                                                                </c:if>
                                                                                <input type="hidden" name="order"
                                                                                    value="${qq.quizOrderIndex != null ? qq.quizOrderIndex : 0}">
                                                                                <div class="points-editor-pill"
                                                                                    title="Điểm số trong bài thi (nhấp để sửa, bấm ✓ hoặc Enter để lưu)">
                                                                                    <span class="points-icon"><i
                                                                                            class="bi bi-award-fill"></i></span>
                                                                                    <input type="number" step="0.5"
                                                                                        min="0.5" name="points"
                                                                                        value="${not empty qq.assignedPoints ? qq.assignedPoints : (not empty qq.points ? qq.points : (not empty qq.defaultPoints ? qq.defaultPoints : 1))}"
                                                                                        class="points-inline-input"
                                                                                        title="Sửa điểm trực tiếp (Enter hoặc bấm ✓ để lưu)"
                                                                                        required>
                                                                                    <span class="points-unit">đ</span>
                                                                                    <button type="submit"
                                                                                        class="btn-save-point"
                                                                                        title="Lưu điểm">
                                                                                        <i
                                                                                            class="bi bi-check-lg fw-bold"></i>
                                                                                    </button>
                                                                                </div>
                                                                            </form>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>

                                                                <!-- Action Buttons: Edit Question & Remove -->
                                                                <div class="d-flex align-items-center gap-1.5">
                                                                    <button type="button" class="btn-icon-action"
                                                                        onclick="openEditQuestionDetailModal(this)"
                                                                        title="Sửa nội dung câu hỏi">
                                                                        <i class="bi bi-pencil-square"></i>
                                                                    </button>

                                                                    <c:choose>
                                                                        <c:when test="${quiz.attemptCount > 0}">
                                                                            <button type="button"
                                                                                class="btn-icon-action text-muted"
                                                                                title="Đã có ${quiz.attemptCount} lượt làm bài của học viên (không thể gỡ câu hỏi)"
                                                                                onclick="alert('Không thể gỡ câu hỏi vì đã có ${quiz.attemptCount} lượt học viên làm bài thi này. Việc gỡ câu hỏi sẽ làm sai lệch thang điểm bài thi cũ!');">
                                                                                <i
                                                                                    class="bi bi-lock-fill text-warning"></i>
                                                                            </button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:url var="removeUrl"
                                                                                value="/quizzes/remove-question">
                                                                                <c:param name="quizId"
                                                                                    value="${quiz.id}" />
                                                                                <c:param name="questionId"
                                                                                    value="${qq.id}" />
                                                                                <c:if test="${not empty courseId}">
                                                                                    <c:param name="courseId"
                                                                                        value="${courseId}" />
                                                                                </c:if>
                                                                            </c:url>
                                                                            <a href="${removeUrl}"
                                                                                class="btn-icon-action text-danger"
                                                                                onclick="return confirm('Bạn có chắc muốn gỡ câu hỏi này khỏi bài thi? (Câu hỏi vẫn được giữ nguyên an toàn trong Ngân hàng câu hỏi)');"
                                                                                title="Gỡ khỏi bài thi">
                                                                                <i class="bi bi-trash3"></i>
                                                                            </a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>

                                                            <!-- Question Title / Content -->
                                                            <div class="fw-medium text-dark mb-3 fs-6 lh-base">
                                                                <c:out value="${qq.questionText}" />
                                                            </div>

                                                            <!-- Question Options Grid -->
                                                            <c:if test="${not empty qq.options}">
                                                                <div class="row g-2 pt-3 border-top">
                                                                    <c:forEach var="opt" items="${qq.options}"
                                                                        varStatus="optStatus">
                                                                        <c:set var="letter"
                                                                            value="${optStatus.index == 0 ? 'A' : (optStatus.index == 1 ? 'B' : (optStatus.index == 2 ? 'C' : (optStatus.index == 3 ? 'D' : optStatus.index + 1)))}" />
                                                                        <div class="col-md-6">
                                                                            <div
                                                                                class="option-card ${opt.correct ? 'is-correct' : ''}">
                                                                                <span
                                                                                    class="option-letter-badge ${opt.correct ? 'bg-success text-white' : 'bg-light border text-muted'}">
                                                                                    ${letter}
                                                                                </span>
                                                                                <span class="flex-grow-1 text-truncate"
                                                                                    title="<c:out value="
                                                                                    ${opt.optionText}" />">
                                                                                <c:out value="${opt.optionText}" />
                                                                                </span>
                                                                                <c:if test="${opt.correct}">
                                                                                    <span
                                                                                        class="badge bg-success text-white py-1 px-2 flex-shrink-0"
                                                                                        style="font-size: 0.7rem;">
                                                                                        <i
                                                                                            class="bi bi-check2 me-1"></i>Đáp
                                                                                        án đúng
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
                                                        <h6 class="fw-bold text-dark mb-1">Không tìm thấy câu hỏi phù
                                                            hợp với bộ lọc</h6>
                                                        <p class="text-muted small mb-2">Hãy thử tìm từ khóa khác hoặc
                                                            thiết lập lại bộ lọc.</p>
                                                        <button type="button" class="btn-saas-outline"
                                                            onclick="clearQuizQuestionSearch()">
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
                <div class="modal fade" id="pickFromBankModal" tabindex="-1" aria-labelledby="pickFromBankModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
                        <div class="modal-content saas-modal">
                            <div class="modal-header saas-modal-header">
                                <div>
                                    <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2"
                                        id="pickFromBankModalLabel">
                                        <span class="text-primary"><i class="bi bi-bank"></i></span>
                                        Ngân hàng câu hỏi của chương
                                    </h5>
                                    <small class="text-muted">Chọn các câu hỏi để gán vào bài thi
                                        "${quiz.title}"</small>
                                </div>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>

                            <div class="modal-body p-4">
                                <c:choose>
                                    <c:when test="${empty bankQuestions}">
                                        <div class="text-center py-5">
                                            <div class="bg-light text-muted rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                                                style="width: 64px; height: 64px;">
                                                <i class="bi bi-inbox fs-2"></i>
                                            </div>
                                            <h6 class="fw-bold text-dark mb-1">Ngân hàng câu hỏi của chương này đang
                                                trống</h6>
                                            <p class="text-muted small mb-3">
                                                Chưa có câu hỏi nào được tạo trong ngân hàng câu hỏi của chương học này.
                                            </p>
                                            <button type="button" class="btn-saas-primary" data-bs-dismiss="modal"
                                                data-bs-toggle="modal" data-bs-target="#newQuestionModal">
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
                                                        <input type="text" id="bankSearchInput"
                                                            class="form-control border-start-0"
                                                            placeholder="Tìm câu hỏi trong ngân hàng...">
                                                    </div>
                                                </div>
                                                <div class="col-sm-5">
                                                    <select id="bankStatusFilter" class="form-select form-select-sm">
                                                        <option value="ALL">Tất cả (${fn:length(bankQuestions)} câu)
                                                        </option>
                                                        <option value="UNASSIGNED">Chưa thêm vào bài thi</option>
                                                        <option value="ASSIGNED">Đã có trong bài thi</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Bank Questions List -->
                                        <div class="d-flex flex-column gap-3" id="bankQuestionsContainer">
                                            <c:forEach var="bq" items="${bankQuestions}" varStatus="bStatus">
                                                <c:set var="isAlreadyAssigned"
                                                    value="${assignedQuestionIds.contains(bq.id)}" />
                                                <div class="bank-question-row p-3 ${isAlreadyAssigned ? 'bg-light opacity-75' : 'bg-white'}"
                                                    data-bank-text="${fn:toLowerCase(fn:escapeXml(bq.questionText))}"
                                                    data-bank-assigned="${isAlreadyAssigned ? 'true' : 'false'}">

                                                    <div
                                                        class="d-flex justify-content-between align-items-start gap-2 mb-2">
                                                        <div class="d-flex align-items-center gap-2 flex-wrap">
                                                            <span class="badge bg-light text-dark border">
                                                                #${bStatus.index + 1}
                                                            </span>
                                                            <span class="saas-badge saas-badge-blue">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${bq.questionType == 'SINGLE_CHOICE'}">1
                                                                        Đáp án</c:when>
                                                                    <c:when test="${bq.questionType == 'MULTI_CHOICE'}">
                                                                        Nhiều đáp án</c:when>
                                                                    <c:when test="${bq.questionType == 'TRUE_FALSE'}">
                                                                        Đúng / Sai</c:when>
                                                                    <c:otherwise>${bq.questionType}</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                            <span class="saas-badge saas-badge-published">
                                                                <span class="badge-dot"></span>Điểm chuẩn:
                                                                ${bq.defaultPoints} đ
                                                            </span>
                                                        </div>

                                                        <!-- Assign Action Button / Status Badge -->
                                                        <div>
                                                            <c:choose>
                                                                <c:when test="${isAlreadyAssigned}">
                                                                    <span class="saas-badge saas-badge-draft">
                                                                        <i class="bi bi-check2-all me-1"></i>Đã trong
                                                                        bài thi
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/quizzes/assign-question"
                                                                        method="POST" class="d-inline">
                                                                        <input type="hidden" name="quizId"
                                                                            value="${quiz.id}">
                                                                        <input type="hidden" name="questionId"
                                                                            value="${bq.id}">
                                                                        <input type="hidden" name="points"
                                                                            value="${bq.defaultPoints}">
                                                                        <c:if test="${not empty courseId}">
                                                                            <input type="hidden" name="courseId"
                                                                                value="${courseId}">
                                                                        </c:if>
                                                                        <button type="submit"
                                                                            class="btn-saas-primary py-1 px-2.5">
                                                                            <i class="bi bi-plus-lg me-1"></i>Thêm vào
                                                                            Quiz
                                                                        </button>
                                                                    </form>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>

                                                    <div class="fw-medium text-dark mb-2 small lh-base">
                                                        <c:out value="${bq.questionText}" />
                                                    </div>

                                                    <!-- Options preview -->
                                                    <div class="row g-1 pt-1">
                                                        <c:forEach var="bOpt" items="${bq.options}"
                                                            varStatus="bOptStatus">
                                                            <c:set var="letter"
                                                                value="${bOptStatus.index == 0 ? 'A' : (bOptStatus.index == 1 ? 'B' : (bOptStatus.index == 2 ? 'C' : 'D'))}" />
                                                            <div class="col-md-6">
                                                                <div
                                                                    class="small p-1.5 rounded border ${bOpt.correct ? 'bg-success-subtle border-success-subtle text-success fw-medium' : 'bg-light text-muted'} d-flex align-items-center gap-1">
                                                                    <span
                                                                        class="badge ${bOpt.correct ? 'bg-success text-white' : 'bg-secondary text-white'}"
                                                                        style="font-size: 0.65rem;">
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

                            <div class="modal-footer saas-modal-footer">
                                <button type="button" class="btn-saas-outline" data-bs-dismiss="modal">Đóng</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ======================================================= -->
                <!-- MODAL 2: TẠO CÂU HỎI MỚI VÀ TỰ ĐỘNG GÁN VÀO QUIZ        -->
                <!-- ======================================================= -->
                <div class="modal fade" id="newQuestionModal" tabindex="-1" aria-labelledby="newQuestionModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content saas-modal">
                            <form action="${pageContext.request.contextPath}/quizzes/save-question" method="POST"
                                id="newQuestionForm">
                                <input type="hidden" name="moduleId" value="${quiz.moduleId}">
                                <input type="hidden" name="quizId" value="${quiz.id}">
                                <c:if test="${not empty courseId}">
                                    <input type="hidden" name="courseId" value="${courseId}">
                                </c:if>

                                <div class="modal-header saas-modal-header">
                                    <div>
                                        <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2"
                                            id="newQuestionModalLabel">
                                            <span class="text-success"><i class="bi bi-patch-plus-fill"></i></span>
                                            Tạo câu hỏi mới và thêm vào bài thi
                                        </h5>
                                        <small class="text-muted">Câu hỏi sẽ được lưu vào ngân hàng của chương và tự
                                            động gán vào bài thi này</small>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>

                                <div class="modal-body p-4">
                                    <!-- Question Text -->
                                    <div class="mb-3">
                                        <label class="saas-form-label">
                                            Nội dung câu hỏi <span class="text-danger">*</span>
                                        </label>
                                        <textarea name="questionText" rows="3" class="form-control saas-form-control"
                                            required
                                            placeholder="Nhập nội dung câu hỏi trắc nghiệm ở đây..."></textarea>
                                    </div>

                                    <!-- Type and Points -->
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label class="saas-form-label">Loại câu hỏi</label>
                                            <select name="questionType" id="newQuestionTypeSelect"
                                                class="form-select saas-form-control"
                                                onchange="handleQuestionTypeChange(this.value)">
                                                <option value="SINGLE_CHOICE" selected>Trắc nghiệm 1 đáp án (Single Choice)</option>
                                                <option value="MULTI_CHOICE">Trắc nghiệm nhiều đáp án (Multiple Choice)</option>
                                                <option value="TRUE_FALSE">Đúng / Sai (True / False)</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="saas-form-label">
                                                Điểm số của câu hỏi <span class="text-danger">*</span>
                                            </label>
                                            <div class="input-group">
                                                <input type="number" step="0.5" min="0.5" name="defaultPoints"
                                                    id="newQuestionPointsInput" value="1.0"
                                                    class="form-control saas-form-control rounded-start-3" required>
                                                <span class="input-group-text bg-light text-muted">điểm</span>
                                            </div>
                                            <div class="form-text small text-muted">Điểm số phải lớn hơn 0 (ví dụ: 1.0,
                                                2.0).</div>
                                        </div>
                                    </div>

                                    <!-- Options Area -->
                                    <label class="saas-form-label text-primary mb-2 d-flex align-items-center justify-content-between">
                                        <span><i class="bi bi-ui-radios me-1"></i>Các phương án trả lời:</span>
                                        <span class="text-muted fw-normal small" id="newCorrectOptionHint">Chọn nút tròn vào đáp án đúng</span>
                                    </label>

                                    <div id="optionsContainer">
                                        <!-- Option A -->
                                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="optGroupA">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="0" checked title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-primary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">A</span>
                                            <input type="text" name="optionText" id="optTextA"
                                                class="form-control border-start-0"
                                                placeholder="Nhập nội dung đáp án A..." required>
                                        </div>

                                        <!-- Option B -->
                                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="optGroupB">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="1" title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-primary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">B</span>
                                            <input type="text" name="optionText" id="optTextB"
                                                class="form-control border-start-0"
                                                placeholder="Nhập nội dung đáp án B..." required>
                                        </div>

                                        <!-- Option C -->
                                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="optGroupC">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="2" title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-primary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">C</span>
                                            <input type="text" name="optionText" id="optTextC"
                                                class="form-control border-start-0"
                                                placeholder="Nhập nội dung đáp án C (tùy chọn)...">
                                        </div>

                                        <!-- Option D -->
                                        <div class="mb-3 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="optGroupD">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="3" title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-primary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">D</span>
                                            <input type="text" name="optionText" id="optTextD"
                                                class="form-control border-start-0"
                                                placeholder="Nhập nội dung đáp án D (tùy chọn)...">
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-footer saas-modal-footer">
                                    <button type="button" class="btn-saas-outline" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn-saas-primary">
                                        <i class="bi bi-save me-1"></i>Tạo câu hỏi và gán vào bài thi
                                    </button>
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
                        <div class="modal-content saas-modal">
                            <div class="modal-body text-center p-4">
                                <div class="bg-danger-subtle text-danger rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                                    style="width: 52px; height: 52px; font-size: 1.35rem;">
                                    <i class="bi bi-trash3-fill"></i>
                                </div>
                                <h5 class="fw-bold text-dark mb-1">Xác nhận xóa bài thi?</h5>
                                <p class="small text-muted mb-4">
                                    Thao tác này sẽ xóa bài thi <strong>"${quiz.title}"</strong>. Các câu hỏi trong ngân
                                    hàng vẫn được giữ nguyên an toàn.
                                </p>
                                <div class="d-flex justify-content-center gap-2">
                                    <button type="button" class="btn-saas-outline" data-bs-dismiss="modal">Hủy</button>
                                    <c:url var="deleteQuizUrl" value="/quizzes/delete">
                                        <c:param name="id" value="${quiz.id}" />
                                        <c:if test="${not empty courseId}">
                                            <c:param name="courseId" value="${courseId}" />
                                        </c:if>
                                        <c:if test="${empty courseId}">
                                            <c:param name="moduleId" value="${quiz.moduleId}" />
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

                <!-- ======================================================= -->
                <!-- MODAL 5: CHỈNH SỬA NỘI DUNG CÂU HỎI                    -->
                <!-- ======================================================= -->
                <div class="modal fade" id="editQuestionModal" tabindex="-1" aria-labelledby="editQuestionModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content saas-modal">
                            <form action="${pageContext.request.contextPath}/quizzes/save-question" method="POST"
                                id="editQuestionForm">
                                <input type="hidden" name="id" id="editQId" value="">
                                <input type="hidden" name="moduleId" value="${quiz.moduleId}">
                                <input type="hidden" name="quizId" value="${quiz.id}">
                                <c:if test="${not empty courseId}">
                                    <input type="hidden" name="courseId" value="${courseId}">
                                </c:if>

                                <div class="modal-header saas-modal-header">
                                    <div>
                                        <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2"
                                            id="editQuestionModalLabel">
                                            <span class="text-primary"><i class="bi bi-pencil-square"></i></span>
                                            Chỉnh sửa câu hỏi
                                        </h5>
                                        <small class="text-muted">Thay đổi sẽ cập nhật câu hỏi trong ngân hàng và đồng
                                            bộ với bài thi này.</small>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>

                                <div class="modal-body p-4">
                                    <!-- Question Text -->
                                    <div class="mb-3">
                                        <label class="saas-form-label">
                                            Nội dung câu hỏi <span class="text-danger">*</span>
                                        </label>
                                        <textarea name="questionText" id="editQText" rows="3"
                                            class="form-control saas-form-control" required
                                            placeholder="Nhập nội dung câu hỏi..."></textarea>
                                    </div>

                                    <!-- Type and Points -->
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label class="saas-form-label">Loại câu hỏi</label>
                                            <select name="questionType" id="editQType"
                                                class="form-select saas-form-control"
                                                onchange="handleEditQTypeChange(this.value)">
                                                <option value="SINGLE_CHOICE">Trắc nghiệm 1 đáp án (Single Choice)</option>
                                                <option value="MULTI_CHOICE">Trắc nghiệm nhiều đáp án (Multiple Choice)</option>
                                                <option value="TRUE_FALSE">Đúng / Sai (True / False)</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="saas-form-label">
                                                Điểm mặc định <span class="text-danger">*</span>
                                            </label>
                                            <div class="input-group">
                                                <input type="number" step="0.5" min="0.5" name="defaultPoints"
                                                    id="editQPoints" value="1.0"
                                                    class="form-control saas-form-control rounded-start-3" required>
                                                <span class="input-group-text bg-light text-muted">điểm</span>
                                            </div>
                                            <div class="form-text small text-muted">Điểm cưỡng bức sẽ được giữ nguyên
                                                trong bài thi này.</div>
                                        </div>
                                    </div>

                                    <!-- Options -->
                                    <label class="saas-form-label text-primary mb-2 d-flex align-items-center justify-content-between">
                                        <span><i class="bi bi-ui-radios me-1"></i>Các phương án trả lời:</span>
                                        <span class="text-muted fw-normal small" id="editCorrectOptionHint">Chọn nút tròn vào đáp án đúng</span>
                                    </label>

                                    <div id="editQOptionsContainer">
                                        <!-- Option A -->
                                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="editOptGroupA">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="0" checked title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">A</span>
                                            <input type="text" name="optionText" id="editOptTextA"
                                                class="form-control border-start-0" placeholder="Đáp án A..." required>
                                        </div>

                                        <!-- Option B -->
                                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="editOptGroupB">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="1" title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">B</span>
                                            <input type="text" name="optionText" id="editOptTextB"
                                                class="form-control border-start-0" placeholder="Đáp án B..." required>
                                        </div>

                                        <!-- Option C -->
                                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="editOptGroupC">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="2" title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">C</span>
                                            <input type="text" name="optionText" id="editOptTextC"
                                                class="form-control border-start-0"
                                                placeholder="Đáp án C (tùy chọn)...">
                                        </div>

                                        <!-- Option D -->
                                        <div class="mb-3 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="editOptGroupD">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="3" title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">D</span>
                                            <input type="text" name="optionText" id="editOptTextD"
                                                class="form-control border-start-0"
                                                placeholder="Đáp án D (tùy chọn)...">
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-footer saas-modal-footer">
                                    <button type="button" class="btn-saas-outline" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn-saas-primary">
                                        <i class="bi bi-save me-1"></i>Lưu thay đổi câu hỏi
                                    </button>
                                </div>
                            </form>
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

                    // 2. Inline points modification highlight
                    document.querySelectorAll('.points-inline-input').forEach(input => {
                        const origVal = parseFloat(input.value);
                        input.addEventListener('input', function () {
                            const btn = this.closest('form').querySelector('.btn-save-point');
                            if (btn) {
                                const currentVal = parseFloat(this.value);
                                if (!isNaN(currentVal) && currentVal !== origVal) {
                                    btn.classList.add('is-dirty');
                                } else {
                                    btn.classList.remove('is-dirty');
                                }
                            }
                        });
                    });

                    // 3. Dynamic adjustment for New Question Modal (Single Choice vs Multi Choice vs True/False)
                    function handleQuestionTypeChange(type) {
                        const optC = document.getElementById('optGroupC');
                        const optD = document.getElementById('optGroupD');
                        const textA = document.getElementById('optTextA');
                        const textB = document.getElementById('optTextB');
                        const inputs = document.querySelectorAll('#newQuestionForm input[name="correctOption"]');
                        const hint = document.getElementById('newCorrectOptionHint');

                        if (type === 'MULTI_CHOICE') {
                            inputs.forEach(input => {
                                input.type = 'checkbox';
                                input.title = 'Chọn làm đáp án đúng (có thể chọn nhiều đáp án)';
                            });
                            if (hint) hint.textContent = 'Chọn các ô vuông để chỉ định đáp án đúng (chọn >= 1)';
                            if (optC) optC.style.display = 'flex';
                            if (optD) optD.style.display = 'flex';
                            if (textA && textA.value === 'Đúng (True)') textA.value = '';
                            if (textB && textB.value === 'Sai (False)') textB.value = '';
                        } else if (type === 'TRUE_FALSE') {
                            inputs.forEach(input => {
                                input.type = 'radio';
                                input.title = 'Chọn làm đáp án đúng';
                            });
                            if (hint) hint.textContent = 'Chọn nút tròn vào đáp án đúng';
                            if (optC) optC.style.display = 'none';
                            if (optD) optD.style.display = 'none';
                            if (textA && !textA.value) textA.value = 'Đúng (True)';
                            if (textB && !textB.value) textB.value = 'Sai (False)';
                        } else {
                            // SINGLE_CHOICE
                            inputs.forEach(input => {
                                input.type = 'radio';
                                input.title = 'Chọn làm đáp án đúng';
                            });
                            if (hint) hint.textContent = 'Chọn nút tròn vào đáp án đúng';
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
                        quizForm.addEventListener('submit', function (e) {
                            const passScore = parseFloat(document.getElementById('passScoreInput').value);
                            if (isNaN(passScore) || passScore < 0 || passScore > 100) {
                                e.preventDefault();
                                alert('Tỉ lệ đạt tối thiểu (%) phải nằm trong khoảng từ 0% đến 100%.');
                            }
                        });
                    }

                    function validateQuestionOptionsForm(form) {
                        const qTypeSelect = form.querySelector('[name="questionType"]');
                        const qType = qTypeSelect ? qTypeSelect.value : 'SINGLE_CHOICE';

                        const optTextInputs = Array.from(form.querySelectorAll('[name="optionText"]'));
                        const correctInputs = Array.from(form.querySelectorAll('[name="correctOption"]'));

                        const maxCheck = (qType === 'TRUE_FALSE') ? 2 : optTextInputs.length;

                        // 1. Phải điền đầy đủ A và B
                        if (optTextInputs[0] && !optTextInputs[0].value.trim()) {
                            alert('Vui lòng nhập nội dung cho phương án A.');
                            optTextInputs[0].focus();
                            return false;
                        }
                        if (optTextInputs[1] && !optTextInputs[1].value.trim()) {
                            alert('Vui lòng nhập nội dung cho phương án B.');
                            optTextInputs[1].focus();
                            return false;
                        }

                        let validTexts = [];
                        let correctCount = 0;
                        let hasSelectedEmpty = false;

                        for (let i = 0; i < maxCheck; i++) {
                            const textVal = optTextInputs[i] ? optTextInputs[i].value.trim() : '';
                            const isChecked = correctInputs[i] ? correctInputs[i].checked : false;

                            if (isChecked) {
                                correctCount++;
                                if (!textVal) {
                                    hasSelectedEmpty = true;
                                }
                            }
                            if (textVal) {
                                validTexts.push({ index: i, text: textVal.toLowerCase() });
                            }
                        }

                        // 2. Không được tích chọn đáp án đúng vào ô trống
                        if (hasSelectedEmpty) {
                            alert('Phương án được chọn làm đáp án đúng không được để trống nội dung.');
                            return false;
                        }

                        // 3. Tối thiểu 2 phương án có nội dung
                        if (validTexts.length < 2) {
                            alert('Câu hỏi phải có ít nhất 2 phương án trả lời có nội dung.');
                            return false;
                        }

                        // 4. Kiểm tra trùng lặp nội dung
                        const uniqueSet = new Set();
                        for (let item of validTexts) {
                            if (uniqueSet.has(item.text)) {
                                alert('Các phương án trả lời không được trùng lặp nội dung.');
                                if (optTextInputs[item.index]) optTextInputs[item.index].focus();
                                return false;
                            }
                            uniqueSet.add(item.text);
                        }

                        // 5. Kiểm tra số lượng đáp án đúng
                        if (qType === 'MULTI_CHOICE') {
                            if (correctCount < 1) {
                                alert('Câu hỏi nhiều đáp án: Vui lòng đánh dấu ít nhất 1 đáp án đúng.');
                                return false;
                            }
                        } else {
                            if (correctCount !== 1) {
                                alert('Vui lòng chọn duy nhất 1 đáp án đúng.');
                                return false;
                            }
                        }

                        return true;
                    }

                    const newQForm = document.getElementById('newQuestionForm');
                    if (newQForm) {
                        newQForm.addEventListener('submit', function (e) {
                            const ptsInput = document.getElementById('newQuestionPointsInput');
                            if (ptsInput) {
                                const pts = parseFloat(ptsInput.value);
                                if (isNaN(pts) || pts <= 0) {
                                    e.preventDefault();
                                    alert('Điểm số của câu hỏi phải lớn hơn 0.');
                                    return;
                                }
                            }
                            if (!validateQuestionOptionsForm(newQForm)) {
                                e.preventDefault();
                            }
                        });
                    }

                    const editQForm = document.getElementById('editQuestionForm');
                    if (editQForm) {
                        editQForm.addEventListener('submit', function (e) {
                            const ptsInput = document.getElementById('editQPoints');
                            if (ptsInput) {
                                const pts = parseFloat(ptsInput.value);
                                if (isNaN(pts) || pts <= 0) {
                                    e.preventDefault();
                                    alert('Điểm số của câu hỏi phải lớn hơn 0.');
                                    return;
                                }
                            }
                            if (!validateQuestionOptionsForm(editQForm)) {
                                e.preventDefault();
                            }
                        });
                    }
                    // 7. Open Edit Question Modal (detail page)
                    function openEditQuestionDetailModal(btn) {
                        const card = btn.closest('.question-item-card');
                        if (!card) return;

                        const qId = card.getAttribute('data-q-id');
                        const qText = card.getAttribute('data-q-text');
                        const qPoints = card.getAttribute('data-q-points');
                        const qType = card.getAttribute('data-q-type') || 'SINGLE_CHOICE';

                        // Fill hidden & fields
                        document.getElementById('editQId').value = qId;
                        document.getElementById('editQText').value = qText;
                        document.getElementById('editQPoints').value = qPoints;
                        const typeEl = document.getElementById('editQType');
                        if (typeEl) typeEl.value = qType;

                        // Apply type-specific display BEFORE setting checked states
                        handleEditQTypeChange(qType);

                        // Fill options A-D from DOM
                        const optItems = card.querySelectorAll('.q-opt-item');
                        const optTextIds = ['editOptTextA', 'editOptTextB', 'editOptTextC', 'editOptTextD'];
                        const inputs = document.querySelectorAll('#editQuestionForm input[name="correctOption"]');
                        optTextIds.forEach((id, i) => {
                            const el = document.getElementById(id);
                            if (!el) return;
                            const optItem = optItems[i];
                            el.value = optItem ? (optItem.getAttribute('data-text') || '') : '';
                            const isCorrect = optItem ? (optItem.getAttribute('data-correct') === 'true') : (i === 0);
                            if (inputs[i]) inputs[i].checked = isCorrect;
                        });

                        // Show modal
                        bootstrap.Modal.getOrCreateInstance(document.getElementById('editQuestionModal')).show();
                    }

                    function handleEditQTypeChange(type) {
                        const optC = document.getElementById('editOptGroupC');
                        const optD = document.getElementById('editOptGroupD');
                        const textA = document.getElementById('editOptTextA');
                        const textB = document.getElementById('editOptTextB');
                        const inputs = document.querySelectorAll('#editQuestionForm input[name="correctOption"]');
                        const hint = document.getElementById('editCorrectOptionHint');
                        const isMulti = (type === 'MULTI_CHOICE');

                        inputs.forEach(input => {
                            input.type = isMulti ? 'checkbox' : 'radio';
                            input.title = isMulti ? 'Đánh dấu ô vuông cho đáp án đúng (có thể chọn nhiều)' : 'Chọn làm đáp án đúng';
                        });

                        if (hint) {
                            hint.textContent = isMulti ? 'Đánh dấu ô vuông vào tất cả đáp án đúng' : 'Chọn nút tròn vào đáp án đúng';
                        }

                        if (type === 'TRUE_FALSE') {
                            if (optC) optC.style.display = 'none';
                            if (optD) optD.style.display = 'none';
                            if (textA && textA.value === '') textA.value = 'Đúng (True)';
                            if (textB && textB.value === '') textB.value = 'Sai (False)';
                        } else {
                            if (optC) optC.style.display = 'flex';
                            if (optD) optD.style.display = 'flex';
                            if (textA && textA.value === 'Đúng (True)') textA.value = '';
                            if (textB && textB.value === 'Sai (False)') textB.value = '';
                        }
                    }

                </script>

                <jsp:include page="../common/footer.jsp" />