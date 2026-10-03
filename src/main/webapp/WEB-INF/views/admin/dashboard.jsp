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
                <p class="text-muted small mb-0">Theo dõi chỉ số hệ thống, giám sát vận hành và lối tắt quản lý tổng quan</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-primary btn-sm">
                    <i class="bi bi-journal-bookmark me-1"></i>Tất cả Khóa học
                </a>
            </div>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Metrics Cards (4 Stat Cards) -->
        <div class="row g-4 mb-4">
            <div class="col-sm-6 col-xl-3">
                <div class="card p-3 border-0 shadow-sm rounded-3 bg-primary text-white h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-semibold">Tổng người dùng</div>
                            <div class="fs-2 fw-bold mt-1">${totalUsers != null ? totalUsers : 0}</div>
                        </div>
                        <i class="bi bi-people fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="card p-3 border-0 shadow-sm rounded-3 bg-success text-white h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-semibold">Tổng khóa học</div>
                            <div class="fs-2 fw-bold mt-1">${totalCourses != null ? totalCourses : 0}</div>
                        </div>
                        <i class="bi bi-journal-code fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="card p-3 border-0 shadow-sm rounded-3 bg-info text-white h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-semibold">Doanh thu hệ thống</div>
                            <div class="fs-2 fw-bold mt-1">$45,230</div>
                        </div>
                        <i class="bi bi-currency-dollar fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="card p-3 border-0 shadow-sm rounded-3 bg-dark text-white h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-semibold">Tình trạng Server</div>
                            <div class="fs-2 fw-bold mt-1 text-success"><i class="bi bi-check-circle-fill me-2"></i>Tốt</div>
                        </div>
                        <i class="bi bi-server fs-1 text-white-50"></i>
                    </div>
                </div>
                <span class="badge bg-warning text-dark px-3 py-2 fw-bold">${draftCourses.size()} khóa chờ duyệt</span>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Khóa học</th>
                            <th>Chuyên gia biên soạn</th>
                            <th>Số bài học</th>
                            <th>Học phí</th>
                            <th class="text-end" style="min-width: 240px;">Quyết định duyệt (1-Click)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty draftCourses}">
                                <tr>
                                    <td colspan="6" class="text-center py-4">
                                        <div class="text-success fw-semibold">
                                            <i class="bi bi-check2-circle fs-3 d-block mb-1"></i>
                                            Tuyệt vời! Hiện không có khóa học nào ở trạng thái chờ duyệt.
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${draftCourses}">
                                    <tr class="table-warning bg-opacity-25">
                                        <td><span class="badge bg-warning text-dark">#${c.id}</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <img src="${c.thumbnailUrl}" class="rounded shadow-sm flex-shrink-0" style="width: 58px; height: 36px; object-fit: cover;" alt="${c.title}"
                                                     onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                                <div>
                                                    <span class="fw-bold text-dark d-block">${c.title}</span>
                                                    <span class="badge bg-light text-secondary border">${c.categoryName != null ? c.categoryName : 'Khóa học'}</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                                <i class="bi bi-person-badge me-1"></i>${c.expertName != null ? c.expertName : 'Expert'}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="fw-semibold text-dark">${c.totalLessons} bài</span>
                                            <small class="text-muted">(${c.modules.size()} chương)</small>
                                        </td>
                                        <td>
                                            <span class="fw-semibold text-success">
                                                <c:choose>
                                                    <c:when test="${c.price <= 0}">Miễn phí</c:when>
                                                    <c:otherwise>${c.price} VNĐ</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/admin/toggle-status?id=${c.id}&fromDashboard=true" class="btn btn-success btn-sm shadow-sm fw-semibold me-1" title="Duyệt xuất bản ngay">
                                                <i class="bi bi-check-lg me-1"></i>Đồng ý xuất bản
                                            </a>
                                            <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="btn btn-outline-secondary btn-sm" target="_blank" title="Xem trước trang khóa học">
                                                <i class="bi bi-eye"></i> Xem trước
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

        <!-- Quick Actions & Recent Activities -->
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold mb-0"><i class="bi bi-shield-lock me-2 text-primary"></i>Hoạt động gần đây (Audit Logs)</h5>
                        <button class="btn btn-outline-primary btn-sm">Xem toàn bộ Log</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Thời gian</th>
                                    <th>Người dùng</th>
                                    <th>Hành động</th>
                                    <th>Mô tả chi tiết</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><span class="text-muted small">Vừa xong</span></td>
                                    <td class="fw-semibold">admin</td>
                                    <td><span class="badge bg-primary-subtle text-primary border border-primary-subtle">LOGIN</span></td>
                                    <td class="small">Đăng nhập thành công vào hệ thống</td>
                                    <td><i class="bi bi-check-circle-fill text-success"></i></td>
                                </tr>
                                <tr>
                                    <td><span class="text-muted small">15 phút trước</span></td>
                                    <td class="fw-semibold">manager1</td>
                                    <td><span class="badge bg-warning-subtle text-warning border border-warning-subtle">UPDATE_COURSE</span></td>
                                    <td class="small">Cập nhật nội dung khóa học ID #12</td>
                                    <td><i class="bi bi-check-circle-fill text-success"></i></td>
                                </tr>
                                <tr>
                                    <td><span class="text-muted small">1 giờ trước</span></td>
                                    <td class="fw-semibold">admin</td>
                                    <td><span class="badge bg-danger-subtle text-danger border border-danger-subtle">DELETE_USER</span></td>
                                    <td class="small">Xóa tài khoản spammer_123</td>
                                    <td><i class="bi bi-check-circle-fill text-success"></i></td>
                                </tr>
                                <tr>
                                    <td><span class="text-muted small">2 giờ trước</span></td>
                                    <td class="fw-semibold">System</td>
                                    <td><span class="badge bg-info-subtle text-info border border-info-subtle">BACKUP</span></td>
                                    <td class="small">Tự động sao lưu cơ sở dữ liệu hàng ngày</td>
                                    <td><i class="bi bi-check-circle-fill text-success"></i></td>
                                </tr>
                                <tr>
                                    <td><span class="text-muted small">Hôm qua</span></td>
                                    <td class="fw-semibold">expert1</td>
                                    <td><span class="badge bg-success-subtle text-success border border-success-subtle">CREATE_LESSON</span></td>
                                    <td class="small">Thêm bài giảng mới vào Module #4</td>
                                    <td><i class="bi bi-check-circle-fill text-success"></i></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Quick shortcuts -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-lightning-charge me-1 text-warning"></i>Lối tắt quản trị</h5>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/users/list" class="btn btn-outline-primary text-start py-2 d-flex align-items-center">
                            <i class="bi bi-people fs-5 me-2"></i>
                            <div>
                                <div class="fw-semibold">Quản lý Người dùng</div>
                                <div class="small text-muted">User Management</div>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-success text-start py-2 d-flex align-items-center">
                            <i class="bi bi-journal-bookmark fs-5 me-2"></i>
                            <div>
                                <div class="fw-semibold">Quản lý Khóa học</div>
                                <div class="small text-muted">Course Management</div>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/settings/list" class="btn btn-outline-secondary text-start py-2 d-flex align-items-center">
                            <i class="bi bi-gear fs-5 me-2"></i>
                            <div>
                                <div class="fw-semibold">Quản lý Cấu hình</div>
                                <div class="small text-muted">Setting Management</div>
                            </div>
                        </a>
                        <button class="btn btn-outline-danger text-start py-2 d-flex align-items-center">
                            <i class="bi bi-shield-lock fs-5 me-2"></i>
                            <div>
                                <div class="fw-semibold">Nhật ký Hệ thống</div>
                                <div class="small text-muted">Audit Log Screens</div>
                            </div>
                        </button>
                    </div>

                    <div class="mt-4 p-3 bg-light rounded-3 border">
                        <div class="small fw-bold text-secondary mb-1"><i class="bi bi-info-circle me-1"></i>Thông tin phiên bản</div>
                        <div class="small text-muted">Courson LMS v1.0 • Jakarta EE 10</div>
                        <div class="small text-muted">PostgreSQL 18 • MVC Layered Architecture</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
