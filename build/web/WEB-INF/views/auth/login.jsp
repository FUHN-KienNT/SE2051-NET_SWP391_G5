<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đăng nhập - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content d-flex align-items-center py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="card p-4">
                    <div class="text-center mb-4">
                        <i class="bi bi-person-circle fs-1 text-primary"></i>
                        <h4 class="mt-2 fw-bold">Đăng nhập</h4>
                        <p class="text-muted small">Chào mừng bạn quay trở lại với Courson LMS</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger py-2 small" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i>${error}
                        </div>
                    </c:if>

                    <c:if test="${param.logout == 'true'}">
                        <div class="alert alert-success py-2 small" role="alert">
                            <i class="bi bi-check-circle-fill me-1"></i>Bạn đã đăng xuất thành công.
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/auth/login" method="POST">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Tên đăng nhập hoặc Email</label>
                            <input type="text" name="loginId" value="${loginId}" class="form-control" required autofocus placeholder="admin hoặc email">
                        </div>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <label class="form-label small fw-semibold">Mật khẩu</label>
                            </div>
                            <input type="password" name="password" class="form-control" required placeholder="Nhập mật khẩu">
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" name="rememberMe" class="form-check-input" id="rememberMe">
                            <label class="form-check-label small text-muted" for="rememberMe">Ghi nhớ đăng nhập</label>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                            <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
                        </button>
                    </form>

                    <div class="text-center mt-4">
                        <p class="small text-muted mb-0">
                            Chưa có tài khoản? 
                            <a href="${pageContext.request.contextPath}/auth/register" class="fw-semibold text-primary text-decoration-none">Đăng ký ngay</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
