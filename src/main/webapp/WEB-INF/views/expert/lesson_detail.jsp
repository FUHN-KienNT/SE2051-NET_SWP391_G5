<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Soạn thảo bài học - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

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
                                ${lesson != null ? 'Chỉnh sửa bài học' : 'Thêm bài học mới (Lesson Editor)'}
                            </h4>
                            <p class="text-muted small mb-0">Nhập tiêu đề, tài liệu học tập và đường dẫn video bài giảng (Màn hình II.4.1)</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-outline-secondary btn-sm">
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

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Thuộc Chương học (Module) <span class="text-muted fw-normal">(Tùy chọn)</span></label>
                            <select name="moduleId" id="lessonModuleId" class="form-select">
                                <option value="" ${empty selectedModuleId && (lesson == null || empty lesson.moduleId) ? 'selected' : ''}>
                                    -- Bài học chung (Không chia chương) --
                                </option>
                                <c:forEach var="m" items="${course.modules}">
                                    <option value="${m.id}" ${(m.id == selectedModuleId || (lesson != null && m.id == lesson.moduleId)) ? 'selected' : ''}>
                                        <c:choose>
                                            <c:when test="${m.title eq 'Danh sách bài học' || m.title eq 'Bài học chung'}">
                                                ${m.title}
                                            </c:when>
                                            <c:otherwise>
                                                Chương ${m.orderIndex}: ${m.title}
                                            </c:otherwise>
                                        </c:choose>
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="form-text small text-muted">Nếu khóa học không chia theo từng chương, bạn có thể chọn "Bài học chung (Không chia chương)".</div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-9">
                                <label class="form-label small fw-semibold">Tiêu đề bài học <span class="text-danger">*</span></label>
                                <input type="text" name="title" id="lessonTitle" class="form-control" value="${lesson != null ? lesson.title : ''}" required placeholder="Ví dụ: Giới thiệu cú pháp Java cơ bản">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small fw-semibold">Thứ tự hiển thị</label>
                                <input type="number" name="orderIndex" id="lessonOrderIndex" class="form-control" value="${lesson != null ? lesson.orderIndex : 1}" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold d-flex justify-content-between align-items-center">
                                <span><i class="bi bi-youtube text-danger me-1"></i>URL Video bài giảng (YouTube Embed hoặc MP4)</span>
                                <button type="button" class="btn btn-outline-danger btn-sm py-0 px-2 fw-semibold" data-bs-toggle="modal" data-bs-target="#youtubePickerModal">
                                    <i class="bi bi-search me-1"></i>Mini YouTube Search &amp; Picker
                                </button>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-link-45deg"></i></span>
                                <input type="url" id="lessonVideoUrl" name="videoUrl" class="form-control" value="${lesson != null ? lesson.videoUrl : ''}" placeholder="https://www.youtube.com/embed/... hoặc https://www.youtube.com/watch?v=...">
                                <button class="btn btn-outline-secondary" type="button" id="btnPreviewVideo" onclick="updateVideoPreview()">
                                    <i class="bi bi-play-circle me-1"></i>Xem thử
                                </button>
                            </div>
                            <div class="form-text small">Bạn có thể dán link YouTube bất kỳ hoặc bấm nút <strong>Mini YouTube Search</strong> ở trên để tìm và chọn video nhanh.</div>
                            
                            <!-- Live Video Preview Box -->
                            <div id="videoPreviewContainer" class="mt-3 p-3 bg-light rounded-3 border ${not empty lesson.videoUrl ? '' : 'd-none'}">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="small fw-bold text-dark"><i class="bi bi-camera-video-fill text-danger me-1"></i>Video đang chọn:</span>
                                    <button type="button" class="btn btn-sm btn-link text-danger p-0 text-decoration-none" onclick="clearVideoUrl()">
                                        <i class="bi bi-x-circle me-1"></i>Xóa video
                                    </button>
                                </div>
                                <div class="ratio ratio-16x9 rounded overflow-hidden shadow-sm bg-black" style="max-height: 260px;">
                                    <iframe id="videoPreviewIframe" src="${lesson != null ? lesson.videoUrl : ''}" allowfullscreen></iframe>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold"><i class="bi bi-file-earmark-text text-info me-1"></i>URL Tài liệu đính kèm (Slide / PDF / Google Docs)</label>
                            <input type="url" name="documentUrl" id="lessonDocumentUrl" class="form-control" value="${lesson != null ? lesson.documentUrl : ''}" placeholder="https://drive.google.com/...">
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-semibold">Nội dung chi tiết bài học / Ghi chú lý thuyết</label>
                            <textarea name="content" id="lessonContent" rows="6" class="form-control" placeholder="Nhập nội dung bài học, hướng dẫn thực hành hoặc ghi chú quan trọng...">${lesson != null ? lesson.content : ''}</textarea>
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-3 border-top flex-wrap gap-2">
                            <div class="d-flex align-items-center gap-3">
                                <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-light btn-sm">
                                    <i class="bi bi-arrow-left me-1"></i>Hủy bỏ
                                </a>
                                <!-- Auto-Save 5-minute Status Badge -->
                                <div id="autoSaveIndicator" class="small text-muted d-inline-flex align-items-center">
                                    <span class="spinner-grow spinner-grow-sm text-success me-1" style="width: 7px; height: 7px;" role="status"></span>
                                    <span id="autoSaveStatusText">Tự động lưu nháp sau mỗi 5 phút</span>
                                </div>
                                <button type="button" class="btn btn-link btn-sm text-decoration-none p-0 text-primary small" onclick="manualSaveDraft()" title="Lưu nháp ngay vào bộ nhớ máy">
                                    <i class="bi bi-cloud-arrow-up me-1"></i>Lưu nháp ngay
                                </button>
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

<!-- Mini YouTube Search & Picker Modal -->
<div class="modal fade" id="youtubePickerModal" tabindex="-1" aria-labelledby="youtubePickerLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-header bg-dark text-white border-0 py-3">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-danger p-2"><i class="bi bi-youtube fs-5"></i></span>
                    <div>
                        <h5 class="modal-title fw-bold mb-0" id="youtubePickerLabel">Mini YouTube Search &amp; Video Picker</h5>
                        <small class="text-white-50">Tìm kiếm video trực tiếp từ YouTube và chèn vào bài học nhanh chóng</small>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <!-- Search Input Bar -->
                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Từ khóa tìm kiếm YouTube:</label>
                    <div class="input-group input-group-lg">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" id="ytSearchKeyword" class="form-control border-start-0" placeholder="Nhập tên bài học, chủ đề..." value="${course.title}">
                        <button class="btn btn-danger px-4 fw-semibold" type="button" onclick="performYoutubeSearch()">
                            <i class="bi bi-search me-1"></i>Tìm kiếm
                        </button>
                    </div>
                </div>

                <!-- Quick Suggestion Badges -->
                <div class="d-flex flex-wrap gap-2 mb-3 align-items-center">
                    <span class="small text-muted fw-semibold me-1"><i class="bi bi-lightbulb text-warning"></i> Gợi ý:</span>
                    <button type="button" class="badge bg-light text-dark border p-2 text-decoration-none btn-suggest" onclick="setSearchKeyword('${course.title}')">
                        ${course.title}
                    </button>
                    <button type="button" class="badge bg-light text-dark border p-2 text-decoration-none btn-suggest" onclick="setSearchKeyword('Nhân tướng học')">
                        Nhân tướng học
                    </button>
                    <button type="button" class="badge bg-light text-dark border p-2 text-decoration-none btn-suggest" onclick="setSearchKeyword('Tử vi')">
                        Tử vi
                    </button>
                    <button type="button" class="badge bg-light text-dark border p-2 text-decoration-none btn-suggest" onclick="setSearchKeyword('12 Cung Hoàng Đạo')">
                        12 Cung Hoàng Đạo
                    </button>
                </div>

                <div class="row g-3">
                    <!-- YouTube Interactive Embedded Player / Search Player -->
                    <div class="col-lg-8">
                        <div class="card border bg-black text-white h-100 overflow-hidden shadow-sm">
                            <div class="card-header bg-dark text-white-50 small py-2 d-flex justify-content-between align-items-center">
                                <span><i class="bi bi-play-btn me-1"></i>Trình xem trước YouTube</span>
                                <span id="ytPlayerStatus" class="badge bg-danger">Sẵn sàng</span>
                            </div>
                            <div class="ratio ratio-16x9 bg-black">
                                <iframe id="ytMiniPlayerFrame" src="https://www.youtube.com/embed?listType=search&list=${course.title}" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                            </div>
                        </div>
                    </div>

                    <!-- Direct Video Link / Selected Video Box -->
                    <div class="col-lg-4">
                        <div class="card border bg-light h-100 p-3 d-flex flex-column">
                            <h6 class="fw-bold mb-2 small text-dark"><i class="bi bi-check2-square text-success me-1"></i>Xác nhận Video được chọn</h6>
                            
                            <div class="mb-2">
                                <label class="small text-muted fw-semibold">Dán Link / Mã Video:</label>
                                <input type="text" id="ytDirectInput" class="form-control form-control-sm" placeholder="URL hoặc Video ID (vd: WVPVpNDKUwM)" oninput="handleDirectInput()">
                            </div>

                            <div id="ytSelectedPreview" class="text-center p-2 bg-white rounded border my-2 flex-grow-1 d-flex flex-column justify-content-center align-items-center">
                                <img id="ytSelectedThumb" src="https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=300" class="img-fluid rounded mb-2 shadow-sm" style="max-height: 90px; object-fit: cover;" alt="Preview">
                                <div id="ytSelectedIdText" class="small fw-semibold text-truncate w-100 text-dark">Chưa chọn video cụ thể</div>
                                <span class="badge bg-secondary-subtle text-secondary border mt-1" id="ytVideoTypeBadge">Tự động phát hiện</span>
                            </div>

                            <div class="mt-auto pt-2">
                                <button type="button" class="btn btn-success w-100 fw-bold py-2 shadow-sm" onclick="applySelectedYoutubeVideo()">
                                    <i class="bi bi-check-circle-fill me-1"></i>Dùng video này
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="alert alert-info py-2 px-3 small mt-3 mb-0 d-flex align-items-center gap-2">
                    <i class="bi bi-info-circle-fill fs-5 text-info"></i>
                    <div>
                        <strong>Mẹo:</strong> Bạn có thể tìm kiếm chủ đề trực tiếp trên thanh tìm kiếm hoặc dán bất kỳ link xem YouTube nào (vd: <code>youtube.com/watch?v=...</code>, <code>youtu.be/...</code>), hệ thống sẽ tự động chuẩn hóa sang định dạng chuẩn <code>embed</code> cho học viên.
                    </div>
                </div>
            </div>
            <div class="modal-footer bg-light py-2">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script>
    function extractYoutubeId(url) {
        if (!url) return null;
        url = url.trim();
        // Match 11 char ID directly
        if (/^[a-zA-Z0-9_-]{11}$/.test(url)) {
            return url;
        }
        // Match embed, watch?v=, youtu.be/, shorts/
        const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
        const match = url.match(regExp);
        return (match && match[2].length === 11) ? match[2] : null;
    }

    function setSearchKeyword(kw) {
        document.getElementById('ytSearchKeyword').value = kw;
        performYoutubeSearch();
    }

    function performYoutubeSearch() {
        const kw = document.getElementById('ytSearchKeyword').value.trim();
        if (!kw) return;
        
        // If user typed or pasted a full YouTube URL into search box, extract ID directly
        const possibleId = extractYoutubeId(kw);
        if (possibleId) {
            setSelectedVideoId(possibleId);
            return;
        }

        const encoded = encodeURIComponent(kw);
        const playerFrame = document.getElementById('ytMiniPlayerFrame');
        playerFrame.src = "https://www.youtube.com/embed?listType=search&list=" + encoded;
        document.getElementById('ytPlayerStatus').textContent = "Đang tìm kiếm...";
        document.getElementById('ytPlayerStatus').className = "badge bg-warning text-dark";
    }

    function handleDirectInput() {
        const val = document.getElementById('ytDirectInput').value.trim();
        const id = extractYoutubeId(val);
        if (id) {
            setSelectedVideoId(id);
        }
    }

    function setSelectedVideoId(id) {
        document.getElementById('ytDirectInput').value = id;
        document.getElementById('ytMiniPlayerFrame').src = "https://www.youtube.com/embed/" + id;
        document.getElementById('ytSelectedThumb').src = "https://img.youtube.com/vi/" + id + "/hqdefault.jpg";
        document.getElementById('ytSelectedIdText').textContent = "Video ID: " + id;
        document.getElementById('ytVideoTypeBadge').textContent = "Đã nhận diện chuẩn";
        document.getElementById('ytVideoTypeBadge').className = "badge bg-success-subtle text-success border";
        document.getElementById('ytPlayerStatus').textContent = "Đã tải: " + id;
        document.getElementById('ytPlayerStatus').className = "badge bg-success";
    }

    function applySelectedYoutubeVideo() {
        let val = document.getElementById('ytDirectInput').value.trim();
        let id = extractYoutubeId(val);
        
        if (!id) {
            const kw = document.getElementById('ytSearchKeyword').value.trim();
            id = extractYoutubeId(kw);
        }

        if (!id) {
            alert("Vui lòng nhập hoặc dán link / mã video YouTube hợp lệ trước khi áp dụng.");
            return;
        }

        const embedUrl = "https://www.youtube.com/embed/" + id;
        document.getElementById('lessonVideoUrl').value = embedUrl;
        updateVideoPreview();

        // Close modal
        const modalEl = document.getElementById('youtubePickerModal');
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) {
            modal.hide();
        }
    }

    function updateVideoPreview() {
        const inputVal = document.getElementById('lessonVideoUrl').value.trim();
        const container = document.getElementById('videoPreviewContainer');
        const iframe = document.getElementById('videoPreviewIframe');

        if (!inputVal) {
            container.classList.add('d-none');
            iframe.src = "";
            return;
        }

        const id = extractYoutubeId(inputVal);
        let finalUrl = inputVal;
        if (id) {
            finalUrl = "https://www.youtube.com/embed/" + id;
            document.getElementById('lessonVideoUrl').value = finalUrl;
        }

        iframe.src = finalUrl;
        container.classList.remove('d-none');
    }

    function clearVideoUrl() {
        document.getElementById('lessonVideoUrl').value = "";
        updateVideoPreview();
    }

    // =========================================================================
    // AUTO-SAVE DRAFT SYSTEM (TỰ ĐỘNG LƯU NHÁP MỖI 5 PHÚT)
    // =========================================================================
    const AUTO_SAVE_INTERVAL_MS = 5 * 60 * 1000; // 5 phút = 300,000ms
    const courseId = document.getElementById('lessonCourseId') ? document.getElementById('lessonCourseId').value : '${course.id}';
    const lessonIdEl = document.getElementById('lessonId');
    const lessonId = lessonIdEl ? lessonIdEl.value : 'new';
    const DRAFT_KEY = 'courson_draft_lesson_' + courseId + '_' + lessonId;

    let isSubmitting = false;
    let isSavingDraft = false;
    let initialFormData = null;
    let cachedDraft = null;

    function getFormData() {
        return {
            courseId: courseId,
            lessonId: lessonId,
            moduleId: document.getElementById('lessonModuleId') ? document.getElementById('lessonModuleId').value : '',
            title: document.getElementById('lessonTitle') ? document.getElementById('lessonTitle').value : '',
            orderIndex: document.getElementById('lessonOrderIndex') ? document.getElementById('lessonOrderIndex').value : '1',
            videoUrl: document.getElementById('lessonVideoUrl') ? document.getElementById('lessonVideoUrl').value : '',
            documentUrl: document.getElementById('lessonDocumentUrl') ? document.getElementById('lessonDocumentUrl').value : '',
            content: document.getElementById('lessonContent') ? document.getElementById('lessonContent').value : ''
        };
    }

    function isFormDirty() {
        if (!initialFormData) return false;
        const cur = getFormData();
        return cur.title !== initialFormData.title ||
               cur.moduleId !== initialFormData.moduleId ||
               cur.orderIndex !== initialFormData.orderIndex ||
               cur.videoUrl !== initialFormData.videoUrl ||
               cur.documentUrl !== initialFormData.documentUrl ||
               cur.content !== initialFormData.content;
    }

    function formatTime(d = new Date()) {
        const pad = (n) => String(n).padStart(2, '0');
        const hh = pad(d.getHours());
        const mm = pad(d.getMinutes());
        const ss = pad(d.getSeconds());
        const dd = pad(d.getDate());
        const mo = pad(d.getMonth() + 1);
        const yyyy = d.getFullYear();
        return hh + ':' + mm + ':' + ss + ' ' + dd + '/' + mo + '/' + yyyy;
    }

    function saveDraft(isManual = false) {
        if (isSubmitting || isSavingDraft) return;

        // Nếu là tự động theo chu kỳ 5 phút mà form không có gì thay đổi thì bỏ qua
        if (!isManual && !isFormDirty()) {
            return;
        }

        isSavingDraft = true;
        const nowStr = formatTime();
        const currentData = getFormData();
        currentData.savedAt = nowStr;

        const statusEl = document.getElementById('autoSaveStatusText');
        if (statusEl) {
            statusEl.textContent = isManual ? 'Đang lưu nháp...' : 'Đang tự động lưu nháp...';
        }

        // 1. Lưu ngay vào localStorage của trình duyệt
        try {
            localStorage.setItem(DRAFT_KEY, JSON.stringify(currentData));
        } catch (e) {
            console.warn('Lỗi lưu nháp localStorage:', e);
        }

        // 2. Gửi lưu backup lên Session server
        const params = new URLSearchParams();
        for (const key in currentData) {
            params.append(key, currentData[key]);
        }

        fetch('${pageContext.request.contextPath}/expert/save-lesson-draft', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            isSavingDraft = false;
            const timeDisplay = (data && data.savedAt) ? data.savedAt : nowStr;
            if (statusEl) {
                statusEl.innerHTML = '<span class="text-success"><i class="bi bi-check2 me-1"></i>Đã lưu nháp lúc ' + timeDisplay + '</span>';
            }
        })
        .catch(err => {
            isSavingDraft = false;
            if (statusEl) {
                statusEl.innerHTML = '<span class="text-success"><i class="bi bi-check2 me-1"></i>Đã lưu nháp máy khách lúc ' + nowStr + '</span>';
            }
        });
    }

    function manualSaveDraft() {
        saveDraft(true);
    }

    function hasMeaningfulDiff(draft, current) {
        if (!draft) return false;
        const hasData = (draft.title && draft.title.trim() !== '') ||
                        (draft.content && draft.content.trim() !== '') ||
                        (draft.videoUrl && draft.videoUrl.trim() !== '');
        if (!hasData) return false;

        return (draft.title || '') !== (current.title || '') ||
               (draft.content || '') !== (current.content || '') ||
               (draft.videoUrl || '') !== (current.videoUrl || '') ||
               (draft.documentUrl || '') !== (current.documentUrl || '') ||
               (draft.moduleId || '') !== (current.moduleId || '') ||
               (draft.orderIndex || '') !== (current.orderIndex || '');
    }

    function showRecoveryBanner(draft) {
        cachedDraft = draft;
        const container = document.getElementById('draftRecoveryAlertContainer');
        if (!container) return;

        const timeStr = draft.savedAt ? ' (lúc ' + draft.savedAt + ')' : '';
        container.innerHTML = 
            '<div class="alert alert-warning alert-dismissible fade show shadow-sm mb-4 border-warning border-start border-4 rounded-3" role="alert">' +
                '<div class="d-flex align-items-center justify-content-between flex-wrap gap-2">' +
                    '<div class="d-flex align-items-center gap-3">' +
                        '<i class="bi bi-clock-history fs-3 text-warning"></i>' +
                        '<div>' +
                            '<strong class="text-dark">Phát hiện bản nháp chưa lưu trước đó' + timeStr + '!</strong>' +
                            '<div class="small text-muted">Hệ thống đã tự động lưu trữ dữ liệu soạn thảo bài học của bạn. Bạn có muốn khôi phục không?</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="d-flex gap-2">' +
                        '<button type="button" class="btn btn-warning btn-sm fw-bold shadow-sm" onclick="restoreDraft()">' +
                            '<i class="bi bi-arrow-counterclockwise me-1"></i>Khôi phục bài' +
                        '</button>' +
                        '<button type="button" class="btn btn-outline-secondary btn-sm" onclick="dismissDraft()">' +
                            'Bỏ qua' +
                        '</button>' +
                    '</div>' +
                '</div>' +
            '</div>';
    }

    function restoreDraft() {
        if (!cachedDraft) return;

        if (cachedDraft.title !== undefined) {
            const el = document.getElementById('lessonTitle');
            if (el) el.value = cachedDraft.title;
        }
        if (cachedDraft.moduleId !== undefined) {
            const el = document.getElementById('lessonModuleId');
            if (el) el.value = cachedDraft.moduleId;
        }
        if (cachedDraft.orderIndex !== undefined) {
            const el = document.getElementById('lessonOrderIndex');
            if (el) el.value = cachedDraft.orderIndex;
        }
        if (cachedDraft.videoUrl !== undefined) {
            const el = document.getElementById('lessonVideoUrl');
            if (el) {
                el.value = cachedDraft.videoUrl;
                updateVideoPreview();
            }
        }
        if (cachedDraft.documentUrl !== undefined) {
            const el = document.getElementById('lessonDocumentUrl');
            if (el) el.value = cachedDraft.documentUrl;
        }
        if (cachedDraft.content !== undefined) {
            const el = document.getElementById('lessonContent');
            if (el) el.value = cachedDraft.content;
        }

        const container = document.getElementById('draftRecoveryAlertContainer');
        if (container) {
            container.innerHTML = 
                '<div class="alert alert-success alert-dismissible fade show shadow-sm mb-4 py-2 px-3 small rounded-3" role="alert">' +
                    '<i class="bi bi-check-circle-fill me-2"></i>Đã khôi phục thành công dữ liệu từ bản nháp ' + (cachedDraft.savedAt ? '(' + cachedDraft.savedAt + ')' : '') + '.' +
                    '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                '</div>';
        }

        const statusEl = document.getElementById('autoSaveStatusText');
        if (statusEl) {
            statusEl.innerHTML = '<span class="text-success"><i class="bi bi-arrow-counterclockwise me-1"></i>Đã khôi phục bản nháp</span>';
        }
    }

    function dismissDraft() {
        const container = document.getElementById('draftRecoveryAlertContainer');
        if (container) {
            container.innerHTML = '';
        }
        try {
            localStorage.removeItem(DRAFT_KEY);
        } catch (e) {}
    }

    function checkExistingDraft() {
        // 1. Kiểm tra localStorage máy khách
        let localDraft = null;
        try {
            const raw = localStorage.getItem(DRAFT_KEY);
            if (raw) {
                localDraft = JSON.parse(raw);
            }
        } catch (e) {}

        if (localDraft && hasMeaningfulDiff(localDraft, initialFormData)) {
            showRecoveryBanner(localDraft);
            return;
        }

        // 2. Dự phòng: Kiểm tra Session máy chủ
        fetch('${pageContext.request.contextPath}/expert/get-lesson-draft?courseId=' + encodeURIComponent(courseId) + '&lessonId=' + encodeURIComponent(lessonId))
            .then(res => res.json())
            .then(data => {
                if (data && data.exists && hasMeaningfulDiff(data, initialFormData)) {
                    showRecoveryBanner(data);
                }
            })
            .catch(err => {
                // Ignore fetch error
            });
    }

    // Khởi tạo các sự kiện khi DOM sẵn sàng
    document.addEventListener('DOMContentLoaded', function() {
        initialFormData = getFormData();

        // Khởi tạo video preview nếu đã có URL
        const curVal = document.getElementById('lessonVideoUrl') ? document.getElementById('lessonVideoUrl').value.trim() : '';
        if (curVal) {
            updateVideoPreview();
            const id = extractYoutubeId(curVal);
            if (id) {
                setSelectedVideoId(id);
            }
        }

        // Kiểm tra xem có bản nháp chưa lưu không
        checkExistingDraft();

        // Kích hoạt bộ định thời tự động lưu sau mỗi 5 phút (300,000 ms)
        setInterval(function() {
            saveDraft(false);
        }, AUTO_SAVE_INTERVAL_MS);

        // Bắt sự kiện nộp biểu mẫu: dọn dẹp nháp
        const formEl = document.getElementById('lessonForm');
        if (formEl) {
            formEl.addEventListener('submit', function() {
                isSubmitting = true;
                try {
                    localStorage.removeItem(DRAFT_KEY);
                } catch (e) {}
            });
        }

        // Cảnh báo khi người dùng tắt tab/rời trang khi chưa lưu và cố gắng bảo toàn nháp
        window.addEventListener('beforeunload', function(e) {
            if (isSubmitting) return;
            if (isFormDirty()) {
                const cur = getFormData();
                cur.savedAt = formatTime();
                try {
                    localStorage.setItem(DRAFT_KEY, JSON.stringify(cur));
                } catch (err) {}

                if (navigator.sendBeacon) {
                    const params = new URLSearchParams();
                    for (const key in cur) {
                        params.append(key, cur[key]);
                    }
                    navigator.sendBeacon('${pageContext.request.contextPath}/expert/save-lesson-draft', params);
                }

                e.preventDefault();
                e.returnValue = 'Bạn có thay đổi chưa lưu. Dữ liệu đã được tự động bảo toàn.';
                return e.returnValue;
            }
        });
    });
</script>

<jsp:include page="../common/footer.jsp" />
