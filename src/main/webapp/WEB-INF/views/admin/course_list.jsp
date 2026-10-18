<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản lý khóa học - Courson LMS" />
<c:set var="rolePath" value="${sessionScope.CURRENT_USER.roleName == 'MANAGER' ? '/manager' : '/admin'}" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<style>
/* ==========================================================================
   MODERN SAAS DESIGN SYSTEM (Admin/Manager Course List)
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
.saas-card-header {
    padding: 14px 18px;
    border-bottom: 1px solid var(--saas-border);
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #ffffff;
}

/* Controls */
.saas-input, .saas-select {
    border-radius: 8px;
    border: 1px solid var(--saas-border);
    background-color: #ffffff;
    font-size: 0.875rem;
    padding: 8px 12px;
    color: var(--saas-text-heading);
}
.saas-input:focus, .saas-select:focus {
    border-color: var(--saas-accent);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    outline: none;
}

/* SaaS Table - Compact full width without horizontal scroll */
.saas-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    margin-bottom: 0;
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

/* Badges */
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
}
.saas-badge-published .badge-dot { background: #10b981; }

.saas-badge-pending {
    background: #fffbeb;
    color: #92400e;
}
.saas-badge-pending .badge-dot { background: #f59e0b; }

.saas-badge-draft {
    background: #f1f5f9;
    color: #475569;
}
.saas-badge-draft .badge-dot { background: #94a3b8; }

.saas-badge-archived {
    background: #fef2f2;
    color: #991b1b;
}
.saas-badge-archived .badge-dot { background: #ef4444; }

/* Buttons */
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

.btn-saas-outline {
    background: #ffffff;
    border: 1px solid var(--saas-border);
    color: var(--saas-text-heading);
    font-size: 0.8125rem;
    font-weight: 600;
    padding: 6px 14px;
    border-radius: var(--saas-radius-md);
    transition: all 0.15s ease;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}
.btn-saas-outline:hover {
    background: #f8fafc;
    border-color: #cbd5e1;
    color: var(--saas-accent);
}
</style>

<main class="main-content py-4">
    <div class="saas-container px-3 px-md-4">
        <!-- Top bar -->
        <div class="saas-header">
            <div>
                <h1 class="saas-title">
                    <span class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-3" style="width: 38px; height: 38px;">
                        <i class="bi bi-collection"></i>
                    </span>
                    Danh sách Khóa học (Course List)
                </h1>
                <p class="saas-subtitle">Quản lý toàn bộ khóa học trên hệ thống, phân công Chuyên gia (Expert) và Người quản lý (Manager)</p>
            </div>
            <div class="d-flex gap-2">
                <c:choose>
                    <c:when test="${sessionScope.CURRENT_USER.roleName == 'MANAGER'}">
                        <a href="${pageContext.request.contextPath}/manager/dashboard" class="btn-saas-outline">
                            <i class="bi bi-arrow-left"></i> Dashboard
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-saas-outline">
                            <i class="bi bi-arrow-left"></i> Dashboard
                        </a>
                    </c:otherwise>
                </c:choose>
                <button type="button" class="btn-saas-primary" data-bs-toggle="modal" data-bs-target="#newCourseModal">
                    <i class="bi bi-plus-lg"></i> Tạo khóa học &amp; Phân công
                </button>
            </div>
        </div>

        <!-- Alerts -->
        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Cập nhật thông tin khóa học thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.deleted == 'true'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Đã xóa khóa học thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Search and Filter Form -->
        <form method="GET" action="${pageContext.request.contextPath}/admin/courses" class="saas-card p-3 mb-4">
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted mb-1">Tìm kiếm từ khóa</label>
                    <div class="position-relative">
                        <input type="text" name="search" class="form-control saas-input ps-5" placeholder="Tên khóa học hoặc ID..." value="${param.search}">
                        <i class="bi bi-search position-absolute text-muted" style="left: 14px; top: 50%; transform: translateY(-50%); pointer-events: none;"></i>
                    </div>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-semibold text-muted mb-1">Danh mục (Category)</label>
                    <select name="categoryId" class="form-select saas-select">
                        <option value="">Tất cả danh mục</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}" ${param.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-semibold text-muted mb-1">Người quản lý (Manager)</label>
                    <select name="managerId" class="form-select saas-select">
                        <option value="">Tất cả Manager</option>
                        <c:forEach var="mgr" items="${managers}">
                            <option value="${mgr.id}" ${param.managerId == mgr.id ? 'selected' : ''}>${mgr.fullName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted mb-1">Trạng thái (Status)</label>
                    <select name="status" class="form-select saas-select">
                        <option value="">Tất cả trạng thái</option>
                        <option value="DRAFT" ${param.status == 'DRAFT' ? 'selected' : ''}>Draft (Nháp)</option>
                        <option value="PENDING_REVIEW" ${param.status == 'PENDING_REVIEW' ? 'selected' : ''}>Pending Review (Chờ duyệt)</option>
                        <option value="PUBLISHED" ${param.status == 'PUBLISHED' ? 'selected' : ''}>Published (Đã duyệt)</option>
                        <option value="ARCHIVED" ${param.status == 'ARCHIVED' ? 'selected' : ''}>Archived (Đã đóng)</option>
                    </select>
                </div>
                <div class="col-md-2 d-grid">
                    <button type="submit" class="btn btn-primary fw-semibold" style="padding: 8px 12px; border-radius: 8px;">
                        <i class="bi bi-funnel me-1"></i> Lọc &amp; Tìm
                    </button>
                </div>
            </div>
        </form>

        <!-- Course Table Card -->
        <div class="saas-card">
            <div class="saas-card-header">
                <span class="fw-bold text-dark"><i class="bi bi-list-ul me-1 text-primary"></i> Danh sách tất cả khóa học (${courses != null ? courses.size() : 0})</span>
            </div>
            <div class="table-responsive">
                <table class="saas-table">
                    <thead>
                        <tr>
                            <th class="ps-3" style="width: 55px;">ID</th>
                            <th style="min-width: 190px;">Tên khóa học</th>
                            <th style="width: 135px;">Danh mục</th>
                            <th style="width: 140px;">Người quản lý</th>
                            <th style="width: 150px;">Chuyên gia (Expert)</th>
                            <th style="width: 110px;">Học phí</th>
                            <th style="width: 110px;">Trạng thái</th>
                            <th class="pe-3 text-end" style="width: 85px;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty courses}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-folder-x fs-1 d-block mb-2 opacity-50"></i>
                                        <span class="fw-semibold">Không tìm thấy khóa học nào phù hợp với bộ lọc.</span>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${courses}">
                                    <tr>
                                        <td class="ps-3 fw-semibold text-muted">#${c.id}</td>
                                        <td>
                                            <div class="fw-bold text-dark text-truncate" style="max-width: 260px;" title="${c.title}">${c.title}</div>
                                            <small class="text-muted text-truncate d-block" style="max-width: 240px;" title="${c.description}">
                                                ${c.description != null ? c.description : 'Chưa có mô tả'}
                                            </small>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-secondary border px-2 py-1">
                                                ${c.categoryName != null ? c.categoryName : 'Chưa phân loại'}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="text-dark fw-semibold small text-truncate d-block" style="max-width: 130px;" title="${c.managerName}">
                                                ${c.managerName != null ? c.managerName : 'Chưa gán'}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.expertName != null}">
                                                    <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 py-1 px-2 text-truncate" style="max-width: 140px;" title="${c.expertName}">
                                                        <i class="bi bi-person-badge me-1"></i>${c.expertName}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25 py-1 px-2">
                                                        Chưa phân công
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.price <= 0}">
                                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">Miễn phí</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="fw-semibold text-primary text-nowrap">
                                                        <fmt:formatNumber value="${c.price}" type="currency" currencySymbol="VND" maxFractionDigits="0"/>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 'PUBLISHED'}">
                                                    <span class="saas-badge saas-badge-published"><span class="badge-dot"></span> Đã duyệt</span>
                                                </c:when>
                                                <c:when test="${c.status == 'PENDING_REVIEW'}">
                                                    <span class="saas-badge saas-badge-pending"><span class="badge-dot"></span> Chờ duyệt</span>
                                                </c:when>
                                                <c:when test="${c.status == 'ARCHIVED'}">
                                                    <span class="saas-badge saas-badge-archived"><span class="badge-dot"></span> Đã đóng</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="saas-badge saas-badge-draft"><span class="badge-dot"></span> Nháp</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="pe-3 text-end">
                                            <a href="${pageContext.request.contextPath}${rolePath}/course-detail?id=${c.id}" class="btn btn-outline-primary btn-sm fw-semibold rounded-pill px-2 py-1 text-nowrap" style="font-size: 0.75rem;" title="View Details Link">
                                                Chi tiết
                                            </a>
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

<!-- Modal Create Course with Expert Assignment -->
<div class="modal fade" id="newCourseModal" tabindex="-1" aria-labelledby="newCourseModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow-lg" style="border-radius: var(--saas-radius-lg, 14px);">
            <form action="${pageContext.request.contextPath}${rolePath}/save-course" method="POST">
                <div class="modal-header border-bottom py-3 px-4">
                    <h5 class="modal-title fw-bold text-dark" id="newCourseModalLabel"><i class="bi bi-plus-circle me-2 text-primary"></i>Tạo khóa học mới &amp; Phân công</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-dark">Tên khóa học <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control saas-input" required placeholder="Ví dụ: Lập trình Java từ cơ bản đến nâng cao">
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-dark">Học phí (VNĐ, 0 là Miễn phí)</label>
                            <input type="number" step="1000" min="0" name="price" value="0" class="form-control saas-input" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-dark">Danh mục khóa học <span class="text-danger">*</span></label>
                            <select name="categoryId" class="form-select saas-select" required>
                                <c:choose>
                                    <c:when test="${not empty categories}">
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.id}">${cat.name}</option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="6">Lập trình Web</option>
                                        <option value="7">Khoa học Dữ liệu &amp; AI</option>
                                        <option value="8">Kỹ năng mềm</option>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                        </div>
                    </div>

                    <!-- Phân công Chuyên gia (Expert) -->
                    <div class="mb-3 p-3 bg-light rounded-3 border">
                        <label class="form-label small fw-bold text-primary mb-1">
                            <i class="bi bi-person-fill-gear me-1"></i>Phân công Chuyên gia phụ trách (Assign Expert) <span class="text-danger">*</span>
                        </label>
                        <select name="expertId" class="form-select border-primary saas-select" required>
                            <option value="">-- Chọn Chuyên gia (Expert) phụ trách nội dung --</option>
                            <c:forEach var="exp" items="${experts}">
                                <option value="${exp.id}">${exp.fullName} (@${exp.username}) - ${exp.email}</option>
                            </c:forEach>
                        </select>
                        <div class="form-text small text-muted mt-1">Chuyên gia được chọn sẽ có quyền tạo bài học (Lesson) và bài kiểm tra (Quiz) cho khóa học này.</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-dark">Trạng thái (Status)</label>
                        <select name="status" class="form-select saas-select">
                            <option value="DRAFT">Draft (Nháp)</option>
                            <option value="PENDING_REVIEW">Pending Review (Chờ duyệt)</option>
                            <option value="PUBLISHED">Published (Đã duyệt)</option>
                            <option value="ARCHIVED">Archived (Đã đóng)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-dark">Mô tả khóa học</label>
                        <textarea name="description" rows="3" class="form-control saas-input" placeholder="Mục tiêu đào tạo, kiến thức đạt được và tóm tắt nội dung..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-top py-3 px-4">
                    <button type="button" class="btn btn-outline-secondary btn-sm px-3" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn-saas-primary">
                        <i class="bi bi-save me-1"></i> Lưu &amp; Phân công
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
