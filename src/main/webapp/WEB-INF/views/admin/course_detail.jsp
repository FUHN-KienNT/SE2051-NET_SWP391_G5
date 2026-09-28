<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản trị khóa học - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Breadcrumb & Title -->
        <nav class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/courses">Khóa học</a></li>
                <li class="breadcrumb-item active">Chi tiết khóa học #${course.id}</li>
            </ol>
        </nav>

        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i>Đã cập nhật thông tin và phân công chuyên gia thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Left col: Course edit & Expert assignment form -->
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-gear-wide-connected me-2"></i>Thông tin &amp; Phân công Chuyên gia</h5>
                    <form action="${pageContext.request.contextPath}/admin/save-course" method="POST">
                        <input type="hidden" name="id" value="${course.id}">

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Tên khóa học</label>
                            <input type="text" name="title" class="form-control" value="${course.title}" required>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Học phí (VNĐ)</label>
                                <input type="number" step="1000" name="price" value="${course.price}" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Danh mục</label>
                                <select name="categoryId" class="form-select">
                                    <option value="6" ${course.categoryId == 6 ? 'selected' : ''}>Lập trình Web</option>
                                    <option value="7" ${course.categoryId == 7 ? 'selected' : ''}>Khoa học Dữ liệu &amp; AI</option>
                                    <option value="8" ${course.categoryId == 8 ? 'selected' : ''}>Kỹ năng mềm</option>
                                </select>
                            </div>
                        </div>

                        <!-- Phân công Expert -->
                        <div class="mb-3 p-3 bg-light rounded-3 border">
                            <label class="form-label small fw-bold text-primary">
                                <i class="bi bi-person-fill-gear me-1"></i>Chuyên gia phụ trách nội dung (Assigned Expert)
                            </label>
                            <select name="expertId" class="form-select border-primary" required>
                                <option value="">-- Chưa phân công --</option>
                                <c:forEach var="exp" items="${experts}">
                                    <option value="${exp.id}" ${course.expertId == exp.id ? 'selected' : ''}>
                                        ${exp.fullName} (@${exp.username})
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="form-text small">Expert này sẽ toàn quyền tạo/sửa Bài học (Lesson) và Bài thi (Quiz) cho khóa học này.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Trạng thái phát hành (Status Override)</label>
                            <select name="status" class="form-select">
                                <option value="DRAFT" ${course.status == 'DRAFT' ? 'selected' : ''}>DRAFT (Bản nháp)</option>
                                <option value="PUBLISHED" ${course.status == 'PUBLISHED' ? 'selected' : ''}>PUBLISHED (Công khai)</option>
                                <option value="ARCHIVED" ${course.status == 'ARCHIVED' ? 'selected' : ''}>ARCHIVED (Lưu trữ / Tạm khóa)</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Mô tả khóa học</label>
                            <textarea name="description" rows="4" class="form-control">${course.description}</textarea>
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                            </a>
                            <button type="submit" class="btn btn-primary fw-semibold px-4">
                                <i class="bi bi-save me-1"></i>Lưu thay đổi &amp; Cập nhật
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Right col: Curriculum preview -->
            <div class="col-lg-5">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-list-task me-2"></i>Khung chương trình học</h5>
                    <c:choose>
                        <c:when test="${empty course.modules}">
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-hourglass-split fs-2 d-block mb-2"></i>
                                <p class="small mb-0">Chuyên gia phụ trách chưa tạo chương trình học.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="accordion" id="curriculumAccordion">
                                <c:forEach var="m" items="${course.modules}" varStatus="status">
                                    <div class="accordion-item border mb-2 rounded-2 overflow-hidden">
                                        <h2 class="accordion-header">
                                            <button class="accordion-button py-2 ${status.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#mod${m.id}">
                                                <small class="fw-bold">Chương ${m.orderIndex}: ${m.title}</small>
                                            </button>
                                        </h2>
                                        <div id="mod${m.id}" class="accordion-collapse collapse ${status.first ? 'show' : ''}">
                                            <div class="accordion-body p-2">
                                                <ul class="list-group list-group-flush small">
                                                    <c:forEach var="l" items="${m.lessons}">
                                                        <li class="list-group-item d-flex justify-content-between align-items-center py-2">
                                                            <span><i class="bi bi-play-circle text-primary me-2"></i>Bài ${l.orderIndex}: ${l.title}</span>
                                                            <span class="badge bg-light text-muted border">Bài học</span>
                                                        </li>
                                                    </c:forEach>
                                                    <c:forEach var="q" items="${m.quizzes}">
                                                        <li class="list-group-item d-flex justify-content-between align-items-center py-2 bg-light-subtle">
                                                            <span><i class="bi bi-question-circle text-warning me-2"></i>${q.title}</span>
                                                            <span class="badge bg-warning-subtle text-dark border">Bài thi</span>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
