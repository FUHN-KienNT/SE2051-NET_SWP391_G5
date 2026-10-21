<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Không gian học tập - ${course.title}" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<!-- Quill WYSIWYG Editor Styles -->
<link href="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.snow.css" rel="stylesheet">

<style>
    html, body {
        height: 100vh;
        height: 100dvh;
        overflow: hidden !important;
        margin: 0;
        padding: 0;
        background-color: #f8fafc;
    }
    .cf-footer {
        display: none !important;
    }
    .learning-wrapper {
        height: calc(100vh - 64px);
        height: calc(100dvh - 64px);
        max-height: calc(100vh - 64px);
        display: flex;
        flex-direction: column;
        background-color: #f8fafc;
        overflow: hidden;
    }
    .learning-topbar {
        background: #ffffff;
        border-bottom: 1px solid #e2e8f0;
        padding: 0.5rem 1.25rem;
        z-index: 1020;
        flex-shrink: 0;
        height: 50px;
    }
    .learning-main-container {
        display: flex;
        flex: 1;
        overflow: hidden;
        position: relative;
        height: calc(100% - 50px);
    }
    #sidebarWrapper {
        width: 300px;
        min-width: 300px;
        max-width: 300px;
        height: 100%;
        background: #ffffff;
        border-right: 1px solid #e2e8f0;
        display: flex;
        flex-direction: column;
        transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.25s ease;
        z-index: 100;
        overflow: hidden;
    }
    #sidebarWrapper.collapsed {
        margin-left: -300px;
        opacity: 0;
        pointer-events: none;
        visibility: hidden;
    }
    .learning-content-scroll {
        flex: 1;
        height: 100%;
        overflow-y: auto;
        padding: 1rem 1.25rem;
        background-color: #f8fafc;
    }
    @media (max-width: 991.98px) {
        #sidebarWrapper {
            position: absolute;
            top: 0;
            bottom: 0;
            left: 0;
            box-shadow: 4px 0 15px rgba(0,0,0,0.1);
        }
    }
    /* Note editor customized styling */
    .note-card {
        display: flex;
        flex-direction: column;
        border: 1px solid #e2e8f0;
        border-radius: 10px;
        background: #ffffff;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    }
    .note-card .ql-toolbar.ql-snow {
        border-top-left-radius: 9px;
        border-top-right-radius: 9px;
        border-color: #e2e8f0;
        background: #f8fafc;
        padding: 5px 8px;
    }
    .note-card .ql-container.ql-snow {
        border-bottom-left-radius: 9px;
        border-bottom-right-radius: 9px;
        border-color: #e2e8f0;
        font-family: inherit;
        font-size: 14px;
        line-height: 1.55;
    }
    .note-card .ql-editor {
        height: 310px;
        min-height: 240px;
        max-height: 380px;
        overflow-y: auto;
    }
    .markdown-body {
        font-size: 14.5px;
        line-height: 1.65;
        color: #334155;
    }
    .markdown-body h1, .markdown-body h2, .markdown-body h3 {
        margin-top: 1rem;
        margin-bottom: 0.5rem;
        font-weight: 600;
        color: #0f172a;
    }
    .markdown-body h1 { font-size: 1.35rem; border-bottom: 1px solid #e2e8f0; padding-bottom: 0.25rem; }
    .markdown-body h2 { font-size: 1.2rem; }
    .markdown-body h3 { font-size: 1.05rem; }
    .markdown-body code {
        background-color: #f1f5f9;
        color: #e11d48;
        padding: 0.15rem 0.35rem;
        border-radius: 4px;
        font-size: 90%;
    }
    .markdown-body pre {
        background-color: #1e293b;
        color: #f8fafc;
        padding: 0.75rem 1rem;
        border-radius: 6px;
        overflow-x: auto;
    }
    .markdown-body pre code {
        background-color: transparent;
        color: inherit;
        padding: 0;
    }
    .btn-toggle-box {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 3px;
        width: 36px;
        height: 36px;
        min-width: 36px;
        padding: 0;
        border: 1.5px solid #cbd5e1;
        border-radius: 6px;
        background-color: #ffffff;
        cursor: pointer;
        transition: all 0.15s ease-in-out;
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    }
    .btn-toggle-box:hover {
        background-color: #f1f5f9;
        border-color: #94a3b8;
    }
    .btn-toggle-box:active {
        transform: scale(0.95);
    }
    .btn-toggle-box .toggle-bar {
        display: inline-block;
        width: 2.5px;
        height: 16px;
        background-color: #334155;
        border-radius: 2px;
        transition: background-color 0.15s ease;
    }
    .btn-toggle-box:hover .toggle-bar {
        background-color: #0f172a;
    }
</style>

<div class="learning-wrapper">
    <!-- Top Learning Toolbar -->
    <div class="learning-topbar d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div class="d-flex align-items-center gap-3">
            <!-- [|||] Boxed 3-Bars Sidebar Toggle Button -->
            <button type="button" class="btn-toggle-box" id="btnToggleSidebar" title="Đóng / Mở danh mục bài học" aria-label="Đóng mở danh sách bài học">
                <span class="toggle-bar"></span>
                <span class="toggle-bar"></span>
                <span class="toggle-bar"></span>
            </button>

            <!-- Breadcrumb Navigation -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0 small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/registrations/my-courses" class="text-decoration-none text-muted">Khóa học của tôi</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/courses/detail?id=${course.id}" class="text-decoration-none text-muted text-truncate" style="max-width: 200px;" title="${course.title}">${course.title}</a></li>
                </ol>
            </nav>
        </div>

        <div class="d-flex align-items-center gap-2">
            <c:if test="${course.archived}">
                <span class="badge bg-secondary-subtle text-secondary border px-2 py-1">
                    <i class="bi bi-archive me-1"></i>Đã lưu trữ
                </span>
            </c:if>
            <span class="badge bg-primary-subtle text-primary border px-2 py-1">
                <i class="bi bi-collection-play me-1"></i>${course.totalLessons} bài học
            </span>
            <a href="${pageContext.request.contextPath}/courses/detail?id=${course.id}" class="btn btn-outline-secondary btn-sm rounded-2">
                <i class="bi bi-info-circle me-1"></i>Thông tin khóa
            </a>
        </div>
    </div>

    <!-- Active Lesson Lookup Logic -->
    <c:set var="activeLesson" value="${null}" />
    <c:set var="activeModuleName" value="" />
    <c:set var="prevLessonId" value="${null}" />
    <c:set var="nextLessonId" value="${null}" />
    <c:set var="foundCurrent" value="false" />
    <c:set var="lastLessonId" value="${null}" />

    <c:forEach var="m" items="${course.modules}">
        <c:forEach var="l" items="${m.lessons}">
            <c:if test="${l.active or l.id == currentLessonId}">
                <c:choose>
                    <c:when test="${l.id == currentLessonId}">
                        <c:set var="activeLesson" value="${l}" />
                        <c:set var="activeModuleName" value="${m.title}" />
                        <c:set var="prevLessonId" value="${lastLessonId}" />
                        <c:set var="foundCurrent" value="true" />
                    </c:when>
                    <c:when test="${foundCurrent == true && nextLessonId == null}">
                        <c:set var="nextLessonId" value="${l.id}" />
                    </c:when>
                </c:choose>
                <c:set var="lastLessonId" value="${l.id}" />
            </c:if>
        </c:forEach>
    </c:forEach>

    <!-- Main Workspace with 3 Sections -->
    <div class="learning-main-container">
        <!-- 1. LEFT SIDEBAR: Collapsible Course & Lesson List -->
        <aside id="sidebarWrapper" class="p-3">
            <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                <h6 class="fw-bold mb-0 text-truncate text-dark" title="${course.title}">
                    <i class="bi bi-journal-bookmark text-primary me-1"></i>${course.title}
                </h6>
                <button type="button" class="btn btn-sm btn-link text-muted p-0 d-lg-none" id="btnCloseSidebarMobile" title="Đóng danh mục">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>

            <!-- Quick search filter in lesson list -->
            <div class="mb-3">
                <div class="input-group input-group-sm">
                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                    <input type="text" id="learnLessonFilter" class="form-control bg-light border-start-0" placeholder="Tìm kiếm bài học..." onkeyup="filterLearningLessons()">
                </div>
            </div>

            <!-- Scrollable Lesson List -->
            <div class="overflow-y-auto flex-grow-1" id="learnLessonListContainer">
                <c:set var="lessonSeq" value="1" />
                <div class="list-group list-group-flush small" id="learnLessonList">
                    <c:forEach var="m" items="${course.modules}">
                        <div class="py-1 px-2 fw-semibold text-secondary text-uppercase" style="font-size: 11px; letter-spacing: 0.5px;">
                            ${m.title}
                        </div>
                        <c:forEach var="l" items="${m.lessons}">
                            <c:if test="${l.active or l.id == currentLessonId}">
                                <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registrationId}&lessonId=${l.id}"
                                   class="list-group-item list-group-item-action d-flex align-items-center gap-2 py-2 px-2 rounded-2 mb-1 ${currentLessonId == l.id ? 'active bg-primary text-white border-primary shadow-sm' : 'border-0'} learn-item"
                                   data-title="${l.title.toLowerCase()}">
                                    <span class="badge ${currentLessonId == l.id ? 'bg-white text-primary' : 'bg-light text-muted border'} flex-shrink-0" style="width: 26px;">
                                        ${lessonSeq}
                                    </span>
                                    <img src="${l.thumbnailUrl}" class="rounded flex-shrink-0" style="width: 42px; height: 26px; object-fit: cover;" alt="${l.title}"
                                         onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                    <div class="text-truncate flex-grow-1">
                                        <span class="d-block text-truncate fw-semibold">${l.title}</span>
                                        <c:if test="${!l.active}">
                                            <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle" style="font-size: 10px;">Đã ẩn</span>
                                        </c:if>
                                    </div>
                                    <c:if test="${l.progressStatus == 'COMPLETED'}">
                                        <i class="bi bi-check-circle-fill ${currentLessonId == l.id ? 'text-white' : 'text-success'} flex-shrink-0"></i>
                                    </c:if>
                                </a>
                                <c:set var="lessonSeq" value="${lessonSeq + 1}" />
                            </c:if>
                        </c:forEach>

                        <c:forEach var="q" items="${m.quizzes}">
                            <a href="${pageContext.request.contextPath}/quizzes/attempt?registrationId=${registrationId}&quizId=${q.id}"
                               class="list-group-item list-group-item-action list-group-item-warning d-flex justify-content-between align-items-center py-2 px-2 rounded-2 mb-1 learn-item border-0"
                               data-title="${q.title.toLowerCase()}">
                                <span class="text-truncate"><i class="bi bi-patch-question me-1"></i>${q.title}</span>
                                <span class="badge bg-warning text-dark">Kiểm tra</span>
                            </a>
                        </c:forEach>
                    </c:forEach>
                </div>
            </div>
        </aside>

        <!-- 2. CONTENT AREA (Center Video/Mô tả + Right Note) -->
        <div class="learning-content-scroll">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-warning alert-dismissible fade show shadow-sm py-2 px-3 small mb-3 rounded-3" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2 text-warning"></i><c:out value="${errorMessage}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm py-2 px-3 small mb-3 rounded-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i><c:out value="${successMessage}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:choose>
                <c:when test="${activeLesson != null}">
                    <c:if test="${!activeLesson.active}">
                        <div class="alert alert-warning py-2 px-3 small mb-3 d-flex align-items-center gap-2 border shadow-sm rounded-3">
                            <i class="bi bi-eye-slash-fill text-warning fs-5 flex-shrink-0"></i>
                            <span><strong>Bài học đã được tạm ẩn:</strong> Bạn vẫn có thể tiếp tục xem và hoàn thành bài giảng trong phiên học hiện tại. Sau khi chuyển sang bài học khác, bạn sẽ không thể quay lại bài học này nữa.</span>
                        </div>
                    </c:if>
                    <c:if test="${course.archived}">
                        <div class="alert alert-secondary py-2 px-3 small mb-3 d-flex align-items-center gap-2 border shadow-sm rounded-3">
                            <i class="bi bi-archive text-secondary fs-5"></i>
                            <span><strong>Khóa học đã lưu trữ:</strong> Khóa học này hiện đã ngừng nhận học viên mới. Toàn bộ nội dung học tập và tiến độ của bạn luôn được bảo đảm và tiếp tục truy cập trọn đời bình thường.</span>
                        </div>
                    </c:if>

                    <div class="row g-3">
                        <!-- CENTER COLUMN: Video Player & Controls & Mô tả -->
                        <div class="col-12 col-md-7 col-lg-7 col-xl-7 col-xxl-8">
                            <div class="card p-3 shadow-sm border-0 rounded-3 mb-3 bg-white">
                                <!-- Lesson Title & Completed Action -->
                                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-2 pb-2 border-bottom">
                                    <div>
                                        <c:if test="${not empty activeModuleName}">
                                            <span class="badge bg-light text-secondary border me-1"><i class="bi bi-folder2 me-1"></i>${activeModuleName}</span>
                                        </c:if>
                                        <span class="badge bg-primary-subtle text-primary border mb-1">Bài học</span>
                                        <h5 class="fw-bold mb-0 mt-1 text-dark">${activeLesson.title}</h5>
                                    </div>
                                    <div class="d-flex align-items-center gap-2">
                                        <form action="${pageContext.request.contextPath}/courses/update-progress" method="POST" class="d-inline">
                                            <input type="hidden" name="registrationId" value="${registrationId}">
                                            <input type="hidden" name="lessonId" value="${activeLesson.id}">
                                            <input type="hidden" name="status" value="COMPLETED">
                                            <c:choose>
                                                <c:when test="${activeLesson.progressStatus == 'COMPLETED'}">
                                                    <button type="submit" class="btn btn-outline-success fw-semibold btn-sm px-3 shadow-sm" title="Bấm để cập nhật lại">
                                                        <i class="bi bi-check-circle-fill me-1"></i>Đã hoàn thành
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="submit" class="btn btn-success fw-semibold btn-sm px-3 shadow-sm">
                                                        <i class="bi bi-check2-circle me-1"></i>Đánh dấu hoàn thành
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                    </div>
                                </div>

                                <!-- Video Player (ratio-16x9) -->
                                <c:choose>
                                    <c:when test="${not empty activeLesson.videoUrl}">
                                        <div class="ratio ratio-16x9 mb-2 rounded-3 bg-dark shadow-sm overflow-hidden border">
                                            <iframe src="${activeLesson.videoUrl}" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="ratio ratio-16x9 mb-2 rounded-3 bg-secondary-subtle d-flex align-items-center justify-content-center text-muted border">
                                            <div class="text-center p-3">
                                                <i class="bi bi-play-circle fs-2 mb-2 text-secondary"></i>
                                                <p class="mb-0 fw-semibold small">Bài học này không có video hướng dẫn trực tiếp.</p>
                                                <span class="text-muted" style="font-size: 11px;">Vui lòng đọc mô tả và ghi chú bài học bên dưới.</span>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Navigation buttons between lessons -->
                                <div class="d-flex justify-content-between align-items-center py-1.5 px-3 bg-light rounded-3 mb-3 border small">
                                    <c:choose>
                                        <c:when test="${prevLessonId != null}">
                                            <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registrationId}&lessonId=${prevLessonId}" class="btn btn-outline-secondary btn-sm py-1 px-2 rounded-2" style="font-size: 12px;">
                                                <i class="bi bi-arrow-left me-1"></i>Bài trước
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-outline-secondary btn-sm py-1 px-2 rounded-2" style="font-size: 12px;" disabled><i class="bi bi-arrow-left me-1"></i>Bài trước</button>
                                        </c:otherwise>
                                    </c:choose>

                                    <span class="text-muted fw-semibold d-none d-sm-inline" style="font-size: 12px;">Điều hướng bài học</span>

                                    <c:choose>
                                        <c:when test="${nextLessonId != null}">
                                            <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registrationId}&lessonId=${nextLessonId}" class="btn btn-primary btn-sm py-1 px-2 rounded-2" style="font-size: 12px;">
                                                Bài kế tiếp <i class="bi bi-arrow-right ms-1"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-secondary btn-sm py-1 px-2 rounded-2" style="font-size: 12px;" disabled>Đã hết bài <i class="bi bi-check2 ms-1"></i></button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Mô tả (Lesson Description & Attachments) -->
                                <div class="lesson-overview pt-2 border-top">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h6 class="fw-bold mb-0 text-dark">
                                            <i class="bi bi-info-circle text-primary me-2"></i>Mô tả & Tài liệu
                                        </h6>
                                        <c:if test="${not empty activeLesson.documentUrl}">
                                            <a href="${activeLesson.documentUrl}" target="_blank" class="btn btn-outline-primary btn-sm rounded-2 py-0 px-2" style="font-size: 12px;">
                                                <i class="bi bi-file-earmark-arrow-down me-1"></i>Tài liệu đính kèm
                                            </a>
                                        </c:if>
                                    </div>

                                    <!-- Collapsible Accordion: Original Expert Note for Quick Reference -->
                                    <c:if test="${not empty activeLesson.content}">
                                        <div class="accordion mt-2" id="accordionExpertRef">
                                            <div class="accordion-item border rounded-3 overflow-hidden">
                                                <h2 class="accordion-header" id="headingExpertRef">
                                                    <button class="accordion-button collapsed py-2 px-3 small fw-semibold bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#collapseExpertRef" aria-expanded="false" aria-controls="collapseExpertRef">
                                                        <i class="bi bi-lightbulb text-warning me-2 fs-6"></i>
                                                        Xem ghi chú tham khảo gốc của Chuyên gia (Expert's Reference)
                                                    </button>
                                                </h2>
                                                <div id="collapseExpertRef" class="accordion-collapse collapse" aria-labelledby="headingExpertRef" data-bs-parent="#accordionExpertRef">
                                                    <div class="accordion-body p-3 bg-white">
                                                        <div id="expertContentRendered" class="ql-editor p-0 markdown-body border-0" style="max-height: 250px; overflow-y: auto;">
                                                            ${activeLesson.content}
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- RIGHT COLUMN: Note (Student Personal Blank Note with Cloud Auto-save) -->
                        <div class="col-12 col-md-5 col-lg-5 col-xl-5 col-xxl-4">
                            <div class="note-card p-3 shadow-sm sticky-top" style="top: 15px; z-index: 10;">
                                <!-- Note Header -->
                                <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom flex-wrap gap-2">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-journal-text text-primary fs-5"></i>
                                        <h6 class="fw-bold mb-0 text-dark">Ghi chú cá nhân</h6>
                                    </div>
                                    <div>
                                        <span id="noteSavedStatus" class="badge bg-light text-muted border" style="font-size: 11.5px; font-weight: 500;">
                                            <i class="bi bi-cloud-check text-success me-1"></i>Đã đồng bộ
                                        </span>
                                    </div>
                                </div>

                                <!-- Quill Rich Text Editor Container (Blank note by default, or student's saved note) -->
                                <div id="studentNoteEditor">
                                    <c:out value="${activeLesson.userNote}" escapeXml="false" />
                                </div>

                                <!-- Auto-save Hint Footer -->
                                <div class="d-flex justify-content-between align-items-center pt-2 mt-2 border-top text-muted small" style="font-size: 11.5px;">
                                    <span><i class="bi bi-cloud-arrow-up text-primary me-1"></i>Tự động lưu vào CSDL</span>
                                    <span id="noteCharCount" class="text-secondary">0 từ</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Welcome state if no active lesson selected -->
                    <div class="card p-5 text-center border-0 shadow-sm rounded-3 bg-white my-4 mx-auto" style="max-width: 600px;">
                        <i class="bi bi-play-circle fs-1 text-primary mb-3"></i>
                        <h4 class="fw-bold">Chào mừng bạn đến với khóa học!</h4>
                        <p class="text-muted">Vui lòng chọn một bài học trong danh sách bên trái để bắt đầu theo dõi video và ghi chú bài học.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.min.js"></script>
<script>
    // 1. Filter Lessons in Sidebar
    function filterLearningLessons() {
        const input = document.getElementById('learnLessonFilter').value.toLowerCase().trim();
        const items = document.querySelectorAll('#learnLessonList .learn-item');
        items.forEach(function(item) {
            const title = item.getAttribute('data-title') || '';
            if (!input || title.includes(input)) {
                item.style.display = '';
            } else {
                item.style.display = 'none';
            }
        });
    }

    // 2. Collapsible Sidebar Management
    const sidebar = document.getElementById('sidebarWrapper');
    const btnToggle = document.getElementById('btnToggleSidebar');
    const btnCloseMobile = document.getElementById('btnCloseSidebarMobile');

    function setSidebarCollapsed(collapsed) {
        if (!sidebar) return;
        if (collapsed) {
            sidebar.classList.add('collapsed');
            if (btnToggle) {
                btnToggle.setAttribute('title', 'Mở danh sách bài học');
            }
            localStorage.setItem('learn_sidebar_collapsed', 'true');
        } else {
            sidebar.classList.remove('collapsed');
            if (btnToggle) {
                btnToggle.setAttribute('title', 'Đóng danh sách bài học');
            }
            localStorage.setItem('learn_sidebar_collapsed', 'false');
        }
    }

    if (btnToggle) {
        btnToggle.addEventListener('click', function() {
            const isCurrentlyCollapsed = sidebar.classList.contains('collapsed');
            setSidebarCollapsed(!isCurrentlyCollapsed);
        });
    }

    if (btnCloseMobile) {
        btnCloseMobile.addEventListener('click', function() {
            setSidebarCollapsed(true);
        });
    }

    // Initialize sidebar state on page load
    document.addEventListener('DOMContentLoaded', function() {
        const savedState = localStorage.getItem('learn_sidebar_collapsed');
        if (savedState === 'true') {
            setSidebarCollapsed(true);
        } else if (savedState === 'false') {
            setSidebarCollapsed(false);
        } else {
            // Default on small screen: collapsed; on desktop: open
            if (window.innerWidth < 992) {
                setSidebarCollapsed(true);
            } else {
                setSidebarCollapsed(false);
            }
        }
    });

    // 3. Render Expert's Reference in Accordion
    document.addEventListener('DOMContentLoaded', function() {
        const expEl = document.getElementById('expertContentRendered');
        if (expEl) {
            const raw = expEl.innerHTML.trim();
            if (!/<[a-z][\s\S]*>/i.test(raw) && window.marked) {
                expEl.innerHTML = marked.parse(expEl.textContent.replace(/__(.*?)__/g, '<u>$1</u>'));
            }
        }
    });

    // 4. Initialize Quill Blank Note Editor & Seamless Database Auto-Save
    let quill = null;
    let noteDebounceTimer = null;
    let hasUnsavedNote = false;

    function setSaveStatus(type, msg) {
        const el = document.getElementById('noteSavedStatus');
        if (!el) return;
        if (type === 'saved') {
            el.className = 'badge bg-success-subtle text-success border';
            el.innerHTML = '<i class="bi bi-cloud-check text-success me-1"></i>' + msg;
        } else if (type === 'saving') {
            el.className = 'badge bg-info-subtle text-info border';
            el.innerHTML = '<span class="spinner-border spinner-border-sm me-1" style="width: 10px; height: 10px;"></span>' + msg;
        } else if (type === 'unsaved') {
            el.className = 'badge bg-warning-subtle text-warning border';
            el.innerHTML = '<i class="bi bi-pencil-fill me-1"></i>' + msg;
        } else if (type === 'error') {
            el.className = 'badge bg-danger-subtle text-danger border';
            el.innerHTML = '<i class="bi bi-exclamation-triangle me-1"></i>' + msg;
        }
    }

    function updateNoteStats() {
        if (!quill) return;
        const text = quill.getText().trim();
        const wordCount = text.length > 0 ? text.split(/\s+/).length : 0;
        const charEl = document.getElementById('noteCharCount');
        if (charEl) {
            charEl.textContent = wordCount + ' từ (' + text.length + ' ký tự)';
        }
    }

    function saveNoteAjax() {
        if (!quill) return;
        const noteHtml = quill.root.innerHTML;
        hasUnsavedNote = false;
        setSaveStatus('saving', 'Đang lưu...');

        const params = new URLSearchParams();
        params.append('registrationId', '${registrationId}');
        params.append('lessonId', '${activeLesson != null ? activeLesson.id : 0}');
        params.append('note', noteHtml);

        fetch('${pageContext.request.contextPath}/courses/save-lesson-note', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
            },
            body: params.toString()
        })
        .then(response => response.json())
        .then(data => {
            if (data && data.success) {
                const now = new Date();
                const timeStr = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
                setSaveStatus('saved', 'Đã lưu lúc ' + timeStr);
            } else {
                setSaveStatus('error', (data && data.message) ? data.message : 'Lỗi khi lưu');
            }
        })
        .catch(err => {
            setSaveStatus('error', 'Lỗi kết nối máy chủ');
            console.error('Lỗi lưu ghi chú:', err);
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        const editorContainer = document.getElementById('studentNoteEditor');
        if (!editorContainer) return;

        quill = new Quill('#studentNoteEditor', {
            theme: 'snow',
            placeholder: 'Ghi chép bài học của bạn tại đây... (Hệ thống tự động lưu vào đám mây)',
            modules: {
                toolbar: [
                    [{ 'header': [1, 2, 3, false] }],
                    ['bold', 'italic', 'underline', 'strike'],
                    [{ 'color': [] }, { 'background': [] }],
                    [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                    ['blockquote', 'code-block'],
                    ['clean']
                ]
            }
        });

        updateNoteStats();

        // Tự động lưu sau 1.2s khi dừng gõ phím
        quill.on('text-change', function(delta, oldDelta, source) {
            if (source === 'user') {
                hasUnsavedNote = true;
                updateNoteStats();
                setSaveStatus('unsaved', 'Đang nhập...');
                if (noteDebounceTimer) {
                    clearTimeout(noteDebounceTimer);
                }
                noteDebounceTimer = setTimeout(function() {
                    saveNoteAjax();
                }, 1200);
            }
        });

        // Khi người dùng bấm chuột ra ngoài ô soạn thảo (blur), lưu ngay lập tức
        quill.root.addEventListener('blur', function() {
            if (hasUnsavedNote) {
                if (noteDebounceTimer) clearTimeout(noteDebounceTimer);
                saveNoteAjax();
            }
        });

        // Lưu trước khi rời trang / đóng tab
        window.addEventListener('beforeunload', function() {
            if (hasUnsavedNote && quill) {
                const params = new URLSearchParams();
                params.append('registrationId', '${registrationId}');
                params.append('lessonId', '${activeLesson != null ? activeLesson.id : 0}');
                params.append('note', quill.root.innerHTML);
                if (navigator.sendBeacon) {
                    navigator.sendBeacon('${pageContext.request.contextPath}/courses/save-lesson-note', params);
                }
            }
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
