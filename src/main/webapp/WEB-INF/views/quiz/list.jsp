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

                    /* Module Card & Headers */
                    .module-quiz-card {
                        border: 1px solid #e2e8f0;
                        border-radius: 0.75rem;
                        background: #ffffff;
                        overflow: hidden;
                        margin-bottom: 1rem;
                        transition: border-color 0.15s ease;
                    }

                    .module-quiz-card:hover {
                        border-color: #cbd5e1;
                    }

                    .module-quiz-header {
                        background: #f8fafc;
                        border-bottom: 1px solid #e2e8f0;
                        padding: 0.75rem 1.15rem;
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
                                    <span>Quiz: ${course.title}</span>
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
                            <c:set var="modulesWithQuizCount" value="0" />
                            <c:forEach var="m" items="${course.modules}">
                                <c:if test="${not empty m.quizzes and fn:length(m.quizzes) > 0}">
                                    <c:set var="modulesWithQuizCount" value="${modulesWithQuizCount + 1}" />
                                </c:if>
                            </c:forEach>

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
                                                ${not empty courseQuestions ? fn:length(courseQuestions) : 0} <span
                                                    class="fs-6 fw-normal text-muted">câu hỏi</span>
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
                                                ${not empty course.modules ? fn:length(course.modules) : 0} <span
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
                                    <i class="bi bi-collection me-1.5"></i>Danh sách Quiz theo Chương
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
                                    <i class="bi bi-database me-1.5"></i>Ngân hàng câu hỏi khóa học
                                    <span class="badge bg-secondary-subtle text-secondary border rounded-pill ms-1.5"
                                        id="totalQuestionsBadge">
                                        ${not empty courseQuestions ? fn:length(courseQuestions) : 0}
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
                                        <!-- Thanh công cụ tìm kiếm & lọc nhanh Tab 1 (Chống rối mắt) -->
                                        <div class="card border-0 shadow-sm rounded-3 p-2.5 mb-3 bg-white">
                                            <div class="row g-2 align-items-center justify-content-between">
                                                <div class="col-md-6 col-12">
                                                    <div class="input-group input-group-sm">
                                                        <span class="input-group-text bg-light border-end-0 text-muted">
                                                            <i class="bi bi-search"></i>
                                                        </span>
                                                        <input type="text" id="quizSearchInput"
                                                            class="form-control border-start-0 bg-light"
                                                            placeholder="Tìm bài Quiz theo tên hoặc theo chương học...">
                                                        <button
                                                            class="btn btn-outline-secondary border-start-0 bg-light text-muted d-none"
                                                            type="button" id="clearQuizSearchBtn">
                                                            <i class="bi bi-x-circle"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div
                                                    class="col-md-6 col-12 d-flex justify-content-md-end align-items-center gap-2">
                                                    <span class="small text-muted d-none d-sm-inline">Hiển thị:</span>
                                                    <div class="btn-group btn-group-sm" role="group"
                                                        aria-label="Filter modules">
                                                        <button type="button"
                                                            class="btn btn-outline-secondary active module-filter-btn"
                                                            data-filter="all">
                                                            Tất cả chương (${fn:length(course.modules)})
                                                        </button>
                                                        <button type="button"
                                                            class="btn btn-outline-secondary module-filter-btn"
                                                            data-filter="has-quiz">
                                                            Có Quiz (${modulesWithQuizCount})
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Thông báo khi filter không tìm thấy quiz nào -->
                                        <div id="quizTabNoResult"
                                            class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white d-none mb-3">
                                            <div class="text-muted mb-2"><i class="bi bi-search fs-2"></i></div>
                                            <h6 class="fw-bold text-dark mb-1">Không tìm thấy bài Quiz nào phù hợp</h6>
                                            <p class="small text-muted mb-0">Thử tìm kiếm với từ khóa khác hoặc chuyển
                                                chế độ xem sang "Tất cả chương".</p>
                                        </div>

                                        <!-- Danh sách Modules & Quizzes -->
                                        <div class="d-flex flex-column gap-3" id="modulesListContainer">
                                            <c:forEach var="m" items="${course.modules}">
                                                <c:set var="mHasQuizzes"
                                                    value="${not empty m.quizzes and fn:length(m.quizzes) > 0}" />
                                                <div class="module-quiz-card" id="module-${m.id}"
                                                    data-has-quizzes="${mHasQuizzes ? 'true' : 'false'}"
                                                    data-module-title="${fn:toLowerCase(m.title)}">

                                                    <!-- Module Header Bar Tinh gọn -->
                                                    <div
                                                        class="module-quiz-header d-flex flex-wrap justify-content-between align-items-center gap-2">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <span class="badge bg-white text-dark border fw-semibold">
                                                                Chương ${m.orderIndex}
                                                            </span>
                                                            <h6 class="fw-bold mb-0 text-dark">${m.title}</h6>
                                                            <c:choose>
                                                                <c:when test="${mHasQuizzes}">
                                                                    <span
                                                                        class="badge bg-orange-subtle text-orange border border-orange-subtle ms-1">
                                                                        ${fn:length(m.quizzes)} bài quiz
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        class="badge bg-light text-muted border ms-1">0
                                                                        bài quiz</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>

                                                        <!-- Nút tạo quiz tinh gọn -->
                                                        <div>
                                                            <c:set var="nextOrder"
                                                                value="${fn:length(m.quizzes) + 1}" />
                                                            <button type="button"
                                                                class="btn btn-sm btn-outline-primary rounded-3 py-1 px-2.5 small fw-semibold"
                                                                onclick="openCreateQuizModal('${m.id}', '${nextOrder}')"
                                                                data-bs-toggle="modal" data-bs-target="#quizModal">
                                                                <i class="bi bi-plus-lg me-1"></i>Tạo Quiz
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <!-- Quizzes Table hoặc thanh thông báo trống tinh gọn (không chiếm diện tích) -->
                                                    <c:choose>
                                                        <c:when test="${not mHasQuizzes}">
                                                            <div
                                                                class="py-2.5 px-3 bg-light-subtle d-flex align-items-center justify-content-between text-muted small">
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
                                                                                class="text-center">Thứ tự</th>
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
                                                                                            onclick="openEditQuizModal('${q.id}', '${m.id}', '${fn:escapeXml(q.title)}', '${q.passScore}', '${q.timeLimitMinutes != null ? q.timeLimitMinutes : ','}', '${q.orderIndex}')"
                                                                                            data-bs-toggle="modal"
                                                                                            data-bs-target="#quizModal"
                                                                                            title="Sửa thông tin">
                                                                                            <i class="bi bi-gear"></i>
                                                                                        </button>
                                                                                        <button type="button"
                                                                                            class="btn btn-sm btn-outline-danger py-1 px-2 rounded-3"
                                                                                            onclick="openDeleteQuizModal('${q.id}', '${fn:escapeXml(q.title)}', '${course.id}', '${m.id}')"
                                                                                            data-bs-toggle="modal"
                                                                                            data-bs-target="#deleteQuizModal"
                                                                                            title="Xóa bài Quiz">
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
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- ======================================================= -->
                            <!-- TAB 2: NGÂN HÀNG CÂU HỎI (QUESTION LIST)                -->
                            <!-- ======================================================= -->
                            <div class="tab-pane fade" id="pills-questions" role="tabpanel">
                                <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                                    <!-- Filter Toolbar Tinh gọn -->
                                    <div class="card-header bg-white py-3 px-4 border-bottom">
                                        <div class="row g-2 align-items-center justify-content-between">
                                            <div class="col-md-4 col-12">
                                                <div class="input-group input-group-sm">
                                                    <span class="input-group-text bg-light border-end-0 text-muted">
                                                        <i class="bi bi-search"></i>
                                                    </span>
                                                    <input type="text" id="questionSearchInput"
                                                        class="form-control border-start-0 bg-light"
                                                        placeholder="Tìm câu hỏi theo nội dung...">
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

                                            <div
                                                class="col-md-3 col-12 text-md-end d-flex align-items-center justify-content-between justify-content-md-end gap-2">
                                                <span class="small text-muted" id="questionCounterWrapper">
                                                    Hiển thị <strong id="questionVisibleCount" class="text-dark">${not
                                                        empty courseQuestions ? fn:length(courseQuestions) : 0}</strong>
                                                    / ${not empty courseQuestions ? fn:length(courseQuestions) : 0}
                                                </span>
                                                <button type="button"
                                                    class="btn btn-success btn-sm fw-semibold shadow-sm rounded-3 px-3 py-1.5"
                                                    onclick="openCreateQuestionModal('')" data-bs-toggle="modal"
                                                    data-bs-target="#questionModal">
                                                    <i class="bi bi-plus-lg me-1"></i>Thêm câu hỏi
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Questions Table Tinh gọn (Chống rối mắt, hỗ trợ xem trước options) -->
                                    <div class="card-body p-0">
                                        <c:choose>
                                            <c:when test="${empty courseQuestions}">
                                                <div class="p-5 text-center text-muted">
                                                    <div class="bg-light text-muted rounded-circle d-inline-flex align-items-center justify-content-center mx-auto mb-3"
                                                        style="width: 64px; height: 64px;">
                                                        <i class="bi bi-patch-question fs-2"></i>
                                                    </div>
                                                    <h5 class="fw-bold text-dark mb-1">Chưa có câu hỏi nào trong ngân
                                                        hàng!</h5>
                                                    <p class="small text-muted mb-3">Tạo các câu hỏi trắc nghiệm để tái
                                                        sử dụng và gán vào các bài thi của khóa học.</p>
                                                    <button type="button"
                                                        class="btn btn-primary fw-semibold btn-sm rounded-3 px-3 py-2 shadow-sm"
                                                        onclick="openCreateQuestionModal('')" data-bs-toggle="modal"
                                                        data-bs-target="#questionModal">
                                                        <i class="bi bi-plus-lg me-1"></i>Tạo câu hỏi đầu tiên
                                                    </button>
                                                </div>
                                            </c:when>

                                            <c:otherwise>
                                                <!-- Thông báo không tìm thấy kết quả filter -->
                                                <div id="questionEmptyFilter" class="p-5 text-center text-muted d-none">
                                                    <div class="text-muted mb-2"><i class="bi bi-funnel fs-2"></i></div>
                                                    <h6 class="fw-bold text-dark mb-1">Không tìm thấy câu hỏi nào phù
                                                        hợp</h6>
                                                    <p class="small text-muted mb-0">Thử thay đổi từ khóa tìm kiếm hoặc
                                                        bỏ chọn các bộ lọc.</p>
                                                </div>

                                                <div class="table-responsive">
                                                    <table class="table clean-table mb-0 align-middle"
                                                        id="questionsTable">
                                                        <thead>
                                                            <tr>
                                                                <th style="width: 65px;" class="text-center">ID</th>
                                                                <th>Nội dung câu hỏi &amp; Đáp án đúng</th>
                                                                <th style="width: 170px;">Chương học</th>
                                                                <th style="width: 130px;" class="text-center">Dạng câu
                                                                </th>
                                                                <th style="width: 90px;" class="text-center">Điểm</th>
                                                                <th style="width: 80px;" class="text-end pe-3">Xóa</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="q" items="${courseQuestions}">
                                                                <tr class="question-row" data-module-id="${q.moduleId}"
                                                                    data-type="${q.questionType}"
                                                                    data-text="${fn:toLowerCase(q.questionText)}">
                                                                    <td
                                                                        class="text-center text-muted small fw-semibold">
                                                                        #${q.id}
                                                                    </td>
                                                                    <td>
                                                                        <div class="fw-medium text-dark mb-1">
                                                                            <c:out value="${q.questionText}" />
                                                                        </div>

                                                                        <!-- Hiển thị đáp án đúng tinh gọn & toggle xem chi tiết options -->
                                                                        <div
                                                                            class="d-flex flex-wrap align-items-center gap-2 mt-1">
                                                                            <c:set var="correctOptText" value="" />
                                                                            <c:forEach var="opt" items="${q.options}">
                                                                                <c:if test="${opt.correct}">
                                                                                    <c:set var="correctOptText"
                                                                                        value="${opt.optionText}" />
                                                                                </c:if>
                                                                            </c:forEach>

                                                                            <c:if test="${not empty correctOptText}">
                                                                                <span class="correct-answer-snippet">
                                                                                    <i
                                                                                        class="bi bi-check-circle-fill"></i>
                                                                                    <span>Đáp án đúng: <strong>
                                                                                            <c:out
                                                                                                value="${correctOptText}" />
                                                                                        </strong></span>
                                                                                </span>
                                                                            </c:if>

                                                                            <c:if test="${not empty q.options}">
                                                                                <button type="button"
                                                                                    class="btn btn-xs btn-outline-secondary py-0 px-2 rounded-pill"
                                                                                    data-bs-toggle="collapse"
                                                                                    data-bs-target="#options-collapse-${q.id}"
                                                                                    title="Xem danh sách tất cả các phương án">
                                                                                    <i
                                                                                        class="bi bi-list-ul me-1"></i>Xem
                                                                                    ${fn:length(q.options)} lựa chọn
                                                                                </button>
                                                                            </c:if>
                                                                        </div>

                                                                        <!-- Danh sách các lựa chọn có thể mở ra khi bấm (Collapsed mặc định để chống rối mắt) -->
                                                                        <c:if test="${not empty q.options}">
                                                                            <div class="collapse mt-2"
                                                                                id="options-collapse-${q.id}">
                                                                                <div
                                                                                    class="p-2.5 rounded-3 bg-light border row g-2 small">
                                                                                    <c:forEach var="opt"
                                                                                        items="${q.options}"
                                                                                        varStatus="optStatus">
                                                                                        <div class="col-md-6 col-12">
                                                                                            <div
                                                                                                class="d-flex align-items-start gap-2 p-1.5 rounded-2 ${opt.correct ? 'bg-success-subtle text-success fw-semibold border border-success-subtle' : 'bg-white border text-secondary'}">
                                                                                                <span
                                                                                                    class="badge ${opt.correct ? 'bg-success text-white' : 'bg-secondary-subtle text-secondary'} rounded-circle px-1.5 py-1"
                                                                                                    style="font-size: 0.7rem; width: 20px; height: 20px; display: inline-flex; align-items: center; justify-content: center;">
                                                                                                    ${optStatus.index ==
                                                                                                    0 ? 'A' :
                                                                                                    (optStatus.index ==
                                                                                                    1 ? 'B' :
                                                                                                    (optStatus.index ==
                                                                                                    2 ? 'C' : 'D'))}
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
                                                                    <td>
                                                                        <span
                                                                            class="badge bg-light text-secondary border text-truncate d-inline-block"
                                                                            style="max-width: 160px;"
                                                                            title="${q.moduleTitle}">
                                                                            ${q.moduleTitle}
                                                                        </span>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <span
                                                                            class="badge bg-light text-secondary border px-2 py-1">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${q.questionType == 'TRUE_FALSE'}">
                                                                                    Đúng / Sai</c:when>
                                                                                <c:otherwise>1 Đáp án</c:otherwise>
                                                                            </c:choose>
                                                                        </span>
                                                                    </td>
                                                                    <td class="text-center fw-semibold text-secondary">
                                                                        ${q.defaultPoints} đ
                                                                    </td>
                                                                    <td class="text-end pe-3 text-nowrap">
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
                                    <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2">
                                        <span class="text-success"><i class="bi bi-database-add"></i></span>
                                        Tạo câu hỏi mới vào Ngân hàng
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
                                    <button type="submit"
                                        class="btn btn-success btn-sm fw-semibold rounded-3 px-3 shadow-sm">
                                        <i class="bi bi-save me-1"></i>Lưu vào ngân hàng
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <jsp:include page="../common/footer.jsp" />

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // 1. Kích hoạt tab nếu có query param ?tab=questions
                        const urlParams = new URLSearchParams(window.location.search);
                        if (urlParams.get('tab') === 'questions') {
                            const questionsTabBtn = document.getElementById('pills-questions-tab');
                            if (questionsTabBtn) {
                                bootstrap.Tab.getOrCreateInstance(questionsTabBtn).show();
                            }
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
                            const moduleCards = document.querySelectorAll('.module-quiz-card');
                            let anyVisible = false;

                            moduleCards.forEach(function (card) {
                                const hasQuizzes = card.getAttribute('data-has-quizzes') === 'true';
                                const moduleTitle = card.getAttribute('data-module-title') || '';

                                if (currentModuleFilter === 'has-quiz' && !hasQuizzes) {
                                    card.classList.add('d-none');
                                    return;
                                }

                                if (kw === '') {
                                    card.classList.remove('d-none');
                                    card.querySelectorAll('.quiz-row').forEach(r => r.classList.remove('d-none'));
                                    anyVisible = true;
                                } else {
                                    let matchInQuizzes = false;
                                    const rows = card.querySelectorAll('.quiz-row');
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
                                        card.classList.remove('d-none');
                                        if (moduleTitle.includes(kw)) {
                                            rows.forEach(r => r.classList.remove('d-none'));
                                        }
                                        anyVisible = true;
                                    } else {
                                        card.classList.add('d-none');
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
                        const qModFilter = document.getElementById('questionModuleFilter');
                        const qTypeFilter = document.getElementById('questionTypeFilter');
                        const qVisibleCountEl = document.getElementById('questionVisibleCount');
                        const qEmptyFilterEl = document.getElementById('questionEmptyFilter');
                        const questionsTable = document.getElementById('questionsTable');

                        function filterQuestions() {
                            const kw = qSearch ? qSearch.value.trim().toLowerCase() : '';
                            const modId = qModFilter ? qModFilter.value : 'all';
                            const type = qTypeFilter ? qTypeFilter.value : 'all';
                            const rows = document.querySelectorAll('.question-row');
                            let count = 0;

                            rows.forEach(function (row) {
                                const rowText = row.getAttribute('data-text') || '';
                                const rowMod = row.getAttribute('data-module-id') || '';
                                const rowType = row.getAttribute('data-type') || '';

                                const matchKw = (kw === '' || rowText.includes(kw));
                                const matchMod = (modId === 'all' || modId === rowMod);
                                const matchType = (type === 'all' || type === rowType);
                                const visible = matchKw && matchMod && matchType;

                                row.classList.toggle('d-none', !visible);
                                if (visible) count++;
                            });

                            if (qVisibleCountEl) qVisibleCountEl.textContent = count;
                            if (qEmptyFilterEl && questionsTable) {
                                if (count === 0 && rows.length > 0) {
                                    qEmptyFilterEl.classList.remove('d-none');
                                    questionsTable.classList.add('d-none');
                                } else {
                                    qEmptyFilterEl.classList.add('d-none');
                                    questionsTable.classList.remove('d-none');
                                }
                            }
                        }

                        if (qSearch) qSearch.addEventListener('input', filterQuestions);
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
                        handleModalQTypeChange('SINGLE_CHOICE');
                        const modalEl = document.getElementById('questionModal');
                        if (modalEl) {
                            bootstrap.Modal.getOrCreateInstance(modalEl).show();
                        }
                    }
                </script>