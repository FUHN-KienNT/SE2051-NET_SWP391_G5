<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Danh sách đăng ký - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <a href="${pageContext.request.contextPath}/manager/dashboard" class="text-decoration-none small text-muted">
                    <i class="bi bi-arrow-left"></i> Quay lại Dashboard
                </a>
                <h2 class="fw-bold mt-2 mb-1"><i class="bi bi-people-fill text-primary me-2"></i>Registration List</h2>
                <p class="text-muted mb-0">Danh sách học viên đăng ký khóa học <strong>${course.title}</strong>.</p>
            </div>
            <span class="badge text-bg-primary fs-6 px-3 py-2">${registrations.size()} đăng ký</span>
        </div>

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">#</th>
                            <th>Học viên</th>
                            <th>Ngày đăng ký</th>
                            <th>Tiến độ</th>
                            <th>Thanh toán</th>
                            <th>Trạng thái</th>
                            <th class="text-end pe-4">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty registrations}">
                                <tr><td colspan="7" class="text-center text-muted py-5">
                                    <i class="bi bi-inbox fs-2 d-block mb-2"></i>Chưa có học viên đăng ký khóa học này.
                                </td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="registration" items="${registrations}">
                                    <tr>
                                        <td class="ps-4 text-muted">#${registration.id}</td>
                                        <td class="fw-semibold">${registration.userName}</td>
                                        <td>${registration.formattedRegistrationDate}</td>
                                        <td style="min-width: 140px;">
                                            <div class="d-flex justify-content-between small mb-1"><span>${registration.progressPercentage}%</span></div>
                                            <div class="progress" style="height: 7px;"><div class="progress-bar" style="width: ${registration.progressPercentage}%"></div></div>
                                        </td>
                                        <td><span class="badge text-bg-light border">${registration.paymentStatus}</span></td>
                                        <td><span class="badge text-bg-${registration.status == 'ACTIVE' ? 'success' : (registration.status == 'COMPLETED' ? 'primary' : 'secondary')}">${registration.status}</span></td>
                                        <td class="text-end pe-4"><a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/registrations/detail?id=${registration.id}">
                                            <i class="bi bi-eye"></i> Chi tiết</a></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<jsp:include page="../common/footer.jsp" />
