<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản lý khóa học - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Top bar -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1"><i class="bi bi-shield-check text-primary me-2"></i>Trung tâm Kiểm duyệt &amp; Phê duyệt Khóa học</h3>
                <p class="text-muted small mb-0">Nhiệm vụ của Admin/Manager: Kiểm duyệt nội dung từ Expert và quyết định <strong>Đồng ý xuất bản (Publish)</strong> hoặc <strong>Từ chối (Draft)</strong></p>
            </div>
            <button type="button" class="btn btn-outline-primary btn-sm" data-bs-toggle="modal" data-bs-target="#newCourseModal">
                <i class="bi bi-plus-lg me-1"></i>Tạo thủ công &amp; Phân công
            </button>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Đã cập nhật trạng thái phê duyệt khóa học thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Table -->
        <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0">Danh sách Khóa học cần kiểm duyệt</h5>
                <span class="badge bg-light text-muted border">${courses.size()} khóa học</span>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Tên khóa học &amp; Thumbnail</th>
                            <th>Chuyên gia biên soạn</th>
                            <th>Bài giảng</th>
                            <th>Trạng thái</th>
                            <th class="text-end" style="min-width: 260px;">Quyết định phê duyệt (Admin Decision)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty courses}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-folder-x fs-1 d-block mb-2 text-muted"></i>
                                        Chưa có khóa học nào được gửi lên.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${courses}">
                                    <tr>
                                        <td><span class="badge bg-light text-dark border">#${c.id}</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <img src="${c.thumbnailUrl}" class="rounded shadow-sm flex-shrink-0" style="width: 58px; height: 36px; object-fit: cover;" alt="${c.title}"
                                                     onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="fw-bold text-dark text-decoration-none" target="_blank">
                                                        ${c.title}
                                                    </a>
                                                    <div class="small text-muted">${c.categoryName != null ? c.categoryName : 'Khóa học'} &bull; ${c.price > 0 ? c.price.concat(' VNĐ') : 'Miễn phí'}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.expertName != null}">
                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                                        <i class="bi bi-person-badge me-1"></i>${c.expertName}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning-subtle text-dark border border-warning-subtle">
                                                        <i class="bi bi-exclamation-circle me-1"></i>Chưa phân công
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="fw-semibold text-dark">${c.totalLessons} bài</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 'PUBLISHED'}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                        <i class="bi bi-check-circle-fill me-1"></i>ĐÃ DUYỆT (PUBLIC)
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-2 py-1">
                                                        <i class="bi bi-hourglass-split me-1"></i>CHỜ DUYỆT (DRAFT)
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <c:choose>
                                                <c:when test="${c.status == 'DRAFT'}">
                                                    <a href="${pageContext.request.contextPath}/admin/toggle-status?id=${c.id}" class="btn btn-success btn-sm me-1 shadow-sm fw-semibold" title="Phê duyệt cho phép học viên thấy và đăng ký khóa học">
                                                        <i class="bi bi-check-lg me-1"></i>Đồng ý xuất bản
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="btn btn-outline-secondary btn-sm me-1" target="_blank" title="Xem trước nội dung khóa học">
                                                        <i class="bi bi-eye"></i> Xem trước
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/admin/toggle-status?id=${c.id}" class="btn btn-outline-danger btn-sm me-1" title="Từ chối hoặc thu hồi về bản nháp">
                                                        <i class="bi bi-x-circle me-1"></i>Hạ về Draft
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="btn btn-outline-primary btn-sm me-1" target="_blank">
                                                        <i class="bi bi-eye"></i> Xem
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            <a href="${pageContext.request.contextPath}/admin/delete-course?id=${c.id}" class="btn btn-light btn-sm text-danger border" onclick="return confirm('Bạn có chắc chắn muốn xóa khóa học này?');" title="Xóa khóa học">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- Modal Create Course with Expert Assignment -->
<div class="modal fade" id="newCourseModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/save-course" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Tạo khóa học mới &amp; Phân công</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên khóa học <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required placeholder="Nhập tên khóa học">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Học phí (VNĐ, 0 là Miễn phí)</label>
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
                        <label class="form-label small fw-semibold text-primary">Phân công Chuyên gia phụ trách (Assign Expert) <span class="text-danger">*</span></label>
                        <select name="expertId" class="form-select border-primary" required>
                            <option value="">-- Chọn Chuyên gia (Expert) phụ trách nội dung --</option>
                            <c:forEach var="exp" items="${experts}">
                                <option value="${exp.id}">${exp.fullName} (@${exp.username})</option>
                            </c:forEach>
                        </select>
                        <div class="form-text small">Chuyên gia được chọn sẽ có quyền tạo bài giảng và bài kiểm tra cho khóa học này.</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Trạng thái phát hành</label>
                        <select name="status" class="form-select">
                            <option value="DRAFT">DRAFT (Bản nháp - Đang biên tập)</option>
                            <option value="PUBLISHED">PUBLISHED (Công khai)</option>
                            <option value="ARCHIVED">ARCHIVED (Lưu trữ)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mô tả khóa học</label>
                        <textarea name="description" rows="3" class="form-control" placeholder="Mục tiêu và tóm tắt nội dung"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold">Lưu &amp; Phân công</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
