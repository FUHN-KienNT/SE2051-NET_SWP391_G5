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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/toast.css">
        <script>
            (function () {
                const theme = localStorage.getItem('courson_auth_theme');
                if (theme === 'light') {
                    document.documentElement.setAttribute('data-theme', 'light');
                }
            })();
        </script>
        <style>
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

            /* Theme toggle */
            .theme-toggle-btn {
                position: fixed;
                top: 24px;
                right: 24px;
                width: 44px;
                height: 44px;
                border-radius: 12px;
                border: 1px solid var(--border-card);
                background: var(--bg-card);
                color: var(--text-main);
                display: inline-flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                font-size: 19px;
                transition: all 0.2s ease;
                z-index: 100;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
            .theme-toggle-btn:hover {
                transform: translateY(-2px);
                border-color: var(--primary);
                color: var(--primary);
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
                from { opacity: 0; transform: translateY(16px); }
                to { opacity: 1; transform: translateY(0); }
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

        <script src="${pageContext.request.contextPath}/js/toast.js"></script>
        <script>
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

                if (timerId) clearInterval(timerId);

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
                resendText.textContent = `Gửi lại sau (${countdown}s)`;
            }

            // Start countdown immediately on arrival
            startCountdown(60);

            // Handle Resend with Fetch (AJAX)
            resendForm.addEventListener('submit', function (e) {
                e.preventDefault();
                if (resendBtn.disabled) return;

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
