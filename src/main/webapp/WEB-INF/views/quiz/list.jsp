<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

                <c:set var="pageTitle"
    value="Quản lý Quiz - ${not empty course ? course.title : 'Courson LMS'}" />
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

/* Filter Buttons */
.module-filter-btn {
    font-size: 0.8125rem;
    font-weight: 500;
    padding: 6px 12px;
    border-radius: 6px;
    border: 1px solid var(--saas-border);
    background: #ffffff;
    color: var(--saas-text-body);
    transition: all 0.15s ease;
}
.module-filter-btn:hover {
    background: #f8fafc;
    color: var(--saas-text-heading);
}
.module-filter-btn.active {
    background: #0f172a !important;
    border-color: #0f172a !important;
    color: #ffffff !important;
    font-weight: 600;
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

.correct-answer-snippet {
    font-size: 0.775rem;
    color: #059669;
    background: #ecfdf5;
    border: 1px solid #d1fae5;
    border-radius: 6px;
    padding: 0.2rem 0.5rem;
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    max-width: 100%;
}
.btn-xs {
    font-size: 0.75rem;
    padding: 0.2rem 0.5rem;
    border-radius: 0.375rem;
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
                            <span class="current">Quản lý Quiz</span>
                        </nav>

                        <!-- System Alerts -->
                        <c:if test="${not empty param.success}">
                            <div class="saas-alert saas-alert-success alert-dismissible fade show" role="alert">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="bi bi-check-circle-fill fs-5"></i>
                                    <div>
                                        <c:choose>
                                            <c:when test="${param.success == 'deleted'}">Đã xóa bài kiểm tra thành công.</c:when>
                                            <c:when test="${param.success == 'saved'}">Đã lưu thông tin cấu hình bài kiểm tra thành công.</c:when>
                                            <c:when test="${param.success == 'activated'}">Đã kích hoạt hiển thị bài thi cho học viên.</c:when>
                                            <c:when test="${param.success == 'deactivated'}">Đã ẩn bài thi đối với học viên.</c:when>
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
                                    <span class="saas-stat-icon saas-icon-blue" style="width: 36px; height: 36px; border-radius: 10px;">
                                        <i class="bi bi-patch-question-fill"></i>
                                    </span>
                                    <span>Quản lý Quiz: ${course.title}</span>
                                </h1>
                                <p class="saas-subtitle">
                                    Quản lý bài kiểm tra theo từng chương của khóa học
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
                                        data-bs-toggle="modal" data-bs-target="#quizModal"
                                        onclick="openCreateQuizModal('')">
                                        <i class="bi bi-plus-lg me-1"></i>Tạo bài Quiz mới
                                    </button>
                                </c:if>
                            </div>
                        </div>

                        <!-- Main Tabs Navigation (Dedicated Screens) -->
                        <ul class="nav nav-tabs saas-tabs mb-4" id="assessmentTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}">
                                    <i class="bi bi-collection"></i>Danh sách Quiz
                                    <span class="tab-count-badge">${totalQuizzes}</span>
                                </a>
                            </li>
                            <li class="nav-item" role="presentation">
                                <a class="nav-link" href="${pageContext.request.contextPath}/quizzes/questions?courseId=${course.id}">
                                    <i class="bi bi-database"></i>Ngân hàng câu hỏi
                                    <span class="tab-count-badge" id="totalQuestionsBadge">${totalQuestions}</span>
                                </a>
                            </li>
                        </ul>

                        <!-- TAB 1: DANH SÁCH BÀI QUIZ THEO TỪNG CHƯƠNG -->
                        <div id="pills-quizzes">
                                <c:choose>
                                    <c:when test="${empty course or empty allModules}">
                                        <div class="saas-card p-5 text-center mb-4">
                                            <div class="bg-light text-muted rounded-circle d-inline-flex align-items-center justify-content-center mx-auto mb-3"
                                                style="width: 64px; height: 64px;">
                                                <i class="bi bi-folder-x fs-2"></i>
                                            </div>
                                            <h5 class="fw-bold text-dark mb-1">Khóa học này chưa có chương học nào!</h5>
                                            <p class="text-muted small mb-3">Bạn cần tạo ít nhất một chương học để có
                                                thể thiết lập các bài kiểm tra trắc nghiệm.</p>
                                            <div>
                                                <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}"
                                                    class="btn-saas-primary">
                                                    <i class="bi bi-plus-circle me-1"></i>Tạo chương học ngay
                                                </a>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="isSearching" value="${not empty keyword or not empty filterModuleId or (not empty filterMode and filterMode != 'all')}" />

                                        <!-- Thanh công cụ tìm kiếm & lọc Tab 1 (Server-side Filtering) -->
                                        <form id="quizFilterForm" action="${pageContext.request.contextPath}/quizzes/list" method="GET" class="saas-toolbar">
                                            <input type="hidden" name="courseId" value="${course.id}">
                                            <div class="row g-2 align-items-center">
                                                <div class="col-md-5 col-12">
                                                    <div class="input-group input-group-sm">
                                                        <span class="input-group-text bg-light border-end-0 text-muted">
                                                            <i class="bi bi-search"></i>
                                                        </span>
                                                        <input type="text" name="keyword" id="quizSearchInput"
                                                            class="form-control border-start-0 bg-light"
                                                            placeholder="Tìm kiếm bài thi theo tên..."
                                                            value="<c:out value='${keyword}'/>">
                                                        <c:if test="${not empty keyword}">
                                                            <a href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}&filterModuleId=${filterModuleId}&filterMode=${filterMode}"
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
                                                    <select id="quizModuleFilter" name="filterModuleId"
                                                        class="form-select form-select-sm bg-light" onchange="document.getElementById('quizFilterForm').submit()">
                                                        <option value="">Tất cả chương học</option>
                                                        <c:forEach var="moduleItem" items="${allModules}">
                                                            <option value="${moduleItem.id}" ${filterModuleId == moduleItem.id ? 'selected' : ''}>
                                                                Chương ${moduleItem.orderIndex}: <c:out value="${moduleItem.title}" />
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <div class="col-md-3 col-sm-6 col-12 d-flex align-items-center gap-2">
                                                    <select id="quizModeFilter" name="filterMode"
                                                        class="form-select form-select-sm bg-light" onchange="document.getElementById('quizFilterForm').submit()">
                                                        <option value="all" ${empty filterMode or filterMode == 'all' ? 'selected' : ''}>Tất cả chương</option>
                                                        <option value="has-quiz" ${filterMode == 'has-quiz' ? 'selected' : ''}>Chỉ chương có Quiz</option>
                                                    </select>

                                                    <c:if test="${isSearching}">
                                                        <a href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}"
                                                            class="btn btn-sm btn-link text-danger text-decoration-none text-nowrap p-0" title="Đặt lại bộ lọc">
                                                            <i class="bi bi-arrow-counterclockwise me-1"></i>Đặt lại
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </form>

                                        <!-- Meta bar: Thông tin số lượng & nút text Thu gọn / Mở rộng tất cả -->
                                        <div class="curriculum-meta-bar">
                                            <span class="small text-muted fw-semibold">
                                                <i class="bi bi-layers-half text-secondary me-1"></i>${course.totalModules}
                                                chương &bull; Hiển thị <strong class="text-dark">${filteredQuizzesCount}</strong> / ${totalQuizzes} bài thi
                                                <c:if test="${isSearching}">
                                                    <span class="badge bg-primary-subtle text-primary border ms-2">Đang lọc</span>
                                                </c:if>
                                            </span>
                                            <button type="button" class="btn-text-toggle" id="toggleAllQuizBtn"
                                                onclick="toggleAllQuizSections()">
                                                <i class="bi bi-arrows-expand me-1"></i><span>Mở rộng tất cả</span>
                                            </button>
                                        </div>

                                        <!-- Thông báo khi filter không tìm thấy quiz nào -->
                                        <c:if test="${empty course.modules or (isSearching and filteredQuizzesCount == 0)}">
                                            <div id="quizTabNoResult" class="saas-card p-5 text-center mb-3">
                                                <div class="text-muted mb-2"><i class="bi bi-funnel fs-2"></i></div>
                                                <h6 class="fw-bold text-dark mb-1">Không tìm thấy bài Quiz nào phù hợp</h6>
                                                <p class="small text-muted mb-3">Thử thay đổi từ khóa tìm kiếm hoặc chọn lại các bộ lọc.</p>
                                                <a href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}"
                                                    class="btn btn-sm btn-outline-secondary">
                                                    <i class="bi bi-arrow-counterclockwise me-1"></i>Xóa tất cả bộ lọc
                                                </a>
                                            </div>
                                        </c:if>

                                        <!-- Danh sách Modules & Quizzes dạng SaaS Module Cards -->
                                        <div class="udemy-curriculum-container mb-4" id="quizCurriculumContainer">
                                            <c:forEach var="m" items="${course.modules}">
                                                <c:set var="mHasQuizzes" value="${m.hasQuizzes}" />
                                                <div class="udemy-section-item" id="module-${m.id}"
                                                    data-has-quizzes="${mHasQuizzes ? 'true' : 'false'}"
                                                    data-module-title="${fn:toLowerCase(m.title)}">

                                                    <!-- Header: Click khu vực tiêu đề để toggle collapse, nút Tạo Quiz nằm riêng biệt -->
                                                    <div class="udemy-section-header ${isSearching ? '' : 'collapsed'}" id="quiz-header-${m.id}">
                                                        <div class="udemy-header-toggle d-flex align-items-center gap-2 flex-grow-1 overflow-hidden ${isSearching ? '' : 'collapsed'}"
                                                            data-bs-toggle="collapse"
                                                            data-bs-target="#quiz-collapse-${m.id}"
                                                            aria-expanded="${isSearching ? 'true' : 'false'}"
                                                            role="button">
                                                            <i class="bi bi-chevron-down udemy-chevron"></i>
                                                            <span class="badge bg-light text-dark border fw-semibold flex-shrink-0">
                                                                Chương ${m.orderIndex}
                                                            </span>
                                                            <span class="fw-bold text-dark text-truncate">${m.cleanTitle}</span>
                                                            <c:choose>
                                                                <c:when test="${mHasQuizzes}">
                                                                    <span class="saas-badge saas-badge-blue flex-shrink-0 ms-1">
                                                                        <span class="badge-dot"></span>${m.quizCount} bài quiz
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="saas-badge saas-badge-draft flex-shrink-0 ms-1">
                                                                        <span class="badge-dot"></span>0 bài quiz
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>

                                                        <!-- Nút tạo quiz: Hoàn toàn tách biệt khỏi collapse trigger -->
                                                        <div class="flex-shrink-0" onclick="event.stopPropagation();">
                                                            <button type="button"
                                                                class="btn-saas-outline"
                                                                onclick="event.stopPropagation(); openCreateQuizModal('${m.id}', '${m.quizCount + 1}')"
                                                                data-bs-toggle="modal" data-bs-target="#quizModal">
                                                                <i class="bi bi-plus-lg me-1"></i>Tạo Quiz
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <!-- Body: Collapsible (Closed by default, opened when searching) -->
                                                    <div class="collapse udemy-section-body ${isSearching ? 'show' : ''}"
                                                        id="quiz-collapse-${m.id}">
                                                        <c:choose>
                                                            <c:when test="${not mHasQuizzes}">
                                                                <div class="py-3 px-4 bg-light d-flex align-items-center justify-content-between text-muted small">
                                                                    <span class="d-flex align-items-center gap-1.5 text-secondary">
                                                                        <i class="bi bi-info-circle text-muted"></i>
                                                                        Chưa có bài kiểm tra nào trong chương này
                                                                    </span>
                                                                    <button type="button"
                                                                        class="btn btn-sm btn-link text-primary text-decoration-none fw-semibold p-0"
                                                                        onclick="openCreateQuizModal('${m.id}', 1)">
                                                                        + Tạo bài Quiz ngay
                                                                    </button>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="table-responsive bg-white">
                                                                    <table class="table clean-table mb-0 align-middle">
                                                                        <thead>
                                                                            <tr>
                                                                                <th style="width: 60px;"
                                                                                    class="text-center">TT</th>
                                                                                <th>Tên bài thi (Quiz)</th>
                                                                                <th style="width: 120px;"
                                                                                    class="text-center">Điểm đạt</th>
                                                                                <th style="width: 120px;"
                                                                                    class="text-center">Thời lượng</th>
                                                                                <th style="width: 130px;"
                                                                                    class="text-center">Trạng thái</th>
                                                                                <th style="width: 130px;"
                                                                                    class="text-end pe-3">Hành động</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <c:forEach var="q" items="${m.quizzes}">
                                                                                <tr class="quiz-row"
                                                                                    data-quiz-title="${fn:toLowerCase(q.title)}">
                                                                                    <td class="text-center">
                                                                                        <span class="badge bg-light text-muted border">#${q.orderIndex}</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div>
                                                                                            <a href="${pageContext.request.contextPath}/quizzes/detail?id=${q.id}&courseId=${course.id}"
                                                                                                class="fw-semibold text-dark text-decoration-none"
                                                                                                style="transition: color 0.15s ease;"
                                                                                                onmouseover="this.style.color='var(--saas-accent)'"
                                                                                                onmouseout="this.style.color='var(--saas-text-heading)'">
                                                                                                ${q.title}
                                                                                            </a>
                                                                                            <span class="small text-muted d-block" style="font-size: 0.75rem;">
                                                                                                 Mã đề: #${q.id}
                                                                                                <c:if test="${q.attemptCount > 0}">
                                                                                                    • <span class="text-primary fw-semibold" title="Đã có ${q.attemptCount} lượt học viên làm bài"><i class="bi bi-people-fill me-1"></i>${q.attemptCount} lượt thi</span>
                                                                                                </c:if>
                                                                                            </span>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td class="text-center">
                                                                                        <span class="saas-badge saas-badge-published">
                                                                                            <span class="badge-dot"></span>${q.passScore}%
                                                                                        </span>
                                                                                    </td>
                                                                                    <td class="text-center">
                                                                                        <c:choose>
                                                                                            <c:when test="${q.timeLimitMinutes != null and q.timeLimitMinutes > 0}">
                                                                                                <span class="badge bg-light text-dark border px-2 py-1">
                                                                                                    <i class="bi bi-stopwatch text-primary me-1"></i>${q.timeLimitMinutes} phút
                                                                                                </span>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span class="badge bg-light text-muted border px-2 py-1">Tự do</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td class="text-center">
                                                                                        <c:choose>
                                                                                            <c:when test="${q.active}">
                                                                                                <a href="${pageContext.request.contextPath}/quizzes/toggle-active?id=${q.id}&courseId=${course.id}"
                                                                                                   class="saas-badge saas-badge-published text-decoration-none"
                                                                                                   title="Bấm để ẩn bài thi đối với học viên">
                                                                                                    <span class="badge-dot"></span>Hiển thị
                                                                                                </a>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <a href="${pageContext.request.contextPath}/quizzes/toggle-active?id=${q.id}&courseId=${course.id}"
                                                                                                   class="saas-badge saas-badge-draft text-decoration-none"
                                                                                                   title="Bấm để hiển thị bài thi cho học viên">
                                                                                                    <span class="badge-dot"></span>Đang ẩn
                                                                                                </a>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td class="text-end pe-3">
                                                                                        <div class="d-inline-flex align-items-center gap-1">
                                                                                            <a href="${pageContext.request.contextPath}/quizzes/toggle-active?id=${q.id}&courseId=${course.id}"
                                                                                                class="btn-icon-action ${q.active ? 'text-success' : 'text-secondary'}"
                                                                                                title="${q.active ? 'Tạm ẩn bài thi đối với học sinh' : 'Hiện bài thi cho học sinh làm bài'}">
                                                                                                <i class="bi ${q.active ? 'bi-eye-fill' : 'bi-eye-slash-fill'}"></i>
                                                                                            </a>
                                                                                            <a href="${pageContext.request.contextPath}/quizzes/detail?id=${q.id}&courseId=${course.id}"
                                                                                                class="btn-icon-action"
                                                                                                title="Cài đặt & chi tiết bài thi">
                                                                                                <i class="bi bi-gear"></i>
                                                                                            </a>
                                                                                            <c:choose>
                                                                                                <c:when test="${q.attemptCount > 0}">
                                                                                                    <button type="button"
                                                                                                        class="btn-icon-action text-muted"
                                                                                                        onclick="alert('Không thể xóa bài kiểm tra vì đã có ${q.attemptCount} lượt làm bài của học viên. Hệ thống cần bảo toàn dữ liệu điểm số và tiến độ học tập!');"
                                                                                                        title="Đã có ${q.attemptCount} lượt thi (không thể xóa để bảo toàn dữ liệu)">
                                                                                                        <i class="bi bi-lock-fill text-warning"></i>
                                                                                                    </button>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <button type="button"
                                                                                                        class="btn-icon-action text-danger"
                                                                                                        onclick="openDeleteQuizModal('${q.id}', '${fn:escapeXml(q.title)}', '${course.id}', '${m.id}')"
                                                                                                        data-bs-toggle="modal"
                                                                                                        data-bs-target="#deleteQuizModal"
                                                                                                        title="Xóa bài Quiz">
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
                <!-- MODAL: TẠO MỚI & CHỈNH SỬA QUIZ                        -->
                <!-- ======================================================= -->
                <div class="modal fade" id="quizModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content saas-modal">
                            <form id="quizForm" action="${pageContext.request.contextPath}/quizzes/save" method="POST">
                                <input type="hidden" name="from" value="list">
                                <input type="hidden" name="id" id="modalQuizId" value="">
                                <c:if test="${not empty course}">
                                    <input type="hidden" name="courseId" value="${course.id}">
                                </c:if>

                                <div class="modal-header saas-modal-header">
                                    <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2"
                                        id="quizModalLabel">
                                        <span class="text-primary"><i class="bi bi-patch-question"></i></span>
                                        Tạo bài kiểm tra mới (Quiz)
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>

                                <div class="modal-body p-4">
                                    <div class="mb-3">
                                        <label class="saas-form-label">Thuộc chương học
                                            <span class="text-danger">*</span></label>
                                        <select name="moduleId" id="modalModuleSelect" class="form-select saas-form-control"
                                            required>
                                            <c:forEach var="m" items="${allModules}">
                                                <option value="${m.id}"><c:out value="${m.displayTitle}" /></option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="saas-form-label">Tên bài kiểm tra
                                            <span class="text-danger">*</span></label>
                                        <input type="text" name="title" id="modalQuizTitle"
                                            class="form-control saas-form-control" placeholder="Ví dụ: Quiz 1 - Tổng quan..."
                                            required>
                                    </div>

                                    <div class="row g-3 mb-3">
                                        <div class="col-6">
                                            <label class="saas-form-label">Điểm đạt tối
                                                thiểu (%) <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <input type="number" name="passScore" id="modalQuizPassScore"
                                                    class="form-control saas-form-control rounded-start-3" value="50" min="0" max="100"
                                                    required>
                                                <span class="input-group-text bg-light text-muted fw-bold">%</span>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <label class="saas-form-label">Thời lượng
                                                (Phút)</label>
                                            <div class="input-group">
                                                <input type="number" name="timeLimitMinutes" id="modalQuizTimeLimit"
                                                    class="form-control saas-form-control rounded-start-3" value="15" min="1"
                                                    placeholder="Để trống nếu tự do">
                                                <span class="input-group-text bg-light text-muted">phút</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="saas-form-label">Thứ tự hiển thị <span
                                                class="text-danger">*</span></label>
                                        <input type="number" name="orderIndex" id="modalQuizOrderIndex"
                                            class="form-control saas-form-control" value="1" min="1" required>
                                        <div id="modalQuizOrderHint" class="form-text small text-muted">
                                            Số thứ tự phải không trùng với bài Quiz khác trong cùng chương.
                                        </div>
                                    </div>

                                    <div class="p-3 bg-light rounded-3 border mb-2">
                                        <div class="form-check form-switch d-flex align-items-center justify-content-between ps-0 mb-0">
                                            <label class="form-check-label fw-semibold text-dark mb-0 cursor-pointer" for="modalQuizActiveSwitch">
                                                <i class="bi bi-eye-slash-fill text-secondary me-1.5" id="modalActiveIcon"></i>Hiển thị cho học viên ngay
                                            </label>
                                            <input class="form-check-input ms-0" type="checkbox" role="switch" id="modalQuizActiveSwitch" name="active" value="true" style="cursor: pointer; width: 2.25em; height: 1.25em;" onchange="updateModalActiveIcon(this)">
                                        </div>
                                        <div class="form-text small text-muted mt-1" style="font-size: 0.75rem;">
                                            Mặc định bài thi sẽ ở trạng thái <strong>Ẩn</strong> để bạn hoàn thiện cấu hình và câu hỏi trước khi phát hành cho học viên.
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-footer saas-modal-footer">
                                    <button type="button" class="btn-saas-outline"
                                        data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit"
                                        class="btn-saas-primary"
                                        id="submitQuizBtn">
                                        <i class="bi bi-save me-1"></i>Lưu bài thi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ======================================================= -->
                <!-- MODAL: XÁC NHẬN XÓA QUIZ                                -->
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
                                <p class="small text-muted mb-4" id="deleteQuizTitle">
                                    Thao tác này sẽ xóa bài kiểm tra khỏi khóa học. Các câu hỏi trong ngân hàng vẫn được
                                    giữ nguyên.
                                </p>
                                <div class="d-flex justify-content-center gap-2">
                                    <button type="button" class="btn-saas-outline"
                                        data-bs-dismiss="modal">Hủy</button>
                                    <a href="#" id="confirmDeleteLink"
                                        class="btn btn-danger btn-sm fw-semibold rounded-3 px-3">
                                        <i class="bi bi-trash3 me-1"></i>Xóa bài thi
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    // 1. Toggling functions cho Accordion ở cả 2 Tab (Dạng text thuần túy, không viền, không box)
                    function toggleAllQuizSections() {
                        const container = document.getElementById('quizCurriculumContainer');
                        if (!container) return;
                        const collapses = container.querySelectorAll('.collapse');
                        const btn = document.getElementById('toggleAllQuizBtn');
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
                        // Tự động đồng bộ trạng thái text nút Toggle và header khi mở/đóng từng chương
                        const quizContainer = document.getElementById('quizCurriculumContainer');
                        if (quizContainer) {
                            quizContainer.addEventListener('show.bs.collapse', function (e) {
                                const item = e.target.closest('.udemy-section-item');
                                if (item) {
                                    const header = item.querySelector('.udemy-section-header');
                                    if (header) header.classList.remove('collapsed');
                                    const toggle = item.querySelector('.udemy-header-toggle');
                                    if (toggle) toggle.classList.remove('collapsed');
                                }
                            });
                            quizContainer.addEventListener('hide.bs.collapse', function (e) {
                                const item = e.target.closest('.udemy-section-item');
                                if (item) {
                                    const header = item.querySelector('.udemy-section-header');
                                    if (header) header.classList.add('collapsed');
                                    const toggle = item.querySelector('.udemy-header-toggle');
                                    if (toggle) toggle.classList.add('collapsed');
                                }
                            });
                            quizContainer.addEventListener('shown.bs.collapse', syncQuizToggleBtn);
                            quizContainer.addEventListener('hidden.bs.collapse', syncQuizToggleBtn);
                        }
                        function syncQuizToggleBtn() {
                            const btn = document.getElementById('toggleAllQuizBtn');
                            if (!btn || !quizContainer) return;
                            const anyOpen = Array.from(quizContainer.querySelectorAll('.collapse')).some(c => c.classList.contains('show'));
                            btn.innerHTML = anyOpen
                                ? '<i class="bi bi-arrows-collapse me-1"></i><span>Thu gọn tất cả</span>'
                                : '<i class="bi bi-arrows-expand me-1"></i><span>Mở rộng tất cả</span>';
                        }
                    });

                    function updateModalActiveIcon(checkbox) {
                        const icon = document.getElementById('modalActiveIcon');
                        if (!icon) return;
                        if (checkbox.checked) {
                            icon.className = 'bi bi-eye-fill text-success me-1.5';
                        } else {
                            icon.className = 'bi bi-eye-slash-fill text-secondary me-1.5';
                        }
                    }

                    // 2. Modal Quản lý Quiz
                    function openCreateQuizModal(moduleId, suggestedOrder) {
                        const idInput = document.getElementById('modalQuizId');
                        if (idInput) idInput.value = '';
                        const titleLabel = document.getElementById('quizModalLabel');
                        if (titleLabel) titleLabel.innerHTML = '<span class="text-orange"><i class="bi bi-patch-question"></i></span> Tạo bài kiểm tra mới (Quiz)';
                        const titleInput = document.getElementById('modalQuizTitle');
                        if (titleInput) titleInput.value = '';
                        const passScoreInput = document.getElementById('modalQuizPassScore');
                        if (passScoreInput) passScoreInput.value = '50';
                        const timeLimitInput = document.getElementById('modalQuizTimeLimit');
                        if (timeLimitInput) timeLimitInput.value = '15';
                        const activeSwitch = document.getElementById('modalQuizActiveSwitch');
                        if (activeSwitch) {
                            activeSwitch.checked = false;
                            updateModalActiveIcon(activeSwitch);
                        }
                        const orderInput = document.getElementById('modalQuizOrderIndex');
                        if (orderInput) orderInput.value = (suggestedOrder && suggestedOrder > 0) ? suggestedOrder : '1';
                        // Cập nhật hint text STT
                        const orderHint = document.getElementById('modalQuizOrderHint');
                        if (orderHint && suggestedOrder && suggestedOrder > 0) {
                            orderHint.textContent = 'Gợi ý: STT ' + suggestedOrder + ' chưa được dùng trong chương này.';
                            orderHint.className = 'form-text small text-success';
                        } else if (orderHint) {
                            orderHint.textContent = 'Số thứ tự phải không trùng với bài Quiz khác trong cùng chương.';
                            orderHint.className = 'form-text small text-muted';
                        }
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

                </script>

                <jsp:include page="../common/footer.jsp" />
