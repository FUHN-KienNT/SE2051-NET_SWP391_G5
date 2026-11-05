<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên mật khẩu - Courson LMS</title>
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
            }

            .alert-server-success {
                background-color: rgba(16, 185, 129, 0.12);
                border: 1px solid rgba(16, 185, 129, 0.45);
                border-radius: 10px;
                color: #059669;
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

            .field-error {
                color: #ed4956;
                font-size: 0.8rem;
                min-height: 18px;
                margin-top: 5px;
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
                margin-top: 20px;
                cursor: pointer;
                transition: background-color 0.15s, opacity 0.15s, transform 0.1s;
                text-align: center;
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
                <h1 class="auth-title">Quên mật khẩu</h1>
                <p class="auth-subtitle">Vui lòng điền địa chỉ email của bạn. Chúng tôi sẽ gửi link xác thực để hỗ trợ bạn vào được tài khoản.</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-server">
                    <i class="bi bi-exclamation-circle"></i>
                    <span><c:out value="${errorMessage}"/></span>
                </div>
            </c:if>



            <form id="forgotPasswordForm" action="${pageContext.request.contextPath}/auth/forgot-password" method="POST" novalidate>
                <div class="field-group">
                    <label class="field-label" for="email">Địa chỉ Email</label>
                    <input type="email"
                           id="email"
                           name="email"
                           class="field-input"
                           placeholder="Nhập địa chỉ email của bạn"
                           value="<c:out value='${email}'/>"
                           required
                           autofocus
                           autocomplete="email">
                    <div class="field-error" id="emailError"></div>
                </div>

                <button type="submit" id="submitBtn" class="btn-submit">Yêu cầu đặt lại mật khẩu</button>

                <div style="text-align: center; margin-top: 24px;">
                    <a href="${pageContext.request.contextPath}/auth/login" class="back-link">
                        <i class="bi bi-arrow-left"></i> Quay lại đăng nhập
                    </a>
                </div>
            </form>
        </div>

        <script>
            (function () {
                const form = document.getElementById('forgotPasswordForm');
                const emailInput = document.getElementById('email');
                const emailError = document.getElementById('emailError');
                const submitBtn = document.getElementById('submitBtn');

                const EMAIL_RE = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

                function validateEmail() {
                    const val = emailInput.value.trim();
                    if (!val) {
                        emailInput.classList.add('field-err');
                        emailError.textContent = 'Vui lòng nhập địa chỉ email.';
                        return false;
                    }
                    if (!EMAIL_RE.test(val)) {
                        emailInput.classList.add('field-err');
                        emailError.textContent = 'Địa chỉ email không đúng định dạng.';
                        return false;
                    }
                    emailInput.classList.remove('field-err');
                    emailError.textContent = '';
                    return true;
                }

                emailInput.addEventListener('input', function () {
                    if (emailInput.classList.contains('field-err')) {
                        validateEmail();
                    }
                });

                form.addEventListener('submit', function (e) {
                    if (!validateEmail()) {
                        e.preventDefault();
                        emailInput.focus();
                        return;
                    }
                    submitBtn.disabled = true;
                    submitBtn.textContent = 'Đang xử lý...';
                });
            })();
        </script>
    </body>
</html>
