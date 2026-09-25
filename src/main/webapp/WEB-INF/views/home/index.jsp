<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Trang chủ - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content">
    <!-- Hero Section -->
    <section class="bg-primary text-white py-5">
        <div class="container py-4 text-center">
            <h1 class="display-5 fw-bold mb-3">Nâng tầm tri thức cùng Courson LMS</h1>
            <p class="lead mb-4 text-white-50">Khám phá các khóa học công nghệ thông tin, khoa học dữ liệu và kỹ năng mềm hàng đầu.</p>
            
            <div class="row justify-content-center">
                <div class="col-md-7">
                    <form action="${pageContext.request.contextPath}/home" method="GET" class="d-flex gap-2">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" value="${keyword}" class="form-control form-control-lg border-0 shadow-sm" placeholder="Tìm kiếm khóa học theo tên hoặc từ khóa...">
                        <button type="submit" class="btn btn-warning btn-lg px-4 fw-semibold text-dark shadow-sm">
                            <i class="bi bi-search me-1"></i>Tìm kiếm
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Courses Grid -->
    <section class="py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold mb-0">Khóa học nổi bật</h3>
                <a href="${pageContext.request.contextPath}/courses/catalog" class="text-primary text-decoration-none fw-semibold">
                    Xem tất cả <i class="bi bi-arrow-right"></i>
                </a>
            </div>

            <c:choose>
                <c:when test="${empty courses}">
                    <div class="text-center py-5 bg-white rounded-3 border">
                        <i class="bi bi-journal-x fs-1 text-muted"></i>
                        <p class="text-muted mt-2">Chưa có khóa học nào được xuất bản.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row row-cols-1 row-cols-md-3 g-4">
                        <c:forEach var="c" items="${courses}">
                            <div class="col">
                                <div class="card h-100">
                                    <div class="card-body d-flex flex-column">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                                ${c.categoryName != null ? c.categoryName : "Chung"}
                                            </span>
                                            <span class="fw-bold text-success">
                                                <c:choose>
                                                    <c:when test="${c.price <= 0}">Miễn phí</c:when>
                                                    <c:otherwise>${c.price} VNĐ</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <h5 class="card-title fw-bold text-truncate">${c.title}</h5>
                                        <p class="card-text text-muted small flex-grow-1">
                                            ${c.description != null ? c.description : "Chưa có mô tả chi tiết."}
                                        </p>
                                        <div class="pt-3 border-top d-flex justify-content-between align-items-center">
                                            <small class="text-muted"><i class="bi bi-book me-1"></i>${c.modules.size()} Chương</small>
                                            <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="btn btn-outline-primary btn-sm px-3">
                                                Xem chi tiết
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
    </section>
</main>

<jsp:include page="../common/footer.jsp" />
