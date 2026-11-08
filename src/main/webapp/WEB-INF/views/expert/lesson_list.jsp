<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Quản lý bài học - Courson LMS" />
<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/expert-lesson-list.css">

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

        <c:if test="${not empty course.moderationNote}">
            <div class="alert alert-danger border-danger border-2 shadow-sm rounded-3 py-3 px-4 mb-4" style="background-color: #fef2f2;">
                <div class="d-flex align-items-start gap-3">
                    <div class="rounded-circle bg-danger bg-opacity-25 p-2 text-danger fs-4 d-flex align-items-center justify-content-center flex-shrink-0" style="width: 44px; height: 44px;">
                        <i class="bi bi-chat-left-quote-fill"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                            <h6 class="fw-bold mb-1 text-danger">
                                <i class="bi bi-shield-exclamation me-1"></i>Lý do / Góp ý kiểm duyệt từ Quản trị viên (Admin / Manager)
                            </h6>
                            <c:if test="${course.status == 'DRAFT'}">
                                <span class="badge bg-danger text-white">Yêu cầu hoàn thiện</span>
                            </c:if>
                        </div>
                        <div class="p-3 bg-white rounded-2 border border-danger border-opacity-25 mt-2 text-dark" style="font-size: 0.95rem; line-height: 1.6; white-space: pre-wrap;">${fn:escapeXml(course.moderationNote)}</div>
                        <p class="mb-0 text-muted small mt-2">
                            <i class="bi bi-info-circle me-1"></i>Vui lòng điều chỉnh hoặc bổ sung nội dung bài giảng theo góp ý trên, sau đó nhấn <strong>"Gửi duyệt"</strong> để Quản trị viên phê duyệt lại.
                        </p>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${course.status == 'PENDING_REVIEW'}">
            <div class="alert alert-warning border border-warning shadow-sm rounded-3 py-3 px-4 mb-4 d-flex align-items-center justify-content-between flex-wrap gap-3">
                <div class="d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-warning bg-opacity-25 p-2 text-warning fs-4 d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <div>
                        <h6 class="fw-bold mb-1 text-dark">Khóa học đang ở trạng thái Chờ duyệt (Khóa chỉnh sửa)</h6>
                        <p class="mb-0 text-muted small">
                            Nội dung khóa học đã được gửi tới Ban Quản Trị và tạm khóa chỉnh sửa. Nếu bạn muốn tiếp tục sửa đổi hoặc bổ sung bài giảng, vui lòng chuyển khóa học về Bản nháp.
                        </p>
                    </div>
                </div>
                <button type="button" class="btn btn-warning fw-semibold btn-sm text-dark px-3 shadow-sm"
                        onclick="confirmCancelPublishCourse('${fn:escapeXml(course.title)}', '${pageContext.request.contextPath}/expert/cancel-request-publish?courseId=${course.id}&from=lessons')">
                    <i class="bi bi-arrow-counterclockwise me-1"></i>Thu hồi về Bản nháp để sửa
                </button>
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
                
            </div>

            <!-- Action Toolbar -->
            <div class="d-flex flex-wrap align-items-center gap-2">
                <c:choose>
                    <c:when test="${course.status == 'DRAFT'}">
                        <!-- #m_duyet [TRẠM 1/4 - GIAO DIỆN]: Nút Gửi duyệt. Bấm xác nhận sẽ gửi POST /expert/request-publish?courseId=... -->
                        <button type="button"
                                class="btn btn-saas-outline-emerald"
                                onclick="confirmPublishCourse('${fn:escapeXml(course.title)}', '${pageContext.request.contextPath}/expert/request-publish?courseId=${course.id}&from=lessons')"
                                title="Gửi duyệt khóa học">
                            <i class="bi bi-send-check"></i>Gửi duyệt
                        </button>
                    </c:when>
                    <c:when test="${course.status == 'PENDING_REVIEW'}">
                        <button type="button"
                                class="btn btn-warning text-dark fw-semibold"
                                onclick="confirmCancelPublishCourse('${fn:escapeXml(course.title)}', '${pageContext.request.contextPath}/expert/cancel-request-publish?courseId=${course.id}&from=lessons')"
                                title="Thu hồi yêu cầu xuất bản về Bản nháp">
                            <i class="bi bi-arrow-counterclockwise me-1"></i>Thu hồi về Bản nháp để sửa
                        </button>
                    </c:when>
                </c:choose>
                <a href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}" class="btn btn-saas-outline" title="Quản lý Quiz cho khóa học">
                    <i class="bi bi-patch-question text-warning me-1"></i>Quản lý Quiz
                </a>
                <c:if test="${course.status != 'PENDING_REVIEW'}">
                    <button type="button" class="btn btn-saas-primary" data-bs-toggle="modal" data-bs-target="#addModuleModal">
                        <i class="bi bi-folder-plus me-1"></i>Thêm Chương mới
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Modules & Lessons List (Grouped by Module) -->
        <c:choose>
            <c:when test="${empty course.modules}">
                <div class="saas-module-card p-5 text-center">
                    <div class="saas-stat-icon saas-icon-blue mx-auto mb-3" style="width: 52px; height: 52px; font-size: 1.5rem; border-radius: 12px; background: #eff6ff; color: #2563eb; display: inline-flex; align-items: center; justify-content: center;">
                        <i class="bi bi-collection-play"></i>
                    </div>
                    <h5 class="fw-bold text-dark mb-2">Khóa học này chưa có chương học nào</h5>
                    <p class="text-muted small mb-4" style="max-width: 500px; margin-left: auto; margin-right: auto;">
                        Bắt đầu xây dựng cấu trúc khóa học bằng cách thêm Chương học (Module) đầu tiên. Mỗi bài giảng sẽ được thêm vào bên trong chương học tương ứng.
                    </p>
                    <c:if test="${course.status != 'PENDING_REVIEW'}">
                        <div class="d-flex justify-content-center gap-2">
                            <button type="button" class="btn btn-saas-primary" data-bs-toggle="modal" data-bs-target="#addModuleModal">
                                <i class="bi bi-folder-plus me-1"></i>Thêm Chương đầu tiên
                            </button>
                        </div>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                                    <!-- #m_cay [TRẠM 4/4 - HIỂN THỊ JSP]: 2 vòng lặp lồng nhau: Vòng ngoài duyệt ${course.modules} in ra Chương, vòng trong duyệt ${m.lessons} in ra từng Bài học -->
                <c:forEach var="m" items="${course.modules}">
                    <div class="saas-module-card mb-3" id="moduleCard-${m.id}">
                        <!-- Module Header -->
                        <div class="saas-module-header">
                            <div class="d-flex align-items-center gap-2 flex-grow-1" data-bs-toggle="collapse" data-bs-target="#moduleCollapse-${m.id}" aria-expanded="true">
                                <i class="bi bi-chevron-down module-chevron me-1"></i>
                                <div class="saas-module-title">
                                    <i class="bi bi-folder2-open text-primary"></i>
                                    <span>${m.displayTitle}</span>
                                </div>
                                <span class="pill-neutral ms-1">${fn:length(m.lessons)} bài học</span>
                            </div>
                            <div class="d-flex align-items-center gap-2 flex-shrink-0" onclick="event.stopPropagation();">
                                <c:choose>
                                    <c:when test="${course.status == 'PENDING_REVIEW'}">
                                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle py-1.5 px-2" style="font-size: 11px;">
                                            <i class="bi bi-lock-fill me-1"></i>Chờ duyệt (Đã khóa)
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/expert/lesson-detail?courseId=${course.id}&moduleId=${m.id}" class="btn btn-sm btn-saas-primary" title="Thêm bài học vào chương này">
                                            <i class="bi bi-plus-lg me-1"></i>Thêm bài học
                                        </a>
                                        <button type="button" class="btn-icon-action" onclick="openEditModuleModal('${m.id}', '${fn:escapeXml(m.title)}', '${m.orderIndex}')" title="Đổi tên chương">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button type="button" class="btn-icon-action text-danger" onclick="confirmDeleteModule('${fn:escapeXml(m.title)}', '${m.id}', ${fn:length(m.lessons)})" title="Xóa chương này">
                                            <i class="bi bi-trash3"></i>
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Module Lessons (Collapsible) -->
                        <div class="collapse show module-lesson-list" id="moduleCollapse-${m.id}" data-module-id="${m.id}">
                            <c:choose>
                                <c:when test="${empty m.lessons}">
                                    <div class="p-4 text-center text-muted small bg-light">
                                        <i class="bi bi-inbox me-1"></i>Chương này chưa có bài học nào.
                                        <c:choose>
                                            <c:when test="${course.status == 'PENDING_REVIEW'}">
                                                <span class="ms-1 text-muted">(Khóa học đang chờ duyệt, vui lòng thu hồi về Bản nháp để thêm bài học)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/expert/lesson-detail?courseId=${course.id}&moduleId=${m.id}" class="ms-1 fw-semibold text-primary text-decoration-none">
                                                    + Bấm vào đây để thêm bài học vào chương này
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="l" items="${m.lessons}" varStatus="lStatus">
                                        <div class="saas-lesson-item ${!l.active ? 'opacity-75 bg-light-subtle' : ''}" id="lessonRow-${l.id}"
                                             data-lesson-id="${l.id}" data-module-id="${m.id}"
                                             draggable="${course.status != 'PENDING_REVIEW'}"
                                             style="transition: all 0.25s ease;">
                                            <div class="d-flex align-items-center gap-3 min-w-0">
                                                <c:if test="${course.status != 'PENDING_REVIEW'}">
                                                    <div class="lesson-drag-handle me-1" style="cursor: grab;" title="Kéo thả để sắp xếp vị trí bài học">
                                                        <i class="bi bi-grip-vertical fs-5"></i>
                                                    </div>
                                                </c:if>
                                                <div class="lesson-thumb-box">
                                                    <img src="${l.thumbnailUrl}" alt="${l.title}"
                                                         onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                                </div>
                                                <div class="min-w-0">
                                                    <div class="d-flex align-items-center gap-2 mb-1 flex-wrap">
                                                        <span class="pill-neutral lesson-order-badge" style="font-size: 11px;">Bài ${lStatus.count}</span>
                                                        <c:if test="${not empty l.videoUrl}">
                                                            <span class="pill-video"><i class="bi bi-youtube"></i>Video</span>
                                                        </c:if>
                                                        <c:if test="${not empty l.documentUrl}">
                                                            <span class="pill-doc"><i class="bi bi-file-earmark-text"></i>Tài liệu</span>
                                                        </c:if>
                                                        <c:choose>
                                                            <c:when test="${l.active}">
                                                                <span class="badge bg-success-subtle text-success border border-success-subtle" style="font-size: 11px;">
                                                                    <i class="bi bi-check-circle me-1"></i>Hiển thị
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle" style="font-size: 11px;">
                                                                    <i class="bi bi-eye-slash-fill me-1"></i>Đã ẩn
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="fw-semibold text-dark text-truncate ${!l.active ? 'text-muted' : ''}" style="font-size: 0.95rem;" title="${l.title}">
                                                        ${l.title}
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="d-flex align-items-center gap-2 flex-shrink-0">
                                                <c:choose>
                                                    <c:when test="${course.status == 'PENDING_REVIEW'}">
                                                        <span class="badge bg-light text-muted border py-1.5 px-2" style="font-size: 11px;" title="Khóa học đang chờ duyệt, chuyển về Bản nháp để chỉnh sửa">
                                                            <i class="bi bi-lock me-1"></i>Đã khóa
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/expert/lesson-detail?courseId=${course.id}&moduleId=${m.id}&lessonId=${l.id}" class="btn-icon-action" title="Chỉnh sửa bài học" aria-label="Sửa bài">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <c:choose>
                                                            <c:when test="${l.active}">
                                                                <button type="button" class="btn-icon-action text-warning border-0 bg-transparent ms-1"
                                                                        onclick="confirmToggleVisibility('${l.id}', '${fn:escapeXml(l.title)}', false)"
                                                                        title="Tạm ẩn bài học (Học viên không nhìn thấy)" aria-label="Ẩn bài học">
                                                                    <i class="bi bi-eye-slash"></i>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn-icon-action text-success border-0 bg-transparent ms-1"
                                                                        onclick="confirmToggleVisibility('${l.id}', '${fn:escapeXml(l.title)}', true)"
                                                                        title="Mở hiển thị lại cho học viên" aria-label="Hiện bài học">
                                                                    <i class="bi bi-eye"></i>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <button type="button" class="btn-icon-action text-danger border-0 bg-transparent ms-1"
                                                                onclick="confirmDeleteLesson('${l.id}', '${fn:escapeXml(l.title)}')"
                                                                title="Xóa bài học" aria-label="Xóa bài">
                                                            <i class="bi bi-trash3"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- Add Module Modal -->
<div class="modal fade" id="addModuleModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content saas-modal">
            <form action="${pageContext.request.contextPath}/expert/save-module" method="POST">
                <input type="hidden" name="courseId" value="${course.id}">
                <div class="modal-header saas-modal-header">
                    <h5 class="modal-title fw-bold text-dark fs-6">
                        <i class="bi bi-folder-plus text-primary me-2"></i>Thêm Chương học mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label saas-form-label">Tên chương học <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control saas-form-control" required placeholder="Ví dụ: Cài đặt và cấu hình môi trường">
                    </div>
                </div>
                <div class="modal-footer saas-modal-footer">
                    <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-saas-primary btn-sm">Tạo chương</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Module Modal -->
<div class="modal fade" id="editModuleModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content saas-modal">
            <form action="${pageContext.request.contextPath}/expert/save-module" method="POST">
                <input type="hidden" name="courseId" value="${course.id}">
                <input type="hidden" name="id" id="editModuleId">
                <input type="hidden" name="orderIndex" id="editModuleOrder">
                <div class="modal-header saas-modal-header">
                    <h5 class="modal-title fw-bold text-dark fs-6">
                        <i class="bi bi-pencil-square text-primary me-2"></i>Chỉnh sửa Chương học
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label saas-form-label">Tên chương học <span class="text-danger">*</span></label>
                        <input type="text" name="title" id="editModuleTitle" class="form-control saas-form-control" required>
                    </div>
                </div>
                <div class="modal-footer saas-modal-footer">
                    <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-saas-primary btn-sm">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    window.CONTEXT_PATH = '${pageContext.request.contextPath}';
    window.COURSE_ID = '${course.id}';
</script>
<script src="${pageContext.request.contextPath}/assets/js/expert-lesson-list.js"></script>

<jsp:include page="../common/footer.jsp" />
