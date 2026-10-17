<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Expert Studio - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<style>
/* ==========================================================================
   MODERN SAAS DESIGN SYSTEM (Linear / Vercel / shadcn inspired)
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

.saas-container {
    max-width: 1280px;
    margin: 0 auto;
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
    gap: 8px;
}
.saas-subtitle {
    font-size: 0.875rem;
    color: var(--saas-text-muted);
    margin-top: 4px;
    margin-bottom: 0;
}

/* Stat Cards */
.saas-stat-card {
    background: var(--saas-card-bg);
    border: 1px solid var(--saas-border);
    border-radius: var(--saas-radius-lg);
    padding: 20px;
    box-shadow: var(--saas-shadow-sm);
    transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}
.saas-stat-card:hover {
    transform: translateY(-2px);
    box-shadow: var(--saas-shadow-md);
    border-color: #cbd5e1;
}
.saas-stat-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 14px;
}
.saas-stat-label {
    font-size: 0.8125rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: var(--saas-text-muted);
}
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

.saas-stat-value {
    font-size: 2rem;
    font-weight: 700;
    letter-spacing: -0.03em;
    color: var(--saas-text-heading);
    line-height: 1;
}
.saas-stat-desc {
    font-size: 0.8125rem;
    color: var(--saas-text-muted);
    margin-top: 8px;
    display: flex;
    align-items: center;
    gap: 4px;
}

/* Course Main Card & Toolbar */
.saas-card {
    background: var(--saas-card-bg);
    border: 1px solid var(--saas-border);
    border-radius: var(--saas-radius-lg);
    box-shadow: var(--saas-shadow-sm);
    overflow: hidden;
}
.saas-toolbar {
    padding: 16px 20px;
    border-bottom: 1px solid var(--saas-border);
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    background: #ffffff;
}

/* Segmented Filter Tabs */
.saas-tabs {
    display: inline-flex;
    align-items: center;
    background: #f1f5f9;
    padding: 3px;
    border-radius: 8px;
    gap: 2px;
}
.saas-tab-btn {
    border: none;
    background: transparent;
    padding: 6px 14px;
    font-size: 0.8125rem;
    font-weight: 500;
    color: var(--saas-text-muted);
    border-radius: 6px;
    transition: all 0.15s ease;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}
.saas-tab-btn:hover {
    color: var(--saas-text-heading);
}
.saas-tab-btn.active {
    background: #ffffff;
    color: var(--saas-text-heading);
    font-weight: 600;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.06);
}
.saas-tab-badge {
    background: #e2e8f0;
    color: #475569;
    font-size: 11px;
    font-weight: 600;
    padding: 1px 6px;
    border-radius: 9999px;
}
.saas-tab-btn.active .saas-tab-badge {
    background: #f1f5f9;
    color: #0f172a;
}

/* Search Box */
.saas-search-box {
    position: relative;
    min-width: 260px;
}
.saas-search-icon {
    position: absolute;
    left: 12px;
    top: 50%;
    transform: translateY(-50%);
    color: #94a3b8;
    pointer-events: none;
    font-size: 0.875rem;
}
.saas-search-input {
    width: 100%;
    padding: 7px 12px 7px 34px;
    font-size: 0.875rem;
    border-radius: 8px;
    border: 1px solid var(--saas-border);
    background: #f8fafc;
    color: var(--saas-text-heading);
    transition: all 0.15s ease;
}
.saas-search-input:focus {
    outline: none;
    background: #ffffff;
    border-color: var(--saas-accent);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}

/* SaaS Table */
.saas-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
}
.saas-table th {
    background: #f8fafc;
    padding: 12px 20px;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: #64748b;
    border-bottom: 1px solid var(--saas-border);
    white-space: nowrap;
}
.saas-table td {
    padding: 16px 20px;
    border-bottom: 1px solid var(--saas-border-subtle);
    vertical-align: middle;
    background: #ffffff;
    transition: background-color 0.15s ease;
}
.saas-table tr:hover td {
    background-color: #f8fafc;
}
.saas-table tr:last-child td {
    border-bottom: none;
}

/* Course Identity Column */
.course-info-wrap {
    display: flex;
    align-items: center;
    gap: 16px;
    min-width: 320px;
}
.course-thumb-box {
    width: 80px;
    height: 50px;
    border-radius: 8px;
    overflow: hidden;
    flex-shrink: 0;
    background: #0f172a;
    border: 1px solid #e2e8f0;
    position: relative;
}
.course-thumb-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.2s ease;
}
.course-info-wrap:hover .course-thumb-img {
    transform: scale(1.05);
}
.course-title-text {
    font-size: 0.9375rem;
    font-weight: 600;
    color: var(--saas-text-heading);
    text-decoration: none;
    line-height: 1.4;
    display: block;
    transition: color 0.15s ease;
}
.course-title-text:hover {
    color: var(--saas-accent);
}
.course-meta-sub {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-top: 4px;
    font-size: 0.8125rem;
    color: var(--saas-text-muted);
}

/* Modern Status Badges (shadcn inspired) */
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

.saas-badge-archived {
    background: #f8fafc;
    color: #64748b;
    border: 1px solid #e2e8f0;
}
.saas-badge-archived .badge-dot { background: #94a3b8; }

/* Category & Info Pills */
.pill-neutral {
    background: #f1f5f9;
    color: #334155;
    border: 1px solid #e2e8f0;
    font-size: 0.75rem;
    font-weight: 500;
    padding: 3px 8px;
    border-radius: 6px;
    display: inline-block;
}
.pill-quiz {
    background: #fefce8;
    color: #854d0e;
    border: 1px solid #fef08a;
    font-size: 0.75rem;
    font-weight: 500;
    padding: 2px 7px;
    border-radius: 6px;
    display: inline-flex;
    align-items: center;
    gap: 4px;
}
.pill-quiz.empty {
    background: #f8fafc;
    color: #94a3b8;
    border: 1px solid #e2e8f0;
}

/* Action Dropdown & Buttons */
.btn-saas-primary {
    background: #0f172a;
    color: #ffffff;
    border: 1px solid #0f172a;
    font-weight: 600;
    font-size: 0.8125rem;
    padding: 6px 14px;
    border-radius: 8px;
    transition: all 0.15s ease;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    text-decoration: none;
    box-shadow: var(--saas-shadow-xs);
}
.btn-saas-primary:hover {
    background: #1e293b;
    color: #ffffff;
    border-color: #1e293b;
}

.btn-saas-outline-emerald {
    background: #ffffff;
    color: #059669;
    border: 1px solid #a7f3d0;
    font-weight: 600;
    font-size: 0.8125rem;
    padding: 6px 12px;
    border-radius: 8px;
    transition: all 0.15s ease;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    text-decoration: none;
}
.btn-saas-outline-emerald:hover {
    background: #ecfdf5;
    color: #047857;
    border-color: #6ee7b7;
}

.btn-saas-outline-amber {
    background: #ffffff;
    color: #d97706;
    border: 1px solid #fde68a;
    font-weight: 600;
    font-size: 0.8125rem;
    padding: 6px 12px;
    border-radius: 8px;
    transition: all 0.15s ease;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    text-decoration: none;
}
.btn-saas-outline-amber:hover {
    background: #fffbeb;
    color: #b45309;
    border-color: #fcd34d;
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
}
.btn-icon-action:hover {
    background: #f1f5f9;
    color: #0f172a;
    border-color: #cbd5e1;
}

/* Dropdown Menu (shadcn style) */
.saas-dropdown-menu {
    border: 1px solid var(--saas-border);
    border-radius: 10px;
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.08), 0 4px 6px -4px rgba(0, 0, 0, 0.04);
    padding: 6px;
    min-width: 190px;
    border: 1px solid #e2e8f0;
}
.saas-dropdown-item {
    font-size: 0.8125rem;
    font-weight: 500;
    color: #334155;
    padding: 8px 12px;
    border-radius: 6px;
    display: flex;
    align-items: center;
    gap: 8px;
    transition: all 0.12s ease;
    text-decoration: none;
}
.saas-dropdown-item:hover {
    background: #f1f5f9;
    color: #0f172a;
}
.saas-dropdown-item.text-danger {
    color: #dc2626 !important;
}
.saas-dropdown-item.text-danger:hover {
    background: #fef2f2 !important;
    color: #b91c1c !important;
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
    padding: 20px 24px;
}
.modal-footer.saas-modal-footer {
    background: #f8fafc;
    border-top: 1px solid var(--saas-border);
    padding: 16px 24px;
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
    padding: 9px 12px;
    transition: all 0.15s ease;
}
.saas-form-control:focus {
    border-color: var(--saas-accent);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}
.saas-youtube-card {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    padding: 16px;
}

/* Alert notifications */
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
    <div class="container saas-container">
        <!-- Top bar -->
        <div class="saas-header">
            <div>
                <h1 class="saas-title">
                    <i class="bi bi-mortarboard text-primary"></i>Expert Studio
                </h1>
                <p class="saas-subtitle">Quản lý và biên tập nội dung các khóa học do bạn phụ trách</p>
            </div>
            <div>
                <button type="button" class="btn btn-saas-primary px-3 py-2" data-bs-toggle="modal" data-bs-target="#newCourseModal">
                    <i class="bi bi-plus-lg"></i>Tạo Khóa học mới
                </button>
            </div>
        </div>

        <!-- Flash alerts -->
        <c:set var="displaySuccess" value="${not empty successMessage ? successMessage : param.success}" />
        <c:if test="${not empty displaySuccess}">
            <div class="saas-alert saas-alert-success alert-dismissible fade show" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <span>
                        <c:choose>
                            <c:when test="${displaySuccess == 'created'}">Khởi tạo khóa học thành công! Hãy bắt đầu thêm các chương và bài học bên dưới.</c:when>
                            <c:when test="${displaySuccess == 'deleted'}">Đã xóa khóa học thành công!</c:when>
                            <c:otherwise><c:out value="${displaySuccess}" escapeXml="true" /></c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:set var="displayError" value="${not empty errorMessage ? errorMessage : param.error}" />
        <c:if test="${not empty displayError}">
            <div class="saas-alert saas-alert-danger alert-dismissible fade show" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <span><c:out value="${displayError}" escapeXml="true" /></span>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Metric summary (Counts calculation) -->
        <c:set var="publishedCount" value="0" />
        <c:set var="pendingCount" value="0" />
        <c:set var="draftCount" value="0" />
        <c:set var="totalAllQuizzes" value="0" />
        <c:forEach var="c" items="${courses}">
            <c:choose>
                <c:when test="${c.status == 'PUBLISHED'}">
                    <c:set var="publishedCount" value="${publishedCount + 1}" />
                </c:when>
                <c:when test="${c.status == 'PENDING_REVIEW'}">
                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                </c:when>
                <c:otherwise>
                    <c:set var="draftCount" value="${draftCount + 1}" />
                </c:otherwise>
            </c:choose>
            <c:set var="totalAllQuizzes" value="${totalAllQuizzes + c.totalQuizzes}" />
        </c:forEach>

        <!-- Modern SaaS Stat Cards (Neutral white cards, clean typography, soft icons) -->
        <div class="row g-3 mb-4">
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Tổng khóa học</span>
                        <div class="saas-stat-icon saas-icon-blue">
                            <i class="bi bi-collection-play"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value">${courses.size()}</div>
                        <div class="saas-stat-desc">
                            <span>Toàn bộ chương trình phụ trách</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Đã công khai</span>
                        <div class="saas-stat-icon saas-icon-emerald">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value">${publishedCount}</div>
                        <div class="saas-stat-desc text-success">
                            <i class="bi bi-broadcast me-1"></i>Học viên đang học trực tuyến
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Chờ Admin duyệt</span>
                        <div class="saas-stat-icon saas-icon-amber">
                            <i class="bi bi-hourglass-split"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value">${pendingCount}</div>
                        <div class="saas-stat-desc text-warning">
                            <i class="bi bi-clock-history me-1"></i>Đang trong hàng đợi kiểm duyệt
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Bản nháp riêng tư</span>
                        <div class="saas-stat-icon saas-icon-slate">
                            <i class="bi bi-file-earmark-text"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value">${draftCount}</div>
                        <div class="saas-stat-desc text-muted">
                            <i class="bi bi-lock me-1"></i>Chỉ bạn có quyền xem &amp; sửa
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Course assigned list Card -->
        <div class="saas-card">
            <!-- Modern Toolbar: Segmented Tabs & Live Search -->
            <div class="saas-toolbar">
                <div class="saas-tabs" id="statusFilterTabs">
                    <button type="button" class="saas-tab-btn active" data-filter="all" onclick="filterCourses('all', this)">
                        Tất cả <span class="saas-tab-badge">${courses.size()}</span>
                    </button>
                    <button type="button" class="saas-tab-btn" data-filter="PUBLISHED" onclick="filterCourses('PUBLISHED', this)">
                        Đã công khai <span class="saas-tab-badge">${publishedCount}</span>
                    </button>
                    <button type="button" class="saas-tab-btn" data-filter="PENDING_REVIEW" onclick="filterCourses('PENDING_REVIEW', this)">
                        Chờ duyệt <span class="saas-tab-badge">${pendingCount}</span>
                    </button>
                    <button type="button" class="saas-tab-btn" data-filter="DRAFT" onclick="filterCourses('DRAFT', this)">
                        Bản nháp <span class="saas-tab-badge">${draftCount}</span>
                    </button>
                </div>

                <div class="saas-search-box">
                    <i class="bi bi-search saas-search-icon"></i>
                    <input type="text" id="courseSearchInput" class="saas-search-input" placeholder="Tìm theo tên khóa học..." oninput="handleCourseSearch()">
                </div>
            </div>

            <!-- Modern SaaS Table -->
            <div class="table-responsive">
                <table class="saas-table align-middle" id="coursesTable">
                    <thead>
                        <tr>
                            <th style="width: 44%;">Khóa học</th>
                            <th style="width: 16%;">Danh mục &amp; Học phí</th>
                            <th style="width: 15%;">Nội dung</th>
                            <th style="width: 13%;">Trạng thái</th>
                            <th style="width: 12%; text-align: right;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty courses}">
                                <tr id="emptyCourseRow">
                                    <td colspan="5" class="text-center py-5">
                                        <div class="py-4">
                                            <div class="saas-stat-icon saas-icon-slate mx-auto mb-3" style="width: 48px; height: 48px; font-size: 1.5rem;">
                                                <i class="bi bi-journal-plus"></i>
                                            </div>
                                            <h6 class="fw-bold text-dark mb-1">Bạn chưa có khóa học nào</h6>
                                            <p class="text-muted small mb-3">Tạo khóa học đầu tiên hoặc dán Playlist YouTube để bắt đầu xây dựng nội dung.</p>
                                            <button type="button" class="btn btn-saas-primary btn-sm" data-bs-toggle="modal" data-bs-target="#newCourseModal">
                                                <i class="bi bi-plus-lg me-1"></i>Tạo Khóa học mới
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${courses}">
                                    <tr class="course-row" 
                                        data-status="${c.status}" 
                                        data-title="<c:out value="${c.title}" />" 
                                        data-category="<c:out value="${c.categoryName != null ? c.categoryName : ''}" />">
                                        <td>
                                            <div class="course-info-wrap">
                                                <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}" class="course-thumb-box">
                                                    <img src="${c.thumbnailUrl}" class="course-thumb-img" alt="${c.title}"
                                                         onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                                </a>
                                                <div class="flex-grow-1 min-w-0">
                                                    <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}" class="course-title-text text-truncate d-block" title="${c.title}">
                                                        ${c.title}
                                                    </a>
                                                    <div class="course-meta-sub">
                                                        <span>#${c.id}</span>
                                                        <span>&bull;</span>
                                                        <span>${c.totalLessons} bài giảng</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <span class="pill-neutral mb-1 d-inline-block">
                                                    ${c.categoryName != null ? c.categoryName : 'Khóa học'}
                                                </span>
                                                <div class="small text-muted fw-medium">
                                                    <c:choose>
                                                        <c:when test="${c.price <= 0}"><span class="text-success fw-semibold">Miễn phí</span></c:when>
                                                        <c:otherwise>${c.price} VNĐ</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <div class="fw-semibold text-dark small">
                                                    <i class="bi bi-play-circle text-primary me-1"></i>${c.totalLessons} bài học
                                                </div>
                                                <span class="text-muted" style="font-size: 11px;">${c.modules.size()} chương học</span>
                                                <div class="mt-1">
                                                    <c:choose>
                                                        <c:when test="${c.totalQuizzes > 0}">
                                                            <span class="pill-quiz">
                                                                <i class="bi bi-patch-question-fill text-warning"></i>${c.totalQuizzes} quiz
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="pill-quiz empty">0 quiz</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 'PUBLISHED'}">
                                                    <span class="saas-badge saas-badge-published">
                                                        <span class="badge-dot"></span>Đã công khai
                                                    </span>
                                                </c:when>
                                                <c:when test="${c.status == 'PENDING_REVIEW'}">
                                                    <span class="saas-badge saas-badge-pending" title="Đang chờ Quản lý duyệt xuất bản">
                                                        <span class="badge-dot"></span>Chờ duyệt
                                                    </span>
                                                </c:when>
                                                <c:when test="${c.status == 'ARCHIVED'}">
                                                    <span class="saas-badge saas-badge-archived">
                                                        <span class="badge-dot"></span>Lưu trữ
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="saas-badge saas-badge-draft" title="Bản nháp riêng tư">
                                                        <span class="badge-dot"></span>Bản nháp
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end text-nowrap">
                                            <div class="d-inline-flex align-items-center justify-content-end gap-2">
                                                <!-- Context-Aware Primary Action Button -->
                                                <c:choose>
                                                    <c:when test="${c.status == 'DRAFT'}">
                                                        <a href="${pageContext.request.contextPath}/expert/request-publish?courseId=${c.id}"
                                                           class="btn btn-saas-outline-emerald text-nowrap"
                                                           onclick="return confirm('Bạn có chắc chắn muốn gửi yêu cầu xuất bản khóa học &quot;${c.title}&quot; để Ban Quản Trị duyệt?');"
                                                           title="Gửi yêu cầu xuất bản khóa học này">
                                                            <i class="bi bi-send-check"></i>Gửi duyệt
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}"
                                                           class="btn btn-saas-primary text-nowrap"
                                                           title="Quản lý chương và bài học">
                                                            <i class="bi bi-pencil-square"></i>Soạn bài
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${c.status == 'PENDING_REVIEW'}">
                                                        <a href="${pageContext.request.contextPath}/expert/cancel-request-publish?courseId=${c.id}"
                                                           class="btn btn-saas-outline-amber text-nowrap"
                                                           onclick="return confirm('Bạn muốn thu hồi yêu cầu duyệt để tiếp tục chỉnh sửa khóa học &quot;${c.title}&quot;?');"
                                                           title="Thu hồi yêu cầu xuất bản về bản nháp">
                                                            <i class="bi bi-arrow-counterclockwise"></i>Thu hồi
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}"
                                                           class="btn btn-saas-primary text-nowrap"
                                                           title="Xem và chỉnh sửa bài học">
                                                            <i class="bi bi-journal-text"></i>Soạn bài
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}"
                                                           class="btn btn-saas-primary text-nowrap"
                                                           title="Quản lý chương và bài học">
                                                            <i class="bi bi-journal-text"></i>Soạn bài
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>

                                                <!-- Secondary Actions Menu (Sleek Dropdown) -->
                                                <div class="dropdown">
                                                    <button type="button" class="btn-icon-action" data-bs-toggle="dropdown" aria-expanded="false" title="Tùy chọn khác">
                                                        <i class="bi bi-three-dots"></i>
                                                    </button>
                                                    <ul class="dropdown-menu dropdown-menu-end saas-dropdown-menu">
                                                        <li>
                                                            <a class="saas-dropdown-item" href="${pageContext.request.contextPath}/quizzes/list?courseId=${c.id}">
                                                                <i class="bi bi-patch-question text-warning"></i>Quản lý Quiz (${c.totalQuizzes})
                                                            </a>
                                                        </li>
                                                        <li>
                                                            <button type="button" class="saas-dropdown-item w-100 border-0 bg-transparent text-start" onclick="openEditCourseModal(${c.id})">
                                                                <i class="bi bi-gear text-secondary"></i>Chỉnh sửa thông tin
                                                            </button>
                                                        </li>
                                                        <li>
                                                            <a class="saas-dropdown-item" href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" target="_blank">
                                                                <i class="bi bi-box-arrow-up-right text-info"></i>Xem trước khóa học
                                                            </a>
                                                        </li>
                                                        <c:if test="${c.status == 'DRAFT' || c.status == 'PENDING_REVIEW'}">
                                                            <li><hr class="dropdown-divider my-1"></li>
                                                            <li>
                                                                <a class="saas-dropdown-item text-danger" href="${pageContext.request.contextPath}/expert/delete-course?id=${c.id}"
                                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa vĩnh viễn khóa học &quot;${c.title}&quot; này không?');">
                                                                    <i class="bi bi-trash3 text-danger"></i>Xóa khóa học
                                                                </a>
                                                            </li>
                                                        </c:if>
                                                    </ul>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        <!-- No Match Filter Row -->
                        <tr id="noMatchRow" style="display: none;">
                            <td colspan="5" class="text-center py-5 text-muted">
                                <i class="bi bi-search fs-2 d-block mb-2 text-muted"></i>
                                Không tìm thấy khóa học nào phù hợp với bộ lọc.<br>
                                <button type="button" class="btn btn-link btn-sm text-decoration-none mt-2" onclick="resetFilters()">
                                    Xóa bộ lọc tìm kiếm
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- New Course Modal (Redesigned Minimalist SaaS Modal) -->
<div class="modal fade" id="newCourseModal" tabindex="-1" aria-labelledby="newCourseModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content saas-modal">
            <form action="${pageContext.request.contextPath}/expert/save-course" method="POST">
                <div class="modal-header saas-modal-header">
                    <div>
                        <h5 class="modal-title fw-bold text-dark mb-1" id="newCourseModalLabel">
                            <i class="bi bi-plus-circle text-primary me-2"></i>Tạo Khóa học mới
                        </h5>
                        <p class="text-muted small mb-0">Khởi tạo chương trình đào tạo hoặc import tự động từ YouTube</p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="saas-form-label">Tên khóa học <span class="text-danger">*</span></label>
                        <input type="text" name="title" id="newCourseTitle" class="form-control saas-form-control"
                            placeholder="Ví dụ: Khóa học Lập trình Web Fullstack..." required oninput="this.dataset.autofilled = 'false'">
                        <div class="form-text small text-muted">Nếu bạn dán link Playlist YouTube bên dưới, tên khóa học sẽ được tự động điền theo tên Playlist.</div>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-7">
                            <label class="saas-form-label">Danh mục đào tạo</label>
                            <select name="categoryId" class="form-select saas-form-control"
                                onchange="toggleCustomCategory(this, 'newCourseCustomCatDiv')">
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                                <option value="__NEW__" class="fw-bold text-primary">+ Nhập danh mục mới...</option>
                            </select>
                            <div id="newCourseCustomCatDiv" class="mt-2" style="display: none;">
                                <input type="text" name="customCategory"
                                    class="form-control form-control-sm border-primary"
                                    placeholder="✨ Nhập tên danh mục đào tạo mới...">
                            </div>
                        </div>
                        <div class="col-md-5">
                            <label class="saas-form-label">Học phí (VNĐ)</label>
                            <input type="number" name="price" class="form-control saas-form-control" value="0" min="0"
                                placeholder="0 = Miễn phí">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="saas-form-label">Mô tả tóm tắt khóa học</label>
                        <textarea name="description" rows="2" class="form-control saas-form-control"
                            placeholder="Mục tiêu đầu ra, đối tượng phù hợp, kiến thức đạt được..."></textarea>
                    </div>

                    <!-- YouTube Import Card -->
                    <div class="saas-youtube-card mb-2">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="saas-form-label mb-0 text-dark">
                                <i class="bi bi-youtube text-danger me-1"></i>Nhập Playlist / Loạt Video YouTube
                            </span>
                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle" style="font-size: 11px;">Tùy chọn</span>
                        </div>
                        <textarea name="batchVideoText" id="newCourseBatchText" rows="3"
                            class="form-control font-monospace small bg-white saas-form-control"
                            placeholder="Dán link playlist (https://www.youtube.com/playlist?list=...) hoặc danh sách link video..."
                            oninput="previewCourseBatchVideos()"></textarea>
                        
                        <div id="newCourseBatchFeedback" class="mt-2 small d-none"></div>
                        <div id="newCourseBatchModuleDiv" class="mt-2 p-2 bg-white rounded border border-primary-subtle d-none">
                            <label class="saas-form-label text-primary mb-1">
                                <i class="bi bi-folder-plus me-1"></i>Tên chương học chứa các video này <span class="text-muted fw-normal">(Tùy chọn)</span>
                            </label>
                            <input type="text" name="batchModuleTitle" id="newCourseBatchModuleTitle" class="form-control form-control-sm" placeholder="Ví dụ: Chương 1: Giới thiệu (để trống nếu không chia chương)...">
                            <div class="form-text small text-muted">Nếu để trống, các bài học sẽ tự động được đưa vào danh sách bài học chung.</div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer saas-modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-saas-primary">
                        <i class="bi bi-check-lg me-1"></i>Tạo khóa học &amp; Soạn bài
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Single Reusable Edit Course Modal (Redesigned) -->
<div class="modal fade" id="editCourseModal" tabindex="-1" aria-labelledby="editCourseModalTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content saas-modal">
            <form action="${pageContext.request.contextPath}/expert/save-course" method="POST">
                <input type="hidden" name="id" id="editCourseId">
                <div class="modal-header saas-modal-header">
                    <div>
                        <h5 class="modal-title fw-bold text-dark mb-1" id="editCourseModalTitle">
                            <i class="bi bi-gear-fill text-primary me-2"></i>Chỉnh sửa Khóa học
                        </h5>
                        <p class="text-muted small mb-0">Cập nhật thông tin tiêu đề, danh mục và học phí</p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <!-- Loading state -->
                    <div id="editCourseLoading" class="text-center py-4">
                        <div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div>
                        <span class="small text-muted">Đang tải thông tin khóa học...</span>
                    </div>

                    <!-- Course Form Fields -->
                    <div id="editCourseFormFields" style="display: none;">
                        <div class="mb-3">
                            <label class="saas-form-label">Tên khóa học <span class="text-danger">*</span></label>
                            <input type="text" name="title" id="editCourseTitle" class="form-control saas-form-control" required>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-7">
                                <label class="saas-form-label">Danh mục</label>
                                <select name="categoryId" id="editCourseCategory" class="form-select saas-form-control"
                                    onchange="toggleCustomCategory(this, 'editCourseCustomCatDiv')">
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}">${cat.name}</option>
                                    </c:forEach>
                                    <option value="__NEW__" class="fw-bold text-primary">+ Nhập danh mục mới...</option>
                                </select>
                                <div id="editCourseCustomCatDiv" class="mt-2" style="display: none;">
                                    <input type="text" name="customCategory" class="form-control form-control-sm border-primary"
                                        placeholder="✨ Nhập tên danh mục đào tạo mới...">
                                </div>
                            </div>
                            <div class="col-md-5">
                                <label class="saas-form-label">Học phí (VNĐ)</label>
                                <input type="number" name="price" id="editCoursePrice" class="form-control saas-form-control" min="0" step="1000">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="saas-form-label">Mô tả tóm tắt</label>
                            <textarea name="description" id="editCourseDescription" rows="3" class="form-control saas-form-control"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer saas-modal-footer d-flex justify-content-between align-items-center">
                    <button type="button" class="btn btn-outline-danger btn-sm" id="editCourseDeleteBtn" onclick="deleteEditingCourse()">
                        <i class="bi bi-trash3 me-1"></i>Xóa khóa học này
                    </button>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-saas-primary" id="editCourseSubmitBtn" disabled>
                            <i class="bi bi-check-lg me-1"></i>Lưu thay đổi
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // =========================================================================
    // CLIENT-SIDE FILTER & INSTANT SEARCH
    // =========================================================================
    let currentFilter = 'all';

    function filterCourses(status, btnEl) {
        currentFilter = status;
        const tabBtns = document.querySelectorAll('#statusFilterTabs .saas-tab-btn');
        tabBtns.forEach(btn => btn.classList.remove('active'));
        if (btnEl) btnEl.classList.add('active');

        applyFilters();
    }

    function handleCourseSearch() {
        applyFilters();
    }

    function applyFilters() {
        const query = (document.getElementById('courseSearchInput').value || '').trim().toLowerCase();
        const rows = document.querySelectorAll('.course-row');
        let visibleCount = 0;

        rows.forEach(row => {
            const status = row.getAttribute('data-status') || '';
            const title = (row.getAttribute('data-title') || '').toLowerCase();
            const category = (row.getAttribute('data-category') || '').toLowerCase();

            const matchesStatus = (currentFilter === 'all') || (status === currentFilter);
            const matchesQuery = !query || title.includes(query) || category.includes(query);

            if (matchesStatus && matchesQuery) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        const noMatchRow = document.getElementById('noMatchRow');
        if (noMatchRow) {
            noMatchRow.style.display = (visibleCount === 0 && rows.length > 0) ? '' : 'none';
        }
    }

    function resetFilters() {
        document.getElementById('courseSearchInput').value = '';
        const allTab = document.querySelector('#statusFilterTabs .saas-tab-btn[data-filter="all"]');
        filterCourses('all', allTab);
    }

    // =========================================================================
    // EDIT COURSE MODAL LOGIC (Preserved O(1) Fetch)
    // =========================================================================
    function openEditCourseModal(courseId) {
        const modalEl = document.getElementById('editCourseModal');
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);

        document.getElementById('editCourseModalTitle').innerHTML = '<i class="bi bi-gear-fill text-primary me-2"></i>Chỉnh sửa Khóa học #' + courseId;
        document.getElementById('editCourseId').value = courseId;
        document.getElementById('editCourseLoading').style.display = 'block';
        document.getElementById('editCourseFormFields').style.display = 'none';
        document.getElementById('editCourseSubmitBtn').disabled = true;

        const customDiv = document.getElementById('editCourseCustomCatDiv');
        if (customDiv) customDiv.style.display = 'none';

        modal.show();

        fetch('${pageContext.request.contextPath}/expert/get-course?id=' + encodeURIComponent(courseId))
            .then(res => {
                if (!res.ok) throw new Error('Không thể tải khóa học #' + courseId);
                return res.json();
            })
            .then(data => {
                if (data.error) {
                    alert(data.error);
                    modal.hide();
                    return;
                }
                document.getElementById('editCourseId').value = data.id;
                document.getElementById('editCourseTitle').value = data.title || '';
                if (data.categoryId) {
                    document.getElementById('editCourseCategory').value = data.categoryId;
                }
                document.getElementById('editCoursePrice').value = data.price != null ? data.price : 0;
                document.getElementById('editCourseDescription').value = data.description || '';

                document.getElementById('editCourseLoading').style.display = 'none';
                document.getElementById('editCourseFormFields').style.display = 'block';
                document.getElementById('editCourseSubmitBtn').disabled = false;
            })
            .catch(err => {
                alert('Lỗi khi truy vấn khóa học từ CSDL: ' + err.message);
                modal.hide();
            });
    }

    function toggleCustomCategory(selectEl, targetDivId) {
        const div = document.getElementById(targetDivId);
        if (!div) return;
        if (selectEl.value === '__NEW__') {
            div.style.display = 'block';
            const inp = div.querySelector('input');
            if (inp) {
                inp.focus();
                inp.required = true;
            }
        } else {
            div.style.display = 'none';
            const inp = div.querySelector('input');
            if (inp) {
                inp.required = false;
                inp.value = '';
            }
        }
    }

    // =========================================================================
    // YOUTUBE PLAYLIST BATCH AUTO-DETECT & PREVIEW
    // =========================================================================
    let courseBatchTimer = null;
    function previewCourseBatchVideos() {
        const text = document.getElementById('newCourseBatchText').value;
        const feedback = document.getElementById('newCourseBatchFeedback');
        const moduleDiv = document.getElementById('newCourseBatchModuleDiv');
        const moduleTitleInp = document.getElementById('newCourseBatchModuleTitle');
        if (!text || !text.trim()) {
            feedback.className = 'mt-2 small d-none';
            feedback.innerHTML = '';
            if (moduleDiv) moduleDiv.classList.add('d-none');
            if (moduleTitleInp) moduleTitleInp.required = false;
            return;
        }

        clearTimeout(courseBatchTimer);
        feedback.className = 'mt-2 small text-muted';
        feedback.innerHTML = '<span class="spinner-border spinner-border-sm text-danger me-1"></span>Đang phân tích video / playlist YouTube...';

        courseBatchTimer = setTimeout(() => {
            const params = new URLSearchParams();
            params.append('batchText', text);
            fetch('${pageContext.request.contextPath}/expert/preview-batch-videos', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
            .then(r => r.json())
            .then(data => {
                const list = Array.isArray(data) ? data : (data.videos || []);
                if (list && list.length > 0) {
                    const plTitle = data.playlistTitle;
                    let infoText = 'Đã nhận diện: <strong>' + list.length + ' bài giảng</strong>';
                    if (plTitle) {
                        infoText += ' từ Playlist: "<strong>' + plTitle + '</strong>"';
                        const titleInp = document.getElementById('newCourseTitle');
                        if (titleInp && (!titleInp.value.trim() || titleInp.dataset.autofilled === 'true')) {
                            titleInp.value = plTitle;
                            titleInp.dataset.autofilled = 'true';
                        }
                    }
                    feedback.className = 'mt-2 small alert alert-success py-1 px-2 mb-0 d-flex align-items-center justify-content-between';
                    feedback.innerHTML = '<span><i class="bi bi-check-circle-fill text-success me-1"></i>' + infoText + '</span>';
                    if (moduleDiv) moduleDiv.classList.remove('d-none');
                    if (moduleTitleInp) {
                        moduleTitleInp.required = false;
                        if (!moduleTitleInp.value) {
                            moduleTitleInp.placeholder = plTitle ? plTitle : ("Nhập tên chương học cho " + list.length + " bài này (hoặc để trống)...");
                        }
                    }
                } else {
                    feedback.className = 'mt-2 small text-muted';
                    feedback.innerHTML = '<i class="bi bi-info-circle me-1"></i>Chưa nhận diện được video YouTube hợp lệ.';
                    if (moduleDiv) moduleDiv.classList.add('d-none');
                    if (moduleTitleInp) moduleTitleInp.required = false;
                }
            })
            .catch(err => {
                feedback.className = 'mt-2 small d-none';
            });
        }, 500);
    }

    function deleteEditingCourse() {
        const id = document.getElementById('editCourseId').value;
        const title = document.getElementById('editCourseTitle').value;
        if (confirm('Bạn có chắc chắn muốn xóa vĩnh viễn khóa học "' + title + '" (cùng toàn bộ bài học bên trong) không?')) {
            window.location.href = '${pageContext.request.contextPath}/expert/delete-course?id=' + encodeURIComponent(id);
        }
    }
</script>

<jsp:include page="../common/footer.jsp" />