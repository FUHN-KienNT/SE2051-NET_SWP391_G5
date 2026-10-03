<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản trị khóa học - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Breadcrumb & Title -->
        <nav class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/courses">Khóa học</a></li>
                <li class="breadcrumb-item active">Chi tiết khóa học #${course.id}</li>
            </ol>
        </nav>

        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Đã cập nhật thông tin và phân công chuyên gia thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Left col: Course edit & Expert assignment form -->
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0"><i class="bi bi-info-square me-2 text-primary"></i>Thông số khóa học (Course Specifications)</h5>
                        <span class="badge ${course.status == 'PUBLISHED' ? 'bg-success' : (course.status == 'ARCHIVED' ? 'bg-warning text-dark' : 'bg-secondary')}">
                            ${course.status}
                        </span>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/save-course" method="POST">
                        <input type="hidden" name="id" value="${course.id}">
                        
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Tên khóa học (Course Title) <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control fw-bold" value="${course.title}" required>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Học phí (Price, 0 là Miễn phí)</label>
                                <input type="number" name="price" step="1000" min="0" value="${course.price}" class="form-control text-success fw-semibold" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Danh mục (Category) <span class="text-danger">*</span></label>
                                <select name="categoryId" class="form-select" required>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}" ${course.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Người quản lý (Assigned Manager)</label>
                                <select name="managerId" class="form-select">
                                    <option value="">-- Chọn Manager --</option>
                                    <c:forEach var="mgr" items="${managers}">
                                        <option value="${mgr.id}" ${course.managerId == mgr.id ? 'selected' : ''}>${mgr.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Chuyên gia (Assigned Expert) <span class="text-danger">*</span></label>
                                <select name="expertId" class="form-select border-primary" required>
                                    <option value="">-- Chọn Chuyên gia --</option>
                                    <c:forEach var="exp" items="${experts}">
                                        <option value="${exp.id}" ${course.expertId == exp.id ? 'selected' : ''}>${exp.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Mô tả chi tiết (Description)</label>
                            <textarea name="description" rows="4" class="form-control">${course.description}</textarea>
                        </div>

                        <!-- Administrative Override -->
                        <div class="mt-4 pt-3 border-top">
                            <h6 class="fw-bold mb-3"><i class="bi bi-shield-exclamation text-danger me-2"></i>Quyền kiểm duyệt (Status Override)</h6>
                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Trạng thái khóa học (Course Status) <span class="text-danger">*</span></label>
                                <select name="status" class="form-select border-danger">
                                    <option value="DRAFT" ${course.status == 'DRAFT' ? 'selected' : ''}>Draft (Bản nháp)</option>
                                    <option value="PENDING_REVIEW" ${course.status == 'PENDING_REVIEW' ? 'selected' : ''}>Pending Review (Chờ duyệt)</option>
                                    <option value="PUBLISHED" ${course.status == 'PUBLISHED' ? 'selected' : ''}>Published (Phát hành)</option>
                                    <option value="ARCHIVED" ${course.status == 'ARCHIVED' ? 'selected' : ''}>Archived (Đình chỉ / Lưu trữ)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Lý do kiểm duyệt (Moderation Note)</label>
                                <textarea name="moderationNote" rows="2" class="form-control" maxlength="255" placeholder="Ghi chú lý do thay đổi trạng thái (tối đa 255 ký tự)..."></textarea>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-4">
                                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-secondary px-4">
                                    <i class="bi bi-arrow-left me-1"></i>Back
                                </a>
                                <button type="submit" class="btn btn-danger fw-semibold px-4">
                                    <i class="bi bi-shield-check me-1"></i>Save All Changes
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Right col: Curriculum preview & Meta info -->
            <div class="col-lg-5">
                <!-- Meta Info Card -->
                <div class="card border-0 shadow-sm rounded-3 p-4 mb-4">
                    <h6 class="fw-bold text-dark mb-3"><i class="bi bi-info-circle me-1 text-primary"></i>Thông tin tổng quan</h6>
                    <ul class="list-unstyled small mb-0">
                        <li class="d-flex justify-content-between py-1 border-bottom">
                            <span class="text-muted">Mã khóa học:</span>
                            <span class="fw-bold">#${course.id}</span>
                        </li>
                        <li class="d-flex justify-content-between py-1 border-bottom">
                            <span class="text-muted">Người quản lý (Manager):</span>
                            <span>${course.managerName != null ? course.managerName : 'Hệ thống'}</span>
                        </li>
                        <li class="d-flex justify-content-between py-1 border-bottom">
                            <span class="text-muted">Chuyên gia phụ trách:</span>
                            <span class="fw-semibold text-primary">${course.expertName != null ? course.expertName : 'Chưa phân công'}</span>
                        </li>
                        <li class="d-flex justify-content-between py-1 border-bottom">
                            <span class="text-muted">Tổng số chương:</span>
                            <span class="badge bg-secondary-subtle text-secondary">${course.modules != null ? course.modules.size() : 0} Chương</span>
                        </li>
                        <li class="d-flex justify-content-between py-1">
                            <span class="text-muted">Học phí niêm yết:</span>
                            <span class="fw-bold text-success">
                                <c:choose>
                                    <c:when test="${course.price > 0}">${course.price} VNĐ</c:when>
                                    <c:otherwise>Miễn phí</c:otherwise>
                                </c:choose>
                            </span>
                        </li>
                    </ul>
                </div>

                <!-- Curriculum Preview -->
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0"><i class="bi bi-list-task me-1 text-primary"></i>Khung chương trình học</h6>
                        <span class="small text-muted">Do Expert biên soạn</span>
                    </div>

                    <c:choose>
                        <c:when test="${empty course.modules}">
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-hourglass-split fs-2 d-block mb-2 text-muted"></i>
                                <p class="small mb-0">Chuyên gia phụ trách chưa tạo chương trình học cho khóa này.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="accordion" id="curriculumAccordion">
                                <c:forEach var="m" items="${course.modules}" varStatus="status">
                                    <div class="accordion-item border mb-2 rounded-2 overflow-hidden">
                                        <h2 class="accordion-header">
                                            <button class="accordion-button py-2 ${status.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#mod${m.id}">
                                                <small class="fw-bold">Chương ${m.orderIndex}: ${m.title}</small>
                                            </button>
                                        </h2>
                                        <div id="mod${m.id}" class="accordion-collapse collapse ${status.first ? 'show' : ''}">
                                            <div class="accordion-body p-2">
                                                <ul class="list-group list-group-flush small">
                                                    <c:forEach var="l" items="${m.lessons}">
                                                        <li class="list-group-item d-flex justify-content-between align-items-center py-2">
                                                            <span><i class="bi bi-play-circle text-primary me-2"></i>Bài ${l.orderIndex}: ${l.title}</span>
                                                            <span class="badge bg-light text-muted border">Bài học</span>
                                                        </li>
                                                    </c:forEach>
                                                    <c:forEach var="q" items="${m.quizzes}">
                                                        <li class="list-group-item d-flex justify-content-between align-items-center py-2 bg-light-subtle">
                                                            <span><i class="bi bi-question-circle text-warning me-2"></i>${q.title}</span>
                                                            <span class="badge bg-warning-subtle text-dark border">Bài thi</span>
                                                        </li>
                                                    </c:forEach>
                                                    <c:if test="${empty m.lessons && empty m.quizzes}">
                                                        <li class="list-group-item text-muted text-center py-2 fst-italic">
                                                            Chưa có bài học hoặc bài thi trong chương này
                                                        </li>
                                                    </c:if>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
