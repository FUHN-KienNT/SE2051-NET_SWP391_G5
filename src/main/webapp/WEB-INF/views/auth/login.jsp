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
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                background-color: #000;
                color: #fff;
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
                background: linear-gradient(135deg, #050505 0%, #0d0d0d 50%, #080808 100%);
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 80px 48px 48px;
                position: relative;
                overflow: hidden;
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
                background-color: #1F1F20;
            }
            @media (min-width: 960px) {
                .login-right {
                    flex: 1 1 50%;
                    width: 50%;
                    max-width: 50%;
                    border-left: 1px solid #2d2d2e;
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
                color: #fff;
                margin-bottom: 6px;
                letter-spacing: -0.4px;
            }
            .auth-subtitle {
                font-size: 0.9rem;
                color: #a8a8a8;
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
                color: #f5f5f5;
                margin-bottom: 8px;
            }
            .field-wrap {
                position: relative;
            }
            .field-input {
                width: 100%;
                background-color: #121212;
                border: 1px solid #363636;
                border-radius: 12px;
                color: #fff;
                font-size: 0.92rem;
                padding: 13px 16px;
                outline: none;
                transition: border-color .2s, background-color .2s;
                appearance: none;
            }
            .field-input::placeholder {
                color: #555;
            }
            .field-input:focus {
                border-color: #666;
                background-color: #181818;
            }
            .field-input.field-err {
                border-color: #ed4956;
            }
            .field-input.pw-input {
                padding-right: 48px;
            }

            .eye-btn {
                position: absolute;
                right: 14px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #888;
                cursor: pointer;
                display: none;
                align-items: center;
                justify-content: center;
                padding: 4px;
                font-size: 1rem;
            }
            .eye-btn:hover {
                color: #ccc;
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
                color: #a8a8a8;
                cursor: pointer;
                user-select: none;
            }
            .remember-label:hover {
                color: #f0f0f0;
            }
            .custom-checkbox {
                appearance: none;
                -webkit-appearance: none;
                width: 16px;
                height: 16px;
                border: 1px solid #444;
                border-radius: 4px;
                background: #141414;
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
                color: #a8a8a8;
                text-decoration: none;
            }
            .link-muted:hover {
                color: #fff;
                text-decoration: underline;
            }

            .btn-submit {
                width: 100%;
                padding: 13px;
                background: #fff;
                color: #000;
                border: none;
                border-radius: 12px;
                font-size: 0.95rem;
                font-weight: 700;
                cursor: pointer;
                transition: background .18s;
                margin-top: 6px;
            }
            .btn-submit:hover {
                background: #e8e8e8;
            }

            .divider {
                display: flex;
                align-items: center;
                gap: 12px;
                margin: 20px 0;
                color: #666;
                font-size: 0.8rem;
            }
            .divider::before, .divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: #333335;
            }

            .btn-google {
                width: 100%;
                padding: 12px;
                background: transparent;
                color: #fff;
                border: 1px solid #363636;
                border-radius: 12px;
                font-size: 0.92rem;
                font-weight: 500;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                transition: border-color .2s, background .2s;
                text-decoration: none;
            }
            .btn-google:hover {
                border-color: #555;
                background: rgba(255, 255, 255, 0.05);
                color: #fff;
            }

            .btn-no-account {
                display: block;
                width: 100%;
                margin-top: 20px;
                padding: 12px;
                background: transparent;
                color: #fff;
                border: 1px solid #363636;
                border-radius: 12px;
                font-size: 0.92rem;
                font-weight: 500;
                text-align: center;
                text-decoration: none;
                transition: border-color .2s, background .2s;
            }
            .btn-no-account:hover {
                border-color: #555;
                background: rgba(255, 255, 255, 0.05);
                color: #fff;
            }

            .auth-footer {
                margin-top: 32px;
                font-size: 0.78rem;
                color: #8e8e8e;
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
                color: #fff;
                line-height: 1.25;
                margin-bottom: 16px;
                letter-spacing: -0.5px;
            }
            .left-sub {
                font-size: 0.96rem;
                color: #a8a8a8;
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
                color: #f0f0f0;
                margin-bottom: 2px;
            }
            .feature-content p {
                font-size: 0.82rem;
                color: #888;
                line-height: 1.4;
            }

            .left-stat {
                display: flex;
                gap: 36px;
                width: 100%;
                max-width: 440px;
                justify-content: flex-start;
                padding-top: 20px;
                border-top: 1px solid #1c1c1c;
            }
            .stat-item {
                text-align: left;
            }
            .stat-num {
                font-size: 1.45rem;
                font-weight: 800;
                color: #fff;
            }
            .stat-label {
                font-size: 0.75rem;
                color: #666;
                margin-top: 2px;
            }

            .left-glow {
                position: absolute;
                width: 320px;
                height: 320px;
                border-radius: 50%;
                background: radial-gradient(circle, rgba(243,128,32,.08) 0%, transparent 70%);
                top: -80px;
                right: -80px;
                pointer-events: none;
            }
            .left-glow-2 {
                position: absolute;
                width: 220px;
                height: 220px;
                border-radius: 50%;
                background: radial-gradient(circle, rgba(243,128,32,.05) 0%, transparent 70%);
                bottom: 40px;
                left: 20px;
                pointer-events: none;
            }
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
        </style>
    </head>
    <body>
        <button type="button" class="theme-toggle-btn" id="themeToggleBtn" aria-label="Chuyển chế độ sáng/tối" title="Chuyển chế độ Sáng/Tối">
            <i class="bi bi-sun-fill" id="themeIcon"></i>
        </button>
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

                <a href="${pageContext.request.contextPath}/auth/google-callback" class="btn-google">
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
                    const themeToggleBtn = document.getElementById('themeToggleBtn');
                    const themeIcon = document.getElementById('themeIcon');

                    function updateThemeDisplay(theme) {
                        if (theme === 'light') {
                            document.documentElement.setAttribute('data-theme', 'light');
                            themeIcon.className = 'bi bi-moon-stars-fill';
                            themeToggleBtn.setAttribute('title', 'Chuyển sang chế độ Tối (Night Mode)');
                        } else {
                            document.documentElement.removeAttribute('data-theme');
                            themeIcon.className = 'bi bi-sun-fill';
                            themeToggleBtn.setAttribute('title', 'Chuyển sang chế độ Sáng (Light Mode)');
                        }
                    }

                    const savedTheme = localStorage.getItem('courson_auth_theme') || 'dark';
                    updateThemeDisplay(savedTheme);

                    themeToggleBtn.addEventListener('click', function () {
                        const isLight = document.documentElement.getAttribute('data-theme') === 'light';
                        const newTheme = isLight ? 'dark' : 'light';
                        localStorage.setItem('courson_auth_theme', newTheme);
                        updateThemeDisplay(newTheme);
                    });
                </script>
            </div>
        </div>

    </body>
</html>