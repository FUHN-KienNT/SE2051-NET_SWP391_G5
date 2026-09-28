<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Dashboard - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1"><i class="bi bi-speedometer2 me-2"></i>Bảng điều khiển Quản trị (Admin Dashboard)</h3>
                <p class="text-muted small mb-0">Theo dõi chỉ số hệ thống, giám sát vận hành và lối tắt quản lý (Màn hình II.2.1)</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-primary">
                    <i class="bi bi-journal-bookmark me-1"></i>Quản lý Khóa học
                </a>
            </div>
        </div>

        <!-- Metrics Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-primary text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-bold">Tổng số khóa học</div>
                            <div class="fs-2 fw-bold mt-1">${totalCourses != null ? totalCourses : 0}</div>
                        </div>
                        <i class="bi bi-book fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-success text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-bold">Chuyên gia nội dung (Expert)</div>
                            <div class="fs-2 fw-bold mt-1">${totalExperts != null ? totalExperts : 0}</div>
                        </div>
                        <i class="bi bi-person-badge fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-info text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-bold">Trạng thái hệ thống</div>
                            <div class="fs-2 fw-bold mt-1">Hoạt động</div>
                        </div>
                        <i class="bi bi-hdd-network fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions & Recent Courses -->
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold mb-0">Khóa học mới cập nhật</h5>
                        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-primary btn-sm">Xem tất cả</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên khóa học</th>
                                    <th>Chuyên gia phụ trách</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty recentCourses}">
                                        <tr><td colspan="5" class="text-center py-4 text-muted">Chưa có khóa học nào.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="c" items="${recentCourses}">
                                            <tr>
                                                <td>#${c.id}</td>
                                                <td class="fw-semibold">${c.title}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.expertName != null}">
                                                            <span class="badge bg-info-subtle text-dark border"><i class="bi bi-person me-1"></i>${c.expertName}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted fst-italic">Chưa phân công</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="badge ${c.status == 'PUBLISHED' ? 'bg-success' : 'bg-secondary'}">${c.status}</span>
                                                </td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/admin/course-detail?id=${c.id}" class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-pencil-square"></i> Quản lý
                                                    </a>
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

            <!-- Quick shortcuts -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-lightning-charge me-1"></i>Lối tắt nhanh</h5>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-primary text-start py-2">
                            <i class="bi bi-plus-circle me-2"></i>Tạo &amp; Phân công khóa học mới
                        </a>
                        <a href="${pageContext.request.contextPath}/users/list" class="btn btn-outline-secondary text-start py-2">
                            <i class="bi bi-people me-2"></i>Quản lý người dùng &amp; Phân quyền
                        </a>
                        <a href="${pageContext.request.contextPath}/settings/list" class="btn btn-outline-secondary text-start py-2">
                            <i class="bi bi-gear me-2"></i>Cấu hình hệ thống (Settings)
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
