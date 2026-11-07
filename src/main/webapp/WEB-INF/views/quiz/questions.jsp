<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle"
    value="Ngân hàng câu hỏi - ${not empty course ? course.title : 'Courson LMS'}" />
<jsp:include page="../common/header.jsp" />

<style>
/* ==========================================================================
   MODERN SAAS DESIGN SYSTEM (Synchronized with Expert Studio & Quiz Management)
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
.saas-icon-blue { background: #eff6ff; color: #2563eb; }
.saas-icon-emerald { background: #ecfdf5; color: #059669; }
.saas-icon-amber { background: #fffbeb; color: #d97706; }
.saas-icon-slate { background: #f1f5f9; color: #475569; }

/* Tabs */
.saas-tabs {
    border-bottom: 1px solid var(--saas-border);
    gap: 8px;
}
.saas-tabs .nav-link {
    color: var(--saas-text-muted);
    font-weight: 600;
    font-size: 0.875rem;
    border: none;
    border-bottom: 2px solid transparent;
    padding: 10px 18px;
    background: transparent;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    border-radius: 0;
    transition: all 0.15s ease;
    text-decoration: none;
}
.saas-tabs .nav-link:hover {
    color: var(--saas-accent);
}
.saas-tabs .nav-link.active {
    color: var(--saas-accent);
    border-bottom: 2px solid var(--saas-accent);
    background: transparent;
}
.tab-count-badge {
    font-size: 0.75rem;
    font-weight: 600;
    padding: 2px 8px;
    border-radius: 9999px;
    background: #f1f5f9;
    color: #475569;
    border: 1px solid #e2e8f0;
}
.saas-tabs .nav-link.active .tab-count-badge {
    background: #eff6ff;
    color: #2563eb;
    border-color: #bfdbfe;
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

/* Card & Filter Toolbar */
.saas-card {
    background: var(--saas-card-bg);
    border: 1px solid var(--saas-border);
    border-radius: var(--saas-radius-lg);
    box-shadow: var(--saas-shadow-sm);
    overflow: hidden;
}
.saas-toolbar {
    background: #ffffff;
    padding: 14px 18px;
    border: 1px solid var(--saas-border);
    border-radius: var(--saas-radius-md);
    box-shadow: var(--saas-shadow-xs);
    margin-bottom: 16px;
}

/* Module Accordion Section Cards */
.udemy-curriculum-container {
    display: flex;
    flex-direction: column;
    gap: 16px;
}
.udemy-section-item {
    background: var(--saas-card-bg);
    border: 1px solid var(--saas-border);
    border-radius: var(--saas-radius-lg);
    box-shadow: var(--saas-shadow-sm);
    overflow: hidden;
    transition: border-color 0.15s ease;
}
.udemy-section-item:hover {
    border-color: #cbd5e1;
}
.udemy-section-header {
    background: #ffffff;
    padding: 14px 18px;
    border-bottom: 1px solid var(--saas-border);
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    cursor: pointer;
    user-select: none;
    transition: background-color 0.15s ease;
}
.udemy-section-header:hover {
    background-color: #f8fafc;
}
.udemy-section-header.collapsed {
    border-bottom-color: transparent;
}
.udemy-header-toggle {
    cursor: pointer;
    user-select: none;
    text-decoration: none;
}
.udemy-chevron {
    transition: transform 0.2s cubic-bezier(0.16, 1, 0.3, 1);
    font-size: 0.85rem;
    color: #64748b;
    display: inline-block;
}
.udemy-section-header.collapsed .udemy-chevron,
.udemy-header-toggle.collapsed .udemy-chevron {
    transform: rotate(-90deg);
}
.udemy-section-body {
    background-color: #ffffff;
}

/* Tables */
.clean-table {
    margin-bottom: 0;
}
.clean-table th {
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: var(--saas-text-muted);
    background-color: #f8fafc;
    border-bottom: 1px solid var(--saas-border);
    padding: 10px 16px;
}
.clean-table td {
    padding: 12px 16px;
    vertical-align: middle;
    border-bottom: 1px solid var(--saas-border-subtle);
    font-size: 0.875rem;
}
.clean-table tbody tr:hover {
    background-color: #f8fafc;
}
.clean-table tbody tr:last-child td {
    border-bottom: none;
}

/* Pure text toggle */
.btn-text-toggle {
    background: none !important;
    border: none !important;
    padding: 0 !important;
    font-size: 0.8125rem;
    font-weight: 600;
    color: var(--saas-text-muted);
    cursor: pointer;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 4px;
    transition: color 0.15s ease;
}
.btn-text-toggle:hover {
    color: var(--saas-accent);
}
.curriculum-meta-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 12px;
    padding: 0 4px;
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
.saas-badge-published .badge-dot { background: #10b981; }

.saas-badge-pending {
    background: #fffbeb;
    color: #92400e;
    border: 1px solid #fde68a;
}
.saas-badge-pending .badge-dot { background: #f59e0b; }

.saas-badge-draft {
    background: #f1f5f9;
    color: #334155;
    border: 1px solid #cbd5e1;
}
.saas-badge-draft .badge-dot { background: #64748b; }

.saas-badge-blue {
    background: #eff6ff;
    color: #1d4ed8;
    border: 1px solid #bfdbfe;
}
.saas-badge-blue .badge-dot { background: #2563eb; }

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

.correct-answer-snippet {
    font-size: 0.775rem;
    color: #059669;
    background: #ecfdf5;
    border: 1px solid #d1fae5;
    border-radius: 6px;
    padding: 0.25rem 0.55rem;
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    max-width: 100%;
    word-break: break-word;
}
.btn-xs {
    font-size: 0.75rem;
    padding: 0.2rem 0.5rem;
    border-radius: 0.375rem;
}
.question-text-title {
    font-size: 0.9125rem;
    font-weight: 500;
    color: var(--saas-text-heading);
    line-height: 1.5;
    word-break: break-word;
}
.option-item-preview {
    transition: background-color 0.15s ease, border-color 0.15s ease;
}
.option-item-preview:hover {
    border-color: #cbd5e1;
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
                <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}">
                    ${course.title}
                </a>
                <span class="separator">/</span>
            </c:if>
            <span class="current">Ngân hàng câu hỏi</span>
        </nav>

        <!-- System Alerts -->
        <c:if test="${not empty param.success}">
            <div class="saas-alert saas-alert-success alert-dismissible fade show" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>
                        <c:choose>
                            <c:when test="${param.success == 'question_saved'}">Đã lưu câu hỏi vào ngân hàng thành công!</c:when>
                            <c:when test="${param.success == 'question_deleted'}">Đã xóa câu hỏi khỏi ngân hàng thành công!</c:when>
                            <c:otherwise>Thao tác đã được hoàn tất thành công.</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error or not empty error}">
            <div class="saas-alert saas-alert-danger alert-dismissible fade show" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <div><c:out value="${not empty param.error ? param.error : error}" /></div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Header Top Bar -->
        <div class="saas-header">
            <div>
                <h1 class="saas-title">
                    <span class="saas-stat-icon saas-icon-emerald" style="width: 36px; height: 36px; border-radius: 10px;">
                        <i class="bi bi-database-fill-check"></i>
                    </span>
                    <span>Ngân hàng câu hỏi: ${course.title}</span>
                </h1>
                <p class="saas-subtitle">
                    Kho lưu trữ và quản lý ngân hàng câu hỏi tập trung của khóa học
                </p>
            </div>
            <div class="d-flex align-items-center gap-2">
                <c:if test="${not empty course}">
                    <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}"
                        class="btn-saas-outline" title="Quay về danh sách bài học">
                        <i class="bi bi-journal-text text-primary me-1"></i>Quản lý bài học
                    </a>
                    <button type="button"
                        class="btn-saas-primary"
                        data-bs-toggle="modal" data-bs-target="#questionModal"
                        onclick="openCreateQuestionModal('')">
                        <i class="bi bi-plus-lg me-1"></i>Thêm câu hỏi mới
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Main Tabs Navigation (Dedicated Screens) -->
        <ul class="nav nav-tabs saas-tabs mb-4" id="assessmentTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <a class="nav-link" href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}">
                    <i class="bi bi-collection"></i>Danh sách Quiz
                    <span class="tab-count-badge">${totalQuizzes}</span>
                </a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link active" href="${pageContext.request.contextPath}/quizzes/questions?courseId=${course.id}">
                    <i class="bi bi-database"></i>Ngân hàng câu hỏi
                    <span class="tab-count-badge" id="totalQuestionsBadge">${totalQuestions}</span>
                </a>
            </li>
        </ul>

        <!-- ======================================================= -->
        <!-- NGÂN HÀNG CÂU HỎI (HIỂN THỊ THEO CHƯƠNG)                -->
        <!-- ======================================================= -->
        <div id="pills-questions">
            <c:choose>
                <c:when test="${empty course or empty course.modules}">
                    <div class="saas-card p-5 text-center mb-4">
                        <div class="bg-light text-muted rounded-circle d-inline-flex align-items-center justify-content-center mx-auto mb-3"
                            style="width: 64px; height: 64px;">
                            <i class="bi bi-folder-x fs-2"></i>
                        </div>
                        <h5 class="fw-bold text-dark mb-1">Khóa học này chưa có chương học nào!</h5>
                        <p class="text-muted small mb-3">Bạn cần tạo ít nhất một chương học để quản
                            lý ngân hàng câu hỏi.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}"
                                class="btn-saas-primary">
                                <i class="bi bi-plus-circle me-1"></i>Tạo chương học ngay
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:set var="isSearching" value="${not empty keyword or not empty filterModuleId or (not empty questionType and questionType != 'all')}" />

                    <!-- Toolbar lọc & tìm kiếm câu hỏi phía Server (Server-side Filtering) -->
                    <form action="${pageContext.request.contextPath}/quizzes/questions" method="GET" class="saas-toolbar mb-3" id="questionFilterForm">
                        <input type="hidden" name="courseId" value="${course.id}">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-5 col-12">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-light border-end-0 text-muted">
                                        <i class="bi bi-search"></i>
                                    </span>
                                    <input type="text" name="keyword" id="questionSearchInput"
                                        class="form-control border-start-0 bg-light"
                                        value="<c:out value='${keyword}'/>"
                                        placeholder="Tìm kiếm nội dung câu hỏi...">
                                    <c:if test="${not empty keyword}">
                                        <a href="${pageContext.request.contextPath}/quizzes/questions?courseId=${course.id}&filterModuleId=${filterModuleId}&questionType=${questionType}"
                                            class="btn btn-outline-secondary border-start-0 bg-light text-muted"
                                            title="Xóa từ khóa">
                                            <i class="bi bi-x-circle"></i>
                                        </a>
                                    </c:if>
                                    <button class="btn btn-dark btn-sm px-3" type="submit">
                                        <i class="bi bi-search me-1"></i>Tìm
                                    </button>
                                </div>
                            </div>

                            <div class="col-md-4 col-sm-6 col-12">
                                <select id="questionModuleFilter" name="filterModuleId"
                                    class="form-select form-select-sm bg-light" onchange="document.getElementById('questionFilterForm').submit()">
                                    <option value="">Tất cả chương học</option>
                                    <c:forEach var="moduleItem" items="${allModules}">
                                        <option value="${moduleItem.id}" ${filterModuleId == moduleItem.id ? 'selected' : ''}>
                                            Chương ${moduleItem.orderIndex}: <c:out value="${moduleItem.title}" />
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-3 col-sm-6 col-12 d-flex align-items-center gap-2">
                                <select id="questionTypeFilter" name="questionType"
                                    class="form-select form-select-sm bg-light" onchange="document.getElementById('questionFilterForm').submit()">
                                    <option value="all" ${empty questionType or questionType == 'all' ? 'selected' : ''}>Tất cả loại câu</option>
                                    <option value="SINGLE_CHOICE" ${questionType == 'SINGLE_CHOICE' ? 'selected' : ''}>Trắc nghiệm</option>
                                    <option value="TRUE_FALSE" ${questionType == 'TRUE_FALSE' ? 'selected' : ''}>Đúng / Sai</option>
                                </select>

                                <c:if test="${isSearching}">
                                    <a href="${pageContext.request.contextPath}/quizzes/questions?courseId=${course.id}"
                                        class="btn btn-sm btn-link text-danger text-decoration-none text-nowrap p-0" title="Đặt lại bộ lọc">
                                        <i class="bi bi-arrow-counterclockwise me-1"></i>Đặt lại
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </form>

                    <!-- Meta bar -->
                    <div class="curriculum-meta-bar">
                        <span class="small text-muted fw-semibold">
                            <i class="bi bi-layers-half text-secondary me-1"></i>${course.totalModules}
                            chương &bull; Hiển thị <strong id="questionVisibleCount"
                                class="text-dark">${filteredQuestionsCount}</strong> / ${totalQuestions} câu hỏi
                            <c:if test="${isSearching}">
                                <span class="badge bg-primary-subtle text-primary border ms-2">Đang lọc</span>
                            </c:if>
                        </span>
                        <button type="button" class="btn-text-toggle" id="toggleAllQuestionBtn"
                            onclick="toggleAllQuestionSections()">
                            <i class="bi bi-arrows-expand me-1"></i><span>Mở rộng tất cả</span>
                        </button>
                    </div>

                    <!-- Thông báo khi filter không tìm thấy câu hỏi nào -->
                    <c:if test="${empty course.modules or (isSearching and filteredQuestionsCount == 0)}">
                        <div id="questionEmptyFilter" class="saas-card p-5 text-center mb-3">
                            <div class="text-muted mb-2"><i class="bi bi-funnel fs-2"></i></div>
                            <h6 class="fw-bold text-dark mb-1">Không tìm thấy câu hỏi nào phù hợp</h6>
                            <p class="small text-muted mb-3">Thử thay đổi từ khóa tìm kiếm hoặc chọn lại các bộ lọc.</p>
                            <a href="${pageContext.request.contextPath}/quizzes/questions?courseId=${course.id}"
                                class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-arrow-counterclockwise me-1"></i>Xóa tất cả bộ lọc
                            </a>
                        </div>
                    </c:if>

                    <!-- Danh sách câu hỏi theo từng chương dạng SaaS Module Cards -->
                    <div class="udemy-curriculum-container mb-4" id="questionCurriculumContainer">
                        <c:forEach var="m" items="${course.modules}">
                            <c:set var="mHasQuestions" value="${m.hasQuestions}" />
                            <div class="udemy-section-item question-module-section"
                                id="q-module-${m.id}" data-module-id="${m.id}"
                                data-has-questions="${mHasQuestions ? 'true' : 'false'}"
                                data-module-title="${fn:toLowerCase(m.title)}">

                                <!-- Header Chương: Click khu vực tiêu đề để đóng/mở, nút Thêm câu hỏi nằm riêng biệt -->
                                <div class="udemy-section-header ${isSearching ? '' : 'collapsed'}" id="q-header-${m.id}">
                                    <div class="udemy-header-toggle d-flex align-items-center gap-2 flex-grow-1 overflow-hidden ${isSearching ? '' : 'collapsed'}"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#q-collapse-${m.id}"
                                        aria-expanded="${isSearching ? 'true' : 'false'}"
                                        role="button">
                                        <i class="bi bi-chevron-down udemy-chevron"></i>
                                        <span class="badge bg-light text-dark border fw-semibold flex-shrink-0">
                                            Chương ${m.orderIndex}
                                        </span>
                                        <span class="fw-bold text-dark text-truncate">${m.cleanTitle}</span>
                                        <c:choose>
                                            <c:when test="${mHasQuestions}">
                                                <span class="saas-badge saas-badge-published flex-shrink-0 ms-1">
                                                    <span class="badge-dot"></span>${m.questionCount} câu hỏi
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="saas-badge saas-badge-draft flex-shrink-0 ms-1">
                                                    <span class="badge-dot"></span>0 câu hỏi
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Nút thêm câu hỏi: Hoàn toàn tách biệt khỏi collapse trigger -->
                                    <div class="flex-shrink-0" onclick="event.stopPropagation();">
                                        <button type="button"
                                            class="btn-saas-outline-emerald"
                                            onclick="event.stopPropagation(); openCreateQuestionModal('${m.id}')"
                                            data-bs-toggle="modal" data-bs-target="#questionModal">
                                            <i class="bi bi-plus-lg me-1"></i>Thêm câu hỏi
                                        </button>
                                    </div>
                                </div>

                                <!-- Body Chương: Danh sách câu hỏi (Tự động mở khi tìm kiếm) -->
                                <div class="collapse udemy-section-body ${isSearching ? 'show' : ''}"
                                    id="q-collapse-${m.id}">
                                    <c:choose>
                                        <c:when test="${not mHasQuestions}">
                                            <div class="py-3 px-4 bg-light d-flex align-items-center justify-content-between text-muted small">
                                                <span class="d-flex align-items-center gap-1.5 text-secondary">
                                                    <i class="bi bi-info-circle text-muted"></i>
                                                    Chưa có câu hỏi nào trong chương này
                                                </span>
                                                <button type="button"
                                                    class="btn btn-sm btn-link text-success text-decoration-none fw-semibold p-0"
                                                    onclick="openCreateQuestionModal('${m.id}')">
                                                    + Thêm câu hỏi ngay
                                                </button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive bg-white">
                                                <table class="table clean-table mb-0 align-middle">
                                                    <thead>
                                                        <tr>
                                                            <th style="width: 65px;"
                                                                class="text-center">ID</th>
                                                            <th>Nội dung câu hỏi &amp; Đáp án đúng</th>
                                                            <th style="width: 140px;"
                                                                class="text-center">Dạng câu</th>
                                                            <th style="width: 90px;"
                                                                class="text-center">Điểm</th>
                                                            <th style="width: 110px;"
                                                                class="text-end pe-3">Hành động</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="q" items="${m.questions}">
                                                            <tr class="question-row"
                                                                data-module-id="${q.moduleId}"
                                                                data-type="${q.questionType}"
                                                                data-text="${fn:toLowerCase(fn:escapeXml(q.questionText))}"
                                                                data-q-id="${q.id}"
                                                                data-q-points="${q.defaultPoints}"
                                                                data-q-text="${fn:escapeXml(q.questionText)}">
                                                                <td class="text-center text-muted small fw-semibold">
                                                                    #${q.id}
                                                                    <!-- Hidden Options Data for Edit Modal -->
                                                                    <div class="d-none question-options-data">
                                                                        <c:forEach var="opt" items="${q.options}">
                                                                            <span class="q-opt-item"
                                                                                  data-text="<c:out value='${opt.optionText}' />"
                                                                                  data-correct="${opt.correct}"></span>
                                                                        </c:forEach>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="question-text-title mb-1">
                                                                        <c:out value="${q.questionText}" />
                                                                    </div>

                                                                    <!-- Hiển thị đáp án đúng & toggle xem chi tiết options -->
                                                                    <div class="d-flex flex-wrap align-items-center gap-2 mt-1">
                                                                        <c:set var="correctOptText" value="" />
                                                                        <c:forEach var="opt" items="${q.options}">
                                                                            <c:if test="${opt.correct}">
                                                                                <c:set var="correctOptText" value="${opt.optionText}" />
                                                                            </c:if>
                                                                        </c:forEach>

                                                                        <c:if test="${not empty correctOptText}">
                                                                            <span class="correct-answer-snippet">
                                                                                <i class="bi bi-check-circle-fill"></i>
                                                                                <span>Đáp án đúng: <strong><c:out value="${correctOptText}" /></strong></span>
                                                                            </span>
                                                                        </c:if>

                                                                        <c:if test="${q.answerCount > 0}">
                                                                            <span class="badge bg-secondary-subtle text-secondary border px-2 py-0.5" style="font-size: 0.72rem;" title="Đã có ${q.answerCount} bài làm của học viên liên quan">
                                                                                <i class="bi bi-lock-fill me-1"></i>Đã thi (${q.answerCount})
                                                                            </span>
                                                                        </c:if>
                                                                        <c:if test="${q.assignmentCount > 0}">
                                                                            <span class="badge bg-primary-subtle text-primary border px-2 py-0.5" style="font-size: 0.72rem;" title="Đang được sử dụng trong bài kiểm tra">
                                                                                <i class="bi bi-link-45deg me-1"></i>Đang dùng
                                                                            </span>
                                                                        </c:if>

                                                                        <c:if test="${not empty q.options}">
                                                                            <button type="button"
                                                                                class="btn btn-xs btn-outline-secondary py-0 px-2 rounded-pill text-decoration-none"
                                                                                data-bs-toggle="collapse"
                                                                                data-bs-target="#options-collapse-${q.id}"
                                                                                title="Xem danh sách tất cả các phương án">
                                                                                <i class="bi bi-list-ul me-1"></i>Xem ${fn:length(q.options)} lựa chọn
                                                                            </button>
                                                                        </c:if>
                                                                    </div>

                                                                    <!-- Danh sách các lựa chọn có thể mở ra khi bấm -->
                                                                    <c:if test="${not empty q.options}">
                                                                        <div class="collapse mt-2" id="options-collapse-${q.id}">
                                                                            <div class="p-2.5 rounded-3 bg-light border row g-2 small">
                                                                                <c:forEach var="opt" items="${q.options}" varStatus="optStatus">
                                                                                    <div class="col-md-6 col-12">
                                                                                        <div class="option-item-preview d-flex align-items-start gap-2 p-1.5 rounded-2 ${opt.correct ? 'bg-success-subtle text-success fw-semibold border border-success-subtle' : 'bg-white border text-secondary'}">
                                                                                            <span class="badge ${opt.correct ? 'bg-success text-white' : 'bg-secondary-subtle text-secondary'} rounded-circle px-1.5 py-1"
                                                                                                style="font-size: 0.7rem; width: 20px; height: 20px; display: inline-flex; align-items: center; justify-content: center;">
                                                                                                ${optStatus.index == 0 ? 'A' : (optStatus.index == 1 ? 'B' : (optStatus.index == 2 ? 'C' : 'D'))}
                                                                                            </span>
                                                                                            <span class="text-break"><c:out value="${opt.optionText}" /></span>
                                                                                            <c:if test="${opt.correct}">
                                                                                                 <i class="bi bi-check2 text-success ms-auto flex-shrink-0"></i>
                                                                                            </c:if>
                                                                                        </div>
                                                                                    </div>
                                                                                </c:forEach>
                                                                            </div>
                                                                        </div>
                                                                    </c:if>
                                                                </td>
                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${q.questionType == 'TRUE_FALSE'}">
                                                                            <span class="saas-badge saas-badge-pending">
                                                                                <span class="badge-dot"></span>Đúng / Sai
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="saas-badge saas-badge-blue">
                                                                                <span class="badge-dot"></span>Trắc nghiệm
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-center">
                                                                    <span class="badge bg-light text-dark border px-2 py-1">${q.defaultPoints} đ</span>
                                                                </td>
                                                                <td class="text-end pe-3 text-nowrap">
                                                                    <div class="d-inline-flex align-items-center gap-1">
                                                                        <button type="button"
                                                                            class="btn-icon-action"
                                                                            title="Sửa câu hỏi"
                                                                            onclick="openEditQuestionModal(this)">
                                                                            <i class="bi bi-pencil-square"></i>
                                                                        </button>
                                                                        <c:choose>
                                                                            <c:when test="${q.answerCount > 0}">
                                                                                <button type="button"
                                                                                    class="btn-icon-action text-muted"
                                                                                    title="Đã có ${q.answerCount} bài làm của học viên liên quan (không thể xóa)"
                                                                                    onclick="alert('Không thể xóa câu hỏi này vì đã có ${q.answerCount} bài làm của học viên liên kết với câu hỏi trong lịch sử thi!');">
                                                                                    <i class="bi bi-lock-fill text-warning"></i>
                                                                                </button>
                                                                            </c:when>
                                                                            <c:when test="${q.assignmentCount > 0}">
                                                                                <button type="button"
                                                                                    class="btn-icon-action text-muted"
                                                                                    title="Câu hỏi đang được gán trong bài kiểm tra (vui lòng gỡ khỏi bài thi trước khi xóa)"
                                                                                    onclick="alert('Không thể xóa câu hỏi vì đang được sử dụng trong bài kiểm tra. Vui lòng gỡ câu hỏi khỏi bài kiểm tra trước!');">
                                                                                    <i class="bi bi-link-45deg text-primary"></i>
                                                                                </button>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <button type="button"
                                                                                    class="btn-icon-action text-danger"
                                                                                    onclick="openDeleteQuestionModal('${q.id}', '${fn:escapeXml(fn:substring(q.questionText, 0, 80))}', '${course.id}')"
                                                                                    data-bs-toggle="modal"
                                                                                    data-bs-target="#deleteQuestionModal"
                                                                                    title="Xóa câu hỏi">
                                                                                    <i class="bi bi-trash3"></i>
                                                                                </button>
                                                                            </c:otherwise>
                                                                        </c:choose>
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
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<!-- ======================================================= -->
<!-- MODAL: THÊM CÂU HỎI MỚI VÀO NGÂN HÀNG CỦA KHÓA HỌC       -->
<!-- ======================================================= -->
<div class="modal fade" id="questionModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content saas-modal">
            <form action="${pageContext.request.contextPath}/quizzes/save-question" method="POST"
                id="bankQuestionForm">
                <input type="hidden" name="from" value="questions">
                <input type="hidden" name="id" id="modalQId" value="">
                <c:if test="${not empty course}">
                    <input type="hidden" name="courseId" value="${course.id}">
                </c:if>

                <div class="modal-header saas-modal-header">
                    <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2">
                        <span class="text-success" id="questionModalIcon"><i class="bi bi-database-add"></i></span>
                        <span id="questionModalTitle">Tạo câu hỏi mới vào Ngân hàng</span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                        aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row g-3 mb-3">
                        <div class="col-md-6 col-12">
                            <label class="saas-form-label">Thuộc chương học
                                <span class="text-danger">*</span></label>
                            <select name="moduleId" id="modalQModuleSelect" class="form-select saas-form-control"
                                required>
                                <c:forEach var="m" items="${course.modules}">
                                    <option value="${m.id}">${m.displayTitle}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3 col-6">
                            <label class="saas-form-label">Loại câu hỏi <span
                                    class="text-danger">*</span></label>
                            <select name="questionType" id="modalQType" class="form-select saas-form-control"
                                onchange="handleModalQTypeChange(this.value)">
                                <option value="SINGLE_CHOICE">Trắc nghiệm</option>
                                <option value="TRUE_FALSE">Đúng / Sai</option>
                            </select>
                        </div>
                        <div class="col-md-3 col-6">
                            <label class="saas-form-label">Điểm mặc định
                                <span class="text-danger">*</span></label>
                            <input type="number" step="0.5" name="defaultPoints" id="modalQPoints"
                                class="form-control saas-form-control" value="1.0" min="0.5" max="100" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="saas-form-label">Nội dung câu hỏi <span
                                class="text-danger">*</span></label>
                        <textarea name="questionText" id="modalQText" rows="3"
                            class="form-control saas-form-control"
                            placeholder="Nhập nội dung câu hỏi chi tiết tại đây..."
                            required></textarea>
                    </div>

                    <div class="mb-2">
                        <label class="saas-form-label d-flex justify-content-between">
                            <span>Danh sách đáp án lựa chọn <span class="text-danger">*</span></span>
                            <span class="text-muted fw-normal small">Chọn nút tròn để chỉ định đáp án đúng</span>
                        </label>

                        <!-- Option A -->
                        <div class="input-group mb-2 shadow-xs">
                            <label class="input-group-text bg-light border-end-0 mb-0" for="radioOptA" style="cursor: pointer;">
                                <input class="form-check-input mt-0" type="radio" id="radioOptA"
                                    name="correctOption" value="0" checked
                                    title="Chọn làm đáp án đúng" style="cursor: pointer;">
                            </label>
                            <label class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0 mb-0" for="radioOptA"
                                style="min-width: 40px; justify-content: center; cursor: pointer;">A</label>
                            <input type="text" name="optionText" id="modalQOptA"
                                class="form-control border-start-0"
                                placeholder="Nội dung đáp án A..." required>
                        </div>

                        <!-- Option B -->
                        <div class="input-group mb-2 shadow-xs">
                            <label class="input-group-text bg-light border-end-0 mb-0" for="radioOptB" style="cursor: pointer;">
                                <input class="form-check-input mt-0" type="radio" id="radioOptB"
                                    name="correctOption" value="1"
                                    title="Chọn làm đáp án đúng" style="cursor: pointer;">
                            </label>
                            <label class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0 mb-0" for="radioOptB"
                                style="min-width: 40px; justify-content: center; cursor: pointer;">B</label>
                            <input type="text" name="optionText" id="modalQOptB"
                                class="form-control border-start-0"
                                placeholder="Nội dung đáp án B..." required>
                        </div>

                        <!-- Option C -->
                        <div class="input-group mb-2 shadow-xs" id="modalQOptGroupC">
                            <label class="input-group-text bg-light border-end-0 mb-0" for="radioOptC" style="cursor: pointer;">
                                <input class="form-check-input mt-0" type="radio" id="radioOptC"
                                    name="correctOption" value="2"
                                    title="Chọn làm đáp án đúng" style="cursor: pointer;">
                            </label>
                            <label class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0 mb-0" for="radioOptC"
                                style="min-width: 40px; justify-content: center; cursor: pointer;">C</label>
                            <input type="text" name="optionText" id="modalQOptC"
                                class="form-control border-start-0"
                                placeholder="Đáp án C (tùy chọn)...">
                        </div>

                        <!-- Option D -->
                        <div class="input-group mb-2 shadow-xs" id="modalQOptGroupD">
                            <label class="input-group-text bg-light border-end-0 mb-0" for="radioOptD" style="cursor: pointer;">
                                <input class="form-check-input mt-0" type="radio" id="radioOptD"
                                    name="correctOption" value="3"
                                    title="Chọn làm đáp án đúng" style="cursor: pointer;">
                            </label>
                            <label class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0 mb-0" for="radioOptD"
                                style="min-width: 40px; justify-content: center; cursor: pointer;">D</label>
                            <input type="text" name="optionText" id="modalQOptD"
                                class="form-control border-start-0"
                                placeholder="Đáp án D (tùy chọn)...">
                        </div>
                    </div>
                </div>

                <div class="modal-footer saas-modal-footer">
                    <button type="button" class="btn-saas-outline"
                        data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" id="questionModalSubmitBtn"
                        class="btn-saas-outline-emerald">
                        <i class="bi bi-save me-1"></i><span id="questionModalSubmitText">Lưu vào ngân hàng</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ======================================================= -->
<!-- MODAL: XÁC NHẬN XÓA CÂU HỎI                            -->
<!-- ======================================================= -->
<div class="modal fade" id="deleteQuestionModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content saas-modal">
            <div class="modal-body text-center p-4">
                <div class="bg-danger-subtle text-danger rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                    style="width: 52px; height: 52px; font-size: 1.35rem;">
                    <i class="bi bi-trash3-fill"></i>
                </div>
                <h5 class="fw-bold text-dark mb-1">Xác nhận xóa câu hỏi?</h5>
                <p class="small text-muted mb-4" id="deleteQuestionSnippet">
                    Câu hỏi này sẽ bị xóa khỏi ngân hàng câu hỏi của khóa học.
                </p>
                <div class="d-flex justify-content-center gap-2">
                    <button type="button" class="btn-saas-outline"
                        data-bs-dismiss="modal">Hủy</button>
                    <a href="#" id="confirmDeleteQuestionLink"
                        class="btn btn-danger btn-sm fw-semibold rounded-3 px-3">
                        <i class="bi bi-trash3 me-1"></i>Xóa câu hỏi
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleAllQuestionSections() {
        const container = document.getElementById('questionCurriculumContainer');
        if (!container) return;
        const collapses = container.querySelectorAll('.collapse');
        const btn = document.getElementById('toggleAllQuestionBtn');
        let anyOpen = false;
        collapses.forEach(c => {
            if (c.classList.contains('show')) anyOpen = true;
        });

        collapses.forEach(c => {
            const bsCollapse = bootstrap.Collapse.getOrCreateInstance(c, { toggle: false });
            if (anyOpen) {
                bsCollapse.hide();
            } else {
                bsCollapse.show();
            }
        });

        if (btn) {
            if (anyOpen) {
                btn.innerHTML = '<i class="bi bi-arrows-expand me-1"></i><span>Mở rộng tất cả</span>';
            } else {
                btn.innerHTML = '<i class="bi bi-arrows-collapse me-1"></i><span>Thu gọn tất cả</span>';
            }
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const qContainer = document.getElementById('questionCurriculumContainer');
        if (qContainer) {
            qContainer.addEventListener('show.bs.collapse', function (e) {
                const item = e.target.closest('.udemy-section-item');
                if (item) {
                    const header = item.querySelector('.udemy-section-header');
                    if (header) header.classList.remove('collapsed');
                    const toggle = item.querySelector('.udemy-header-toggle');
                    if (toggle) toggle.classList.remove('collapsed');
                }
            });
            qContainer.addEventListener('hide.bs.collapse', function (e) {
                const item = e.target.closest('.udemy-section-item');
                if (item) {
                    const header = item.querySelector('.udemy-section-header');
                    if (header) header.classList.add('collapsed');
                    const toggle = item.querySelector('.udemy-header-toggle');
                    if (toggle) toggle.classList.add('collapsed');
                }
            });
            qContainer.addEventListener('shown.bs.collapse', syncQuestionToggleBtn);
            qContainer.addEventListener('hidden.bs.collapse', syncQuestionToggleBtn);
        }

        function syncQuestionToggleBtn() {
            const btn = document.getElementById('toggleAllQuestionBtn');
            if (!btn || !qContainer) return;
            const anyOpen = Array.from(qContainer.querySelectorAll('.collapse')).some(c => c.classList.contains('show'));
            btn.innerHTML = anyOpen
                ? '<i class="bi bi-arrows-collapse me-1"></i><span>Thu gọn tất cả</span>'
                : '<i class="bi bi-arrows-expand me-1"></i><span>Mở rộng tất cả</span>';
        }

    });

    function handleModalQTypeChange(type) {
        const optC = document.getElementById('modalQOptGroupC');
        const optD = document.getElementById('modalQOptGroupD');
        const textA = document.getElementById('modalQOptA');
        const textB = document.getElementById('modalQOptB');

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
        ['modalQOptA','modalQOptB','modalQOptC','modalQOptD'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.value = '';
        });
        const firstRadio = document.querySelector('#bankQuestionForm input[name="correctOption"][value="0"]');
        if (firstRadio) firstRadio.checked = true;
        const icon = document.getElementById('questionModalIcon');
        if (icon) {
            icon.innerHTML = '<i class="bi bi-database-add"></i>';
            icon.className = 'text-success';
        }
        const title = document.getElementById('questionModalTitle');
        if (title) title.textContent = 'Tạo câu hỏi mới vào Ngân hàng';
        const submitBtn = document.getElementById('questionModalSubmitBtn');
        if (submitBtn) submitBtn.className = 'btn-saas-outline-emerald';
        const submitText = document.getElementById('questionModalSubmitText');
        if (submitText) submitText.textContent = 'Lưu vào ngân hàng';
        const qType = document.getElementById('modalQType');
        if (qType) qType.value = 'SINGLE_CHOICE';
        handleModalQTypeChange('SINGLE_CHOICE');
        const modalEl = document.getElementById('questionModal');
        if (modalEl) {
            bootstrap.Modal.getOrCreateInstance(modalEl).show();
        }
    }

    function openEditQuestionModal(btn) {
        const tr = btn.closest('tr.question-row');
        if (!tr) return;

        const qId      = tr.getAttribute('data-q-id');
        const qText    = tr.getAttribute('data-q-text');
        const qPoints  = tr.getAttribute('data-q-points');
        const qType    = tr.getAttribute('data-type');
        const moduleId = tr.getAttribute('data-module-id');

        document.getElementById('modalQId').value = qId;
        document.getElementById('modalQText').value = qText;
        document.getElementById('modalQPoints').value = qPoints;
        const typeEl = document.getElementById('modalQType');
        if (typeEl) typeEl.value = qType;
        const modSel = document.getElementById('modalQModuleSelect');
        if (modSel && moduleId) modSel.value = moduleId;

        const optItems = tr.querySelectorAll('.q-opt-item');
        const optIds   = ['modalQOptA', 'modalQOptB', 'modalQOptC', 'modalQOptD'];
        const radios   = document.querySelectorAll('#bankQuestionForm input[name="correctOption"]');
        optIds.forEach((id, i) => {
            const el = document.getElementById(id);
            if (!el) return;
            const optItem = optItems[i];
            el.value = optItem ? (optItem.getAttribute('data-text') || '') : '';
            const isCorrect = optItem ? (optItem.getAttribute('data-correct') === 'true') : (i === 0);
            if (radios[i]) radios[i].checked = isCorrect;
        });

        handleModalQTypeChange(qType);

        const icon = document.getElementById('questionModalIcon');
        if (icon) { icon.innerHTML = '<i class="bi bi-pencil-square"></i>'; icon.className = 'text-primary'; }
        const titleEl = document.getElementById('questionModalTitle');
        if (titleEl) titleEl.textContent = 'Chỉnh sửa câu hỏi #' + qId;
        const submitBtn = document.getElementById('questionModalSubmitBtn');
        if (submitBtn) submitBtn.className = 'btn-saas-primary';
        const submitText = document.getElementById('questionModalSubmitText');
        if (submitText) submitText.textContent = 'Lưu thay đổi';

        const modalEl = document.getElementById('questionModal');
        if (modalEl) bootstrap.Modal.getOrCreateInstance(modalEl).show();
    }

    function openDeleteQuestionModal(id, textSnippet, courseId) {
        const textEl = document.getElementById('deleteQuestionSnippet');
        if (textEl) {
            textEl.textContent = 'Bạn có chắc chắn muốn xóa câu hỏi: "' + textSnippet + '"?';
        }
        const link = document.getElementById('confirmDeleteQuestionLink');
        if (link) {
            link.href = '${pageContext.request.contextPath}/quizzes/delete-question?id=' + id + (courseId ? '&courseId=' + courseId : '');
        }
        const modalEl = document.getElementById('deleteQuestionModal');
        if (modalEl) {
            bootstrap.Modal.getOrCreateInstance(modalEl).show();
        }
    }
</script>

<jsp:include page="../common/footer.jsp" />

