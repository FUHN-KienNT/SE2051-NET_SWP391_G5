<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Expert Dashboard - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Top bar -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1"><i class="bi bi-mortarboard me-2"></i>Bảng điều khiển Chuyên gia (Expert Dashboard)</h3>
                <p class="text-muted small mb-0">Quản lý các khóa học được phân công, soạn thảo bài giảng và chương trình học (Màn hình II.4.3)</p>
            </div>
        </div>

        <!-- Metric summary -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-primary text-white">
                    <div class="small text-white-50 text-uppercase fw-bold">Khóa học phụ trách</div>
                    <div class="fs-2 fw-bold mt-1">${courses.size()}</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-success text-white">
                    <div class="small text-white-50 text-uppercase fw-bold">Vai trò hệ thống</div>
                    <div class="fs-2 fw-bold mt-1">Chuyên gia (Expert)</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 border-0 shadow-sm rounded-3 bg-info text-white">
                    <div class="small text-white-50 text-uppercase fw-bold">Nhiệm vụ chính</div>
                    <div class="fs-5 fw-bold mt-2">Biên soạn Lesson &amp; Quiz</div>
                </div>
            </div>
        </div>

        <!-- Course assigned list -->
        <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
            <div class="card-header bg-white py-3">
                <h5 class="fw-bold mb-0">Danh sách Khóa học bạn được phân công</h5>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Tên khóa học</th>
                            <th>Danh mục</th>
                            <th>Số chương (Modules)</th>
                            <th>Trạng thái</th>
                            <th class="text-end">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty courses}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-folder-x fs-1 d-block mb-2"></i>
                                        Bạn chưa được phân công phụ trách khóa học nào.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${courses}">
                                    <tr>
                                        <td>#${c.id}</td>
                                        <td class="fw-bold">${c.title}</td>
                                        <td><span class="badge bg-light text-dark border">${c.categoryName}</span></td>
                                        <td>${c.modules.size()} chương</td>
                                        <td>
                                            <span class="badge ${c.status == 'PUBLISHED' ? 'bg-success' : 'bg-secondary'}">${c.status}</span>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}" class="btn btn-primary btn-sm me-1">
                                                <i class="bi bi-journal-text me-1"></i>Soạn Bài học (Lesson)
                                            </a>
                                            <a href="${pageContext.request.contextPath}/quizzes/list?moduleId=${not empty c.modules ? c.modules[0].id : ''}" class="btn btn-outline-warning btn-sm">
                                                <i class="bi bi-patch-question me-1"></i>Soạn Đề thi (Quiz)
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
</main>

<jsp:include page="../common/footer.jsp" />
