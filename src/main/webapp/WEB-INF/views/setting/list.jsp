<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Cấu hình hệ thống - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Cấu hình hệ thống (Settings)</h3>
                <p class="text-muted small mb-0">Quản lý các vai trò người dùng (USER_ROLE) và danh mục khóa học (COURSE_CATEGORY)</p>
            </div>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newSettingModal">
                <i class="bi bi-plus-lg me-1"></i>Thêm cấu hình mới
            </button>
        </div>

        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success py-2 small" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i>Lưu cấu hình thành công!
            </div>
        </c:if>
        <c:if test="${param.deleted == 'true'}">
            <div class="alert alert-success py-2 small" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i>Xóa cấu hình thành công!
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger py-2 small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-1"></i>${param.error}
            </div>
        </c:if>

        <ul class="nav nav-pills mb-3">
            <li class="nav-item">
                <a class="nav-link ${currentType == 'USER_ROLE' ? 'active' : ''}" href="${pageContext.request.contextPath}/settings/list?type=USER_ROLE">
                    <i class="bi bi-people me-1"></i>Vai trò (USER_ROLE)
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentType == 'COURSE_CATEGORY' ? 'active' : ''}" href="${pageContext.request.contextPath}/settings/list?type=COURSE_CATEGORY">
                    <i class="bi bi-tags me-1"></i>Danh mục (COURSE_CATEGORY)
                </a>
            </li>
        </ul>

        <div class="card overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Tên hiển thị</th>
                            <th>Giá trị (Code/Value)</th>
                            <th>Độ ưu tiên</th>
                            <th>Trạng thái</th>
                            <th>Mô tả</th>
                            <th class="text-end">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${settings}">
                            <tr>
                                <td>#${s.id}</td>
                                <td class="fw-semibold">${s.name}</td>
                                <td><code>${s.value}</code></td>
                                <td>${s.priority}</td>
                                <td>
                                    <span class="badge ${s.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                        ${s.status}
                                    </span>
                                </td>
                                <td class="small text-muted">${s.description}</td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/settings/detail?id=${s.id}" class="btn btn-outline-primary btn-sm me-1" title="Chỉnh sửa cấu hình">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/settings/delete?id=${s.id}" class="btn btn-outline-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa cấu hình này?');" title="Xóa cấu hình">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- Modal Add Setting -->
<div class="modal fade" id="newSettingModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/settings/save" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Thêm cấu hình mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Loại cấu hình (Type)</label>
                        <select name="type" class="form-select">
                            <option value="USER_ROLE" ${currentType == 'USER_ROLE' ? 'selected' : ''}>USER_ROLE (Vai trò)</option>
                            <option value="COURSE_CATEGORY" ${currentType == 'COURSE_CATEGORY' ? 'selected' : ''}>COURSE_CATEGORY (Danh mục khóa học)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên hiển thị (Name)</label>
                        <input type="text" name="name" class="form-control" required placeholder="Ví dụ: Giảng viên hoặc Lập trình Java">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mã giá trị (Value)</label>
                        <input type="text" name="value" class="form-control" required placeholder="Ví dụ: INSTRUCTOR hoặc JAVA_DEV">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Độ ưu tiên (Priority)</label>
                        <input type="number" name="priority" value="1" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mô tả</label>
                        <textarea name="description" rows="3" class="form-control" placeholder="Mô tả chi tiết"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold">Lưu cấu hình</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
