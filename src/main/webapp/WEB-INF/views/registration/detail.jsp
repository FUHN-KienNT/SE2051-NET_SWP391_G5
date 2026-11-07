<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

                <c:set var="pageTitle" value="Tiến độ học tập: ${registration.courseTitle} - Courson LMS" />

                <jsp:include page="../common/header.jsp" />



                <style>
                    /* Modern SaaS Styling for Student Course Learning Dashboard */

                    .saas-container {

                        max-width: 1140px;

                        margin: 0 auto;

                    }

                    .saas-card {

                        background: #ffffff;

                        border: 1px solid #e2e8f0;

                        border-radius: 16px;

                        box-shadow: 0 4px 20px -2px rgba(15, 23, 42, 0.06);

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

                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home"
                                                class="text-decoration-none text-muted">Trang chủ</a></li>

                                        <li class="breadcrumb-item"><a
                                                href="${pageContext.request.contextPath}/registrations/my"
                                                class="text-decoration-none text-muted">Khóa học của tôi</a></li>

                                        <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Chi
                                            tiết tiến độ học tập</li>

                                    </ol>

                                </nav>

                                <h3 class="fw-bold mb-0 text-dark">

                                    <i class="bi bi-mortarboard text-primary me-2"></i>Chi tiết khóa học & Tiến độ (My
                                    Course Detail)

                                </h3>

                            </div>

                            <div class="d-flex align-items-center gap-2">

                                <a href="${pageContext.request.contextPath}/registrations/my"
                                    class="btn btn-saas-outline btn-sm">

                                    <i class="bi bi-arrow-left"></i>Về khóa học của tôi

                                </a>

                                <c:choose>

                                    <c:when test="${registration.status == 'PENDING'}">

                                        <a href="${pageContext.request.contextPath}/registrations/payment?courseId=${registration.courseId}"
                                            class="btn btn-warning btn-sm fw-bold text-dark shadow-sm">

                                            <i class="bi bi-credit-card-2-front-fill me-1"></i>Thanh toán ngay qua VNPay

                                        </a>

                                    </c:when>

                                    <c:otherwise>

                                        <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registration.id}"
                                            class="btn btn-saas-primary btn-sm">

                                            <i class="bi bi-play-circle-fill"></i>Vào học ngay (Lesson Viewer)

                                        </a>

                                    </c:otherwise>

                                </c:choose>

                            </div>

                        </div>



                        <!-- Hero Card: Course Progress & Quick Action -->

                        <div class="saas-card mb-4 p-4">

                            <div class="row g-4 align-items-center">

                                <!-- Course Thumbnail -->

                                <div class="col-md-4 col-lg-3">

                                    <div class="position-relative rounded-3 overflow-hidden shadow-sm"
                                        style="height: 180px;">

                                        <img src="${course.thumbnailUrl != null ? course.thumbnailUrl : registration.courseThumbnailUrl}"
                                            alt="${registration.courseTitle}" class="w-100 h-100"
                                            style="object-fit: cover;"
                                            onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=600'">

                                        <span
                                            class="position-absolute top-0 start-0 m-2 badge bg-primary bg-opacity-90 px-2 py-1">

                                            ${course.categoryName != null ? course.categoryName :
                                            (registration.categoryName != null ? registration.categoryName : 'Khóa
                                            học')}

                                        </span>

                                    </div>

                                </div>



                                <!-- Course Progress Summary -->

                                <div class="col-md-8 col-lg-9">

                                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-2">

                                        <div>

                                            <h4 class="fw-bold text-dark mb-1">${registration.courseTitle}</h4>

                                            <p class="text-muted small mb-0">

                                                Giảng viên: <strong>${course.expertName != null ? course.expertName :
                                                    "Đội ngũ chuyên gia Courson"}</strong> &bull;

                                                Đăng ký ngày: <strong>${registration.formattedRegistrationDate}</strong>

                                            </p>

                                        </div>

                                        <div>

                                            <c:choose>

                                                <c:when
                                                    test="${registration.status == 'COMPLETED' or registration.progressPercentage >= 100}">

                                                    <span class="badge px-3 py-1.5 rounded-pill"
                                                        style="background: #ecfdf5; color: #047857; border: 1px solid #a7f3d0; font-size: 0.8125rem;">

                                                        <i class="bi bi-patch-check-fill me-1"></i>Đã hoàn thành khóa
                                                        học

                                                    </span>

                                                </c:when>

                                                <c:when test="${registration.status == 'ACTIVE'}">

                                                    <span class="badge px-3 py-1.5 rounded-pill"
                                                        style="background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; font-size: 0.8125rem;">

                                                        <i class="bi bi-clock-history me-1"></i>Đang theo học

                                                    </span>

                                                </c:when>

                                                <c:when test="${registration.status == 'PENDING'}">

                                                    <span class="badge px-3 py-1.5 rounded-pill"
                                                        style="background: #fef3c7; color: #b45309; border: 1px solid #fde68a; font-size: 0.8125rem;">

                                                        <i class="bi bi-hourglass-split me-1"></i>Chờ thanh toán
                                                        (${registration.paymentCode})

                                                    </span>

                                                </c:when>

                                                <c:otherwise>

                                                    <span
                                                        class="badge bg-secondary-subtle text-secondary px-3 py-1.5 rounded-pill">

                                                        ${registration.status}

                                                    </span>

                                                </c:otherwise>

                                            </c:choose>

                                        </div>

                                    </div>



                                    <!-- Progress Bar -->

                                    <div class="my-3 p-3 rounded-3 bg-light border">

                                        <div class="d-flex justify-content-between align-items-center mb-1 small">

                                            <span class="fw-semibold text-dark">Tiến trình hoàn thành bài học:</span>

                                            <span
                                                class="fw-bold text-primary">${registration.progressPercentage}%</span>

                                        </div>

                                        <div class="progress-pill-track mb-2">

                                            <div class="progress-pill-fill ${(registration.status == 'COMPLETED' or registration.progressPercentage >= 100) ? 'bg-success' : 'bg-primary'}"
                                                style="width: ${registration.progressPercentage}%;"></div>

                                        </div>

                                        <div class="d-flex justify-content-between text-muted"
                                            style="font-size: 0.78rem;">

                                            <span>Đã hoàn thành: <strong>${registration.completedLessons} /
                                                    ${registration.totalLessons} bài học</strong></span>

                                            <span>Quyền truy cập: <strong class="text-success">Trọn đời</strong></span>

                                        </div>

                                    </div>



                                    <!-- Pending Banner if awaiting payment -->

                                    <c:if test="${registration.status == 'PENDING'}">

                                        <div
                                            class="alert alert-warning border-0 rounded-3 p-3 my-3 d-flex align-items-center justify-content-between flex-wrap gap-2">

                                            <div class="d-flex align-items-center gap-2">

                                                <i class="bi bi-hourglass-split fs-4 text-warning"></i>

                                                <div>

                                                    <div class="fw-bold text-dark">Đơn hàng đang chờ thanh toán (Mã:
                                                        ${registration.paymentCode})</div>

                                                    <div class="small text-muted">Vui lòng hoàn tất thanh toán để kích
                                                        hoạt quyền truy cập các bài giảng.</div>

                                                </div>

                                            </div>

                                            <a href="${pageContext.request.contextPath}/registrations/payment?courseId=${registration.courseId}"
                                                class="btn btn-warning fw-bold text-dark px-3 py-2 rounded-pill shadow-sm">

                                                <i class="bi bi-credit-card-2-front-fill me-1"></i>Thanh toán ngay
                                                (VNPay)

                                            </a>

                                        </div>

                                    </c:if>



                                    <!-- CTA Buttons -->

                                    <div class="d-flex flex-wrap gap-2">

                                        <c:choose>

                                            <c:when test="${registration.status == 'PENDING'}">

                                                <a href="${pageContext.request.contextPath}/registrations/payment?courseId=${registration.courseId}"
                                                    class="btn btn-warning fw-bold text-dark px-4 py-2 rounded-pill shadow-sm">

                                                    <i class="bi bi-credit-card-2-front-fill me-1"></i>Tiến hành thanh
                                                    toán ngay (VNPay)

                                                </a>

                                            </c:when>

                                            <c:otherwise>

                                                <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registration.id}"
                                                    class="btn btn-saas-primary">

                                                    <i class="bi bi-play-circle-fill"></i>

                                                    <c:choose>

                                                        <c:when test="${registration.progressPercentage >= 100}">Ôn tập
                                                            lại các bài học</c:when>

                                                        <c:when test="${registration.completedLessons > 0}">Tiếp tục học
                                                            bài dở dang</c:when>

                                                        <c:otherwise>Bắt đầu học bài đầu tiên</c:otherwise>

                                                    </c:choose>

                                                </a>

                                            </c:otherwise>

                                        </c:choose>

                                        <a href="${pageContext.request.contextPath}/courses/detail?id=${registration.courseId}"
                                            class="btn btn-saas-outline">

                                            <i class="bi bi-info-circle"></i>Xem trang thông tin chung khóa học

                                        </a>

                                    </div>

                                </div>

                            </div>

                        </div>



                        <div class="row g-4">

                            <!-- Left Column: Syllabus & Learning Checklist -->

                            <div class="col-lg-8">

                                <div class="saas-card p-4">

                                    <div
                                        class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">

                                        <div>

                                            <h5 class="fw-bold text-dark mb-0">

                                                <i class="bi bi-list-check text-primary me-2"></i>Đề cương & Tiến độ bài
                                                học

                                            </h5>

                                            <p class="text-muted small mb-0">Theo dõi trạng thái hoàn thành của từng bài
                                                giảng và bài tập</p>

                                        </div>

                                        <span class="badge bg-light text-dark border px-2.5 py-1">

                                            ${registration.totalLessons} bài học

                                        </span>

                                    </div>



                                    <c:choose>

                                        <c:when test="${empty course or empty course.modules}">

                                            <div class="p-4 text-center text-muted">

                                                <i class="bi bi-journal-x fs-2 d-block mb-2"></i>

                                                Nội dung khóa học đang được cập nhật thêm.

                                            </div>

                                        </c:when>

                                        <c:otherwise>

                                            <c:set var="lessonIndex" value="1" />

                                            <div class="d-flex flex-column gap-3">

                                                <c:forEach var="m" items="${course.modules}">

                                                    <div class="border rounded-3 overflow-hidden">

                                                        <!-- Module Header -->

                                                        <div
                                                            class="px-3 py-2.5 bg-light border-bottom d-flex justify-content-between align-items-center">

                                                            <span class="fw-bold text-dark small">

                                                                <i
                                                                    class="bi bi-folder2-open text-primary me-2"></i>${m.title}

                                                            </span>

                                                            <span class="badge bg-white text-muted border small">

                                                                ${fn:length(m.lessons)} bài học

                                                            </span>

                                                        </div>



                                                        <!-- Lessons in Module -->

                                                        <div class="list-group list-group-flush">

                                                            <c:forEach var="l" items="${m.lessons}">

                                                                <div
                                                                    class="list-group-item d-flex align-items-center justify-content-between py-2.5 px-3 lesson-item-row ${l.progressStatus == 'COMPLETED' ? 'completed' : (l.progressStatus == 'IN_PROGRESS' ? 'in-progress' : '')}">

                                                                    <div
                                                                        class="d-flex align-items-center gap-3 text-truncate">

                                                                        <!-- Progress Status Icon -->

                                                                        <div class="flex-shrink-0"
                                                                            style="width: 24px; text-align: center;">

                                                                            <c:choose>

                                                                                <c:when
                                                                                    test="${l.progressStatus == 'COMPLETED'}">

                                                                                    <i class="bi bi-check-circle-fill text-success fs-5"
                                                                                        title="Đã hoàn thành bài học"></i>

                                                                                </c:when>

                                                                                <c:when
                                                                                    test="${l.progressStatus == 'IN_PROGRESS'}">

                                                                                    <i class="bi bi-play-circle-fill text-primary fs-5"
                                                                                        title="Đang học bài này"></i>

                                                                                </c:when>

                                                                                <c:otherwise>

                                                                                    <i class="bi bi-circle text-muted opacity-50 fs-5"
                                                                                        title="Chưa học"></i>

                                                                                </c:otherwise>

                                                                            </c:choose>

                                                                        </div>



                                                                        <div class="position-relative flex-shrink-0"
                                                                            style="width: 68px; height: 40px;">

                                                                            <img src="${l.thumbnailUrl}"
                                                                                class="w-100 h-100 rounded"
                                                                                style="object-fit: cover;"
                                                                                onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">

                                                                        </div>



                                                                        <div class="text-truncate">

                                                                            <span
                                                                                class="fw-semibold text-dark d-block text-truncate small">

                                                                                Bài ${lessonIndex}: ${l.title}

                                                                            </span>

                                                                            <span class="text-muted"
                                                                                style="font-size: 0.72rem;">

                                                                                <i
                                                                                    class="bi bi-camera-video me-1 text-danger"></i>Video
                                                                                bài giảng



                                                                            </span>

                                                                        </div>

                                                                    </div>



                                                                    <!-- Direct Action Button -->

                                                                    <div class="flex-shrink-0 ms-2">

                                                                        <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registration.id}&lessonId=${l.id}"
                                                                            class="btn btn-sm ${l.progressStatus == 'COMPLETED' ? 'btn-light border' : 'btn-saas-primary'} py-1 px-2.5"
                                                                            style="font-size: 0.75rem;">

                                                                            <c:choose>

                                                                                <c:when
                                                                                    test="${l.progressStatus == 'COMPLETED'}">
                                                                                    Xem lại</c:when>

                                                                                <c:when
                                                                                    test="${l.progressStatus == 'IN_PROGRESS'}">
                                                                                    Học tiếp &rarr;</c:when>

                                                                                <c:otherwise>Vào học</c:otherwise>

                                                                            </c:choose>

                                                                        </a>

                                                                    </div>

                                                                </div>

                                                                <c:set var="lessonIndex" value="${lessonIndex + 1}" />

                                                            </c:forEach>



                                                            <!-- Quizzes in Module -->

                                                            <c:forEach var="q" items="${m.quizzes}">

                                                                <div
                                                                    class="list-group-item d-flex align-items-center justify-content-between py-2 px-3 bg-warning bg-opacity-10 border-top">

                                                                    <div class="d-flex align-items-center gap-2">

                                                                        <i
                                                                            class="bi bi-patch-question-fill text-warning fs-5"></i>

                                                                        <div>

                                                                            <span
                                                                                class="fw-semibold text-dark small d-block">${q.title}</span>

                                                                            <small class="text-muted"
                                                                                style="font-size: 0.72rem;">Điểm đạt:
                                                                                ${q.passScore}% &bull; Thời gian:
                                                                                ${q.timeLimitMinutes} phút</small>

                                                                        </div>

                                                                    </div>

                                                                    <a href="${pageContext.request.contextPath}/quizzes/attempt?registrationId=${registration.id}&quizId=${q.id}"
                                                                        class="btn btn-sm btn-warning py-1 px-2.5 fw-semibold"
                                                                        style="font-size: 0.75rem;">

                                                                        Làm bài tập

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



                            <!-- Right Column: Registration & Payment Information (VNPay Gateway verification) -->

                            <div class="col-lg-4">

                                <div class="saas-card p-4 sticky-top" style="top: 80px;">

                                    <div
                                        class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">

                                        <h6 class="fw-bold text-dark mb-0">

                                            <i class="bi bi-receipt text-primary me-2"></i>Thông tin đăng ký & Giao dịch

                                        </h6>

                                        <span
                                            class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 small">

                                            ${registration.status}

                                        </span>

                                    </div>



                                    <div class="d-flex flex-column gap-3 small">

                                        <div>

                                            <span class="text-muted d-block" style="font-size: 0.75rem;">MÃ ĐĂNG KÝ HỌC
                                                VIÊN</span>

                                            <span class="fw-bold font-monospace fs-6">#${registration.id}</span>

                                        </div>

                                        <div>

                                            <span class="text-muted d-block" style="font-size: 0.75rem;">HỌC VIÊN SỞ
                                                HỮU</span>

                                            <span class="fw-semibold text-dark">${registration.userName != null ?
                                                registration.userName : sessionScope.CURRENT_USER.fullName}</span>

                                        </div>

                                        <div>

                                            <span class="text-muted d-block" style="font-size: 0.75rem;">HỌC PHÍ ĐÃ
                                                THANH TOÁN</span>

                                            <span class="fw-bold text-success fs-5">

                                                <c:choose>

                                                    <c:when test="${registration.paymentAmount <= 0}">0 VNĐ (Miễn phí)
                                                    </c:when>

                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${registration.paymentAmount}"
                                                            pattern="#,###" /> VNĐ
                                                    </c:otherwise>

                                                </c:choose>

                                            </span>

                                        </div>

                                        <div>

                                            <span class="text-muted d-block" style="font-size: 0.75rem;">CỔNG THANH
                                                TOÁN</span>

                                            <span class="fw-semibold text-dark">

                                                <i class="bi bi-credit-card-2-front text-primary me-1"></i>

                                                ${registration.paymentMethod != null ? registration.paymentMethod :
                                                "VNPay Sandbox"}

                                            </span>

                                        </div>

                                        <div>

                                            <span class="text-muted d-block" style="font-size: 0.75rem;">MÃ GIAO DỊCH
                                                (TRANSACTION CODE)</span>

                                            <span
                                                class="font-monospace text-dark bg-light px-2 py-1 rounded border d-inline-block small">

                                                ${registration.paymentCode != null ? registration.paymentCode : "CHƯA
                                                GHI NHẬN"}

                                            </span>

                                        </div>

                                        <div>

                                            <span class="text-muted d-block" style="font-size: 0.75rem;">THỜI ĐIỂM THANH
                                                TOÁN</span>

                                            <span class="text-dark">

                                                <c:choose>

                                                    <c:when test="${not empty registration.paidAt}">
                                                        ${registration.paidAt}</c:when>

                                                    <c:otherwise>${registration.formattedRegistrationDate}</c:otherwise>

                                                </c:choose>

                                            </span>

                                        </div>

                                    </div>



                                    <div class="border-top pt-3 mt-3">

                                        <span class="text-muted d-block small mb-2">Quyền lợi học viên Courson:</span>

                                        <div class="d-flex align-items-center gap-2 small text-muted mb-1.5">

                                            <i class="bi bi-check-circle-fill text-success"></i>Bảo lưu quyền học trọn
                                            đời

                                        </div>

                                        <div class="d-flex align-items-center gap-2 small text-muted mb-1.5">

                                            <i class="bi bi-check-circle-fill text-success"></i>Tự động lưu tiến độ
                                            video học dở

                                        </div>

                                        <div class="d-flex align-items-center gap-2 small text-muted">

                                            <i class="bi bi-check-circle-fill text-success"></i>Hỗ trợ giải đáp từ
                                            chuyên gia

                                        </div>

                                    </div>

                                </div>

                            </div>

                        </div>



                    </div>

                </main>
                <jsp:include page="../common/footer.jsp" />