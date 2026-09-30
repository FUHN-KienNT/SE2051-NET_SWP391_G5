<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Quản lý bài thi (Quiz List) - ${not empty course ? course.title : 'Courson LMS'}" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<style>
    /* Courson LMS Quiz List Design Tokens */
    :root {
        --primary-gradient: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
        --accent-gradient: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
        --surface-subtle: #f8fafc;
        --border-color: #e2e8f0;
        --text-primary: #0f172a;
        --text-secondary: #64748b;
    }

    /* Hero Banner & Badges */
    .quiz-hero-card {
        background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
        border: 1px solid var(--border-color);
        border-radius: 18px;
        box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
    }

    /* KPI Stat Cards */
    .kpi-card {
        background: #ffffff;
        border: 1px solid var(--border-color);
        border-radius: 16px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
        position: relative;
        overflow: hidden;
    }
    .kpi-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 12px 24px -4px rgba(0, 0, 0, 0.08);
        border-color: #cbd5e1;
    }
    .kpi-icon-wrapper {
        width: 50px;
        height: 50px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 14px;
        font-size: 1.5rem;
    }

    /* Sticky Control Toolbar */
    .filter-toolbar {
        position: sticky;
        top: 1rem;
        z-index: 1020;
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        background: rgba(255, 255, 255, 0.94);
        border: 1px solid var(--border-color);
        border-radius: 16px;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06);
    }

    /* Module Accordion & Cards */
    .module-card {
        background: #ffffff;
        border: 1px solid var(--border-color);
        border-radius: 16px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
        transition: all 0.25s ease-in-out;
    }
    .module-card:hover {
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
    }
    .module-card.target-highlight {
        animation: highlightPulse 2s ease-out;
        border-color: #3b82f6 !important;
    }
    @keyframes highlightPulse {
        0% { box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.5); }
        70% { box-shadow: 0 0 0 15px rgba(59, 130, 246, 0); }
        100% { box-shadow: 0 0 0 0 rgba(59, 130, 246, 0); }
    }

    .module-badge-seq {
        background: var(--primary-gradient);
        color: white;
        font-weight: 600;
        font-size: 0.8rem;
        padding: 0.35rem 0.75rem;
        border-radius: 20px;
        letter-spacing: 0.3px;
    }

    /* Table Styling */
    .quiz-table thead th {
        font-size: 0.78rem;
        text-transform: uppercase;
        letter-spacing: 0.6px;
        font-weight: 700;
        color: #64748b;
        background-color: #f8fafc;
        border-bottom: 1px solid #e2e8f0;
        padding-top: 0.9rem;
        padding-bottom: 0.9rem;
    }
    .quiz-table tbody tr {
        transition: background-color 0.15s ease-in-out;
    }
    .quiz-table tbody tr:hover {
        background-color: #f1f5f9;
    }
    .quiz-title-link {
        color: #0f172a;
        font-weight: 600;
        text-decoration: none;
        transition: color 0.15s ease;
    }
    .quiz-title-link:hover {
        color: #2563eb;
    }

    /* Action Buttons */
    .btn-action-group .btn {
        transition: all 0.2s ease;
    }
    .btn-action-group .btn:hover {
        transform: translateY(-1px);
    }

    /* Quick Preset Badges */
    .preset-pill {
        cursor: pointer;
        user-select: none;
        transition: all 0.15s ease;
    }
    .preset-pill:hover {
        background-color: #2563eb !important;
        color: white !important;
        border-color: #2563eb !important;
    }

    /* Empty States */
    .empty-state-dashed {
        border: 2px dashed #cbd5e1;
        border-radius: 14px;
        background-color: #f8fafc;
    }
</style>

<main class="main-content py-4">
    <div class="container-fluid px-lg-5 px-3">

        <!-- Breadcrumb Navigation -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0 py-2 px-3 bg-white rounded-pill shadow-sm border small" style="width: fit-content;">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/expert/dashboard" class="text-decoration-none text-muted">
                        <i class="bi bi-mortarboard me-1 text-primary"></i>Expert Dashboard
                    </a>
                </li>
                <c:if test="${not empty course}">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="text-decoration-none text-muted text-truncate" style="max-width: 250px;">
                            ${course.title}
                        </a>
                    </li>
                </c:if>
                <li class="breadcrumb-item active fw-semibold text-primary" aria-current="page">
                    <i class="bi bi-patch-question me-1"></i>Quản lý Quiz &amp; Bài kiểm tra
                </li>
            </ol>
        </nav>

        <!-- System Alerts -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-4 mb-4 d-flex align-items-center" role="alert">
                <div class="bg-success text-white rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 38px; height: 38px;">
                    <i class="bi bi-check-lg fs-5"></i>
                </div>
                <div>
                    <strong class="d-block">Thành công!</strong>
                    <span class="small">
                        <c:choose>
                            <c:when test="${param.success == 'deleted'}">Đã xóa bài kiểm tra và gỡ bỏ cấu hình liên quan thành công.</c:when>
                            <c:when test="${param.success == 'saved'}">Đã lưu thông tin cấu hình bài kiểm tra thành công.</c:when>
                            <c:otherwise>Thao tác đã được hệ thống ghi nhận thành công.</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-4 mb-4 d-flex align-items-center" role="alert">
                <div class="bg-danger text-white rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 38px; height: 38px;">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                </div>
                <div>
                    <strong class="d-block">Đã xảy ra lỗi!</strong>
                    <span class="small">${param.error}</span>
                </div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <%-- TÍNH TOÁN CHỈ SỐ KPI BẰNG JSTL THUẦN (KHÔNG CAN THIỆP BACKEND) --%>
        <c:set var="totalQuizCount" value="0" />
        <c:set var="totalModuleCount" value="${not empty course and not empty course.modules ? fn:length(course.modules) : 0}" />
        <c:set var="modulesWithQuizCount" value="0" />
        <c:set var="totalPassScore" value="0" />
        <c:set var="timedQuizCount" value="0" />

        <c:if test="${not empty course and not empty course.modules}">
            <c:forEach var="modItem" items="${course.modules}">
                <c:set var="mQuizCount" value="${not empty modItem.quizzes ? fn:length(modItem.quizzes) : 0}" />
                <c:if test="${mQuizCount > 0}">
                    <c:set var="modulesWithQuizCount" value="${modulesWithQuizCount + 1}" />
                    <c:set var="totalQuizCount" value="${totalQuizCount + mQuizCount}" />
                    <c:forEach var="qzItem" items="${modItem.quizzes}">
                        <c:if test="${qzItem.passScore != null}">
                            <c:set var="totalPassScore" value="${totalPassScore + qzItem.passScore}" />
                        </c:if>
                        <c:if test="${qzItem.timeLimitMinutes != null and qzItem.timeLimitMinutes > 0}">
                            <c:set var="timedQuizCount" value="${timedQuizCount + 1}" />
                        </c:if>
                    </c:forEach>
                </c:if>
            </c:forEach>
        </c:if>

        <c:set var="avgPassScore" value="${totalQuizCount > 0 ? (totalPassScore / totalQuizCount) : 0}" />
        <c:set var="coverageRate" value="${totalModuleCount > 0 ? (modulesWithQuizCount * 100 / totalModuleCount) : 0}" />

        <!-- Top Hero Card -->
        <div class="quiz-hero-card p-4 p-md-5 mb-4 position-relative">
            <div class="row align-items-center g-4">
                <div class="col-lg-8">
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-1 mb-2 rounded-pill fw-semibold">
                        <i class="bi bi-shield-check me-1"></i>Hệ thống Khảo thí &amp; Đánh giá Năng lực
                    </span>
                    <h2 class="fw-bold text-dark mb-2">
                        <c:choose>
                            <c:when test="${not empty course}">
                                Đề cương Bài thi &amp; Quiz: <span class="text-primary">${course.title}</span>
                            </c:when>
                            <c:otherwise>
                                Danh sách Bài thi &amp; Kiểm tra (Quiz List)
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <p class="text-muted mb-0">
                        Quản lý toàn diện các bài thi trắc nghiệm, cấu hình thời gian làm bài và điểm đạt phân bổ theo từng chương học (Màn hình II.5.1.1).
                    </p>
                </div>
                <div class="col-lg-4 text-lg-end">
                    <div class="d-flex flex-wrap gap-2 justify-content-lg-end">
                        <c:if test="${not empty course}">
                            <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-outline-secondary rounded-pill px-3 shadow-sm">
                                <i class="bi bi-journal-text me-1 text-primary"></i>Nội dung bài học
                            </a>
                        </c:if>
                        <c:if test="${not empty course and not empty course.modules}">
                            <button type="button" class="btn btn-primary rounded-pill px-4 shadow-sm fw-semibold" onclick="openCreateQuizModal('')">
                                <i class="bi bi-plus-lg me-1"></i>Tạo bài Quiz mới
                            </button>
                        </c:if>
                        <c:if test="${empty course and not empty moduleId}">
                            <a href="${pageContext.request.contextPath}/quizzes/question-bank?moduleId=${moduleId}" class="btn btn-outline-info rounded-pill px-3 shadow-sm">
                                <i class="bi bi-bank me-1"></i>Ngân hàng câu hỏi
                            </a>
                            <button type="button" class="btn btn-primary rounded-pill px-4 shadow-sm fw-semibold" onclick="openCreateQuizModal('${moduleId}')">
                                <i class="bi bi-plus-lg me-1"></i>Tạo bài Quiz mới
                            </button>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <c:choose>
            <%-- TH1: Hiển thị theo Khóa học (Course) --%>
            <c:when test="${not empty course}">
                <!-- KPI Stat Cards Row -->
                <div class="row g-3 mb-4">
                    <div class="col-xl-3 col-sm-6">
                        <div class="kpi-card p-3 h-100 d-flex align-items-center">
                            <div class="kpi-icon-wrapper bg-primary-subtle text-primary me-3 flex-shrink-0">
                                <i class="bi bi-patch-question-fill"></i>
                            </div>
                            <div class="flex-grow-1">
                                <span class="text-muted small text-uppercase fw-semibold d-block">Tổng số bài Quiz</span>
                                <h3 class="fw-bold mb-0 text-dark">${totalQuizCount} <span class="fs-6 fw-normal text-muted">bài</span></h3>
                                <small class="text-muted">Phân bổ trong ${totalModuleCount} chương</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6">
                        <div class="kpi-card p-3 h-100 d-flex align-items-center">
                            <div class="kpi-icon-wrapper bg-success-subtle text-success me-3 flex-shrink-0">
                                <i class="bi bi-folder-check"></i>
                            </div>
                            <div class="flex-grow-1">
                                <span class="text-muted small text-uppercase fw-semibold d-block">Độ phủ chương học</span>
                                <h3 class="fw-bold mb-0 text-dark">${modulesWithQuizCount} / ${totalModuleCount} <span class="fs-6 fw-normal text-muted">chương</span></h3>
                                <div class="progress mt-1" style="height: 5px;">
                                    <div class="progress-bar bg-success" role="progressbar" style="width: ${coverageRate}%;" aria-valuenow="${coverageRate}" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6">
                        <div class="kpi-card p-3 h-100 d-flex align-items-center">
                            <div class="kpi-icon-wrapper bg-warning-subtle text-warning me-3 flex-shrink-0">
                                <i class="bi bi-bullseye"></i>
                            </div>
                            <div class="flex-grow-1">
                                <span class="text-muted small text-uppercase fw-semibold d-block">Điểm đạt trung bình</span>
                                <h3 class="fw-bold mb-0 text-dark">
                                    <fmt:formatNumber value="${avgPassScore}" maxFractionDigits="1" />%
                                </h3>
                                <small class="text-muted">Tiêu chuẩn hoàn thành bài thi</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6">
                        <div class="kpi-card p-3 h-100 d-flex align-items-center">
                            <div class="kpi-icon-wrapper bg-info-subtle text-info me-3 flex-shrink-0">
                                <i class="bi bi-stopwatch-fill"></i>
                            </div>
                            <div class="flex-grow-1">
                                <span class="text-muted small text-uppercase fw-semibold d-block">Bài thi có hẹn giờ</span>
                                <h3 class="fw-bold mb-0 text-dark">${timedQuizCount} / ${totalQuizCount}</h3>
                                <small class="text-muted">Kiểm soát thời gian thực tế</small>
                            </div>
                        </div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty course.modules}">
                        <!-- Empty State: Course has no modules -->
                        <div class="card p-5 text-center border-0 shadow-sm rounded-4 empty-state-dashed mb-4">
                            <div class="mx-auto mb-3 text-muted">
                                <i class="bi bi-folder2-open display-3 text-primary"></i>
                            </div>
                            <h4 class="fw-bold text-dark">Khóa học này chưa có chương học nào!</h4>
                            <p class="text-muted small mx-auto" style="max-width: 480px;">
                                Để có thể thiết lập các bài kiểm tra trắc nghiệm, trước tiên bạn cần tạo ít nhất một chương học (Module) cho khóa học này.
                            </p>
                            <div class="mt-2">
                                <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}" class="btn btn-primary rounded-pill px-4 shadow-sm">
                                    <i class="bi bi-plus-circle me-1"></i>Đi đến Quản lý Chương &amp; Bài học
                                </a>
                            </div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <!-- Sticky Interactive Filter & Control Toolbar -->
                        <div class="filter-toolbar p-3 mb-4">
                            <div class="row g-2 align-items-center">
                                <!-- Realtime Search Input -->
                                <div class="col-md-5 col-12">
                                    <div class="input-group">
                                        <span class="input-group-text bg-white border-end-0 rounded-start-pill text-muted">
                                            <i class="bi bi-search"></i>
                                        </span>
                                        <input type="text" id="quizSearchInput" class="form-control border-start-0 border-end-0" 
                                               placeholder="Tìm nhanh bài quiz theo tên bài, thời lượng..." aria-label="Tìm kiếm bài quiz">
                                        <button class="btn btn-outline-secondary border-start-0 rounded-end-pill d-none" type="button" id="clearSearchBtn">
                                            <i class="bi bi-x-circle-fill"></i>
                                        </button>
                                    </div>
                                </div>

                                <!-- Filter by Module -->
                                <div class="col-md-3 col-sm-6">
                                    <select id="moduleFilterSelect" class="form-select rounded-pill">
                                        <option value="all">Tất cả chương học (${totalModuleCount})</option>
                                        <c:forEach var="m" items="${course.modules}">
                                            <option value="${m.id}" ${selectedModuleId == m.id ? 'selected' : ''}>
                                                Chương ${m.orderIndex}: ${m.title}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Quick Filter Chips & Action Toggles -->
                                <div class="col-md-4 col-sm-6 text-sm-end d-flex justify-content-sm-end align-items-center gap-2">
                                    <span id="quizCounterBadge" class="badge bg-secondary-subtle text-secondary border px-3 py-2 rounded-pill small">
                                        Hiển thị: <strong id="visibleQuizCount">${totalQuizCount}</strong> bài
                                    </span>
                                    <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-3" id="toggleAllBtn" title="Thu gọn / Mở rộng tất cả">
                                        <i class="bi bi-arrows-collapse me-1"></i><span id="toggleAllText">Thu gọn tất cả</span>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- No Search Results Alert (Initially hidden) -->
                        <div id="noSearchResultsAlert" class="card p-4 text-center border-0 shadow-sm rounded-4 empty-state-dashed mb-4 d-none">
                            <i class="bi bi-search text-muted fs-1 mb-2"></i>
                            <h5 class="fw-semibold text-dark mb-1">Không tìm thấy bài Quiz nào phù hợp!</h5>
                            <p class="text-muted small mb-3">Vui lòng thử lại với từ khóa khác hoặc xóa bộ lọc tìm kiếm.</p>
                            <div>
                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3" onclick="resetSearchFilter()">
                                    <i class="bi bi-arrow-counterclockwise me-1"></i>Xóa bộ lọc tìm kiếm
                                </button>
                            </div>
                        </div>

                        <!-- Module & Quiz Card Accordion List -->
                        <div class="row g-4" id="modulesContainer">
                            <c:forEach var="m" items="${course.modules}">
                                <div class="col-12 module-wrapper" id="module-wrapper-${m.id}" data-module-id="${m.id}">
                                    <div class="module-card overflow-hidden ${selectedModuleId == m.id ? 'border-primary shadow' : ''}" id="module-${m.id}">
                                        
                                        <!-- Module Header Bar -->
                                        <div class="card-header bg-white py-3 px-4 d-flex flex-wrap justify-content-between align-items-center gap-2 border-bottom">
                                            <div class="d-flex align-items-center gap-2 flex-grow-1">
                                                <button class="btn btn-sm btn-light rounded-circle p-1 d-flex align-items-center justify-content-center collapse-toggle-btn" 
                                                        type="button" data-bs-toggle="collapse" data-bs-target="#moduleCollapse-${m.id}" aria-expanded="true"
                                                        style="width: 32px; height: 32px;">
                                                    <i class="bi bi-chevron-down text-muted transition-icon"></i>
                                                </button>
                                                <span class="module-badge-seq">Chương ${m.orderIndex}</span>
                                                <h5 class="fw-bold mb-0 text-dark">${m.title}</h5>
                                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill ms-1 quiz-count-badge">
                                                    <i class="bi bi-patch-question me-1"></i>${not empty m.quizzes ? fn:length(m.quizzes) : 0} bài quiz
                                                </span>
                                            </div>

                                            <div class="d-flex gap-2 align-items-center">
                                                <a href="${pageContext.request.contextPath}/quizzes/question-bank?moduleId=${m.id}&courseId=${course.id}" 
                                                   class="btn btn-sm btn-outline-info rounded-pill px-3" title="Quản lý ngân hàng câu hỏi của chương này">
                                                    <i class="bi bi-bank me-1"></i>Ngân hàng câu hỏi
                                                </a>
                                                <button type="button" class="btn btn-sm btn-primary rounded-pill px-3 fw-semibold shadow-sm" 
                                                        onclick="openCreateQuizModal('${m.id}')">
                                                    <i class="bi bi-plus-lg me-1"></i>Thêm Quiz
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Collapsible Module Quizzes Table Body -->
                                        <div class="collapse show" id="moduleCollapse-${m.id}">
                                            <div class="card-body p-0">
                                                <c:choose>
                                                    <c:when test="${empty m.quizzes}">
                                                        <div class="p-5 text-center text-muted empty-module-quiz">
                                                            <div class="mb-2">
                                                                <i class="bi bi-patch-question text-muted fs-1 opacity-50"></i>
                                                            </div>
                                                            <h6 class="fw-semibold text-dark">Chưa có bài Quiz nào trong chương này</h6>
                                                            <p class="small text-muted mb-3">Tạo bài kiểm tra để đánh giá mức độ hiểu bài của học viên sau khi học xong chương này.</p>
                                                            <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3" onclick="openCreateQuizModal('${m.id}')">
                                                                <i class="bi bi-plus-circle me-1"></i>Tạo bài kiểm tra đầu tiên
                                                            </button>
                                                        </div>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <div class="table-responsive">
                                                            <table class="table quiz-table align-middle mb-0">
                                                                <thead>
                                                                    <tr>
                                                                        <th style="width: 80px;" class="ps-4">Thứ tự</th>
                                                                        <th>Tiêu đề bài thi (Quiz Title)</th>
                                                                        <th style="width: 160px;" class="text-center">Điểm đạt tối thiểu</th>
                                                                        <th style="width: 170px;" class="text-center">Thời lượng</th>
                                                                        <th style="width: 220px;" class="text-end pe-4">Hành động</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody class="module-quiz-tbody">
                                                                    <c:forEach var="q" items="${m.quizzes}">
                                                                        <tr class="quiz-row" data-quiz-id="${q.id}" data-quiz-title="${fn:toLowerCase(q.title)}" data-module-id="${m.id}">
                                                                            <td class="ps-4">
                                                                                <span class="badge bg-light text-dark border rounded-pill px-2 py-1 fw-semibold">
                                                                                    #${q.orderIndex}
                                                                                </span>
                                                                            </td>
                                                                            <td>
                                                                                <div class="d-flex align-items-center">
                                                                                    <div class="bg-primary-subtle text-primary rounded-3 p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                                                                                        <i class="bi bi-file-earmark-check"></i>
                                                                                    </div>
                                                                                    <div>
                                                                                        <a href="${pageContext.request.contextPath}/quizzes/detail?id=${q.id}&courseId=${course.id}" 
                                                                                           class="quiz-title-link d-block" title="Xem chi tiết &amp; gán câu hỏi">
                                                                                            ${q.title}
                                                                                        </a>
                                                                                        <span class="small text-muted">Mã đề: #${q.id}</span>
                                                                                    </div>
                                                                                </div>
                                                                            </td>
                                                                            <td class="text-center">
                                                                                <c:choose>
                                                                                    <c:when test="${q.passScore >= 80}">
                                                                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-1.5 rounded-pill">
                                                                                            <i class="bi bi-shield-check me-1"></i>${q.passScore}%
                                                                                        </span>
                                                                                    </c:when>
                                                                                    <c:when test="${q.passScore >= 50}">
                                                                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-1.5 rounded-pill">
                                                                                            <i class="bi bi-check2-circle me-1"></i>${q.passScore}%
                                                                                        </span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle px-3 py-1.5 rounded-pill">
                                                                                            <i class="bi bi-exclamation-circle me-1"></i>${q.passScore}%
                                                                                        </span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td class="text-center">
                                                                                <c:choose>
                                                                                    <c:when test="${q.timeLimitMinutes != null and q.timeLimitMinutes > 0}">
                                                                                        <span class="badge bg-secondary-subtle text-dark border px-3 py-1.5 rounded-pill">
                                                                                            <i class="bi bi-clock-history me-1 text-primary"></i>${q.timeLimitMinutes} phút
                                                                                        </span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="badge bg-light text-muted border px-3 py-1.5 rounded-pill">
                                                                                            <i class="bi bi-infinity me-1"></i>Không giới hạn
                                                                                        </span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td class="text-end pe-4">
                                                                                <div class="btn-group btn-action-group" role="group">
                                                                                    <a href="${pageContext.request.contextPath}/quizzes/detail?id=${q.id}&courseId=${course.id}" 
                                                                                       class="btn btn-sm btn-outline-primary rounded-start-pill px-2.5" 
                                                                                       title="Chi tiết cấu hình và gán câu hỏi">
                                                                                        <i class="bi bi-sliders2-vertical me-1"></i>Gán câu hỏi
                                                                                    </a>
                                                                                    <button type="button" class="btn btn-sm btn-outline-secondary px-2.5" 
                                                                                            onclick="openEditQuizModal('${q.id}', '${m.id}', '${fn:escapeXml(q.title)}', '${q.passScore}', '${q.timeLimitMinutes != null ? q.timeLimitMinutes : ''}', '${q.orderIndex}')"
                                                                                            title="Chỉnh sửa nhanh thông tin bài thi">
                                                                                        <i class="bi bi-pencil"></i>
                                                                                    </button>
                                                                                    <button type="button" class="btn btn-sm btn-outline-danger rounded-end-pill px-2.5" 
                                                                                            onclick="openDeleteQuizModal('${q.id}', '${fn:escapeXml(q.title)}', '${course.id}', '${m.id}')"
                                                                                            title="Xóa bài thi này">
                                                                                        <i class="bi bi-trash3"></i>
                                                                                    </button>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:when>

            <%-- TH2: Fallback hiển thị theo 1 Module đơn lẻ (khi chỉ truyền moduleId) --%>
            <c:otherwise>
                <c:choose>
                    <c:when test="${empty quizzes}">
                        <div class="card p-5 text-center border-0 shadow-sm rounded-4 empty-state-dashed mb-4">
                            <i class="bi bi-journal-x display-3 text-muted mb-3"></i>
                            <h4 class="fw-bold text-dark">Chưa có bài Quiz nào trong chương này (#${moduleId})!</h4>
                            <p class="text-muted small mx-auto" style="max-width: 480px;">
                                Hãy bấm nút "Tạo bài Quiz mới" ở góc trên để thiết lập đề thi trắc nghiệm đánh giá kết quả học tập.
                            </p>
                            <div class="mt-2">
                                <button type="button" class="btn btn-primary rounded-pill px-4 shadow-sm" onclick="openCreateQuizModal('${moduleId}')">
                                    <i class="bi bi-plus-circle me-1"></i>Tạo bài Quiz đầu tiên
                                </button>
                            </div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="module-card overflow-hidden mb-4">
                            <div class="card-header bg-white py-3 px-4 d-flex justify-content-between align-items-center border-bottom">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="module-badge-seq">Chương #${moduleId}</span>
                                    <h5 class="fw-bold mb-0">Danh sách bài Quiz trong chương</h5>
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill">
                                        ${quizzes.size()} bài quiz
                                    </span>
                                </div>
                                <div>
                                    <button type="button" class="btn btn-primary btn-sm rounded-pill px-3" onclick="openCreateQuizModal('${moduleId}')">
                                        <i class="bi bi-plus-lg me-1"></i>Tạo bài Quiz mới
                                    </button>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="table quiz-table align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th style="width: 80px;" class="ps-4">Thứ tự</th>
                                            <th>Tiêu đề bài thi</th>
                                            <th style="width: 160px;" class="text-center">Điểm đạt</th>
                                            <th style="width: 170px;" class="text-center">Thời lượng</th>
                                            <th style="width: 220px;" class="text-end pe-4">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="q" items="${quizzes}">
                                            <tr>
                                                <td class="ps-4">
                                                    <span class="badge bg-light text-dark border rounded-pill px-2.5 py-1">#${q.orderIndex}</span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="bg-primary-subtle text-primary rounded-3 p-2 me-3" style="width: 36px; height: 36px;">
                                                            <i class="bi bi-file-earmark-check"></i>
                                                        </div>
                                                        <div>
                                                            <a href="${pageContext.request.contextPath}/quizzes/detail?id=${q.id}" class="quiz-title-link">
                                                                ${q.title}
                                                            </a>
                                                            <span class="small text-muted d-block">Mã bài thi: #${q.id}</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-1.5 rounded-pill">
                                                        <i class="bi bi-check2-circle me-1"></i>${q.passScore}%
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-secondary-subtle text-dark border px-3 py-1.5 rounded-pill">
                                                        <i class="bi bi-clock me-1 text-primary"></i>
                                                        ${q.timeLimitMinutes != null and q.timeLimitMinutes > 0 ? q.timeLimitMinutes.concat(' phút') : 'Không giới hạn'}
                                                    </span>
                                                </td>
                                                <td class="text-end pe-4">
                                                    <div class="btn-group btn-action-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/quizzes/detail?id=${q.id}" class="btn btn-sm btn-outline-primary rounded-start-pill px-2.5">
                                                            <i class="bi bi-sliders2-vertical me-1"></i>Chi tiết &amp; Gán câu hỏi
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-outline-secondary px-2.5" 
                                                                onclick="openEditQuizModal('${q.id}', '${q.moduleId}', '${fn:escapeXml(q.title)}', '${q.passScore}', '${q.timeLimitMinutes != null ? q.timeLimitMinutes : ''}', '${q.orderIndex}')">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-danger rounded-end-pill px-2.5" 
                                                                onclick="openDeleteQuizModal('${q.id}', '${fn:escapeXml(q.title)}', '', '${q.moduleId}')">
                                                            <i class="bi bi-trash3"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<!-- Modal: Tạo mới & Chỉnh sửa Quiz (Hỗ trợ cả 2 chế độ Tạo / Sửa qua 1 form chuẩn backend) -->
<div class="modal fade" id="quizModal" tabindex="-1" aria-labelledby="quizModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <form id="quizForm" action="${pageContext.request.contextPath}/quizzes/save" method="POST">
                <!-- Hidden inputs -->
                <input type="hidden" name="id" id="modalQuizId" value="">
                <c:if test="${not empty course}">
                    <input type="hidden" name="courseId" value="${course.id}">
                </c:if>

                <div class="modal-header bg-light py-3 px-4 border-bottom">
                    <div class="d-flex align-items-center gap-2">
                        <div class="bg-primary text-white rounded-circle p-2 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                            <i class="bi bi-patch-question-fill fs-5" id="modalHeaderIcon"></i>
                        </div>
                        <div>
                            <h5 class="modal-title fw-bold text-dark mb-0" id="quizModalLabel">Tạo bài kiểm tra mới (Quiz)</h5>
                            <small class="text-muted" id="modalSubTitle">Thiết lập cấu hình làm bài và chuẩn điểm đạt</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <!-- Chọn Module (Chương học) -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">
                            Thuộc chương học <span class="text-danger">*</span>
                        </label>
                        <c:choose>
                            <c:when test="${not empty course and not empty course.modules}">
                                <select name="moduleId" id="modalModuleSelect" class="form-select rounded-3 py-2" required>
                                    <c:forEach var="moduleItem" items="${course.modules}">
                                        <option value="${moduleItem.id}">
                                            Chương ${moduleItem.orderIndex}: ${moduleItem.title}
                                        </option>
                                    </c:forEach>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="moduleId" id="modalModuleSelect" value="${moduleId}">
                                <input type="text" class="form-control rounded-3 bg-light" value="Chương hiện tại (#${moduleId})" readonly>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Tên bài thi -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">
                            Tên bài kiểm tra <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light text-muted border-end-0">
                                <i class="bi bi-type"></i>
                            </span>
                            <input type="text" name="title" id="modalQuizTitle" class="form-control border-start-0 py-2" 
                                   required placeholder="Ví dụ: Kiểm tra trắc nghiệm chương 1">
                        </div>
                    </div>

                    <!-- Điểm đạt tối thiểu -->
                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <label class="form-label small fw-semibold text-secondary mb-0">
                                Điểm đạt tối thiểu (0 - 100%) <span class="text-danger">*</span>
                            </label>
                            <div class="d-flex gap-1">
                                <span class="badge bg-light text-secondary border preset-pill px-2 py-1" onclick="setPresetScore(50)">50%</span>
                                <span class="badge bg-light text-secondary border preset-pill px-2 py-1" onclick="setPresetScore(60)">60%</span>
                                <span class="badge bg-light text-secondary border preset-pill px-2 py-1" onclick="setPresetScore(70)">70%</span>
                                <span class="badge bg-light text-secondary border preset-pill px-2 py-1" onclick="setPresetScore(80)">80%</span>
                            </div>
                        </div>
                        <div class="input-group">
                            <span class="input-group-text bg-light text-muted border-end-0">
                                <i class="bi bi-percent"></i>
                            </span>
                            <input type="number" step="1" name="passScore" id="modalQuizPassScore" 
                                   value="50" min="0" max="100" class="form-control border-start-0 py-2" required>
                        </div>
                        <div class="form-text small">Học viên cần đạt điểm số này trở lên để được tính là vượt qua bài kiểm tra.</div>
                    </div>

                    <!-- Thời lượng & Thứ tự -->
                    <div class="row g-3">
                        <div class="col-md-7">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label class="form-label small fw-semibold text-secondary mb-0">Thời lượng (Phút)</label>
                                <div class="d-flex gap-1">
                                    <span class="badge bg-light text-secondary border preset-pill px-1.5 py-1" onclick="setPresetTime(15)">15p</span>
                                    <span class="badge bg-light text-secondary border preset-pill px-1.5 py-1" onclick="setPresetTime(30)">30p</span>
                                    <span class="badge bg-light text-secondary border preset-pill px-1.5 py-1" onclick="setPresetTime(45)">45p</span>
                                    <span class="badge bg-light text-secondary border preset-pill px-1.5 py-1" onclick="setPresetTime('')">∞</span>
                                </div>
                            </div>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted border-end-0">
                                    <i class="bi bi-clock"></i>
                                </span>
                                <input type="number" name="timeLimitMinutes" id="modalQuizTimeLimit" 
                                       value="15" min="1" class="form-control border-start-0 py-2" 
                                       placeholder="Trống = Không giới hạn">
                            </div>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label small fw-semibold text-secondary mb-1">
                                Thứ tự hiển thị <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted border-end-0">
                                    <i class="bi bi-sort-numeric-down"></i>
                                </span>
                                <input type="number" name="orderIndex" id="modalQuizOrderIndex" 
                                       value="1" min="1" class="form-control border-start-0 py-2" required>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-light px-4 py-3 border-top">
                    <button type="button" class="btn btn-outline-secondary rounded-pill px-3" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" id="submitQuizBtn" class="btn btn-primary rounded-pill px-4 fw-semibold shadow-sm">
                        <span class="spinner-border spinner-border-sm me-1 d-none" id="submitSpinner" role="status" aria-hidden="true"></span>
                        <i class="bi bi-check2-circle me-1" id="submitIcon"></i><span id="submitBtnText">Lưu bài thi</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Xác nhận xóa bài Quiz an toàn -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden text-center p-4">
            <div class="mx-auto mb-3 text-danger bg-danger-subtle rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                <i class="bi bi-exclamation-triangle-fill fs-3"></i>
            </div>
            <h5 class="fw-bold text-dark mb-2" id="deleteConfirmModalLabel">Xác nhận xóa Quiz?</h5>
            <p class="text-muted small mb-3">
                Bạn có chắc chắn muốn xóa bài thi <strong id="deleteQuizTitle" class="text-dark"></strong>? 
                Mọi thiết lập gán câu hỏi trong bài này sẽ bị gỡ bỏ.
            </p>
            <div class="d-flex justify-content-center gap-2">
                <button type="button" class="btn btn-outline-secondary rounded-pill px-3" data-bs-dismiss="modal">Hủy</button>
                <a href="#" id="confirmDeleteLink" class="btn btn-danger rounded-pill px-3 fw-semibold">
                    <i class="bi bi-trash3 me-1"></i>Xác nhận xóa
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    // Khởi tạo Bootstrap Modals
    let quizModalInstance = null;
    let deleteModalInstance = null;

    document.addEventListener('DOMContentLoaded', function () {
        const quizModalEl = document.getElementById('quizModal');
        if (quizModalEl) {
            quizModalInstance = new bootstrap.Modal(quizModalEl);
        }
        const deleteModalEl = document.getElementById('deleteConfirmModal');
        if (deleteModalEl) {
            deleteModalInstance = new bootstrap.Modal(deleteModalEl);
        }

        // Tự động cuộn đến module được chọn (nếu có)
        const hash = window.location.hash;
        if (hash) {
            const targetEl = document.querySelector(hash);
            if (targetEl) {
                targetEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
                targetEl.classList.add('target-highlight');
            }
        }

        // Đăng ký tương tác tìm kiếm realtime
        initLiveSearch();

        // Đăng ký bộ lọc module
        initModuleFilter();

        // Đăng ký nút mở rộng / thu gọn tất cả
        initToggleAll();

        // Ngăn chặn submit form nhiều lần (Double-submission prevention)
        const quizForm = document.getElementById('quizForm');
        if (quizForm) {
            quizForm.addEventListener('submit', function () {
                const submitBtn = document.getElementById('submitQuizBtn');
                const spinner = document.getElementById('submitSpinner');
                const icon = document.getElementById('submitIcon');
                if (submitBtn && spinner && icon) {
                    submitBtn.disabled = true;
                    spinner.classList.remove('d-none');
                    icon.classList.add('d-none');
                }
            });
        }
    });

    // Mở modal tạo Quiz mới
    function openCreateQuizModal(moduleId) {
        document.getElementById('modalQuizId').value = '';
        document.getElementById('quizModalLabel').textContent = 'Tạo bài kiểm tra mới (Quiz)';
        document.getElementById('modalSubTitle').textContent = 'Thiết lập cấu hình làm bài và chuẩn điểm đạt';
        document.getElementById('modalHeaderIcon').className = 'bi bi-patch-question-fill fs-5';
        document.getElementById('submitBtnText').textContent = 'Lưu bài thi';

        // Đặt lại các trường về mặc định
        document.getElementById('modalQuizTitle').value = '';
        document.getElementById('modalQuizPassScore').value = '50';
        document.getElementById('modalQuizTimeLimit').value = '15';
        document.getElementById('modalQuizOrderIndex').value = '1';

        if (moduleId) {
            const select = document.getElementById('modalModuleSelect');
            if (select) {
                select.value = moduleId;
            }
        }

        if (quizModalInstance) {
            quizModalInstance.show();
        }
    }

    // Mở modal sửa thông tin Quiz nhanh
    function openEditQuizModal(id, moduleId, title, passScore, timeLimit, orderIndex) {
        document.getElementById('modalQuizId').value = id;
        document.getElementById('quizModalLabel').textContent = 'Cập nhật thông tin bài Quiz';
        document.getElementById('modalSubTitle').textContent = 'Mã bài thi: #' + id;
        document.getElementById('modalHeaderIcon').className = 'bi bi-pencil-square fs-5';
        document.getElementById('submitBtnText').textContent = 'Cập nhật bài thi';

        document.getElementById('modalQuizTitle').value = title || '';
        document.getElementById('modalQuizPassScore').value = passScore || '50';
        document.getElementById('modalQuizTimeLimit').value = timeLimit || '';
        document.getElementById('modalQuizOrderIndex').value = orderIndex || '1';

        if (moduleId) {
            const select = document.getElementById('modalModuleSelect');
            if (select) {
                select.value = moduleId;
            }
        }

        if (quizModalInstance) {
            quizModalInstance.show();
        }
    }

    // Mở modal xác nhận xóa Quiz
    function openDeleteQuizModal(id, title, courseId, moduleId) {
        const titleEl = document.getElementById('deleteQuizTitle');
        if (titleEl) {
            titleEl.textContent = '"' + title + '"';
        }

        const link = document.getElementById('confirmDeleteLink');
        if (link) {
            let deleteUrl = '${pageContext.request.contextPath}/quizzes/delete?id=' + id;
            if (courseId) {
                deleteUrl += '&courseId=' + courseId;
            }
            if (moduleId) {
                deleteUrl += '&moduleId=' + moduleId;
            }
            link.href = deleteUrl;
        }

        if (deleteModalInstance) {
            deleteModalInstance.show();
        }
    }

    // Thiết lập điểm nhanh qua preset pills
    function setPresetScore(val) {
        const input = document.getElementById('modalQuizPassScore');
        if (input) {
            input.value = val;
        }
    }

    // Thiết lập thời gian nhanh qua preset pills
    function setPresetTime(val) {
        const input = document.getElementById('modalQuizTimeLimit');
        if (input) {
            input.value = val;
        }
    }

    // Khởi tạo Live Search Vanilla JS
    function initLiveSearch() {
        const searchInput = document.getElementById('quizSearchInput');
        const clearBtn = document.getElementById('clearSearchBtn');
        if (!searchInput) return;

        searchInput.addEventListener('input', function () {
            const query = this.value.trim().toLowerCase();
            if (clearBtn) {
                clearBtn.classList.toggle('d-none', query === '');
            }
            filterQuizzes();
        });

        if (clearBtn) {
            clearBtn.addEventListener('click', function () {
                searchInput.value = '';
                clearBtn.classList.add('d-none');
                filterQuizzes();
                searchInput.focus();
            });
        }
    }

    // Khởi tạo lọc theo Module
    function initModuleFilter() {
        const moduleSelect = document.getElementById('moduleFilterSelect');
        if (!moduleSelect) return;

        moduleSelect.addEventListener('change', function () {
            filterQuizzes();
        });
    }

    // Logic lọc tổng hợp (Search query + Module filter)
    function filterQuizzes() {
        const searchInput = document.getElementById('quizSearchInput');
        const moduleSelect = document.getElementById('moduleFilterSelect');
        const noResultsAlert = document.getElementById('noSearchResultsAlert');
        const visibleQuizCountSpan = document.getElementById('visibleQuizCount');

        const query = searchInput ? searchInput.value.trim().toLowerCase() : '';
        const selectedModule = moduleSelect ? moduleSelect.value : 'all';

        const moduleWrappers = document.querySelectorAll('.module-wrapper');
        let totalVisibleQuizzes = 0;

        moduleWrappers.forEach(function (wrapper) {
            const modId = wrapper.getAttribute('data-module-id');
            const isModuleMatch = (selectedModule === 'all' || selectedModule === modId);

            if (!isModuleMatch) {
                wrapper.classList.add('d-none');
                return;
            }

            const rows = wrapper.querySelectorAll('.quiz-row');
            let visibleInModule = 0;

            if (rows.length === 0) {
                // Chương này vốn không có quiz nào
                wrapper.classList.toggle('d-none', query !== '');
            } else {
                rows.forEach(function (row) {
                    const title = row.getAttribute('data-quiz-title') || '';
                    const isTextMatch = (query === '' || title.includes(query));

                    if (isTextMatch) {
                        row.classList.remove('d-none');
                        visibleInModule++;
                        totalVisibleQuizzes++;
                    } else {
                        row.classList.add('d-none');
                    }
                });

                // Nếu đang tìm kiếm và chương không có kết quả nào, ẩn module
                if (query !== '' && visibleInModule === 0) {
                    wrapper.classList.add('d-none');
                } else {
                    wrapper.classList.remove('d-none');
                }
            }
        });

        if (visibleQuizCountSpan) {
            visibleQuizCountSpan.textContent = totalVisibleQuizzes;
        }

        if (noResultsAlert) {
            noResultsAlert.classList.toggle('d-none', totalVisibleQuizzes > 0 || (query === '' && selectedModule === 'all'));
        }
    }

    // Xóa bộ lọc tìm kiếm
    function resetSearchFilter() {
        const searchInput = document.getElementById('quizSearchInput');
        const clearBtn = document.getElementById('clearSearchBtn');
        const moduleSelect = document.getElementById('moduleFilterSelect');

        if (searchInput) searchInput.value = '';
        if (clearBtn) clearBtn.classList.add('d-none');
        if (moduleSelect) moduleSelect.value = 'all';

        filterQuizzes();
    }

    // Mở rộng / Thu gọn tất cả chương
    function initToggleAll() {
        const toggleBtn = document.getElementById('toggleAllBtn');
        const toggleText = document.getElementById('toggleAllText');
        if (!toggleBtn) return;

        let allExpanded = true;

        toggleBtn.addEventListener('click', function () {
            allExpanded = !allExpanded;
            const collapses = document.querySelectorAll('.module-card .collapse');
            collapses.forEach(function (collapseEl) {
                const bsCollapse = bootstrap.Collapse.getOrCreateInstance(collapseEl, { toggle: false });
                if (allExpanded) {
                    bsCollapse.show();
                } else {
                    bsCollapse.hide();
                }
            });

            if (toggleText) {
                toggleText.textContent = allExpanded ? 'Thu gọn tất cả' : 'Mở rộng tất cả';
            }
        });
    }
</script>

<jsp:include page="../common/footer.jsp" />
