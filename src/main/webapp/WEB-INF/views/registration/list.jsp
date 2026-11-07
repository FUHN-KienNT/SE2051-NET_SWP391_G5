<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="Quản lý Đăng ký - Courson LMS" />
            <jsp:include page="../common/header.jsp" />

            <style>
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

                .btn-saas-outline {
                    background: #ffffff;
                    border: 1px solid var(--saas-border);
                    color: #475569;
                    font-size: 0.875rem;
                    font-weight: 600;
                    padding: 8px 16px;
                    border-radius: var(--saas-radius-md);
                    transition: all 0.15s ease;
                    text-decoration: none;
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                }

                .btn-saas-outline:hover {
                    background: #f1f5f9;
                    color: #0f172a;
                    border-color: #cbd5e1;
                }

                .saas-card {
                    background: var(--saas-card-bg);
                    border: 1px solid var(--saas-border);
                    border-radius: var(--saas-radius-lg);
                    box-shadow: var(--saas-shadow-sm);
                }

                .saas-input,
                .saas-select {
                    border: 1px solid var(--saas-border);
                    border-radius: 8px;
                    font-size: 0.875rem;
                    padding: 8px 12px;
                }

                .saas-input:focus,
                .saas-select:focus {
                    border-color: var(--saas-accent);
                    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
                }

                .saas-table {
                    width: 100%;
                    border-collapse: separate;
                    border-spacing: 0;
                }

                .saas-table th {
                    background: #f8fafc;
                    color: var(--saas-text-muted);
                    font-size: 0.75rem;
                    font-weight: 700;
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                    padding: 12px 14px;
                    border-bottom: 1px solid var(--saas-border);
                    white-space: nowrap;
                }

                .saas-table td {
                    padding: 14px 14px;
                    vertical-align: middle;
                    border-bottom: 1px solid var(--saas-border-subtle);
                    font-size: 0.875rem;
                }

                .saas-table tbody tr:hover td {
                    background-color: #f8fafc;
                }

                .badge-dot {
                    width: 6px;
                    height: 6px;
                    display: inline-block;
                    border-radius: 50%;
                    margin-right: 4px;
                }

                .saas-badge {
                    display: inline-flex;
                    align-items: center;
                    padding: 4px 10px;
                    font-size: 0.75rem;
                    font-weight: 600;
                    border-radius: 9999px;
                    line-height: 1;
                }

                .saas-badge-success {
                    background: #ecfdf5;
                    color: #065f46;
                }

                .saas-badge-success .badge-dot {
                    background: #10b981;
                }

                .saas-badge-warning {
                    background: #fffbeb;
                    color: #92400e;
                }

                .saas-badge-warning .badge-dot {
                    background: #f59e0b;
                }

                .saas-badge-danger {
                    background: #fef2f2;
                    color: #991b1b;
                }

                .saas-badge-danger .badge-dot {
                    background: #ef4444;
                }

                .saas-badge-secondary {
                    background: #f1f5f9;
                    color: #475569;
                }

                .saas-badge-secondary .badge-dot {
                    background: #94a3b8;
                }

                .saas-badge-info {
                    background: #eff6ff;
                    color: #1e40af;
                }

                .saas-badge-info .badge-dot {
                    background: #3b82f6;
                }
            </style>

            <main class="main-content py-4">
                <div class="container">
                    <!-- Top bar -->
                    <div class="saas-header">
                        <div>
                            <h1 class="saas-title">
                                <span
                                    class="d-inline-flex align-items-center justify-content-center bg-success bg-opacity-10 text-success rounded-3"
                                    style="width: 38px; height: 38px;">
                                    <i class="bi bi-person-lines-fill"></i>
                                </span>
                                Quản lý Đăng ký (Registration List)
                            </h1>
                            <p class="saas-subtitle">
                                <c:choose>
                                    <c:when test="${not empty course}">
                                        Danh sách học viên đăng ký khóa học: <strong>${course.title}</strong>
                                    </c:when>
                                    <c:otherwise>
                                        Danh sách học viên đăng ký tất cả các khóa học thuộc phạm vi quản lý của bạn
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <c:choose>
                                <c:when test="${sessionScope.CURRENT_USER.roleName == 'MANAGER'}">
                                    <a href="${pageContext.request.contextPath}/manager/dashboard"
                                        class="btn-saas-outline">
                                        <i class="bi bi-arrow-left"></i> Dashboard
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                                        class="btn-saas-outline">
                                        <i class="bi bi-arrow-left"></i> Dashboard
                                    </a>
                                </c:otherwise>
                            </c:choose>
                            <span
                                class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-3 py-2 rounded-pill fw-semibold">
                                ${registrations.size()} đơn đăng ký
                            </span>
                        </div>
                    </div>

                    <!-- Filter and Search Toolbar -->
                    <form method="GET" action="${pageContext.request.contextPath}/registrations/list"
                        class="saas-card p-3 mb-4">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label class="form-label small fw-semibold text-muted mb-1">Tìm kiếm từ khóa</label>
                                <div class="position-relative">
                                    <input type="text" name="search" class="form-control saas-input ps-5"
                                        placeholder="Tên học viên, mã đơn #ID..." value="${param.search}">
                                    <i class="bi bi-search position-absolute text-muted"
                                        style="left: 14px; top: 50%; transform: translateY(-50%); pointer-events: none;"></i>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small fw-semibold text-muted mb-1">Khóa học</label>
                                <select name="courseId" class="form-select saas-select">
                                    <option value="">Tất cả khóa học</option>
                                    <c:forEach var="c" items="${courseList}">
                                        <option value="${c.id}" ${(param.courseId==c.id || (empty param.courseId && not
                                            empty course && course.id==c.id)) ? 'selected' : '' }>${c.title}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label small fw-semibold text-muted mb-1">Thanh toán</label>
                                <select name="paymentStatus" class="form-select saas-select">
                                    <option value="">Tất cả thanh toán</option>
                                    <option value="SUCCESS" ${param.paymentStatus=='SUCCESS' ? 'selected' : '' }>Thành
                                        công</option>
                                    <option value="PENDING" ${param.paymentStatus=='PENDING' ? 'selected' : '' }>Chờ
                                        thanh toán</option>
                                    <option value="FAILED" ${param.paymentStatus=='FAILED' ? 'selected' : '' }>Thất bại
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label small fw-semibold text-muted mb-1">Trạng thái học</label>
                                <select name="status" class="form-select saas-select">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="ACTIVE" ${param.status=='ACTIVE' ? 'selected' : '' }>Đang học
                                    </option>
                                    <option value="COMPLETED" ${param.status=='COMPLETED' ? 'selected' : '' }>Đã hoàn
                                        thành</option>
                                    <option value="CANCELLED" ${param.status=='CANCELLED' ? 'selected' : '' }>Đã hủy
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-2 d-grid">
                                <button type="submit" class="btn btn-primary fw-semibold"
                                    style="padding: 8px 12px; border-radius: 8px;">
                                    <i class="bi bi-funnel me-1"></i> Lọc &amp; Tìm
                                </button>
                            </div>
                        </div>
                        <c:if
                            test="${not empty param.search || not empty param.courseId || not empty param.paymentStatus || not empty param.status}">
                            <div class="mt-2 pt-2 border-top d-flex justify-content-between align-items-center">
                                <span class="small text-muted">Đang áp dụng bộ lọc tùy chỉnh.</span>
                                <a href="${pageContext.request.contextPath}/registrations/list"
                                    class="small text-decoration-none text-danger fw-semibold">
                                    <i class="bi bi-x-circle me-1"></i>Xóa bộ lọc
                                </a>
                            </div>
                        </c:if>
                    </form>

                    <!-- Registrations Table Card -->
                    <div class="saas-card overflow-hidden">
                        <div class="table-responsive">
                            <table class="saas-table mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-3 text-center" style="width: 75px;">Mã ĐK</th>
                                        <th style="min-width: 160px;">Học viên</th>
                                        <th style="min-width: 200px;">Khóa học</th>
                                        <th style="width: 140px;">Ngày đăng ký</th>
                                        <th style="width: 130px;">Tiến độ</th>
                                        <th style="width: 125px;">Thanh toán</th>
                                        <th style="width: 120px;">Trạng thái</th>
                                        <th class="pe-3 text-end" style="width: 90px;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty registrations}">
                                            <tr>
                                                <td colspan="8" class="text-center py-5 text-muted">
                                                    <i class="bi bi-inbox fs-1 d-block mb-2 opacity-50"></i>
                                                    <span class="fw-semibold">Không tìm thấy đơn đăng ký nào phù hợp với
                                                        bộ lọc.</span>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="registration" items="${registrations}">
                                                <tr>
                                                    <td class="ps-3 text-center">
                                                        <span
                                                            class="saas-badge saas-badge-secondary">#${registration.id}</span>
                                                    </td>
                                                    <td>
                                                        <div class="fw-bold text-dark text-truncate"
                                                            style="max-width: 200px;">
                                                            <i
                                                                class="bi bi-person me-1 text-muted"></i>${registration.userName}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="fw-semibold text-truncate" style="max-width: 240px;"
                                                            title="${registration.courseTitle}">
                                                            <a href="${pageContext.request.contextPath}/registrations/list?courseId=${registration.courseId}"
                                                                class="text-decoration-none text-dark hover-primary">
                                                                ${registration.courseTitle}
                                                            </a>
                                                        </div>
                                                    </td>
                                                    <td class="text-muted small text-nowrap">
                                                        ${registration.formattedRegistrationDate}
                                                    </td>
                                                    <td style="min-width: 120px;">
                                                        <div class="d-flex justify-content-between small mb-1">
                                                            <span
                                                                class="fw-semibold text-dark">${registration.progressPercentage}%</span>
                                                        </div>
                                                        <div class="progress" style="height: 6px;">
                                                            <div class="progress-bar bg-success" role="progressbar" data-progress="${registration.progressPercentage}"></div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when
                                                                test="${registration.paymentStatus == 'SUCCESS' || registration.paymentStatus == 'FREE'}">
                                                                <span class="saas-badge saas-badge-success">
                                                                    <span class="badge-dot"></span> Thành công
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${registration.paymentStatus == 'PENDING'}">
                                                                <span class="saas-badge saas-badge-warning">
                                                                    <span class="badge-dot"></span> Chờ xử lý
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="saas-badge saas-badge-danger">
                                                                    <span class="badge-dot"></span>
                                                                    ${registration.paymentStatus}
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${registration.status == 'ACTIVE'}">
                                                                <span class="saas-badge saas-badge-success">
                                                                    <span class="badge-dot"></span> Đang học
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${registration.status == 'COMPLETED'}">
                                                                <span class="saas-badge saas-badge-info">
                                                                    <span class="badge-dot"></span> Hoàn thành
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="saas-badge saas-badge-secondary">
                                                                    <span class="badge-dot"></span>
                                                                    ${registration.status}
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="pe-3 text-end text-nowrap">
                                                        <a class="btn btn-outline-primary btn-sm fw-semibold rounded-pill px-2 py-1"
                                                            style="font-size: 0.75rem;"
                                                            href="${pageContext.request.contextPath}/registrations/detail?id=${registration.id}">
                                                            <i class="bi bi-eye me-1"></i>Chi tiết
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

            <script>
                document.querySelectorAll('.progress-bar[data-progress]').forEach(function(el) {
                    var p = el.getAttribute('data-progress') || '0';
                    el.style.width = p + '%';
                });
            </script>

            <jsp:include page="../common/footer.jsp" />