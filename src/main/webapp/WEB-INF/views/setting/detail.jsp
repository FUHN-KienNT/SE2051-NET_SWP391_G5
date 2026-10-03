<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Chi tiết cấu hình - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Breadcrumb -->
        <nav class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/settings/list">Cấu hình</a></li>
                <li class="breadcrumb-item active">Chi tiết cấu hình #${setting.id}</li>
            </ol>
        </nav>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-sliders me-2 text-primary"></i>Chỉnh sửa cấu hình hệ thống</h5>

                    <form action="${pageContext.request.contextPath}/settings/save" method="POST">
                        <input type="hidden" name="id" value="${setting.id}">

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Loại cấu hình (Type)</label>
                            <input type="text" name="type" class="form-control" value="${setting.type}" readonly>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Tên hiển thị (Name) <span class="text-danger">*</span></label>
                                <input type="text" name="name" class="form-control" value="${setting.name}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Mã giá trị (Value) <span class="text-danger">*</span></label>
                                <input type="text" name="value" class="form-control" value="${setting.value}" required>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Độ ưu tiên (Priority)</label>
                                <input type="number" name="priority" value="${setting.priority}" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Trạng thái</label>
                                <select name="status" class="form-select">
                                    <option value="ACTIVE" ${setting.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE (Kích hoạt)</option>
                                    <option value="INACTIVE" ${setting.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE (Ngừng hoạt động)</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Mô tả chi tiết</label>
                            <textarea name="description" rows="3" class="form-control">${setting.description}</textarea>
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/settings/list" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                            </a>
                            <button type="submit" class="btn btn-primary fw-semibold px-4">
                                <i class="bi bi-save me-1"></i>Lưu cấu hình
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
