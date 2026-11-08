<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Hồ sơ cá nhân - Courson LMS" />
<jsp:include page="../common/header.jsp" />

<style>
    .cf-profile-wrapper {
        max-width: 960px;
        margin: 0 auto;
    }
    .cf-profile-card {
        background: #ffffff;
        border: 1px solid #E2E8F0;
        border-radius: 18px;
        padding: 36px 40px;
        box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05), 0 6px 12px -4px rgba(0, 0, 0, 0.02);
    }
    .cf-profile-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding-bottom: 24px;
        margin-bottom: 28px;
        border-bottom: 1px solid #F1F5F9;
    }
    .cf-profile-title {
        font-size: 1.65rem;
        font-weight: 800;
        color: #0F172A;
        letter-spacing: -0.5px;
        margin-bottom: 0;
    }
    /* Đổi mật khẩu button using project brand orange tone */
    .cf-change-pwd-link {
        display: inline-flex;
        align-items: center;
        color: #F38020;
        background-color: #FFF5EB;
        border: 1.5px solid #FEEBD6;
        padding: 8px 20px;
        border-radius: 10px;
        font-size: 0.95rem;
        font-weight: 700;
        text-decoration: none;
        transition: all 0.2s ease;
    }
    .cf-change-pwd-link:hover {
        background-color: #F38020;
        border-color: #F38020;
        color: #FFFFFF;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(243, 128, 32, 0.25);
    }
    .cf-form-label {
        font-size: 0.92rem;
        font-weight: 600;
        color: #334155;
        margin-bottom: 7px;
        display: flex;
        align-items: center;
    }
    .cf-form-control {
        border: 1.5px solid #CBD5E1;
        border-radius: 10px;
        padding: 10px 14px;
        font-size: 0.95rem;
        color: #1E293B;
        transition: all 0.2s ease;
        background-color: #FFFFFF;
    }
    .cf-form-control:focus {
        border-color: #F38020;
        box-shadow: 0 0 0 3px rgba(243, 128, 32, 0.18);
        outline: none;
    }
    .cf-form-control:disabled, .cf-form-control[readonly] {
        background-color: #F1F5F9;
        border-color: #E2E8F0;
        color: #64748B;
        cursor: not-allowed;
    }

    /* Avatar block styled matching wireframe image (Circular avatar + text + 2 buttons) */
    .cf-avatar-block {
        display: flex;
        align-items: center;
        gap: 24px;
        margin-bottom: 28px;
        padding: 18px 20px;
        background-color: #F8FAFC;
        border: 1px solid #E2E8F0;
        border-radius: 16px;
    }
    .cf-avatar-preview-wrap {
        width: 84px;
        height: 84px;
        border-radius: 50%;
        overflow: hidden;
        flex-shrink: 0;
        border: 2px solid #E2E8F0;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #FAAD3F 0%, #F38020 100%);
    }
    .cf-avatar-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .cf-avatar-initial {
        font-size: 2.2rem;
        font-weight: 700;
        color: #FFFFFF;
        user-select: none;
    }
    .cf-avatar-actions-wrap {
        flex: 1;
    }
    .cf-avatar-hint-text {
        color: #475569;
        font-size: 0.93rem;
        font-weight: 500;
        margin-bottom: 12px;
    }
    .cf-avatar-btns-group {
        display: flex;
        align-items: center;
        gap: 14px;
    }
    .cf-btn-upload {
        background-color: #FFFFFF;
        color: #1E293B;
        border: 1.5px solid #CBD5E1;
        padding: 7px 18px;
        font-size: 0.92rem;
        font-weight: 600;
        border-radius: 8px;
        transition: all 0.2s ease;
        cursor: pointer;
    }
    .cf-btn-upload:hover {
        border-color: #F38020;
        color: #F38020;
        background-color: #FFF5EB;
    }
    .cf-btn-remove {
        background: transparent;
        color: #475569;
        border: none;
        padding: 7px 12px;
        font-size: 0.92rem;
        font-weight: 600;
        transition: color 0.2s ease;
        cursor: pointer;
    }
    .cf-btn-remove:hover {
        color: #DC2626;
    }

    /* Save Changes Button (clean, no checkmark icon) */
    .cf-btn-save {
        background: linear-gradient(135deg, #F38020 0%, #E56B00 100%);
        color: #FFFFFF;
        border: none;
        padding: 11px 34px;
        font-size: 1rem;
        font-weight: 700;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(243, 128, 32, 0.28);
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
    }
    .cf-btn-save:hover {
        background: linear-gradient(135deg, #E56B00 0%, #CF5A00 100%);
        box-shadow: 0 6px 16px rgba(243, 128, 32, 0.38);
        transform: translateY(-1px);
        color: #FFFFFF;
    }
    .cf-btn-save:active {
        transform: translateY(0);
    }
    .cf-btn-save:disabled {
        background: #94A3B8;
        box-shadow: none;
        cursor: not-allowed;
    }

    .field-error-text {
        font-size: 0.82rem;
        color: #DC2626;
        margin-top: 5px;
        display: none;
    }
    .role-tag {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 0.84rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.4px;
    }
    .role-tag.student { background: #EFF6FF; color: #1E40AF; }
    .role-tag.expert  { background: #FAF5FF; color: #6B21A8; }
    .role-tag.admin   { background: #FEF2F2; color: #991B1B; }
    .role-tag.manager { background: #ECFDF5; color: #065F46; }
</style>

<main class="main-content py-5" style="background-color: #F8FAFC; min-height: 80vh;">
    <div class="container">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/home" class="text-decoration-none text-muted">
                        <i class="bi bi-house-door me-1"></i>Trang chủ
                    </a>
                </li>
                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Hồ sơ cá nhân</li>
            </ol>
        </nav>

        <c:set var="displayName" value="${not empty user.fullName ? user.fullName : user.username}" />
        <c:set var="userInitial" value="${fn:toUpperCase(fn:substring(displayName, 0, 1))}" />

        <div class="cf-profile-wrapper">
            <div class="cf-profile-card">
                <!-- Header: Hồ sơ cá nhân + Nút Đổi mật khẩu -->
                <div class="cf-profile-header">
                    <div>
                        <h1 class="cf-profile-title">Hồ sơ cá nhân</h1>
                        <p class="text-muted small mb-0 mt-1">Quản lý và cập nhật thông tin tài khoản cá nhân của bạn trên Courson LMS</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/profile/change-password" class="cf-change-pwd-link" title="Đổi mật khẩu tài khoản">
                            Đổi mật khẩu
                        </a>
                    </div>
                </div>

                <!-- Server Error Alert -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2 fs-5"></i>
                        <div><c:out value="${error}" /></div>
                    </div>
                </c:if>

                <!-- Profile Form -->
                <form id="profileForm" action="${pageContext.request.contextPath}/profile" method="POST" enctype="multipart/form-data" novalidate>
                    <input type="hidden" name="action" value="update" />
                    <input type="hidden" id="removeAvatarInput" name="removeAvatar" value="false" />

                    <!-- Avatar Section (Giống ảnh 2: Avatar tròn, Text 15MB, Nút Tải ảnh lên & Xóa ảnh) -->
                    <div class="cf-avatar-block">
                        <div class="cf-avatar-preview-wrap" id="avatarPreviewContainer">
                            <c:choose>
                                <c:when test="${not empty user.avatarUrl}">
                                    <img src="${pageContext.request.contextPath}${user.avatarUrl}" id="avatarPreviewImg" class="cf-avatar-img" alt="Avatar" />
                                    <div id="avatarPreviewInitial" class="cf-avatar-initial" style="display: none;">${userInitial}</div>
                                </c:when>
                                <c:otherwise>
                                    <img src="" id="avatarPreviewImg" class="cf-avatar-img" style="display: none;" alt="Avatar" />
                                    <div id="avatarPreviewInitial" class="cf-avatar-initial">${userInitial}</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="cf-avatar-actions-wrap">
                            <div class="cf-avatar-hint-text">
                                Dung lượng tối đa: 15MB. Định dạng hỗ trợ: JPG, PNG hoặc WEBP.
                            </div>
                            <div class="cf-avatar-btns-group">
                                <button type="button" id="btnUploadAvatar" class="cf-btn-upload">Tải ảnh lên</button>
                                <button type="button" id="btnRemoveAvatar" class="cf-btn-remove">Xóa ảnh</button>
                            </div>
                            <!-- Hidden File Input -->
                            <input type="file" id="avatarInput" name="avatar" accept="image/jpeg,image/png,image/webp" style="display: none;" />
                            <div id="avatarError" class="field-error-text"></div>
                        </div>
                    </div>

                    <!-- Row 1: Họ và tên & Tên người dùng -->
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="cf-form-label" for="fullNameInput">Họ và tên</label>
                            <input type="text" id="fullNameInput" name="fullName" class="form-control cf-form-control"
                                   value="<c:out value='${user.fullName}'/>" placeholder="Nhập họ và tên" required />
                            <div id="fullNameError" class="field-error-text"></div>
                        </div>
                        <div class="col-md-6">
                            <label class="cf-form-label" for="usernameInput">Tên người dùng</label>
                            <input type="text" id="usernameInput" name="username" class="form-control cf-form-control"
                                   value="<c:out value='${user.username}'/>" placeholder="Nhập tên người dùng" required />
                            <div id="usernameError" class="field-error-text"></div>
                        </div>
                    </div>

                    <!-- Row 2: Email & Số điện thoại -->
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="cf-form-label" for="emailInput">Email</label>
                            <input type="email" id="emailInput" class="form-control cf-form-control"
                                   value="<c:out value='${user.email}'/>" disabled readonly />
                            <small class="form-text text-muted">Email định danh tài khoản cố định, không được phép thay đổi.</small>
                        </div>
                        <div class="col-md-6">
                            <label class="cf-form-label" for="phoneInput">Số điện thoại</label>
                            <input type="tel" id="phoneInput" name="phone" class="form-control cf-form-control"
                                   value="<c:out value='${user.phone}'/>" placeholder="0912345678" />
                            <div id="phoneError" class="field-error-text"></div>
                        </div>
                    </div>

                    <!-- Row 3: Ngày sinh & Vai trò (chỉ hiển thị Học viên) -->
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="cf-form-label" for="birthDateInput">Ngày sinh</label>
                            <input type="date" id="birthDateInput" name="birthDate" class="form-control cf-form-control"
                                   value="${user.birthDate}" />
                            <div id="birthDateError" class="field-error-text"></div>
                        </div>
                        <div class="col-md-6">
                            <label class="cf-form-label">Vai trò</label>
                            <div class="p-2 border rounded-3 bg-light d-flex align-items-center" style="min-height: 44px;">
                                <c:choose>
                                    <c:when test="${user.roleName == 'STUDENT'}">
                                        <span class="role-tag student"><i class="bi bi-mortarboard-fill"></i> Học viên</span>
                                    </c:when>
                                    <c:when test="${user.roleName == 'EXPERT'}">
                                        <span class="role-tag expert"><i class="bi bi-person-badge-fill"></i> Chuyên gia</span>
                                    </c:when>
                                    <c:when test="${user.roleName == 'ADMIN'}">
                                        <span class="role-tag admin"><i class="bi bi-shield-fill-check"></i> Quản trị viên</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="role-tag manager"><i class="bi bi-briefcase-fill"></i> Quản lý</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Row 4: Tiểu sử / Mô tả bản thân -->
                    <div class="mb-4">
                        <label class="cf-form-label mb-1" for="bioTextarea">Tiểu sử</label>
                        <textarea id="bioTextarea" name="bio" rows="4" class="form-control cf-form-control"
                                  placeholder="Mô tả tóm tắt kinh nghiệm, chuyên môn hoặc định hướng học tập của bạn..."><c:out value="${user.bio}"/></textarea>
                        <div class="mt-1">
                            <small class="form-text text-muted">Giới hạn tối đa 250 từ.</small>
                        </div>
                        <div id="bioError" class="field-error-text"></div>
                    </div>

                    <!-- Nút Lưu thay đổi (không có icon dấu tích) -->
                    <div class="pt-2">
                        <button type="submit" id="btnSubmitProfile" class="cf-btn-save">
                            <span id="btnSubmitText">Lưu thay đổi</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('profileForm');
        const btnUploadAvatar = document.getElementById('btnUploadAvatar');
        const btnRemoveAvatar = document.getElementById('btnRemoveAvatar');
        const avatarInput = document.getElementById('avatarInput');
        const removeAvatarInput = document.getElementById('removeAvatarInput');
        const avatarPreviewImg = document.getElementById('avatarPreviewImg');
        const avatarPreviewInitial = document.getElementById('avatarPreviewInitial');
        const fullNameInput = document.getElementById('fullNameInput');
        const usernameInput = document.getElementById('usernameInput');
        const phoneInput = document.getElementById('phoneInput');
        const birthDateInput = document.getElementById('birthDateInput');
        const bioTextarea = document.getElementById('bioTextarea');
        const btnSubmit = document.getElementById('btnSubmitProfile');
        const btnSubmitText = document.getElementById('btnSubmitText');

        // Initial setup for avatar buttons
        btnUploadAvatar.addEventListener('click', function() {
            avatarInput.click();
        });

        btnRemoveAvatar.addEventListener('click', function() {
            avatarInput.value = '';
            removeAvatarInput.value = 'true';
            avatarPreviewImg.style.display = 'none';
            avatarPreviewImg.src = '';
            avatarPreviewInitial.style.display = 'flex';
            clearError('avatarError', 'avatarInput');
        });

        bioTextarea.addEventListener('input', () => clearError('bioError', 'bioTextarea'));

        // Live Avatar preview when choosing file
        avatarInput.addEventListener('change', function() {
            const file = this.files && this.files[0];
            if (!file) return;

            // Validate file size (15MB)
            if (file.size > 15 * 1024 * 1024) {
                showError('avatarError', 'avatarInput', 'Dung lượng ảnh vượt quá 15MB. Vui lòng chọn ảnh khác.');
                this.value = '';
                return;
            }

            // Validate extension
            const ext = file.name.split('.').pop().toLowerCase();
            if (!['jpg', 'jpeg', 'png', 'webp'].includes(ext)) {
                showError('avatarError', 'avatarInput', 'Định dạng file không hỗ trợ. Chỉ chấp nhận JPG, PNG, WEBP.');
                this.value = '';
                return;
            }

            removeAvatarInput.value = 'false';
            clearError('avatarError', 'avatarInput');

            // Show preview
            const reader = new FileReader();
            reader.onload = function(evt) {
                avatarPreviewImg.src = evt.target.result;
                avatarPreviewImg.style.display = 'block';
                if (avatarPreviewInitial) avatarPreviewInitial.style.display = 'none';
            };
            reader.readAsDataURL(file);
        });

        function showError(errorId, inputId, message) {
            const errEl = document.getElementById(errorId);
            const inputEl = document.getElementById(inputId);
            if (errEl) {
                errEl.textContent = message;
                errEl.style.display = 'block';
            }
            if (inputEl) {
                inputEl.style.borderColor = '#DC2626';
            }
        }

        function clearError(errorId, inputId) {
            const errEl = document.getElementById(errorId);
            const inputEl = document.getElementById(inputId);
            if (errEl) {
                errEl.textContent = '';
                errEl.style.display = 'none';
            }
            if (inputEl) {
                inputEl.style.borderColor = '#CBD5E1';
            }
        }

        fullNameInput.addEventListener('input', () => clearError('fullNameError', 'fullNameInput'));
        usernameInput.addEventListener('input', () => clearError('usernameError', 'usernameInput'));
        phoneInput.addEventListener('input', () => clearError('phoneError', 'phoneInput'));
        birthDateInput.addEventListener('change', () => clearError('birthDateError', 'birthDateInput'));

        // Form submission
        form.addEventListener('submit', function(e) {
            let isValid = true;

            // 1. Họ và tên
            const fullName = fullNameInput.value.trim();
            if (!fullName) {
                showError('fullNameError', 'fullNameInput', 'Họ và tên không được để trống.');
                isValid = false;
            } else if (fullName.length < 3 || fullName.length > 50) {
                showError('fullNameError', 'fullNameInput', 'Họ và tên phải từ 3 đến 50 ký tự.');
                isValid = false;
            } else {
                clearError('fullNameError', 'fullNameInput');
            }

            // 2. Tên người dùng
            const username = usernameInput.value.trim();
            const usernameRe = /^[a-zA-Z0-9_]{4,30}$/;
            if (!username) {
                showError('usernameError', 'usernameInput', 'Tên người dùng không được để trống.');
                isValid = false;
            } else if (!usernameRe.test(username)) {
                showError('usernameError', 'usernameInput', 'Tên người dùng phải từ 4-30 ký tự, chỉ gồm chữ cái, số hoặc dấu gạch dưới (_).');
                isValid = false;
            } else {
                clearError('usernameError', 'usernameInput');
            }

            // 3. Số điện thoại (tùy chọn)
            const phone = phoneInput.value.trim();
            if (phone) {
                const phoneCleaned = phone.replace(/\s+/g, '');
                const vnPhoneRe = /^(0|\+84)(3[2-9]|5[25689]|7[06-9]|8[1-9]|9[0-9])[0-9]{7}$/;
                if (!vnPhoneRe.test(phoneCleaned)) {
                    showError('phoneError', 'phoneInput', 'Số điện thoại không hợp lệ (gồm 10 chữ số đầu mạng VN hợp lệ, bắt đầu bằng 0 hoặc +84).');
                    isValid = false;
                } else {
                    clearError('phoneError', 'phoneInput');
                }
            } else {
                clearError('phoneError', 'phoneInput');
            }

            // 4. Ngày sinh (tùy chọn)
            const birthDate = birthDateInput.value;
            if (birthDate) {
                const bDate = new Date(birthDate);
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                if (bDate > today) {
                    showError('birthDateError', 'birthDateInput', 'Ngày sinh không được ở tương lai.');
                    isValid = false;
                } else {
                    let age = today.getFullYear() - bDate.getFullYear();
                    const m = today.getMonth() - bDate.getMonth();
                    if (m < 0 || (m === 0 && today.getDate() < bDate.getDate())) {
                        age--;
                    }
                    if (age < 10) {
                        showError('birthDateError', 'birthDateInput', 'Độ tuổi tối thiểu là 10 tuổi.');
                        isValid = false;
                    } else if (age > 120) {
                        showError('birthDateError', 'birthDateInput', 'Độ tuổi không hợp lệ (tối đa 120 tuổi).');
                        isValid = false;
                    } else {
                        clearError('birthDateError', 'birthDateInput');
                    }
                }
            } else {
                clearError('birthDateError', 'birthDateInput');
            }

            if (!isValid) {
                e.preventDefault();
                return;
            }

            // Submit via AJAX FormData
            e.preventDefault();

            btnSubmit.disabled = true;
            btnSubmitText.textContent = 'Đang lưu...';

            const formData = new FormData(form);

            fetch('${pageContext.request.contextPath}/profile', {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                btnSubmit.disabled = false;
                btnSubmitText.textContent = 'Lưu thay đổi';

                if (data.success) {
                    const rawAvatarUrl = data.avatarUrl || data.value;
                    const newFullName = fullNameInput.value.trim();
                    const newInitial = newFullName ? newFullName.substring(0, 1).toUpperCase() : 'U';
                    const isExplicitRemove = (removeAvatarInput.value === 'true');

                    const contextPath = '${pageContext.request.contextPath}';
                    let resolvedAvatarUrl = rawAvatarUrl;
                    if (resolvedAvatarUrl && !resolvedAvatarUrl.startsWith('http://') && !resolvedAvatarUrl.startsWith('https://')) {
                        if (contextPath && !resolvedAvatarUrl.startsWith(contextPath)) {
                            resolvedAvatarUrl = contextPath + (resolvedAvatarUrl.startsWith('/') ? resolvedAvatarUrl : '/' + resolvedAvatarUrl);
                        }
                    }

                    // 1. Cập nhật ngay lập tức toàn bộ Avatar trên trang cá nhân và thanh Navbar / Dropdown Menu
                    if (isExplicitRemove) {
                        // Người dùng đã bấm "Xóa ảnh" và nhấn Lưu thay đổi
                        document.querySelectorAll('.navbar-avatar-img').forEach(img => {
                            img.style.display = 'none';
                            img.src = '';
                        });
                        document.querySelectorAll('.navbar-avatar-text').forEach(el => {
                            el.textContent = newInitial;
                            el.style.display = 'flex';
                        });
                        if (avatarPreviewImg) {
                            avatarPreviewImg.style.display = 'none';
                            avatarPreviewImg.src = '';
                        }
                        if (avatarPreviewInitial) {
                            avatarPreviewInitial.textContent = newInitial;
                            avatarPreviewInitial.style.display = 'flex';
                        }
                    } else if (resolvedAvatarUrl && resolvedAvatarUrl.length > 0) {
                        // Có URL ảnh hợp lệ (ảnh vừa tải lên hoặc avatar hiện tại)
                        const cacheBuster = resolvedAvatarUrl.includes('?')
                            ? (resolvedAvatarUrl + '&t=' + Date.now())
                            : (resolvedAvatarUrl + '?t=' + Date.now());

                        document.querySelectorAll('.navbar-avatar-img').forEach(img => {
                            img.src = cacheBuster;
                            img.style.display = 'inline-block';
                        });
                        document.querySelectorAll('.navbar-avatar-text').forEach(el => {
                            el.style.display = 'none';
                        });

                        if (avatarPreviewImg) {
                            avatarPreviewImg.src = cacheBuster;
                            avatarPreviewImg.style.display = 'block';
                        }
                        if (avatarPreviewInitial) {
                            avatarPreviewInitial.style.display = 'none';
                        }
                    } else {
                        // Không có URL trả về và không chủ động xóa ảnh:
                        // Giữ nguyên preview ảnh hiện tại (tuyệt đối không reset về chữ cái đại diện!)
                        document.querySelectorAll('.navbar-avatar-text').forEach(el => {
                            if (el.style.display !== 'none') {
                                el.textContent = newInitial;
                            }
                        });
                    }

                    // 2. Cập nhật tên hiển thị trên header và menu dropdown
                    document.querySelectorAll('.cf-account-header .fw-bold, .cf-user-name').forEach(el => {
                        el.textContent = newFullName;
                    });

                    // Reset trạng thái file & remove flag
                    avatarInput.value = '';
                    removeAvatarInput.value = 'false';

                    // Hiển thị thông báo thành công
                    if (window.CoursonToast) {
                        window.CoursonToast.show('success', data.message || 'Cập nhật thông tin hồ sơ thành công!', 8000);
                    }
                } else {
                    if (data.field === 'fullName' || (data.message && data.message.includes('Họ và tên'))) {
                        showError('fullNameError', 'fullNameInput', data.message);
                    } else if (data.field === 'username' || (data.message && data.message.includes('người dùng'))) {
                        showError('usernameError', 'usernameInput', data.message);
                    } else if (data.field === 'phone' || (data.message && data.message.includes('thoại'))) {
                        showError('phoneError', 'phoneInput', data.message);
                    } else if (data.field === 'birthDate' || (data.message && (data.message.includes('sinh') || data.message.includes('tuổi')))) {
                        showError('birthDateError', 'birthDateInput', data.message);
                    } else if (data.field === 'bio' || (data.message && (data.message.includes('Tiểu sử') || data.message.includes('Mô tả')))) {
                        showError('bioError', 'bioTextarea', data.message);
                    } else if (data.field === 'avatar') {
                        showError('avatarError', 'avatarInput', data.message);
                    }
                    if (window.CoursonToast) {
                        window.CoursonToast.show('error', data.message || 'Cập nhật hồ sơ thất bại.', 8000);
                    }
                }
            })
            .catch(err => {
                btnSubmit.disabled = false;
                btnSubmitText.textContent = 'Lưu thay đổi';
                form.submit();
            });
        });
    });
</script>

<jsp:include page="../common/footer.jsp" />
