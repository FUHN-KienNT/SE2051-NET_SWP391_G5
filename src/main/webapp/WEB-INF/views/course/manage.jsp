<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản lý khóa học - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Khóa học bạn phụ trách</h3>
                <p class="text-muted small mb-0">Quản trị các khóa học, chương trình giảng dạy và bài thi</p>
            </div>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newCourseModal">
                <i class="bi bi-plus-lg me-1"></i>Tạo khóa học mới
            </button>
        </div>

        <c:choose>
            <c:when test="${empty courses}">
                <div class="card p-5 text-center">
                    <i class="bi bi-folder2-open fs-1 text-muted mb-2"></i>
                    <p class="text-muted">Bạn chưa quản lý khóa học nào.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tiêu đề khóa học</th>
                                    <th>Giá (VNĐ)</th>
                                    <th>Trạng thái</th>
                                    <th>Số chương</th>
                                    <th class="text-end">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${courses}">
                                    <tr>
                                        <td>#${c.id}</td>
                                        <td class="fw-semibold">${c.title}</td>
                                        <td>${c.price}</td>
                                        <td>
                                            <span class="badge ${c.status == 'PUBLISHED' ? 'bg-success' : 'bg-secondary'}">
                                                ${c.status}
                                            </span>
                                        </td>
                                        <td>${c.modules.size()}</td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="btn btn-outline-primary btn-sm me-1">
                                                <i class="bi bi-eye"></i> Xem
                                            </a>
                                            <a href="${pageContext.request.contextPath}/courses/delete?id=${c.id}" class="btn btn-outline-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa khóa học này?');">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- Modal Create Course -->
<div class="modal fade" id="newCourseModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/courses/save" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Tạo khóa học mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên khóa học</label>
                        <input type="text" name="title" class="form-control" required placeholder="Nhập tên khóa học">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Giá khóa học (0 là Miễn phí)</label>
                        <input type="number" step="1000" name="price" value="0" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Danh mục khóa học</label>
                        <select name="categoryId" class="form-select">
                            <option value="6">Lập trình Web</option>
                            <option value="7">Khoa học Dữ liệu &amp; AI</option>
                            <option value="8">Kỹ năng mềm</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="DRAFT">DRAFT (Bản nháp)</option>
                            <option value="PUBLISHED">PUBLISHED (Công khai)</option>
                            <option value="ARCHIVED">ARCHIVED (Lưu trữ)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mô tả khóa học</label>
                        <textarea name="description" rows="4" class="form-control" placeholder="Mô tả nội dung, mục tiêu của khóa học"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold">Lưu khóa học</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
