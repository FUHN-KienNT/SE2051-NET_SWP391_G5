<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Hồ sơ cá nhân - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-6">
                <div class="card p-4">
                    <div class="text-center mb-4">
                        <i class="bi bi-person-bounding-box fs-1 text-primary"></i>
                        <h4 class="fw-bold mt-2">Hồ sơ cá nhân</h4>
                        <p class="text-muted small">Quản lý và cập nhật thông tin tài khoản của bạn</p>
                    </div>

                    <c:if test="${param.success == 'true'}">
                        <div class="alert alert-success py-2 small" role="alert">
                            <i class="bi bi-check-circle-fill me-1"></i>Cập nhật thông tin thành công!
                        </div>
                    </c:if>

                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger py-2 small" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i>${param.error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/users/update-profile" method="POST">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Tên đăng nhập</label>
                            <input type="text" class="form-control" value="${user.username}" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Email</label>
                            <input type="email" class="form-control" value="${user.email}" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Vai trò hệ thống</label>
                            <input type="text" class="form-control" value="${user.roleName}" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Họ và tên</label>
                            <input type="text" name="fullName" value="${user.fullName}" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                            <i class="bi bi-save me-1"></i>Lưu thay đổi
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
