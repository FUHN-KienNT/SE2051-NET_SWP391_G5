<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Đổi mật khẩu - Courson LMS" />
<jsp:include page="../common/header.jsp" />

<style>
    .cf-pwd-wrapper {
        max-width: 620px;
        margin: 0 auto;
    }
    .cf-pwd-card {
        background: #ffffff;
        border: 1px solid #E2E8F0;
        border-radius: 18px;
        padding: 36px 40px;
        box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05), 0 6px 12px -4px rgba(0, 0, 0, 0.02);
    }
    .cf-back-link {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        color: #64748B;
        text-decoration: none;
        font-size: 0.92rem;
        font-weight: 600;
        margin-bottom: 20px;
        transition: color 0.2s ease;
    }
    .cf-back-link:hover {
        color: #F38020;
    }
    .cf-pwd-header {
        padding-bottom: 20px;
        margin-bottom: 24px;
        border-bottom: 1px solid #F1F5F9;
    }
    .cf-pwd-title {
        font-size: 1.55rem;
        font-weight: 800;
        color: #0F172A;
        letter-spacing: -0.4px;
        margin-bottom: 4px;
    }
    .cf-form-label {
        font-size: 0.92rem;
        font-weight: 600;
        color: #334155;
        margin-bottom: 7px;
        display: flex;
        align-items: center;
        gap: 4px;
    }
    .cf-form-label .req-star {
        color: #EF4444;
    }
    .cf-input-wrapper {
        position: relative;
    }
    .cf-form-control {
        border: 1.5px solid #CBD5E1;
        border-radius: 10px;
        padding: 10px 42px 10px 14px;
        font-size: 0.95rem;
        color: #1E293B;
        transition: all 0.2s ease;
        background-color: #FFFFFF;
        width: 100%;
    }
    .cf-form-control:focus {
        border-color: #F38020;
        box-shadow: 0 0 0 3px rgba(243, 128, 32, 0.18);
        outline: none;
    }
    .cf-toggle-icon {
        position: absolute;
        right: 12px;
        top: 50%;
        transform: translateY(-50%);
        color: #94A3B8;
        cursor: pointer;
        font-size: 1.15rem;
        transition: color 0.2s;
        display: flex;
        align-items: center;
        justify-content: center;
        user-select: none;
    }
    .cf-toggle-icon:hover {
        color: #475569;
    }
    .field-error-text {
        font-size: 0.82rem;
        color: #DC2626;
        margin-top: 5px;
        display: none;
    }
    .cf-btn-submit {
        background: linear-gradient(135deg, #F38020 0%, #E56B00 100%);
        color: #FFFFFF;
        border: none;
        padding: 11px 28px;
        font-size: 0.98rem;
        font-weight: 700;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(243, 128, 32, 0.28);
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
    }
    .cf-btn-submit:hover {
        background: linear-gradient(135deg, #E56B00 0%, #CF5A00 100%);
        box-shadow: 0 6px 16px rgba(243, 128, 32, 0.38);
        transform: translateY(-1px);
        color: #FFFFFF;
    }
    .cf-btn-submit:disabled {
        background: #94A3B8;
        box-shadow: none;
        cursor: not-allowed;
    }
    .cf-btn-cancel {
        background: #F1F5F9;
        color: #475569;
        border: 1px solid #E2E8F0;
        padding: 11px 22px;
        font-size: 0.98rem;
        font-weight: 600;
        border-radius: 10px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        transition: all 0.2s ease;
    }
    .cf-btn-cancel:hover {
        background: #E2E8F0;
        color: #1E293B;
    }
    .strength-bars {
        display: none;
        gap: 4px;
        margin-top: 7px;
    }
    .strength-bars.show {
        display: flex;
    }
    .s-bar {
        height: 3px;
        flex: 1;
        border-radius: 2px;
        background-color: #E2E8F0;
        transition: background-color 0.25s ease;
    }
    .s-bar.weak   { background-color: #EF4444; }
    .s-bar.fair   { background-color: #F59E0B; }
    .s-bar.strong { background-color: #10B981; }
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
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/profile" class="text-decoration-none text-muted">Hồ sơ cá nhân</a>
                </li>
                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Đổi mật khẩu</li>
            </ol>
        </nav>

        <div class="cf-pwd-wrapper">
            <!-- Back to profile link -->
            <a href="${pageContext.request.contextPath}/profile" class="cf-back-link">
                <i class="bi bi-arrow-left"></i>
                <span>Quay lại User Profile</span>
            </a>

            <div class="cf-pwd-card">
                <div class="cf-pwd-header">
                    <h1 class="cf-pwd-title">Đổi mật khẩu</h1>
                    <p class="text-muted small mb-0">Cập nhật mật khẩu mới để bảo vệ tài khoản của bạn trên Courson LMS.</p>
                </div>

                <!-- Server Error Alert -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2 fs-5"></i>
                        <div><c:out value="${error}" /></div>
                    </div>
                </c:if>

                <form id="changePasswordForm" action="${pageContext.request.contextPath}/profile/change-password" method="POST" novalidate>
                    <input type="hidden" name="action" value="change-password" />

                    <!-- Mật khẩu hiện tại -->
                    <div class="mb-3">
                        <label class="cf-form-label" for="currentPassword">
                            Mật khẩu hiện tại<span class="req-star">*</span>
                        </label>
                        <div class="cf-input-wrapper">
                            <input type="password" id="currentPassword" name="currentPassword" class="cf-form-control"
                                   placeholder="Nhập mật khẩu hiện tại" autocomplete="current-password" required />
                            <span class="cf-toggle-icon" onclick="togglePass('currentPassword', 'iconCur')">
                                <i class="bi bi-eye-slash" id="iconCur"></i>
                            </span>
                        </div>
                        <div id="currentPasswordError" class="field-error-text"></div>
                    </div>

                    <!-- Mật khẩu mới -->
                    <div class="mb-3">
                        <label class="cf-form-label" for="newPassword">
                            Mật khẩu mới<span class="req-star">*</span>
                        </label>
                        <div class="cf-input-wrapper">
                            <input type="password" id="newPassword" name="newPassword" class="cf-form-control"
                                   placeholder="Nhập mật khẩu mới" autocomplete="new-password" required />
                            <span class="cf-toggle-icon" onclick="togglePass('newPassword', 'iconNew')">
                                <i class="bi bi-eye-slash" id="iconNew"></i>
                            </span>
                        </div>
                        <div class="strength-bars" id="strengthBars">
                            <div class="s-bar" id="b1"></div>
                            <div class="s-bar" id="b2"></div>
                            <div class="s-bar" id="b3"></div>
                            <div class="s-bar" id="b4"></div>
                        </div>
                        <small class="form-text text-muted">Từ 8–32 ký tự, gồm ít nhất 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.</small>
                        <div id="newPasswordError" class="field-error-text"></div>
                    </div>

                    <!-- Xác nhận mật khẩu mới -->
                    <div class="mb-4">
                        <label class="cf-form-label" for="confirmPassword">
                            Xác nhận mật khẩu mới<span class="req-star">*</span>
                        </label>
                        <div class="cf-input-wrapper">
                            <input type="password" id="confirmPassword" name="confirmPassword" class="cf-form-control"
                                   placeholder="Nhập lại mật khẩu mới" autocomplete="new-password" required />
                            <span class="cf-toggle-icon" onclick="togglePass('confirmPassword', 'iconCfm')">
                                <i class="bi bi-eye-slash" id="iconCfm"></i>
                            </span>
                        </div>
                        <div id="confirmPasswordError" class="field-error-text"></div>
                    </div>

                    <!-- Action buttons -->
                    <div class="d-flex align-items-center gap-3 pt-2">
                        <button type="submit" id="btnSubmitPw" class="cf-btn-submit">
                            <i class="bi bi-check-lg"></i>
                            <span id="btnSubmitPwText">Lưu mật khẩu mới</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/profile" class="cf-btn-cancel">
                            Hủy
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
    function togglePass(inputId, iconId) {
        const input = document.getElementById(inputId);
        const icon = document.getElementById(iconId);
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        } else {
            input.type = 'password';
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('changePasswordForm');
        const curInput = document.getElementById('currentPassword');
        const newInput = document.getElementById('newPassword');
        const cfmInput = document.getElementById('confirmPassword');
        const btnSubmit = document.getElementById('btnSubmitPw');
        const btnSubmitText = document.getElementById('btnSubmitPwText');
        const strengthBars = document.getElementById('strengthBars');

        const STRONG_RE = /^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+\[\]{};':"\\|,.<>/?]).{8,32}$/;

        function passwordScore(pw) {
            let s = 0;
            if (pw.length >= 8) s++;
            if (/[A-Z]/.test(pw)) s++;
            if (/\d/.test(pw)) s++;
            if (/[!@#$%^&*()\-_=+\[\]{};':"\\|,.<>/?]/.test(pw)) s++;
            return s;
        }

        function updateBars(score) {
            const bars = [document.getElementById('b1'), document.getElementById('b2'),
                          document.getElementById('b3'), document.getElementById('b4')];
            bars.forEach(b => b.className = 's-bar');
            if (score === 0) return;
            const cls = score <= 1 ? 'weak' : score <= 2 ? 'fair' : 'strong';
            for (let i = 0; i < score; i++) {
                bars[i].classList.add(cls);
            }
        }

        newInput.addEventListener('input', function() {
            clearError('newPasswordError', 'newPassword');
            const pw = this.value;
            if (pw.length > 0) {
                strengthBars.classList.add('show');
                updateBars(passwordScore(pw));
            } else {
                strengthBars.classList.remove('show');
            }
        });

        curInput.addEventListener('input', () => clearError('currentPasswordError', 'currentPassword'));
        cfmInput.addEventListener('input', () => clearError('confirmPasswordError', 'confirmPassword'));

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

        form.addEventListener('submit', function(e) {
            let ok = true;
            const cur = curInput.value;
            const nw = newInput.value;
            const cfm = cfmInput.value;

            // 1. Current password
            if (!cur) {
                showError('currentPasswordError', 'currentPassword', 'Vui lòng nhập mật khẩu hiện tại.');
                ok = false;
            } else {
                clearError('currentPasswordError', 'currentPassword');
            }

            // 2. New password
            if (!nw) {
                showError('newPasswordError', 'newPassword', 'Mật khẩu mới không được để trống.');
                ok = false;
            } else if (!STRONG_RE.test(nw)) {
                showError('newPasswordError', 'newPassword', 'Mật khẩu mới phải từ 8–32 ký tự, gồm ít nhất 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.');
                ok = false;
            } else if (cur && cur === nw) {
                showError('newPasswordError', 'newPassword', 'Mật khẩu mới không được trùng với mật khẩu hiện tại.');
                ok = false;
            } else {
                clearError('newPasswordError', 'newPassword');
            }

            // 3. Confirm password
            if (!cfm) {
                showError('confirmPasswordError', 'confirmPassword', 'Vui lòng xác nhận mật khẩu mới.');
                ok = false;
            } else if (cfm !== nw) {
                showError('confirmPasswordError', 'confirmPassword', 'Mật khẩu xác nhận không khớp.');
                ok = false;
            } else {
                clearError('confirmPasswordError', 'confirmPassword');
            }

            if (!ok) {
                e.preventDefault();
                return;
            }

            // AJAX submit
            e.preventDefault();
            btnSubmit.disabled = true;
            btnSubmitText.textContent = 'Đang đổi mật khẩu...';

            const params = new URLSearchParams();
            params.append('action', 'change-password');
            params.append('currentPassword', cur);
            params.append('newPassword', nw);
            params.append('confirmPassword', cfm);

            fetch('${pageContext.request.contextPath}/profile/change-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                btnSubmit.disabled = false;
                btnSubmitText.textContent = 'Lưu mật khẩu mới';

                if (data.success) {
                    curInput.value = '';
                    newInput.value = '';
                    cfmInput.value = '';
                    strengthBars.classList.remove('show');
                    if (window.CoursonToast) {
                        window.CoursonToast.show('success', data.message || 'Đổi mật khẩu thành công!', 8000);
                    }
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/profile';
                    }, 1200);
                } else {
                    if (window.CoursonToast) {
                        window.CoursonToast.show('error', data.message || 'Đổi mật khẩu thất bại.', 8000);
                    }
                    if (data.message && data.message.includes('hiện tại')) {
                        showError('currentPasswordError', 'currentPassword', data.message);
                    } else if (data.message && data.message.includes('khớp')) {
                        showError('confirmPasswordError', 'confirmPassword', data.message);
                    } else {
                        showError('newPasswordError', 'newPassword', data.message);
                    }
                }
            })
            .catch(err => {
                btnSubmit.disabled = false;
                btnSubmitText.textContent = 'Lưu mật khẩu mới';
                form.submit();
            });
        });
    });
</script>

<jsp:include page="../common/footer.jsp" />
