<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thiết lập mật khẩu - Courson LMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                background-color: #F8F9FA;
                color: #111827;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: flex-start;
                padding: 40px 16px 24px;
            }

            .auth-container {
                width: 100%;
                max-width: 440px;
                margin: 0 auto;
            }

            .auth-header {
                text-align: left;
                margin-bottom: 24px;
            }
            .brand-row {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 16px;
            }
            .auth-title {
                font-size: 1.45rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 6px;
                letter-spacing: -0.4px;
            }
            .auth-subtitle {
                font-size: 0.9rem;
                color: #6B7280;
                line-height: 1.4;
            }

            /* User Info Card */
            .user-info-card {
                background: #FFFFFF;
                border: 1px solid #E5E7EB;
                border-radius: 14px;
                padding: 16px;
                margin-bottom: 22px;
                display: flex;
                align-items: center;
                gap: 14px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            }
            .user-avatar-wrap {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                overflow: hidden;
                flex-shrink: 0;
                background: #FFF0E2;
                border: 2px solid #F38020;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .user-avatar-wrap img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            .user-avatar-initial {
                font-size: 1.2rem;
                font-weight: 700;
                color: #F38020;
            }
            .user-details {
                flex: 1;
                min-width: 0;
            }
            .user-name {
                font-size: 0.96rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 2px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .user-meta {
                font-size: 0.82rem;
                color: #6B7280;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .role-badge {
                display: inline-block;
                background-color: #EBF5FF;
                color: #1E40AF;
                font-size: 0.72rem;
                font-weight: 700;
                padding: 2px 8px;
                border-radius: 6px;
                margin-top: 4px;
                text-transform: uppercase;
                letter-spacing: 0.4px;
            }

            .alert-server {
                background-color: rgba(237, 73, 86, 0.12);
                border: 1px solid rgba(237, 73, 86, 0.45);
                border-radius: 10px;
                color: #ed4956;
                font-size: 0.84rem;
                padding: 11px 14px;
                margin-bottom: 20px;
            }

            .field-group {
                margin-bottom: 18px;
            }
            .field-label {
                display: block;
                font-size: 0.88rem;
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
            }
            .field-input {
                width: 100%;
                background-color: #FFFFFF;
                border: 1px solid #E5E7EB;
                border-radius: 12px;
                color: #111827;
                font-size: 0.92rem;
                padding: 13px 16px;
                outline: none;
                transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s;
                appearance: none;
            }
            .field-input::placeholder {
                color: #9CA3AF;
            }
            .field-input:focus {
                background-color: #FFFFFF;
                border-color: #F38020;
                box-shadow: 0 0 0 3px rgba(243, 128, 32, 0.15);
            }
            .field-input.field-err {
                border-color: #ed4956;
            }

            .input-wrapper {
                position: relative;
                display: flex;
                align-items: center;
            }
            .input-wrapper .field-input {
                padding-right: 48px;
            }
            input::-ms-reveal,
            input::-ms-clear {
                display: none;
            }
            .toggle-icon {
                position: absolute;
                right: 14px;
                cursor: pointer;
                color: #9CA3AF;
                font-size: 1.25rem;
                display: none;
                align-items: center;
                justify-content: center;
                user-select: none;
                transition: color 0.15s;
            }
            .toggle-icon:hover {
                color: #111827;
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
                background-color: #E5E7EB;
                transition: background-color 0.2s;
            }
            .s-bar.weak   { background-color: #ed4956; }
            .s-bar.fair   { background-color: #f5a623; }
            .s-bar.strong { background-color: #3ee04b; }

            .field-hint {
                font-size: 0.78rem;
                color: #6B7280;
                margin-top: 6px;
                line-height: 1.4;
            }

            .field-error {
                color: #ed4956;
                font-size: 0.78rem;
                min-height: 16px;
                margin-top: 4px;
            }

            .btn-submit {
                display: block;
                width: 100%;
                background-color: #F38020;
                color: #fff;
                border: none;
                border-radius: 9999px;
                font-size: 0.95rem;
                font-weight: 700;
                padding: 13px;
                margin-top: 24px;
                cursor: pointer;
                transition: background-color 0.15s, opacity 0.15s;
                text-align: center;
            }
            .btn-submit:hover {
                background-color: #E56B00;
            }
            .btn-submit:disabled {
                opacity: 0.65;
                cursor: not-allowed;
            }

            /* Toast Notification Styles */
            .courson-toast-container {
                position: fixed;
                top: 24px;
                right: 24px;
                z-index: 99999;
                display: flex;
                flex-direction: column;
                gap: 12px;
                pointer-events: none;
                max-width: 440px;
                width: calc(100vw - 48px);
            }
            @media (max-width: 600px) {
                .courson-toast-container {
                    top: 16px;
                    right: 16px;
                    left: 16px;
                    width: auto;
                }
            }
            .courson-toast {
                pointer-events: auto;
                display: flex;
                align-items: flex-start;
                gap: 12px;
                padding: 14px 18px;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25), 0 2px 6px rgba(0, 0, 0, 0.1);
                font-size: 14px;
                line-height: 1.5;
                font-family: inherit;
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);
                transform: translateX(110%);
                opacity: 0;
                border: 1px solid rgba(255, 255, 255, 0.15);
            }
            .courson-toast.show {
                transform: translateX(0);
                opacity: 1;
            }
            .courson-toast.hide {
                transform: translateX(120%);
                opacity: 0;
            }
            .courson-toast-success {
                background: linear-gradient(135deg, rgba(16, 185, 129, 0.95), rgba(5, 150, 105, 0.95));
                color: #ffffff;
                border-color: rgba(110, 231, 183, 0.4);
            }
            .courson-toast-error {
                background: linear-gradient(135deg, rgba(239, 68, 68, 0.95), rgba(220, 38, 38, 0.95));
                color: #ffffff;
                border-color: rgba(252, 165, 165, 0.4);
            }
            .courson-toast-info {
                background: linear-gradient(135deg, rgba(243, 128, 32, 0.95), rgba(229, 107, 0, 0.95));
                color: #ffffff;
                border-color: rgba(255, 180, 110, 0.4);
            }
            .courson-toast-icon {
                font-size: 18px;
                margin-top: 1px;
                flex-shrink: 0;
            }
            .courson-toast-content {
                flex: 1;
                font-weight: 500;
            }
            .courson-toast-close {
                background: transparent;
                border: none;
                color: rgba(255, 255, 255, 0.8);
                font-size: 18px;
                cursor: pointer;
                padding: 0;
                margin-left: 4px;
                flex-shrink: 0;
            }
        </style>
    </head>
    <body>
        <div class="auth-container">

            <div class="auth-header">
                <div class="brand-row">
                    <a href="${pageContext.request.contextPath}/home" title="Về trang chủ" style="display: inline-flex; align-items: center; text-decoration: none; cursor: pointer;">
                        <svg width="42" height="29" viewBox="0 0 38 26" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M31.2 10.9C30.4 5.5 25.8 1.4 20.2 1.4C15.6 1.4 11.5 4.3 9.9 8.5C9.2 8.2 8.4 8.0 7.6 8.0C3.4 8.0 0 11.4 0 15.6C0 19.8 3.4 23.2 7.6 23.2H30.9C34.8 23.2 38 20.0 38 16.1C38 12.5 35.1 9.5 31.2 10.9Z" fill="url(#cfRegGrad)"/>
                            <path d="M22.5 1.5C21.7 1.4 21.0 1.4 20.2 1.4C15.6 1.4 11.5 4.3 9.9 8.5C10.7 8.5 11.5 8.7 12.3 9.0C13.5 5.8 16.6 3.5 20.2 3.5C23.2 3.5 25.8 4.9 27.5 7.1C26.1 4.5 24.5 2.6 22.5 1.5Z" fill="#FAAD3F"/>
                            <defs>
                                <linearGradient id="cfRegGrad" x1="0" y1="0" x2="38" y2="24" gradientUnits="userSpaceOnUse">
                                    <stop stop-color="#FAAD3F"/>
                                    <stop offset="0.45" stop-color="#F38020"/>
                                    <stop offset="1" stop-color="#E56B00"/>
                                </linearGradient>
                            </defs>
                        </svg>
                    </a>
                </div>
                <h1 class="auth-title">Thiết lập mật khẩu</h1>
                <p class="auth-subtitle">Tạo mật khẩu cho tài khoản để hoàn tất đăng ký và bắt đầu học tập trên Courson LMS.</p>
            </div>

            <!-- Current User Profile Card -->
            <c:if test="${not empty sessionScope.user}">
                <div class="user-info-card">
                    <div class="user-avatar-wrap">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.avatarUrl}">
                                <img src="${pageContext.request.contextPath}/${sessionScope.user.avatarUrl}" alt="Avatar">
                            </c:when>
                            <c:otherwise>
                                <span class="user-avatar-initial">
                                    <c:out value="${sessionScope.user.fullName != null && !sessionScope.user.fullName.isEmpty() ? sessionScope.user.fullName.substring(0,1).toUpperCase() : 'U'}"/>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="user-details">
                        <div class="user-name"><c:out value="${sessionScope.user.fullName}"/></div>
                        <div class="user-meta">@<c:out value="${sessionScope.user.username}"/> &bull; <c:out value="${sessionScope.user.email}"/></div>
                        <span class="role-badge"><c:out value="${sessionScope.user.roleName != null ? sessionScope.user.roleName : 'HỌC VIÊN'}"/></span>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert-server">
                    <i class="bi bi-exclamation-circle me-1"></i><c:out value="${error}"/>
                </div>
            </c:if>

            <form id="setPasswordForm" action="${pageContext.request.contextPath}/auth/set-password" method="POST" novalidate>

                <div class="field-group">
                    <label class="field-label" for="password">Mật khẩu</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" class="field-input"
                               placeholder="Nhập mật khẩu" autocomplete="new-password">
                        <span class="toggle-icon" id="togglePw" onclick="togglePass('password', 'pwIcon')">
                            <i class="bi bi-eye-slash" id="pwIcon"></i>
                        </span>
                    </div>
                    <div class="strength-bars" id="strengthBars">
                        <div class="s-bar" id="b1"></div>
                        <div class="s-bar" id="b2"></div>
                        <div class="s-bar" id="b3"></div>
                        <div class="s-bar" id="b4"></div>
                    </div>
                    <p class="field-hint">Mật khẩu phải từ 8–32 ký tự, gồm ít nhất 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.</p>
                    <div class="field-error" id="passwordError"></div>
                </div>

                <div class="field-group">
                    <label class="field-label" for="confirmPassword">Xác nhận mật khẩu</label>
                    <div class="input-wrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="field-input"
                               placeholder="Nhập lại mật khẩu" autocomplete="new-password">
                        <span class="toggle-icon" id="toggleCp" onclick="togglePass('confirmPassword', 'cpIcon')">
                            <i class="bi bi-eye-slash" id="cpIcon"></i>
                        </span>
                    </div>
                    <div class="field-error" id="confirmError"></div>
                </div>

                <button type="submit" id="btnSubmit" class="btn-submit">
                    Lưu mật khẩu & Bắt đầu học
                </button>

            </form>
        </div>

        <script>
            (function(global) {
                'use strict';
                let container = null;
                function getOrCreateContainer() {
                    if (!container || !document.body.contains(container)) {
                        container = document.createElement('div');
                        container.className = 'courson-toast-container';
                        container.setAttribute('aria-live', 'polite');
                        container.setAttribute('aria-atomic', 'true');
                        document.body.appendChild(container);
                    }
                    return container;
                }
                const ICONS = {
                    success: 'bi-check-circle-fill',
                    error: 'bi-exclamation-triangle-fill',
                    warning: 'bi-exclamation-circle-fill',
                    info: 'bi-info-circle-fill'
                };
                function dismissToast(toast) {
                    if (!toast || toast.classList.contains('hide')) return;
                    toast.classList.remove('show');
                    toast.classList.add('hide');
                    setTimeout(() => {
                        if (toast.parentNode) {
                            toast.parentNode.removeChild(toast);
                        }
                    }, 400);
                }
                const CoursonToast = {
                    show: function(type, message, duration = 6000) {
                        if (!message) return;
                        const c = getOrCreateContainer();
                        const normalizedType = ['success', 'error', 'warning', 'info'].includes(type) ? type : 'info';
                        const iconClass = ICONS[normalizedType];
                        const toast = document.createElement('div');
                        toast.className = 'courson-toast courson-toast-' + normalizedType;
                        toast.setAttribute('role', 'status');
                        const iconSpan = document.createElement('span');
                        iconSpan.className = 'courson-toast-icon bi ' + iconClass;
                        toast.appendChild(iconSpan);
                        const contentDiv = document.createElement('div');
                        contentDiv.className = 'courson-toast-content';
                        contentDiv.textContent = message;
                        toast.appendChild(contentDiv);
                        const closeBtn = document.createElement('button');
                        closeBtn.className = 'courson-toast-close';
                        closeBtn.setAttribute('type', 'button');
                        closeBtn.setAttribute('aria-label', 'Đóng');
                        closeBtn.innerHTML = '&times;';
                        closeBtn.onclick = function() { dismissToast(toast); };
                        toast.appendChild(closeBtn);
                        c.appendChild(toast);
                        requestAnimationFrame(() => { toast.classList.add('show'); });
                        let timer = setTimeout(() => { dismissToast(toast); }, duration);
                        toast.onmouseenter = () => { clearTimeout(timer); };
                        toast.onmouseleave = () => { timer = setTimeout(() => { dismissToast(toast); }, 2000); };
                        return toast;
                    }
                };
                global.CoursonToast = CoursonToast;
            })(window);

            const pwInput = document.getElementById('password');
            const cpInput = document.getElementById('confirmPassword');
            const togglePw = document.getElementById('togglePw');
            const toggleCp = document.getElementById('toggleCp');

            function syncToggle(input, btn) {
                btn.style.display = input.value.length > 0 ? 'inline-flex' : 'none';
            }
            pwInput.addEventListener('input', () => syncToggle(pwInput, togglePw));
            cpInput.addEventListener('input', () => syncToggle(cpInput, toggleCp));

            function togglePass(inputId, iconId) {
                const field = document.getElementById(inputId);
                const icon = document.getElementById(iconId);
                if (field.type === 'password') {
                    field.type = 'text';
                    icon.classList.remove('bi-eye-slash');
                    icon.classList.add('bi-eye');
                } else {
                    field.type = 'password';
                    icon.classList.remove('bi-eye');
                    icon.classList.add('bi-eye-slash');
                }
            }

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
                const cls = score <= 1 ? 'weak' : score <= 2 ? 'fair' : 'strong';
                for (let i = 0; i < score; i++) {
                    bars[i].classList.add(cls);
                }
            }

            pwInput.addEventListener('input', function () {
                const barsEl = document.getElementById('strengthBars');
                if (this.value.length > 0) {
                    barsEl.classList.add('show');
                    updateBars(passwordScore(this.value));
                } else {
                    barsEl.classList.remove('show');
                }
            });

            function showErr(errId, inputId, msg) {
                document.getElementById(errId).textContent = msg;
                if (inputId) document.getElementById(inputId).classList.add('field-err');
            }

            function clearErr(errId, inputId) {
                document.getElementById(errId).textContent = '';
                if (inputId) document.getElementById(inputId).classList.remove('field-err');
            }

            pwInput.addEventListener('blur', function () {
                const pw = this.value;
                if (!pw) {
                    showErr('passwordError', 'password', 'Mật khẩu không được để trống.');
                } else if (!STRONG_RE.test(pw)) {
                    showErr('passwordError', 'password',
                            'Mật khẩu phải từ 8–32 ký tự, có ít nhất 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.');
                } else {
                    clearErr('passwordError', 'password');
                }
            });
            pwInput.addEventListener('input', () => clearErr('passwordError', 'password'));

            cpInput.addEventListener('blur', function () {
                if (!this.value) {
                    showErr('confirmError', 'confirmPassword', 'Vui lòng xác nhận mật khẩu.');
                } else if (this.value !== pwInput.value) {
                    showErr('confirmError', 'confirmPassword', 'Mật khẩu xác nhận không khớp.');
                } else {
                    clearErr('confirmError', 'confirmPassword');
                }
            });
            cpInput.addEventListener('input', () => clearErr('confirmError', 'confirmPassword'));

            document.getElementById('setPasswordForm').addEventListener('submit', function (e) {
                let ok = true;

                const pw = pwInput.value;
                if (!pw) {
                    showErr('passwordError', 'password', 'Mật khẩu không được để trống.');
                    ok = false;
                } else if (!STRONG_RE.test(pw)) {
                    showErr('passwordError', 'password',
                            'Mật khẩu phải từ 8–32 ký tự, có ít nhất 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.');
                    ok = false;
                }

                const cp = cpInput.value;
                if (!cp) {
                    showErr('confirmError', 'confirmPassword', 'Vui lòng xác nhận mật khẩu.');
                    ok = false;
                } else if (cp !== pw) {
                    showErr('confirmError', 'confirmPassword', 'Mật khẩu xác nhận không khớp.');
                    ok = false;
                }

                if (!ok) {
                    e.preventDefault();
                } else {
                    const btn = document.getElementById('btnSubmit');
                    btn.disabled = true;
                    btn.textContent = 'Đang lưu mật khẩu...';
                }
            });
        </script>

        <c:if test="${not empty sessionScope.flashToastMessage}">
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    if (window.CoursonToast) {
                        window.CoursonToast.show(
                            '<c:out value="${sessionScope.flashToastType != null ? sessionScope.flashToastType : 'info'}"/>',
                            '<c:out value="${sessionScope.flashToastMessage}"/>'
                        );
                    }
                });
            </script>
            <c:remove var="flashToastMessage" scope="session"/>
            <c:remove var="flashToastType" scope="session"/>
        </c:if>
    </body>
</html>
