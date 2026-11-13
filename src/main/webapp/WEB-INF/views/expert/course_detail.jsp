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

/* Searchable Custom Combobox (SaaS Dropdown) */
.saas-combobox {
    position: relative;
    width: 100%;
}
.saas-combobox-trigger {
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 9px 12px;
    font-size: 0.875rem;
    background: #ffffff;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    color: #0f172a;
    cursor: pointer;
    transition: all 0.15s ease;
    text-align: left;
}
.saas-combobox-trigger:hover {
    border-color: #94a3b8;
}
.saas-combobox.open .saas-combobox-trigger {
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}
.saas-combobox-label {
    display: flex;
    align-items: center;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.saas-combobox-arrow {
    color: #94a3b8;
    font-size: 0.8rem;
    transition: transform 0.2s cubic-bezier(0.16, 1, 0.3, 1);
    flex-shrink: 0;
}
.saas-combobox.open .saas-combobox-arrow {
    transform: rotate(180deg);
    color: #2563eb;
}
.saas-combobox-dropdown {
    position: absolute;
    top: calc(100% + 6px);
    left: 0;
    right: 0;
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    box-shadow: 0 14px 34px -4px rgba(15, 23, 42, 0.16), 0 6px 12px -2px rgba(15, 23, 42, 0.08);
    z-index: 1065;
    display: none;
    overflow: hidden;
}
.saas-combobox.open .saas-combobox-dropdown {
    display: block;
    animation: saasComboboxFade 0.15s cubic-bezier(0.16, 1, 0.3, 1);
}
@keyframes saasComboboxFade {
    from {
        opacity: 0;
        transform: translateY(-6px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
.saas-combobox-search-wrap {
    position: relative;
    padding: 10px;
    background: #f8fafc;
    border-bottom: 1px solid #f1f5f9;
}
.saas-combobox-search {
    width: 100%;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    padding: 7px 30px 7px 32px;
    font-size: 0.8125rem;
    background: #ffffff;
    outline: none;
    color: #0f172a;
    transition: all 0.15s ease;
}
.saas-combobox-search:focus {
    border-color: #2563eb;
    box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.1);
}
.saas-combobox-search-icon {
    position: absolute;
    left: 20px;
    top: 50%;
    transform: translateY(-50%);
    font-size: 0.8rem;
    color: #94a3b8;
    pointer-events: none;
}
.saas-combobox-search-clear {
    position: absolute;
    right: 18px;
    top: 50%;
    transform: translateY(-50%);
    border: none;
    background: transparent;
    color: #94a3b8;
    cursor: pointer;
    padding: 0;
    font-size: 0.85rem;
    display: flex;
    align-items: center;
}
.saas-combobox-search-clear:hover {
    color: #475569;
}
.saas-combobox-list {
    max-height: 220px;
    overflow-y: auto;
    padding: 6px;
}
.saas-combobox-list::-webkit-scrollbar {
    width: 5px;
}
.saas-combobox-list::-webkit-scrollbar-thumb {
    background: #cbd5e1;
    border-radius: 10px;
}
.saas-combobox-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 8px 12px;
    border-radius: 6px;
    font-size: 0.84rem;
    color: #334155;
    cursor: pointer;
    transition: all 0.12s ease;
    user-select: none;
    margin-bottom: 1px;
}
.saas-combobox-item:hover {
    background: #f1f5f9;
    color: #0f172a;
}
.saas-combobox-item.selected {
    background: #eff6ff;
    color: #1d4ed8;
    font-weight: 600;
}
.saas-combobox-item .item-check {
    color: #2563eb;
    font-size: 1rem;
    display: none;
}
.saas-combobox-item.selected .item-check {
    display: inline-block;
}
.saas-combobox-empty {
    padding: 16px 12px;
    text-align: center;
    font-size: 0.8125rem;
    color: #94a3b8;
}
.saas-combobox-footer {
    border-top: 1px solid #f1f5f9;
    padding: 6px;
    background: #fafbfc;
}
.saas-combobox-footer .add-new-btn {
    width: 100%;
    display: flex;
    align-items: center;
    padding: 8px 12px;
    border-radius: 6px;
    font-size: 0.84rem;
    font-weight: 600;
    color: #2563eb;
    background: transparent;
    border: none;
    cursor: pointer;
    transition: all 0.12s ease;
    text-align: left;
}
.saas-combobox-footer .add-new-btn:hover {
    background: #eff6ff;
    color: #1d4ed8;
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

            <c:choose>
                <c:when test="${isEdit}">
                    <input type="hidden" name="id" value="${course.id}">
                    <input type="hidden" name="redirect" value="detail">
                </c:when>
                <c:otherwise>
                    <input type="hidden" name="redirect" value="lessons">
                </c:otherwise>
            </c:choose>



            <div class="saas-card mb-4">

                <!-- Course Title -->

                <div class="mb-4">

                    <label class="saas-form-label">Tên khóa học <span class="text-danger">*</span></label>

                    <input type="text" name="title" id="courseDetailTitle" class="form-control saas-form-control form-control-lg"

                        value="<c:out value="${course.title}" />" placeholder="Ví dụ: Khóa học Lập trình Web Fullstack 2026..." required>



                </div>



                <!-- Category & Price -->

                <div class="row g-3 mb-4">

                    <div class="col-md-6">

                        <label class="saas-form-label">Danh mục <span class="text-danger">*</span></label>

                        <div class="saas-combobox" id="courseCategoryCombobox">
                            <input type="hidden" name="categoryId" id="courseCategoryId" value="${course.categoryId != null ? course.categoryId : ''}">
                            <button type="button" class="saas-combobox-trigger" aria-haspopup="listbox" aria-expanded="false">
                                <span class="saas-combobox-label">
                                    <i class="bi bi-tag text-muted me-2"></i>
                                    <span class="selected-text">
                                        <c:set var="matchedCatName" value="" />
                                        <c:forEach var="cItem" items="${categories}">
                                            <c:if test="${cItem.id == course.categoryId}"><c:set var="matchedCatName" value="${cItem.name}" /></c:if>
                                        </c:forEach>
                                        ${not empty matchedCatName ? matchedCatName : 'Chọn danh mục...'}
                                    </span>
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
                                        <div class="saas-combobox-item ${cat.id == course.categoryId ? 'selected' : ''}"
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
                                        <i class="bi bi-plus-circle text-primary me-2"></i> Nhập danh mục mới...
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div id="courseCustomCatDiv" class="mt-2" style="display: none;">
                            <div class="position-relative">
                                <input type="text" name="customCategory" id="courseCustomCatInput" class="form-control form-control-sm saas-form-control border-primary pe-4"
                                       placeholder="Nhập tên danh mục đào tạo mới...">
                                <button type="button" class="btn btn-link btn-sm text-muted position-absolute end-0 top-50 translate-middle-y text-decoration-none p-1 me-1"
                                        onclick="cancelCustomCategory('courseCategoryCombobox', 'courseCustomCatDiv')" title="Hủy nhập danh mục mới">
                                    <i class="bi bi-x-lg"></i>
                                </button>
                            </div>
                        </div>

                    </div>

                    <div class="col-md-6">

                        <label class="saas-form-label">Học phí (VNĐ)</label>

                        <div class="input-group">

                            <input type="text" name="price" id="coursePriceInput" class="form-control saas-form-control font-monospace"

                                value="${course != null ? course.formattedPriceNumber : '0'}" 

                                placeholder="0" 

                                autocomplete="off"

                                oninput="formatPriceInputRealtime(this)">

                            <span class="input-group-text bg-light text-muted fw-semibold" style="border-color: #cbd5e1;">VNĐ</span>

                        </div>

                        

                    </div>

                </div>



                <!-- Description -->

                <div class="mb-4">

                    <label class="saas-form-label">Mô tả tóm tắt</label>

                    <textarea name="description" id="courseDescription" rows="3" class="form-control saas-form-control"

                        placeholder="Mô tả ngắn gọn về khóa học..."><c:out value="${course.description}" /></textarea>

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
                if (data.suggestedCategoryId) {
                    setComboboxValue('courseCategoryCombobox', data.suggestedCategoryId, data.suggestedCategoryName);
                }



                // 2. Tự động điền Mô tả tóm tắt do Gemini AI gợi ý

                const descTextarea = document.getElementById('courseDescription');

                if (descTextarea && data.suggestedDescription && (!descTextarea.value || descTextarea.value.trim() === '')) {

                    descTextarea.value = data.suggestedDescription;

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

function removeVietnameseDiacritics(str) {
    if (!str) return '';
    return str.normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .replace(/đ/g, "d").replace(/Đ/g, "D")
            .toLowerCase()
            .trim();
}

function initSearchableSelect(comboboxId, customDivId) {
    const box = document.getElementById(comboboxId);
    if (!box) return;

    const trigger = box.querySelector('.saas-combobox-trigger');
    const labelSpan = box.querySelector('.selected-text');
    const hiddenInput = box.querySelector('input[type="hidden"]');
    const searchInput = box.querySelector('.saas-combobox-search');
    const searchClear = box.querySelector('.saas-combobox-search-clear');
    const items = box.querySelectorAll('.saas-combobox-list .saas-combobox-item');
    const emptyBox = box.querySelector('.saas-combobox-empty');
    const addNewBtn = box.querySelector('.add-new-btn');
    const customDiv = document.getElementById(customDivId);
    const customInput = customDiv ? customDiv.querySelector('input') : null;

    function openDropdown() {
        document.querySelectorAll('.saas-combobox.open').forEach(cb => {
            if (cb !== box) cb.classList.remove('open');
        });
        box.classList.add('open');
        trigger.setAttribute('aria-expanded', 'true');
        if (searchInput) {
            searchInput.value = '';
            filterItems('');
            setTimeout(() => searchInput.focus(), 50);
        }
    }

    function closeDropdown() {
        box.classList.remove('open');
        trigger.setAttribute('aria-expanded', 'false');
    }

    trigger.addEventListener('click', function (e) {
        e.preventDefault();
        e.stopPropagation();
        if (box.classList.contains('open')) {
            closeDropdown();
        } else {
            openDropdown();
        }
    });

    document.addEventListener('click', function (e) {
        if (!box.contains(e.target)) {
            closeDropdown();
        }
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && box.classList.contains('open')) {
            closeDropdown();
            trigger.focus();
        }
    });

    function filterItems(query) {
        const cleanQuery = removeVietnameseDiacritics(query);
        let matchCount = 0;

        if (searchClear) {
            if (query.trim()) {
                searchClear.classList.remove('d-none');
            } else {
                searchClear.classList.add('d-none');
            }
        }

        items.forEach(it => {
            const label = it.getAttribute('data-label') || it.textContent;
            const cleanLabel = removeVietnameseDiacritics(label);
            if (!cleanQuery || cleanLabel.includes(cleanQuery)) {
                it.classList.remove('d-none');
                matchCount++;
            } else {
                it.classList.add('d-none');
            }
        });

        if (emptyBox) {
            if (matchCount === 0) {
                emptyBox.classList.remove('d-none');
            } else {
                emptyBox.classList.add('d-none');
            }
        }

        if (addNewBtn) {
            if (query.trim()) {
                addNewBtn.innerHTML = '<i class="bi bi-plus-circle text-primary me-2"></i> Thêm danh mục "' + escapeHtml(query.trim()) + '"...';
                addNewBtn.dataset.customText = query.trim();
            } else {
                addNewBtn.innerHTML = '<i class="bi bi-plus-circle text-primary me-2"></i> Nhập danh mục mới...';
                delete addNewBtn.dataset.customText;
            }
        }
    }

    if (searchInput) {
        searchInput.addEventListener('input', function () {
            filterItems(this.value);
        });
        searchInput.addEventListener('click', function (e) {
            e.stopPropagation();
        });
    }

    if (searchClear) {
        searchClear.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            searchInput.value = '';
            filterItems('');
            searchInput.focus();
        });
    }

    items.forEach(it => {
        it.addEventListener('click', function (e) {
            e.stopPropagation();
            const val = this.getAttribute('data-value');
            const label = this.getAttribute('data-label') || this.querySelector('.item-text').textContent;

            items.forEach(i => i.classList.remove('selected'));
            this.classList.add('selected');

            hiddenInput.value = val;
            labelSpan.textContent = label;

            if (customDiv) {
                customDiv.style.display = 'none';
                if (customInput) {
                    customInput.required = false;
                    customInput.value = '';
                }
            }

            closeDropdown();
            trigger.focus();
        });
    });

    if (addNewBtn) {
        addNewBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            hiddenInput.value = '__NEW__';
            const customVal = addNewBtn.dataset.customText || '';
            labelSpan.textContent = customVal ? ('Mới: ' + customVal) : '+ Danh mục mới';

            items.forEach(i => i.classList.remove('selected'));

            if (customDiv) {
                customDiv.style.display = 'block';
                if (customInput) {
                    customInput.required = true;
                    if (customVal) customInput.value = customVal;
                    setTimeout(() => customInput.focus(), 50);
                }
            }

            closeDropdown();
        });
    }

    if (customInput) {
        customInput.addEventListener('input', function () {
            if (this.value.trim()) {
                labelSpan.textContent = 'Mới: ' + this.value.trim();
            } else {
                labelSpan.textContent = '+ Danh mục mới';
            }
        });
    }
}

function setComboboxValue(comboboxId, value, fallbackName) {
    const box = document.getElementById(comboboxId);
    if (!box) return;

    const hiddenInput = box.querySelector('input[type="hidden"]');
    const labelSpan = box.querySelector('.selected-text');
    const items = box.querySelectorAll('.saas-combobox-list .saas-combobox-item');

    let matched = false;
    items.forEach(it => {
        if (it.getAttribute('data-value') == value) {
            it.classList.add('selected');
            labelSpan.textContent = it.getAttribute('data-label') || it.textContent.trim();
            hiddenInput.value = value;
            matched = true;
        } else {
            it.classList.remove('selected');
        }
    });

    if (!matched && fallbackName) {
        hiddenInput.value = value || '__NEW__';
        labelSpan.textContent = fallbackName;
    }
}

function cancelCustomCategory(comboboxId, customDivId) {
    const box = document.getElementById(comboboxId);
    const customDiv = document.getElementById(customDivId);
    if (customDiv) {
        customDiv.style.display = 'none';
        const inp = customDiv.querySelector('input');
        if (inp) {
            inp.required = false;
            inp.value = '';
        }
    }
    if (box) {
        const hiddenInput = box.querySelector('input[type="hidden"]');
        const labelSpan = box.querySelector('.selected-text');
        const firstItem = box.querySelector('.saas-combobox-list .saas-combobox-item');
        if (firstItem) {
            const val = firstItem.getAttribute('data-value');
            const label = firstItem.getAttribute('data-label') || firstItem.textContent.trim();
            setComboboxValue(comboboxId, val, label);
        } else {
            if (hiddenInput) hiddenInput.value = '';
            if (labelSpan) labelSpan.textContent = 'Chọn danh mục...';
        }
    }
}

function formatPriceInputRealtime(el) {
    if (!el) return;
    let raw = el.value.replace(/\D/g, '');
    if (!raw) {
        el.value = '';
        return;
    }
    raw = raw.replace(/^0+(?=\d)/, '');
    try {
        let num = BigInt(raw);
        el.value = num.toLocaleString('en-US');
    } catch (e) {
        el.value = raw;
    }
}

document.addEventListener('DOMContentLoaded', function () {
    initSearchableSelect('courseCategoryCombobox', 'courseCustomCatDiv');

    const form = document.getElementById('courseDetailForm');
    if (form) {
        form.addEventListener('submit', function (e) {
            const catId = document.getElementById('courseCategoryId') ? document.getElementById('courseCategoryId').value : '';
            const customInput = document.getElementById('courseCustomCatInput');
            if (!catId || catId.trim() === '') {
                e.preventDefault();
                alert('Vui lòng chọn hoặc thêm Danh mục đào tạo cho khóa học!');
                const trigger = document.querySelector('#courseCategoryCombobox .saas-combobox-trigger');
                if (trigger) trigger.focus();
                return;
            }
            if (catId === '__NEW__' && (!customInput || !customInput.value.trim())) {
                e.preventDefault();
                alert('Vui lòng nhập tên danh mục đào tạo mới!');
                if (customInput) customInput.focus();
                return;
            }
        });
    }
});
</script>

<jsp:include page="../common/footer.jsp" />

