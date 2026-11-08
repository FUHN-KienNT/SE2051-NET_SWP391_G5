<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Soạn thảo bài học - Courson LMS" />
<jsp:include page="../common/header.jsp" />

<!-- Quill WYSIWYG Editor CSS -->
<link href="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.snow.css" rel="stylesheet">

<style>
    .ql-toolbar.ql-snow {
        border-top-left-radius: 8px;
        border-top-right-radius: 8px;
        border-color: #dee2e6;
        background-color: #f8f9fa;
        padding: 8px 12px;
    }
    .ql-container.ql-snow {
        border-bottom-left-radius: 8px;
        border-bottom-right-radius: 8px;
        border-color: #dee2e6;
        font-family: inherit;
        font-size: 15px;
        background-color: #ffffff;
    }
    .ql-editor {
        min-height: 200px;
        max-height: 480px;
        overflow-y: auto;
        line-height: 1.7;
    }
    .ql-editor.ql-blank::before {
        color: #adb5bd;
        font-style: normal;
    }
</style>

<main class="main-content py-5">
    <div class="container">
        <!-- Breadcrumb -->
        <nav class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/expert/dashboard">Expert Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}">${course.title}</a></li>
                <li class="breadcrumb-item active">${lesson != null ? 'Chỉnh sửa bài học' : 'Thêm bài học mới'}</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-lg-9">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                        <div>
                            <h4 class="fw-bold mb-1">
                                <i class="bi bi-pencil-square text-primary me-2"></i>
                                ${lesson != null ? 'Chỉnh sửa bài học' : 'Thêm bài học mới'}
                            </h4>
                            
                        </div>
                        <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-outline-secondary btn-sm" id="btnBackToLessons">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại
                        </a>
                    </div>

                    <c:set var="displayError" value="${not empty errorMessage ? errorMessage : param.error}" />
                    <c:if test="${not empty displayError}">
                        <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${displayError}" escapeXml="true" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Container thông báo khôi phục bản nháp tự động -->
                    <div id="draftRecoveryAlertContainer"></div>

                    <form action="${pageContext.request.contextPath}/expert/save-lesson" method="POST" id="lessonForm">
                        <input type="hidden" name="courseId" id="lessonCourseId" value="${course.id}">
                        <c:if test="${lesson != null}">
                            <input type="hidden" name="id" id="lessonId" value="${lesson.id}">
                        </c:if>

                        <c:set var="curModId" value="${selectedModuleId != null ? selectedModuleId : (lesson != null ? lesson.moduleId : '')}" />
                        <div class="mb-3">
                            <label class="form-label small fw-semibold mb-1" for="lessonModuleId">
                                <i class="bi bi-folder2-open text-primary me-1"></i>Thuộc Chương học (Module) <span class="text-danger">*</span>
                            </label>
                            <c:choose>
                                <c:when test="${not empty course.modules}">
                                    <select name="moduleId" id="lessonModuleId" class="form-select saas-form-control" required onchange="handleModuleSelectChange(this.value)">
                                        <c:forEach var="moduleItem" items="${course.modules}">
                                            <option value="${moduleItem.id}" ${moduleItem.id == curModId ? 'selected' : ''}>
                                                <c:out value="${moduleItem.displayTitle}" />
                                            </option>
                                        </c:forEach>
                                        <option value="__NEW__" class="fw-bold text-primary">+ Tạo Chương học mới...</option>
                                    </select>
                                </c:when>
                                <c:otherwise>
                                    <input type="hidden" name="moduleId" id="lessonModuleId" value="__NEW__">
                                </c:otherwise>
                            </c:choose>

                            <!-- Nhập tên chương mới nếu chọn tạo chương mới hoặc khóa học chưa có chương nào -->
                            <div id="newModuleInputGroup" class="mt-2 ${empty course.modules ? '' : 'd-none'}">
                                <div class="input-group">
                                    <span class="input-group-text bg-light small"><i class="bi bi-folder-plus text-primary"></i></span>
                                    <input type="text" name="newModuleTitle" id="newModuleTitle" class="form-control"
                                           placeholder="Nhập tên chương học mới..."
                                           value="${empty course.modules ? 'Khởi động & Giới thiệu' : ''}">
                                </div>
                            </div>
                        </div>

                        <input type="hidden" name="orderIndex" id="lessonOrderIndex" value="${lesson != null ? lesson.orderIndex : (course.totalLessons + 1)}">

                        <div class="row g-3 mb-3">
                            <div class="col-md-8">
                                <label class="form-label small fw-semibold">Tiêu đề bài học <span class="text-danger">*</span></label>
                                <input type="text" name="title" id="lessonTitle" class="form-control" value="${lesson != null ? lesson.title : ''}" required placeholder="Ví dụ: Giới thiệu cú pháp Java cơ bản">
                                <div id="titleFetchFeedback" class="mt-1 small" style="display: none;"></div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">
                                    <i class="bi bi-eye text-primary me-1"></i>Trạng thái hiển thị
                                </label>
                                <select name="isActive" id="lessonIsActive" class="form-select">
                                    <option value="true" ${lesson == null || lesson.active ? 'selected' : ''}>Hiển thị (Công khai)</option>
                                    <option value="false" ${lesson != null && !lesson.active ? 'selected' : ''}>Tạm ẩn (Không công khai)</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label class="form-label small fw-semibold mb-0"><i class="bi bi-youtube text-danger me-1"></i>URL Video bài giảng (YouTube hoặc MP4)</label>
                                
                            </div>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-link-45deg"></i></span>
                                <input type="url" id="lessonVideoUrl" name="videoUrl" class="form-control" value="${lesson != null ? lesson.videoUrl : ''}" placeholder="Dán link YouTube (vd: https://www.youtube.com/watch?v=... hoặc https://www.youtube.com/shorts/...)" oninput="handleVideoUrlChange()" onpaste="setTimeout(handleVideoUrlChange, 50)">
                            </div>
                            
                            <!-- Video Player (Fit 100% full width, No gap) -->
                            <div id="videoContainer" class="mt-2.5 text-center ${not empty lesson.videoUrl ? '' : 'd-none'}">
                                <div id="videoWrapper" class="w-100 rounded-3 overflow-hidden shadow-sm bg-black mx-auto" style="aspect-ratio: 16 / 9; transition: max-width 0.25s ease;">
                                    <iframe id="videoPreviewIframe" class="w-100 h-100" src="${lesson != null ? lesson.videoUrl : ''}" allowfullscreen style="border: 0; display: block;"></iframe>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold"><i class="bi bi-file-earmark-text text-info me-1"></i>URL Tài liệu đính kèm (Slide / PDF / Google Docs)</label>
                            <input type="url" name="documentUrl" id="lessonDocumentUrl" class="form-control" value="${lesson != null ? lesson.documentUrl : ''}" placeholder="https://drive.google.com/...">
                        </div>

                        <!-- WYSIWYG Rich Text Content Editor -->
                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label class="form-label small fw-semibold mb-0">Nội dung chi tiết bài học / Ghi chú lý thuyết</label>
                                <span class="badge bg-primary-subtle text-primary border small" style="font-size: 11px;">
                                    <i class="bi bi-pencil-square me-1"></i>Trình soạn thảo trực quan (WYSIWYG)
                                </span>
                            </div>

                            <!-- Hidden input to submit with the form -->
                            <textarea name="content" id="lessonContent" class="d-none">${lesson != null ? lesson.content : ''}</textarea>

                            <!-- Quill Editor Container -->
                            <div id="quillEditor">${lesson != null ? lesson.content : ''}</div>

                            
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-3 border-top flex-wrap gap-2">
                            <div class="d-flex align-items-center gap-3">
                                <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-light btn-sm" id="btnCancelLesson">
                                    <i class="bi bi-arrow-left me-1"></i>Hủy bỏ
                                </a>
                                <div class="d-flex align-items-center gap-2">
                                    <span id="autoSaveStatusText" class="small text-muted"></span>
                                    <button type="button" class="btn btn-link btn-sm text-decoration-none p-0 small text-secondary" onclick="manualSaveDraft()" title="Lưu nháp ngay bây giờ">
                                        <i class="bi bi-cloud-arrow-up me-1"></i>Lưu nháp ngay
                                    </button>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary fw-semibold px-4 shadow-sm" id="btnSubmitLesson">
                                <i class="bi bi-save me-1"></i>Lưu bài học
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Quill WYSIWYG Editor JS -->
<script src="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.min.js"></script>

<script>
    window.CONTEXT_PATH = '${pageContext.request.contextPath}';
    window.COURSE_ID = '${course.id}';
    window.IS_USER_TYPING_MANUALLY = ${lesson != null && not empty lesson.title ? 'true' : 'false'};
</script>
<script src="${pageContext.request.contextPath}/assets/js/expert-lesson-detail.js"></script>


<!-- Modal Bootstrap: Cảnh báo xác nhận khi đang sửa bài học mà thoát ra -->
<div class="modal fade" id="unsavedChangesModal" tabindex="-1" aria-labelledby="unsavedChangesModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 480px;">
        <div class="modal-content shadow-lg border-0 rounded-4 overflow-hidden">
            <div class="modal-header border-0 pb-0 pt-4 px-4 d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-2">
                    <div class="rounded-circle bg-warning-subtle text-warning d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;">
                        <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    </div>
                    <div>
                        <h5 class="modal-title fw-bold text-dark fs-6 mb-0" id="unsavedChangesModalLabel">Chưa lưu thay đổi bài học!</h5>
                        <span class="text-muted small">Cảnh báo thoát khỏi trang soạn thảo</span>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            <div class="modal-body px-4 py-3">
                <p class="text-secondary small mb-3">
                    Bạn đang chỉnh sửa nội dung bài học và có những thay đổi chưa được lưu lại. Nếu rời khỏi trang bây giờ, các thay đổi mới nhất có thể chưa được lưu chính thức vào hệ thống.
                </p>
                <div class="p-3 bg-light rounded-3 border small mb-2 d-flex align-items-start gap-2">
                    <i class="bi bi-shield-check text-success fs-5 mt-n1 flex-shrink-0"></i>
                    <div>
                        <strong class="text-dark d-block mb-1">Dữ liệu được bảo toàn an toàn:</strong>
                        <span class="text-muted">Hệ thống đã tự động lưu lại bản nháp trên trình duyệt. Bạn có thể khôi phục lại khi quay lại soạn thảo bài học này.</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 pt-0 pb-4 px-4 flex-column gap-2">
                <button type="button" class="btn btn-primary w-100 fw-semibold py-2.5 rounded-3 shadow-sm d-flex align-items-center justify-content-center" id="modalBtnSaveAndExit">
                    <i class="bi bi-floppy2-fill me-2"></i>Lưu bài học rồi thoát
                </button>
                <button type="button" class="btn btn-outline-danger w-100 fw-medium py-2 rounded-3 d-flex align-items-center justify-content-center" id="modalBtnDiscardAndExit">
                    <i class="bi bi-box-arrow-right me-2"></i>Rời đi (Không lưu thay đổi)
                </button>
                <button type="button" class="btn btn-link text-muted text-decoration-none small py-1" data-bs-dismiss="modal">
                    <i class="bi bi-arrow-return-left me-1"></i>Ở lại tiếp tục chỉnh sửa
                </button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
