<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Dashboard - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<style>
/* ==========================================================================
   MODERN SAAS DESIGN SYSTEM (Admin Dashboard)
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
    --saas-shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.06), 0 2px 4px -2px rgba(0, 0, 0, 0.04);
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

/* Stat Cards */
.saas-stat-card {
    background: var(--saas-card-bg);
    border: 1px solid var(--saas-border);
    border-radius: var(--saas-radius-lg);
    padding: 22px;
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
    width: 38px;
    height: 38px;
    border-radius: var(--saas-radius-md);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
}
.saas-icon-blue { background: #eff6ff; color: #2563eb; }
.saas-icon-emerald { background: #ecfdf5; color: #059669; }
.saas-icon-violet { background: #f5f3ff; color: #7c3aed; }
.saas-icon-amber { background: #fffbeb; color: #d97706; }

.saas-stat-value {
    font-size: 2rem;
    font-weight: 700;
    letter-spacing: -0.03em;
    color: var(--saas-text-heading);
    line-height: 1.1;
}
.saas-stat-desc {
    font-size: 0.8125rem;
    color: var(--saas-text-muted);
    margin-top: 8px;
    display: flex;
    align-items: center;
    gap: 6px;
}

/* SaaS Card */
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
.saas-card-title {
    font-size: 1rem;
    font-weight: 700;
    color: var(--saas-text-heading);
    margin: 0;
    display: flex;
    align-items: center;
    gap: 8px;
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
.saas-badge-warning {
    background: #fffbeb;
    color: #92400e;
}
.saas-badge-warning .badge-dot { background: #f59e0b; }

.saas-badge-success {
    background: #ecfdf5;
    color: #065f46;
}
.saas-badge-success .badge-dot { background: #10b981; }

.saas-badge-secondary {
    background: #f1f5f9;
    color: #475569;
}
.saas-badge-secondary .badge-dot { background: #94a3b8; }

/* Buttons */
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

.shortcut-link {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 14px 16px;
    border-radius: var(--saas-radius-md);
    border: 1px solid var(--saas-border);
    background: #ffffff;
    color: var(--saas-text-heading);
    text-decoration: none;
    transition: all 0.15s ease;
    margin-bottom: 10px;
}
.shortcut-link:hover {
    background: #f8fafc;
    border-color: #cbd5e1;
    transform: translateX(3px);
}
.shortcut-icon {
    width: 38px;
    height: 38px;
    border-radius: 8px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
    flex-shrink: 0;
}
</style>

<main class="main-content py-4">
    <div class="saas-container px-3 px-md-4">
        <!-- Header -->
        <div class="saas-header">
            <div>
                <h1 class="saas-title">
                    <span class="saas-stat-icon saas-icon-blue"><i class="bi bi-speedometer2"></i></span>
                    Bảng điều khiển Quản trị (Admin Dashboard)
                </h1>
                <p class="saas-subtitle">Theo dõi chỉ số hệ thống, giám sát vận hành và phê duyệt khóa học</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/courses" class="btn-saas-outline">
                    <i class="bi bi-journal-bookmark text-primary"></i> Tất cả Khóa học
                </a>
            </div>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Metrics Cards (4 Modern Stat Cards) -->
        <div class="row g-3 g-md-4 mb-4">
            <div class="col-sm-6 col-xl-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Tổng người dùng</span>
                        <div class="saas-stat-icon saas-icon-blue">
                            <i class="bi bi-people"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value">${totalUsers != null ? totalUsers : 0}</div>
                        <div class="saas-stat-desc">
                            <i class="bi bi-person-check text-primary"></i> Tài khoản trong hệ thống
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Tổng khóa học</span>
                        <div class="saas-stat-icon saas-icon-emerald">
                            <i class="bi bi-journal-code"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value">${totalCourses != null ? totalCourses : 0}</div>
                        <div class="saas-stat-desc">
                            <i class="bi bi-collection-play text-success"></i> Khóa học được khởi tạo
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Doanh thu hệ thống</span>
                        <div class="saas-stat-icon saas-icon-violet">
                            <i class="bi bi-currency-dollar"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value text-primary">$45,230</div>
                        <div class="saas-stat-desc">
                            <i class="bi bi-graph-up text-primary"></i> Tổng giao dịch thành công
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Tình trạng máy chủ</span>
                        <div class="saas-stat-icon saas-icon-emerald">
                            <i class="bi bi-server"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value text-success" style="font-size: 1.75rem;">
                            <i class="bi bi-check-circle-fill me-1"></i> Hoạt động tốt
                        </div>
                        <div class="saas-stat-desc">
                            <i class="bi bi-cpu text-muted"></i> PostgreSQL & Tomcat 10
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Khóa học chờ duyệt xuất bản -->
        <div class="saas-card mb-4">
            <div class="saas-card-header">
                <h2 class="saas-card-title">
                    <i class="bi bi-patch-check-fill text-warning"></i> Khóa học chờ duyệt xuất bản
                </h2>
                <span class="saas-badge saas-badge-warning">
                    <span class="badge-dot"></span> ${pendingCourses.size()} khóa chờ quyết định
                </span>
            </div>
            <div class="table-responsive">
                <table class="saas-table">
                    <thead>
                        <tr>
                            <th class="ps-3" style="width: 55px;">ID</th>
                            <th>Khóa học</th>
                            <th style="width: 140px;">Chuyên gia</th>
                            <th style="width: 115px;">Nội dung</th>
                            <th style="width: 105px;">Học phí</th>
                            <th class="pe-3 text-end" style="width: 230px;">Quyết định duyệt</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty pendingCourses}">
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <div class="text-muted">
                                            <i class="bi bi-check2-circle fs-1 d-block mb-2 text-success opacity-75"></i>
                                            <span class="fw-semibold text-dark">Tuyệt vời! Hiện không có khóa học nào ở trạng thái chờ duyệt.</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${pendingCourses}">
                                    <tr>
                                        <td class="ps-3">
                                            <span class="saas-badge saas-badge-secondary">#${c.id}</span>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="${c.thumbnailUrl}" class="rounded-2 flex-shrink-0" style="width: 48px; height: 32px; object-fit: cover;" alt="${c.title}"
                                                     onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                                <div style="min-width: 0;">
                                                    <span class="fw-bold text-dark d-block text-truncate" style="max-width: 260px;" title="${c.title}">${c.title}</span>
                                                    <span class="badge bg-light text-secondary border mt-1" style="font-size: 10px;">${c.categoryName != null ? c.categoryName : 'Khóa học'}</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 py-1 px-2 text-truncate d-inline-block" style="max-width: 135px;" title="${c.expertName}">
                                                <i class="bi bi-person-badge me-1"></i>${c.expertName != null ? c.expertName : 'Expert'}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="fw-semibold text-dark">${c.totalLessons} bài</span>
                                            <small class="text-muted d-block" style="font-size: 11px;">(${c.modules.size()} chương)</small>
                                        </td>
                                        <td>
                                            <span class="fw-semibold text-success">
                                                <c:choose>
                                                    <c:when test="${c.price <= 0}">Miễn phí</c:when>
                                                    <c:otherwise>${c.price} VNĐ</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="pe-3 text-end text-nowrap">
                                            <a href="${pageContext.request.contextPath}/admin/toggle-status?id=${c.id}&status=PUBLISHED&fromDashboard=true" class="btn btn-success btn-sm fw-semibold me-1 px-2 py-1 shadow-xs" title="Duyệt xuất bản ngay">
                                                <i class="bi bi-check-lg me-1"></i>Duyệt
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/toggle-status?id=${c.id}&status=DRAFT&fromDashboard=true" class="btn btn-outline-danger btn-sm me-1 px-2 py-1"
                                               onclick="return confirm('Bạn có chắc muốn từ chối và chuyển khóa học &quot;${c.title}&quot; về bản nháp để Chuyên gia hoàn thiện thêm không?');"
                                               title="Từ chối và trả về bản nháp">
                                                <i class="bi bi-x-circle me-1"></i>Từ chối
                                            </a>
                                            <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="btn-saas-outline btn-sm px-2 py-1" target="_blank" title="Xem trước trang khóa học">
                                                <i class="bi bi-eye"></i>
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

        <!-- Quick Management Modules & Platform Information -->
        <div class="row g-4">
            <!-- Management Shortcuts (col-lg-7) -->
            <div class="col-lg-7">
                <div class="saas-card p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                        <h2 class="saas-card-title">
                            <i class="bi bi-lightning-charge text-warning"></i> Phân hệ Quản trị &amp; Lối tắt điều hướng
                        </h2>
                        <span class="text-muted small">Quyền Quản trị viên (Admin)</span>
                    </div>

                    <div class="row g-3">
                        <div class="col-sm-6">
                            <a href="${pageContext.request.contextPath}/users/list" class="shortcut-link h-100 mb-0">
                                <div class="shortcut-icon bg-primary bg-opacity-10 text-primary">
                                    <i class="bi bi-people"></i>
                                </div>
                                <div>
                                    <div class="fw-bold small">Quản lý Người dùng</div>
                                    <div class="text-muted" style="font-size: 11px;">Tài khoản &amp; Phân quyền</div>
                                </div>
                            </a>
                        </div>

                        <div class="col-sm-6">
                            <a href="${pageContext.request.contextPath}/admin/courses" class="shortcut-link h-100 mb-0">
                                <div class="shortcut-icon bg-success bg-opacity-10 text-success">
                                    <i class="bi bi-journal-bookmark"></i>
                                </div>
                                <div>
                                    <div class="fw-bold small">Quản lý Khóa học</div>
                                    <div class="text-muted" style="font-size: 11px;">Phân công Expert &amp; Manager</div>
                                </div>
                            </a>
                        </div>

                        <div class="col-sm-6">
                            <a href="${pageContext.request.contextPath}/settings/list" class="shortcut-link h-100 mb-0">
                                <div class="shortcut-icon bg-secondary bg-opacity-10 text-secondary">
                                    <i class="bi bi-sliders"></i>
                                </div>
                                <div>
                                    <div class="fw-bold small">Cấu hình Hệ thống (Settings)</div>
                                    <div class="text-muted" style="font-size: 11px;">Master data (Role, Category)</div>
                                </div>
                            </a>
                        </div>

                        <div class="col-sm-6">
                            <a href="${pageContext.request.contextPath}/settings/detail" class="shortcut-link h-100 mb-0">
                                <div class="shortcut-icon bg-info bg-opacity-10 text-info">
                                    <i class="bi bi-plus-circle"></i>
                                </div>
                                <div>
                                    <div class="fw-bold small">Thêm Cấu hình Mới</div>
                                    <div class="text-muted" style="font-size: 11px;">Tạo Role hoặc Danh mục mới</div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Platform & Architecture Info (col-lg-5) -->
            <div class="col-lg-5">
                <div class="saas-card p-4 h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                            <h2 class="saas-card-title">
                                <i class="bi bi-cpu text-primary"></i> Môi trường &amp; Công nghệ
                            </h2>
                            <span class="saas-badge saas-badge-success"><span class="badge-dot"></span> Sẵn sàng</span>
                        </div>

                        <ul class="list-unstyled small mb-0">
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted"><i class="bi bi-layers me-2 text-primary"></i>Kiến trúc dự án:</span>
                                <span class="fw-semibold text-dark">MVC Layered Architecture</span>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted"><i class="bi bi-hdd-network me-2 text-success"></i>Web Server:</span>
                                <span class="fw-semibold text-dark">Apache Tomcat 10.1 (Jakarta EE 10)</span>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted"><i class="bi bi-database me-2 text-info"></i>Hệ quản trị CSDL:</span>
                                <span class="fw-semibold text-dark">PostgreSQL 18 (JDBC Driver)</span>
                            </li>
                            <li class="d-flex justify-content-between py-2">
                                <span class="text-muted"><i class="bi bi-shield-check me-2 text-warning"></i>Bảo mật phân quyền:</span>
                                <span class="fw-semibold text-dark">Filter RBAC &amp; Session Management</span>
                            </li>
                        </ul>
                    </div>

                    <div class="p-3 bg-light rounded-3 border mt-3 text-muted small" style="font-size: 11px;">
                        <i class="bi bi-info-circle me-1 text-primary"></i> Courson LMS • Dự án SWP391 • Nhóm SE2051-NET Group 5 (FPT University)
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
