<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản lý người dùng - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Quản lý người dùng</h3>
                <p class="text-muted small mb-0">Danh sách tài khoản và phân quyền trong hệ thống</p>
            </div>
        </div>

        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success py-2 small" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i>Thao tác người dùng thành công!
            </div>
        </c:if>

        <div class="card overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Tên đăng nhập</th>
                            <th>Họ và tên</th>
                            <th>Email</th>
                            <th>Vai trò</th>
                            <th>Trạng thái</th>
                            <th class="text-end">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>#${u.id}</td>
                                <td class="fw-semibold">${u.username}</td>
                                <td>${u.fullName}</td>
                                <td>${u.email}</td>
                                <td>
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                        ${u.roleName != null ? u.roleName : "USER"}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge ${u.status == 'ACTIVE' ? 'bg-success' : (u.status == 'BANNED' ? 'bg-danger' : 'bg-secondary')}">
                                        ${u.status}
                                    </span>
                                </td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/users/detail?id=${u.id}" class="btn btn-outline-primary btn-sm me-1" title="Chi tiết & Phân quyền">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>
                                    <c:choose>
                                        <c:when test="${u.status == 'ACTIVE'}">
                                            <a href="${pageContext.request.contextPath}/users/change-status?id=${u.id}&status=BANNED" class="btn btn-outline-danger btn-sm" onclick="return confirm('Khóa tài khoản người dùng này?');" title="Khóa tài khoản">
                                                <i class="bi bi-lock me-1"></i>Khóa
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/users/change-status?id=${u.id}&status=ACTIVE" class="btn btn-outline-success btn-sm" title="Mở khóa tài khoản">
                                                <i class="bi bi-unlock me-1"></i>Mở khóa
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
