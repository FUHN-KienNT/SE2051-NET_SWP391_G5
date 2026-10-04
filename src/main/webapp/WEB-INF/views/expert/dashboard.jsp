<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Expert Dashboard - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Top bar -->
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div>
                <h3 class="fw-bold mb-1"><i class="bi bi-mortarboard-fill text-primary me-2"></i>Expert Studio &amp; Quản lý Khóa học</h3>
                <p class="text-muted small mb-0">Tạo khóa học mới, biên soạn danh sách bài giảng và xây dựng nội dung đào tạo (Màn hình II.4.3)</p>
            </div>
            <div>
                <button type="button" class="btn btn-primary fw-semibold shadow-sm px-3" data-bs-toggle="modal" data-bs-target="#newCourseModal">
                    <i class="bi bi-plus-circle-fill me-1"></i>Tạo Khóa học mới
                </button>
            </div>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'created'}">Khởi tạo khóa học thành công! Hãy bắt đầu thêm các chương và bài học bên dưới.</c:when>
                    <c:when test="${param.success == 'deleted'}">Đã xóa khóa học thành công!</c:when>
                    <c:otherwise>Cập nhật thông tin thành công!</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Metric summary -->
        <c:set var="publishedCount" value="0" />
        <c:set var="draftCount" value="0" />
        <c:forEach var="c" items="${courses}">
            <c:if test="${c.status == 'PUBLISHED'}"><c:set var="publishedCount" value="${publishedCount + 1}" /></c:if>
            <c:if test="${c.status == 'DRAFT'}"><c:set var="draftCount" value="${draftCount + 1}" /></c:if>
        </c:forEach>

        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-primary text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-bold">Tổng số khóa học</div>
                            <div class="fs-2 fw-bold mt-1">${courses.size()}</div>
                        </div>
                        <i class="bi bi-journal-bookmark fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-success text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-bold">Đã công khai (Published)</div>
                            <div class="fs-2 fw-bold mt-1">${publishedCount}</div>
                        </div>
                        <i class="bi bi-check-circle-fill fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-warning text-dark">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-dark text-opacity-75 text-uppercase fw-bold">Bản nháp / Chờ duyệt (Draft)</div>
                            <div class="fs-2 fw-bold mt-1">${draftCount}</div>
                        </div>
                        <i class="bi bi-hourglass-split fs-1 text-dark text-opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Course assigned list -->
        <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0"><i class="bi bi-collection-play text-primary me-2"></i>Danh sách Khóa học của bạn</h5>
                <span class="badge bg-light text-muted border">${courses.size()} khóa học</span>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Ảnh / Tên khóa học</th>
                            <th>Danh mục</th>
                            <th>Bài giảng</th>
                            <th>Trạng thái xuất bản</th>
                            <th class="text-end text-nowrap" style="min-width: 300px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty courses}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-folder-x fs-1 d-block mb-2"></i>
                                        Bạn chưa tạo hoặc chưa được phân công khóa học nào.<br>
                                        <button type="button" class="btn btn-primary btn-sm mt-3" data-bs-toggle="modal" data-bs-target="#newCourseModal">
                                            <i class="bi bi-plus-lg me-1"></i>Bấm vào đây để tạo khóa học đầu tiên
                                        </button>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${courses}">
                                    <tr>
                                        <td><span class="badge bg-light text-dark border">#${c.id}</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <img src="${c.thumbnailUrl}" class="rounded shadow-sm flex-shrink-0" style="width: 60px; height: 38px; object-fit: cover;" alt="${c.title}"
                                                     onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}" class="fw-bold text-dark text-decoration-none">
                                                        ${c.title}
                                                    </a>
                                                    <div class="small text-muted">
                                                        <c:choose>
                                                            <c:when test="${c.price <= 0}">Miễn phí</c:when>
                                                            <c:otherwise>${c.price} VNĐ</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">${c.categoryName != null ? c.categoryName : 'Khóa học'}</span></td>
                                        <td>
                                            <span class="fw-semibold text-primary">${c.totalLessons} bài</span>
                                            <small class="text-muted d-block">(${c.modules.size()} chương)</small>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 'PUBLISHED'}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                        <i class="bi bi-check-circle-fill me-1"></i>Đã công khai (PUBLISHED)
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-2 py-1" title="Khóa học đang ở dạng bản nháp, học viên chưa thấy">
                                                        <i class="bi bi-hourglass-split me-1"></i>Bản nháp (DRAFT) - Đang chờ duyệt
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end text-nowrap">
                                            <div class="d-inline-flex align-items-center justify-content-end gap-1">
                                                <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}" class="btn btn-primary btn-sm shadow-sm text-nowrap">
                                                    <i class="bi bi-journal-text me-1"></i>Soạn Bài học (${c.totalLessons})
                                                </a>
                                                <button type="button" class="btn btn-outline-secondary btn-sm text-nowrap" data-bs-toggle="modal" data-bs-target="#editCourseModal_${c.id}">
                                                    <i class="bi bi-gear me-1"></i>Sửa thông tin
                                                </button>
                                                <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="btn btn-light btn-sm border text-nowrap" target="_blank" title="Xem trước trang khóa học">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>

                                    <!-- Edit Course Modal for Course #${c.id} -->
                                    <div class="modal fade" id="editCourseModal_${c.id}" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <form action="${pageContext.request.contextPath}/expert/save-course" method="POST">
                                                    <input type="hidden" name="id" value="${c.id}">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold">Chỉnh sửa thông tin Khóa học #${c.id}</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Tên khóa học <span class="text-danger">*</span></label>
                                                            <input type="text" name="title" class="form-control" value="${c.title}" required>
                                                        </div>
                                                        <div class="row g-2 mb-3">
                                                            <div class="col-md-7">
                                                                <label class="form-label small fw-semibold">Danh mục</label>
                                                                <select name="categoryId" class="form-select" onchange="toggleCustomCategory(this, 'editCourseCustomCatDiv_${c.id}')">
                                                                    <c:forEach var="cat" items="${categories}">
                                                                        <option value="${cat.id}" ${cat.id == c.categoryId ? 'selected' : ''}>${cat.name}</option>
                                                                    </c:forEach>
                                                                    <option value="__NEW__" class="fw-bold text-primary">➕ + Nhập danh mục mới...</option>
                                                                </select>
                                                                <div id="editCourseCustomCatDiv_${c.id}" class="mt-2" style="display: none;">
                                                                    <input type="text" name="customCategory" class="form-control form-control-sm border-primary" placeholder="✨ Nhập tên danh mục đào tạo mới...">
                                                                </div>
                                                            </div>
                                                            <div class="col-md-5">
                                                                <label class="form-label small fw-semibold">Học phí (VNĐ)</label>
                                                                <input type="number" name="price" class="form-control" value="${c.price}">
                                                            </div>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Mô tả tóm tắt</label>
                                                            <textarea name="description" rows="3" class="form-control">${c.description}</textarea>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn btn-primary fw-semibold">Lưu thay đổi</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- New Course Modal -->
<div class="modal fade" id="newCourseModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <form action="${pageContext.request.contextPath}/expert/save-course" method="POST">
                <div class="modal-header bg-primary text-white border-0">
                    <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle me-2"></i>Tạo Khóa học mới (Expert)</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="alert alert-info py-2 px-3 small mb-3">
                        <i class="bi bi-info-circle-fill me-1"></i>Khóa học khi tạo mới sẽ ở trạng thái <strong>BẢN NHÁP (DRAFT)</strong> để bạn chủ động thêm chương và bài giảng trước khi Admin/Manager duyệt công khai.
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên khóa học <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" placeholder="Ví dụ: Khóa học Lập trình Web Fullstack..." required>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-md-7">
                            <label class="form-label small fw-semibold">Danh mục đào tạo</label>
                            <select name="categoryId" class="form-select" onchange="toggleCustomCategory(this, 'newCourseCustomCatDiv')">
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                                <option value="__NEW__" class="fw-bold text-primary">➕ + Nhập danh mục mới...</option>
                            </select>
                            <div id="newCourseCustomCatDiv" class="mt-2" style="display: none;">
                                <input type="text" name="customCategory" class="form-control form-control-sm border-primary" placeholder="✨ Nhập tên danh mục đào tạo mới...">
                            </div>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label small fw-semibold">Học phí (VNĐ)</label>
                            <input type="number" name="price" class="form-control" value="0" min="0" placeholder="0 = Miễn phí">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mô tả tóm tắt khóa học</label>
                        <textarea name="description" rows="2" class="form-control" placeholder="Mục tiêu đầu ra, kiến thức đạt được..."></textarea>
                    </div>

                    <div class="p-3 bg-light rounded-3 border mb-3">
                        <label class="form-label small fw-bold text-dark d-flex justify-content-between align-items-center mb-1">
                            <span><i class="bi bi-youtube text-danger me-1"></i>Nhập Playlist / Danh sách nhiều Video YouTube (Tùy chọn)</span>
                            <span class="badge bg-danger">Tạo tự động</span>
                        </label>
                        <textarea name="batchVideoText" rows="4" class="form-control font-monospace small bg-white" placeholder="Dán danh sách các link video YouTube hoặc playlist (mỗi dòng 1 link). Ví dụ:&#10;https://www.youtube.com/watch?v=WVPVpNDKUwM - Buổi 1: Khái quát cơ bản&#10;https://www.youtube.com/watch?v=gJS-1C78Jy0 - Buổi 2: Hướng dẫn thực hành&#10;https://youtu.be/SMaG-tqSzFM - Buổi 3: Ứng dụng thực tế"></textarea>
                        <div class="form-text small mt-1"><i class="bi bi-magic text-primary me-1"></i>Nếu dán link ở đây, hệ thống sẽ tự động tạo ngay toàn bộ bài giảng tương ứng vào khóa học chỉ với 1 click!</div>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 py-3">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold px-4">Tạo khóa học &amp; Soạn bài</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function toggleCustomCategory(selectEl, targetDivId) {
    var div = document.getElementById(targetDivId);
    if (!div) return;
    if (selectEl.value === '__NEW__') {
        div.style.display = 'block';
        var inp = div.querySelector('input');
        if (inp) {
            inp.focus();
            inp.required = true;
        }
    } else {
        div.style.display = 'none';
        var inp = div.querySelector('input');
        if (inp) {
            inp.required = false;
            inp.value = '';
        }
    }
}
</script>

<jsp:include page="../common/footer.jsp" />
