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

        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i>Đã lưu thông tin bài học thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1"><i class="bi bi-journal-bookmark me-2"></i>Chương trình học: ${course.title}</h3>
                <p class="text-muted small mb-0">Quản lý các chương học (Modules) và các bài giảng (Lessons) - Màn hình II.4.1</p>
            </div>
            <div>
                <button type="button" class="btn btn-outline-primary me-2" data-bs-toggle="modal" data-bs-target="#newModuleModal">
                    <i class="bi bi-folder-plus me-1"></i>Thêm Chương mới
                </button>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty course.modules}">
                <div class="card p-5 text-center border-0 shadow-sm rounded-3">
                    <i class="bi bi-folder2-open fs-1 text-muted mb-3"></i>
                    <h5>Khóa học này chưa có chương học nào!</h5>
                    <p class="text-muted small">Hãy bấm nút "Thêm Chương mới" ở trên để bắt đầu xây dựng nội dung bài học.</p>
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
                                        <a href="${pageContext.request.contextPath}/quizzes/list?courseId=${course.id}#module-${m.id}" class="btn btn-sm btn-outline-warning">
                                            <i class="bi bi-patch-question me-1"></i>Quản lý Quiz
                                        </a>
                                        <a href="${pageContext.request.contextPath}/expert/delete-module?courseId=${course.id}&moduleId=${m.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa chương này sẽ xóa tất cả bài học bên trong. Bạn có chắc không?');">
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
                                                        <div>
                                                            <span class="badge bg-light text-dark border me-2">Bài ${l.orderIndex}</span>
                                                            <strong class="me-2">${l.title}</strong>
                                                            <c:if test="${not empty l.videoUrl}">
                                                                <span class="badge bg-danger-subtle text-danger border"><i class="bi bi-youtube me-1"></i>Video</span>
                                                            </c:if>
                                                            <c:if test="${not empty l.documentUrl}">
                                                                <span class="badge bg-info-subtle text-info border"><i class="bi bi-file-earmark me-1"></i>Tài liệu</span>
                                                            </c:if>
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

<jsp:include page="../common/footer.jsp" />
