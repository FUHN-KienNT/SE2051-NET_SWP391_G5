<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Khóa học của tôi - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<style>
    /* Hero Resume Card Styles */
    .hero-resume-card {
        background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 18px;
        overflow: hidden;
        position: relative;
        box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.25), 0 8px 10px -6px rgba(15, 23, 42, 0.2);
    }
    .hero-resume-card::before {
        content: '';
        position: absolute;
        top: -50px;
        right: -50px;
        width: 260px;
        height: 260px;
        background: radial-gradient(circle, rgba(243, 128, 32, 0.22) 0%, rgba(243, 128, 32, 0) 70%);
        pointer-events: none;
    }
    .hero-thumb-wrapper {
        position: relative;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
        max-height: 210px;
    }
    .hero-thumb-wrapper img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.4s ease;
    }
    .hero-thumb-wrapper:hover img {
        transform: scale(1.04);
    }
    .hero-play-btn {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 54px;
        height: 54px;
        background: rgba(243, 128, 32, 0.95);
        color: #ffffff;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        box-shadow: 0 0 20px rgba(243, 128, 32, 0.6);
        transition: all 0.25s ease;
    }
    .hero-thumb-wrapper:hover .hero-play-btn {
        transform: translate(-50%, -50%) scale(1.12);
        background: #f38020;
    }

    /* KPI Metric Cards */
    .stat-card {
        background: #ffffff;
        border-radius: 16px;
        border: 1px solid #e2e8f0;
        padding: 1.25rem 1.25rem;
        transition: all 0.25s ease;
        position: relative;
        overflow: hidden;
    }
    .stat-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 20px -5px rgba(0, 0, 0, 0.07);
        border-color: #cbd5e1;
    }
    .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.4rem;
    }

    /* Course Grid Cards */
    .course-grid-card {
        background: #ffffff;
        border-radius: 16px;
        border: 1px solid #e2e8f0;
        overflow: hidden;
        transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        display: flex;
        flex-direction: column;
        height: 100%;
    }
    .course-grid-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 16px 28px -8px rgba(0, 0, 0, 0.08);
        border-color: #cbd5e1;
    }
    .card-thumb-container {
        position: relative;
        height: 180px;
        overflow: hidden;
        background: #0f172a;
    }
    .card-thumb-container img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.4s ease;
    }
    .course-grid-card:hover .card-thumb-container img {
        transform: scale(1.05);
    }
    .card-cat-badge {
        position: absolute;
        top: 12px;
        left: 12px;
        background: rgba(15, 23, 42, 0.82);
        backdrop-filter: blur(6px);
        color: #ffffff;
        font-size: 0.75rem;
        font-weight: 600;
        padding: 5px 10px;
        border-radius: 30px;
        letter-spacing: 0.3px;
        z-index: 2;
    }
    .card-status-badge {
        position: absolute;
        top: 12px;
        right: 12px;
        font-size: 0.75rem;
        font-weight: 600;
        padding: 5px 10px;
        border-radius: 30px;
        z-index: 2;
    }
    .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    /* Filter Toolbar Tabs */
    .filter-tab-btn {
        border-radius: 30px;
        font-size: 0.875rem;
        font-weight: 600;
        padding: 7px 18px;
        border: 1px solid #e2e8f0;
        background: #ffffff;
        color: #64748b;
        transition: all 0.2s ease;
        text-decoration: none;
    }
    .filter-tab-btn:hover {
        background: #f1f5f9;
        color: #1e293b;
    }
    .filter-tab-btn.active {
        background: #1e293b;
        color: #ffffff;
        border-color: #1e293b;
        box-shadow: 0 4px 10px rgba(30, 41, 59, 0.2);
    }
    .filter-tab-btn .badge {
        font-size: 0.72rem;
        padding: 3px 7px;
        border-radius: 20px;
    }
</style>

<main class="main-content py-4 py-lg-5">
    <div class="container">
        
        <!-- Header Page Title -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4 gap-3">
            <div>
                <h2 class="fw-bold mb-1 text-dark">
                    <i class="bi bi-mortarboard-fill text-primary me-2"></i>Khóa học của tôi
                </h2>
                <p class="text-muted mb-0 small">Theo dõi tiến độ học tập, tiếp tục bài học gần nhất và hoàn thành chứng chỉ của bạn</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/courses/catalog" class="btn btn-outline-primary btn-sm px-3 fw-semibold rounded-pill">
                    <i class="bi bi-compass me-1"></i>Khám phá khóa học mới
                </a>
            </div>
        </div>

        <!-- Flash Alert Messages -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-4 mb-4 border-0 shadow-sm d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                <div class="flex-grow-1">${errorMessage}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 mb-4 border-0 shadow-sm d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                <div class="flex-grow-1">${successMessage}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- 1. TỔNG QUAN SỐ KHÓA HỌC (Feature 1 - KPI Metric Cards) -->
        <div class="row g-3 g-lg-4 mb-4">
            <!-- Tổng số khóa học -->
            <div class="col-6 col-lg-3">
                <div class="stat-card d-flex align-items-center gap-3">
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                        <i class="bi bi-journal-bookmark-fill"></i>
                    </div>
                    <div>
                        <div class="fs-4 fw-bold text-dark lh-1 mb-1">${totalCourses}</div>
                        <div class="text-muted small fw-medium">Tổng khóa học</div>
                        <div class="text-muted" style="font-size: 0.75rem;">Đã đăng ký</div>
                    </div>
                </div>
            </div>

            <!-- Khóa học đang học -->
            <div class="col-6 col-lg-3">
                <div class="stat-card d-flex align-items-center gap-3">
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                        <i class="bi bi-lightning-charge-fill"></i>
                    </div>
                    <div>
                        <div class="fs-4 fw-bold text-dark lh-1 mb-1">${inProgressCourses}</div>
                        <div class="text-muted small fw-medium">Đang học</div>
                        <div class="text-muted" style="font-size: 0.75rem;">Đang duy trì tiến độ</div>
                    </div>
                </div>
            </div>

            <!-- Khóa học đã hoàn thành -->
            <div class="col-6 col-lg-3">
                <div class="stat-card d-flex align-items-center gap-3">
                    <div class="stat-icon bg-success bg-opacity-10 text-success">
                        <i class="bi bi-patch-check-fill"></i>
                    </div>
                    <div>
                        <div class="fs-4 fw-bold text-dark lh-1 mb-1">${completedCourses}</div>
                        <div class="text-muted small fw-medium">Đã hoàn thành</div>
                        <div class="text-muted" style="font-size: 0.75rem;">Mục tiêu hoàn tất</div>
                    </div>
                </div>
            </div>

            <!-- Tiến độ trung bình -->
            <div class="col-6 col-lg-3">
                <div class="stat-card d-flex align-items-center gap-3">
                    <div class="stat-icon bg-info bg-opacity-10 text-info">
                        <i class="bi bi-graph-up-arrow"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div class="d-flex align-items-baseline gap-1 mb-1">
                            <span class="fs-4 fw-bold text-dark lh-1">${avgProgress}</span>
                            <span class="small fw-bold text-muted">%</span>
                        </div>
                        <div class="text-muted small fw-medium">Tiến độ trung bình</div>
                        <div class="progress mt-1" style="height: 4px;">
                            <div class="progress-bar bg-info" style="width: ${avgProgress}%;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. TIẾP TỤC BÀI HỌC GẦN NHẤT (Feature 2 - Resume Hero Banner) -->
        <c:if test="${not empty recentLearning}">
            <div class="hero-resume-card p-4 p-md-4 mb-5 text-white">
                <div class="row align-items-center g-4">
                    <div class="col-lg-7 col-md-7">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="badge bg-primary px-3 py-1 rounded-pill fw-semibold small text-uppercase">
                                <span class="spinner-grow spinner-grow-sm me-1" role="status" aria-hidden="true" style="width: 8px; height: 8px;"></span>
                                Tiếp tục bài học gần nhất
                            </span>
                            <c:if test="${not empty recentLearning.categoryName}">
                                <span class="badge bg-white bg-opacity-15 text-white px-2 py-1 rounded-pill small">
                                    ${recentLearning.categoryName}
                                </span>
                            </c:if>
                        </div>

                        <div class="text-white-50 small mb-1">
                            Khóa học: <span class="text-white fw-semibold">${recentLearning.courseTitle}</span>
                        </div>
                        <h4 class="fw-bold mb-3 text-white lh-base">
                            ${recentLearning.lessonTitle}
                        </h4>

                        <!-- Course Progress Info -->
                        <div class="mb-4" style="max-width: 480px;">
                            <div class="d-flex justify-content-between small text-white-50 mb-1">
                                <span>Tiến độ khóa học: <strong class="text-white">${recentLearning.completedLessons} / ${recentLearning.totalLessons} bài</strong></span>
                                <span class="fw-bold text-primary">${recentLearning.progressPercentage}%</span>
                            </div>
                            <div class="progress" style="height: 8px; background: rgba(255, 255, 255, 0.15); border-radius: 999px;">
                                <div class="progress-bar bg-primary" role="progressbar" style="width: ${recentLearning.progressPercentage}%; border-radius: 999px;"></div>
                            </div>
                        </div>

                        <!-- CTA Button & Last Access Time -->
                        <div class="d-flex flex-wrap align-items-center gap-3">
                            <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${recentLearning.registrationId}&lessonId=${recentLearning.lessonId}" 
                               class="btn btn-primary btn-lg px-4 py-2 fw-bold rounded-pill shadow-sm d-inline-flex align-items-center">
                                <i class="bi bi-play-fill fs-4 me-1"></i>Tiếp tục học ngay
                            </a>
                            <div class="text-white-50 small">
                                <i class="bi bi-clock-history me-1"></i>Học gần nhất: <span class="text-white">${recentLearning.formattedLastStudied}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Right Thumbnail Preview -->
                    <div class="col-lg-5 col-md-5">
                        <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${recentLearning.registrationId}&lessonId=${recentLearning.lessonId}" 
                           class="d-block hero-thumb-wrapper text-decoration-none" title="Nhấn để tiếp tục học">
                            <img src="${recentLearning.thumbnailUrl}" alt="${recentLearning.courseTitle}" onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=60'">
                            <div class="hero-play-btn">
                                <i class="bi bi-play-fill ms-1"></i>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- 5. TÌM KIẾM, LỌC KHÓA HỌC (Feature 5 - Filter & Search Toolbar) -->
        <c:choose>
            <c:when test="${empty registrations}">
                <div class="card p-5 text-center my-4 border-0 shadow-sm" style="background: #ffffff; border-radius: 18px;">
                    <div class="mb-3">
                        <div class="d-inline-flex p-3 rounded-circle bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-mortarboard fs-1"></i>
                        </div>
                    </div>
                    <h4 class="fw-bold text-dark">Bạn chưa đăng ký khóa học nào!</h4>
                    <p class="text-muted mx-auto" style="max-width: 480px;">
                        Khám phá kho tàng kiến thức phong phú từ Chiêm tinh học, Tử vi phong thủy đến Nhân tướng học tại Courson LMS.
                    </p>
                    <div class="mt-2">
                        <a href="${pageContext.request.contextPath}/courses/catalog" class="btn btn-primary px-4 py-2 rounded-pill fw-semibold shadow-sm">
                            <i class="bi bi-search me-1"></i>Khám phá khóa học ngay
                        </a>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="bg-white p-3 p-md-4 rounded-4 border mb-4 shadow-sm">
                    <div class="row g-3 align-items-center">
                        
                        <!-- Status Tabs -->
                        <div class="col-12 col-xl-6">
                            <div class="d-flex flex-wrap gap-2" id="statusFilterGroup">
                                <button type="button" class="filter-tab-btn active" data-status="ALL">
                                    Tất cả <span class="badge bg-secondary ms-1">${totalCourses}</span>
                                </button>
                                <button type="button" class="filter-tab-btn" data-status="IN_PROGRESS">
                                    Đang học <span class="badge bg-warning text-dark ms-1">${inProgressCourses}</span>
                                </button>
                                <button type="button" class="filter-tab-btn" data-status="COMPLETED">
                                    Đã hoàn thành <span class="badge bg-success ms-1">${completedCourses}</span>
                                </button>
                                <c:if test="${pendingCourses > 0}">
                                    <button type="button" class="filter-tab-btn" data-status="PENDING">
                                        Chờ thanh toán <span class="badge bg-warning ms-1">${pendingCourses}</span>
                                    </button>
                                </c:if>
                            </div>
                        </div>

                        <!-- Search Bar + Category Dropdown + Sort -->
                        <div class="col-12 col-xl-6">
                            <div class="row g-2">
                                <!-- Search Input -->
                                <div class="col-12 col-md-5">
                                    <div class="input-group">
                                        <span class="input-group-text bg-white border-end-0 text-muted">
                                            <i class="bi bi-search"></i>
                                        </span>
                                        <input type="text" id="courseSearchInput" class="form-control border-start-0 ps-0" placeholder="Tìm theo tên khóa, giảng viên...">
                                        <button class="btn btn-outline-secondary border-start-0 border-end-1 d-none" type="button" id="clearSearchBtn">
                                            <i class="bi bi-x"></i>
                                        </button>
                                    </div>
                                </div>

                                <!-- Category Filter -->
                                <div class="col-6 col-md-4">
                                    <select class="form-select" id="categoryFilter">
                                        <option value="ALL">Tất cả danh mục</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat}">${cat}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Sort Dropdown -->
                                <div class="col-6 col-md-3">
                                    <select class="form-select" id="sortSelect">
                                        <option value="recent">Mới nhất</option>
                                        <option value="progress-desc">Tiến độ cao</option>
                                        <option value="progress-asc">Tiến độ thấp</option>
                                        <option value="name-asc">Tên A-Z</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- 3 & 4. DANH SÁCH KHÓA ĐÃ ĐĂNG KÝ & TIẾN ĐỘ HOÀN THÀNH (Feature 3 & 4) -->
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="coursesGrid">
                    <c:forEach var="r" items="${registrations}">
                        <div class="col course-card-wrapper"
                             data-id="${r.id}"
                             data-title="${r.courseTitle}"
                             data-expert="${r.expertName}"
                             data-category="${r.categoryName}"
                             data-status="${r.courseStatus == 'DRAFT' ? 'LOCKED' : ((r.status == 'COMPLETED' or (r.totalLessons > 0 and r.completedLessons >= r.totalLessons)) ? 'COMPLETED' : (r.status == 'PENDING' ? 'PENDING' : 'IN_PROGRESS'))}"
                             data-progress="${r.progressPercentage}">
                            
                            <div class="course-grid-card">
                                <!-- Card Thumbnail Container -->
                                <div class="card-thumb-container">
                                    <!-- Category Pill -->
                                    <c:if test="${not empty r.categoryName}">
                                        <span class="card-cat-badge">
                                            <i class="bi bi-tag-fill me-1"></i>${r.categoryName}
                                        </span>
                                    </c:if>

                                    <!-- Status Pill -->
                                    <c:choose>
                                        <c:when test="${r.courseStatus == 'DRAFT'}">
                                            <span class="card-status-badge bg-secondary text-white">
                                                <i class="bi bi-lock-fill me-1"></i>Tạm khóa cập nhật
                                            </span>
                                        </c:when>
                                        <c:when test="${r.status == 'COMPLETED' or (r.totalLessons > 0 and r.completedLessons >= r.totalLessons)}">
                                            <span class="card-status-badge bg-success text-white">
                                                <i class="bi bi-check-circle-fill me-1"></i>Đã hoàn thành
                                            </span>
                                        </c:when>
                                        <c:when test="${r.status == 'ACTIVE'}">
                                            <span class="card-status-badge bg-primary text-white">
                                                <i class="bi bi-play-circle-fill me-1"></i>Đang học
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="card-status-badge bg-warning text-dark">
                                                <i class="bi bi-clock-fill me-1"></i>Chờ thanh toán
                                            </span>
                                        </c:otherwise>
                                    </c:choose>

                                    <img src="${r.thumbnailUrl}" alt="${r.courseTitle}" onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=60'">
                                </div>

                                <!-- Card Body -->
                                <div class="p-3 p-md-4 d-flex flex-column flex-grow-1">
                                    
                                    <!-- Course Title -->
                                    <h5 class="fw-bold mb-2 line-clamp-2 text-dark" title="${r.courseTitle}" style="min-height: 2.8rem; line-height: 1.4;">
                                        ${r.courseTitle}
                                    </h5>

                                    <!-- Expert Name -->
                                    <div class="d-flex align-items-center text-muted small mb-3">
                                        <i class="bi bi-person-workspace text-primary me-2 fs-6"></i>
                                        <span class="text-truncate">${not empty r.expertName ? r.expertName : 'Giảng viên Courson'}</span>
                                    </div>

                                    <!-- Archive / Draft Notice if applicable -->
                                    <c:choose>
                                        <c:when test="${r.courseStatus == 'DRAFT'}">
                                            <div class="alert alert-secondary py-1 px-2 small mb-3 d-flex align-items-center gap-1 rounded-2">
                                                <i class="bi bi-lock-fill text-secondary me-1"></i>
                                                <span style="font-size: 0.76rem;">Khóa học đang tạm thời bảo trì nội dung, tạm khóa mở bài</span>
                                            </div>
                                        </c:when>
                                        <c:when test="${r.archived}">
                                            <div class="alert alert-warning py-1 px-2 small mb-3 d-flex align-items-center gap-1 rounded-2">
                                                <i class="bi bi-archive-fill text-warning me-1"></i>
                                                <span style="font-size: 0.76rem;">Khóa học đã lưu trữ (vẫn học bình thường)</span>
                                            </div>
                                        </c:when>
                                    </c:choose>

                                    <!-- 4. TIẾN ĐỘ HOÀN THÀNH KHÓA HỌC (Feature 4 - Progress Bar & Lesson Counter) -->
                                    <div class="my-auto py-2">
                                        <div class="d-flex justify-content-between align-items-center small text-muted mb-1">
                                            <span class="fw-medium">Tiến độ</span>
                                            <span class="fw-bold ${(r.status == 'COMPLETED' or r.progressPercentage >= 100) ? 'text-success' : 'text-primary'}">
                                                ${r.completedLessons} / ${r.totalLessons} bài (${r.progressPercentage}%)
                                            </span>
                                        </div>
                                        <div class="progress" style="height: 7px; border-radius: 999px; background: #e2e8f0;">
                                            <div class="progress-bar ${(r.status == 'COMPLETED' or r.progressPercentage >= 100) ? 'bg-success' : 'bg-primary'}" 
                                                 role="progressbar" 
                                                 style="width: ${r.progressPercentage}%; border-radius: 999px;">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Action Button Footer -->
                                    <div class="mt-3 pt-3 border-top">
                                        <c:choose>
                                            <c:when test="${r.courseStatus == 'DRAFT'}">
                                                <button type="button" class="btn btn-secondary w-100 fw-semibold rounded-pill py-2 d-flex align-items-center justify-content-center" disabled title="Khóa học đang được cập nhật nội dung">
                                                    <i class="bi bi-lock-fill me-2 fs-5 lh-1"></i>
                                                    <span>Tạm khóa cập nhật</span>
                                                </button>
                                            </c:when>
                                            <c:when test="${r.status == 'ACTIVE' || r.status == 'COMPLETED'}">
                                                <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${r.id}${not empty r.lastLessonId ? '&lessonId=' : ''}${r.lastLessonId}" 
                                                   class="btn btn-primary w-100 fw-semibold rounded-pill py-2 d-flex align-items-center justify-content-center">
                                                    <i class="bi bi-play-circle-fill me-2 fs-5 lh-1"></i>
                                                    <span>
                                                        <c:choose>
                                                            <c:when test="${r.progressPercentage >= 100 or r.status == 'COMPLETED'}">Ôn tập lại</c:when>
                                                            <c:when test="${r.completedLessons > 0}">Tiếp tục học</c:when>
                                                            <c:otherwise>Vào học ngay</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </a>

                                                <!-- Recent studied lesson hint -->
                                                <c:if test="${not empty r.lastLessonTitle}">
                                                    <div class="text-muted small text-truncate mt-2 text-center" style="font-size: 0.78rem;" title="${r.lastLessonTitle}">
                                                        <i class="bi bi-play-circle text-primary me-1"></i>Bài gần nhất: ${r.lastLessonTitle}
                                                    </div>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-warning py-2 px-3 small mb-0 text-center rounded-pill fw-medium">
                                                    <i class="bi bi-hourglass-split me-1"></i>Chờ xác nhận (${r.paymentCode})
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                </div>
                            </div>

                        </div>
                    </c:forEach>
                </div>

                <!-- Empty Search Results Message -->
                <div id="noResultsMessage" class="card p-5 text-center my-4 border-0 shadow-sm d-none" style="background: #ffffff; border-radius: 18px;">
                    <div class="mb-3">
                        <div class="d-inline-flex p-3 rounded-circle bg-light text-muted">
                            <i class="bi bi-search fs-1"></i>
                        </div>
                    </div>
                    <h5 class="fw-bold text-dark">Không tìm thấy khóa học nào phù hợp</h5>
                    <p class="text-muted small">Vui lòng thử tìm kiếm với từ khóa khác hoặc điều chỉnh lại bộ lọc trạng thái và danh mục.</p>
                    <div>
                        <button type="button" class="btn btn-outline-primary btn-sm px-4 rounded-pill fw-semibold" id="resetFiltersBtn">
                            <i class="bi bi-arrow-counterclockwise me-1"></i>Xóa bộ lọc
                        </button>
                    </div>
                </div>

            </c:otherwise>
        </c:choose>

    </div>
</main>

<jsp:include page="../common/footer.jsp" />

<!-- 5. REAL-TIME SEARCH & FILTER JAVASCRIPT (Feature 5) -->
<script>
document.addEventListener('DOMContentLoaded', function () {
    const searchInput = document.getElementById('courseSearchInput');
    const clearSearchBtn = document.getElementById('clearSearchBtn');
    const categoryFilter = document.getElementById('categoryFilter');
    const sortSelect = document.getElementById('sortSelect');
    const statusButtons = document.querySelectorAll('#statusFilterGroup .filter-tab-btn');
    const coursesGrid = document.getElementById('coursesGrid');
    const noResultsMessage = document.getElementById('noResultsMessage');
    const resetFiltersBtn = document.getElementById('resetFiltersBtn');

    if (!coursesGrid) return;

    let currentStatus = 'ALL';

    function normalizeText(str) {
        if (!str) return '';
        return str.toLowerCase()
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '')
            .trim();
    }

    function filterAndSortCourses() {
        const keyword = normalizeText(searchInput ? searchInput.value : '');
        const selectedCat = categoryFilter ? categoryFilter.value : 'ALL';
        const cards = Array.from(coursesGrid.querySelectorAll('.course-card-wrapper'));

        let visibleCount = 0;

        cards.forEach(card => {
            const title = normalizeText(card.getAttribute('data-title'));
            const expert = normalizeText(card.getAttribute('data-expert'));
            const cat = card.getAttribute('data-category') || '';
            const status = card.getAttribute('data-status') || '';

            // 1. Status Filter
            const matchStatus = (currentStatus === 'ALL') || (status === currentStatus);

            // 2. Category Filter
            const matchCategory = (selectedCat === 'ALL') || (cat === selectedCat);

            // 3. Search Keyword Filter
            const matchKeyword = !keyword || title.includes(keyword) || expert.includes(keyword);

            if (matchStatus && matchCategory && matchKeyword) {
                card.classList.remove('d-none');
                visibleCount++;
            } else {
                card.classList.add('d-none');
            }
        });

        // 4. Sorting
        const sortMode = sortSelect ? sortSelect.value : 'recent';
        cards.sort((a, b) => {
            if (sortMode === 'name-asc') {
                const titleA = (a.getAttribute('data-title') || '').toLowerCase();
                const titleB = (b.getAttribute('data-title') || '').toLowerCase();
                return titleA.localeCompare(titleB, 'vi');
            } else if (sortMode === 'progress-desc') {
                const progA = parseFloat(a.getAttribute('data-progress') || 0);
                const progB = parseFloat(b.getAttribute('data-progress') || 0);
                return progB - progA;
            } else if (sortMode === 'progress-asc') {
                const progA = parseFloat(a.getAttribute('data-progress') || 0);
                const progB = parseFloat(b.getAttribute('data-progress') || 0);
                return progA - progB;
            } else {
                // Default 'recent' by registration ID descending
                const idA = parseInt(a.getAttribute('data-id') || 0);
                const idB = parseInt(b.getAttribute('data-id') || 0);
                return idB - idA;
            }
        });

        cards.forEach(card => coursesGrid.appendChild(card));

        // Toggle empty message
        if (noResultsMessage) {
            if (visibleCount === 0) {
                noResultsMessage.classList.remove('d-none');
            } else {
                noResultsMessage.classList.add('d-none');
            }
        }
    }

    // Status Tab Click Event
    statusButtons.forEach(btn => {
        btn.addEventListener('click', function () {
            statusButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            currentStatus = this.getAttribute('data-status');
            filterAndSortCourses();
        });
    });

    // Search Input Event
    if (searchInput) {
        searchInput.addEventListener('input', function () {
            if (clearSearchBtn) {
                if (this.value.trim().length > 0) {
                    clearSearchBtn.classList.remove('d-none');
                } else {
                    clearSearchBtn.classList.add('d-none');
                }
            }
            filterAndSortCourses();
        });
    }

    // Clear Search Button
    if (clearSearchBtn) {
        clearSearchBtn.addEventListener('click', function () {
            searchInput.value = '';
            clearSearchBtn.classList.add('d-none');
            filterAndSortCourses();
            searchInput.focus();
        });
    }

    // Category Filter Event
    if (categoryFilter) {
        categoryFilter.addEventListener('change', filterAndSortCourses);
    }

    // Sort Dropdown Event
    if (sortSelect) {
        sortSelect.addEventListener('change', filterAndSortCourses);
    }

    // Reset Filters Button
    if (resetFiltersBtn) {
        resetFiltersBtn.addEventListener('click', function () {
            if (searchInput) {
                searchInput.value = '';
                if (clearSearchBtn) clearSearchBtn.classList.add('d-none');
            }
            if (categoryFilter) categoryFilter.value = 'ALL';
            if (sortSelect) sortSelect.value = 'recent';

            statusButtons.forEach(b => b.classList.remove('active'));
            const allBtn = document.querySelector('#statusFilterGroup .filter-tab-btn[data-status="ALL"]');
            if (allBtn) allBtn.classList.add('active');
            currentStatus = 'ALL';

            filterAndSortCourses();
        });
    }
});
</script>
