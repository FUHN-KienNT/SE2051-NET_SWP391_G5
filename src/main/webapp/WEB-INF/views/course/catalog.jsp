<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Danh mục khóa học - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="row mb-4">
            <div class="col-md-8">
                <h3 class="fw-bold">Tất cả khóa học</h3>
                <p class="text-muted small">Khám phá các lộ trình học tập chuyên sâu được giảng dạy bởi các chuyên gia.</p>
            </div>
            <div class="col-md-4">
                <form action="${pageContext.request.contextPath}/courses/catalog" method="GET">
                    <div class="input-group">
                        <input type="text" name="keyword" value="${param.keyword}" class="form-control" placeholder="Tìm theo tên khóa học...">
                        <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i></button>
                    </div>
                </form>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty courses}">
                <div class="text-center py-5 bg-white rounded-3 border">
                    <i class="bi bi-search fs-1 text-muted"></i>
                    <p class="text-muted mt-2">Không tìm thấy khóa học nào phù hợp.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row row-cols-1 row-cols-md-3 g-4">
                    <c:forEach var="c" items="${courses}">
                        <div class="col">
                            <div class="card h-100 shadow-sm border-0 overflow-hidden">
                                <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="d-block position-relative">
                                    <img src="${c.thumbnailUrl}" class="card-img-top" alt="${c.title}" style="height: 190px; object-fit: cover;" onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=60'">
                                    <span class="position-absolute top-0 end-0 m-2 badge bg-dark bg-opacity-75 text-white">
                                        <i class="bi bi-play-circle me-1"></i>${c.totalLessons} bài học
                                    </span>
                                </a>
                                <div class="card-body d-flex flex-column">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge bg-secondary-subtle text-secondary border">
                                            ${c.categoryName != null ? c.categoryName : "Chung"}
                                        </span>
                                        <span class="fw-bold text-success">
                                            <c:choose>
                                                <c:when test="${c.price <= 0}">Miễn phí</c:when>
                                                <c:otherwise>${c.price} VNĐ</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <h5 class="card-title fw-bold text-truncate" title="${c.title}">
                                        <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="text-dark text-decoration-none">${c.title}</a>
                                    </h5>
                                    <p class="card-text text-muted small flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                        ${c.description != null ? c.description : "Chưa có mô tả chi tiết."}
                                    </p>
                                    <div class="pt-3 border-top d-flex justify-content-between align-items-center">
                                        <small class="text-muted"><i class="bi bi-journal-code me-1"></i>${c.modules.size()} Chương</small>
                                        <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="btn btn-primary btn-sm px-3">
                                            Xem khóa học
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
