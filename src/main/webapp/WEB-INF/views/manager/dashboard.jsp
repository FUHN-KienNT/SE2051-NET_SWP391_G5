<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Manager Dashboard - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1"><i class="bi bi-speedometer2 me-2"></i>Bảng điều khiển Quản lý (Manager Dashboard)</h3>
                <p class="text-muted small mb-0">Theo dõi khóa học và lượt đăng ký học viên</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/manager/courses" class="btn btn-outline-primary btn-sm">
                    <i class="bi bi-journal-bookmark me-1"></i>Quản lý Khóa học
                </a>
            </div>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Metrics Cards -->
        <div class="row g-4 mb-4">
            <div class="col-sm-6 col-xl-3">
                <div class="card p-3 border-0 shadow-sm rounded-3 bg-primary text-white h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-semibold">Tổng khóa học phụ trách</div>
                            <div class="fs-2 fw-bold mt-1">${totalCourses != null ? totalCourses : 0}</div>
                        </div>
                        <i class="bi bi-journal-code fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="card p-3 border-0 shadow-sm rounded-3 bg-success text-white h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-semibold">Lượt đăng ký khóa học</div>
                            <div class="fs-2 fw-bold mt-1">${totalRegistrations != null ? totalRegistrations : 0}</div>
                        </div>
                        <i class="bi bi-people fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="card p-3 border-0 shadow-sm rounded-3 bg-info text-white h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-semibold">Doanh thu tạm tính</div>
                            <div class="fs-2 fw-bold mt-1">
                                <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" type="currency" currencySymbol="VND" maxFractionDigits="0"/>
                            </div>
                        </div>
                        <i class="bi bi-cash-stack fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="card p-3 border-0 shadow-sm rounded-3 bg-dark text-white h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-semibold">Khóa học chờ duyệt</div>
                            <div class="fs-2 fw-bold mt-1 text-warning"><i class="bi bi-hourglass-split me-2"></i>${pendingCount != null ? pendingCount : 0}</div>
                        </div>
                        <i class="bi bi-bookmark-check fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Recent Registrations -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3 h-100">
                    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                        <h6 class="mb-0 fw-bold"><i class="bi bi-person-lines-fill text-primary me-2"></i>Giao dịch đăng ký gần đây</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3">Mã ĐK</th>
                                        <th>Khóa học</th>
                                        <th>Tiến độ</th>
                                        <th>Thanh toán</th>
                                        <th>Thời gian</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty recentRegistrations}">
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted">Chưa có lượt đăng ký nào</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="reg" items="${recentRegistrations}">
                                                <tr>
                                                    <td class="ps-3"><span class="badge bg-secondary">#${reg.id}</span></td>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="text-truncate" style="max-width: 250px;" title="${reg.courseTitle}">
                                                                <a href="${pageContext.request.contextPath}/course/detail?id=${reg.courseId}" class="text-decoration-none fw-semibold">${reg.courseTitle}</a>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="progress flex-grow-1" style="height: 6px;">
                                                                <div class="progress-bar bg-success" role="progressbar" style="width: ${reg.progressPercentage}%"></div>
                                                            </div>
                                                            <span class="small text-muted">${reg.progressPercentage}%</span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${reg.paymentStatus == 'COMPLETED'}"><span class="badge bg-success">Thành công</span></c:when>
                                                            <c:when test="${reg.paymentStatus == 'PENDING'}"><span class="badge bg-warning text-dark">Chờ thanh toán</span></c:when>
                                                            <c:otherwise><span class="badge bg-danger">Thất bại</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="small text-muted">
                                                        <fmt:parseDate value="${reg.registrationDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Courses -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-3 h-100">
                    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                        <h6 class="mb-0 fw-bold"><i class="bi bi-journals text-success me-2"></i>Khóa học phụ trách</h6>
                        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-sm btn-link text-decoration-none">Xem tất cả</a>
                    </div>
                    <div class="card-body p-0">
                        <div class="list-group list-group-flush">
                            <c:forEach var="course" items="${recentCourses}">
                                <a href="${pageContext.request.contextPath}/admin/course-detail?id=${course.id}" class="list-group-item list-group-item-action p-3">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <h6 class="mb-0 fw-semibold text-truncate" style="max-width: 200px;" title="${course.title}">${course.title}</h6>
                                        <c:choose>
                                            <c:when test="${course.status == 'PUBLISHED'}"><span class="badge bg-success rounded-pill">Đã duyệt</span></c:when>
                                            <c:when test="${course.status == 'PENDING_REVIEW'}"><span class="badge bg-warning text-dark rounded-pill">Chờ duyệt</span></c:when>
                                            <c:when test="${course.status == 'ARCHIVED'}"><span class="badge bg-secondary rounded-pill">Đã đóng</span></c:when>
                                            <c:otherwise><span class="badge bg-light text-dark border rounded-pill">Nháp</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <small class="text-muted"><i class="bi bi-tag me-1"></i>${course.categoryName}</small>
                                </a>
                            </c:forEach>
                            <c:if test="${empty recentCourses}">
                                <div class="p-4 text-center text-muted">
                                    <i class="bi bi-journal-x fs-3 d-block mb-2"></i>
                                    Bạn chưa phụ trách khóa học nào.
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
