<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Setting List - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<%
    String currentSortBy = (String) request.getAttribute("currentSortBy");
    String currentSortOrder = (String) request.getAttribute("currentSortOrder");
    if (currentSortOrder == null || currentSortOrder.isEmpty()) currentSortOrder = "asc";
    String nextSortOrder = currentSortOrder.equalsIgnoreCase("asc") ? "desc" : "asc";
%>

<style>
/* ==========================================================================
   MODERN SAAS DESIGN SYSTEM (Setting Management)
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
    --saas-accent: #2563eb;
    --saas-radius-md: 10px;
    --saas-radius-lg: 14px;
    --saas-shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.06), 0 1px 2px -1px rgba(0, 0, 0, 0.04);
}

body {
    background-color: var(--saas-bg);
    color: var(--saas-text-body);
}

.saas-container {
    max-width: 100%;
    padding-left: 20px;
    padding-right: 20px;
    margin: 0 auto;
}

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

/* Card */
.saas-card {
    background: var(--saas-card-bg);
    border: 1px solid var(--saas-border);
    border-radius: var(--saas-radius-lg);
    box-shadow: var(--saas-shadow-sm);
    overflow: hidden;
}

/* Search Box & Controls */
.saas-search-input {
    border-radius: 8px;
    border: 1px solid var(--saas-border);
    background: #ffffff;
    color: var(--saas-text-heading);
    padding: 8px 12px;
    font-size: 0.875rem;
    transition: all 0.15s ease;
}
.saas-search-input:focus {
    border-color: var(--saas-accent);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    outline: none;
}

.saas-select {
    border-radius: 8px;
    border: 1px solid var(--saas-border);
    background-color: #ffffff;
    font-size: 0.875rem;
    padding: 8px 12px;
    color: var(--saas-text-heading);
}
.saas-select:focus {
    border-color: var(--saas-accent);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    outline: none;
}

/* SaaS Table */
.saas-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
}
.saas-table th {
    background: #f8fafc;
    padding: 11px 12px;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #64748b;
    border-bottom: 1px solid var(--saas-border);
    white-space: nowrap;
}
.saas-table td {
    padding: 11px 12px;
    border-bottom: 1px solid var(--saas-border-subtle);
    vertical-align: middle;
    background: #ffffff;
    font-size: 0.84rem;
    transition: background-color 0.15s ease;
}
.saas-table tr:hover td {
    background-color: #f8fafc;
}
.saas-table tr:last-child td {
    border-bottom: none;
}

@media (min-width: 992px) {
    .table-responsive {
        overflow-x: visible !important;
    }
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
.saas-badge-active {
    background: #ecfdf5;
    color: #065f46;
}
.saas-badge-active .badge-dot { background: #10b981; }

.saas-badge-inactive {
    background: #f1f5f9;
    color: #475569;
}
.saas-badge-inactive .badge-dot { background: #94a3b8; }

.saas-type-tag {
    background: #f1f5f9;
    color: #334155;
    border: 1px solid #e2e8f0;
    padding: 2px 8px;
    border-radius: 6px;
    font-size: 0.75rem;
    font-weight: 600;
}

.code-value {
    background: #f8fafc;
    color: #0f172a;
    border: 1px solid #e2e8f0;
    padding: 2px 6px;
    border-radius: 4px;
    font-size: 0.8125rem;
    font-family: monospace;
}

/* Modern Buttons */
.btn-saas-primary {
    background: #0f172a;
    color: #ffffff;
    border: 1px solid #0f172a;
    font-size: 0.875rem;
    font-weight: 600;
    padding: 8px 18px;
    border-radius: var(--saas-radius-md);
    transition: all 0.15s ease;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    text-decoration: none;
}
.btn-saas-primary:hover {
    background: #1e293b;
    border-color: #1e293b;
    color: #ffffff;
}

.btn-action-sm {
    padding: 4px 10px;
    font-size: 0.8125rem;
    font-weight: 600;
    border-radius: 6px;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 4px;
    transition: all 0.15s ease;
}
.btn-action-edit {
    background: #ffffff;
    border: 1px solid var(--saas-border);
    color: #334155;
}
.btn-action-edit:hover {
    background: #f8fafc;
    color: var(--saas-accent);
    border-color: #cbd5e1;
}

.btn-action-deactivate {
    background: #fffbeb;
    border: 1px solid #fef3c7;
    color: #b45309;
}
.btn-action-deactivate:hover {
    background: #fef3c7;
    color: #92400e;
}

.btn-action-activate {
    background: #ecfdf5;
    border: 1px solid #d1fae5;
    color: #047857;
}
.btn-action-activate:hover {
    background: #d1fae5;
    color: #065f46;
}
</style>

<main class="main-content py-4">
    <div class="saas-container px-3 px-md-4">
        <!-- Header -->
        <div class="saas-header">
            <div>
                <h1 class="saas-title">
                    <span class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-3" style="width: 38px; height: 38px;">
                        <i class="bi bi-sliders"></i>
                    </span>
                    Danh sách Cấu hình Hệ thống (Setting List)
                </h1>
                <p class="saas-subtitle">Quản lý các cấu hình master data gồm Vai trò (User Roles) và Danh mục khóa học (Course Categories)</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/settings/detail" class="btn-saas-primary" title="New Setting">
                    <i class="bi bi-plus-lg"></i> Thêm Cấu hình Mới
                </a>
            </div>
        </div>

        <!-- Alerts -->
        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Thao tác thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${requestScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Filter & Search Toolbar Card -->
        <div class="saas-card p-3 mb-4">
            <form action="${pageContext.request.contextPath}/settings/list" method="GET" class="row g-3 align-items-end">
                <input type="hidden" name="sortBy" value="${currentSortBy}">
                <input type="hidden" name="sortOrder" value="${currentSortOrder}">
                
                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted mb-1" title="Setting Type">Loại cấu hình (Type)</label>
                    <select name="type" class="form-select saas-select">
                        <option value="ALL" ${currentType == 'ALL' || empty currentType ? 'selected' : ''}>Tất cả các loại (All Types)</option>
                        <option value="USER_ROLE" ${currentType == 'USER_ROLE' ? 'selected' : ''}>USER_ROLE (Vai trò)</option>
                        <option value="COURSE_CATEGORY" ${currentType == 'COURSE_CATEGORY' ? 'selected' : ''}>COURSE_CATEGORY (Danh mục khóa học)</option>
                    </select>
                </div>
                
                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted mb-1" title="Setting Status">Trạng thái (Status)</label>
                    <select name="status" class="form-select saas-select">
                        <option value="ALL" ${currentStatus == 'ALL' || empty currentStatus ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="ACTIVE" ${currentStatus == 'ACTIVE' ? 'selected' : ''}>Active (Kích hoạt)</option>
                        <option value="INACTIVE" ${currentStatus == 'INACTIVE' ? 'selected' : ''}>Inactive (Vô hiệu)</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label small fw-semibold text-muted mb-1">Tìm kiếm từ khóa</label>
                    <div class="position-relative">
                        <input type="text" name="keyword" class="form-control saas-search-input ps-5" placeholder="Tìm theo tên hoặc giá trị cấu hình..." value="${currentKeyword}">
                        <i class="bi bi-search position-absolute text-muted" style="left: 14px; top: 50%; transform: translateY(-50%); pointer-events: none;"></i>
                    </div>
                </div>

                <div class="col-md-2 text-end">
                    <button type="submit" class="btn btn-primary w-100 fw-semibold" style="padding: 8px 12px; border-radius: 8px;" title="Search Button">
                        <i class="bi bi-funnel me-1"></i> Lọc & Tìm
                    </button>
                </div>
            </form>
        </div>

        <!-- Table Card -->
        <div class="saas-card">
            <div class="table-responsive">
                <table class="saas-table">
                    <thead>
                        <tr>
                            <th class="ps-3" style="width: 60px;">
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=id&sortOrder=<%= currentSortBy != null && currentSortBy.equals("id") ? nextSortOrder : "asc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    ID <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th style="min-width: 180px;">
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=name&sortOrder=<%= currentSortBy != null && currentSortBy.equals("name") ? nextSortOrder : "asc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    Tên Cấu Hình (Name) <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th style="width: 150px;">
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=type&sortOrder=<%= currentSortBy != null && currentSortBy.equals("type") ? nextSortOrder : "asc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    Loại (Type) <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th style="width: 140px;">
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=value&sortOrder=<%= currentSortBy != null && currentSortBy.equals("value") ? nextSortOrder : "asc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    Giá Trị (Value) <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th style="width: 80px;">
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=priority&sortOrder=<%= currentSortBy != null && currentSortBy.equals("priority") ? nextSortOrder : "asc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    Thứ Tự <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th style="width: 110px;">
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=status&sortOrder=<%= currentSortBy != null && currentSortBy.equals("status") ? nextSortOrder : "asc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    Trạng Thái <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th class="pe-3 text-end" style="width: 130px;">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${settings}">
                            <tr>
                                <td class="ps-3 fw-semibold text-muted">#${s.id}</td>
                                <td>
                                    <span class="fw-semibold text-dark">${s.name}</span>
                                    <c:if test="${not empty s.description}">
                                        <div class="small text-muted text-truncate" style="max-width: 260px;" title="${s.description}">${s.description}</div>
                                    </c:if>
                                </td>
                                <td>
                                    <span class="saas-type-tag">${s.type}</span>
                                </td>
                                <td>
                                    <span class="code-value">${s.value}</span>
                                </td>
                                <td><span class="badge bg-light text-dark border px-2 py-1">${s.priority}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${s.status == 'ACTIVE'}">
                                            <span class="saas-badge saas-badge-active">
                                                <span class="badge-dot"></span> Active
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="saas-badge saas-badge-inactive">
                                                <span class="badge-dot"></span> Inactive
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="pe-3 text-end">
                                    <div class="d-inline-flex align-items-center gap-1">
                                        <a href="${pageContext.request.contextPath}/settings/detail?id=${s.id}" class="btn-action-sm btn-action-edit" title="Chỉnh sửa cấu hình">
                                            <i class="bi bi-pencil-square"></i> Sửa
                                        </a>
                                        <c:choose>
                                            <c:when test="${s.status == 'ACTIVE'}">
                                                <a href="${pageContext.request.contextPath}/settings/toggle-status?id=${s.id}" class="btn-action-sm btn-action-deactivate" title="Vô hiệu hóa cấu hình">
                                                    <i class="bi bi-toggle-on"></i> Tắt
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/settings/toggle-status?id=${s.id}" class="btn-action-sm btn-action-activate" title="Kích hoạt cấu hình">
                                                    <i class="bi bi-toggle-off"></i> Bật
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty settings}">
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-search fs-1 d-block mb-2 opacity-50"></i>
                                    <span class="fw-semibold">Không tìm thấy cấu hình nào khớp với điều kiện tìm kiếm.</span>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
