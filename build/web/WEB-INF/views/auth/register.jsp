<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đăng ký tài khoản - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content d-flex align-items-center py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card p-4">
                    <div class="text-center mb-4">
                        <i class="bi bi-person-plus-fill fs-1 text-primary"></i>
                        <h4 class="mt-2 fw-bold">Tạo tài khoản học viên</h4>
                        <p class="text-muted small">Bắt đầu hành trình nâng cao tri thức cùng hàng ngàn khóa học chất lượng</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger py-2 small" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i>${error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/auth/register" method="POST">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Họ và tên</label>
                            <input type="text" name="fullName" value="${registerDto.fullName}" class="form-control" required placeholder="Nguyễn Văn A">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Tên đăng nhập</label>
                            <input type="text" name="username" value="${registerDto.username}" class="form-control" required placeholder="nguyenvana">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Email</label>
                            <input type="email" name="email" value="${registerDto.email}" class="form-control" required placeholder="example@courson.edu.vn">
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Mật khẩu</label>
                                <input type="password" name="password" class="form-control" required placeholder="Tối thiểu 6 ký tự">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Nhập lại mật khẩu</label>
                                <input type="password" name="confirmPassword" class="form-control" required placeholder="Khớp với mật khẩu trên">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i>Đăng ký ngay
                        </button>
                    </form>

                    <div class="text-center mt-4">
                        <p class="small text-muted mb-0">
                            Đã có tài khoản? 
                            <a href="${pageContext.request.contextPath}/auth/login" class="fw-semibold text-primary text-decoration-none">Đăng nhập</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
