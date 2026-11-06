<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt lại mật khẩu - Courson LMS</title>
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
                margin-bottom: 8px;
                letter-spacing: -0.4px;
            }
            .auth-subtitle {
                font-size: 0.92rem;
                color: #6B7280;
                line-height: 1.5;
            }

            .alert-server {
                background-color: rgba(237, 73, 86, 0.12);
                border: 1px solid rgba(237, 73, 86, 0.45);
                border-radius: 10px;
                color: #ed4956;
                font-size: 0.88rem;
                padding: 12px 14px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
                line-height: 1.45;
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
                font-size: 0.8rem;
                min-height: 18px;
                margin-top: 4px;
            }

            .btn-submit {
                display: block;
                width: 100%;
                background-color: #F38020;
                color: #fff;
                border: none;
                border-radius: 10px;
                font-size: 0.95rem;
                font-weight: 700;
                padding: 13px;
                margin-top: 24px;
                cursor: pointer;
                transition: background-color 0.15s, opacity 0.15s, transform 0.1s;
                text-align: center;
                text-decoration: none;
            }
            .btn-submit:hover {
                background-color: #E56B00;
            }
            .btn-submit:active {
                transform: scale(0.99);
            }
            .btn-submit:disabled {
                opacity: 0.65;
                cursor: not-allowed;
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                color: #6B7280;
                font-size: 0.88rem;
                font-weight: 500;
                text-decoration: none;
                transition: color 0.15s;
            }
            .back-link:hover {
                color: #F38020;
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
                <h1 class="auth-title">Đặt lại mật khẩu</h1>
                <p class="auth-subtitle">Tạo mật khẩu mới cho tài khoản Courson LMS của bạn để tiếp tục truy cập.</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-server">
                    <i class="bi bi-exclamation-circle"></i>
                    <span><c:out value="${errorMessage}"/></span>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${invalidToken}">
                    <div style="text-align: center; margin-top: 10px;">
                        <a href="${pageContext.request.contextPath}/auth/forgot-password" class="btn-submit">
                            Yêu cầu gửi lại link mới
                        </a>
                        <div style="margin-top: 20px;">
                            <a href="${pageContext.request.contextPath}/auth/login" class="back-link">
                                <i class="bi bi-arrow-left"></i> Quay lại đăng nhập
                            </a>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <form id="resetPasswordForm" action="${pageContext.request.contextPath}/auth/reset-password" method="POST" novalidate>
                        <input type="hidden" name="token" value="<c:out value='${token}'/>">

                        <div class="field-group">
                            <label class="field-label" for="password">Mật khẩu mới</label>
                            <div class="input-wrapper">
                                <input type="password"
                                       id="password"
                                       name="password"
                                       class="field-input ${not empty fieldErrors['password'] ? 'field-err' : ''}"
                                       placeholder="Nhập mật khẩu mới"
                                       autocomplete="new-password">
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
                            <div class="field-error" id="passwordError"><c:out value="${fieldErrors['password']}"/></div>
                        </div>

                        <div class="field-group">
                            <label class="field-label" for="confirmPassword">Xác nhận mật khẩu mới</label>
                            <div class="input-wrapper">
                                <input type="password"
                                       id="confirmPassword"
                                       name="confirmPassword"
                                       class="field-input ${not empty fieldErrors['confirmPassword'] ? 'field-err' : ''}"
                                       placeholder="Nhập lại mật khẩu mới"
                                       autocomplete="new-password">
                                <span class="toggle-icon" id="toggleCp" onclick="togglePass('confirmPassword', 'cpIcon')">
                                    <i class="bi bi-eye-slash" id="cpIcon"></i>
                                </span>
                            </div>
                            <div class="field-error" id="confirmError"><c:out value="${fieldErrors['confirmPassword']}"/></div>
                        </div>

                        <button type="submit" id="submitBtn" class="btn-submit">Lưu mật khẩu mới</button>

                        <div style="text-align: center; margin-top: 24px;">
                            <a href="${pageContext.request.contextPath}/auth/login" class="back-link">
                                <i class="bi bi-arrow-left"></i> Quay lại đăng nhập
                            </a>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>

        </div>

        <c:if test="${not invalidToken}">
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

            </script>
        </c:if>
    </body>
</html>
