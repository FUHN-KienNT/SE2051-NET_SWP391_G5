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
                background: linear-gradient(135deg, #0a0a0a 0%, #111 50%, #0d0d0d 100%);
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 60px 48px;
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
                background-color: #000;
            }
            @media (min-width: 960px) {
                .login-right {
                    flex: 1 1 50%;
                    width: 50%;
                    max-width: 50%;
                    border-left: 1px solid #1a1a1a;
                }
            }

            .auth-container {
                width: 100%;
                max-width: 380px;
                margin: 0 auto;
            }

            .brand-row {
                display: flex;
                align-items: center;
                margin-bottom: 24px;
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
                color: #555;
                font-size: 0.8rem;
            }
            .divider::before, .divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: #2a2a2a;
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
                border-color: #666;
                background: #111;
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
                border-color: #666;
                background: #111;
                color: #fff;
            }

            .auth-footer {
                margin-top: 32px;
                font-size: 0.78rem;
                color: #737373;
                text-align: center;
                line-height: 1.5;
            }

            .left-brand {
                display: flex;
                align-items: center;
                margin-bottom: 40px;
                align-self: flex-start;
            }
            .left-headline {
                font-size: 2rem;
                font-weight: 800;
                color: #fff;
                line-height: 1.25;
                margin-bottom: 16px;
                letter-spacing: -0.5px;
                width: 100%;
                max-width: 420px;
            }
            .left-sub {
                font-size: 1rem;
                color: #a8a8a8;
                line-height: 1.6;
                margin-bottom: 40px;
                width: 100%;
                max-width: 420px;
            }
            .course-cards {
                display: flex;
                flex-direction: column;
                gap: 14px;
                width: 100%;
                max-width: 420px;
            }
            .course-card {
                background: #111;
                border: 1px solid #222;
                border-radius: 14px;
                padding: 14px 16px;
                display: flex;
                gap: 14px;
                align-items: center;
            }
            .course-thumb {
                width: 60px;
                height: 44px;
                border-radius: 8px;
                object-fit: cover;
                flex-shrink: 0;
                background: #222;
            }
            .course-info {
                flex: 1;
                min-width: 0;
            }
            .course-title {
                font-size: 0.85rem;
                font-weight: 600;
                color: #f0f0f0;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                margin-bottom: 4px;
            }
            .course-meta {
                font-size: 0.75rem;
                color: #666;
            }
            .course-badge {
                font-size: 0.72rem;
                font-weight: 600;
                color: #F38020;
                background: rgba(243,128,32,.12);
                border-radius: 20px;
                padding: 3px 10px;
                flex-shrink: 0;
            }
            .left-stat {
                display: flex;
                gap: 28px;
                margin-top: 36px;
                width: 100%;
                max-width: 420px;
                justify-content: flex-start;
            }
            .stat-item {
                text-align: left;
            }
            .stat-num {
                font-size: 1.5rem;
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
                width: 300px;
                height: 300px;
                border-radius: 50%;
                background: radial-gradient(circle, rgba(243,128,32,.08) 0%, transparent 70%);
                top: -80px;
                right: -80px;
                pointer-events: none;
            }
            .left-glow-2 {
                position: absolute;
                width: 200px;
                height: 200px;
                border-radius: 50%;
                background: radial-gradient(circle, rgba(243,128,32,.05) 0%, transparent 70%);
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

            <div class="left-brand">
                <svg width="48" height="33" viewBox="0 0 38 26" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M31.2 10.9C30.4 5.5 25.8 1.4 20.2 1.4C15.6 1.4 11.5 4.3 9.9 8.5C9.2 8.2 8.4 8.0 7.6 8.0C3.4 8.0 0 11.4 0 15.6C0 19.8 3.4 23.2 7.6 23.2H30.9C34.8 23.2 38 20.0 38 16.1C38 12.5 35.1 9.5 31.2 10.9Z" fill="url(#cfLoginGrad)"/>
                <path d="M22.5 1.5C21.7 1.4 21.0 1.4 20.2 1.4C15.6 1.4 11.5 4.3 9.9 8.5C10.7 8.5 11.5 8.7 12.3 9.0C13.5 5.8 16.6 3.5 20.2 3.5C23.2 3.5 25.8 4.9 27.5 7.1C26.1 4.5 24.5 2.6 22.5 1.5Z" fill="#FAAD3F"/>
                </svg>
            </div>

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

        <div class="login-right">
            <div class="auth-container">
            </div>
        </div>

    </body>
</html>