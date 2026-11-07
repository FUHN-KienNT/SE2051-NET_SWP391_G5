<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kiểm tra email - Courson LMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
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
                margin-bottom: 24px;
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
                margin: 0 auto 20px;
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
                font-size: 13px;
                display: flex;
                align-items: center;
                justify-content: center;
                border: 2px solid var(--bg-card);
            }

            .card-title {
                font-size: 24px;
                font-weight: 800;
                letter-spacing: -0.3px;
                margin-bottom: 12px;
                color: var(--text-main);
            }

            .card-desc {
                font-size: 15px;
                line-height: 1.6;
                color: var(--text-muted);
                margin-bottom: 20px;
            }

            .email-display {
                display: inline-block;
                color: var(--primary);
                font-weight: 700;
                background: var(--tip-bg);
                padding: 4px 14px;
                border-radius: 8px;
                border: 1px solid var(--tip-border);
                margin: 8px 0;
                word-break: break-all;
                font-size: 15px;
            }

            .tip-box {
                background: var(--tip-bg);
                border: 1px solid var(--tip-border);
                border-radius: 12px;
                padding: 14px 16px;
                margin-bottom: 24px;
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
                margin-bottom: 20px;
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

            .links-row {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 20px;
                flex-wrap: wrap;
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

        <div class="email-card">
            <!-- Brand -->
            <a href="${pageContext.request.contextPath}/home" class="brand-badge">
                <div class="logo-icon">☁</div>
                <div class="logo-text">COURSON<span>.LMS</span></div>
            </a>

            <!-- Big Icon -->
            <div class="mail-icon-wrap">
                <i class="bi bi-envelope-at"></i>
                <div class="mail-icon-badge">
                    <i class="bi bi-key-fill"></i>
                </div>
            </div>

            <!-- Title & Description -->
            <h1 class="card-title">Kiểm tra email của bạn</h1>

            <p class="card-desc">
                Chúng tôi đã gửi liên kết xác thực đặt lại mật khẩu đến địa chỉ email:<br>
                <span class="email-display" id="displayEmail"><c:out value="${email}"/></span><br>
                Vui lòng mở hộp thư đến (kể cả thư mục <em>Spam</em> hoặc <em>Quảng cáo</em>) và nhấp vào liên kết để tạo mật khẩu mới. Liên kết này có hiệu lực trong vòng <strong>24 giờ</strong>.
            </p>

            <!-- Tip Box -->
            <div class="tip-box">
                <i class="bi bi-info-circle-fill"></i>
                <div>
                    <strong>Chưa nhận được email?</strong> Hãy đợi khoảng 1–2 phút để hệ thống thư chuyển phát. Sau khi hết thời gian chờ, bạn có thể bấm nút bên dưới để gửi lại link xác thực.
                </div>
            </div>

            <!-- Resend Button -->
            <button type="button" class="btn-resend" id="resendBtn" disabled>
                <i class="bi bi-hourglass-split" id="resendIcon"></i>
                <span id="resendText">Gửi lại sau (30s)</span>
            </button>

            <div class="links-row">
                <a href="${pageContext.request.contextPath}/auth/login" class="back-link">
                    <i class="bi bi-arrow-left"></i> Quay lại đăng nhập
                </a>
                <a href="${pageContext.request.contextPath}/auth/forgot-password" class="back-link">
                    <i class="bi bi-pencil-square"></i> Nhập email khác
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
                    show: function (type, message, duration = 3000) {
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
                                }, 1200);
                            }
                        };
                        return toast;
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

            // 30-Second Countdown Timer for Resend Button
            const resendBtn = document.getElementById('resendBtn');
            const resendText = document.getElementById('resendText');
            const resendIcon = document.getElementById('resendIcon');
            const targetEmail = '<c:out value="${email}"/>';
            let countdown = 30;
            let timerId = null;

            function startCountdown(seconds) {
                countdown = seconds;
                resendBtn.disabled = true;
                resendIcon.className = 'bi bi-hourglass-split';

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
                        resendIcon.className = 'bi bi-arrow-repeat';
                    } else {
                        updateButtonLabel();
                    }
                }, 1000);
            }

            function updateButtonLabel() {
                resendText.textContent = 'Gửi lại sau (' + countdown + 's)';
            }

            resendBtn.addEventListener('click', function () {
                if (resendBtn.disabled) return;

                resendBtn.disabled = true;
                resendText.textContent = 'Đang gửi...';
                resendIcon.className = 'bi bi-arrow-repeat';

                const formData = new URLSearchParams();
                formData.append('email', targetEmail);

                fetch('${pageContext.request.contextPath}/auth/resend-forgot-password', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest',
                        'Accept': 'application/json'
                    },
                    body: formData.toString()
                })
                .then(response => {
                    return response.json()
                        .then(data => ({ status: response.status, body: data }))
                        .catch(() => ({ status: response.status, body: {} }));
                })
                .then(res => {
                    if (res.status === 200 && res.body.success) {
                        CoursonToast.show('success', res.body.message || 'Email xác thực mới đã được gửi đi! Vui lòng kiểm tra hộp thư của bạn.');
                        startCountdown(30);
                    } else if (res.status === 429) {
                        CoursonToast.show('warning', res.body.message || 'Vui lòng đợi 30 giây trước khi yêu cầu gửi lại email xác thực.');
                        startCountdown(30);
                    } else {
                        CoursonToast.show('error', res.body.message || 'Có lỗi xảy ra khi gửi lại email. Vui lòng thử lại sau.');
                        resendBtn.disabled = false;
                        resendText.textContent = 'Gửi lại email xác nhận';
                    }
                })
                .catch(err => {
                    CoursonToast.show('error', 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại kết nối mạng.');
                    resendBtn.disabled = false;
                    resendText.textContent = 'Gửi lại email xác nhận';
                });
            });

            // Start 30-second countdown immediately upon arrival
            startCountdown(30);

            <c:if test="${param.resent == 'true'}">
            CoursonToast.show('success', 'Email xác thực mới đã được gửi đi! Vui lòng kiểm tra hộp thư của bạn.');
            </c:if>
            <c:if test="${param.error == 'ratelimit'}">
            CoursonToast.show('warning', 'Vui lòng đợi 30 giây trước khi yêu cầu gửi lại email xác thực.');
            </c:if>
            <c:if test="${param.error == 'system'}">
            CoursonToast.show('error', 'Có lỗi xảy ra khi gửi lại email. Vui lòng thử lại sau.');
            </c:if>
        </script>
    </body>
</html>
