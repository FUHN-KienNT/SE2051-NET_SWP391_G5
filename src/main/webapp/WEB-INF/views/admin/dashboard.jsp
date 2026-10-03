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
                <h3 class="fw-bold mb-1"><i class="bi bi-speedometer2 text-primary me-2"></i>Bảng điều khiển Quản trị (Admin Dashboard)</h3>
                <p class="text-muted small mb-0">Theo dõi toàn diện hệ thống và trực tiếp <strong>Kiểm duyệt &amp; Phê duyệt</strong> các khóa học từ Expert</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-primary btn-sm">
                    <i class="bi bi-journal-bookmark me-1"></i>Tất cả Khóa học
                </a>
            </div>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Đã cập nhật trạng thái phê duyệt khóa học thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Metrics Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-warning text-dark">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-dark text-opacity-75 text-uppercase fw-bold">Chờ duyệt (Drafts)</div>
                            <div class="fs-2 fw-bold mt-1">${draftCount != null ? draftCount : 0}</div>
                        </div>
                        <i class="bi bi-hourglass-split fs-1 text-dark text-opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-success text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-bold">Đã công khai (Published)</div>
                            <div class="fs-2 fw-bold mt-1">${publishedCount != null ? publishedCount : 0}</div>
                        </div>
                        <i class="bi bi-check-circle-fill fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
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
            <div class="col-md-3">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-info text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small text-white-50 text-uppercase fw-bold">Chuyên gia (Expert)</div>
                            <div class="fs-2 fw-bold mt-1">${totalExperts != null ? totalExperts : 0}</div>
                        </div>
                        <i class="bi bi-person-badge fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- SECTION: Direct Pending Draft Courses for Fast Admin Review & Approval -->
        <div class="card border-0 shadow-sm rounded-3 mb-4 overflow-hidden border-start border-warning border-4">
            <div class="card-header bg-warning bg-opacity-10 py-3 d-flex justify-content-between align-items-center">
                <div>
                    <h5 class="fw-bold mb-0 text-dark">
                        <i class="bi bi-hourglass-split text-warning me-2"></i>Khóa học do Expert gửi - Đang chờ phê duyệt
                    </h5>
                    <small class="text-muted">Xem nhanh và quyết định Đồng ý xuất bản (Publish) trực tiếp ngay tại đây</small>
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

        <!-- Recent / All Published Courses & Quick shortcuts -->
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold mb-0"><i class="bi bi-collection-play me-2"></i>Tất cả Khóa học trên hệ thống</h5>
                        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-primary btn-sm">Xem chi tiết</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên khóa học</th>
                                    <th>Chuyên gia phụ trách</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Thao tác</th>
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
                                                    <c:choose>
                                                        <c:when test="${c.status == 'PUBLISHED'}">
                                                            <span class="badge bg-success-subtle text-success border border-success-subtle">
                                                                <i class="bi bi-check-circle-fill me-1"></i>PUBLISHED
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">
                                                                <i class="bi bi-hourglass-split me-1"></i>DRAFT
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <c:choose>
                                                        <c:when test="${c.status == 'DRAFT'}">
                                                            <a href="${pageContext.request.contextPath}/admin/toggle-status?id=${c.id}&fromDashboard=true" class="btn btn-sm btn-success fw-semibold me-1">
                                                                <i class="bi bi-check-lg"></i> Duyệt
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/admin/toggle-status?id=${c.id}&fromDashboard=true" class="btn btn-sm btn-outline-danger me-1" title="Hạ về Draft">
                                                                <i class="bi bi-x-circle"></i> Hạ nháp
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="btn btn-sm btn-light border" target="_blank">
                                                        <i class="bi bi-eye"></i>
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
                    <h5 class="fw-bold mb-3"><i class="bi bi-lightning-charge me-1"></i>Lối tắt Quản trị</h5>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-primary text-start py-2">
                            <i class="bi bi-shield-check me-2"></i>Trung tâm Duyệt khóa học
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
