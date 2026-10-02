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

                    <form action="${pageContext.request.contextPath}/expert/save-lesson" method="POST">
                        <input type="hidden" name="courseId" value="${course.id}">
                        <c:if test="${lesson != null}">
                            <input type="hidden" name="id" value="${lesson.id}">
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Thuộc Chương học (Module) <span class="text-danger">*</span></label>
                            <select name="moduleId" class="form-select" required>
                                <c:forEach var="m" items="${course.modules}">
                                    <option value="${m.id}" ${(m.id == selectedModuleId || (lesson != null && m.id == lesson.moduleId)) ? 'selected' : ''}>
                                        Chương ${m.orderIndex}: ${m.title}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-9">
                                <label class="form-label small fw-semibold">Tiêu đề bài học <span class="text-danger">*</span></label>
                                <input type="text" name="title" class="form-control" value="${lesson != null ? lesson.title : ''}" required placeholder="Ví dụ: Giới thiệu cú pháp Java cơ bản">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small fw-semibold">Thứ tự hiển thị</label>
                                <input type="number" name="orderIndex" class="form-control" value="${lesson != null ? lesson.orderIndex : 1}" required>
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
                            <input type="url" name="documentUrl" class="form-control" value="${lesson != null ? lesson.documentUrl : ''}" placeholder="https://drive.google.com/...">
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-semibold">Nội dung chi tiết bài học / Ghi chú lý thuyết</label>
                            <textarea name="content" rows="6" class="form-control" placeholder="Nhập nội dung bài học, hướng dẫn thực hành hoặc ghi chú quan trọng...">${lesson != null ? lesson.content : ''}</textarea>
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-light">Hủy bỏ</a>
                            <button type="submit" class="btn btn-primary fw-semibold px-4">
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

    // Auto-init preview on page load if video exists
    document.addEventListener('DOMContentLoaded', function() {
        const curVal = document.getElementById('lessonVideoUrl').value.trim();
        if (curVal) {
            updateVideoPreview();
            const id = extractYoutubeId(curVal);
            if (id) {
                setSelectedVideoId(id);
            }
        }
    });
</script>

<jsp:include page="../common/footer.jsp" />
