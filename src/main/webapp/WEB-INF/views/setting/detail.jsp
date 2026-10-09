<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Setting Details - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Breadcrumb -->
        <nav class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/settings/list">Settings</a></li>
                <li class="breadcrumb-item active">${empty setting.id ? 'New Setting' : 'Setting Details'}</li>
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
                    <h5 class="fw-bold mb-3"><i class="bi bi-sliders me-2 text-primary"></i>${empty setting.id ? 'Add New Setting' : 'Update Setting Details'}</h5>

                    <form action="${pageContext.request.contextPath}/settings/save" method="POST" id="settingForm">
                        <input type="hidden" name="id" value="${setting.id}">

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Type <span class="text-danger">*</span></label>
                            <select name="type" class="form-select" required>
                                <option value="USER_ROLE" ${setting.type == 'USER_ROLE' ? 'selected' : ''}>USER_ROLE</option>
                                <option value="COURSE_CATEGORY" ${setting.type == 'COURSE_CATEGORY' ? 'selected' : ''}>COURSE_CATEGORY</option>
                            </select>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Name <span class="text-danger">*</span></label>
                                <input type="text" name="name" class="form-control" value="${setting.name}" required maxlength="20" pattern="[^\d]*" title="Non-digit string, max 20 chars">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Value <span class="text-danger">*</span></label>
                                <input type="text" name="value" class="form-control" value="${setting.value}" required maxlength="100">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Priority <span class="text-danger">*</span></label>
                            <input type="number" name="priority" value="${not empty setting.priority ? setting.priority : '1'}" class="form-control" required min="1">
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold d-block">Status <span class="text-danger">*</span></label>
                            <div class="form-check form-check-inline mt-2">
                                <input class="form-check-input" type="radio" name="status" id="statusActive" value="ACTIVE" ${empty setting.id || setting.status == 'ACTIVE' ? 'checked' : ''}>
                                <label class="form-check-label" for="statusActive">Active</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="status" id="statusInactive" value="INACTIVE" ${not empty setting.id && setting.status == 'INACTIVE' ? 'checked' : ''}>
                                <label class="form-check-label" for="statusInactive">Inactive</label>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Description</label>
                            <textarea name="description" rows="3" class="form-control" maxlength="200">${setting.description}</textarea>
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/settings/list" class="btn btn-outline-secondary">
                                <i class="bi bi-x-lg me-1"></i>Cancel / Back
                            </a>
                            <button type="submit" class="btn btn-primary fw-semibold px-4">
                                <i class="bi bi-save me-1"></i>Save Setting
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
document.getElementById('settingForm').addEventListener('submit', function(e) {
    var nameInput = document.querySelector('input[name="name"]').value;
    if (/\d/.test(nameInput)) {
        e.preventDefault();
        alert('Name must be a non-digit string.');
    }
});
</script>

<jsp:include page="../common/footer.jsp" />
