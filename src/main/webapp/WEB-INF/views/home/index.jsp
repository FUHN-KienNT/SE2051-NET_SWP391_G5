<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Courson LMS - Nền tảng học trực tuyến thông minh" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<style>
    :root {
        --brand-orange: #F38020;
        --brand-orange-hover: #E56B00;
        --brand-orange-soft: #FFF7ED;
        --brand-orange-border: #FFEDD5;
        --text-heading: #111827;
        --text-body: #4B5563;
        --text-muted: #6B7280;
        --border-color: #E5E7EB;
        --bg-card: #FFFFFF;
    }

    body {
        background-color: #FFFFFF !important;
    }

    .cf-navbar {
        position: sticky !important;
        top: 0 !important;
        z-index: 1040 !important;
        background-color: rgba(255, 255, 255, 0.96) !important;
        backdrop-filter: blur(12px) !important;
        -webkit-backdrop-filter: blur(12px) !important;
    }

    .eyebrow-tag {
        font-size: 0.78rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.8px;
        color: var(--brand-orange);
        margin-bottom: 8px;
        display: inline-block;
    }

    .hero-section {
        padding: 56px 0 64px;
        background-color: #FFFFFF;
    }
    .hero-headline {
        font-size: 2.85rem;
        font-weight: 800;
        line-height: 1.15;
        color: var(--text-heading);
        letter-spacing: -0.6px;
        margin-bottom: 18px;
    }
    .hero-headline span.text-brand {
        color: var(--brand-orange);
    }
    .hero-sub {
        font-size: 1.05rem;
        color: var(--text-body);
        line-height: 1.65;
        margin-bottom: 32px;
        max-width: 520px;
    }
    .hero-actions {
        display: flex;
        align-items: center;
        gap: 16px;
        flex-wrap: wrap;
    }
    .btn-pill-primary {
        background-color: var(--brand-orange);
        color: #fff !important;
        border: none;
        border-radius: 9999px;
        padding: 12px 26px;
        font-weight: 700;
        font-size: 0.92rem;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
        transition: all 0.2s ease;
        box-shadow: 0 4px 12px rgba(243, 128, 32, 0.25);
    }
    .btn-pill-primary:hover {
        background-color: var(--brand-orange-hover);
        transform: translateY(-1px);
        box-shadow: 0 6px 16px rgba(243, 128, 32, 0.35);
    }
    .btn-pill-ghost {
        color: var(--text-heading) !important;
        font-weight: 600;
        font-size: 0.92rem;
        text-decoration: none;
        padding: 12px 16px;
        border-radius: 9999px;
        transition: color 0.15s ease;
    }
    .btn-pill-ghost:hover {
        color: var(--brand-orange) !important;
    }

    .hero-card-container {
        background-color: #FFF7ED;
        border: 1px solid #FFEDD5;
        border-radius: 28px;
        padding: 32px;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 330px;
        position: relative;
    }
    .hero-terminal-card {
        background-color: #141416;
        border: 1px solid #262626;
        border-radius: 18px;
        padding: 24px;
        width: 100%;
        max-width: 380px;
        color: #fff;
        box-shadow: 0 20px 35px -10px rgba(0, 0, 0, 0.25);
    }
    .terminal-dots {
        display: flex;
        gap: 6px;
        margin-bottom: 20px;
    }
    .terminal-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background-color: #404040;
    }
    .terminal-dot.active {
        background-color: var(--brand-orange);
    }
    .terminal-icon-box {
        width: 44px;
        height: 44px;
        border-radius: 10px;
        background-color: rgba(243, 128, 32, 0.15);
        color: var(--brand-orange);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.35rem;
        margin-bottom: 16px;
    }
    .terminal-title {
        font-size: 1.1rem;
        font-weight: 700;
        margin-bottom: 6px;
        color: #fff;
    }
    .terminal-desc {
        font-size: 0.84rem;
        color: #A3A3A3;
        line-height: 1.5;
        margin-bottom: 20px;
    }
    .terminal-bars {
        display: flex;
        gap: 6px;
    }
    .terminal-bar {
        height: 4px;
        flex: 1;
        border-radius: 9999px;
        background-color: #262626;
    }
    .terminal-bar.filled {
        background-color: var(--brand-orange);
    }
</style>

<main class="main-content">

    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center g-5">

                <div class="col-lg-7">
                    <c:choose>
                        <c:when test="${sessionScope.CURRENT_USER != null}">
                            <span class="eyebrow-tag">CHÀO MỪNG BẠN QUAY TRỞ LẠI</span>
                            <h1 class="hero-headline">
                                Tiếp tục học tập cùng <span class="text-brand">Courson.</span>
                            </h1>
                            <p class="hero-sub">
                                Xin chào <strong>${not empty sessionScope.CURRENT_USER.fullName ? sessionScope.CURRENT_USER.fullName : sessionScope.CURRENT_USER.username}</strong>! Hãy tiếp tục các bài giảng, kiểm tra tiến độ và tích lũy chứng chỉ kỹ năng ngay hôm nay.
                            </p>
                            <div class="hero-actions">
                                <c:choose>
                                    <c:when test="${sessionScope.CURRENT_USER.roleName == 'STUDENT'}">
                                        <a href="${pageContext.request.contextPath}/registrations/my" class="btn-pill-primary">
                                            Khóa học của tôi <i class="bi bi-arrow-right"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/courses/catalog" class="btn-pill-ghost">
                                            Khám phá thêm khóa học
                                        </a>
                                    </c:when>
                                    <c:when test="${sessionScope.CURRENT_USER.roleName == 'EXPERT'}">
                                        <a href="${pageContext.request.contextPath}/expert/dashboard" class="btn-pill-primary">
                                            Expert Studio <i class="bi bi-arrow-right"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/courses/catalog" class="btn-pill-ghost">
                                            Xem danh mục khóa học
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-pill-primary">
                                            Trang Quản trị <i class="bi bi-arrow-right"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/courses/catalog" class="btn-pill-ghost">
                                            Xem danh mục khóa học
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <span class="eyebrow-tag">LEARN YOUR WAY</span>
                            <h1 class="hero-headline">
                                Bắt đầu hành trình học tập cùng <span class="text-brand">Courson.</span>
                            </h1>
                            <p class="hero-sub">
                                Khám phá các khóa học thực chiến chuẩn đại học & quốc tế, học từng bài theo tiến độ riêng và làm chủ kỹ năng số trong tầm tay.
                            </p>
                            <div class="hero-actions">
                                <a href="${pageContext.request.contextPath}/courses/catalog" class="btn-pill-primary">
                                    Khám phá khóa học <i class="bi bi-arrow-right"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/auth/register" class="btn-pill-ghost">
                                    Tạo tài khoản miễn phí
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="col-lg-5">
                    <div class="hero-card-container">
                        <div class="hero-terminal-card">
                            <div class="terminal-dots">
                                <div class="terminal-dot active"></div>
                                <div class="terminal-dot"></div>
                                <div class="terminal-dot"></div>
                            </div>
                            <div class="terminal-icon-box">
                                <i class="bi bi-laptop"></i>
                            </div>
                            <h3 class="terminal-title">Học qua thực hành</h3>
                            <p class="terminal-desc">
                                Bài học thực tế, bài kiểm tra tương tác và trang bị kỹ năng ứng dụng doanh nghiệp chuẩn đầu ra.
                            </p>
                            <div class="terminal-bars">
                                <div class="terminal-bar filled"></div>
                                <div class="terminal-bar"></div>
                                <div class="terminal-bar"></div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

</main>

<jsp:include page="../common/footer.jsp" />