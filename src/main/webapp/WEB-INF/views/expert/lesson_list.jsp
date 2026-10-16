<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản lý bài học - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Breadcrumb -->
        <nav class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/expert/dashboard">Expert Dashboard</a></li>
                <li class="breadcrumb-item active">${course.title}</li>
                <li class="breadcrumb-item active">Danh sách Bài học (Lesson List)</li>
            </ol>
        </nav>

        <c:set var="displaySuccess" value="${not empty successMessage ? successMessage : param.success}" />
        <c:if test="${not empty displaySuccess}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:choose>
                    <c:when test="${displaySuccess == 'batch_saved'}">
                        Đã nhập và khởi tạo thành công <strong><c:out value="${not empty param.count ? param.count : 'toàn bộ'}" /> bài học</strong> từ danh sách video YouTube!
                    </c:when>
                    <c:when test="${displaySuccess == 'created'}">
                        Đã tạo khóa học thành công!
                    </c:when>
                    <c:when test="${displaySuccess == 'true'}">
                        Đã lưu thông tin bài học thành công!
                    </c:when>
                    <c:otherwise>
                        <c:out value="${displaySuccess}" escapeXml="true" />
                    </c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:set var="displayError" value="${not empty errorMessage ? errorMessage : param.error}" />
        <c:if test="${not empty displayError}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${displayError}" escapeXml="true" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <h3 class="fw-bold mb-0"><i class="bi bi-journal-bookmark me-2"></i>Chương trình học: ${course.title}</h3>
                    <c:choose>
                        <c:when test="${course.status == 'PUBLISHED'}">
                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                <i class="bi bi-check-circle-fill me-1"></i>Đã công khai
                            </span>
                        </c:when>
                        <c:when test="${course.status == 'PENDING_REVIEW'}">
                            <span class="badge bg-warning-subtle text-warning-emphasis border border-warning px-2 py-1">
                                <i class="bi bi-hourglass-split me-1"></i>Đang chờ Admin duyệt
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary-subtle text-secondary border px-2 py-1">
                                <i class="bi bi-pencil-square me-1"></i>Bản nháp (DRAFT)
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <p class="text-muted small mb-0">Quản lý các chương học (Modules) và các bài giảng (Lessons) - Màn hình II.4.1</p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <c:choose>
                    <c:when test="${course.status == 'DRAFT'}">
                        <a href="${pageContext.request.contextPath}/expert/request-publish?courseId=${course.id}&from=lessons"
                           class="btn btn-success fw-semibold shadow-sm"
                           onclick="return confirm('Bạn có chắc chắn muốn gửi duyệt xuất bản khóa học &quot;${course.title}&quot; để Ban Quản Trị duyệt?');">
                            <i class="bi bi-send-check me-1"></i>Gửi duyệt xuất bản
                        </a>
                    </c:when>
                    <c:when test="${course.status == 'PENDING_REVIEW'}">
                        <a href="${pageContext.request.contextPath}/expert/cancel-request-publish?courseId=${course.id}&from=lessons"
                           class="btn btn-outline-warning fw-semibold shadow-sm"
                           onclick="return confirm('Bạn muốn thu hồi yêu cầu duyệt để tiếp tục chỉnh sửa khóa học &quot;${course.title}&quot;?');">
                            <i class="bi bi-arrow-counterclockwise me-1"></i>Thu hồi yêu cầu
                        </a>
                    </c:when>
                </c:choose>
                <button type="button" class="btn btn-danger fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#batchImportLessonsModal">
                    <i class="bi bi-youtube me-1"></i>Nhập Playlist / Hàng loạt Video
                </button>
                <button type="button" class="btn btn-outline-primary fw-semibold" data-bs-toggle="modal" data-bs-target="#newModuleModal">
                    <i class="bi bi-folder-plus me-1"></i>Thêm Chương mới
                </button>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty course.modules}">
                <div class="card p-5 text-center border-0 shadow-sm rounded-3">
                    <i class="bi bi-folder2-open fs-1 text-muted mb-3"></i>
                    <h5>Khóa học này chưa có chương học nào!</h5>
                    <p class="text-muted small">Hãy bấm nút <strong>"Nhập Playlist / Hàng loạt Video"</strong> để tạo nhanh toàn bộ bài học, hoặc bấm "Thêm Chương mới".</p>
                    <div class="d-flex justify-content-center gap-2 mt-2">
                        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#batchImportLessonsModal">
                            <i class="bi bi-youtube me-1"></i>Nhập hàng loạt video YouTube
                        </button>
                        <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#newModuleModal">
                            <i class="bi bi-folder-plus me-1"></i>Thêm Chương thủ công
                        </button>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach var="m" items="${course.modules}">
                        <div class="col-12">
                            <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                                <div class="card-header bg-light py-3 d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-primary">Chương ${m.orderIndex}</span>
                                        <h5 class="fw-bold mb-0">${m.title}</h5>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/expert/lesson-detail?courseId=${course.id}&moduleId=${m.id}" class="btn btn-sm btn-primary">
                                            <i class="bi bi-plus-lg me-1"></i>Thêm Bài học
                                        </a>
                                        <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#batchImportLessonsModal" onclick="selectBatchModule('${m.id}')">
                                            <i class="bi bi-youtube me-1"></i>Nhập loạt video vào chương này
                                        </button>
                                        <a href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}#module-${m.id}" class="btn btn-sm btn-outline-warning">
                                            <i class="bi bi-patch-question me-1"></i>Quản lý Quiz
                                        </a>
                                        <button type="button" class="btn btn-sm btn-outline-secondary"
                                                data-id="${m.id}"
                                                data-title="<c:out value="${m.title}" />"
                                                data-order="${m.orderIndex}"
                                                onclick="openEditModuleModal(this)" title="Sửa tên chương">
                                            <i class="bi bi-pencil me-1"></i>Sửa tên chương
                                        </button>
                                        <a href="${pageContext.request.contextPath}/expert/delete-module?courseId=${course.id}&moduleId=${m.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa chương &quot;<c:out value="${m.title}" />&quot; và tất cả bài học bên trong không?');" title="Xóa chương này">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </div>
                                </div>
                                <div class="card-body p-0">
                                    <c:choose>
                                        <c:when test="${empty m.lessons}">
                                            <div class="p-4 text-center text-muted small">Chưa có bài học nào trong chương này.</div>
                                        </c:when>
                                        <c:otherwise>
                                            <ul class="list-group list-group-flush">
                                                <c:forEach var="l" items="${m.lessons}">
                                                    <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <img src="${l.thumbnailUrl}" class="rounded shadow-sm flex-shrink-0" style="width: 60px; height: 36px; object-fit: cover;" alt="${l.title}"
                                                                 onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                                            <div>
                                                                <span class="badge bg-light text-dark border me-1">Bài ${l.orderIndex}</span>
                                                                <strong class="text-dark">${l.title}</strong>
                                                                <div class="small text-muted mt-1">
                                                                    <c:if test="${not empty l.videoUrl}">
                                                                        <span class="badge bg-danger-subtle text-danger border me-1"><i class="bi bi-youtube me-1"></i>Video</span>
                                                                    </c:if>
                                                                    <c:if test="${not empty l.documentUrl}">
                                                                        <span class="badge bg-info-subtle text-info border"><i class="bi bi-file-earmark me-1"></i>Tài liệu</span>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <a href="${pageContext.request.contextPath}/expert/lesson-detail?courseId=${course.id}&moduleId=${m.id}&lessonId=${l.id}" class="btn btn-sm btn-outline-primary me-1">
                                                                <i class="bi bi-pencil"></i> Sửa bài
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/expert/delete-lesson?courseId=${course.id}&lessonId=${l.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có chắc muốn xóa bài học này?');">
                                                                <i class="bi bi-trash"></i>
                                                            </a>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- Modal Batch Import Lessons from YouTube Playlist / Multiple URLs -->
<div class="modal fade" id="batchImportLessonsModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <form action="${pageContext.request.contextPath}/expert/batch-save-lessons" method="POST">
                <input type="hidden" name="courseId" value="${course.id}">
                <div class="modal-header bg-danger text-white border-0 py-3">
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-white text-danger p-2"><i class="bi bi-youtube fs-5"></i></span>
                        <div>
                            <h5 class="modal-title fw-bold mb-0">Nhập hàng loạt Video / Playlist YouTube</h5>
                            <small class="text-white-50">Tạo nhiều bài giảng cùng lúc chỉ bằng cách dán danh sách link</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Thêm vào Chương học:</label>
                        <select name="moduleId" id="batchTargetModule" class="form-select" onchange="toggleBatchModuleChoice(this)">
                            <c:forEach var="m" items="${course.modules}">
                                <option value="${m.id}">Chương ${m.orderIndex}: ${m.title}</option>
                            </c:forEach>
                            <option value="__NEW__" ${empty course.modules ? 'selected' : ''}>+ Tạo Chương học mới...</option>
                        </select>
                        <div id="batchNewModuleInputDiv" class="mt-2 ${empty course.modules ? '' : 'd-none'}">
                            <label class="form-label small fw-semibold text-primary">Tên chương học mới <span class="text-danger">*</span></label>
                            <input type="text" name="newModuleTitle" id="batchNewModuleTitle" class="form-control form-control-sm border-primary" placeholder="Ví dụ: Chương 1: Giới thiệu khóa học..." ${empty course.modules ? 'required' : ''}>
                            <div class="form-text small text-muted">Vui lòng nhập tên chương học thay vì để hệ thống tự động đặt tên.</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <label class="form-label small fw-semibold mb-0">Danh sách liên kết YouTube (Mỗi dòng một video hoặc kèm tiêu đề):</label>
                            <button type="button" class="btn btn-link btn-sm text-decoration-none p-0" onclick="insertBatchSample()">
                                <i class="bi bi-file-text me-1"></i>Chèn danh sách mẫu
                            </button>
                        </div>
                        <textarea name="batchText" id="batchInputText" rows="6" class="form-control font-monospace small" placeholder="Dán danh sách các link video YouTube ở đây (mỗi dòng 1 link). Ví dụ:&#10;https://www.youtube.com/watch?v=WVPVpNDKUwM - Buổi 1: Giới thiệu căn bản&#10;https://www.youtube.com/watch?v=gJS-1C78Jy0 - Buổi 2: Hướng dẫn chi tiết&#10;https://youtu.be/SMaG-tqSzFM - Buổi 3: Thực hành và đúc kết" oninput="previewBatchVideos()"></textarea>
                    </div>

                    <!-- Live Parsed Video List Preview -->
                    <div id="batchPreviewBox" class="border rounded-3 p-3 bg-light d-none">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <strong class="small text-dark"><i class="bi bi-check2-circle text-success me-1"></i>Đã nhận diện: <span id="batchCountBadge" class="badge bg-success">0 video</span></strong>
                            <small class="text-muted">Các bài học sẽ được tạo tuần tự với link chuẩn Embed</small>
                        </div>
                        <div class="table-responsive" style="max-height: 200px; overflow-y: auto;">
                            <table class="table table-sm table-bordered bg-white mb-0 align-middle">
                                <thead class="table-light small">
                                    <tr>
                                        <th style="width: 40px;">#</th>
                                        <th style="width: 80px;">Thumbnail</th>
                                        <th>Tiêu đề bài học nhận diện</th>
                                        <th style="width: 130px;">Video ID</th>
                                    </tr>
                                </thead>
                                <tbody id="batchPreviewTableBody" class="small"></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 py-3">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger fw-semibold px-4">
                        <i class="bi bi-cloud-arrow-up-fill me-1"></i>Tạo toàn bộ bài học
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Add Module -->
<div class="modal fade" id="newModuleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/expert/save-module" method="POST">
                <input type="hidden" name="courseId" value="${course.id}">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Thêm Chương học mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên chương <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required placeholder="Ví dụ: Giới thiệu căn bản...">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Thứ tự chương</label>
                        <input type="number" name="orderIndex" class="form-control" value="${course.modules.size() + 1}" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold">Lưu chương</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Edit Module -->
<div class="modal fade" id="editModuleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow rounded-4 overflow-hidden">
            <form action="${pageContext.request.contextPath}/expert/save-module" method="POST">
                <input type="hidden" name="courseId" value="${course.id}">
                <input type="hidden" name="id" id="editModuleId">
                <div class="modal-header bg-light py-3">
                    <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square me-2 text-primary"></i>Chỉnh sửa Chương học</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên chương <span class="text-danger">*</span></label>
                        <input type="text" name="title" id="editModuleTitle" class="form-control" required placeholder="Nhập tên chương học...">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Thứ tự chương</label>
                        <input type="number" name="orderIndex" id="editModuleOrder" class="form-control" required min="1">
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 py-3">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold px-4"><i class="bi bi-check2 me-1"></i>Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openEditModuleModal(arg1, arg2, arg3) {
        let id, title, order;
        if (typeof arg1 === 'object' && arg1 !== null) {
            id = arg1.getAttribute('data-id');
            title = arg1.getAttribute('data-title');
            order = arg1.getAttribute('data-order');
        } else {
            id = arg1;
            title = arg2;
            order = arg3;
        }
        document.getElementById('editModuleId').value = id || '';
        document.getElementById('editModuleTitle').value = title || '';
        document.getElementById('editModuleOrder').value = order || '1';
        const modal = new bootstrap.Modal(document.getElementById('editModuleModal'));
        modal.show();
    }

    function toggleBatchModuleChoice(sel) {
        const div = document.getElementById('batchNewModuleInputDiv');
        const inp = document.getElementById('batchNewModuleTitle');
        if (!div || !inp) return;
        if (sel.value === '__NEW__') {
            div.classList.remove('d-none');
            inp.required = true;
            inp.focus();
        } else {
            div.classList.add('d-none');
            inp.required = false;
            inp.value = '';
        }
    }

    function selectBatchModule(modId) {
        const sel = document.getElementById('batchTargetModule');
        if (sel) {
            sel.value = modId;
            toggleBatchModuleChoice(sel);
        }
    }

    function insertBatchSample() {
        const sample = "https://www.youtube.com/watch?v=WVPVpNDKUwM - Bài 1: Tổng quan và Phương pháp học tập\n" +
                       "https://www.youtube.com/watch?v=gJS-1C78Jy0 - Bài 2: Phân tích chi tiết và Cấu trúc cốt lõi\n" +
                       "https://www.youtube.com/watch?v=SMaG-tqSzFM - Bài 3: Thực hành và Bài tập áp dụng thực tế";
        document.getElementById('batchInputText').value = sample;
        previewBatchVideos();
    }

    function extractYtId(str) {
        if (!str) return null;
        const reg = /(?:youtu\.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([a-zA-Z0-9_-]{11})|^([a-zA-Z0-9_-]{11})$/;
        const m = str.match(reg);
        return m ? (m[1] || m[2]) : null;
    }

    // =========================================================================
    // [TÍNH NĂNG] XEM TRƯỚC BÀI HỌC TỪ YOUTUBE PLAYLIST & DANH SÁCH VIDEO
    // Tag tìm kiếm: #YOUTUBE_PLAYLIST_IMPORT #BATCH_PREVIEW
    // =========================================================================
    let previewTimer = null;

    function renderLocalPreview(text, box, tbody, countBadge) {
        const lines = text.split('\n');
        let count = 0;
        let html = '';

        lines.forEach(function(line, idx) {
            line = line.trim();
            if (!line) return;

            let videoId = null;
            const words = line.split(/\s+/);
            for (let i = 0; i < words.length; i++) {
                const id = extractYtId(words[i]);
                if (id) {
                    videoId = id;
                    break;
                }
            }

            if (videoId) {
                count++;
                let title = line.replace(/https?:\/\/[^\s]+/g, '')
                                .replace(/^[0-9]+[\.\:\-]\s*/, '')
                                .replace(/^[\-\–\—\|\:\.]+\s*/, '')
                                .replace(/\s*[\-\–\—\|\:]+$/, '')
                                .trim();
                if (!title || title.length < 2) {
                    title = "Bài " + count + ": Video bài giảng";
                }

                html += '<tr>' +
                    '<td>' + count + '</td>' +
                    '<td><img src="https://img.youtube.com/vi/' + videoId + '/hqdefault.jpg" class="rounded" style="width: 50px; height: 30px; object-fit: cover;"></td>' +
                    '<td class="fw-semibold text-dark">' + title + '</td>' +
                    '<td><code>' + videoId + '</code></td>' +
                '</tr>';
            }
        });

        if (count > 0) {
            tbody.innerHTML = html;
            countBadge.className = 'badge bg-success';
            countBadge.textContent = count + " video";
            box.classList.remove('d-none');
        } else {
            box.classList.add('d-none');
            tbody.innerHTML = '';
        }
    }

    function previewBatchVideos() {
        const text = document.getElementById('batchInputText').value;
        const box = document.getElementById('batchPreviewBox');
        const tbody = document.getElementById('batchPreviewTableBody');
        const countBadge = document.getElementById('batchCountBadge');

        if (!text || !text.trim()) {
            box.classList.add('d-none');
            tbody.innerHTML = '';
            return;
        }

        clearTimeout(previewTimer);

        // Nếu phát hiện có chứa tham số danh sách phát (Playlist: 'list=' hoặc 'playlist?')
        if (/[?&]list=|playlist\?list=|PL[a-zA-Z0-9_-]{16,}/.test(text)) {
            box.classList.remove('d-none');
            countBadge.className = 'badge bg-warning text-dark';
            countBadge.innerHTML = '<span class="spinner-border spinner-border-sm me-1" style="width: 10px; height: 10px;"></span>Đang tải Playlist...';
            tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-3">' +
                '<div class="spinner-border spinner-border-sm text-danger me-2" role="status"></div>' +
                'Đang tự động bóc tách toàn bộ danh sách bài học từ Playlist YouTube... Vui lòng chờ vài giây.' +
                '</td></tr>';

            previewTimer = setTimeout(function() {
                const params = new URLSearchParams();
                params.append('batchText', text);
                fetch('${pageContext.request.contextPath}/expert/preview-batch-videos', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                })
                .then(r => r.json())
                .then(data => {
                    if (data && data.length > 0) {
                        let html = '';
                        data.forEach((item, idx) => {
                            html += '<tr>' +
                                '<td>' + (idx + 1) + '</td>' +
                                '<td><img src="https://img.youtube.com/vi/' + item.videoId + '/hqdefault.jpg" class="rounded" style="width: 50px; height: 30px; object-fit: cover;"></td>' +
                                '<td class="fw-semibold text-dark">' + item.title + '</td>' +
                                '<td><code>' + item.videoId + '</code></td>' +
                            '</tr>';
                        });
                        tbody.innerHTML = html;
                        countBadge.className = 'badge bg-success';
                        countBadge.textContent = data.length + " video (Playlist)";
                    } else {
                        renderLocalPreview(text, box, tbody, countBadge);
                    }
                })
                .catch(err => {
                    renderLocalPreview(text, box, tbody, countBadge);
                });
            }, 600);
            return;
        }

        renderLocalPreview(text, box, tbody, countBadge);
    }
</script>

<jsp:include page="../common/footer.jsp" />
