<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-mortarboard-fill fs-3"></i>
            <span>Courson LMS</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-house-door me-1"></i>Trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/courses/catalog">
                        <i class="bi bi-collection me-1"></i>Khóa học
                    </a>
                </li>
                <c:if test="${sessionScope.CURRENT_USER != null}">
                    <c:if test="${sessionScope.CURRENT_USER.roleName == 'STUDENT'}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/registrations/my">
                                <i class="bi bi-journal-bookmark me-1"></i>Khóa học của tôi
                            </a>
                        </li>
                    </c:if>

                    <c:if test="${sessionScope.CURRENT_USER.roleName == 'EXPERT'}">
                        <li class="nav-item">
                            <a class="nav-link text-primary fw-semibold" href="${pageContext.request.contextPath}/expert/dashboard">
                                <i class="bi bi-mortarboard me-1"></i>Expert Dashboard
                            </a>
                        </li>
                    </c:if>

                    <c:if test="${sessionScope.CURRENT_USER.roleName == 'ADMIN' || sessionScope.CURRENT_USER.roleName == 'MANAGER'}">
                        <li class="nav-item">
                            <a class="nav-link text-danger fw-semibold" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="bi bi-speedometer2 me-1"></i>Admin Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/courses">
                                <i class="bi bi-collection me-1"></i>Quản lý Khóa học
                            </a>
                        </li>
                        <c:if test="${sessionScope.CURRENT_USER.roleName == 'ADMIN'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/users/list">
                                    <i class="bi bi-people me-1"></i>Người dùng
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/settings/list">
                                    <i class="bi bi-gear me-1"></i>Cấu hình
                                </a>
                            </li>
                        </c:if>
                    </c:if>
                </c:if>
            </ul>
            <ul class="navbar-nav align-items-center gap-2">
                <c:choose>
                    <c:when test="${sessionScope.CURRENT_USER != null}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" role="button" data-bs-toggle="dropdown">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                                    ${sessionScope.CURRENT_USER.roleName}
                                </span>
                                <strong>${sessionScope.CURRENT_USER.fullName}</strong>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/users/profile">
                                        <i class="bi bi-person me-2"></i>Hồ sơ cá nhân
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="btn btn-outline-primary btn-sm px-3" href="${pageContext.request.contextPath}/auth/login">Đăng nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary btn-sm px-3" href="${pageContext.request.contextPath}/auth/register">Đăng ký</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
