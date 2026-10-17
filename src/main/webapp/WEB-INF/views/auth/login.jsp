<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Courson LMS</title>
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

            body {
                background-color: #FFFFFF;
                color: #111827;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                min-height: 100vh;
                display: flex;
                width: 100%;
                overflow-x: hidden;
            }

            .login-left {
                display: none;
                flex: 1 1 50%;
                width: 50%;
                max-width: 50%;
                background: linear-gradient(145deg, #FFF9F5 0%, #FFF3E6 100%);
                border-right: 1px solid #FFE4CC;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 80px 48px 48px;
                position: relative;
                overflow: hidden;
            }
            .left-brand, .left-content-block, .left-glow, .left-glow-2 {
                position: relative;
                z-index: 2;
            }

            @media (min-width: 960px) {
                .login-left {
                    display: flex;
                }
            }

            .login-right {
                flex: 1 1 100%;
                width: 100%;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 48px 24px 32px;
                background-color: #FFFFFF;
            }
            @media (min-width: 960px) {
                .login-right {
                    flex: 1 1 50%;
                    width: 50%;
                    max-width: 50%;
                    border-left: 1px solid #E5E7EB;
                }
            }

            .auth-container {
                width: 100%;
                max-width: 380px;
                margin: 0 auto;
            }

            .auth-title {
                font-size: 1.55rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 6px;
                letter-spacing: -0.4px;
            }
            .auth-subtitle {
                font-size: 0.9rem;
                color: #6B7280;
                margin-bottom: 24px;
            }

            .alert-server {
                background: rgba(237,73,86,.12);
                border: 1px solid rgba(237,73,86,.45);
                border-radius: 10px;
                color: #ed4956;
                font-size: 0.84rem;
                padding: 11px 14px;
                margin-bottom: 20px;
                text-align: center;
            }
            .alert-success {
                background: rgba(0,186,124,.12);
                border: 1px solid rgba(0,186,124,.4);
                border-radius: 10px;
                color: #00ba7c;
                font-size: 0.84rem;
                padding: 11px 14px;
                margin-bottom: 20px;
                text-align: center;
            }

            .field-group {
                margin-bottom: 16px;
            }
            .field-label {
                display: block;
                font-size: 0.88rem;
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
            }
            .field-wrap {
                position: relative;
            }
            .field-input {
                width: 100%;
                background-color: #F9FAFB;
                border: 1px solid #E5E7EB;
                border-radius: 12px;
                color: #111827;
                font-size: 0.92rem;
                padding: 13px 16px;
                outline: none;
                transition: border-color .2s, background-color .2s, box-shadow .2s;
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
            .field-input.pw-input {
                padding-right: 48px;
            }
            input::-ms-reveal,
            input::-ms-clear {
                display: none;
            }

            .eye-btn {
                position: absolute;
                right: 14px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #9CA3AF;
                cursor: pointer;
                display: none;
                align-items: center;
                justify-content: center;
                padding: 4px;
                font-size: 1rem;
                transition: color 0.15s;
            }
            .eye-btn:hover {
                color: #111827;
            }

            .field-error {
                font-size: 0.78rem;
                color: #ed4956;
                margin-top: 5px;
                min-height: 18px;
            }

            .form-action-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 8px;
                margin-bottom: 6px;
            }
            .remember-label {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 0.83rem;
                color: #4B5563;
                cursor: pointer;
                user-select: none;
            }
            .remember-label:hover {
                color: #111827;
            }
            .custom-checkbox {
                appearance: none;
                -webkit-appearance: none;
                width: 16px;
                height: 16px;
                border: 1px solid #D1D5DB;
                border-radius: 4px;
                background: #F3F4F6;
                cursor: pointer;
                display: inline-grid;
                place-content: center;
                margin: 0;
                transition: all 0.15s ease;
            }
            .custom-checkbox:checked {
                background: #F38020;
                border-color: #F38020;
            }
            .custom-checkbox:checked::before {
                content: "";
                width: 8px;
                height: 5px;
                border-left: 2px solid #fff;
                border-bottom: 2px solid #fff;
                transform: rotate(-45deg) translate(1px, -1px);
            }
            .link-muted {
                font-size: 0.83rem;
                color: #6B7280;
                text-decoration: none;
            }
            .link-muted:hover {
                color: #F38020;
                text-decoration: underline;
            }

            .btn-submit {
                width: 100%;
                padding: 13px;
                background: #F38020;
                color: #FFFFFF;
                border: none;
                border-radius: 12px;
                font-size: 0.95rem;
                font-weight: 700;
                cursor: pointer;
                transition: background .18s;
                margin-top: 6px;
            }
            .btn-submit:hover {
                background: #E56B00;
            }

            .divider {
                display: flex;
                align-items: center;
                gap: 12px;
                margin: 20px 0;
                color: #9CA3AF;
                font-size: 0.8rem;
            }
            .divider::before, .divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: #E5E7EB;
            }

            .btn-google {
                width: 100%;
                padding: 12px;
                background: #FFFFFF;
                color: #374151;
                border: 1px solid #E5E7EB;
                border-radius: 12px;
                font-size: 0.92rem;
                font-weight: 500;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                transition: border-color .2s, background .2s, color .2s;
                text-decoration: none;
            }
            .btn-google:hover {
                border-color: #D1D5DB;
                background: #F9FAFB;
                color: #111827;
            }

            .btn-no-account {
                display: block;
                width: 100%;
                margin-top: 20px;
                padding: 12px;
                background: transparent;
                color: #374151;
                border: 1px solid #E5E7EB;
                border-radius: 12px;
                font-size: 0.92rem;
                font-weight: 500;
                text-align: center;
                text-decoration: none;
                transition: border-color .2s, background .2s, color .2s;
            }
            .btn-no-account:hover {
                background: #FFF7ED;
                border-color: #F38020;
                color: #F38020;
            }

            .auth-footer {
                margin-top: 32px;
                font-size: 0.78rem;
                color: #9CA3AF;
                text-align: center;
                line-height: 1.5;
            }

            .left-brand {
                position: absolute;
                top: 28px;
                left: 48px;
                display: flex;
                align-items: center;
                z-index: 10;
            }
            .left-content-block {
                width: 100%;
                max-width: 440px;
                display: flex;
                flex-direction: column;
            }
            .left-headline {
                font-size: 2.1rem;
                font-weight: 800;
                color: #111827;
                line-height: 1.25;
                margin-bottom: 16px;
                letter-spacing: -0.5px;
            }
            .left-sub {
                font-size: 0.96rem;
                color: #4B5563;
                line-height: 1.6;
                margin-bottom: 36px;
            }

            .feature-list {
                display: flex;
                flex-direction: column;
                gap: 20px;
                margin-bottom: 36px;
            }
            .feature-item {
                display: flex;
                align-items: center;
                gap: 16px;
            }
            .feature-icon-box {
                width: 42px;
                height: 42px;
                border-radius: 10px;
                background: rgba(243, 128, 32, 0.1);
                border: 1px solid rgba(243, 128, 32, 0.2);
                color: #F38020;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                flex-shrink: 0;
            }
            .feature-content h4 {
                font-size: 0.95rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 2px;
            }
            .feature-content p {
                font-size: 0.82rem;
                color: #6B7280;
                line-height: 1.4;
            }

            .left-stat {
                display: flex;
                gap: 36px;
                width: 100%;
                max-width: 440px;
                justify-content: flex-start;
                padding-top: 20px;
                border-top: 1px solid #FFE4CC;
            }
            .stat-item {
                text-align: left;
            }
            .stat-num {
                font-size: 1.45rem;
                font-weight: 800;
                color: #111827;
            }
            .stat-label {
                font-size: 0.75rem;
                color: #6B7280;
                margin-top: 2px;
            }

            .left-glow {
                position: absolute;
                width: 320px;
                height: 320px;
                border-radius: 50%;
                background: radial-gradient(circle, rgba(243,128,32,.14) 0%, transparent 70%);
                top: -80px;
                right: -80px;
                pointer-events: none;
            }
            .left-glow-2 {
                position: absolute;
                width: 220px;
                height: 220px;
                border-radius: 50%;
                background: radial-gradient(circle, rgba(243,128,32,.09) 0%, transparent 70%);
                bottom: 40px;
                left: 20px;
                pointer-events: none;
            }
        </style>
    </head>
    <body>
        <svg width="0" height="0" style="position:absolute">
        <defs>
        <linearGradient id="cfLoginGrad" x1="0" y1="0" x2="38" y2="24" gradientUnits="userSpaceOnUse">
        <stop stop-color="#FAAD3F"/>
        <stop offset="0.45" stop-color="#F38020"/>
        <stop offset="1" stop-color="#E56B00"/>
        </linearGradient>
        </defs>
        </svg>

        <div class="login-left">
            <div class="left-glow"></div>
            <div class="left-glow-2"></div>

            <div class="left-brand" style="position: absolute !important; top: 28px !important; left: 48px !important; z-index: 10;">
                <a href="${pageContext.request.contextPath}/home" title="Về trang chủ" style="display: inline-flex; align-items: center; text-decoration: none; cursor: pointer;">
                    <svg width="58" height="40" viewBox="0 0 38 26" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M31.2 10.9C30.4 5.5 25.8 1.4 20.2 1.4C15.6 1.4 11.5 4.3 9.9 8.5C9.2 8.2 8.4 8.0 7.6 8.0C3.4 8.0 0 11.4 0 15.6C0 19.8 3.4 23.2 7.6 23.2H30.9C34.8 23.2 38 20.0 38 16.1C38 12.5 35.1 9.5 31.2 10.9Z" fill="url(#cfLoginGrad)"/>
                    <path d="M22.5 1.5C21.7 1.4 21.0 1.4 20.2 1.4C15.6 1.4 11.5 4.3 9.9 8.5C10.7 8.5 11.5 8.7 12.3 9.0C13.5 5.8 16.6 3.5 20.2 3.5C23.2 3.5 25.8 4.9 27.5 7.1C26.1 4.5 24.5 2.6 22.5 1.5Z" fill="#FAAD3F"/>
                    </svg>
                </a>
            </div>

            <div class="left-content-block">
                <h2 class="left-headline">Học tập không giới hạn.<br>Kiến tạo tương lai.</h2>
                <p class="left-sub">Hệ thống quản lý học tập thông minh, đồng hành cùng bạn trên mọi nấc thang tri thức và phát triển sự nghiệp.</p>

                <div class="feature-list">
                    <div class="feature-item">
                        <div class="feature-icon-box">
                            <i class="bi bi-mortarboard-fill"></i>
                        </div>
                        <div class="feature-content">
                            <h4>Chương trình chuẩn đại học & quốc tế</h4>
                            <p>Giáo trình chất lượng cao được biên soạn bởi các chuyên gia.</p>
                        </div>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon-box">
                            <i class="bi bi-lightning-charge-fill"></i>
                        </div>
                        <div class="feature-content">
                            <h4>Lộ trình học tập cá nhân hóa</h4>
                            <p>Theo dõi tiến độ, làm bài kiểm tra và cấp chứng chỉ trực tiếp.</p>
                        </div>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon-box">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <div class="feature-content">
                            <h4>Cộng đồng học thuật gắn kết</h4>
                            <p>Trao đổi, thảo luận và kết nối trực tiếp cùng giảng viên.</p>
                        </div>
                    </div>
                </div>

                <div class="left-stat">
                    <div class="stat-item">
                        <div class="stat-num">50+</div>
                        <div class="stat-label">Khóa học chuyên sâu</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-num">1.2K+</div>
                        <div class="stat-label">Học viên tin tưởng</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-num">4.9★</div>
                        <div class="stat-label">Đánh giá xuất sắc</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="login-right">
            <div class="auth-container">
                <h1 class="auth-title">Đăng nhập vào Courson</h1>
                <p class="auth-subtitle">Chào mừng bạn quay trở lại.</p>

                <c:if test="${not empty error}">
                    <div class="alert-server">
                        <i class="bi bi-exclamation-circle me-1"></i><c:out value="${error}"/>
                    </div>
                </c:if>

                <c:if test="${not empty inactiveEmail}">
                    <div class="alert-inactive-box" style="margin-bottom: 20px; padding: 14px 16px; border-radius: 12px; background: rgba(243, 128, 32, 0.12); border: 1px solid rgba(243, 128, 32, 0.35); color: #F38020; font-size: 14px; display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap;">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <i class="bi bi-envelope-exclamation" style="font-size: 18px;"></i>
                            <span>Tài khoản chưa được kích hoạt email.</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/auth/check-email?email=<c:out value='${inactiveEmail}'/>" style="color: #ffffff; background: #F38020; text-decoration: none; padding: 6px 14px; border-radius: 8px; font-weight: 600; font-size: 13px; display: inline-flex; align-items: center; gap: 6px;">
                            Gửi lại email xác nhận <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </c:if>

                <c:if test="${param.logout == 'true'}">
                    <div class="alert-success">
                        <i class="bi bi-check-circle me-1"></i>Bạn đã đăng xuất thành công.
                    </div>
                </c:if>

                <c:if test="${param.registered == 'true'}">
                    <div class="alert-success">
                        <i class="bi bi-check-circle me-1"></i>Đăng ký thành công! Hãy đăng nhập để bắt đầu.
                    </div>
                </c:if>

                <form id="loginForm" action="${pageContext.request.contextPath}/auth/login" method="POST" novalidate>

                    <div class="field-group">
                        <label class="field-label" for="loginId">Tên đăng nhập hoặc Email</label>
                        <input type="text" id="loginId" name="loginId"
                               class="field-input"
                               value="<c:out value='${loginId}'/>"
                               placeholder="Nhập tên đăng nhập hoặc email"
                               autofocus autocomplete="username">
                        <div class="field-error" id="loginIdError"></div>
                    </div>

                    <div class="field-group">
                        <label class="field-label" for="password">Mật khẩu</label>
                        <div class="field-wrap">
                            <input type="password" id="password" name="password"
                                   class="field-input pw-input"
                                   placeholder="Nhập mật khẩu"
                                   autocomplete="current-password">
                            <button type="button" class="eye-btn" id="togglePw"
                                    onclick="togglePass('password', 'eyeIconPw')" tabindex="-1" aria-label="Hiện/ẩn mật khẩu">
                                <i class="bi bi-eye-slash" id="eyeIconPw"></i>
                            </button>
                        </div>

                        <div class="form-action-row">
                            <label class="remember-label" for="rememberMe">
                                <input type="checkbox" id="rememberMe" name="rememberMe" class="custom-checkbox">
                                <span>Ghi nhớ tài khoản</span>
                            </label>
                            <a href="#" class="link-muted">Quên mật khẩu?</a>
                        </div>

                        <div class="field-error" id="passwordError"></div>
                    </div>

                    <button type="submit" class="btn-submit">Đăng nhập</button>
                </form>

                <div class="divider">hoặc</div>

                <a href="${pageContext.request.contextPath}/auth/google" class="btn-google">
                    <svg width="18" height="18" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg">
                    <path d="M17.64 9.2c0-.637-.057-1.251-.164-1.84H9v3.481h4.844c-.209 1.125-.843 2.078-1.796 2.717v2.258h2.908c1.702-1.567 2.684-3.874 2.684-6.615z" fill="#4285F4"/>
                    <path d="M9 18c2.43 0 4.467-.806 5.956-2.18l-2.908-2.259c-.806.54-1.837.86-3.048.86-2.344 0-4.328-1.584-5.036-3.711H.957v2.332A8.997 8.997 0 0 0 9 18z" fill="#34A853"/>
                    <path d="M3.964 10.71A5.41 5.41 0 0 1 3.682 9c0-.593.102-1.17.282-1.71V4.958H.957A8.996 8.996 0 0 0 0 9c0 1.452.348 2.827.957 4.042l3.007-2.332z" fill="#FBBC05"/>
                    <path d="M9 3.58c1.321 0 2.508.454 3.44 1.345l2.582-2.58C13.463.891 11.426 0 9 0A8.997 8.997 0 0 0 .957 4.958L3.964 6.29C4.672 4.163 6.656 3.58 9 3.58z" fill="#EA4335"/>
                    </svg>
                    Đăng nhập bằng Google
                </a>

                <a href="${pageContext.request.contextPath}/auth/register" class="btn-no-account">
                    Chưa có tài khoản? Đăng ký
                </a>

                <footer class="auth-footer">
                    &copy; 2026 Courson LMS. Hệ thống quản lý học tập đại học và tổ chức đào tạo chuyên nghiệp.
                </footer>

                <script>
                    const pwInput = document.getElementById('password');
                    const togglePw = document.getElementById('togglePw');
                    const loginIdInput = document.getElementById('loginId');
                    const rememberMeCheck = document.getElementById('rememberMe');

                    const savedLogin = localStorage.getItem('courson_saved_login');
                    if (savedLogin) {
                        if (!loginIdInput.value) {
                            loginIdInput.value = savedLogin;
                        }
                        rememberMeCheck.checked = true;
                    }

                    pwInput.addEventListener('input', function () {
                        togglePw.style.display = this.value.length > 0 ? 'inline-flex' : 'none';
                        document.getElementById('passwordError').textContent = '';
                        this.classList.remove('field-err');
                    });

                    function togglePass(fieldId, iconId) {
                        const field = document.getElementById(fieldId);
                        const icon = document.getElementById(iconId);
                        field.type = field.type === 'password' ? 'text' : 'password';
                        icon.classList.toggle('bi-eye-slash');
                        icon.classList.toggle('bi-eye');
                    }

                    document.getElementById('loginForm').addEventListener('submit', function (e) {
                        let ok = true;
                        const loginIdVal = loginIdInput.value.trim();
                        if (!loginIdVal) {
                            document.getElementById('loginIdError').textContent = 'Vui lòng nhập tên đăng nhập hoặc email.';
                            loginIdInput.classList.add('field-err');
                            ok = false;
                        }

                        const pwVal = pwInput.value;
                        if (!pwVal) {
                            document.getElementById('passwordError').textContent = 'Vui lòng nhập mật khẩu.';
                            pwInput.classList.add('field-err');
                            ok = false;
                        }

                        if (ok) {
                            if (rememberMeCheck.checked) {
                                localStorage.setItem('courson_saved_login', loginIdVal);
                            } else {
                                localStorage.removeItem('courson_saved_login');
                            }
                        } else {
                            e.preventDefault();
                        }
                    });

                    loginIdInput.addEventListener('input', function () {
                        document.getElementById('loginIdError').textContent = '';
                        this.classList.remove('field-err');
                    });
                </script>
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
        </script>
        <c:if test="${not empty toastMessage}">
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    CoursonToast.show('<c:out value="${toastType}"/>', '<c:out value="${toastMessage}"/>');
                    CoursonToast.cleanUrlParams(['status']);
                });
            </script>
        </c:if>
    </body>
</html>