<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kiểm tra email của bạn - Courson LMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <script>
            (function () {
                const theme = localStorage.getItem('courson_auth_theme');
                if (theme === 'light') {
                    document.documentElement.setAttribute('data-theme', 'light');
                }
            })();
        </script>
        <style>
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
                max-width: 420px;
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
            .courson-toast-warning {
                background: linear-gradient(135deg, rgba(245, 158, 11, 0.95), rgba(217, 119, 6, 0.95));
                color: #ffffff;
                border-color: rgba(252, 211, 77, 0.4);
            }
            .courson-toast-icon {
                flex-shrink: 0;
                font-size: 18px;
                margin-top: 1px;
            }
            .courson-toast-content {
                flex: 1 1 auto;
                font-weight: 500;
            }
            .courson-toast-close {
                flex-shrink: 0;
                background: transparent;
                border: none;
                color: rgba(255, 255, 255, 0.8);
                cursor: pointer;
                font-size: 16px;
                padding: 0;
                margin-left: 6px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 20px;
                height: 20px;
                border-radius: 50%;
                transition: background 0.2s ease, color 0.2s ease;
            }
            .courson-toast-close:hover {
                background: rgba(255, 255, 255, 0.2);
                color: #ffffff;
            }

            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            :root {
                --bg-main: #0d0d0e;
                --bg-card: #18181b;
                --border-card: rgba(255, 255, 255, 0.1);
                --text-main: #ffffff;
                --text-muted: #a1a1aa;
                --text-sub: #71717a;
                --primary: #F38020;
                --primary-hover: #E56B00;
                --primary-glow: rgba(243, 128, 32, 0.25);
                --box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
                --tip-bg: rgba(243, 128, 32, 0.08);
                --tip-border: rgba(243, 128, 32, 0.25);
            }

            [data-theme="light"] {
                --bg-main: #F5EFEB;
                --bg-card: #ffffff;
                --border-card: #E5DFD7;
                --text-main: #1F1F20;
                --text-muted: #52525b;
                --text-sub: #71717a;
                --primary: #F38020;
                --primary-hover: #E56B00;
                --primary-glow: rgba(243, 128, 32, 0.15);
                --box-shadow: 0 20px 45px rgba(0, 0, 0, 0.08);
                --tip-bg: #FFF8F0;
                --tip-border: #FFE4CC;
            }

            body {
                background-color: var(--bg-main);
                color: var(--text-main);
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 32px 16px;
                transition: background-color 0.3s ease, color 0.3s ease;
            }

            /* Theme toggle (đồng bộ chuẩn Login / Register) */
            .theme-toggle-btn {
                position: fixed;
                top: 20px;
                right: 24px;
                z-index: 1000;
                width: 44px;
                height: 44px;
                border-radius: 50%;
                background-color: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.18);
                color: #F38020;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 1.3rem;
                cursor: pointer;
                transition: all 0.25s ease;
                backdrop-filter: blur(10px);
                outline: none;
            }
            .theme-toggle-btn:hover {
                transform: scale(1.1) rotate(15deg);
                background-color: rgba(255, 255, 255, 0.2);
                border-color: #F38020;
            }

            [data-theme="light"] .theme-toggle-btn {
                background-color: #FFFFFF;
                border-color: #E5E7EB;
                color: #F38020;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            }
            [data-theme="light"] .theme-toggle-btn:hover {
                background-color: #FFF7ED;
                border-color: #F38020;
            }

            .email-card {
                max-width: 520px;
                width: 100%;
                background: var(--bg-card);
                border: 1px solid var(--border-card);
                border-radius: 20px;
                padding: 44px 36px;
                box-shadow: var(--box-shadow);
                text-align: center;
                position: relative;
                animation: fadeIn 0.4s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(16px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .brand-badge {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                text-decoration: none;
                margin-bottom: 28px;
            }
            .brand-badge .logo-icon {
                width: 38px;
                height: 38px;
                background: linear-gradient(135deg, #F38020, #FF9D42);
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #fff;
                font-size: 20px;
                box-shadow: 0 6px 16px rgba(243,128,32,0.3);
            }
            .brand-badge .logo-text {
                font-size: 20px;
                font-weight: 800;
                color: var(--text-main);
                letter-spacing: 0.5px;
            }
            .brand-badge .logo-text span {
                color: var(--primary);
            }

            .mail-icon-wrap {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                background: linear-gradient(135deg, rgba(243,128,32,0.15), rgba(243,128,32,0.05));
                border: 2px dashed rgba(243,128,32,0.4);
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 24px;
                color: var(--primary);
                font-size: 36px;
                position: relative;
            }
            .mail-icon-badge {
                position: absolute;
                bottom: 2px;
                right: 2px;
                width: 26px;
                height: 26px;
                border-radius: 50%;
                background: var(--primary);
                color: #fff;
                font-size: 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                border: 2px solid var(--bg-card);
            }

            .card-title {
                font-size: 26px;
                font-weight: 800;
                letter-spacing: -0.3px;
                margin-bottom: 14px;
                color: var(--text-main);
            }

            .card-desc {
                font-size: 15px;
                line-height: 1.6;
                color: var(--text-muted);
                margin-bottom: 20px;
            }

            .masked-email {
                display: inline-block;
                color: var(--primary);
                font-weight: 700;
                background: var(--tip-bg);
                padding: 4px 12px;
                border-radius: 6px;
                border: 1px solid var(--tip-border);
                margin: 6px 0;
                word-break: break-all;
            }

            .tip-box {
                background: var(--tip-bg);
                border: 1px solid var(--tip-border);
                border-radius: 12px;
                padding: 14px 16px;
                margin-bottom: 28px;
                text-align: left;
                display: flex;
                gap: 12px;
                align-items: flex-start;
                font-size: 13.5px;
                line-height: 1.5;
                color: var(--text-muted);
            }
            .tip-box i {
                color: var(--primary);
                font-size: 18px;
                flex-shrink: 0;
                margin-top: 1px;
            }

            .btn-resend {
                width: 100%;
                padding: 13px 20px;
                border-radius: 12px;
                border: 1px solid var(--border-card);
                background: transparent;
                color: var(--text-main);
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s ease;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                margin-bottom: 16px;
            }
            .btn-resend:hover:not(:disabled) {
                background: var(--primary);
                color: #ffffff;
                border-color: var(--primary);
                box-shadow: 0 6px 18px var(--primary-glow);
            }
            .btn-resend:disabled {
                opacity: 0.6;
                cursor: not-allowed;
                border-color: var(--border-card);
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                color: var(--text-sub);
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                transition: color 0.2s ease;
            }
            .back-link:hover {
                color: var(--primary);
            }
        </style>
    </head>
    <body>

        <!-- Theme Toggle -->
        <button type="button" class="theme-toggle-btn" id="themeToggleBtn" title="Chuyển chế độ giao diện">
            <i class="bi bi-sun-fill" id="themeIcon"></i>
        </button>

        <div class="email-card">
            <!-- Brand -->
            <a href="${pageContext.request.contextPath}/home" class="brand-badge">
                <div class="logo-icon">☁️</div>
                <div class="logo-text">COURSON<span>.LMS</span></div>
            </a>

            <!-- Big Icon -->
            <div class="mail-icon-wrap">
                <i class="bi bi-envelope"></i>
                <div class="mail-icon-badge">
                    <i class="bi bi-clock-history"></i>
                </div>
            </div>

            <!-- Title & Description -->
            <h1 class="card-title">Kiểm tra email của bạn</h1>

            <%-- Email Masking logic --%>
            <c:set var="rawEmail" value="${param.email}" />
            <c:set var="maskedEmail" value="email của bạn" />
            <c:if test="${not empty rawEmail}">
                <c:choose>
                    <c:when test="${fn:contains(rawEmail, '@')}">
                        <c:set var="parts" value="${fn:split(rawEmail, '@')}" />
                        <c:set var="uname" value="${parts[0]}" />
                        <c:set var="domain" value="${parts[1]}" />
                        <c:choose>
                            <c:when test="${fn:length(uname) > 3}">
                                <c:set var="maskedEmail" value="${fn:substring(uname, 0, 2)}***${fn:substring(uname, fn:length(uname) - 1, fn:length(uname))}@${domain}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="maskedEmail" value="${fn:substring(uname, 0, 1)}***@${domain}" />
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:set var="maskedEmail" value="${rawEmail}" />
                    </c:otherwise>
                </c:choose>
            </c:if>

            <p class="card-desc">
                Chúng tôi đã gửi link xác thực tài khoản tới:<br>
                <span class="masked-email" id="displayEmail"><c:out value="${maskedEmail}"/></span><br>
                Vui lòng mở hòm thư và bấm vào link để kích hoạt tài khoản. Liên kết có hiệu lực trong vòng <strong>24 giờ</strong>.
            </p>

            <!-- Tip Box -->
            <div class="tip-box">
                <i class="bi bi-info-circle-fill"></i>
                <div>
                    <strong>Chưa nhận được email?</strong> Hãy kiểm tra kỹ trong cả thư mục <em>Spam (Thư rác)</em> hoặc <em>Quảng cáo</em>. Đôi khi hệ thống thư cần 1–2 phút để chuyển phát.
                </div>
            </div>

            <!-- Resend Form / Button -->
            <form id="resendForm" action="${pageContext.request.contextPath}/auth/resend-verification" method="POST">
                <input type="hidden" name="email" value="<c:out value='${param.email}'/>">
                <button type="submit" class="btn-resend" id="resendBtn">
                    <i class="bi bi-arrow-repeat" id="resendIcon"></i>
                    <span id="resendText">Gửi lại email xác nhận</span>
                </button>
            </form>

            <div>
                <a href="${pageContext.request.contextPath}/auth/login" class="back-link">
                    <i class="bi bi-arrow-left"></i> Quay lại trang đăng nhập
                </a>
            </div>
        </div>

        <script>
            (function (global) {
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
                const CoursonToast = {
                    show: function (type, message, duration = 5000) {
                        if (!message)
                            return;
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
                        closeBtn.setAttribute('aria-label', 'Đóng thông báo');
                        closeBtn.innerHTML = '&times;';
                        closeBtn.onclick = function () {
                            dismissToast(toast);
                        };
                        toast.appendChild(closeBtn);
                        c.appendChild(toast);
                        requestAnimationFrame(() => {
                            toast.classList.add('show');
                        });
                        let timer = null;
                        if (duration > 0) {
                            timer = setTimeout(() => {
                                dismissToast(toast);
                            }, duration);
                        }
                        toast.onmouseenter = () => {
                            if (timer)
                                clearTimeout(timer);
                        };
                        toast.onmouseleave = () => {
                            if (duration > 0) {
                                timer = setTimeout(() => {
                                    dismissToast(toast);
                                }, 2000);
                            }
                        };
                        return toast;
                    },
                    cleanUrlParams: function (paramNames = ['status']) {
                        if (!window.history || !window.history.replaceState)
                            return;
                        try {
                            const url = new URL(window.location.href);
                            let changed = false;
                            paramNames.forEach(name => {
                                if (url.searchParams.has(name)) {
                                    url.searchParams.delete(name);
                                    changed = true;
                                }
                            });
                            if (changed) {
                                const cleanPath = url.pathname + (url.search ? url.search : '') + url.hash;
                                window.history.replaceState(null, '', cleanPath);
                            }
                        } catch (e) {
                    }
                    }
                };
                function dismissToast(toast) {
                    if (!toast || toast.classList.contains('hide'))
                        return;
                    toast.classList.remove('show');
                    toast.classList.add('hide');
                    setTimeout(() => {
                        if (toast.parentNode) {
                            toast.parentNode.removeChild(toast);
                        }
                    }, 400);
                }
                global.CoursonToast = CoursonToast;
            })(window);

            // Theme toggle logic
            const themeToggleBtn = document.getElementById('themeToggleBtn');
            const themeIcon = document.getElementById('themeIcon');

            function updateThemeDisplay(theme) {
                if (theme === 'light') {
                    document.documentElement.setAttribute('data-theme', 'light');
                    themeIcon.className = 'bi bi-moon-stars-fill';
                } else {
                    document.documentElement.removeAttribute('data-theme');
                    themeIcon.className = 'bi bi-sun-fill';
                }
            }

            const currentTheme = localStorage.getItem('courson_auth_theme') || 'dark';
            updateThemeDisplay(currentTheme);

            themeToggleBtn.addEventListener('click', function () {
                const isLight = document.documentElement.getAttribute('data-theme') === 'light';
                const nextTheme = isLight ? 'dark' : 'light';
                localStorage.setItem('courson_auth_theme', nextTheme);
                updateThemeDisplay(nextTheme);
            });

            // 60-Second Countdown Timer for Resend Button
            const resendBtn = document.getElementById('resendBtn');
            const resendText = document.getElementById('resendText');
            const resendIcon = document.getElementById('resendIcon');
            const resendForm = document.getElementById('resendForm');
            let countdown = 60;
            let timerId = null;

            function startCountdown(seconds) {
                countdown = seconds;
                resendBtn.disabled = true;
                resendIcon.classList.add('bi-hourglass-split');
                resendIcon.classList.remove('bi-arrow-repeat');

                if (timerId)
                    clearInterval(timerId);

                updateButtonLabel();
                timerId = setInterval(function () {
                    countdown--;
                    if (countdown <= 0) {
                        clearInterval(timerId);
                        timerId = null;
                        resendBtn.disabled = false;
                        resendText.textContent = 'Gửi lại email xác nhận';
                        resendIcon.classList.remove('bi-hourglass-split');
                        resendIcon.classList.add('bi-arrow-repeat');
                    } else {
                        updateButtonLabel();
                    }
                }, 1000);
            }

            function updateButtonLabel() {
                resendText.textContent = 'Gửi lại sau (' + countdown + 's)';
            }

            // Start countdown immediately on arrival
            startCountdown(60);

            // Handle Resend with Fetch (AJAX)
            resendForm.addEventListener('submit', function (e) {
                e.preventDefault();
                if (resendBtn.disabled)
                    return;

                resendBtn.disabled = true;
                resendText.textContent = 'Đang gửi...';

                const formData = new FormData(resendForm);
                fetch(resendForm.action, {
                    method: 'POST',
                    body: new URLSearchParams(formData),
                    headers: {
                        'Accept': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                        .then(response => {
                            if (response.status === 429) {
                                return response.json().then(data => {
                                    CoursonToast.show('warning', data.message || 'Vui lòng đợi 60 giây trước khi gửi lại.');
                                    startCountdown(countdown > 0 ? countdown : 30);
                                });
                            }
                            if (!response.ok) {
                                throw new Error('Gửi lại email thất bại');
                            }
                            return response.json().then(data => {
                                CoursonToast.show('success', data.message || 'Đã gửi lại link xác thực! Vui lòng kiểm tra hộp thư.');
                                startCountdown(60);
                            });
                        })
                        .catch(err => {
                            CoursonToast.show('error', 'Có lỗi xảy ra khi gửi lại email. Vui lòng thử lại sau.');
                            resendBtn.disabled = false;
                            resendText.textContent = 'Gửi lại email xác nhận';
                        });
            });
        </script>
    </body>
</html>
