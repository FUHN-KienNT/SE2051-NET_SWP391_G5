<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Thêm người dùng mới - Courson LMS" />
<jsp:include page="../common/header.jsp" />

<style>
/* ==========================================================================
   MODERN SAAS DESIGN SYSTEM (New User Creation)
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
    padding: 30px;
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
.saas-form-control[readonly] {
    background-color: #f8fafc;
    color: #64748b;
    cursor: not-allowed;
    border-color: #e2e8f0;
}

/* Radio Cards */
.saas-radio-card {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    border: 1px solid var(--saas-border);
    border-radius: 8px;
    background: #ffffff;
    cursor: pointer;
    transition: all 0.15s ease;
}
.saas-radio-card:hover {
    border-color: #cbd5e1;
    background-color: #f8fafc;
}
.saas-radio-card:has(input[type="radio"]:checked) {
    border-color: var(--saas-accent);
    background-color: #eff6ff;
}

/* Buttons */
.btn-saas-primary {
    background: #0f172a;
    color: #ffffff;
    border: 1px solid #0f172a;
    font-size: 0.875rem;
    font-weight: 600;
    padding: 9px 22px;
    border-radius: var(--saas-radius-md);
    transition: all 0.15s ease;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    text-decoration: none;
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
    <div class="container" style="max-width: 900px;">
        <!-- Breadcrumb Navigation -->
        <nav class="mb-3">
            <ol class="breadcrumb small">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none text-muted">Admin Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/users/list" class="text-decoration-none text-muted">Quản lý người dùng</a></li>
                <li class="breadcrumb-item active fw-semibold text-dark">Thêm người dùng mới</li>
            </ol>
        </nav>

        <!-- Top Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="h3 fw-bold text-dark mb-1">
                    <span class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-3 me-2" style="width: 36px; height: 36px;">
                        <i class="bi bi-person-plus-fill"></i>
                    </span>
                    Thêm Người Dùng Mới (New User)
                </h1>
                <p class="text-muted small mb-0">Khởi tạo tài khoản nội bộ (Admin, Manager, Expert) hoặc học viên mới vào hệ thống Courson LMS</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/users/list" class="btn-saas-outline" title="Back to User List">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </div>

        <!-- Error Notification Alert -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- New User Form Card -->
        <div class="saas-card">
            <form action="${pageContext.request.contextPath}/users/create" method="POST">
                
                <!-- Account Info Section -->
                <div class="row g-4 mb-4">
                    <!-- Full Name -->
                    <div class="col-md-6">
                        <label class="saas-form-label">
                            Họ và tên (Full Name) <span class="text-danger">*</span>
                        </label>
                        <input type="text" name="fullName" maxlength="100" class="form-control saas-form-control" 
                               value="${formUser != null ? formUser.fullName : ''}" required placeholder="Ví dụ: Nguyễn Văn An">
                        <div class="form-text small text-muted">Tối đa 100 ký tự.</div>
                    </div>

                    <!-- Username -->
                    <div class="col-md-6">
                        <label class="saas-form-label">
                            Tên đăng nhập (Username) <span class="text-danger">*</span>
                        </label>
                        <input type="text" name="username" maxlength="50" class="form-control saas-form-control font-monospace" 
                               value="${formUser != null ? formUser.username : ''}" required placeholder="Ví dụ: nguyenvanan">
                        <div class="form-text small text-muted">Duy nhất, viết liền không dấu, tối đa 50 ký tự.</div>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <!-- Email Address -->
                    <div class="col-md-6">
                        <label class="saas-form-label">
                            Địa chỉ Email <span class="text-danger">*</span>
                        </label>
                        <input type="email" name="email" maxlength="100" class="form-control saas-form-control" 
                               value="${formUser != null ? formUser.email : ''}" required placeholder="Ví dụ: an.nguyen@courson.edu.vn">
                        <div class="form-text small text-muted">Duy nhất, dùng để đăng nhập và nhận thông báo.</div>
                    </div>

                    <!-- Initial Temporary Password -->
                    <div class="col-md-6">
                        <label class="saas-form-label">
                            Mật khẩu tạm thời (Password) <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <input type="password" id="rawPasswordInput" name="password" minlength="8" class="form-control saas-form-control" 
                                   required placeholder="Tối thiểu 8 ký tự...">
                            <button type="button" class="btn btn-outline-secondary" onclick="togglePasswordVisibility()" style="border-radius: 0 8px 8px 0; border-color: var(--saas-border);">
                                <i class="bi bi-eye" id="togglePasswordIcon"></i>
                            </button>
                        </div>
                        <div class="form-text small text-muted">Mật khẩu ban đầu có độ dài tối thiểu 8 ký tự.</div>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <!-- Phone -->
                    <div class="col-md-12">
                        <label class="saas-form-label">Số điện thoại liên hệ</label>
                        <input type="text" name="phone" maxlength="20" class="form-control saas-form-control" 
                               value="${formUser != null ? formUser.phone : ''}" placeholder="Ví dụ: 0901234567">
                    </div>
                </div>

                <!-- Assigned Role (Dropdown) -->
                <div class="mb-4 p-3 bg-light rounded-3 border">
                    <label class="saas-form-label text-primary fw-bold mb-1">
                        <i class="bi bi-shield-lock-fill me-1"></i>Phân vai trò tài khoản (Assigned Role) <span class="text-danger">*</span>
                    </label>
                    <p class="small text-muted mb-2">Chỉ định vai trò truy cập phù hợp với nhiệm vụ công việc hoặc học tập.</p>
                    <select name="roleId" class="form-select saas-form-control border-primary" required>
                        <option value="">-- Chọn vai trò hệ thống --</option>
                        <c:forEach var="r" items="${roles}">
                            <option value="${r.id}" ${formUser != null && formUser.roleId == r.id ? 'selected' : (r.name == 'Expert' ? 'selected' : '')}>
                                ${r.name} (${r.value}) - ${r.description}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Account Status (Radio buttons: Active, Inactive, Suspended) -->
                <div class="mb-4">
                    <label class="saas-form-label fw-bold mb-2">Trạng thái khởi tạo (Initial Account Status) <span class="text-danger">*</span></label>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="saas-radio-card w-100">
                                <input type="radio" name="status" value="ACTIVE" class="form-check-input mt-0" 
                                       ${formUser == null || formUser.status == 'ACTIVE' || empty formUser.status ? 'checked' : ''}>
                                <div class="radio-label-box">
                                    <div class="fw-bold text-dark small"><i class="bi bi-check-circle-fill text-success me-1"></i>Active</div>
                                    <div class="text-muted" style="font-size: 0.725rem;">Kích hoạt ngay, sẵn sàng đăng nhập.</div>
                                </div>
                            </label>
                        </div>
                        <div class="col-md-4">
                            <label class="saas-radio-card w-100">
                                <input type="radio" name="status" value="INACTIVE" class="form-check-input mt-0"
                                       ${formUser != null && formUser.status == 'INACTIVE' ? 'checked' : ''}>
                                <div class="radio-label-box">
                                    <div class="fw-bold text-dark small"><i class="bi bi-hourglass-split text-secondary me-1"></i>Inactive</div>
                                    <div class="text-muted" style="font-size: 0.725rem;">Tạm hoãn, chờ kích hoạt sau.</div>
                                </div>
                            </label>
                        </div>
                        <div class="col-md-4">
                            <label class="saas-radio-card w-100">
                                <input type="radio" name="status" value="BANNED" class="form-check-input mt-0"
                                       ${formUser != null && formUser.status == 'BANNED' ? 'checked' : ''}>
                                <div class="radio-label-box">
                                    <div class="fw-bold text-danger small"><i class="bi bi-slash-circle-fill text-danger me-1"></i>Suspended</div>
                                    <div class="text-muted" style="font-size: 0.725rem;">Tạm khóa ngay từ khi tạo.</div>
                                </div>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/users/list" class="btn-saas-outline">
                        <i class="bi bi-x-lg"></i> Hủy bỏ (Cancel)
                    </a>
                    <button type="submit" class="btn-saas-primary">
                        <i class="bi bi-person-check-fill"></i> Tạo Tài Khoản (Create User)
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<script>
function togglePasswordVisibility() {
    var pwdInput = document.getElementById('rawPasswordInput');
    var icon = document.getElementById('togglePasswordIcon');
    if (pwdInput.type === 'password') {
        pwdInput.type = 'text';
        icon.className = 'bi bi-eye-slash';
    } else {
        pwdInput.type = 'password';
        icon.className = 'bi bi-eye';
    }
}
</script>

<jsp:include page="../common/footer.jsp" />
