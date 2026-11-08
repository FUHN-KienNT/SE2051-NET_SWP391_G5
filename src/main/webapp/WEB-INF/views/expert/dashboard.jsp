<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Expert Studio - Courson LMS" />
<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/expert-dashboard.css">

<main class="main-content py-4">
    <div class="container">
        <!-- Top bar -->
        <div class="saas-header">
            <div>
                <h1 class="saas-title">
                    <i class="bi bi-mortarboard-fill text-primary"></i>Expert Studio
                </h1>
                
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/expert/course-detail" class="btn btn-saas-primary px-3 py-2 text-decoration-none">
                    <i class="bi bi-plus-lg"></i>Tạo Khóa học mới
                </a>
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
                            <c:when test="${displaySuccess == 'created'}">Tạo khóa học thành công! Hãy bắt đầu soạn bài học cho khóa học này.</c:when>
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
        <c:set var="archivedCount" value="0" />
        <c:set var="totalAllQuizzes" value="0" />
                                <!-- #m_ds [TRẠM 4/4 - HIỂN THỊ JSP]: Nhận list ${courses} từ Servlet và dùng forEach vẽ từng dòng bảng: tiêu đề, giá, badge trạng thái -->
        <c:forEach var="c" items="${courses}">
            <c:choose>
                <c:when test="${c.status == 'PUBLISHED'}">
                    <c:set var="publishedCount" value="${publishedCount + 1}" />
                </c:when>
                <c:when test="${c.status == 'PENDING_REVIEW'}">
                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                </c:when>
                <c:when test="${c.status == 'ARCHIVED'}">
                    <c:set var="archivedCount" value="${archivedCount + 1}" />
                </c:when>
                <c:otherwise>
                    <c:set var="draftCount" value="${draftCount + 1}" />
                </c:otherwise>
            </c:choose>
            <c:set var="totalAllQuizzes" value="${totalAllQuizzes + c.totalQuizzes}" />
        </c:forEach>


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
                    <button type="button" class="saas-tab-btn" data-filter="ARCHIVED" onclick="filterCourses('ARCHIVED', this)">
                        Lưu trữ <span class="saas-tab-badge">${archivedCount}</span>
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
                            <th style="width: 50px;" class="text-center">STT</th>
                            <th style="width: 36%;">Khóa học</th>
                            <th style="width: 17%;">Danh mục &amp; Học phí</th>
                            <th style="width: 16%;">Nội dung</th>
                            <th style="width: 14%;">Trạng thái</th>
                            <th style="width: 15%; text-align: right;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty courses}">
                                <tr id="emptyCourseRow">
                                    <td colspan="6" class="text-center py-5">
                                        <div class="py-4">
                                            <div class="saas-stat-icon saas-icon-slate mx-auto mb-3" style="width: 48px; height: 48px; font-size: 1.5rem;">
                                                <i class="bi bi-journal-plus"></i>
                                            </div>
                                            <h6 class="fw-bold text-dark mb-1">Bạn chưa có khóa học nào</h6>
                                            <p class="text-muted small mb-3">Tạo khóa học đầu tiên để bắt đầu xây dựng nội dung.</p>
                                            <a href="${pageContext.request.contextPath}/expert/course-detail" class="btn btn-saas-primary btn-sm text-decoration-none">
                                                <i class="bi bi-plus-lg me-1"></i>Tạo Khóa học mới
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${courses}" varStatus="status">
                                    <tr class="course-row" id="courseRow-${c.id}" 
                                        data-status="${c.status}" 
                                        data-title="${fn:escapeXml(c.title)}" 
                                        data-category="${fn:escapeXml(c.categoryName != null ? c.categoryName : '')}">
                                        <td class="text-center fw-bold text-muted" style="font-size: 0.875rem;">${status.count}</td>
                                        <td>
                                            <div class="course-info-wrap">
                                                <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}" class="course-thumb-box">
                                                    <img src="${c.thumbnailUrl}" class="course-thumb-img" alt="${c.title}"
                                                         onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                                </a>
                                                <div class="flex-grow-1 min-w-0">
                                                    <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}" class="course-title-text" title="${c.title}">
                                                        ${c.title}
                                                    </a>
                                                    <div class="course-meta-sub">
                                                        <span>#${c.id}</span>
                                                        <span>&bull;</span>
                                                        <span>${c.totalLessons} bài học</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <span class="pill-neutral mb-1 d-inline-block">
                                                    ${c.categoryName != null ? c.categoryName : 'Khóa học'}
                                                </span>
                                                <div class="text-dark fw-semibold" style="font-size: 0.85rem;">
                                                    <c:choose>
                                                        <c:when test="${c.price <= 0}"><span class="text-success fw-semibold">Miễn phí</span></c:when>
                                                        <c:otherwise><span class="text-dark fw-bold">${c.formattedPrice}</span></c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="fw-semibold text-dark" style="font-size: 0.875rem;">
                                                <i class="bi bi-play-circle text-primary me-1"></i>${c.totalLessons} bài học
                                            </div>
                                            <div class="text-muted" style="font-size: 0.8rem; margin-top: 2px;">
                                                ${c.modules.size()} chương &bull; ${c.totalQuizzes} quiz
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
                                                    <span class="saas-badge saas-badge-archived" title="Đã ngừng nhận học viên mới">
                                                        <span class="badge-dot"></span>Đã lưu trữ
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
                                                <c:choose>
                                                    <c:when test="${c.status == 'PENDING_REVIEW'}">
                                                        <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}"
                                                           class="btn btn-saas-outline-amber btn-sm text-nowrap"
                                                           title="Khóa học đang chờ duyệt (nhấp để xem nội dung)">
                                                            <i class="bi bi-clock-history me-1"></i>Xem (Chờ duyệt)
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}"
                                                           class="btn btn-saas-primary btn-sm text-nowrap"
                                                           title="Quản lý chương và bài học">
                                                            <i class="bi bi-pencil-square me-1"></i>Soạn bài
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>

                                                <!-- Secondary Actions Menu (Sleek Dropdown) -->
                                                <div class="dropdown">
                                                    <button type="button" class="btn-icon-action" data-bs-toggle="dropdown" aria-expanded="false" title="Tùy chọn khác" aria-label="Tùy chọn khác">
                                                        <i class="bi bi-three-dots"></i>
                                                    </button>
                                                    <ul class="dropdown-menu dropdown-menu-end saas-dropdown-menu">
                                                        <c:choose>
                                                            <c:when test="${c.status == 'DRAFT'}">
                                                                <li>
                                                                    <a class="saas-dropdown-item text-success fw-semibold"
                                                                       href="javascript:void(0)"
                                                                       onclick="confirmPublishCourse('${fn:escapeXml(c.title)}', '${pageContext.request.contextPath}/expert/request-publish?courseId=${c.id}')">
                                                                        <i class="bi bi-send-check text-success"></i>Gửi duyệt xuất bản
                                                                    </a>
                                                                </li>
                                                                <li><hr class="dropdown-divider my-1"></li>
                                                                </c:when>
                                                                <c:when test="${c.status == 'PENDING_REVIEW'}">
                                                                <li>
                                                                    <a class="saas-dropdown-item text-warning fw-semibold"
                                                                       href="javascript:void(0)"
                                                                       onclick="confirmCancelPublishCourse('${fn:escapeXml(c.title)}', '${pageContext.request.contextPath}/expert/cancel-request-publish?courseId=${c.id}')">
                                                                        <i class="bi bi-arrow-counterclockwise text-warning"></i>Thu hồi yêu cầu duyệt
                                                                    </a>
                                                                </li>
                                                                <li><hr class="dropdown-divider my-1"></li>
                                                                </c:when>
                                                                <c:when test="${c.status == 'PUBLISHED'}">
                                                                <li>
                                                                    <a class="saas-dropdown-item text-warning fw-semibold"
                                                                       href="javascript:void(0)"
                                                                       onclick="confirmArchiveCourse('${fn:escapeXml(c.title)}', '${pageContext.request.contextPath}/expert/archive-course?id=${c.id}')">
                                                                        <i class="bi bi-archive text-warning"></i>Lưu trữ / Ẩn khóa học
                                                                    </a>
                                                                </li>
                                                                <li><hr class="dropdown-divider my-1"></li>
                                                                </c:when>

                                                        </c:choose>
                                                        <c:if test="${not empty c.moderationNote}">
                                                            <li>
                                                                <button type="button" class="saas-dropdown-item text-danger fw-semibold w-100 border-0 bg-transparent text-start" onclick="showModerationNoteModal('${fn:escapeXml(c.title)}', '${fn:escapeXml(c.moderationNote)}')">
                                                                    <i class="bi bi-chat-square-text text-danger"></i>Lý do từ chối
                                                                </button>
                                                            </li>
                                                            <li><hr class="dropdown-divider my-1"></li>
                                                            </c:if>
                                                        <li>
                                                            <a class="saas-dropdown-item" href="${pageContext.request.contextPath}/quizzes/list?courseId=${c.id}">
                                                                <i class="bi bi-patch-question text-warning"></i>Quản lý Quiz (${c.totalQuizzes})
                                                            </a>
                                                        </li>
                                                        <li>
                                                            <a class="saas-dropdown-item" href="${pageContext.request.contextPath}/expert/course-detail?id=${c.id}">
                                                                <i class="bi bi-gear text-secondary"></i>Chỉnh sửa thông tin
                                                            </a>
                                                        </li>
                                                        <li>
                                                            <a class="saas-dropdown-item" href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" target="_blank">
                                                                <i class="bi bi-box-arrow-up-right text-info"></i>Xem trước khóa học
                                                            </a>
                                                        </li>
                                                        <c:choose>
                                                            <c:when test="${c.status == 'DRAFT'}">
                                                                <li><hr class="dropdown-divider my-1"></li>
                                                                <li>
                                                                    <!-- #m_xoa [TRẠM 1/4 - GIAO DIỆN]: Nút xóa bản nháp menu 3 chấm. Bấm xác nhận sẽ gửi POST /expert/delete-course?id=... -->
                                                                    <a class="saas-dropdown-item text-danger" href="javascript:void(0)"
                                                                       onclick="confirmDeleteCourse('${fn:escapeXml(c.title)}', '${pageContext.request.contextPath}/expert/delete-course?id=${c.id}')">
                                                                        <i class="bi bi-trash3 text-danger"></i>Xóa vĩnh viễn (Nháp)
                                                                    </a>
                                                                </li>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <li><hr class="dropdown-divider my-1"></li>
                                                                <li>
                                                                    <span class="dropdown-item-text text-muted py-1" style="font-size: 0.75rem;">
                                                                        <i class="bi bi-shield-lock me-1"></i>Chỉ Admin có quyền xóa hoàn toàn
                                                                    </span>
                                                                </li>
                                                            </c:otherwise>
                                                        </c:choose>
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




<!-- Single Reusable Edit Course Modal (Redesigned) -->
<div class="modal fade" id="editCourseModal" tabindex="-1" aria-labelledby="editCourseModalTitle" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content saas-modal">
            <form action="${pageContext.request.contextPath}/expert/save-course" method="POST">
                <input type="hidden" name="id" id="editCourseId">
                <div class="modal-header saas-modal-header">
                    <div>
                        <h5 class="modal-title fw-bold text-dark mb-1" id="editCourseModalTitle">
                            <i class="bi bi-gear-fill text-primary me-2"></i>Chỉnh sửa Khóa học
                        </h5>
                        
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
                                <div class="saas-combobox" id="editCourseCategoryCombobox">
                                    <input type="hidden" name="categoryId" id="editCourseCategory" value="">
                                    <button type="button" class="saas-combobox-trigger" aria-haspopup="listbox" aria-expanded="false">
                                        <span class="saas-combobox-label">
                                            <i class="bi bi-tag text-muted me-2"></i>
                                            <span class="selected-text">Chọn danh mục...</span>
                                        </span>
                                        <i class="bi bi-chevron-down saas-combobox-arrow"></i>
                                    </button>
                                    <div class="saas-combobox-dropdown" role="listbox">
                                        <div class="saas-combobox-search-wrap">
                                            <i class="bi bi-search saas-combobox-search-icon"></i>
                                            <input type="text" class="saas-combobox-search" placeholder="Tìm kiếm danh mục..." autocomplete="off">
                                            <button type="button" class="saas-combobox-search-clear d-none" aria-label="Xóa tìm kiếm">
                                                <i class="bi bi-x-circle-fill"></i>
                                            </button>
                                        </div>
                                        <div class="saas-combobox-list">
                                            <c:forEach var="cat" items="${categories}">
                                                <div class="saas-combobox-item"
                                                     data-value="${cat.id}"
                                                     data-label="${fn:escapeXml(cat.name)}"
                                                     role="option">
                                                    <span class="item-text"><c:out value="${cat.name}"/></span>
                                                    <i class="bi bi-check2 item-check"></i>
                                                </div>
                                            </c:forEach>
                                            <div class="saas-combobox-empty d-none">
                                                <i class="bi bi-search text-muted mb-1 d-block fs-6"></i>
                                                Không tìm thấy danh mục phù hợp
                                            </div>
                                        </div>
                                        <div class="saas-combobox-footer">
                                            <button type="button" class="add-new-btn">
                                                <i class="bi bi-plus-circle text-primary me-2"></i>+ Nhập danh mục mới...
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div id="editCourseCustomCatDiv" class="mt-2" style="display: none;">
                                    <div class="position-relative">
                                        <input type="text" name="customCategory" class="form-control form-control-sm saas-form-control border-primary pe-4"
                                               placeholder="✨ Nhập tên danh mục đào tạo mới...">
                                        <button type="button" class="btn btn-link btn-sm text-muted position-absolute end-0 top-50 translate-middle-y text-decoration-none p-1 me-1"
                                                onclick="cancelCustomCategory('editCourseCategoryCombobox', 'editCourseCustomCatDiv')" title="Hủy nhập danh mục mới">
                                            <i class="bi bi-x-lg"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5">
                                <label class="saas-form-label">Học phí (VNĐ)</label>
                                <div class="input-group">
                                    <input type="text" name="price" id="editCoursePrice" class="form-control saas-form-control font-monospace" placeholder="0" autocomplete="off" oninput="formatPriceInputRealtime(this)">
                                    <span class="input-group-text bg-light text-muted fw-semibold" style="border-color: #cbd5e1;">VNĐ</span>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="saas-form-label">Mô tả tóm tắt</label>
                            <textarea name="description" id="editCourseDescription" rows="4" class="form-control saas-form-control"
                                      style="min-height: 105px; resize: vertical; line-height: 1.6;" oninput="autoResizeTextarea(this);"></textarea>
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


<!-- Bootstrap Modal: Lý do từ chối kiểm duyệt -->
<div class="modal fade" id="moderationNoteModal" tabindex="-1" aria-labelledby="moderationNoteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 16px;">
            <div class="modal-header border-0 pb-0 pt-4 px-4">
                <div class="d-flex align-items-center gap-2">
                    <div class="rounded-circle bg-danger bg-opacity-10 p-2 text-danger d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                        <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    </div>
                    <div>
                        <h5 class="modal-title fw-bold text-dark mb-0" id="moderationNoteModalLabel">Lý do từ chối kiểm duyệt</h5>
                        <small class="text-muted" id="moderationCourseTitle"></small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <label class="form-label text-muted small fw-semibold">Góp ý từ Quản trị viên:</label>
                <div class="p-3 rounded-3 bg-light border text-dark" style="font-size: 0.925rem; line-height: 1.6; white-space: pre-wrap;" id="moderationNoteContent"></div>
            </div>
            <div class="modal-footer border-0 pt-0 px-4 pb-4">
                <button type="button" class="btn btn-secondary px-4 rounded-pill" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script>
    window.CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/assets/js/expert-dashboard.js"></script>

<jsp:include page="../common/footer.jsp" />
