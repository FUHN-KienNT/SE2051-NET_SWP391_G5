<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Setting Details - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<style>
/* ==========================================================================
   MODERN SAAS DESIGN SYSTEM (Setting Details)
   ========================================================================== */
:root {
    --saas-bg: #f8fafc;
    --saas-card-bg: #ffffff;
    --saas-border: #e2e8f0;
    --saas-border-subtle: #f1f5f9;
    --saas-text-heading: #0f172a;
    --saas-text-body: #334155;
    --saas-text-muted: #64748b;
    --saas-primary: #0f172a;
    --saas-accent: #2563eb;
    --saas-radius-md: 10px;
    --saas-radius-lg: 14px;
    --saas-shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.06), 0 1px 2px -1px rgba(0, 0, 0, 0.04);
}

body {
    background-color: var(--saas-bg);
    color: var(--saas-text-body);
}


.saas-card {
    background: var(--saas-card-bg);
    border: 1px solid var(--saas-border);
    border-radius: var(--saas-radius-lg);
    box-shadow: var(--saas-shadow-sm);
    padding: 28px;
}

.saas-form-label {
    font-size: 0.8125rem;
    font-weight: 600;
    color: var(--saas-text-heading);
    margin-bottom: 6px;
    display: block;
}

.saas-form-control {
    border-radius: 8px;
    border: 1px solid var(--saas-border);
    padding: 9px 14px;
    font-size: 0.875rem;
    color: var(--saas-text-heading);
    transition: all 0.15s ease;
    background-color: #ffffff;
}
.saas-form-control:focus {
    border-color: var(--saas-accent);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    outline: none;
    background-color: #ffffff;
}

.btn-saas-primary {
    background: #0f172a;
    color: #ffffff;
    border: 1px solid #0f172a;
    font-size: 0.875rem;
    font-weight: 600;
    padding: 9px 20px;
    border-radius: var(--saas-radius-md);
    transition: all 0.15s ease;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}
.btn-saas-primary:hover {
    background: #1e293b;
    border-color: #1e293b;
    color: #ffffff;
}

.btn-saas-outline {
    background: #ffffff;
    border: 1px solid var(--saas-border);
    color: #475569;
    font-size: 0.875rem;
    font-weight: 600;
    padding: 9px 18px;
    border-radius: var(--saas-radius-md);
    transition: all 0.15s ease;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}
.btn-saas-outline:hover {
    background: #f8fafc;
    border-color: #cbd5e1;
    color: #0f172a;
}
</style>

<main class="main-content py-4">
    <div class="container">
        <!-- Breadcrumb -->
        <nav class="mb-4">
            <ol class="breadcrumb small mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none text-muted">Admin Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/settings/list" class="text-decoration-none text-muted">Settings</a></li>
                <li class="breadcrumb-item active text-dark fw-semibold">${empty setting.id ? 'Thêm mới' : 'Chi tiết cấu hình'}</li>
            </ol>
        </nav>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row justify-content-center">
            <div class="col-lg-9 col-xl-8">
                <div class="saas-card">
            <div class="d-flex align-items-center gap-3 pb-3 mb-4 border-bottom">
                <div class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-3" style="width: 44px; height: 44px; font-size: 1.25rem;">
                    <i class="bi bi-sliders"></i>
                </div>
                <div>
                    <h2 class="h5 fw-bold mb-1 text-dark">${empty setting.id ? 'Thêm Cấu Hình Hệ Thống Mới' : 'Cập Nhật Cấu Hình Hệ Thống'}</h2>
                    <p class="text-muted small mb-0">Thiết lập tham số master data cho phân quyền hoặc danh mục</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/settings/save" method="POST" id="settingForm">
                <input type="hidden" name="id" value="${setting.id}">

                <div class="mb-4">
                    <label class="saas-form-label">Loại cấu hình (Type) <span class="text-danger">*</span></label>
                    <select name="type" class="form-select saas-form-control" required>
                        <option value="USER_ROLE" ${setting.type == 'USER_ROLE' ? 'selected' : ''}>USER_ROLE (Vai trò người dùng trong hệ thống)</option>
                        <option value="COURSE_CATEGORY" ${setting.type == 'COURSE_CATEGORY' ? 'selected' : ''}>COURSE_CATEGORY (Danh mục khóa học)</option>
                    </select>
                    <small class="text-muted d-block mt-1">Lưu ý: Không đổi loại cấu hình nếu cấu hình này đang được liên kết với Người dùng hoặc Khóa học.</small>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="saas-form-label">Tên hiển thị (Name) <span class="text-danger">*</span></label>
                        <input type="text" name="name" class="form-control saas-form-control" value="${setting.name}" required maxlength="20" pattern="[^\d]*" title="Không chứa chữ số, tối đa 20 ký tự" placeholder="VD: Công nghệ thông tin">
                        <small class="text-muted">Chỉ chứa chữ cái, tối đa 20 ký tự</small>
                    </div>
                    <div class="col-md-6">
                        <label class="saas-form-label">Giá trị định danh (Value) <span class="text-danger">*</span></label>
                        <input type="text" name="value" class="form-control saas-form-control" value="${setting.value}" required maxlength="100" placeholder="VD: IT_DEV">
                        <small class="text-muted">Mã định danh duy nhất (VD: ROLE_ADMIN, IT)</small>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="saas-form-label">Thứ tự ưu tiên (Priority) <span class="text-danger">*</span></label>
                        <input type="number" name="priority" value="${not empty setting.priority ? setting.priority : '1'}" class="form-control saas-form-control" required min="1">
                        <small class="text-muted">Số nguyên dương (1 là ưu tiên cao nhất)</small>
                    </div>
                    <div class="col-md-6">
                        <label class="saas-form-label">Trạng thái (Status) <span class="text-danger">*</span></label>
                        <div class="d-flex align-items-center gap-4 mt-2">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="status" id="statusActive" value="ACTIVE" ${empty setting.id || setting.status == 'ACTIVE' ? 'checked' : ''}>
                                <label class="form-check-label fw-semibold text-success" for="statusActive">
                                    <i class="bi bi-check-circle-fill me-1"></i> Active (Kích hoạt)
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="status" id="statusInactive" value="INACTIVE" ${not empty setting.id && setting.status == 'INACTIVE' ? 'checked' : ''}>
                                <label class="form-check-label fw-semibold text-secondary" for="statusInactive">
                                    <i class="bi bi-dash-circle-fill me-1"></i> Inactive (Vô hiệu)
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="saas-form-label">Mô tả chi tiết (Description)</label>
                    <textarea name="description" rows="3" class="form-control saas-form-control" maxlength="200" placeholder="Nhập ghi chú hoặc mô tả về vai trò hoặc danh mục này...">${setting.description}</textarea>
                    <div class="d-flex justify-content-end text-muted small mt-1">Tối đa 200 ký tự</div>
                </div>

                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-4">
                    <a href="${pageContext.request.contextPath}/settings/list" class="btn-saas-outline">
                        <i class="bi bi-arrow-left"></i> Quay lại Danh sách
                    </a>
                    <button type="submit" class="btn-saas-primary">
                        <i class="bi bi-check2-circle"></i> ${empty setting.id ? 'Tạo Cấu Hình' : 'Lưu Thay Đổi'}
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
        alert('Tên cấu hình (Name) không được chứa chữ số.');
    }
});
</script>

<jsp:include page="../common/footer.jsp" />
