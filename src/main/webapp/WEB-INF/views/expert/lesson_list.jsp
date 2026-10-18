<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Quản lý bài học - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<style>
/* ==========================================================================
   MODERN SAAS DESIGN SYSTEM (Cohesive with Expert Dashboard)
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
    padding: 7px 14px;
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
    width: 34px;
    height: 34px;
    border-radius: 8px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border: 1px solid var(--saas-border);
    background: #ffffff;
    color: #64748b;
    transition: all 0.15s ease;
    cursor: pointer;
    font-size: 0.9rem;
    text-decoration: none;
}
.btn-icon-action:hover {
    background: #f1f5f9;
    color: #0f172a;
    border-color: #cbd5e1;
}

/* Module Cards */
.saas-module-card {
    background: var(--saas-card-bg);
    border: 1px solid var(--saas-border);
    border-radius: var(--saas-radius-lg);
    box-shadow: var(--saas-shadow-sm);
    overflow: hidden;
    margin-bottom: 20px;
    transition: border-color 0.15s ease;
}
.saas-module-card:hover {
    border-color: #cbd5e1;
}
.saas-module-header {
    background: #ffffff;
    padding: 16px 20px;
    border-bottom: 1px solid var(--saas-border);
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
    cursor: pointer;
    user-select: none;
    transition: background-color 0.15s ease, border-color 0.15s ease;
}
.saas-module-header:hover {
    background-color: #f8fafc;
}
.saas-module-header.collapsed {
    border-bottom-color: transparent;
}
.module-chevron {
    transition: transform 0.2s cubic-bezier(0.16, 1, 0.3, 1);
    font-size: 0.95rem;
    color: #64748b;
    display: inline-block;
}
.saas-module-header.collapsed .module-chevron {
    transform: rotate(-90deg);
}
.saas-module-title {
    font-size: 1rem;
    font-weight: 700;
    color: var(--saas-text-heading);
    margin: 0;
    display: flex;
    align-items: center;
    gap: 8px;
}

/* Lesson Items */
.saas-lesson-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 20px;
    border-bottom: 1px solid var(--saas-border-subtle);
    background: #ffffff;
    transition: background-color 0.15s ease;
    gap: 16px;
}
.saas-lesson-item:last-child {
    border-bottom: none;
}
.saas-lesson-item:hover {
    background-color: #f8fafc;
}
.lesson-thumb-box {
    width: 84px;
    height: 52px;
    border-radius: 8px;
    overflow: hidden;
    flex-shrink: 0;
    background: #0f172a;
    border: 1px solid var(--saas-border);
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}
.lesson-thumb-box img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

/* Pills & Tags */
.pill-neutral {
    background: #f1f5f9;
    color: #334155;
    border: 1px solid #e2e8f0;
    font-size: 0.75rem;
    font-weight: 500;
    padding: 3px 8px;
    border-radius: 6px;
    display: inline-flex;
    align-items: center;
    gap: 4px;
}
.pill-video {
    background: #fef2f2;
    color: #b91c1c;
    border: 1px solid #fecaca;
    font-size: 0.75rem;
    font-weight: 500;
    padding: 2px 7px;
    border-radius: 6px;
    display: inline-flex;
    align-items: center;
    gap: 4px;
}
.pill-doc {
    background: #f0fdfa;
    color: #0f766e;
    border: 1px solid #ccfbf1;
    font-size: 0.75rem;
    font-weight: 500;
    padding: 2px 7px;
    border-radius: 6px;
    display: inline-flex;
    align-items: center;
    gap: 4px;
}

/* Modals (shadcn inspired) */
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

/* Pagination styling */
.pagination .page-link {
    color: var(--saas-text-secondary);
    border: 1px solid var(--saas-border);
    padding: 0.35rem 0.65rem;
    font-size: 0.8125rem;
    font-weight: 500;
    border-radius: 6px;
    background: #ffffff;
    transition: all 0.15s ease;
}
.pagination .page-link:hover {
    color: var(--saas-accent);
    background-color: #eff6ff;
    border-color: #bfdbfe;
}
.pagination .page-item.active .page-link {
    background-color: var(--saas-accent);
    border-color: var(--saas-accent);
    color: #ffffff;
    font-weight: 600;
}
.pagination .page-item.disabled .page-link {
    color: var(--saas-text-muted);
    background-color: transparent;
    border-color: var(--saas-border-subtle);
    opacity: 0.6;
}
</style>

<main class="main-content py-4">
    <div class="container">
        <!-- Modern Breadcrumb -->
        <nav class="saas-breadcrumb" aria-label="breadcrumb">
            <a href="${pageContext.request.contextPath}/expert/dashboard">
                <i class="bi bi-mortarboard-fill me-1 text-primary"></i>Expert Studio
            </a>
            <span class="separator">/</span>
            <span class="current">${course.title}</span>
            <span class="separator">/</span>
            <span>Danh sách bài học</span>
        </nav>

        <!-- Flash alerts -->
        <c:set var="displaySuccess" value="${not empty successMessage ? successMessage : param.success}" />
        <c:if test="${not empty displaySuccess}">
            <div class="saas-alert saas-alert-success alert-dismissible fade show" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <span>
                        <c:choose>
                            <c:when test="${displaySuccess == 'batch_saved'}">
                                Đã nhập thành công <strong><c:out value="${not empty param.count ? param.count : 'toàn bộ'}" /> bài học</strong> từ YouTube!
                            </c:when>
                            <c:when test="${displaySuccess == 'created'}">
                                Tạo khóa học thành công!
                            </c:when>
                            <c:when test="${displaySuccess == 'true'}">
                                Đã lưu thông tin bài học thành công!
                            </c:when>
                            <c:otherwise>
                                <c:out value="${displaySuccess}" escapeXml="true" />
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
            </div>
        </c:if>

        <c:set var="displayError" value="${not empty errorMessage ? errorMessage : param.error}" />
        <c:if test="${not empty displayError}">
            <div class="saas-alert saas-alert-danger alert-dismissible fade show" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <span><c:out value="${displayError}" escapeXml="true" /></span>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
            </div>
        </c:if>

        <!-- Top Header & Primary Actions -->
        <div class="saas-header">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <h1 class="saas-title">
                        <i class="bi bi-journal-bookmark text-primary"></i>${course.title}
                    </h1>
                    <c:choose>
                        <c:when test="${course.status == 'PUBLISHED'}">
                            <span class="saas-badge saas-badge-published">
                                <span class="badge-dot"></span>Đã công khai
                            </span>
                        </c:when>
                        <c:when test="${course.status == 'PENDING_REVIEW'}">
                            <span class="saas-badge saas-badge-pending">
                                <span class="badge-dot"></span>Chờ duyệt
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="saas-badge saas-badge-draft">
                                <span class="badge-dot"></span>Bản nháp
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <p class="saas-subtitle">Quản lý danh sách các bài giảng trong khóa học này</p>
            </div>

            <!-- Action Toolbar -->
            <div class="d-flex flex-wrap align-items-center gap-2">
                <c:choose>
                    <c:when test="${course.status == 'DRAFT'}">
                        <button type="button"
                           class="btn btn-saas-outline-emerald"
                           onclick="confirmPublishCourse('${fn:escapeXml(course.title)}', '${pageContext.request.contextPath}/expert/request-publish?courseId=${course.id}&from=lessons')"
                           title="Gửi duyệt khóa học">
                            <i class="bi bi-send-check"></i>Gửi duyệt
                        </button>
                    </c:when>
                    <c:when test="${course.status == 'PENDING_REVIEW'}">
                        <button type="button"
                           class="btn btn-saas-outline-amber"
                           onclick="confirmCancelPublishCourse('${fn:escapeXml(course.title)}', '${pageContext.request.contextPath}/expert/cancel-request-publish?courseId=${course.id}&from=lessons')"
                           title="Thu hồi yêu cầu xuất bản">
                            <i class="bi bi-arrow-counterclockwise"></i>Thu hồi yêu cầu
                        </button>
                    </c:when>
                </c:choose>
                <a href="${pageContext.request.contextPath}/expert/lesson-detail?courseId=${course.id}" class="btn btn-saas-primary">
                    <i class="bi bi-plus-lg me-1"></i>Thêm bài học
                </a>
            </div>
        </div>

        <!-- Lessons List (Fully Flattened & Extracted) -->
        <c:choose>
            <c:when test="${empty course.modules || course.totalLessons == 0}">
                <div class="saas-module-card p-5 text-center">
                    <div class="saas-stat-icon saas-icon-blue mx-auto mb-3" style="width: 52px; height: 52px; font-size: 1.5rem; border-radius: 12px; background: #eff6ff; color: #2563eb; display: inline-flex; align-items: center; justify-content: center;">
                        <i class="bi bi-play-btn"></i>
                    </div>
                    <h5 class="fw-bold text-dark mb-2">Khóa học này chưa có bài học nào</h5>
                    <p class="text-muted small mb-4" style="max-width: 500px; margin-left: auto; margin-right: auto;">
                        Bắt đầu xây dựng nội dung cho khóa học bằng cách thêm bài học đầu tiên.
                    </p>
                    <div class="d-flex justify-content-center">
                        <a href="${pageContext.request.contextPath}/expert/lesson-detail?courseId=${course.id}" class="btn btn-saas-primary">
                            <i class="bi bi-plus-lg me-1"></i>Thêm bài học mới
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="saas-module-card" id="lessonsCard">
                    <div class="p-3 bg-light border-bottom d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center gap-2">
                            <span class="pill-neutral fw-semibold">
                                <i class="bi bi-collection-play me-1 text-primary"></i>${course.totalLessons} bài học
                            </span>
                            <span class="text-muted small">Danh sách toàn bộ bài giảng</span>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}" class="btn btn-saas-outline btn-sm" title="Quản lý bài Quiz cho khóa học">
                                <i class="bi bi-patch-question text-warning me-1"></i>Quản lý Quiz
                            </a>
                        </div>
                    </div>
                    <div id="lessonsContainer">
                        <c:set var="lessonIndex" value="1" />
                        <c:forEach var="m" items="${course.modules}">
                            <c:forEach var="l" items="${m.lessons}">
                                <div class="saas-lesson-item">
                                    <div class="d-flex align-items-center gap-3 min-w-0">
                                        <div class="lesson-thumb-box">
                                            <img src="${l.thumbnailUrl}" alt="${l.title}"
                                                 onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                        </div>
                                        <div class="min-w-0">
                                            <div class="d-flex align-items-center gap-2 mb-1 flex-wrap">
                                                <span class="pill-neutral" style="font-size: 11px;">Bài ${lessonIndex}</span>
                                                <c:if test="${not empty l.videoUrl}">
                                                    <span class="pill-video"><i class="bi bi-youtube"></i>Video</span>
                                                </c:if>
                                                <c:if test="${not empty l.documentUrl}">
                                                    <span class="pill-doc"><i class="bi bi-file-earmark-text"></i>Tài liệu</span>
                                                </c:if>
                                            </div>
                                            <div class="fw-semibold text-dark text-truncate" style="font-size: 0.95rem;" title="${l.title}">
                                                ${l.title}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-2 flex-shrink-0">
                                        <a href="${pageContext.request.contextPath}/expert/lesson-detail?courseId=${course.id}&moduleId=${m.id}&lessonId=${l.id}" class="btn-icon-action" title="Chỉnh sửa bài học" aria-label="Sửa bài">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <button type="button" class="btn-icon-action text-danger border-0 bg-transparent" 
                                                onclick="confirmDeleteLesson('${fn:escapeXml(l.title)}', '${pageContext.request.contextPath}/expert/delete-lesson?courseId=${course.id}&lessonId=${l.id}')" 
                                                title="Xóa bài học" aria-label="Xóa bài">
                                            <i class="bi bi-trash3"></i>
                                        </button>
                                    </div>
                                </div>
                                <c:set var="lessonIndex" value="${lessonIndex + 1}" />
                            </c:forEach>
                        </c:forEach>
                    </div>

                    <!-- Pagination Bar (8 lessons per page) -->
                    <c:if test="${course.totalLessons > 8}">
                        <div id="lessonPagination" class="p-3 bg-light border-top d-flex flex-wrap justify-content-between align-items-center gap-2">
                            <span class="text-muted small" id="paginationInfo"></span>
                            <nav aria-label="Phân trang bài học">
                                <ul class="pagination pagination-sm mb-0 gap-1" id="paginationList"></ul>
                            </nav>
                        </div>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const pageSize = 8;
        const container = document.getElementById('lessonsContainer');
        if (!container) return;

        const items = Array.from(container.querySelectorAll('.saas-lesson-item'));
        const totalItems = items.length;
        if (totalItems <= pageSize) return;

        const totalPages = Math.ceil(totalItems / pageSize);
        
        // Get initial page from URL query ?page=X
        const urlParams = new URLSearchParams(window.location.search);
        let currentPage = parseInt(urlParams.get('page')) || 1;
        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        function goToPage(page) {
            currentPage = Math.max(1, Math.min(page, totalPages));
            const startIdx = (currentPage - 1) * pageSize;
            const endIdx = startIdx + pageSize;

            items.forEach((item, idx) => {
                if (idx >= startIdx && idx < endIdx) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });

            // Update info text
            const infoEl = document.getElementById('paginationInfo');
            if (infoEl) {
                const currentStart = startIdx + 1;
                const currentEnd = Math.min(endIdx, totalItems);
                infoEl.innerHTML = 'Hiển thị <strong>' + currentStart + ' - ' + currentEnd + '</strong> trên tổng số <strong>' + totalItems + '</strong> bài học';
            }

            // Render pagination buttons
            const paginationList = document.getElementById('paginationList');
            if (paginationList) {
                let html = '';

                // Prev Button
                html += '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">';
                html += '<button type="button" class="page-link shadow-none" ' + (currentPage === 1 ? 'disabled' : 'onclick="window.lessonGoToPage(' + (currentPage - 1) + ')"') + ' aria-label="Trang trước">';
                html += '<i class="bi bi-chevron-left me-1"></i>Trước';
                html += '</button></li>';

                // Page Number Buttons
                for (let i = 1; i <= totalPages; i++) {
                    if (totalPages > 7) {
                        if (i !== 1 && i !== totalPages && Math.abs(i - currentPage) > 1) {
                            if (i === 2 || i === totalPages - 1) {
                                html += '<li class="page-item disabled"><span class="page-link border-0 text-muted px-1">...</span></li>';
                            }
                            continue;
                        }
                    }
                    html += '<li class="page-item ' + (i === currentPage ? 'active' : '') + '">';
                    html += '<button type="button" class="page-link shadow-none" onclick="window.lessonGoToPage(' + i + ')">' + i + '</button>';
                    html += '</li>';
                }

                // Next Button
                html += '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">';
                html += '<button type="button" class="page-link shadow-none" ' + (currentPage === totalPages ? 'disabled' : 'onclick="window.lessonGoToPage(' + (currentPage + 1) + ')"') + ' aria-label="Trang sau">';
                html += 'Sau<i class="bi bi-chevron-right ms-1"></i>';
                html += '</button></li>';

                paginationList.innerHTML = html;
            }

            // Sync URL without full page reload
            const newUrl = new URL(window.location.href);
            newUrl.searchParams.set('page', currentPage);
            window.history.replaceState({ page: currentPage }, '', newUrl.toString());
        }

        window.lessonGoToPage = function(page) {
            goToPage(page);
            const card = document.getElementById('lessonsCard');
            if (card) {
                card.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        };

        // Initialize first render
        goToPage(currentPage);
    });

    function confirmDeleteLesson(title, url) {
        showConfirmModal({
            title: 'Xác nhận xóa bài học',
            html: 'Bạn có chắc chắn muốn xóa bài học "<strong>' + (title || '') + '</strong>"?<br><span class="text-danger small mt-2 d-inline-block"><i class="bi bi-exclamation-triangle me-1"></i>Thao tác này sẽ xóa vĩnh viễn bài học khỏi khóa học và không thể hoàn tác.</span>',
            type: 'danger',
            icon: 'bi bi-trash3-fill',
            confirmText: 'Xóa bài học',
            confirmIcon: 'bi bi-trash3 me-1',
            confirmBtnClass: 'btn-danger',
            confirmUrl: url
        });
    }

    function confirmPublishCourse(title, url) {
        showConfirmModal({
            title: 'Gửi yêu cầu xuất bản',
            html: 'Bạn có chắc chắn muốn gửi yêu cầu duyệt khóa học "<strong>' + (title || '') + '</strong>" để Quản lý kiểm tra và công khai khóa học?',
            type: 'success',
            icon: 'bi bi-send-check-fill',
            confirmText: 'Gửi duyệt ngay',
            confirmIcon: 'bi bi-send-check me-1',
            confirmBtnClass: 'btn-success',
            confirmUrl: url
        });
    }

    function confirmCancelPublishCourse(title, url) {
        showConfirmModal({
            title: 'Thu hồi yêu cầu xuất bản',
            html: 'Bạn có muốn thu hồi yêu cầu duyệt để tiếp tục chỉnh sửa khóa học "<strong>' + (title || '') + '</strong>"?',
            type: 'warning',
            icon: 'bi bi-arrow-counterclockwise',
            confirmText: 'Thu hồi yêu cầu',
            confirmIcon: 'bi bi-arrow-counterclockwise me-1',
            confirmBtnClass: 'btn-warning text-dark',
            confirmUrl: url
        });
    }
</script>

<jsp:include page="../common/footer.jsp" />
