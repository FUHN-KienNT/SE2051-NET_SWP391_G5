<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Manager Dashboard - Courson LMS" />
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
    max-width: 100%;
    padding-left: 20px;
    padding-right: 20px;
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
.saas-icon-amber { background: #fffbeb; color: #d97706; }
.saas-icon-violet { background: #f5f3ff; color: #7c3aed; }
.saas-icon-slate { background: #f1f5f9; color: #475569; }

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

/* Card Container */
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
.saas-badge-success {
    background: #ecfdf5;
    color: #065f46;
}
.saas-badge-success .badge-dot { background: #10b981; }

.saas-badge-warning {
    background: #fffbeb;
    color: #92400e;
}
.saas-badge-warning .badge-dot { background: #f59e0b; }

.saas-badge-danger {
    background: #fef2f2;
    color: #991b1b;
}
.saas-badge-danger .badge-dot { background: #ef4444; }

.saas-badge-secondary {
    background: #f1f5f9;
    color: #475569;
}
.saas-badge-secondary .badge-dot { background: #94a3b8; }

.saas-badge-info {
    background: #eff6ff;
    color: #1e40af;
}
.saas-badge-info .badge-dot { background: #3b82f6; }

/* Progress bar modern */
.saas-progress-track {
    background: #e2e8f0;
    border-radius: 9999px;
    height: 6px;
    overflow: hidden;
}
.saas-progress-fill {
    height: 100%;
    border-radius: 9999px;
    transition: width 0.3s ease;
}

/* Action button */
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

.course-item-hover {
    transition: background-color 0.15s ease;
    border-bottom: 1px solid var(--saas-border-subtle);
}
.course-item-hover:hover {
    background-color: #f8fafc;
}
.course-item-hover:last-child {
    border-bottom: none;
}
</style>

<main class="main-content py-4">
    <div class="saas-container">
        <!-- Header -->
        <div class="saas-header">
            <div>
                <h1 class="saas-title">
                    <span class="saas-stat-icon saas-icon-blue"><i class="bi bi-speedometer2"></i></span>
                    Bảng điều khiển Quản lý
                </h1>
                <p class="saas-subtitle">Theo dõi hoạt động khóa học phụ trách và lượt đăng ký của học viên</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/manager/courses" class="btn-saas-outline">
                    <i class="bi bi-journal-bookmark text-primary"></i> Quản lý Khóa học
                </a>
            </div>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Metrics Cards (Modern SaaS Stat Cards) -->
        <div class="row g-3 g-md-4 mb-4">
            <!-- 1. Total Courses -->
            <div class="col-sm-6 col-xl-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Khóa học phụ trách</span>
                        <div class="saas-stat-icon saas-icon-blue">
                            <i class="bi bi-journal-code"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value">${totalCourses != null ? totalCourses : 0}</div>
                        <div class="saas-stat-desc">
                            <i class="bi bi-layers text-muted"></i> Đang được giao quyền quản lý
                        </div>
                    </div>
                </div>
            </div>

            <!-- 2. Total Registrations -->
            <div class="col-sm-6 col-xl-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Lượt đăng ký học</span>
                        <div class="saas-stat-icon saas-icon-emerald">
                            <i class="bi bi-people"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value">${totalRegistrations != null ? totalRegistrations : 0}</div>
                        <div class="saas-stat-desc">
                            <i class="bi bi-graph-up-arrow text-success"></i> Học viên đã đăng ký khóa
                        </div>
                    </div>
                </div>
            </div>

            <!-- 3. Total Revenue -->
            <div class="col-sm-6 col-xl-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Doanh thu tạm tính</span>
                        <div class="saas-stat-icon saas-icon-violet">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value text-primary" style="font-size: 1.75rem;">
                            <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" type="currency" currencySymbol="VND" maxFractionDigits="0"/>
                        </div>
                        <div class="saas-stat-desc">
                            <i class="bi bi-check-circle text-primary"></i> Từ các đơn đã thanh toán
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4. Pending Review -->
            <div class="col-sm-6 col-xl-3">
                <div class="saas-stat-card">
                    <div class="saas-stat-header">
                        <span class="saas-stat-label">Khóa học chờ duyệt</span>
                        <div class="saas-stat-icon saas-icon-amber">
                            <i class="bi bi-hourglass-split"></i>
                        </div>
                    </div>
                    <div>
                        <div class="saas-stat-value text-warning">${pendingCount != null ? pendingCount : 0}</div>
                        <div class="saas-stat-desc">
                            <i class="bi bi-clock-history text-warning"></i> Chờ duyệt xuất bản
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content Row: Registrations & Courses -->
        <div class="row g-4">
            <!-- Recent Registrations (8 cols) -->
            <div class="col-lg-8">
                <div class="saas-card h-100">
                    <div class="saas-card-header">
                        <h2 class="saas-card-title">
                            <i class="bi bi-person-lines-fill text-primary"></i> Giao dịch đăng ký gần đây
                        </h2>
                        <span class="text-muted small fw-semibold">10 lượt mới nhất</span>
                    </div>
                    <div class="table-responsive">
                        <table class="saas-table">
                            <thead>
                                <tr>
                                    <th class="ps-3" style="width: 70px;">Mã ĐK</th>
                                    <th style="min-width: 170px;">Khóa học</th>
                                    <th style="width: 120px;">Tiến độ</th>
                                    <th style="width: 125px;">Trạng thái</th>
                                    <th class="pe-3 text-end" style="width: 130px;">Thời gian</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty recentRegistrations}">
                                        <tr>
                                            <td colspan="5" class="text-center py-5">
                                                <div class="text-muted">
                                                    <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                                    <span class="fw-semibold">Chưa có lượt đăng ký nào</span>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="reg" items="${recentRegistrations}">
                                            <tr>
                                                <td class="ps-3">
                                                    <span class="saas-badge saas-badge-secondary">#${reg.id}</span>
                                                </td>
                                                <td>
                                                    <div class="text-truncate fw-semibold" style="max-width: 280px;" title="${reg.courseTitle}">
                                                        <a href="${pageContext.request.contextPath}/course/detail?id=${reg.courseId}" class="text-decoration-none text-dark hover-primary">
                                                            ${reg.courseTitle}
                                                        </a>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center gap-2" style="min-width: 100px;">
                                                        <div class="saas-progress-track flex-grow-1">
                                                            <div class="saas-progress-fill bg-success" style="width: ${reg.progressPercentage}%;"></div>
                                                        </div>
                                                        <span class="small fw-semibold text-muted" style="font-size: 11px;">${reg.progressPercentage}%</span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${reg.paymentStatus == 'COMPLETED'}">
                                                            <span class="saas-badge saas-badge-success">
                                                                <span class="badge-dot"></span> Thành công
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${reg.paymentStatus == 'PENDING'}">
                                                            <span class="saas-badge saas-badge-warning">
                                                                <span class="badge-dot"></span> Chờ thanh toán
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="saas-badge saas-badge-danger">
                                                                <span class="badge-dot"></span> Thất bại
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="pe-3 text-end text-muted small text-nowrap">
                                                    <fmt:parseDate value="${reg.registrationDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm"/>
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

            <!-- Recent Courses (4 cols) -->
            <div class="col-lg-4">
                <div class="saas-card h-100 d-flex flex-column">
                    <div class="saas-card-header">
                        <h2 class="saas-card-title">
                            <i class="bi bi-journals text-success"></i> Khóa học phụ trách
                        </h2>
                        <a href="${pageContext.request.contextPath}/admin/courses" class="small fw-semibold text-decoration-none text-primary">
                            Xem tất cả <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                    <div class="flex-grow-1">
                        <c:forEach var="course" items="${recentCourses}">
                            <div class="course-item-hover p-3">
                                <div class="d-flex justify-content-between align-items-center gap-2 mb-2">
                                    <a href="${pageContext.request.contextPath}/admin/course-detail?id=${course.id}" class="text-decoration-none text-dark fw-semibold text-truncate flex-grow-1" style="min-width: 0;" title="${course.title}">
                                        ${course.title}
                                    </a>
                                    <c:choose>
                                        <c:when test="${course.status == 'PUBLISHED'}">
                                            <span class="saas-badge saas-badge-success flex-shrink-0"><span class="badge-dot"></span> Đã duyệt</span>
                                        </c:when>
                                        <c:when test="${course.status == 'PENDING_REVIEW'}">
                                            <span class="saas-badge saas-badge-warning flex-shrink-0"><span class="badge-dot"></span> Chờ duyệt</span>
                                        </c:when>
                                        <c:when test="${course.status == 'ARCHIVED'}">
                                            <span class="saas-badge saas-badge-secondary flex-shrink-0"><span class="badge-dot"></span> Đã đóng</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="saas-badge saas-badge-secondary flex-shrink-0"><span class="badge-dot"></span> Nháp</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="d-flex align-items-center justify-content-between text-muted small">
                                    <span><i class="bi bi-tag me-1 text-secondary"></i>${course.categoryName}</span>
                                    <span>#${course.id}</span>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty recentCourses}">
                            <div class="p-5 text-center text-muted">
                                <i class="bi bi-journal-x fs-1 d-block mb-2 opacity-50"></i>
                                <span class="fw-semibold">Bạn chưa phụ trách khóa học nào</span>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
