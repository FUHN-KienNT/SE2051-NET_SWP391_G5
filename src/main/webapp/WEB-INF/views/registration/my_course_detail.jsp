<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Tiến độ học tập: ${registration.courseTitle} - Courson LMS" />
<jsp:include page="../common/header.jsp" />

<style>
/* Modern SaaS Styling for Student Course Learning Dashboard */
.saas-container {
    max-width: 1180px;
    margin: 0 auto;
}
.saas-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    box-shadow: 0 4px 20px -2px rgba(15, 23, 42, 0.05);
    overflow: hidden;
}
.btn-saas-primary {
    background: #0f172a;
    color: #ffffff;
    border: 1px solid #0f172a;
    font-weight: 600;
    font-size: 0.875rem;
    padding: 9px 18px;
    border-radius: 8px;
    transition: all 0.15s ease;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    text-decoration: none;
    box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
}
.btn-saas-primary:hover {
    background: #1e293b;
    color: #ffffff;
    border-color: #1e293b;
    transform: translateY(-1px);
}
.btn-saas-outline {
    background: #ffffff;
    color: #0f172a;
    border: 1px solid #cbd5e1;
    font-weight: 600;
    font-size: 0.875rem;
    padding: 8px 16px;
    border-radius: 8px;
    transition: all 0.15s ease;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    text-decoration: none;
}
.btn-saas-outline:hover {
    background: #f8fafc;
    border-color: #94a3b8;
    color: #0f172a;
}
.progress-pill-track {
    background: #e2e8f0;
    height: 9px;
    border-radius: 9999px;
    overflow: hidden;
}
.progress-pill-fill {
    height: 100%;
    border-radius: 9999px;
    transition: width 0.4s ease;
}
.lesson-item-row {
    transition: background-color 0.15s ease;
    border-left: 3px solid transparent;
}
.lesson-item-row:hover {
    background-color: #f8fafc;
}
.lesson-item-row.completed {
    border-left-color: #10b981;
}
.lesson-item-row.in-progress {
    border-left-color: #3b82f6;
    background-color: #f0f7ff;
}
</style>

<main class="main-content py-5 bg-light-subtle">
    <div class="container saas-container">

        <!-- Navigation Breadcrumbs -->
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1 small">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-decoration-none text-muted">Trang chủ</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/registrations/my" class="text-decoration-none text-muted">Khóa học của tôi</a></li>
                        <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Chi tiết tiến độ học tập</li>
                    </ol>
                </nav>
                <h3 class="fw-bold mb-0 text-dark">
                    <i class="bi bi-mortarboard text-primary me-2"></i>Tổng quan khóa học &amp; Tiến độ (My Course Detail)
                </h3>
            </div>
            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/registrations/my" class="btn btn-saas-outline btn-sm">
                    <i class="bi bi-arrow-left"></i>Về khóa học của tôi
                </a>
                <c:choose>
                    <c:when test="${registration.status == 'PENDING'}">
                        <a href="${pageContext.request.contextPath}/registrations/payment?courseId=${registration.courseId}" class="btn btn-warning btn-sm fw-bold text-dark shadow-sm">
                            <i class="bi bi-credit-card-2-front-fill me-1"></i>Thanh toán ngay qua VNPay
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registration.id}${not empty registration.lastLessonId ? '&lessonId=' : ''}${registration.lastLessonId}" class="btn btn-saas-primary btn-sm">
                            <i class="bi bi-play-circle-fill"></i>Vào phòng học ngay
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${errorMessage}" />
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Hero Card: Course Progress & Quick Action -->
        <div class="saas-card mb-4 p-4">
            <div class="row g-4 align-items-center">
                <!-- Course Thumbnail -->
                <div class="col-md-4 col-lg-3">
                    <div class="position-relative rounded-3 overflow-hidden shadow-sm" style="height: 180px;">
                        <img src="${not empty registration.courseThumbnailUrl ? registration.courseThumbnailUrl : course.thumbnailUrl}"
                             alt="${registration.courseTitle}" class="w-100 h-100" style="object-fit: cover;"
                             onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=600'">
                        <span class="position-absolute top-0 start-0 m-2 badge bg-primary bg-opacity-90 px-2 py-1">
                            ${not empty registration.categoryName ? registration.categoryName : (not empty course.categoryName ? course.categoryName : 'Khóa học')}
                        </span>
                    </div>
                </div>

                <!-- Course Progress Summary -->
                <div class="col-md-8 col-lg-9">
                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-2">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">${registration.courseTitle}</h4>
                            <p class="text-muted small mb-0">
                                Giảng viên: <strong>${not empty registration.expertName ? registration.expertName : (not empty course.expertName ? course.expertName : "Chuyên gia Courson")}</strong> &bull;
                                Đăng ký ngày: <strong>${registration.formattedRegistrationDate}</strong>
                            </p>
                        </div>
                        <div>
                            <c:choose>
                                <c:when test="${registration.status == 'COMPLETED' or registration.progressPercentage >= 100}">
                                    <span class="badge px-3 py-1.5 rounded-pill" style="background: #ecfdf5; color: #047857; border: 1px solid #a7f3d0; font-size: 0.8125rem;">
                                        <i class="bi bi-patch-check-fill me-1"></i>Đã hoàn thành khóa học
                                    </span>
                                </c:when>
                                <c:when test="${registration.status == 'ACTIVE'}">
                                    <span class="badge px-3 py-1.5 rounded-pill" style="background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; font-size: 0.8125rem;">
                                        <i class="bi bi-clock-history me-1"></i>Đang theo học
                                    </span>
                                </c:when>
                                <c:when test="${registration.status == 'PENDING'}">
                                    <span class="badge px-3 py-1.5 rounded-pill" style="background: #fef3c7; color: #b45309; border: 1px solid #fde68a; font-size: 0.8125rem;">
                                        <i class="bi bi-hourglass-split me-1"></i>Chờ thanh toán (${registration.paymentCode})
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary-subtle text-secondary px-3 py-1.5 rounded-pill">${registration.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Progress Bar -->
                    <c:set var="displayTotalLessons" value="${registration.totalLessons > 0 ? registration.totalLessons : (course != null ? course.totalLessons : 0)}" />
                    <div class="my-3 p-3 rounded-3 bg-light border">
                        <div class="d-flex justify-content-between align-items-center mb-1 small">
                            <span class="fw-semibold text-dark"><i class="bi bi-bar-chart-steps me-1 text-primary"></i>Tiến độ khóa học</span>
                            <span class="fw-bold ${(registration.status == 'COMPLETED' or registration.progressPercentage >= 100) ? 'text-success' : 'text-primary'}">
                                ${registration.progressPercentage != null ? registration.progressPercentage : 0}% Hoàn thành
                            </span>
                        </div>
                        <div class="progress-pill-track my-2">
                            <div class="progress-pill-fill ${(registration.status == 'COMPLETED' or registration.progressPercentage >= 100) ? 'bg-success' : 'bg-primary'}"
                                 style="width: ${registration.progressPercentage != null ? registration.progressPercentage : 0}%;"></div>
                        </div>
                        <div class="d-flex justify-content-between text-muted" style="font-size: 0.78rem;">
                            <span>Đã hoàn thành: <strong>${registration.completedLessons} / ${displayTotalLessons} bài học</strong></span>
                            <span>Quyền truy cập: <strong class="text-success"><i class="bi bi-infinity me-1"></i>Trọn đời</strong></span>
                        </div>
                    </div>

                    <!-- Pending Banner if awaiting payment -->
                    <c:if test="${registration.status == 'PENDING'}">
                        <div class="alert alert-warning border-0 rounded-3 p-3 my-3 d-flex align-items-center justify-content-between flex-wrap gap-2">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-hourglass-split fs-4 text-warning"></i>
                                <div>
                                    <div class="fw-bold text-dark">Đơn hàng đang chờ thanh toán (Mã: ${registration.paymentCode})</div>
                                    <div class="small text-muted">Vui lòng hoàn tất thanh toán để kích hoạt quyền truy cập các bài giảng.</div>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/registrations/payment?courseId=${registration.courseId}"
                               class="btn btn-warning fw-bold text-dark px-3 py-2 rounded-pill shadow-sm">
                                <i class="bi bi-credit-card-2-front-fill me-1"></i>Thanh toán ngay (VNPay)
                            </a>
                        </div>
                    </c:if>

                    <!-- CTA Buttons -->
                    <div class="d-flex flex-wrap gap-2">
                        <c:choose>
                            <c:when test="${registration.status == 'PENDING'}">
                                <a href="${pageContext.request.contextPath}/registrations/payment?courseId=${registration.courseId}"
                                   class="btn btn-warning fw-bold text-dark px-4 py-2 rounded-pill shadow-sm">
                                    <i class="bi bi-credit-card-2-front-fill me-1"></i>Tiến hành thanh toán ngay (VNPay)
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registration.id}${not empty registration.lastLessonId ? '&lessonId=' : ''}${registration.lastLessonId}"
                                   class="btn btn-saas-primary">
                                    <i class="bi bi-play-circle-fill"></i>
                                    <c:choose>
                                        <c:when test="${registration.progressPercentage >= 100}">Ôn tập lại các bài học</c:when>
                                        <c:when test="${registration.completedLessons > 0}">Tiếp tục học bài gần nhất</c:when>
                                        <c:otherwise>Bắt đầu học bài đầu tiên</c:otherwise>
                                    </c:choose>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Left Column: Syllabus & Learning Checklist (70%) -->
            <div class="col-lg-8">
                <div class="saas-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                        <div>
                            <h5 class="fw-bold text-dark mb-0">
                                <i class="bi bi-list-check text-primary me-2"></i>Đề cương &amp; Tiến độ bài học
                            </h5>
                            <p class="text-muted small mb-0">Theo dõi trạng thái hoàn thành của từng bài giảng và bài tập</p>
                        </div>
                        <span class="badge bg-light text-dark border px-2.5 py-1">
                            ${displayTotalLessons} bài học &bull; ${fn:length(course.modules)} chương
                        </span>
                    </div>

                    <c:choose>
                        <c:when test="${empty course or empty course.modules}">
                            <div class="p-5 text-center text-muted">
                                <i class="bi bi-journal-x fs-1 d-block mb-2 opacity-50"></i>
                                <span class="fw-semibold">Nội dung khóa học đang được cập nhật thêm.</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="m" items="${course.modules}" varStatus="mStatus">
                                    <div class="border rounded-3 overflow-hidden">
                                        <!-- Module Header -->
                                        <div class="px-3 py-2.5 bg-light border-bottom d-flex justify-content-between align-items-center">
                                            <span class="fw-bold text-dark small">
                                                <i class="bi bi-folder2-open text-primary me-2"></i>Chương ${mStatus.count}: ${m.title}
                                            </span>
                                            <span class="badge bg-white text-muted border small">
                                                ${fn:length(m.lessons)} bài học
                                                <c:if test="${not empty m.quizzes}">
                                                    &bull; ${fn:length(m.quizzes)} quiz
                                                </c:if>
                                            </span>
                                        </div>

                                        <!-- Lessons in Module -->
                                        <div class="list-group list-group-flush">
                                            <c:forEach var="l" items="${m.lessons}">
                                                <div class="list-group-item d-flex align-items-center justify-content-between py-2.5 px-3 lesson-item-row ${l.progressStatus == 'COMPLETED' ? 'completed' : (l.progressStatus == 'IN_PROGRESS' ? 'in-progress' : '')}">
                                                    <div class="d-flex align-items-center gap-3 overflow-hidden me-2">
                                                        <c:choose>
                                                            <c:when test="${l.progressStatus == 'COMPLETED'}">
                                                                <i class="bi bi-check-circle-fill text-success fs-5 flex-shrink-0" title="Đã hoàn thành"></i>
                                                            </c:when>
                                                            <c:when test="${l.progressStatus == 'IN_PROGRESS'}">
                                                                <i class="bi bi-play-circle-fill text-primary fs-5 flex-shrink-0" title="Đang học dở"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="bi bi-circle text-muted fs-5 flex-shrink-0" title="Chưa học"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <div class="overflow-hidden">
                                                            <div class="fw-semibold text-dark text-truncate small">
                                                                Bài ${l.orderIndex}: ${l.title}
                                                            </div>
                                                            <span class="text-muted" style="font-size: 0.72rem;">
                                                                <i class="bi bi-play-btn me-1 text-primary"></i>Video bài giảng
                                                            </span>
                                                        </div>
                                                    </div>

                                                    <!-- Direct Action Button -->
                                                    <div class="flex-shrink-0 ms-2">
                                                        <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registration.id}&lessonId=${l.id}"
                                                           class="btn btn-sm ${l.progressStatus == 'COMPLETED' ? 'btn-outline-secondary' : (l.progressStatus == 'IN_PROGRESS' ? 'btn-primary' : 'btn-outline-primary')} py-1 px-3 rounded-pill"
                                                           style="font-size: 0.75rem;">
                                                            <c:choose>
                                                                <c:when test="${l.progressStatus == 'COMPLETED'}">Xem lại</c:when>
                                                                <c:when test="${l.progressStatus == 'IN_PROGRESS'}">Học tiếp &rarr;</c:when>
                                                                <c:otherwise>Vào học</c:otherwise>
                                                            </c:choose>
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:forEach>

                                            <!-- Quizzes in Module -->
                                            <c:forEach var="q" items="${m.quizzes}">
                                                <div class="list-group-item d-flex align-items-center justify-content-between py-2.5 px-3 bg-warning bg-opacity-10 border-top">
                                                    <div class="d-flex align-items-center gap-2.5 overflow-hidden me-2">
                                                        <i class="bi bi-patch-question-fill text-warning fs-5 flex-shrink-0"></i>
                                                        <div class="overflow-hidden">
                                                            <span class="fw-semibold text-dark small d-block text-truncate">${q.title}</span>
                                                            <small class="text-muted" style="font-size: 0.72rem;">
                                                                Điểm đạt: <strong>${q.passScore} điểm</strong> &bull;
                                                                Thời gian: <strong><c:choose><c:when test="${q.timeLimitMinutes != null && q.timeLimitMinutes > 0}">${q.timeLimitMinutes} phút</c:when><c:otherwise>Không giới hạn</c:otherwise></c:choose></strong>
                                                            </small>
                                                        </div>
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/quizzes/overview?quizId=${q.id}&registrationId=${registration.id}"
                                                       class="btn btn-sm btn-warning py-1 px-3 fw-semibold rounded-pill text-dark shadow-xs flex-shrink-0"
                                                       style="font-size: 0.75rem;">
                                                        <i class="bi bi-pencil-square me-1"></i>Làm bài tập
                                                    </a>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Right Column: Registration & Study Support Information (30%) -->
            <div class="col-lg-4">
                <!-- Registration Specs Card -->
                <div class="saas-card p-4 mb-4">
                    <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
                        <h6 class="fw-bold text-dark mb-0">
                            <i class="bi bi-receipt text-primary me-2"></i>Thông tin đăng ký &amp; Giao dịch
                        </h6>
                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 small">
                            ${registration.status}
                        </span>
                    </div>

                    <div class="d-flex flex-column gap-3 small">
                        <div>
                            <span class="text-muted d-block" style="font-size: 0.75rem;">MÃ ĐĂNG KÝ HỌC VIÊN</span>
                            <span class="fw-bold font-monospace fs-6 text-dark">#${registration.id}</span>
                        </div>
                        <div>
                            <span class="text-muted d-block" style="font-size: 0.75rem;">HỌC VIÊN SỞ HỮU</span>
                            <span class="fw-semibold text-dark">${not empty registration.userName ? registration.userName : sessionScope.CURRENT_USER.fullName}</span>
                        </div>
                        <div>
                            <span class="text-muted d-block" style="font-size: 0.75rem;">HỌC PHÍ ĐÃ THANH TOÁN</span>
                            <span class="fw-bold text-success fs-5">
                                <c:choose>
                                    <c:when test="${registration.paymentAmount <= 0}">0 VNĐ (Miễn phí)</c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${registration.paymentAmount}" pattern="#,###" /> VNĐ
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div>
                            <span class="text-muted d-block" style="font-size: 0.75rem;">CỔNG THANH TOÁN</span>
                            <span class="fw-semibold text-dark">
                                <i class="bi bi-credit-card-2-front text-primary me-1"></i>
                                ${not empty registration.paymentMethod ? registration.paymentMethod : "VNPay Sandbox"}
                            </span>
                        </div>
                        <div>
                            <span class="text-muted d-block" style="font-size: 0.75rem;">MÃ TRA CỨU ĐƠN HÀNG</span>
                            <span class="font-monospace text-dark bg-light px-2 py-1 rounded border d-inline-block small">
                                ${not empty registration.paymentCode ? registration.paymentCode : "CHƯA GHI NHẬN"}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Learning Benefits Card -->
                <div class="saas-card p-4">
                    <h6 class="fw-bold text-dark mb-3 pb-2 border-bottom">
                        <i class="bi bi-shield-check text-success me-2"></i>Quyền lợi học viên Courson
                    </h6>
                    <ul class="list-unstyled small mb-0 d-flex flex-column gap-2.5">
                        <li class="d-flex align-items-start gap-2">
                            <i class="bi bi-check-circle-fill text-success mt-0.5"></i>
                            <span>Quyền học tập <strong>trọn đời</strong> trên mọi thiết bị.</span>
                        </li>
                        <li class="d-flex align-items-start gap-2">
                            <i class="bi bi-check-circle-fill text-success mt-0.5"></i>
                            <span>Trọn bộ slide bài giảng, mã nguồn mẫu và video chất lượng cao.</span>
                        </li>
                        <li class="d-flex align-items-start gap-2">
                            <i class="bi bi-check-circle-fill text-success mt-0.5"></i>
                            <span>Cấp <strong>Chứng chỉ hoàn thành</strong> khi đạt 100% tiến độ bài học và vượt qua các đề thi Quiz.</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
