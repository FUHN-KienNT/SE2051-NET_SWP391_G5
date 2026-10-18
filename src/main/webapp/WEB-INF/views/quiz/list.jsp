<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

                <c:set var="pageTitle"
                    value="Quản lý Quiz & Ngân hàng câu hỏi - ${not empty course ? course.title : 'Courson LMS'}" />
                <jsp:include page="../common/header.jsp" />
                <jsp:include page="../common/navbar.jsp" />

                <style>
                    /* Courson Brand Colors & Utilities */
                    .text-orange {
                        color: var(--primary-color, #F38020) !important;
                    }

                    .bg-orange-subtle {
                        background-color: var(--cf-orange-light, #FFF5EB) !important;
                        color: var(--primary-color, #F38020) !important;
                    }

                    .border-orange-subtle {
                        border-color: var(--cf-orange-border, #FCD5B5) !important;
                    }

                    .hover-primary:hover {
                        color: var(--primary-color, #F38020) !important;
                    }

                    /* Compact & Clean Metric Summary Cards */
                    .metric-summary-card {
                        background: #ffffff;
                        border: 1px solid #e2e8f0;
                        border-radius: 0.75rem;
                        padding: 0.875rem 1.15rem;
                        transition: transform 0.15s ease, box-shadow 0.15s ease;
                    }

                    .metric-summary-card:hover {
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                    }

                    .metric-icon-box {
                        width: 38px;
                        height: 38px;
                        border-radius: 10px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.15rem;
                    }

                    /* Udemy-Style Connected Curriculum Accordion */
                    .udemy-curriculum-container {
                        border: 1px solid #e2e8f0;
                        border-radius: 0.75rem;
                        overflow: hidden;
                        background: #ffffff;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
                    }

                    .udemy-section-item {
                        border-bottom: 1px solid #e2e8f0;
                        transition: background-color 0.15s ease;
                    }

                    .udemy-section-item:last-child {
                        border-bottom: none;
                    }

                    .udemy-section-header {
                        background-color: #f8fafc;
                        padding: 0.85rem 1.25rem;
                        cursor: pointer;
                        user-select: none;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        gap: 0.75rem;
                        transition: background-color 0.15s ease;
                    }

                    .udemy-section-header:hover {
                        background-color: #f1f5f9;
                    }

                    .udemy-chevron {
                        font-size: 0.85rem;
                        color: #64748b;
                        transition: transform 0.2s ease;
                        display: inline-block;
                        flex-shrink: 0;
                    }

                    .udemy-section-header.collapsed .udemy-chevron {
                        transform: rotate(-90deg);
                    }

                    .udemy-section-body {
                        background-color: #ffffff;
                    }

                    /* Pure Text Toggle (Collapse All / Expand All - Không viền, không box) */
                    .btn-text-toggle {
                        background: none !important;
                        border: none !important;
                        padding: 0 !important;
                        font-size: 0.85rem;
                        font-weight: 600;
                        color: #475569;
                        cursor: pointer;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.35rem;
                        transition: color 0.15s ease;
                    }

                    .btn-text-toggle:hover {
                        color: var(--primary-color, #F38020) !important;
                        text-decoration: underline;
                    }

                    .curriculum-meta-bar {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        margin-bottom: 0.75rem;
                        padding: 0 0.25rem;
                    }

                    /* Clean, Breathable Tables */
                    .clean-table th {
                        font-size: 0.75rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.04em;
                        color: #64748b;
                        background-color: #f8fafc;
                        border-bottom: 1px solid #e2e8f0;
                        padding: 0.65rem 1rem;
                    }

                    .clean-table td {
                        padding: 0.75rem 1rem;
                        vertical-align: middle;
                        border-bottom: 1px solid #f1f5f9;
                        font-size: 0.875rem;
                    }

                    .clean-table tbody tr:hover {
                        background-color: #fafbfd;
                    }

                    /* Modern Clean Tabs */
                    .nav-tabs-clean .nav-link {
                        color: #64748b;
                        font-weight: 600;
                        border: none;
                        border-bottom: 2px solid transparent;
                        padding: 0.65rem 1.25rem;
                        background: transparent;
                        transition: all 0.15s ease;
                    }

                    .nav-tabs-clean .nav-link:hover {
                        color: var(--primary-color, #F38020);
                    }

                    .nav-tabs-clean .nav-link.active {
                        color: var(--primary-color, #F38020);
                        border-bottom: 2px solid var(--primary-color, #F38020);
                        background: transparent;
                    }

                    /* Question Bank Snippet & Options Preview */
                    .correct-answer-snippet {
                        font-size: 0.775rem;
                        color: #059669;
                        background: #ecfdf5;
                        border: 1px solid #d1fae5;
                        border-radius: 6px;
                        padding: 0.2rem 0.5rem;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.35rem;
                        max-width: 100%;
                    }

                    .module-filter-btn.active {
                        background-color: var(--primary-color, #F38020) !important;
                        border-color: var(--primary-color, #F38020) !important;
                        color: #ffffff !important;
                    }

                    .btn-xs {
                        font-size: 0.75rem;
                        padding: 0.2rem 0.5rem;
                        border-radius: 0.375rem;
                    }
                </style>

                <main class="main-content py-4">
                    <div class="container">

                        <!-- Breadcrumb Navigation Tinh gọn -->
                        <nav class="mb-3" aria-label="breadcrumb">
                            <ol class="breadcrumb py-1 px-0 mb-0 small">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/expert/dashboard"
                                        class="text-decoration-none text-muted">
                                        <i class="bi bi-speedometer2 me-1"></i>Expert Dashboard
                                    </a>
                                </li>
                                <c:if test="${not empty course}">
                                    <li class="breadcrumb-item">
                                        <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}"
                                            class="text-decoration-none text-muted">
                                            ${course.title}
                                        </a>
                                    </li>
                                </c:if>
                                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">
                                    Quản lý Quiz & Ngân hàng câu hỏi
                                </li>
                            </ol>
                        </nav>

                        <!-- System Alerts Tinh gọn -->
                        <c:if test="${not empty param.success}">
                            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 rounded-3 mb-3 d-flex align-items-center gap-2"
                                role="alert">
                                <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                                <div class="flex-grow-1 small">
                                    <c:choose>
                                        <c:when test="${param.success == 'deleted'}">Đã xóa bài kiểm tra thành công.
                                        </c:when>
                                        <c:when test="${param.success == 'saved'}">Đã lưu thông tin cấu hình bài kiểm
                                            tra thành công.</c:when>
                                        <c:when test="${param.success == 'question_saved'}">Đã lưu câu hỏi vào ngân hàng
                                            thành công!</c:when>
                                        <c:when test="${param.success == 'question_deleted'}">Đã xóa câu hỏi khỏi ngân
                                            hàng thành công!</c:when>
                                        <c:otherwise>Thao tác đã được hoàn tất thành công.</c:otherwise>
                                    </c:choose>
                                </div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 rounded-3 mb-3 d-flex align-items-center gap-2"
                                role="alert">
                                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                                <div class="flex-grow-1 small">
                                    <c:out value="${param.error}" />
                                </div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Header Top Bar Tinh gọn -->
                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                            <div>
                                <h3 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                                    <span class="text-orange"><i class="bi bi-patch-question-fill"></i></span>
                                    <span>Quản lý Quiz: ${course.title}</span>
                                </h3>
                                <p class="text-muted small mb-0">
                                    Quản lý bài kiểm tra theo từng chương và kho ngân hàng câu hỏi tập trung của khóa
                                    học
                                </p>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <c:if test="${not empty course}">
                                    <button type="button"
                                        class="btn btn-outline-secondary btn-sm fw-semibold px-3 py-2 rounded-3 shadow-sm bg-white"
                                        data-bs-toggle="modal" data-bs-target="#questionModal"
                                        onclick="openCreateQuestionModal('')">
                                        <i class="bi bi-database-add text-success me-1"></i>Thêm câu hỏi
                                    </button>
                                    <button type="button"
                                        class="btn btn-primary btn-sm fw-semibold px-3 py-2 rounded-3 shadow-sm"
                                        data-bs-toggle="modal" data-bs-target="#quizModal"
                                        onclick="openCreateQuizModal('')">
                                        <i class="bi bi-plus-lg me-1"></i>Tạo bài Quiz mới
                                    </button>
                                </c:if>
                            </div>
                        </div>

                        <!-- 3 Thẻ thống kê tổng quan (Metrics Summary) Tinh gọn & Cân đối -->
                        <c:if test="${not empty course}">
                            <div class="row g-3 mb-4">
                                <div class="col-md-4 col-sm-6 col-12">
                                    <div class="metric-summary-card d-flex align-items-center justify-content-between">
                                        <div>
                                            <span class="text-muted small fw-medium">Tổng số bài Quiz</span>
                                            <h4 class="fw-bold mb-0 text-dark mt-0.5">
                                                ${course.totalQuizzes} <span class="fs-6 fw-normal text-muted">bài
                                                    thi</span>
                                            </h4>
                                        </div>
                                        <div class="metric-icon-box bg-orange-subtle text-orange">
                                            <i class="bi bi-patch-question-fill"></i>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-4 col-sm-6 col-12">
                                    <div class="metric-summary-card d-flex align-items-center justify-content-between">
                                        <div>
                                            <span class="text-muted small fw-medium">Ngân hàng câu hỏi</span>
                                            <h4 class="fw-bold mb-0 text-dark mt-0.5">
                                                ${totalQuestions} <span class="fs-6 fw-normal text-muted">câu hỏi</span>
                                            </h4>
                                        </div>
                                        <div class="metric-icon-box bg-success-subtle text-success">
                                            <i class="bi bi-database-fill-check"></i>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-4 col-sm-12 col-12">
                                    <div class="metric-summary-card d-flex align-items-center justify-content-between">
                                        <div>
                                            <span class="text-muted small fw-medium">Số chương học</span>
                                            <h4 class="fw-bold mb-0 text-dark mt-0.5">
                                                ${course.totalModules} <span
                                                    class="fs-6 fw-normal text-muted">chương</span>
                                            </h4>
                                        </div>
                                        <div class="metric-icon-box bg-light text-secondary">
                                            <i class="bi bi-folder2-open"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- 2 Main Tabs Navigation Đồng bộ -->
                        <ul class="nav nav-tabs nav-tabs-clean border-bottom mb-3" id="assessmentTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="pills-quizzes-tab" data-bs-toggle="tab"
                                    data-bs-target="#pills-quizzes" type="button" role="tab">
                                    <i class="bi bi-collection me-1"></i>Danh sách Quiz
                                    <c:if test="${not empty course}">
                                        <span
                                            class="badge bg-orange-subtle text-orange border border-orange-subtle rounded-pill ms-1.5">
                                            ${course.totalQuizzes}
                                        </span>
                                    </c:if>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="pills-questions-tab" data-bs-toggle="tab"
                                    data-bs-target="#pills-questions" type="button" role="tab">
                                    <i class="bi bi-database me-1"></i>Ngân hàng câu hỏi
                                    <span class="badge bg-secondary-subtle text-secondary border rounded-pill ms-1.5"
                                        id="totalQuestionsBadge">
                                        ${totalQuestions}
                                    </span>
                                </button>
                            </li>
                        </ul>

                        <!-- Tab Content -->
                        <div class="tab-content" id="assessmentTabsContent">

                            <!-- ======================================================= -->
                            <!-- TAB 1: DANH SÁCH BÀI QUIZ THEO TỪNG CHƯƠNG              -->
                            <!-- ======================================================= -->
                            <div class="tab-pane fade show active" id="pills-quizzes" role="tabpanel">
                                <c:choose>
                                    <c:when test="${empty course or empty course.modules}">
                                        <div class="card p-5 text-center border-0 shadow-sm rounded-4 mb-4">
                                            <div class="bg-light text-muted rounded-circle d-inline-flex align-items-center justify-content-center mx-auto mb-3"
                                                style="width: 64px; height: 64px;">
                                                <i class="bi bi-folder-x fs-2"></i>
                                            </div>
                                            <h5 class="fw-bold text-dark mb-1">Khóa học này chưa có chương học nào!</h5>
                                            <p class="text-muted small mb-3">Bạn cần tạo ít nhất một chương học để có
                                                thể thiết lập các bài kiểm tra trắc nghiệm.</p>
                                            <div>
                                                <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${course.id}"
                                                    class="btn btn-primary btn-sm fw-semibold rounded-3 px-3 py-2">
                                                    <i class="bi bi-plus-circle me-1"></i>Tạo chương học ngay
                                                </a>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Thanh công cụ tìm kiếm & lọc Tab 1 (Thiết kế hiện đại, hợp lý) -->
                                        <div class="card border-0 shadow-sm rounded-3 p-2.5 mb-3 bg-white">
                                            <div class="row g-2 align-items-center justify-content-between">
                                                <div class="col-md-7 col-12">
                                                    <div class="input-group input-group-sm">
                                                        <span class="input-group-text bg-light border-end-0 text-muted">
                                                            <i class="bi bi-search"></i>
                                                        </span>
                                                        <input type="text" id="quizSearchInput"
                                                            class="form-control border-start-0 bg-light"
                                                            placeholder="Tìm kiếm bài thi theo tên hoặc chương...">
                                                        <button
                                                            class="btn btn-outline-secondary border-start-0 bg-light text-muted d-none"
                                                            type="button" id="clearQuizSearchBtn">
                                                            <i class="bi bi-x-circle"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div
                                                    class="col-md-5 col-12 d-flex justify-content-md-end align-items-center gap-2">
                                                    <div class="btn-group btn-group-sm w-100 w-md-auto" role="group"
                                                        aria-label="Filter modules">
                                                        <button type="button"
                                                            class="btn btn-outline-secondary active module-filter-btn"
                                                            data-filter="all">
                                                            Tất cả (${course.totalModules})
                                                        </button>
                                                        <button type="button"
                                                            class="btn btn-outline-secondary module-filter-btn"
                                                            data-filter="has-quiz">
                                                            Có Quiz (${course.modulesWithQuizCount})
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Meta bar: Thông tin số lượng & nút text Thu gọn / Mở rộng tất cả (Không box, không viền) -->
                                        <div class="curriculum-meta-bar">
                                            <span class="small text-muted fw-semibold">
                                                <i
                                                    class="bi bi-layers-half text-secondary me-1"></i>${course.totalModules}
                                                chương &bull; ${course.totalQuizzes} bài thi
                                            </span>
                                            <button type="button" class="btn-text-toggle" id="toggleAllQuizBtn"
                                                onclick="toggleAllQuizSections()">
                                                <i class="bi bi-arrows-collapse me-1"></i><span>Thu gọn tất cả</span>
                                            </button>
                                        </div>

                                        <!-- Thông báo khi filter không tìm thấy quiz nào -->
                                        <div id="quizTabNoResult"
                                            class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white d-none mb-3">
                                            <div class="text-muted mb-2"><i class="bi bi-search fs-2"></i></div>
                                            <h6 class="fw-bold text-dark mb-1">Không tìm thấy bài Quiz nào phù hợp</h6>
                                            <p class="small text-muted mb-0">Thử tìm kiếm với từ khóa khác hoặc chọn
                                                "Tất cả".</p>
                                        </div>

                                        <!-- Danh sách Modules & Quizzes liền mạch dạng Udemy Accordion -->
                                        <div class="udemy-curriculum-container mb-4" id="quizCurriculumContainer">
                                            <c:forEach var="m" items="${course.modules}">
                                                <c:set var="mHasQuizzes" value="${m.hasQuizzes}" />
                                                <div class="udemy-section-item" id="module-${m.id}"
                                                    data-has-quizzes="${mHasQuizzes ? 'true' : 'false'}"
                                                    data-module-title="${fn:toLowerCase(m.title)}">

                                                    <!-- Header: Click để toggle collapse -->
                                                    <div class="udemy-section-header" data-bs-toggle="collapse"
                                                        data-bs-target="#quiz-collapse-${m.id}" aria-expanded="true">
                                                        <div
                                                            class="d-flex align-items-center gap-2 flex-grow-1 overflow-hidden">
                                                            <i class="bi bi-chevron-down udemy-chevron"></i>
                                                            <span
                                                                class="badge bg-white text-dark border fw-semibold flex-shrink-0">
                                                                Chương ${m.orderIndex}
                                                            </span>
                                                            <span
                                                                class="fw-bold text-dark text-truncate">${m.title}</span>
                                                            <c:choose>
                                                                <c:when test="${mHasQuizzes}">
                                                                    <span
                                                                        class="badge bg-orange-subtle text-orange border border-orange-subtle ms-1 flex-shrink-0">
                                                                        ${m.quizCount} bài quiz
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        class="badge bg-light text-muted border ms-1 flex-shrink-0">
                                                                        0 bài quiz
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>

                                                        <!-- Nút tạo quiz tinh gọn (stopPropagation để không trigger đóng/mở) -->
                                                        <div class="flex-shrink-0" onclick="event.stopPropagation();">
                                                            <button type="button"
                                                                class="btn btn-sm btn-outline-primary rounded-3 py-1 px-2.5 small fw-semibold"
                                                                onclick="openCreateQuizModal('${m.id}', '${m.quizCount + 1}')"
                                                                data-bs-toggle="modal" data-bs-target="#quizModal">
                                                                <i class="bi bi-plus-lg me-1"></i>Tạo Quiz
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <!-- Body: Collapsible -->
                                                    <div class="collapse show udemy-section-body"
                                                        id="quiz-collapse-${m.id}">
                                                        <c:choose>
                                                            <c:when test="${not mHasQuizzes}">
                                                                <div
                                                                    class="py-2.5 px-4 bg-light-subtle d-flex align-items-center justify-content-between text-muted small">
                                                                    <span
                                                                        class="d-flex align-items-center gap-1.5 text-secondary">
                                                                        <i class="bi bi-info-circle text-muted"></i>
                                                                        Chưa có bài kiểm tra nào trong chương này
                                                                    </span>
                                                                    <button type="button"
                                                                        class="btn btn-sm btn-link text-primary text-decoration-none fw-semibold p-0"
                                                                        onclick="openCreateQuizModal('${m.id}', 1)">
                                                                        + Tạo bài Quiz ngay
                                                                    </button>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="table-responsive bg-white">
                                                                    <table class="table clean-table mb-0 align-middle">
                                                                        <thead>
                                                                            <tr>
                                                                                <th style="width: 70px;"
                                                                                    class="text-center">TT</th>
                                                                                <th>Tên bài thi (Quiz)</th>
                                                                                <th style="width: 130px;"
                                                                                    class="text-center">Điểm đạt</th>
                                                                                <th style="width: 140px;"
                                                                                    class="text-center">Thời lượng</th>
                                                                                <th style="width: 190px;"
                                                                                    class="text-end pe-3">Hành động</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <c:forEach var="q" items="${m.quizzes}">
                                                                                <tr class="quiz-row"
                                                                                    data-quiz-title="${fn:toLowerCase(q.title)}">
                                                                                    <td class="text-center">
                                                                                        <span
                                                                                            class="badge bg-light text-muted border">#${q.orderIndex}</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div>
                                                                                            <a href="${pageContext.request.contextPath}/quizzes/detail?id=${q.id}&courseId=${course.id}"
                                                                                                class="fw-bold text-dark text-decoration-none hover-primary">
                                                                                                ${q.title}
                                                                                            </a>
                                                                                            <span
                                                                                                class="small text-muted d-block"
                                                                                                style="font-size: 0.75rem;">
                                                                                                Mã đề: #${q.id}
                                                                                            </span>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td class="text-center">
                                                                                        <span
                                                                                            class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 fw-semibold">
                                                                                            <i
                                                                                                class="bi bi-shield-check me-1"></i>${q.passScore}%
                                                                                        </span>
                                                                                    </td>
                                                                                    <td class="text-center">
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${q.timeLimitMinutes != null and q.timeLimitMinutes > 0}">
                                                                                                <span
                                                                                                    class="badge bg-light text-dark border px-2 py-1">
                                                                                                    <i
                                                                                                        class="bi bi-stopwatch text-orange me-1"></i>${q.timeLimitMinutes}
                                                                                                    phút
                                                                                                </span>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="badge bg-light text-muted border px-2 py-1">Tự
                                                                                                    do</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td class="text-end pe-3">
                                                                                        <div
                                                                                            class="d-inline-flex align-items-center gap-1">
                                                                                            <button type="button"
                                                                                                class="btn btn-sm btn-outline-secondary py-1 px-2 rounded-3"
                                                                                                onclick="openEditQuizModal('${q.id}', '${m.id}', '${fn:escapeXml(q.title)}', '${q.passScore}', '${q.timeLimitMinutes}', '${q.orderIndex}')"
                                                                                                data-bs-toggle="modal"
                                                                                                data-bs-target="#quizModal"
                                                                                                title="Sửa thông tin">
                                                                                                <i
                                                                                                    class="bi bi-gear"></i>
                                                                                            </button>
                                                                                            <button type="button"
                                                                                                class="btn btn-sm btn-outline-danger py-1 px-2 rounded-3"
                                                                                                onclick="openDeleteQuizModal('${q.id}', '${fn:escapeXml(q.title)}', '${course.id}', '${m.id}')"
                                                                                                data-bs-toggle="modal"
                                                                                                data-bs-target="#deleteQuizModal"
                                                                                                title="Xóa bài Quiz">
                                                                                                <i
                                                                                                    class="bi bi-trash3"></i>
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
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- ======================================================= -->
                            <!-- TAB 2: NGÂN HÀNG CÂU HỎI (HIỂN THỊ THEO CHƯƠNG)          -->
                            <!-- ======================================================= -->
                            <div class="tab-pane fade" id="pills-questions" role="tabpanel">
                                <c:choose>
                                    <c:when test="${empty course or empty course.modules}">
                                        <div class="card p-5 text-center border-0 shadow-sm rounded-4 mb-4">
                                            <div class="bg-light text-muted rounded-circle d-inline-flex align-items-center justify-content-center mx-auto mb-3"
                                                style="width: 64px; height: 64px;">
                                                <i class="bi bi-folder-x fs-2"></i>
                                            </div>
                                            <h5 class="fw-bold text-dark mb-1">Khóa học này chưa có chương học nào!</h5>
                                            <p class="text-muted small mb-0">Bạn cần tạo ít nhất một chương học để quản
                                                lý ngân hàng câu hỏi.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Toolbar lọc & tìm kiếm câu hỏi Tab 2 (Thiết kế hiện đại) -->
                                        <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                            <div class="row g-2 align-items-center justify-content-between">
                                                <div class="col-md-5 col-12">
                                                    <div class="input-group input-group-sm">
                                                        <span class="input-group-text bg-light border-end-0 text-muted">
                                                            <i class="bi bi-search"></i>
                                                        </span>
                                                        <input type="text" id="questionSearchInput"
                                                            class="form-control border-start-0 bg-light"
                                                            placeholder="Tìm kiếm nội dung câu hỏi...">
                                                        <button
                                                            class="btn btn-outline-secondary border-start-0 bg-light text-muted d-none"
                                                            type="button" id="clearQuestionSearchBtn">
                                                            <i class="bi bi-x-circle"></i>
                                                        </button>
                                                    </div>
                                                </div>

                                                <div class="col-md-3 col-sm-6 col-12">
                                                    <select id="questionModuleFilter"
                                                        class="form-select form-select-sm bg-light">
                                                        <option value="all">Tất cả chương học</option>
                                                        <c:forEach var="moduleItem" items="${course.modules}">
                                                            <option value="${moduleItem.id}">Chương
                                                                ${moduleItem.orderIndex}: ${moduleItem.title}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <div class="col-md-2 col-sm-6 col-12">
                                                    <select id="questionTypeFilter"
                                                        class="form-select form-select-sm bg-light">
                                                        <option value="all">Tất cả loại câu</option>
                                                        <option value="SINGLE_CHOICE">Trắc nghiệm</option>
                                                        <option value="TRUE_FALSE">Đúng / Sai</option>
                                                    </select>
                                                </div>

                                                <div class="col-md-2 col-12 text-md-end d-flex justify-content-md-end">
                                                    <button type="button"
                                                        class="btn btn-success btn-sm fw-semibold shadow-sm rounded-3 px-3 py-1.5 w-100 w-md-auto"
                                                        onclick="openCreateQuestionModal('')" data-bs-toggle="modal"
                                                        data-bs-target="#questionModal">
                                                        <i class="bi bi-plus-lg me-1"></i>Thêm câu hỏi
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Meta bar Tab 2: Thông tin số lượng & nút text Thu gọn / Mở rộng tất cả (Không box, không viền) -->
                                        <div class="curriculum-meta-bar">
                                            <span class="small text-muted fw-semibold">
                                                <i
                                                    class="bi bi-layers-half text-secondary me-1"></i>${course.totalModules}
                                                chương &bull; Hiển thị <strong id="questionVisibleCount"
                                                    class="text-dark">${totalQuestions}</strong> / ${totalQuestions} câu
                                                hỏi
                                            </span>
                                            <button type="button" class="btn-text-toggle" id="toggleAllQuestionBtn"
                                                onclick="toggleAllQuestionSections()">
                                                <i class="bi bi-arrows-collapse me-1"></i><span>Thu gọn tất cả</span>
                                            </button>
                                        </div>

                                        <!-- Thông báo khi filter không tìm thấy câu hỏi nào -->
                                        <div id="questionEmptyFilter"
                                            class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white d-none mb-3">
                                            <div class="text-muted mb-2"><i class="bi bi-funnel fs-2"></i></div>
                                            <h6 class="fw-bold text-dark mb-1">Không tìm thấy câu hỏi nào phù hợp</h6>
                                            <p class="small text-muted mb-0">Thử thay đổi từ khóa tìm kiếm hoặc chọn lại
                                                các bộ lọc.</p>
                                        </div>

                                        <!-- Danh sách câu hỏi theo từng chương dạng Udemy Accordion liền mạch -->
                                        <div class="udemy-curriculum-container mb-4" id="questionCurriculumContainer">
                                            <c:forEach var="m" items="${course.modules}">
                                                <c:set var="mHasQuestions" value="${m.hasQuestions}" />
                                                <div class="udemy-section-item question-module-section"
                                                    id="q-module-${m.id}" data-module-id="${m.id}"
                                                    data-has-questions="${mHasQuestions ? 'true' : 'false'}"
                                                    data-module-title="${fn:toLowerCase(m.title)}">

                                                    <!-- Header Chương: Click để đóng/mở -->
                                                    <div class="udemy-section-header" data-bs-toggle="collapse"
                                                        data-bs-target="#q-collapse-${m.id}" aria-expanded="true">
                                                        <div
                                                            class="d-flex align-items-center gap-2 flex-grow-1 overflow-hidden">
                                                            <i class="bi bi-chevron-down udemy-chevron"></i>
                                                            <span
                                                                class="badge bg-white text-dark border fw-semibold flex-shrink-0">
                                                                Chương ${m.orderIndex}
                                                            </span>
                                                            <span
                                                                class="fw-bold text-dark text-truncate">${m.title}</span>
                                                            <c:choose>
                                                                <c:when test="${mHasQuestions}">
                                                                    <span
                                                                        class="badge bg-success-subtle text-success border border-success-subtle ms-1 flex-shrink-0">
                                                                        ${m.questionCount} câu hỏi
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        class="badge bg-light text-muted border ms-1 flex-shrink-0">
                                                                        0 câu hỏi
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>

                                                        <!-- Nút thêm câu hỏi cho chương này (stopPropagation để không trigger đóng/mở accordion) -->
                                                        <div class="flex-shrink-0" onclick="event.stopPropagation();">
                                                            <button type="button"
                                                                class="btn btn-sm btn-outline-success rounded-3 py-1 px-2.5 small fw-semibold"
                                                                onclick="openCreateQuestionModal('${m.id}')"
                                                                data-bs-toggle="modal" data-bs-target="#questionModal">
                                                                <i class="bi bi-plus-lg me-1"></i>Thêm câu hỏi
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <!-- Body Chương: Danh sách câu hỏi -->
                                                    <div class="collapse show udemy-section-body"
                                                        id="q-collapse-${m.id}">
                                                        <c:choose>
                                                            <c:when test="${not mHasQuestions}">
                                                                <div
                                                                    class="py-3 px-4 bg-light-subtle d-flex align-items-center justify-content-between text-muted small">
                                                                    <span
                                                                        class="d-flex align-items-center gap-1.5 text-secondary">
                                                                        <i class="bi bi-info-circle text-muted"></i>
                                                                        Chưa có câu hỏi nào trong chương này
                                                                    </span>
                                                                    <button type="button"
                                                                        class="btn btn-sm btn-link text-success text-decoration-none fw-semibold p-0"
                                                                        onclick="openCreateQuestionModal('${m.id}')">
                                                                        + Thêm câu hỏi ngay
                                                                    </button>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="table-responsive bg-white">
                                                                    <table class="table clean-table mb-0 align-middle">
                                                                        <thead>
                                                                            <tr>
                                                                                <th style="width: 65px;"
                                                                                    class="text-center">ID</th>
                                                                                <th>Nội dung câu hỏi &amp; Đáp án đúng
                                                                                </th>
                                                                                <th style="width: 140px;"
                                                                                    class="text-center">Dạng câu</th>
                                                                                <th style="width: 90px;"
                                                                                    class="text-center">Điểm</th>
                                                                                <th style="width: 120px;"
                                                                                    class="text-end pe-3">Hành động</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <c:forEach var="q" items="${m.questions}">
                                                                                <%-- Build options JSON for JS edit modal --%>
                                                                                <c:set var="qOptionsJson" value="[" />
                                                                                <c:forEach var="opt" items="${q.options}" varStatus="os">
                                                                                    <c:set var="escaped" value="${fn:replace(opt.optionText, '\"', '&quot;')}" />
                                                                                    <c:set var="qOptionsJson" value='${qOptionsJson}{"text":"${escaped}","correct":${opt.correct}}' />
                                                                                    <c:if test="${!os.last}"><c:set var="qOptionsJson" value="${qOptionsJson}," /></c:if>
                                                                                </c:forEach>
                                                                                <c:set var="qOptionsJson" value="${qOptionsJson}]" />
                                                                                <tr class="question-row"
                                                                                    data-module-id="${q.moduleId}"
                                                                                    data-type="${q.questionType}"
                                                                                    data-text="${fn:toLowerCase(q.questionText)}"
                                                                                    data-q-id="${q.id}"
                                                                                    data-q-points="${q.defaultPoints}"
                                                                                    data-q-text="${q.questionText}"
                                                                                    data-q-options='${qOptionsJson}'>
                                                                                    <td
                                                                                        class="text-center text-muted small fw-semibold">
                                                                                        #${q.id}
                                                                                    </td>
                                                                                    <td>
                                                                                        <div
                                                                                            class="fw-medium text-dark mb-1">
                                                                                            <c:out
                                                                                                value="${q.questionText}" />
                                                                                        </div>

                                                                                        <!-- Hiển thị đáp án đúng tinh gọn & toggle xem chi tiết options -->
                                                                                        <div
                                                                                            class="d-flex flex-wrap align-items-center gap-2 mt-1">
                                                                                            <c:set var="correctOptText"
                                                                                                value="" />
                                                                                            <c:forEach var="opt"
                                                                                                items="${q.options}">
                                                                                                <c:if
                                                                                                    test="${opt.correct}">
                                                                                                    <c:set
                                                                                                        var="correctOptText"
                                                                                                        value="${opt.optionText}" />
                                                                                                </c:if>
                                                                                            </c:forEach>

                                                                                            <c:if
                                                                                                test="${not empty correctOptText}">
                                                                                                <span
                                                                                                    class="correct-answer-snippet">
                                                                                                    <i
                                                                                                        class="bi bi-check-circle-fill"></i>
                                                                                                    <span>Đáp án đúng:
                                                                                                        <strong>
                                                                                                            <c:out
                                                                                                                value="${correctOptText}" />
                                                                                                        </strong></span>
                                                                                                </span>
                                                                                            </c:if>

                                                                                            <c:if
                                                                                                test="${not empty q.options}">
                                                                                                <button type="button"
                                                                                                    class="btn btn-xs btn-outline-secondary py-0 px-2 rounded-pill"
                                                                                                    data-bs-toggle="collapse"
                                                                                                    data-bs-target="#options-collapse-${q.id}"
                                                                                                    title="Xem danh sách tất cả các phương án">
                                                                                                    <i
                                                                                                        class="bi bi-list-ul me-1"></i>Xem
                                                                                                    ${fn:length(q.options)}
                                                                                                    lựa chọn
                                                                                                </button>
                                                                                            </c:if>
                                                                                        </div>

                                                                                        <!-- Danh sách các lựa chọn có thể mở ra khi bấm -->
                                                                                        <c:if
                                                                                            test="${not empty q.options}">
                                                                                            <div class="collapse mt-2"
                                                                                                id="options-collapse-${q.id}">
                                                                                                <div
                                                                                                    class="p-2.5 rounded-3 bg-light border row g-2 small">
                                                                                                    <c:forEach var="opt"
                                                                                                        items="${q.options}"
                                                                                                        varStatus="optStatus">
                                                                                                        <div
                                                                                                            class="col-md-6 col-12">
                                                                                                            <div
                                                                                                                class="d-flex align-items-start gap-2 p-1.5 rounded-2 ${opt.correct ? 'bg-success-subtle text-success fw-semibold border border-success-subtle' : 'bg-white border text-secondary'}">
                                                                                                                <span
                                                                                                                    class="badge ${opt.correct ? 'bg-success text-white' : 'bg-secondary-subtle text-secondary'} rounded-circle px-1.5 py-1"
                                                                                                                    style="font-size: 0.7rem; width: 20px; height: 20px; display: inline-flex; align-items: center; justify-content: center;">
                                                                                                                    ${optStatus.index
                                                                                                                    == 0
                                                                                                                    ?
                                                                                                                    'A'
                                                                                                                    :
                                                                                                                    (optStatus.index
                                                                                                                    == 1
                                                                                                                    ?
                                                                                                                    'B'
                                                                                                                    :
                                                                                                                    (optStatus.index
                                                                                                                    == 2
                                                                                                                    ?
                                                                                                                    'C'
                                                                                                                    :
                                                                                                                    'D'))}
                                                                                                                </span>
                                                                                                                <span
                                                                                                                    class="text-break">
                                                                                                                    <c:out
                                                                                                                        value="${opt.optionText}" />
                                                                                                                </span>
                                                                                                                <c:if
                                                                                                                    test="${opt.correct}">
                                                                                                                    <i
                                                                                                                        class="bi bi-check2 text-success ms-auto flex-shrink-0"></i>
                                                                                                                </c:if>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </c:forEach>
                                                                                                </div>
                                                                                            </div>
                                                                                        </c:if>
                                                                                    </td>
                                                                                    <td class="text-center">
                                                                                        <span
                                                                                            class="badge bg-light text-secondary border px-2 py-1">
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${q.questionType == 'TRUE_FALSE'}">
                                                                                                    Đúng / Sai
                                                                                                </c:when>
                                                                                                <c:otherwise>Trắc nghiệm
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </span>
                                                                                    </td>
                                                                                    <td
                                                                                        class="text-center fw-semibold text-secondary">
                                                                                        ${q.defaultPoints} đ
                                                                                    </td>
                                                                                    <td
                                                                                        class="text-end pe-3 text-nowrap">
                                                                                        <button type="button"
                                                                                            class="btn btn-sm btn-outline-primary py-1 px-2 rounded-3 me-1"
                                                                                            title="Sửa câu hỏi"
                                                                                            onclick="openEditQuestionModal(this)">
                                                                                            <i class="bi bi-pencil-square"></i>
                                                                                        </button>
                                                                                        <a href="${pageContext.request.contextPath}/quizzes/delete-question?id=${q.id}&courseId=${course.id}"
                                                                                            class="btn btn-sm btn-outline-danger py-1 px-2 rounded-3"
                                                                                            onclick="return confirm('Bạn có chắc chắn muốn xóa câu hỏi này khỏi ngân hàng câu hỏi?');"
                                                                                            title="Xóa câu hỏi">
                                                                                            <i class="bi bi-trash3"></i>
                                                                                        </a>
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
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                        </div>
                    </div>
                </main>

                <!-- ======================================================= -->
                <!-- MODAL: TẠO MỚI & CHỈNH SỬA QUIZ                        -->
                <!-- ======================================================= -->
                <div class="modal fade" id="quizModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                            <form id="quizForm" action="${pageContext.request.contextPath}/quizzes/save" method="POST">
                                <input type="hidden" name="id" id="modalQuizId" value="">
                                <c:if test="${not empty course}">
                                    <input type="hidden" name="courseId" value="${course.id}">
                                </c:if>

                                <div class="modal-header py-3 px-4 bg-light border-bottom">
                                    <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2"
                                        id="quizModalLabel">
                                        <span class="text-orange"><i class="bi bi-patch-question"></i></span>
                                        Tạo bài kiểm tra mới (Quiz)
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>

                                <div class="modal-body p-4">
                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold text-secondary">Thuộc chương học
                                            <span class="text-danger">*</span></label>
                                        <select name="moduleId" id="modalModuleSelect" class="form-select rounded-3"
                                            required>
                                            <c:forEach var="m" items="${course.modules}">
                                                <option value="${m.id}">Chương ${m.orderIndex}: ${m.title}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold text-secondary">Tên bài kiểm tra
                                            <span class="text-danger">*</span></label>
                                        <input type="text" name="title" id="modalQuizTitle"
                                            class="form-control rounded-3" placeholder="Ví dụ: Quiz 1 - Tổng quan..."
                                            required>
                                    </div>

                                    <div class="row g-3 mb-3">
                                        <div class="col-6">
                                            <label class="form-label small fw-semibold text-secondary">Điểm đạt tối
                                                thiểu (%) <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <input type="number" name="passScore" id="modalQuizPassScore"
                                                    class="form-control rounded-start-3" value="50" min="0" max="100"
                                                    required>
                                                <span
                                                    class="input-group-text bg-light text-muted rounded-end-3 fw-bold">%</span>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <label class="form-label small fw-semibold text-secondary">Thời lượng
                                                (Phút)</label>
                                            <div class="input-group">
                                                <input type="number" name="timeLimitMinutes" id="modalQuizTimeLimit"
                                                    class="form-control rounded-start-3" value="15" min="1"
                                                    placeholder="Để trống nếu tự do">
                                                <span
                                                    class="input-group-text bg-light text-muted rounded-end-3">phút</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-2">
                                        <label class="form-label small fw-semibold text-secondary">Thứ tự hiển thị <span
                                                class="text-danger">*</span></label>
                                        <input type="number" name="orderIndex" id="modalQuizOrderIndex"
                                            class="form-control rounded-3" value="1" min="1" required>
                                        <div id="modalQuizOrderHint" class="form-text small text-muted">
                                            Số thứ tự phải không trùng với bài Quiz khác trong cùng chương.
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-footer py-2.5 px-4 bg-light border-top">
                                    <button type="button" class="btn btn-secondary btn-sm fw-semibold rounded-3"
                                        data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit"
                                        class="btn btn-primary btn-sm fw-semibold rounded-3 px-3 shadow-sm"
                                        id="submitQuizBtn">
                                        <i class="bi bi-save me-1"></i>Lưu bài thi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ======================================================= -->
                <!-- MODAL: XÁC NHẬN XÓA QUIZ                                -->
                <!-- ======================================================= -->
                <div class="modal fade" id="deleteQuizModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-sm">
                        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                            <div class="modal-body text-center p-4">
                                <div class="bg-danger-subtle text-danger rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                                    style="width: 56px; height: 56px; font-size: 1.5rem;">
                                    <i class="bi bi-trash3-fill"></i>
                                </div>
                                <h5 class="fw-bold text-dark mb-1">Xác nhận xóa bài thi?</h5>
                                <p class="small text-muted mb-4" id="deleteQuizTitle">
                                    Thao tác này sẽ xóa bài kiểm tra khỏi khóa học. Các câu hỏi trong ngân hàng vẫn được
                                    giữ nguyên.
                                </p>
                                <div class="d-flex justify-content-center gap-2">
                                    <button type="button" class="btn btn-secondary btn-sm fw-semibold rounded-3 px-3"
                                        data-bs-dismiss="modal">Hủy</button>
                                    <a href="#" id="confirmDeleteLink"
                                        class="btn btn-danger btn-sm fw-semibold rounded-3 px-3">
                                        <i class="bi bi-trash3 me-1"></i>Xóa bài thi
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ======================================================= -->
                <!-- MODAL: THÊM CÂU HỎI MỚI VÀO NGÂN HÀNG CỦA KHÓA HỌC       -->
                <!-- ======================================================= -->
                <div class="modal fade" id="questionModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                            <form action="${pageContext.request.contextPath}/quizzes/save-question" method="POST"
                                id="bankQuestionForm">
                                <input type="hidden" name="id" id="modalQId" value="">
                                <c:if test="${not empty course}">
                                    <input type="hidden" name="courseId" value="${course.id}">
                                </c:if>

                                <div class="modal-header py-3 px-4 bg-light border-bottom">
                                    <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2" id="questionModalLabel">
                                        <span id="questionModalIcon" class="text-success"><i class="bi bi-database-add"></i></span>
                                        <span id="questionModalTitle">Tạo câu hỏi mới vào Ngân hàng</span>
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>

                                <div class="modal-body p-4">
                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold text-secondary">Thuộc chương học
                                            <span class="text-danger">*</span></label>
                                        <select name="moduleId" id="modalQModuleSelect" class="form-select rounded-3"
                                            required>
                                            <c:forEach var="m" items="${course.modules}">
                                                <option value="${m.id}">Chương ${m.orderIndex}: ${m.title}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold text-secondary">Nội dung câu hỏi
                                            <span class="text-danger">*</span></label>
                                        <textarea name="questionText" id="modalQText" rows="3"
                                            class="form-control rounded-3" required
                                            placeholder="Nhập nội dung câu hỏi trắc nghiệm ở đây..."></textarea>
                                    </div>

                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold text-secondary">Loại câu
                                                hỏi</label>
                                            <select name="questionType" id="modalQType" class="form-select rounded-3"
                                                onchange="handleModalQTypeChange(this.value)">
                                                <option value="SINGLE_CHOICE" selected>Trắc nghiệm 1 đáp án</option>
                                                <option value="TRUE_FALSE">Đúng / Sai</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold text-secondary">Điểm mặc định
                                                <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <input type="number" step="0.5" min="0.5" name="defaultPoints"
                                                    id="modalQPoints" value="1.0" class="form-control rounded-start-3"
                                                    required>
                                                <span
                                                    class="input-group-text bg-light text-muted rounded-end-3">điểm</span>
                                            </div>
                                        </div>
                                    </div>

                                    <label
                                        class="form-label small fw-semibold text-orange mb-2 d-flex align-items-center gap-1">
                                        <i class="bi bi-ui-radios"></i>
                                        <span>Các phương án trả lời (Tích chọn radio vào đáp án đúng):</span>
                                    </label>

                                    <div id="modalQOptionsContainer">
                                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="modalQOptGroupA">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="0" checked title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">A</span>
                                            <input type="text" name="optionText" id="modalQOptA"
                                                class="form-control border-start-0" placeholder="Đáp án A..." required>
                                        </div>

                                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="modalQOptGroupB">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="1" title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">B</span>
                                            <input type="text" name="optionText" id="modalQOptB"
                                                class="form-control border-start-0" placeholder="Đáp án B..." required>
                                        </div>

                                        <div class="mb-2 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="modalQOptGroupC">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="2" title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">C</span>
                                            <input type="text" name="optionText" id="modalQOptC"
                                                class="form-control border-start-0"
                                                placeholder="Đáp án C (tùy chọn)...">
                                        </div>

                                        <div class="mb-3 input-group shadow-sm rounded-3 overflow-hidden"
                                            id="modalQOptGroupD">
                                            <div class="input-group-text bg-white border-end-0">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption"
                                                    value="3" title="Chọn làm đáp án đúng">
                                            </div>
                                            <span
                                                class="input-group-text bg-light fw-bold text-secondary border-start-0 border-end-0"
                                                style="min-width: 40px; justify-content: center;">D</span>
                                            <input type="text" name="optionText" id="modalQOptD"
                                                class="form-control border-start-0"
                                                placeholder="Đáp án D (tùy chọn)...">
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-footer py-2.5 px-4 bg-light border-top">
                                    <button type="button" class="btn btn-secondary btn-sm fw-semibold rounded-3"
                                        data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" id="questionModalSubmitBtn"
                                        class="btn btn-success btn-sm fw-semibold rounded-3 px-3 shadow-sm">
                                        <i class="bi bi-save me-1"></i><span id="questionModalSubmitText">Lưu vào ngân hàng</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <jsp:include page="../common/footer.jsp" />

                <script>
                    // 1. Toggling functions cho Accordion ở cả 2 Tab (Dạng text thuần túy, không viền, không box)
                    function toggleAllQuizSections() {
                        const container = document.getElementById('quizCurriculumContainer');
                        if (!container) return;
                        const collapses = container.querySelectorAll('.collapse');
                        const btn = document.getElementById('toggleAllQuizBtn');
                        let anyOpen = false;
                        collapses.forEach(c => {
                            if (c.classList.contains('show')) anyOpen = true;
                        });

                        collapses.forEach(c => {
                            const bsCollapse = bootstrap.Collapse.getOrCreateInstance(c, { toggle: false });
                            if (anyOpen) {
                                bsCollapse.hide();
                            } else {
                                bsCollapse.show();
                            }
                        });

                        if (btn) {
                            if (anyOpen) {
                                btn.innerHTML = '<i class="bi bi-arrows-expand me-1"></i><span>Mở rộng tất cả</span>';
                            } else {
                                btn.innerHTML = '<i class="bi bi-arrows-collapse me-1"></i><span>Thu gọn tất cả</span>';
                            }
                        }
                    }

                    function toggleAllQuestionSections() {
                        const container = document.getElementById('questionCurriculumContainer');
                        if (!container) return;
                        const collapses = container.querySelectorAll('.collapse');
                        const btn = document.getElementById('toggleAllQuestionBtn');
                        let anyOpen = false;
                        collapses.forEach(c => {
                            if (c.classList.contains('show')) anyOpen = true;
                        });

                        collapses.forEach(c => {
                            const bsCollapse = bootstrap.Collapse.getOrCreateInstance(c, { toggle: false });
                            if (anyOpen) {
                                bsCollapse.hide();
                            } else {
                                bsCollapse.show();
                            }
                        });

                        if (btn) {
                            if (anyOpen) {
                                btn.innerHTML = '<i class="bi bi-arrows-expand me-1"></i><span>Mở rộng tất cả</span>';
                            } else {
                                btn.innerHTML = '<i class="bi bi-arrows-collapse me-1"></i><span>Thu gọn tất cả</span>';
                            }
                        }
                    }

                    document.addEventListener('DOMContentLoaded', function () {
                        // Kích hoạt tab nếu có query param ?tab=questions
                        const urlParams = new URLSearchParams(window.location.search);
                        if (urlParams.get('tab') === 'questions') {
                            const questionsTabBtn = document.getElementById('pills-questions-tab');
                            if (questionsTabBtn) {
                                bootstrap.Tab.getOrCreateInstance(questionsTabBtn).show();
                            }
                        }

                        // Tự động đồng bộ trạng thái text nút Toggle khi người dùng click mở/đóng từng chương
                        const quizContainer = document.getElementById('quizCurriculumContainer');
                        if (quizContainer) {
                            quizContainer.addEventListener('shown.bs.collapse', syncQuizToggleBtn);
                            quizContainer.addEventListener('hidden.bs.collapse', syncQuizToggleBtn);
                        }
                        function syncQuizToggleBtn() {
                            const btn = document.getElementById('toggleAllQuizBtn');
                            if (!btn || !quizContainer) return;
                            const anyOpen = Array.from(quizContainer.querySelectorAll('.collapse')).some(c => c.classList.contains('show'));
                            btn.innerHTML = anyOpen
                                ? '<i class="bi bi-arrows-collapse me-1"></i><span>Thu gọn tất cả</span>'
                                : '<i class="bi bi-arrows-expand me-1"></i><span>Mở rộng tất cả</span>';
                        }

                        const qContainer = document.getElementById('questionCurriculumContainer');
                        if (qContainer) {
                            qContainer.addEventListener('shown.bs.collapse', syncQuestionToggleBtn);
                            qContainer.addEventListener('hidden.bs.collapse', syncQuestionToggleBtn);
                        }
                        function syncQuestionToggleBtn() {
                            const btn = document.getElementById('toggleAllQuestionBtn');
                            if (!btn || !qContainer) return;
                            const anyOpen = Array.from(qContainer.querySelectorAll('.collapse')).some(c => c.classList.contains('show'));
                            btn.innerHTML = anyOpen
                                ? '<i class="bi bi-arrows-collapse me-1"></i><span>Thu gọn tất cả</span>'
                                : '<i class="bi bi-arrows-expand me-1"></i><span>Mở rộng tất cả</span>';
                        }

                        // 2. Tab 1: Live search & Module filter (All vs Has-Quiz)
                        const quizSearch = document.getElementById('quizSearchInput');
                        const clearQuizBtn = document.getElementById('clearQuizSearchBtn');
                        const moduleFilterBtns = document.querySelectorAll('.module-filter-btn');
                        let currentModuleFilter = 'all';

                        function applyQuizTabFilter() {
                            const kw = quizSearch ? quizSearch.value.trim().toLowerCase() : '';
                            if (clearQuizBtn) {
                                clearQuizBtn.classList.toggle('d-none', kw === '');
                            }
                            const moduleSections = document.querySelectorAll('#quizCurriculumContainer .udemy-section-item');
                            let anyVisible = false;

                            moduleSections.forEach(function (sec) {
                                const hasQuizzes = sec.getAttribute('data-has-quizzes') === 'true';
                                const moduleTitle = sec.getAttribute('data-module-title') || '';

                                if (currentModuleFilter === 'has-quiz' && !hasQuizzes) {
                                    sec.classList.add('d-none');
                                    return;
                                }

                                if (kw === '') {
                                    sec.classList.remove('d-none');
                                    sec.querySelectorAll('.quiz-row').forEach(r => r.classList.remove('d-none'));
                                    anyVisible = true;
                                } else {
                                    let matchInQuizzes = false;
                                    const rows = sec.querySelectorAll('.quiz-row');
                                    rows.forEach(function (row) {
                                        const title = row.getAttribute('data-quiz-title') || '';
                                        if (title.includes(kw)) {
                                            row.classList.remove('d-none');
                                            matchInQuizzes = true;
                                        } else {
                                            row.classList.add('d-none');
                                        }
                                    });

                                    if (matchInQuizzes || moduleTitle.includes(kw)) {
                                        sec.classList.remove('d-none');
                                        if (moduleTitle.includes(kw)) {
                                            rows.forEach(r => r.classList.remove('d-none'));
                                        }
                                        // Tự động mở rộng section khi có kết quả tìm kiếm
                                        const collapseEl = sec.querySelector('.collapse');
                                        if (collapseEl && !collapseEl.classList.contains('show')) {
                                            bootstrap.Collapse.getOrCreateInstance(collapseEl, { toggle: false }).show();
                                        }
                                        anyVisible = true;
                                    } else {
                                        sec.classList.add('d-none');
                                    }
                                }
                            });

                            const noResultEl = document.getElementById('quizTabNoResult');
                            if (noResultEl) {
                                noResultEl.classList.toggle('d-none', anyVisible);
                            }
                        }

                        if (quizSearch) {
                            quizSearch.addEventListener('input', applyQuizTabFilter);
                        }
                        if (clearQuizBtn) {
                            clearQuizBtn.addEventListener('click', function () {
                                quizSearch.value = '';
                                applyQuizTabFilter();
                                quizSearch.focus();
                            });
                        }
                        moduleFilterBtns.forEach(function (btn) {
                            btn.addEventListener('click', function () {
                                moduleFilterBtns.forEach(b => b.classList.remove('active'));
                                this.classList.add('active');
                                currentModuleFilter = this.getAttribute('data-filter');
                                applyQuizTabFilter();
                            });
                        });

                        // 3. Tab 2: Live search, Module filter & Question Type filter
                        const qSearch = document.getElementById('questionSearchInput');
                        const clearQSearchBtn = document.getElementById('clearQuestionSearchBtn');
                        const qModFilter = document.getElementById('questionModuleFilter');
                        const qTypeFilter = document.getElementById('questionTypeFilter');
                        const qVisibleCountEl = document.getElementById('questionVisibleCount');
                        const qEmptyFilterEl = document.getElementById('questionEmptyFilter');

                        function filterQuestions() {
                            const kw = qSearch ? qSearch.value.trim().toLowerCase() : '';
                            if (clearQSearchBtn) {
                                clearQSearchBtn.classList.toggle('d-none', kw === '');
                            }
                            const modId = qModFilter ? qModFilter.value : 'all';
                            const type = qTypeFilter ? qTypeFilter.value : 'all';

                            const moduleSections = document.querySelectorAll('#questionCurriculumContainer .question-module-section');
                            let totalVisibleQuestions = 0;
                            let anySectionVisible = false;

                            moduleSections.forEach(function (sec) {
                                const secModId = sec.getAttribute('data-module-id') || '';
                                const secTitle = sec.getAttribute('data-module-title') || '';

                                // Lọc theo chương nếu chọn trong dropdown
                                if (modId !== 'all' && modId !== secModId) {
                                    sec.classList.add('d-none');
                                    return;
                                }

                                const rows = sec.querySelectorAll('.question-row');
                                let secVisibleQuestions = 0;

                                rows.forEach(function (row) {
                                    const rowText = row.getAttribute('data-text') || '';
                                    const rowType = row.getAttribute('data-type') || '';

                                    const matchKw = (kw === '' || rowText.includes(kw) || secTitle.includes(kw));
                                    const matchType = (type === 'all' || type === rowType);
                                    const visible = matchKw && matchType;

                                    row.classList.toggle('d-none', !visible);
                                    if (visible) {
                                        secVisibleQuestions++;
                                        totalVisibleQuestions++;
                                    }
                                });

                                if (kw === '' && type === 'all') {
                                    sec.classList.remove('d-none');
                                    anySectionVisible = true;
                                } else {
                                    if (secVisibleQuestions > 0) {
                                        sec.classList.remove('d-none');
                                        anySectionVisible = true;
                                        const collapseEl = sec.querySelector('.collapse');
                                        if (collapseEl && !collapseEl.classList.contains('show')) {
                                            bootstrap.Collapse.getOrCreateInstance(collapseEl, { toggle: false }).show();
                                        }
                                    } else {
                                        sec.classList.add('d-none');
                                    }
                                }
                            });

                            if (qVisibleCountEl) qVisibleCountEl.textContent = totalVisibleQuestions;
                            if (qEmptyFilterEl && qContainer) {
                                if (!anySectionVisible) {
                                    qEmptyFilterEl.classList.remove('d-none');
                                    qContainer.classList.add('d-none');
                                } else {
                                    qEmptyFilterEl.classList.add('d-none');
                                    qContainer.classList.remove('d-none');
                                }
                            }
                        }

                        if (qSearch) qSearch.addEventListener('input', filterQuestions);
                        if (clearQSearchBtn) {
                            clearQSearchBtn.addEventListener('click', function () {
                                qSearch.value = '';
                                filterQuestions();
                                qSearch.focus();
                            });
                        }
                        if (qModFilter) qModFilter.addEventListener('change', filterQuestions);
                        if (qTypeFilter) qTypeFilter.addEventListener('change', filterQuestions);
                    });

                    // 4. Xử lý đổi dạng câu hỏi modal tạo câu hỏi
                    function handleModalQTypeChange(type) {
                        const optC = document.getElementById('modalQOptGroupC');
                        const optD = document.getElementById('modalQOptGroupD');
                        const textA = document.getElementById('modalQOptA');
                        const textB = document.getElementById('modalQOptB');

                        if (type === 'TRUE_FALSE') {
                            if (optC) optC.style.display = 'none';
                            if (optD) optD.style.display = 'none';
                            if (textA) textA.value = 'Đúng (True)';
                            if (textB) textB.value = 'Sai (False)';
                        } else {
                            if (optC) optC.style.display = 'flex';
                            if (optD) optD.style.display = 'flex';
                            if (textA && textA.value === 'Đúng (True)') textA.value = '';
                            if (textB && textB.value === 'Sai (False)') textB.value = '';
                        }
                    }

                    // 5. Modal Quản lý Quiz
                    function openCreateQuizModal(moduleId, suggestedOrder) {
                        const idInput = document.getElementById('modalQuizId');
                        if (idInput) idInput.value = '';
                        const titleLabel = document.getElementById('quizModalLabel');
                        if (titleLabel) titleLabel.innerHTML = '<span class="text-orange"><i class="bi bi-patch-question"></i></span> Tạo bài kiểm tra mới (Quiz)';
                        const titleInput = document.getElementById('modalQuizTitle');
                        if (titleInput) titleInput.value = '';
                        const passScoreInput = document.getElementById('modalQuizPassScore');
                        if (passScoreInput) passScoreInput.value = '50';
                        const timeLimitInput = document.getElementById('modalQuizTimeLimit');
                        if (timeLimitInput) timeLimitInput.value = '15';
                        const orderInput = document.getElementById('modalQuizOrderIndex');
                        if (orderInput) orderInput.value = (suggestedOrder && suggestedOrder > 0) ? suggestedOrder : '1';
                        // Cập nhật hint text STT
                        const orderHint = document.getElementById('modalQuizOrderHint');
                        if (orderHint && suggestedOrder && suggestedOrder > 0) {
                            orderHint.textContent = 'Gợi ý: STT ' + suggestedOrder + ' chưa được dùng trong chương này.';
                            orderHint.className = 'form-text small text-success';
                        } else if (orderHint) {
                            orderHint.textContent = 'Số thứ tự phải không trùng với bài Quiz khác trong cùng chương.';
                            orderHint.className = 'form-text small text-muted';
                        }
                        if (moduleId) {
                            const modSelect = document.getElementById('modalModuleSelect');
                            if (modSelect) modSelect.value = moduleId;
                        }
                        const modalEl = document.getElementById('quizModal');
                        if (modalEl) {
                            bootstrap.Modal.getOrCreateInstance(modalEl).show();
                        }
                    }

                    function openEditQuizModal(id, moduleId, title, passScore, timeLimit, orderIndex) {
                        const idInput = document.getElementById('modalQuizId');
                        if (idInput) idInput.value = id;
                        const titleLabel = document.getElementById('quizModalLabel');
                        if (titleLabel) titleLabel.innerHTML = '<span class="text-orange"><i class="bi bi-gear-fill"></i></span> Cập nhật bài kiểm tra #' + id;
                        const titleInput = document.getElementById('modalQuizTitle');
                        if (titleInput) titleInput.value = title || '';
                        const passScoreInput = document.getElementById('modalQuizPassScore');
                        if (passScoreInput) passScoreInput.value = passScore || '50';
                        const timeLimitInput = document.getElementById('modalQuizTimeLimit');
                        if (timeLimitInput) timeLimitInput.value = timeLimit || '';
                        const orderInput = document.getElementById('modalQuizOrderIndex');
                        if (orderInput) orderInput.value = orderIndex || '1';
                        // Reset hint STT về mặc định khi edit
                        const orderHint = document.getElementById('modalQuizOrderHint');
                        if (orderHint) {
                            orderHint.textContent = 'Thứ tự hiện tại: ' + (orderIndex || 1) + '. Chỉ thay đổi nếu cần sắp xếp lại, tránh trùng với bài Quiz khác.';
                            orderHint.className = 'form-text small text-muted';
                        }
                        if (moduleId) {
                            const modSelect = document.getElementById('modalModuleSelect');
                            if (modSelect) modSelect.value = moduleId;
                        }
                        const modalEl = document.getElementById('quizModal');
                        if (modalEl) {
                            bootstrap.Modal.getOrCreateInstance(modalEl).show();
                        }
                    }

                    function openDeleteQuizModal(id, title, courseId, moduleId) {
                        const titleEl = document.getElementById('deleteQuizTitle');
                        if (titleEl) titleEl.textContent = 'Bạn có chắc chắn muốn xóa bài thi "' + title + '"?';
                        let deleteUrl = '${pageContext.request.contextPath}/quizzes/delete?id=' + id;
                        if (courseId) deleteUrl += '&courseId=' + courseId;
                        if (moduleId) deleteUrl += '&moduleId=' + moduleId;
                        const link = document.getElementById('confirmDeleteLink');
                        if (link) link.href = deleteUrl;
                        const modalEl = document.getElementById('deleteQuizModal');
                        if (modalEl) {
                            bootstrap.Modal.getOrCreateInstance(modalEl).show();
                        }
                    }

                    function openCreateQuestionModal(moduleId) {
                        // Reset về chế độ tạo mới
                        const qId = document.getElementById('modalQId');
                        if (qId) qId.value = '';
                        const qText = document.getElementById('modalQText');
                        if (qText) qText.value = '';
                        const qPoints = document.getElementById('modalQPoints');
                        if (qPoints) qPoints.value = '1.0';
                        if (moduleId) {
                            const modSelect = document.getElementById('modalQModuleSelect');
                            if (modSelect) modSelect.value = moduleId;
                        }
                        // Reset options về trống
                        ['modalQOptA','modalQOptB','modalQOptC','modalQOptD'].forEach(id => {
                            const el = document.getElementById(id);
                            if (el) el.value = '';
                        });
                        // Reset radio về đáp án A
                        const firstRadio = document.querySelector('#bankQuestionForm input[name="correctOption"][value="0"]');
                        if (firstRadio) firstRadio.checked = true;
                        // Reset header & button
                        const icon = document.getElementById('questionModalIcon');
                        if (icon) icon.innerHTML = '<i class="bi bi-database-add"></i>';
                        if (icon) icon.className = 'text-success';
                        const title = document.getElementById('questionModalTitle');
                        if (title) title.textContent = 'Tạo câu hỏi mới vào Ngân hàng';
                        const submitBtn = document.getElementById('questionModalSubmitBtn');
                        if (submitBtn) submitBtn.className = 'btn btn-success btn-sm fw-semibold rounded-3 px-3 shadow-sm';
                        const submitText = document.getElementById('questionModalSubmitText');
                        if (submitText) submitText.textContent = 'Lưu vào ngân hàng';
                        // Reset type
                        const qType = document.getElementById('modalQType');
                        if (qType) qType.value = 'SINGLE_CHOICE';
                        handleModalQTypeChange('SINGLE_CHOICE');
                        const modalEl = document.getElementById('questionModal');
                        if (modalEl) {
                            bootstrap.Modal.getOrCreateInstance(modalEl).show();
                        }
                    }

                    function openEditQuestionModal(btn) {
                        const tr = btn.closest('tr.question-row');
                        if (!tr) return;

                        const qId     = tr.getAttribute('data-q-id');
                        const qText   = tr.getAttribute('data-q-text');
                        const qPoints = tr.getAttribute('data-q-points');
                        const qType   = tr.getAttribute('data-type');
                        const moduleId = tr.getAttribute('data-module-id');
                        let   options  = [];
                        try { options = JSON.parse(tr.getAttribute('data-q-options') || '[]'); } catch(e) {}

                        // Điền id, text, points, type, module
                        document.getElementById('modalQId').value = qId;
                        document.getElementById('modalQText').value = qText;
                        document.getElementById('modalQPoints').value = qPoints;
                        const typeEl = document.getElementById('modalQType');
                        if (typeEl) typeEl.value = qType;
                        const modSel = document.getElementById('modalQModuleSelect');
                        if (modSel && moduleId) modSel.value = moduleId;

                        // Điền options A/B/C/D
                        const optIds = ['modalQOptA','modalQOptB','modalQOptC','modalQOptD'];
                        const radios = document.querySelectorAll('#bankQuestionForm input[name="correctOption"]');
                        optIds.forEach((id, i) => {
                            const el = document.getElementById(id);
                            if (!el) return;
                            const opt = options[i];
                            el.value = opt ? opt.text : '';
                            if (radios[i]) radios[i].checked = opt ? opt.correct : (i === 0);
                        });

                        // Áp dụng hiển thị theo loại câu hỏi
                        handleModalQTypeChange(qType);

                        // Đổi header & nút submit sang Edit mode
                        const icon = document.getElementById('questionModalIcon');
                        if (icon) { icon.innerHTML = '<i class="bi bi-pencil-square"></i>'; icon.className = 'text-primary'; }
                        const titleEl = document.getElementById('questionModalTitle');
                        if (titleEl) titleEl.textContent = 'Chỉnh sửa câu hỏi #' + qId;
                        const submitBtn = document.getElementById('questionModalSubmitBtn');
                        if (submitBtn) submitBtn.className = 'btn btn-primary btn-sm fw-semibold rounded-3 px-3 shadow-sm';
                        const submitText = document.getElementById('questionModalSubmitText');
                        if (submitText) submitText.textContent = 'Lưu thay đổi';

                        // Hiện modal
                        const modalEl = document.getElementById('questionModal');
                        if (modalEl) bootstrap.Modal.getOrCreateInstance(modalEl).show();
                    }
                </script>