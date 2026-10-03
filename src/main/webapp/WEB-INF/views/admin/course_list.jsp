<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản lý khóa học - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Top bar -->
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div>
                <h3 class="fw-bold mb-1"><i class="bi bi-collection me-2"></i>Danh sách Khóa học (Course List)</h3>
                <p class="text-muted small mb-0">Quản lý toàn bộ khóa học trên hệ thống, phân công Chuyên gia (Expert) phụ trách</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i>Dashboard
                </a>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newCourseModal">
                    <i class="bi bi-plus-lg me-1"></i>Tạo khóa học &amp; Phân công
                </button>
            </div>
        </div>

        <!-- Alerts -->
        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Cập nhật thông tin khóa học thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.deleted == 'true'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Đã xóa khóa học thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Search and Filter Form -->
        <form method="GET" action="${pageContext.request.contextPath}/admin/courses" class="card p-3 border-0 shadow-sm rounded-3 mb-4">
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted">Tìm kiếm (Search Box)</label>
                    <input type="text" name="search" class="form-control" placeholder="Tên khóa học hoặc ID..." value="${param.search}">
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-semibold text-muted">Danh mục (Category)</label>
                    <select name="categoryId" class="form-select">
                        <option value="">Tất cả danh mục</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}" ${param.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-semibold text-muted">Người quản lý (Manager)</label>
                    <select name="managerId" class="form-select">
                        <option value="">Tất cả Manager</option>
                        <c:forEach var="mgr" items="${managers}">
                            <option value="${mgr.id}" ${param.managerId == mgr.id ? 'selected' : ''}>${mgr.fullName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted">Trạng thái (Status)</label>
                    <select name="status" class="form-select">
                        <option value="">Tất cả trạng thái</option>
                        <option value="DRAFT" ${param.status == 'DRAFT' ? 'selected' : ''}>Draft</option>
                        <option value="PENDING_REVIEW" ${param.status == 'PENDING_REVIEW' ? 'selected' : ''}>Pending Review</option>
                        <option value="PUBLISHED" ${param.status == 'PUBLISHED' ? 'selected' : ''}>Published</option>
                        <option value="ARCHIVED" ${param.status == 'ARCHIVED' ? 'selected' : ''}>Archived</option>
                    </select>
                </div>
                <div class="col-md-2 d-grid">
                    <button type="submit" class="btn btn-primary fw-semibold"><i class="bi bi-funnel me-1"></i>Lọc & Tìm</button>
                </div>
            </div>
        </form>

        <!-- Course Table Card -->
        <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
            <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                <span class="fw-bold text-dark"><i class="bi bi-list-ul me-1"></i>Tất cả khóa học (${courses != null ? courses.size() : 0})</span>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 70px;">ID</th>
                            <th style="cursor: pointer;" title="Sort by Title">Tên khóa học <i class="bi bi-arrow-down-up ms-1 text-muted small"></i></th>
                            <th>Danh mục</th>
                            <th>Người quản lý (Manager)</th>
                            <th>Chuyên gia (Expert)</th>
                            <th style="cursor: pointer;" title="Sort by Price">Học phí <i class="bi bi-arrow-down-up ms-1 text-muted small"></i></th>
                            <th style="cursor: pointer;" title="Sort by Creation Date">Trạng thái <i class="bi bi-arrow-down-up ms-1 text-muted small"></i></th>
                            <th class="text-end" style="width: 150px;">Thao tác</th>
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
                                        <td><span class="text-muted fw-semibold">#${c.id}</span></td>
                                        <td>
                                            <div class="fw-bold text-dark">${c.title}</div>
                                            <small class="text-muted text-truncate d-inline-block" style="max-width: 280px;">
                                                ${c.description != null ? c.description : 'Chưa có mô tả'}
                                            </small>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-secondary border">
                                                ${c.categoryName != null ? c.categoryName : 'Chưa phân loại'}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="text-muted fw-semibold">${c.managerName != null ? c.managerName : 'Hệ thống'}</span>
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
                                            <c:choose>
                                                <c:when test="${c.price <= 0}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle">Miễn phí</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="fw-semibold text-primary">${c.price} VNĐ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 'PUBLISHED'}">
                                                    <span class="badge bg-success">PUBLISHED</span>
                                                </c:when>
                                                <c:when test="${c.status == 'PENDING_REVIEW'}">
                                                    <span class="badge bg-info text-dark">PENDING REVIEW</span>
                                                </c:when>
                                                <c:when test="${c.status == 'ARCHIVED'}">
                                                    <span class="badge bg-warning text-dark">ARCHIVED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">DRAFT</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/admin/course-detail?id=${c.id}" class="btn btn-primary btn-sm rounded-pill px-3" title="View Details Link">
                                                View Details
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
<div class="modal fade" id="newCourseModal" tabindex="-1" aria-labelledby="newCourseModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/save-course" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="newCourseModalLabel"><i class="bi bi-plus-circle me-2 text-primary"></i>Tạo khóa học mới &amp; Phân công</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên khóa học <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required placeholder="Ví dụ: Lập trình Java từ cơ bản đến nâng cao">
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Học phí (VNĐ, 0 là Miễn phí)</label>
                            <input type="number" step="1000" min="0" name="price" value="0" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Danh mục khóa học <span class="text-danger">*</span></label>
                            <select name="categoryId" class="form-select" required>
                                <c:choose>
                                    <c:when test="${not empty categories}">
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.id}">${cat.name}</option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="6">Lập trình Web</option>
                                        <option value="7">Khoa học Dữ liệu &amp; AI</option>
                                        <option value="8">Kỹ năng mềm</option>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                        </div>
                    </div>

                    <!-- Phân công Chuyên gia (Expert) -->
                    <div class="mb-3 p-3 bg-light rounded-3 border">
                        <label class="form-label small fw-bold text-primary">
                            <i class="bi bi-person-fill-gear me-1"></i>Phân công Chuyên gia phụ trách (Assign Expert) <span class="text-danger">*</span>
                        </label>
                        <select name="expertId" class="form-select border-primary" required>
                            <option value="">-- Chọn Chuyên gia (Expert) phụ trách nội dung --</option>
                            <c:forEach var="exp" items="${experts}">
                                <option value="${exp.id}">${exp.fullName} (@${exp.username}) - ${exp.email}</option>
                            </c:forEach>
                        </select>
                        <div class="form-text small">Chuyên gia được chọn sẽ có quyền tạo bài học (Lesson) và bài kiểm tra (Quiz) cho khóa học này.</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Trạng thái (Status)</label>
                        <select name="status" class="form-select">
                            <option value="DRAFT">Draft</option>
                            <option value="PENDING_REVIEW">Pending Review</option>
                            <option value="PUBLISHED">Published</option>
                            <option value="ARCHIVED">Archived</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mô tả khóa học</label>
                        <textarea name="description" rows="3" class="form-control" placeholder="Mục tiêu đào tạo, kiến thức đạt được và tóm tắt nội dung..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold px-4">
                        <i class="bi bi-save me-1"></i>Lưu &amp; Phân công
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
