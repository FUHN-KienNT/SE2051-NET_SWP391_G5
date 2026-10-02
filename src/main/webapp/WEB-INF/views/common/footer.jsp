<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer class="cf-footer mt-auto">
    <div class="container py-5">
        <div class="row g-4 align-items-center justify-content-between">

            <div class="col-lg-6 col-md-7">
                <a class="cf-footer-brand d-inline-flex align-items-center gap-2 text-decoration-none mb-3" 
                   href="${pageContext.request.contextPath}/home">
                    <svg width="36" height="25" viewBox="0 0 38 26" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M31.2 10.9C30.4 5.5 25.8 1.4 20.2 1.4C15.6 1.4 11.5 4.3 9.9 8.5C9.2 8.2 8.4 8.0 7.6 8.0C3.4 8.0 0 11.4 0 15.6C0 19.8 3.4 23.2 7.6 23.2H30.9C34.8 23.2 38 20.0 38 16.1C38 12.5 35.1 9.5 31.2 10.9Z" fill="url(#cfFootGrad)" />
                        <path d="M22.5 1.5C21.7 1.4 21.0 1.4 20.2 1.4C15.6 1.4 11.5 4.3 9.9 8.5C10.7 8.5 11.5 8.7 12.3 9.0C13.5 5.8 16.6 3.5 20.2 3.5C23.2 3.5 25.8 4.9 27.5 7.1C26.1 4.5 24.5 2.6 22.5 1.5Z" fill="#FAAD3F" />
                        <defs>
                            <linearGradient id="cfFootGrad" x1="0" y1="0" x2="38" y2="24" gradientUnits="userSpaceOnUse">
                                <stop stop-color="#FAAD3F" />
                                <stop offset="0.45" stop-color="#F38020" />
                                <stop offset="1" stop-color="#E56B00" />
                            </linearGradient>
                        </defs>
                    </svg>
                    <div class="d-flex align-items-center">
                        <span class="cf-footer-brand-name">COURSON<span>.</span></span>
                        <span class="cf-footer-brand-tag">LMS</span>
                    </div>
                </a>
                <p class="cf-footer-desc mb-0 small">
                    Hệ thống quản lý học tập đại học và tổ chức đào tạo chuyên nghiệp. Đồng hành cùng bạn trên mọi nấc thang tri thức và phát triển sự nghiệp.
                </p>
            </div>

            <div class="col-lg-5 col-md-5 text-md-end">
                <div class="d-flex justify-content-md-end gap-3 mb-2 flex-wrap">
                    <a href="${pageContext.request.contextPath}/home" class="cf-footer-link">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/courses/catalog" class="cf-footer-link">Khóa học</a>
                </div>
                <div class="cf-footer-copy small">
                    &copy; 2026 <strong>Courson LMS</strong>. Tất cả các quyền được bảo lưu.
                </div>
            </div>

        </div>
    </div>
</footer>

<style>
    .cf-footer {
        background-color: #F5EFEB;
        border-top: 1px solid #E6DDD4;
    }

    .cf-footer-brand-name {
        font-weight: 800;
        font-size: 1.28rem;
        letter-spacing: -0.5px;
        color: #111827; 
        line-height: 1;
    }

    .cf-footer-brand-name span {
        color: #F38020;
    }

    .cf-footer-brand-tag {
        font-size: 10px;
        font-weight: 700;
        background: #FFF5EB;
        color: #F38020;
        border: 1px solid #FCD5B5;
        padding: 1px 6px;
        border-radius: 4px;
        letter-spacing: 0.5px;
        margin-left: 6px;
        vertical-align: middle;
    }

    .cf-footer-desc {
        max-width: 460px;
        line-height: 1.65;
        color: #4B5563 !important;
    }

    .cf-footer-link {
        font-size: 0.88rem;
        font-weight: 600;
        color: #374151;
        text-decoration: none;
        transition: color 0.15s ease;
    }

    .cf-footer-link:hover {
        color: #F38020;
    }

    .cf-footer-copy {
        color: #6B7280;
    }
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>