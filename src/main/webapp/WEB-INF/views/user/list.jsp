<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Quản lý người dùng - Courson LMS" />
<jsp:include page="../common/header.jsp" />

<%
    String currentSortBy = (String) request.getAttribute("currentSortBy");
    String currentSortOrder = (String) request.getAttribute("currentSortOrder");
    if (currentSortOrder == null || currentSortOrder.isEmpty()) currentSortOrder = "desc";
    String nextSortOrder = currentSortOrder.equalsIgnoreCase("asc") ? "desc" : "asc";
%>

<style>
/* ==========================================================================
   MODERN SAAS DESIGN SYSTEM (Admin User Management)
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
    margin-bottom: 0;
}
.saas-table th {
    background: #f8fafc;
    padding: 12px 14px;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #64748b;
    border-bottom: 1px solid var(--saas-border);
    white-space: nowrap;
}
.saas-table td {
    padding: 13px 14px;
    border-bottom: 1px solid var(--saas-border-subtle);
    vertical-align: middle;
    background: #ffffff;
    font-size: 0.85rem;
    transition: background-color 0.15s ease;
}
.saas-table tr:hover td {
    background-color: #f8fafc;
}
.saas-table tr:last-child td {
    border-bottom: none;
}

/* Badges */
.saas-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 4px 10px;
    border-radius: 9999px;
    font-size: 0.75rem;
    font-weight: 600;
    line-height: 1;
}
.saas-badge-active {
    background-color: #ecfdf5;
    color: #065f46;
    border: 1px solid #a7f3d0;
}
.saas-badge-active .badge-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background-color: #10b981;
}
.saas-badge-inactive {
    background-color: #f1f5f9;
    color: #475569;
    border: 1px solid #cbd5e1;
}
.saas-badge-inactive .badge-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background-color: #94a3b8;
}
.saas-badge-suspended {
    background-color: #fef2f2;
    color: #991b1b;
    border: 1px solid #fecaca;
}
.saas-badge-suspended .badge-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background-color: #ef4444;
}

/* Role Badges */
.role-badge-admin {
    background: #fdf4ff;
    color: #701a75;
    border: 1px solid #f5d0fe;
}
.role-badge-manager {
    background: #eff6ff;
    color: #1e40af;
    border: 1px solid #bfdbfe;
}
.role-badge-expert {
    background: #f0fdf4;
    color: #166534;
    border: 1px solid #bbf7d0;
}
.role-badge-student {
    background: #f8fafc;
    color: #475569;
    border: 1px solid #e2e8f0;
}

/* Action Buttons */
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
    padding: 5px 10px;
    font-size: 0.775rem;
    font-weight: 600;
    border-radius: 6px;
    display: inline-flex;
    align-items: center;
    gap: 4px;
    text-decoration: none;
    transition: all 0.15s ease;
    border: none;
}
.btn-action-edit {
    background: #f1f5f9;
    color: #334155;
    border: 1px solid #e2e8f0;
}
.btn-action-edit:hover {
    background: #e2e8f0;
    color: #0f172a;
}
.btn-action-deactivate {
    background: #fff1f2;
    border: 1px solid #ffe4e6;
    color: #be123c;
}
.btn-action-deactivate:hover {
    background: #ffe4e6;
    color: #9f1239;
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
    <div class="container">
        <!-- Top Bar Header -->
        <div class="saas-header">
            <div>
                <h1 class="saas-title">
                    <span class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-3" style="width: 38px; height: 38px;">
                        <i class="bi bi-people-fill"></i>
                    </span>
                    Quản lý người dùng (User Management)
                </h1>
                <p class="saas-subtitle">Quản lý toàn bộ tài khoản người dùng, phân quyền truy cập (RBAC) và kiểm soát trạng thái hoạt động</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary btn-sm d-inline-flex align-items-center gap-1 rounded-2 px-3">
                    <i class="bi bi-arrow-left"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/users/new" class="btn-saas-primary" title="Add New User">
                    <i class="bi bi-person-plus-fill"></i> Thêm Người Dùng Mới
                </a>
            </div>
        </div>

        <!-- Notification Alerts -->
        <c:if test="${param.success == 'created'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Khởi tạo tài khoản người dùng mới thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'status_updated'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Cập nhật trạng thái tài khoản thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Đã xóa tài khoản người dùng thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Search & Filter Toolbar -->
        <div class="saas-card p-3 mb-4">
            <form action="${pageContext.request.contextPath}/users/list" method="GET" class="row g-3 align-items-end">
                <input type="hidden" name="sortBy" value="${currentSortBy}">
                <input type="hidden" name="sortOrder" value="${currentSortOrder}">

                <!-- Role Filter -->
                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted mb-1">Vai trò (Role Filter)</label>
                    <select name="roleId" class="form-select saas-select">
                        <option value="ALL" ${currentRoleId == null ? 'selected' : ''}>Tất cả vai trò (All Roles)</option>
                        <c:forEach var="r" items="${roles}">
                            <option value="${r.id}" ${currentRoleId == r.id ? 'selected' : ''}>${r.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Status Filter -->
                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted mb-1">Trạng thái (Status Filter)</label>
                    <select name="status" class="form-select saas-select">
                        <option value="ALL" ${currentStatus == 'ALL' || empty currentStatus ? 'selected' : ''}>Tất cả trạng thái (All Statuses)</option>
                        <option value="ACTIVE" ${currentStatus == 'ACTIVE' ? 'selected' : ''}>Active (Hoạt động)</option>
                        <option value="INACTIVE" ${currentStatus == 'INACTIVE' ? 'selected' : ''}>Inactive (Chưa kích hoạt)</option>
                        <option value="BANNED" ${currentStatus == 'BANNED' || currentStatus == 'SUSPENDED' ? 'selected' : ''}>Suspended (Tạm khóa)</option>
                    </select>
                </div>

                <!-- Search Box -->
                <div class="col-md-4">
                    <label class="form-label small fw-semibold text-muted mb-1">Tìm kiếm người dùng</label>
                    <div class="position-relative">
                        <input type="text" name="keyword" maxlength="100" class="form-control saas-search-input ps-5" placeholder="Tìm theo họ tên, username hoặc email..." value="${currentKeyword}">
                        <i class="bi bi-search position-absolute text-muted" style="left: 14px; top: 50%; transform: translateY(-50%); pointer-events: none;"></i>
                    </div>
                </div>

                <!-- Submit & Reset Buttons -->
                <div class="col-md-2 d-flex gap-2">
                    <button type="submit" class="btn btn-primary w-100 fw-semibold" style="padding: 8px 12px; border-radius: 8px;" title="Filter & Search">
                        <i class="bi bi-funnel me-1"></i> Lọc
                    </button>
                    <a href="${pageContext.request.contextPath}/users/list" class="btn btn-outline-secondary" style="padding: 8px 12px; border-radius: 8px;" title="Reset Filters">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                </div>
            </form>
        </div>

        <!-- User Table Card -->
        <div class="saas-card">
            <div class="table-responsive">
                <table class="saas-table">
                    <thead>
                        <tr>
                            <th class="ps-3" style="width: 70px;">
                                <a href="?roleId=${currentRoleId}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=id&sortOrder=<%= "id".equalsIgnoreCase(currentSortBy) ? nextSortOrder : "desc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    ID <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th style="min-width: 170px;">
                                <a href="?roleId=${currentRoleId}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=fullname&sortOrder=<%= "fullname".equalsIgnoreCase(currentSortBy) ? nextSortOrder : "asc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    Họ và tên <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th style="min-width: 130px;">
                                <a href="?roleId=${currentRoleId}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=username&sortOrder=<%= "username".equalsIgnoreCase(currentSortBy) ? nextSortOrder : "asc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    Tên đăng nhập <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th style="min-width: 180px;">
                                <a href="?roleId=${currentRoleId}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=email&sortOrder=<%= "email".equalsIgnoreCase(currentSortBy) ? nextSortOrder : "asc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    Email <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th style="min-width: 120px;">
                                <a href="?roleId=${currentRoleId}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=role&sortOrder=<%= "role".equalsIgnoreCase(currentSortBy) ? nextSortOrder : "asc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    Vai trò <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th style="min-width: 120px;">
                                <a href="?roleId=${currentRoleId}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=status&sortOrder=<%= "status".equalsIgnoreCase(currentSortBy) ? nextSortOrder : "asc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    Trạng thái <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th style="min-width: 140px;">
                                <a href="?roleId=${currentRoleId}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=created&sortOrder=<%= "created".equalsIgnoreCase(currentSortBy) ? nextSortOrder : "desc" %>" class="text-secondary text-decoration-none d-inline-flex align-items-center gap-1">
                                    Ngày tạo <i class="bi bi-arrow-down-up small"></i>
                                </a>
                            </th>
                            <th class="pe-3 text-end" style="min-width: 140px;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty users}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-person-x fs-1 d-block mb-2 opacity-50"></i>
                                        <span class="fw-semibold">Không tìm thấy tài khoản người dùng nào phù hợp với bộ lọc.</span>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <!-- ID -->
                                        <td class="ps-3 fw-bold text-muted small">#${u.id}</td>

                                        <!-- Full Name -->
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="rounded-circle d-flex align-items-center justify-content-center text-white fw-bold" style="width: 32px; height: 32px; background: linear-gradient(135deg, #3b82f6, #1d4ed8); font-size: 0.8rem; flex-shrink: 0;">
                                                    ${fn:toUpperCase(fn:substring(u.fullName, 0, 1))}
                                                </div>
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/users/detail?id=${u.id}" class="fw-bold text-dark text-decoration-none" title="Xem chi tiết">
                                                        ${u.fullName}
                                                    </a>
                                                    <c:if test="${not empty sessionScope.CURRENT_USER and u.id == sessionScope.CURRENT_USER.id}">
                                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle ms-1" style="font-size: 0.65rem;">Bạn</span>
                                                    </c:if>
                                                    <c:if test="${not empty u.phone}">
                                                        <small class="text-muted d-block" style="font-size: 0.75rem;">
                                                            <i class="bi bi-telephone me-1"></i>${u.phone}
                                                        </small>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>

                                        <!-- Username -->
                                        <td>
                                            <span class="fw-semibold text-secondary font-monospace small">@${u.username}</span>
                                        </td>

                                        <!-- Email -->
                                        <td>
                                            <span class="text-muted small">${u.email}</span>
                                            <c:if test="${u.authProvider == 'GOOGLE'}">
                                                <span class="badge bg-light text-secondary border ms-1" style="font-size: 0.65rem;" title="Đăng nhập qua Google OAuth">
                                                    <i class="bi bi-google text-danger"></i>
                                                </span>
                                            </c:if>
                                        </td>

                                        <!-- Role -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.roleName == 'Admin' || u.roleName == 'ADMIN'}">
                                                    <span class="saas-badge role-badge-admin"><i class="bi bi-shield-lock-fill"></i> Admin</span>
                                                </c:when>
                                                <c:when test="${u.roleName == 'Manager' || u.roleName == 'MANAGER'}">
                                                    <span class="saas-badge role-badge-manager"><i class="bi bi-briefcase-fill"></i> Manager</span>
                                                </c:when>
                                                <c:when test="${u.roleName == 'Expert' || u.roleName == 'EXPERT'}">
                                                    <span class="saas-badge role-badge-expert"><i class="bi bi-mortarboard-fill"></i> Expert</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="saas-badge role-badge-student"><i class="bi bi-person"></i> Student</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Status -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.status == 'ACTIVE'}">
                                                    <span class="saas-badge saas-badge-active">
                                                        <span class="badge-dot"></span> Active
                                                    </span>
                                                </c:when>
                                                <c:when test="${u.status == 'BANNED'}">
                                                    <span class="saas-badge saas-badge-suspended">
                                                        <span class="badge-dot"></span> Suspended
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="saas-badge saas-badge-inactive">
                                                        <span class="badge-dot"></span> Inactive
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Created Date -->
                                        <td>
                                            <span class="text-muted small">${u.formattedCreatedAt}</span>
                                        </td>

                                        <!-- Actions -->
                                        <td class="pe-3 text-end">
                                            <div class="d-inline-flex align-items-center gap-1">
                                                <!-- View/Edit Icon -->
                                                <a href="${pageContext.request.contextPath}/users/detail?id=${u.id}" class="btn-action-sm btn-action-edit" title="Xem chi tiết & Phân quyền">
                                                    <i class="bi bi-pencil-square"></i> Chi tiết
                                                </a>

                                                <!-- Change Status Link / Button -->
                                                <c:choose>
                                                    <c:when test="${not empty sessionScope.CURRENT_USER and u.id == sessionScope.CURRENT_USER.id}">
                                                        <span class="badge bg-secondary-subtle text-secondary border px-2 py-1" title="Tài khoản đang đăng nhập của bạn">
                                                            <i class="bi bi-person-fill"></i> Bạn
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${u.status == 'ACTIVE'}">
                                                        <button type="button" class="btn-action-sm btn-action-deactivate"
                                                                onclick="openStatusModal('${u.id}', '${fn:escapeXml(u.fullName)}', '${u.username}', 'deactivate')"
                                                                title="Tạm dừng / Khóa tài khoản">
                                                            <i class="bi bi-slash-circle"></i> Khóa
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn-action-sm btn-action-activate"
                                                                onclick="openStatusModal('${u.id}', '${fn:escapeXml(u.fullName)}', '${u.username}', 'activate')"
                                                                title="Kích hoạt lại tài khoản">
                                                            <i class="bi bi-check-circle"></i> Kích hoạt
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- Confirmation Modal for Status Toggle -->
<div class="modal fade" id="statusConfirmModal" tabindex="-1" aria-labelledby="statusConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: var(--saas-radius-lg);">
            <div class="modal-header border-bottom py-3 px-4">
                <h5 class="modal-title fw-bold" id="statusConfirmModalLabel">
                    <i class="bi bi-shield-exclamation me-2 text-warning"></i>Xác nhận đổi trạng thái
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <div id="modalIconContainer" class="mb-3"></div>
                <h6 class="fw-bold text-dark mb-2" id="modalHeading"></h6>
                <p class="text-muted small mb-0" id="modalDescription"></p>
            </div>
            <div class="modal-footer border-top py-3 px-4 d-flex justify-content-between">
                <button type="button" class="btn btn-outline-secondary btn-sm px-3" data-bs-dismiss="modal">Hủy bỏ</button>
                <a id="modalConfirmBtn" href="#" class="btn btn-sm fw-semibold px-4">Xác nhận thực hiện</a>
            </div>
        </div>
    </div>
</div>

<script>
function openStatusModal(userId, fullName, username, actionType) {
    var modalEl = document.getElementById('statusConfirmModal');
    var modalHeading = document.getElementById('modalHeading');
    var modalDesc = document.getElementById('modalDescription');
    var modalIcon = document.getElementById('modalIconContainer');
    var confirmBtn = document.getElementById('modalConfirmBtn');
    var url = '${pageContext.request.contextPath}/users/toggle-status?id=' + userId;

    if (actionType === 'deactivate') {
        modalHeading.innerText = 'Tạm dừng / Khóa tài khoản?';
        modalDesc.innerHTML = 'Bạn có chắc chắn muốn khóa tài khoản của <strong>' + fullName + '</strong> (@' + username + ')?<br><span class="text-danger small"><i class="bi bi-info-circle me-1"></i>Người dùng sẽ ngay lập tức không thể đăng nhập vào hệ thống.</span>';
        modalIcon.innerHTML = '<span class="d-inline-flex align-items-center justify-content-center bg-danger bg-opacity-10 text-danger rounded-circle" style="width: 54px; height: 54px; font-size: 1.6rem;"><i class="bi bi-lock-fill"></i></span>';
        confirmBtn.className = 'btn btn-danger btn-sm fw-semibold px-4';
        confirmBtn.innerText = 'Khóa tài khoản';
    } else {
        modalHeading.innerText = 'Kích hoạt lại tài khoản?';
        modalDesc.innerHTML = 'Bạn có chắc chắn muốn kích hoạt lại tài khoản của <strong>' + fullName + '</strong> (@' + username + ')?<br><span class="text-success small"><i class="bi bi-check-circle me-1"></i>Người dùng sẽ được phép đăng nhập và sử dụng dịch vụ bình thường.</span>';
        modalIcon.innerHTML = '<span class="d-inline-flex align-items-center justify-content-center bg-success bg-opacity-10 text-success rounded-circle" style="width: 54px; height: 54px; font-size: 1.6rem;"><i class="bi bi-unlock-fill"></i></span>';
        confirmBtn.className = 'btn btn-success btn-sm fw-semibold px-4';
        confirmBtn.innerText = 'Kích hoạt tài khoản';
    }

    confirmBtn.href = url;
    var bsModal = new bootstrap.Modal(modalEl);
    bsModal.show();
}
</script>

<jsp:include page="../common/footer.jsp" />
