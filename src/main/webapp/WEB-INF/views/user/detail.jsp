<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Chi tiết người dùng - Courson LMS" />
<jsp:include page="../common/header.jsp" />

<c:set var="isSelf" value="${not empty sessionScope.CURRENT_USER and user.id == sessionScope.CURRENT_USER.id}" />

<style>
/* ==========================================================================
   MODERN SAAS DESIGN SYSTEM (User Details)
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
.saas-radio-card.disabled-card {
    opacity: 0.55;
    cursor: not-allowed;
    background-color: #f1f5f9;
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
                <li class="breadcrumb-item active fw-semibold text-dark">Chi tiết người dùng #${user.id}</li>
            </ol>
        </nav>

        <!-- Top Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="h3 fw-bold text-dark mb-1">
                    <span class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-3 me-2" style="width: 36px; height: 36px;">
                        <i class="bi bi-person-lines-fill"></i>
                    </span>
                    Chi tiết người dùng #${user.id}
                </h1>
                <p class="text-muted small mb-0">Xem hồ sơ, cập nhật thông tin liên hệ, phân quyền vai trò và đặt lại mật khẩu</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/users/list" class="btn-saas-outline" title="Back to User List">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </div>

        <!-- Success / Error Alerts -->
        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Lưu thông tin và phân quyền người dùng thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'password_and_info_updated'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Cập nhật thông tin và mật khẩu mới cho người dùng thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.success == 'password_reset'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-shield-check me-2"></i>Đã đặt lại mật khẩu thành công! Người dùng có thể đăng nhập bằng mật khẩu mới.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error || not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs mb-4 py-2 px-3 small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${not empty error ? error : param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- User Detail Form Card -->
        <div class="saas-card">
            <!-- Profile Overview Header inside Card -->
            <div class="d-flex align-items-center gap-3 pb-4 mb-4 border-bottom">
                <div class="rounded-circle d-flex align-items-center justify-content-center text-white fw-bold shadow-sm" style="width: 60px; height: 60px; background: linear-gradient(135deg, #2563eb, #1e40af); font-size: 1.5rem;">
                    ${fn:toUpperCase(fn:substring(user.fullName, 0, 1))}
                </div>
                <div>
                    <div class="d-flex align-items-center gap-2">
                        <h4 class="fw-bold text-dark mb-1">${user.fullName}</h4>
                        <c:if test="${isSelf}">
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1 small">
                                <i class="bi bi-person-fill me-1"></i>Tài khoản của bạn
                            </span>
                        </c:if>
                    </div>
                    <div class="d-flex flex-wrap align-items-center gap-2 small">
                        <span class="text-muted font-monospace">@${user.username}</span>
                        <span class="text-muted">•</span>
                        <span class="badge bg-light text-secondary border px-2 py-1">
                            <i class="bi bi-calendar3 me-1"></i>Đăng ký: ${user.formattedCreatedAt}
                        </span>
                        <span class="badge bg-light text-secondary border px-2 py-1">
                            Mã ID: #${user.id}
                        </span>
                        <c:if test="${user.enrolledCoursesCount > 0}">
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                                <i class="bi bi-mortarboard-fill me-1"></i>Đã tham gia ${user.enrolledCoursesCount} khóa học
                            </span>
                        </c:if>
                        <c:if test="${user.assignedCoursesCount > 0}">
                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                <i class="bi bi-briefcase-fill me-1"></i>Phụ trách ${user.assignedCoursesCount} khóa học
                            </span>
                        </c:if>
                    </div>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/users/save" method="POST">
                <input type="hidden" name="id" value="${user.id}">

                <div class="row g-4 mb-4">
                    <!-- Username (Read-only) -->
                    <div class="col-md-6">
                        <label class="saas-form-label">
                            Tên đăng nhập (Username) <span class="badge bg-light text-muted border ms-1">Chỉ đọc</span>
                        </label>
                        <input type="text" class="form-control saas-form-control font-monospace" value="${user.username}" readonly>
                        <div class="form-text small text-muted">Định danh duy nhất không thể chỉnh sửa sau khi tạo.</div>
                    </div>

                    <!-- Email Address (Read-only) -->
                    <div class="col-md-6">
                        <label class="saas-form-label">
                            Địa chỉ Email <span class="badge bg-light text-muted border ms-1">Chỉ đọc</span>
                        </label>
                        <input type="email" class="form-control saas-form-control" value="${user.email}" readonly>
                        <div class="form-text small text-muted">Email hệ thống xác thực của người dùng.</div>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <!-- Full Name (Editable, max 100) -->
                    <div class="col-md-6">
                        <label class="saas-form-label">
                            Họ và tên (Full Name) <span class="text-danger">*</span>
                        </label>
                        <input type="text" name="fullName" maxlength="100" class="form-control saas-form-control" value="${user.fullName}" required placeholder="Nhập đầy đủ họ và tên...">
                        <div class="form-text small text-muted">Tên hiển thị công khai trên chứng chỉ và hồ sơ (tối đa 100 ký tự).</div>
                    </div>

                    <!-- Phone (Editable) -->
                    <div class="col-md-6">
                        <label class="saas-form-label">Số điện thoại liên hệ</label>
                        <input type="text" name="phone" maxlength="20" class="form-control saas-form-control" value="${user.phone}" placeholder="Ví dụ: 0901234567">
                        <div class="form-text small text-muted">Số điện thoại liên lạc gồm 10 chữ số bắt đầu bằng số 0.</div>
                    </div>
                </div>

                <!-- Assigned Role (Dropdown with Role Lock Protection & Self-Protection) -->
                <div class="mb-4 p-3 bg-light rounded-3 border">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label class="saas-form-label text-primary fw-bold mb-0">
                            <i class="bi bi-shield-lock-fill me-1"></i>Phân vai trò hệ thống (Assigned Role) <span class="text-danger">*</span>
                        </label>
                        <c:choose>
                            <c:when test="${isSelf}">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                                    <i class="bi bi-shield-check me-1"></i>Vai trò quản trị của bạn
                                </span>
                            </c:when>
                            <c:when test="${user.roleLocked}">
                                <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-2 py-1">
                                    <i class="bi bi-lock-fill me-1"></i>Vai trò cố định
                                </span>
                            </c:when>
                        </c:choose>
                    </div>

                    <c:choose>
                        <c:when test="${isSelf}">
                            <div class="alert alert-info py-2 px-3 small rounded-2 mb-2 d-flex align-items-center gap-2">
                                <i class="bi bi-info-circle-fill text-primary fs-6"></i>
                                <span>Bạn đang chỉnh sửa tài khoản hiện tại. Quyền Quản trị viên (Admin) được giữ cố định để bảo vệ phiên làm việc.</span>
                            </div>
                            <input type="hidden" name="roleId" value="${user.roleId}">
                            <select class="form-select saas-form-control bg-light" disabled>
                                <c:forEach var="r" items="${roles}">
                                    <option value="${r.id}" ${user.roleId == r.id ? 'selected' : ''}>
                                        ${r.name} (${r.value}) - ${r.description}
                                    </option>
                                </c:forEach>
                            </select>
                        </c:when>
                        <c:when test="${user.roleLocked}">
                            <div class="alert alert-warning py-2 px-3 small rounded-2 mb-2 d-flex align-items-center gap-2">
                                <i class="bi bi-info-circle-fill text-warning fs-6"></i>
                                <span>${user.roleLockReason}</span>
                            </div>
                            <!-- Hidden input ensures the current roleId is kept intact -->
                            <input type="hidden" name="roleId" value="${user.roleId}">
                            <select class="form-select saas-form-control bg-light" disabled>
                                <c:forEach var="r" items="${roles}">
                                    <option value="${r.id}" ${user.roleId == r.id ? 'selected' : ''}>
                                        ${r.name} (${r.value}) - ${r.description}
                                    </option>
                                </c:forEach>
                            </select>
                        </c:when>
                        <c:otherwise>
                            <p class="small text-muted mb-2">Vai trò quyết định phạm vi quyền hạn và các màn hình người dùng được phép truy cập trong Courson LMS.</p>
                            <select name="roleId" class="form-select saas-form-control border-primary" required>
                                <c:forEach var="r" items="${roles}">
                                    <option value="${r.id}" ${user.roleId == r.id ? 'selected' : ''}>
                                        ${r.name} (${r.value}) - ${r.description}
                                    </option>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Account Status (Radio buttons: Active, Inactive, Suspended with Self Protection) -->
                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <label class="saas-form-label fw-bold mb-0">Trạng thái tài khoản (Account Status) <span class="text-danger">*</span></label>
                        <c:if test="${isSelf}">
                            <span class="badge bg-secondary-subtle text-secondary border px-2 py-1 small">
                                <i class="bi bi-lock-fill me-1"></i>Không thể tự khóa tài khoản hiện tại
                            </span>
                        </c:if>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="saas-radio-card w-100">
                                <input type="radio" name="status" value="ACTIVE" class="form-check-input mt-0" ${user.status == 'ACTIVE' ? 'checked' : ''}>
                                <div class="radio-label-box">
                                    <div class="fw-bold text-dark small"><i class="bi bi-check-circle-fill text-success me-1"></i>Active</div>
                                    <div class="text-muted" style="font-size: 0.725rem;">Được phép đăng nhập và hoạt động bình thường.</div>
                                </div>
                            </label>
                        </div>
                        <div class="col-md-4">
                            <label class="saas-radio-card w-100 ${isSelf ? 'disabled-card' : ''}">
                                <input type="radio" name="status" value="INACTIVE" class="form-check-input mt-0" ${user.status == 'INACTIVE' ? 'checked' : ''} ${isSelf ? 'disabled' : ''}>
                                <div class="radio-label-box">
                                    <div class="fw-bold text-dark small"><i class="bi bi-hourglass-split text-secondary me-1"></i>Inactive</div>
                                    <div class="text-muted" style="font-size: 0.725rem;">Chưa kích hoạt hoặc đang tạm dừng.</div>
                                </div>
                            </label>
                        </div>
                        <div class="col-md-4">
                            <label class="saas-radio-card w-100 ${isSelf ? 'disabled-card' : ''}">
                                <input type="radio" name="status" value="BANNED" class="form-check-input mt-0" ${user.status == 'BANNED' ? 'checked' : ''} ${isSelf ? 'disabled' : ''}>
                                <div class="radio-label-box">
                                    <div class="fw-bold text-danger small"><i class="bi bi-slash-circle-fill text-danger me-1"></i>Suspended</div>
                                    <div class="text-muted" style="font-size: 0.725rem;">Đình chỉ tài khoản, chặn quyền đăng nhập.</div>
                                </div>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Đặt lại / Cập nhật Mật khẩu (Password Reset / Update Section) -->
                <div class="mb-4 p-3 rounded-3 border" style="background-color: #fdfdfd;">
                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-2 gap-2">
                        <label class="saas-form-label fw-bold text-dark mb-0">
                            <i class="bi bi-key-fill text-warning me-1"></i>Đổi / Đặt lại mật khẩu (Reset Password)
                        </label>
                        <button type="button" class="btn btn-outline-secondary btn-sm d-inline-flex align-items-center gap-1" onclick="quickFillDefaultPassword()" style="font-size: 0.75rem; border-radius: 6px;">
                            <i class="bi bi-magic text-primary"></i>Điền nhanh: 123456
                        </button>
                    </div>
                    <p class="small text-muted mb-2">Để trống nếu không muốn đổi mật khẩu. Nếu nhập mật khẩu mới, hệ thống sẽ tự động băm mã hóa an toàn và cập nhật cho tài khoản.</p>
                    <div class="input-group">
                        <input type="password" id="detailNewPassword" name="newPassword" minlength="6" class="form-control saas-form-control" placeholder="Nhập mật khẩu mới nếu muốn thay đổi (tối thiểu 6 ký tự)...">
                        <button type="button" class="btn btn-outline-secondary" onclick="toggleDetailPasswordVisibility()" style="border-radius: 0 8px 8px 0; border-color: var(--saas-border);">
                            <i class="bi bi-eye" id="toggleDetailPasswordIcon"></i>
                        </button>
                    </div>
                </div>

                <!-- Read-only registration summary -->
                <div class="p-3 bg-light rounded-3 border mb-4">
                    <div class="row g-3 small">
                        <div class="col-md-6">
                            <span class="text-muted d-block">Ngày khởi tạo tài khoản (Registration Date):</span>
                            <span class="fw-bold text-dark">${user.formattedCreatedAt}</span>
                        </div>
                        <div class="col-md-6">
                            <span class="text-muted d-block">Mã định danh hệ thống (System User ID):</span>
                            <span class="fw-bold font-monospace text-dark">#${user.id}</span>
                        </div>
                    </div>
                </div>

                <!-- Form Action Buttons -->
                <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/users/list" class="btn-saas-outline">
                        <i class="bi bi-x-lg"></i> Hủy / Quay lại
                    </a>
                    <button type="submit" class="btn-saas-primary">
                        <i class="bi bi-check-lg"></i> Lưu Thay Đổi
                    </button>
                </div>
            </form>

            <!-- Danger Zone: Safe Account Deletion -->
            <c:if test="${not isSelf}">
                <div class="card mt-4 border-danger-subtle bg-danger-subtle bg-opacity-10">
                    <div class="card-body p-3 d-flex flex-wrap justify-content-between align-items-center gap-3">
                        <div>
                            <h6 class="text-danger fw-bold mb-1"><i class="bi bi-trash3 me-1"></i>Xóa tài khoản người dùng</h6>
                            <p class="text-muted small mb-0">Hệ thống áp dụng cơ chế xóa an toàn: chặn xóa nếu tài khoản có dữ liệu khóa học hoặc đăng ký học tập liên kết.</p>
                        </div>
                        <button type="button" class="btn btn-outline-danger btn-sm px-3 fw-semibold" onclick="openDeleteConfirmModal()">
                            <i class="bi bi-trash"></i> Xóa tài khoản
                        </button>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</main>

<!-- Modal Xác nhận Xóa Tài khoản -->
<c:if test="${not isSelf}">
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: var(--saas-radius-lg);">
            <div class="modal-header border-bottom py-3 px-4">
                <h5 class="modal-title fw-bold text-danger" id="deleteConfirmModalLabel">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>Xác nhận xóa tài khoản
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <div class="d-inline-flex align-items-center justify-content-center bg-danger bg-opacity-10 text-danger rounded-circle mb-3" style="width: 56px; height: 56px; font-size: 1.8rem;">
                    <i class="bi bi-trash3-fill"></i>
                </div>
                <h6 class="fw-bold text-dark mb-2">Bạn có chắc chắn muốn xóa tài khoản này?</h6>
                <p class="text-muted small mb-2">
                    Tài khoản: <strong>${user.fullName}</strong> (@${user.username})<br>
                    Mã định danh ID: <strong>#${user.id}</strong>
                </p>
                <div class="alert alert-warning py-2 px-3 small text-start rounded-2 mb-0">
                    <i class="bi bi-shield-lock-fill me-1"></i><strong>Quy tắc an toàn:</strong> Nếu tài khoản đã tham gia khóa học hoặc được phân công quản lý/giảng dạy, hệ thống sẽ tự động từ chối để tránh mất mát dữ liệu.
                </div>
            </div>
            <div class="modal-footer border-top py-3 px-4 d-flex justify-content-between">
                <button type="button" class="btn btn-outline-secondary btn-sm px-3" data-bs-dismiss="modal">Hủy bỏ</button>
                <a href="${pageContext.request.contextPath}/users/delete?id=${user.id}" class="btn btn-danger btn-sm fw-semibold px-4">
                    Đồng ý xóa
                </a>
            </div>
        </div>
    </div>
</div>
</c:if>

<script>
function toggleDetailPasswordVisibility() {
    var pwdInput = document.getElementById('detailNewPassword');
    var icon = document.getElementById('toggleDetailPasswordIcon');
    if (pwdInput.type === 'password') {
        pwdInput.type = 'text';
        icon.className = 'bi bi-eye-slash';
    } else {
        pwdInput.type = 'password';
        icon.className = 'bi bi-eye';
    }
}

function quickFillDefaultPassword() {
    var pwdInput = document.getElementById('detailNewPassword');
    pwdInput.value = '123456';
    pwdInput.type = 'text';
    var icon = document.getElementById('toggleDetailPasswordIcon');
    if (icon) icon.className = 'bi bi-eye-slash';
    pwdInput.focus();
}

function openDeleteConfirmModal() {
    var modalEl = document.getElementById('deleteConfirmModal');
    if (modalEl) {
        var bsModal = new bootstrap.Modal(modalEl);
        bsModal.show();
    }
}
</script>

<jsp:include page="../common/footer.jsp" />
