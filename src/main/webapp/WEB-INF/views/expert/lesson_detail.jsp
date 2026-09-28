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
                            <label class="form-label small fw-semibold"><i class="bi bi-youtube text-danger me-1"></i>URL Video bài giảng (YouTube Embed hoặc MP4)</label>
                            <input type="url" name="videoUrl" class="form-control" value="${lesson != null ? lesson.videoUrl : ''}" placeholder="https://www.youtube.com/watch?v=...">
                            <div class="form-text small">Dán liên kết video để học viên có thể xem trực tiếp trong màn hình học tập.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold"><i class="bi bi-file-earmark-text text-info me-1"></i>URL Tài liệu đính kèm (Slide / PDF / Google Docs)</label>
                            <input type="url" name="documentUrl" class="form-control" value="${lesson != null ? lesson.documentUrl : ''}" placeholder="https://drive.google.com/...">
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-semibold">Nội dung chi tiết bài học / Ghi chú lý thuyết</label>
                            <textarea name="content" rows="8" class="form-control" placeholder="Nhập nội dung bài học, hướng dẫn thực hành hoặc ghi chú quan trọng...">${lesson != null ? lesson.content : ''}</textarea>
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

<jsp:include page="../common/footer.jsp" />
