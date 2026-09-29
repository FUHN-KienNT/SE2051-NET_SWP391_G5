<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký - Courson LMS</title>
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
            .brand-icon {
                font-size: 1.8rem;
                color: #fff;
            }
            .brand-name {
                font-size: 1.25rem;
                font-weight: 800;
                color: #fff;
                letter-spacing: -0.3px;
            }
            .auth-title {
                font-size: 1.45rem;
                font-weight: 700;
                color: #fff;
                margin-bottom: 6px;
                letter-spacing: -0.4px;
            }
            .auth-subtitle {
                font-size: 0.9rem;
                color: #a8a8a8;
                line-height: 1.4;
            }

            .alert-server {
                background-color: rgba(237, 73, 86, 0.12);
                border: 1px solid rgba(237, 73, 86, 0.45);
                border-radius: 10px;
                color: #ed4956;
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
            .field-input {
                width: 100%;
                background-color: #121212;
                border: 1px solid #363636;
                border-radius: 12px;
                color: #fff;
                font-size: 0.92rem;
                padding: 13px 16px;
                outline: none;
                transition: border-color 0.2s, background-color 0.2s;
                appearance: none;
            }
            .field-input::placeholder {
                color: #737373;
            }
            .field-input:focus {
                border-color: #737373;
                background-color: #161616;
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
            .toggle-icon {
                position: absolute;
                right: 14px;
                cursor: pointer;
                color: #a8a8a8;
                font-size: 1.25rem;
                display: none;
                align-items: center;
                justify-content: center;
                user-select: none;
                transition: color 0.15s;
            }
            .toggle-icon:hover {
                color: #fff;
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
                background-color: #363636;
                transition: background-color 0.2s;
            }
            .s-bar.weak   {
                background-color: #ed4956;
            }
            .s-bar.fair   {
                background-color: #f5a623;
            }
            .s-bar.strong {
                background-color: #3ee04b;
            }

            .field-error {
                color: #ed4956;
                font-size: 0.78rem;
                min-height: 16px;
                margin-top: 4px;
            }

            .terms-row {
                display: flex;
                align-items: flex-start;
                gap: 10px;
                margin: 18px 0 6px;
            }
            .terms-check {
                width: 17px;
                height: 17px;
                min-width: 17px;
                margin-top: 2px;
                accent-color: #0095f6;
                cursor: pointer;
            }
            .terms-label {
                font-size: 0.8rem;
                color: #a8a8a8;
                line-height: 1.5;
            }
            .terms-label a {
                color: #0095f6;
                text-decoration: none;
                font-weight: 600;
            }
            .terms-label a:hover {
                text-decoration: underline;
            }

            .btn-submit {
                display: block;
                width: 100%;
                background-color: #0095f6;
                color: #fff;
                border: none;
                border-radius: 9999px;
                font-size: 0.95rem;
                font-weight: 700;
                padding: 13px;
                margin-top: 20px;
                cursor: pointer;
                transition: background-color 0.15s;
                text-align: center;
            }
            .btn-submit:hover {
                background-color: #1877f2;
            }

            .btn-have-account {
                display: block;
                width: 100%;
                background-color: #262626;
                color: #f5f5f5;
                border: 1px solid transparent;
                border-radius: 9999px;
                font-size: 0.92rem;
                font-weight: 600;
                padding: 13px;
                margin-top: 14px;
                text-align: center;
                text-decoration: none;
                cursor: pointer;
                transition: background-color 0.15s, color 0.15s;
            }
            .btn-have-account:hover {
                background-color: #333333;
                color: #fff;
            }

            .auth-footer {
                margin-top: 48px;
                padding-bottom: 24px;
                text-align: center;
                font-size: 0.78rem;
                color: #737373;
                line-height: 1.5;
            }
        </style>
    </head>
    <body>

        <div class="auth-container">

            <div class="auth-header">
                <div class="brand-row">
                    <i class="bi bi-mortarboard-fill brand-icon"></i>
                    <span class="brand-name">Courson LMS</span>
                </div>
                <h1 class="auth-title">Bắt đầu trên Courson LMS</h1>
                <p class="auth-subtitle">Đăng ký để bắt đầu hành trình học tập của bạn.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert-server">
                    <i class="bi bi-exclamation-circle me-1"></i><c:out value="${error}"/>
                </div>
            </c:if>

            <form id="registerForm" action="${pageContext.request.contextPath}/auth/register" method="POST" novalidate>

                <div class="field-group">
                    <label class="field-label" for="email">Email</label>
                    <input type="email" id="email" name="email" class="field-input"
                           value="<c:out value='${registerDto.email}'/>"
                           placeholder="Nhập email của bạn" autocomplete="email">
                    <div class="field-error" id="emailError"></div>
                </div>

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

                <div class="field-group">
                    <label class="field-label" for="fullName">Tên</label>
                    <input type="text" id="fullName" name="fullName" class="field-input"
                           value="<c:out value='${registerDto.fullName}'/>"
                           placeholder="Tên đầy đủ" autocomplete="name">
                    <div class="field-error" id="fullNameError"></div>
                </div>

                <div class="field-group">
                    <label class="field-label" for="username">Tên người dùng</label>
                    <input type="text" id="username" name="username" class="field-input"
                           value="<c:out value='${registerDto.username}'/>"
                           placeholder="Tên người dùng" autocomplete="username">
                    <div class="field-error" id="usernameError"></div>
                </div>

                <div class="terms-row">
                    <input type="checkbox" id="agreeTerms" name="agreeTerms" class="terms-check">
                    <label for="agreeTerms" class="terms-label">
                        Bằng cách đăng ký, bạn đồng ý với
                        <a href="#">Điều khoản dịch vụ</a>,
                        <a href="#">Chính sách bảo mật</a> và
                        <a href="#">Chính sách cookie</a> của Courson.
                    </label>
                </div>
                <div class="field-error" id="termsError"></div>

                <button type="submit" class="btn-submit" id="submitBtn">Đăng ký</button>
            </form>

            <a href="${pageContext.request.contextPath}/auth/login" class="btn-have-account">
                Tôi có tài khoản rồi
            </a>

            <footer class="auth-footer">
                &copy; 2026 Courson LMS. Hệ thống quản lý học tập đại học và tổ chức đào tạo chuyên nghiệp.
            </footer>

        </div>

        <script>
            const pwInput = document.getElementById('password');
            const togglePw = document.getElementById('togglePw');
            const cpInput = document.getElementById('confirmPassword');
            const toggleCp = document.getElementById('toggleCp');

            pwInput.addEventListener('input', function () {
                togglePw.style.display = this.value.length > 0 ? 'inline-flex' : 'none';
                clearErr('passwordError', 'password');
            });

            cpInput.addEventListener('input', function () {
                toggleCp.style.display = this.value.length > 0 ? 'inline-flex' : 'none';
                clearErr('confirmError', 'confirmPassword');
            });

            function togglePass(fieldId, iconId) {
                const field = document.getElementById(fieldId);
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
                if (pw.length >= 8)
                    s++;
                if (/[A-Z]/.test(pw))
                    s++;
                if (/\d/.test(pw))
                    s++;
                if (/[!@#$%^&*()\-_=+\[\]{};':"\\|,.<>/?]/.test(pw))
                    s++;
                return s;
            }

            function updateBars(score) {
                const bars = [document.getElementById('b1'), document.getElementById('b2'),
                    document.getElementById('b3'), document.getElementById('b4')];
                bars.forEach(b => b.className = 's-bar');
                const cls = score <= 1 ? 'weak' : score <= 2 ? 'fair' : 'strong';
                for (let i = 0; i < score; i++)
                    bars[i].classList.add(cls);
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
                if (inputId)
                    document.getElementById(inputId).classList.add('field-err');
            }

            function clearErr(errId, inputId) {
                document.getElementById(errId).textContent = '';
                if (inputId)
                    document.getElementById(inputId).classList.remove('field-err');
            }

            const EMAIL_RE = /^[A-Za-z0-9+_.\-]+@[A-Za-z0-9.\-]+$/;
            const USER_RE = /^[a-zA-Z0-9_]{4,30}$/;

            document.getElementById('email').addEventListener('blur', function () {
                const v = this.value.trim();
                if (!v)
                    showErr('emailError', 'email', 'Email không được để trống.');
                else if (!EMAIL_RE.test(v))
                    showErr('emailError', 'email', 'Email không đúng định dạng.');
                else
                    clearErr('emailError', 'email');
            });
            document.getElementById('email').addEventListener('input', () => clearErr('emailError', 'email'));

            pwInput.addEventListener('blur', function () {
                const pw = this.value;
                if (!pw)
                    showErr('passwordError', 'password', 'Mật khẩu không được để trống.');
                else if (!STRONG_RE.test(pw))
                    showErr('passwordError', 'password',
                            'Mật khẩu phải từ 8–32 ký tự, có ít nhất 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.');
                else
                    clearErr('passwordError', 'password');
            });

            cpInput.addEventListener('blur', function () {
                if (!this.value)
                    showErr('confirmError', 'confirmPassword', 'Vui lòng xác nhận mật khẩu.');
                else if (this.value !== pwInput.value)
                    showErr('confirmError', 'confirmPassword', 'Mật khẩu xác nhận không khớp.');
                else
                    clearErr('confirmError', 'confirmPassword');
            });

            document.getElementById('fullName').addEventListener('blur', function () {
                const v = this.value.trim();
                if (!v)
                    showErr('fullNameError', 'fullName', 'Họ và tên không được để trống.');
                else if (v.length < 3 || v.length > 50)
                    showErr('fullNameError', 'fullName', 'Họ và tên phải từ 3 đến 50 ký tự.');
                else
                    clearErr('fullNameError', 'fullName');
            });
            document.getElementById('fullName').addEventListener('input', () => clearErr('fullNameError', 'fullName'));

            document.getElementById('username').addEventListener('blur', function () {
                const v = this.value.trim();
                if (!v)
                    showErr('usernameError', 'username', 'Tên người dùng không được để trống.');
                else if (!USER_RE.test(v))
                    showErr('usernameError', 'username',
                            'Tên người dùng phải từ 4–30 ký tự, chỉ gồm chữ cái, số hoặc dấu gạch dưới (_).');
                else
                    clearErr('usernameError', 'username');
            });
            document.getElementById('username').addEventListener('input', () => clearErr('usernameError', 'username'));

            document.getElementById('agreeTerms').addEventListener('change', function () {
                if (this.checked)
                    document.getElementById('termsError').textContent = '';
            });

            document.getElementById('registerForm').addEventListener('submit', function (e) {
                let ok = true;

                const email = document.getElementById('email').value.trim();
                if (!email || !EMAIL_RE.test(email)) {
                    showErr('emailError', 'email', 'Email không hợp lệ.');
                    ok = false;
                }

                const pw = pwInput.value;
                if (!pw || !STRONG_RE.test(pw)) {
                    showErr('passwordError', 'password',
                            'Mật khẩu phải từ 8–32 ký tự, có ít nhất 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.');
                    ok = false;
                }

                const cp = cpInput.value;
                if (cp !== pw) {
                    showErr('confirmError', 'confirmPassword', 'Mật khẩu xác nhận không khớp.');
                    ok = false;
                }

                const fn = document.getElementById('fullName').value.trim();
                if (!fn || fn.length < 3 || fn.length > 50) {
                    showErr('fullNameError', 'fullName', 'Họ và tên phải từ 3 đến 50 ký tự.');
                    ok = false;
                }

                const un = document.getElementById('username').value.trim();
                if (!un || !USER_RE.test(un)) {
                    showErr('usernameError', 'username',
                            'Tên người dùng phải từ 4–30 ký tự, chỉ gồm chữ cái, số hoặc dấu gạch dưới (_).');
                    ok = false;
                }

                if (!document.getElementById('agreeTerms').checked) {
                    document.getElementById('termsError').textContent =
                            'Bạn phải đồng ý với điều khoản dịch vụ để đăng ký.';
                    ok = false;
                }

                if (!ok)
                    e.preventDefault();
            });
        </script>

    </body>
</html>