<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Chi tiết người dùng - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Breadcrumb -->
        <nav class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/users/list">Người dùng</a></li>
                <li class="breadcrumb-item active">Chi tiết người dùng #${user.id}</li>
            </ol>
        </nav>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-person-lines-fill me-2 text-primary"></i>Thông tin &amp; Phân quyền người dùng</h5>

                    <form action="${pageContext.request.contextPath}/users/save" method="POST">
                        <input type="hidden" name="id" value="${user.id}">

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Tên đăng nhập</label>
                                <input type="text" name="username" class="form-control" value="${user.username}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Email</label>
                                <input type="email" name="email" class="form-control" value="${user.email}" readonly>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Họ và tên</label>
                            <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Vai trò (Role)</label>
                                <select name="roleId" class="form-select">
                                    <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Student (Học viên)</option>
                                    <option value="3" ${user.roleId == 3 ? 'selected' : ''}>Manager (Quản lý)</option>
                                    <option value="4" ${user.roleId == 4 ? 'selected' : ''}>Expert (Chuyên gia nội dung)</option>
                                    <option value="5" ${user.roleId == 5 ? 'selected' : ''}>Admin (Quản trị hệ thống)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Trạng thái tài khoản</label>
                                <select name="status" class="form-select">
                                    <option value="ACTIVE" ${user.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE (Hoạt động)</option>
                                    <option value="INACTIVE" ${user.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE (Chưa kích hoạt)</option>
                                    <option value="BANNED" ${user.status == 'BANNED' ? 'selected' : ''}>BANNED (Bị khóa)</option>
                                </select>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/users/list" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                            </a>
                            <button type="submit" class="btn btn-primary fw-semibold px-4">
                                <i class="bi bi-save me-1"></i>Lưu thông tin
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
