<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="${isEdit ? 'Chỉnh sửa: '.concat(course.title) : 'Tạo Khóa học mới'} - Courson" />
<jsp:include page="../common/header.jsp" />

<style>
/* Modern SaaS Design Tokens for Course Detail */
.saas-container {
    max-width: 860px;
    margin: 0 auto;
}
.saas-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    box-shadow: 0 4px 20px -2px rgba(15, 23, 42, 0.06);
    padding: 2.25rem;
}
.saas-form-label {
    font-size: 0.8125rem;
    font-weight: 600;
    color: #334155;
    margin-bottom: 6px;
    display: block;
}
.saas-form-control {
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    font-size: 0.875rem;
    padding: 9px 12px;
    transition: all 0.15s ease;
}
.saas-form-control:focus {
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}
.btn-saas-primary {
    background: #0f172a;
    color: #ffffff;
    border: 1px solid #0f172a;
    font-weight: 600;
    font-size: 0.875rem;
    padding: 10px 20px;
    border-radius: 8px;
    transition: all 0.15s ease;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    text-decoration: none;
    box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
}
.btn-saas-primary:hover {
    background: #1e293b;
    color: #ffffff;
    border-color: #1e293b;
    transform: translateY(-1px);
}
.btn-saas-outline {
    background: #ffffff;
    color: #0f172a;
    border: 1px solid #cbd5e1;
    font-weight: 600;
    font-size: 0.875rem;
    padding: 9px 18px;
    border-radius: 8px;
    transition: all 0.15s ease;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    text-decoration: none;
}
.btn-saas-outline:hover {
    background: #f8fafc;
    border-color: #94a3b8;
    color: #0f172a;
}
.saas-youtube-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 16px;
}
</style>

<main class="main-content py-5 bg-light-subtle">
    <div class="container saas-container">

        <!-- Breadcrumbs & Header -->
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1 small">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/expert/dashboard" class="text-decoration-none text-muted">Expert Studio</a></li>
                        <c:choose>
                            <c:when test="${isEdit}">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/courses/detail?id=${course.id}" class="text-decoration-none text-muted">Khóa học #${course.id}</a></li>
                                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Course Detail</li>
                            </c:when>
                            <c:otherwise>
                                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Tạo khóa học mới</li>
                            </c:otherwise>
                        </c:choose>
                    </ol>
                </nav>
                <div class="d-flex align-items-center gap-2">
                    <h3 class="fw-bold mb-0 text-dark">
                        <i class="bi ${isEdit ? 'bi-gear-fill' : 'bi-plus-circle'} text-primary me-2"></i>
                        ${isEdit ? 'Chỉnh sửa Khóa học' : 'Tạo Khóa học mới'}
                    </h3>
                    <c:if test="${isEdit}">
                        <c:choose>
                            <c:when test="${course.status == 'PUBLISHED'}">
                                <span class="badge px-2.5 py-1 rounded-pill" style="background: #ecfdf5; color: #047857; border: 1px solid #a7f3d0; font-size: 0.75rem;">
                                    ● Đang công khai
                                </span>
                            </c:when>
                            <c:when test="${course.status == 'PENDING_REVIEW'}">
                                <span class="badge px-2.5 py-1 rounded-pill" style="background: #fffbeb; color: #b45309; border: 1px solid #fde68a; font-size: 0.75rem;">
                                    ● Chờ duyệt
                                </span>
                            </c:when>
                            <c:when test="${course.status == 'DRAFT'}">
                                <span class="badge px-2.5 py-1 rounded-pill" style="background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; font-size: 0.75rem;">
                                    ● Bản nháp
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-light text-muted border px-2 py-1">${course.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </div>
                <p class="text-muted small mb-0">
                    <c:choose>
                        <c:when test="${isEdit}">Chỉnh sửa thông tin chi tiết của khóa học</c:when>
                        <c:otherwise>Nhập thông tin khóa học hoặc dán link YouTube để tự động tạo bài học</c:otherwise>
                    </c:choose>
                </p>
            </div>

            <!-- Action buttons in header -->
            <div class="d-flex align-items-center gap-2">
                <c:if test="${isEdit}">
                    <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-saas-outline btn-sm">
                        <i class="bi bi-collection-play text-primary"></i>Soạn đề cương bài giảng
                    </a>
                </c:if>
                <a href="${pageContext.request.contextPath}/expert/dashboard" class="btn btn-saas-outline btn-sm">
                    <i class="bi bi-arrow-left me-1"></i>Về Studio
                </a>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm mb-4 border-0" role="alert" style="background: #fef2f2; color: #991b1b; border-left: 4px solid #ef4444 !important;">
                <i class="bi bi-exclamation-triangle-fill me-2 text-danger"></i><c:out value="${errorMessage}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm mb-4 border-0" role="alert" style="background: #f0fdf4; color: #166534; border-left: 4px solid #22c55e !important;">
                <i class="bi bi-check-circle-fill me-2 text-success"></i><c:out value="${successMessage}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Course Detail Form -->
        <form action="${pageContext.request.contextPath}/expert/save-course" method="POST" id="courseDetailForm">
            <c:if test="${isEdit}">
                <input type="hidden" name="id" value="${course.id}">
            </c:if>
            <input type="hidden" name="redirect" value="detail">

            <div class="saas-card mb-4">
                <!-- Course Title -->
                <div class="mb-4">
                    <label class="saas-form-label">Tên khóa học <span class="text-danger">*</span></label>
                    <input type="text" name="title" id="courseDetailTitle" class="form-control saas-form-control form-control-lg"
                        value="<c:out value="${course.title}" />" placeholder="Ví dụ: Khóa học Lập trình Web Fullstack 2026..." required>
                    <c:if test="${not isEdit}">
                        <div class="form-text small text-muted">Nếu dán link Playlist YouTube bên dưới, tên khóa học sẽ tự động được điền theo tên playlist.</div>
                    </c:if>
                </div>

                <!-- Category & Price -->
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="saas-form-label">Danh mục <span class="text-danger">*</span></label>
                        <select name="categoryId" id="courseCategoryId" class="form-select saas-form-control" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${cat.id == course.categoryId ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="saas-form-label">Học phí (VNĐ)</label>
                        <input type="number" name="price" class="form-control saas-form-control"
                            value="${course.price != null ? course.price : 0}" min="0" step="1000" placeholder="0">
                    </div>
                </div>

                <!-- Description -->
                <div class="mb-4">
                    <label class="saas-form-label">Mô tả tóm tắt</label>
                    <textarea name="description" id="courseDescription" rows="3" class="form-control saas-form-control"
                        placeholder="Mô tả ngắn gọn về khóa học..."><c:out value="${course.description}" /></textarea>
                </div>

                <!-- Đường dẫn ảnh bìa (Thumbnail URL) -->
                <div class="mb-4">
                    <label class="saas-form-label">Đường dẫn ảnh bìa (Thumbnail URL)</label>
                    <c:set var="currentThumb" value="${not empty course && not empty course.thumbnailUrl && !fn:contains(course.thumbnailUrl, 'unsplash.com') ? course.thumbnailUrl : ''}" />
                    <input type="url" name="thumbnailUrl" id="thumbnailUrlInput" class="form-control saas-form-control"
                        value="<c:out value="${currentThumb}" />"
                        placeholder="Mặc định lấy từ video YouTube hoặc dán link ảnh tùy chọn..."
                        oninput="previewCourseThumbnail(this.value)">
                    <div id="thumbPreviewBox" class="mt-2 ${empty currentThumb ? 'd-none' : ''}">
                        <img id="thumbPreviewImg" src="<c:out value="${currentThumb}" />" alt="Thumbnail Preview"
                            style="max-height: 160px; max-width: 100%; border-radius: 8px; border: 1px solid #cbd5e1; object-fit: cover;">
                    </div>
                </div>

                <!-- Section: YouTube Import (Tùy chọn) -->
                <div class="saas-youtube-card mb-4" style="border: 1px solid #e2e8f0; background: #ffffff; border-radius: 12px; padding: 16px;">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="saas-form-label mb-0 text-dark d-flex align-items-center">
                            <i class="bi bi-youtube text-danger me-1 fs-6"></i>Nhập Playlist hoặc danh sách link YouTube
                        </span>
                        <span class="badge" style="background-color: #fee2e2; color: #dc2626; font-size: 11px; font-weight: 500; padding: 3px 8px; border-radius: 6px;">Tùy chọn</span>
                    </div>
                    <textarea name="batchVideoText" id="courseBatchText" rows="3"
                        class="form-control font-monospace small bg-white saas-form-control"
                        placeholder="Dán link playlist (https://www.youtube.com/playlist?list=...) hoặc danh sách link video (mỗi dòng 1 link)..."
                        oninput="previewCourseBatchVideos()"></textarea>
                    <div id="courseBatchFeedback" class="mt-2 small d-none"></div>
                </div>

                <!-- Footer CTA Actions -->
                <div class="d-flex justify-content-end align-items-center gap-2 pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/expert/dashboard" class="btn btn-link text-muted text-decoration-none px-3">Hủy</a>
                    <button type="submit" class="btn btn-saas-primary">
                        <i class="bi bi-check-lg me-1"></i>
                        <c:choose>
                            <c:when test="${isEdit}">Lưu thay đổi</c:when>
                            <c:otherwise>Tạo khóa học</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </div>
        </form>
    </div>
</main>

<script>
let courseBatchTimer = null;
let lastDetectedCourseTitle = '';
let isUserTypingCourseTitleManually = ${course != null && not empty course.title ? 'true' : 'false'};

document.addEventListener('DOMContentLoaded', function() {
    const titleInput = document.getElementById('courseDetailTitle');
    const batchInput = document.getElementById('courseBatchText');

    if (titleInput) {
        titleInput.addEventListener('input', function() {
            if (this.value.trim().length > 0) {
                isUserTypingCourseTitleManually = true;
            } else {
                // Khi người dùng xóa hết chữ trong ô tiêu đề, mở lại cờ auto-fill
                isUserTypingCourseTitleManually = false;
            }
        });

        // Khi tiêu đề đang trống, người dùng nhấn Enter -> tự động fill lại tiêu đề theo link!
        titleInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                if (!this.value || this.value.trim() === '') {
                    e.preventDefault();
                    isUserTypingCourseTitleManually = false;
                    if (lastDetectedCourseTitle && lastDetectedCourseTitle.trim()) {
                        this.value = lastDetectedCourseTitle;
                    }
                    previewCourseBatchVideos(true);
                }
            }
        });

        // Khi gõ xong tên khóa học và rời ô, tự động sinh mô tả qua AI nếu mô tả còn trống
        titleInput.addEventListener('change', function() {
            const val = this.value.trim();
            const descEl = document.getElementById('courseDescription');
            const catEl = document.getElementById('courseCategoryId');
            if (val && descEl && !descEl.value.trim()) {
                let catName = (catEl && catEl.selectedIndex > 0) ? catEl.options[catEl.selectedIndex].text.trim() : '';
                fetch('${pageContext.request.contextPath}/expert/generate-ai-description?title=' + encodeURIComponent(val) + '&categoryName=' + encodeURIComponent(catName))
                    .then(res => res.json())
                    .then(data => {
                        if (data && data.description && descEl && !descEl.value.trim()) {
                            descEl.value = data.description;
                        }
                    })
                    .catch(() => {});
            }
        });
    }

    if (batchInput) {
        batchInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                const titleInp = document.getElementById('courseDetailTitle');
                if (titleInp && (!titleInp.value || titleInp.value.trim() === '')) {
                    previewCourseBatchVideos(true);
                }
            }
        });
    }
});

function previewCourseBatchVideos(forceFill = false) {
    const batchEl = document.getElementById('courseBatchText');
    if (!batchEl) return;
    const text = batchEl.value;
    const feedback = document.getElementById('courseBatchFeedback');
    clearTimeout(courseBatchTimer);
    if (!text || !text.trim()) {
        if (feedback) {
            feedback.className = 'mt-2 small d-none';
            feedback.innerHTML = '';
        }
        return;
    }

    const doFetch = () => {
        fetch('${pageContext.request.contextPath}/expert/preview-batch-videos', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: 'batchText=' + encodeURIComponent(text)
        })
        .then(res => res.json())
        .then(data => {
            const lessons = data.lessons || data.videos || [];
            if (data.success && (lessons.length > 0 || data.playlistTitle)) {
                const detectedTitle = (data.playlistTitle && data.playlistTitle !== 'undefined' && data.playlistTitle !== 'null') 
                    ? data.playlistTitle 
                    : (lessons[0] && lessons[0].title ? lessons[0].title : '');
                if (detectedTitle) {
                    lastDetectedCourseTitle = detectedTitle;
                }
                const titleInput = document.getElementById('courseDetailTitle');
                if (titleInput && (forceFill || !titleInput.value || titleInput.value.trim() === '' || !isUserTypingCourseTitleManually) && lastDetectedCourseTitle) {
                    titleInput.value = lastDetectedCourseTitle;
                    isUserTypingCourseTitleManually = false;
                }

                // 1. Tự động chọn Danh mục do Gemini AI gợi ý
                const catSelect = document.getElementById('courseCategoryId');
                if (catSelect && data.suggestedCategoryId && (!catSelect.value || catSelect.value === '')) {
                    catSelect.value = data.suggestedCategoryId;
                }

                // 2. Tự động điền Mô tả tóm tắt do Gemini AI gợi ý
                const descTextarea = document.getElementById('courseDescription');
                if (descTextarea && data.suggestedDescription && (!descTextarea.value || descTextarea.value.trim() === '')) {
                    descTextarea.value = data.suggestedDescription;
                }

                // 3. Tự động điền Ảnh bìa (Thumbnail) từ video YouTube đầu tiên
                const thumbInput = document.getElementById('thumbnailUrlInput');
                const firstVideo = (lessons && lessons.length > 0) ? lessons[0] : null;
                let firstVidId = null;
                if (firstVideo) {
                    firstVidId = firstVideo.videoId || extractYoutubeId(firstVideo.videoUrl);
                } else if (text) {
                    firstVidId = extractYoutubeId(text);
                }
                if (firstVidId && thumbInput && (!thumbInput.value || thumbInput.value.trim() === '' || thumbInput.value.includes('unsplash.com'))) {
                    const ytThumb = 'https://img.youtube.com/vi/' + firstVidId + '/hqdefault.jpg';
                    thumbInput.value = ytThumb;
                    previewCourseThumbnail(ytThumb);
                }

                if (feedback) {
                    feedback.className = 'mt-2 small text-success';
                    feedback.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i>Nhận diện được <strong>' + lessons.length + ' bài giảng YouTube</strong> hợp lệ!';
                }
            } else {
                if (feedback) {
                    feedback.className = 'mt-2 small text-muted';
                    feedback.innerHTML = '<i class="bi bi-info-circle me-1"></i>Đang nhập danh sách link video YouTube.';
                }
            }
        })
        .catch(() => {});
    };

    if (forceFill) {
        doFetch();
    } else {
        courseBatchTimer = setTimeout(doFetch, 400);
    }
}

function previewCourseThumbnail(url) {
    const box = document.getElementById('thumbPreviewBox');
    const img = document.getElementById('thumbPreviewImg');
    if (url && url.trim()) {
        img.src = url.trim();
        img.onload = () => box.classList.remove('d-none');
        img.onerror = () => box.classList.add('d-none');
    } else {
        box.classList.add('d-none');
    }
}

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function extractYoutubeId(url) {
    if (!url) return null;
    url = url.trim();
    if (/^[a-zA-Z0-9_-]{11}$/.test(url)) return url;
    const regExp = /^.*(youtu\.be\/|v\/|u\/\w\/|embed\/|shorts\/|watch\?v=|\&v=)([^#\&\?]*).*/;
    const match = url.match(regExp);
    return (match && match[2].length === 11) ? match[2] : null;
}
</script>

<jsp:include page="../common/footer.jsp" />
