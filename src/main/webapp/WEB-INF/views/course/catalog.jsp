<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Danh mục khóa học - Courson LMS" />
<jsp:include page="../common/header.jsp" />

<style>
    .catalog-pagination .page-link {
        color: #374151;
        border: 1px solid #E5E7EB;
        border-radius: 8px !important;
        margin: 0 3px;
        min-width: 38px;
        height: 38px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-weight: 600;
        font-size: 0.9rem;
        transition: all 0.15s ease;
    }
    .catalog-pagination .page-link:hover {
        background-color: #FFF7ED;
        border-color: #F38020;
        color: #F38020;
    }
    .catalog-pagination .page-item.active .page-link {
        background-color: #F38020;
        border-color: #F38020;
        color: #FFFFFF;
        box-shadow: 0 4px 10px rgba(243, 128, 32, 0.25);
    }
    .catalog-pagination .page-item.disabled .page-link {
        color: #9CA3AF;
        background-color: #F9FAFB;
        border-color: #E5E7EB;
    }
</style>

<main class="main-content py-5">
    <div class="container">
        <div class="row mb-4 align-items-center">
            <div class="col-md-8">
                <h3 class="fw-bold mb-1">Tất cả khóa học</h3>
                <p class="text-muted small mb-0">Khám phá các lộ trình học tập chuyên sâu được giảng dạy bởi các chuyên gia.</p>
            </div>
            <div class="col-md-4 mt-3 mt-md-0">
                <form action="${pageContext.request.contextPath}/courses/catalog" method="GET">
                    <c:if test="${not empty selectedCategoryId}">
                        <input type="hidden" name="categoryId" value="${selectedCategoryId}">
                    </c:if>
                    <div class="input-group">
                        <input type="text" name="keyword" value="<c:out value='${keyword}'/>" class="form-control" placeholder="Tìm theo tên khóa học...">
                        <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i></button>
                        <c:if test="${not empty keyword || not empty selectedCategoryId}">
                            <a href="${pageContext.request.contextPath}/courses/catalog" class="btn btn-outline-secondary" title="Xóa bộ lọc">
                                <i class="bi bi-x-lg"></i>
                            </a>
                        </c:if>
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
                        <c:set var="targetCourseUrl" value="${pageContext.request.contextPath}/courses/detail?id=${c.id}" />
                        <c:set var="targetCourseCta" value="Xem khóa học" />
                        <c:set var="targetBtnClass" value="btn-primary" />
                        <c:if test="${sessionScope.CURRENT_USER.roleName == 'EXPERT'}">
                            <c:set var="targetCourseUrl" value="${pageContext.request.contextPath}/expert/lessons?courseId=${c.id}" />
                            <c:set var="targetCourseCta" value="Quản lý bài học" />
                            <c:set var="targetBtnClass" value="btn-warning text-dark fw-semibold" />
                        </c:if>
                        <c:if test="${sessionScope.CURRENT_USER.roleName == 'ADMIN' || sessionScope.CURRENT_USER.roleName == 'MANAGER'}">
                            <c:set var="targetCourseUrl" value="${pageContext.request.contextPath}/admin/course-detail?id=${c.id}" />
                            <c:set var="targetCourseCta" value="Quản trị khóa" />
                            <c:set var="targetBtnClass" value="btn-danger fw-semibold" />
                        </c:if>

                        <div class="col">
                            <div class="card h-100 shadow-sm border-0 overflow-hidden">
                                <a href="${targetCourseUrl}" class="d-block position-relative">
                                    <img src="${c.thumbnailUrl}" class="card-img-top" alt="<c:out value='${c.title}'/>" style="height: 190px; object-fit: cover;" onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=60'">
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
                                    <h5 class="card-title fw-bold text-truncate" title="<c:out value='${c.title}'/>">
                                        <a href="${targetCourseUrl}" class="text-dark text-decoration-none"><c:out value="${c.title}"/></a>
                                    </h5>
                                    <p class="card-text text-muted small flex-grow-1 mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                        <c:out value="${c.description != null ? c.description : 'Chưa có mô tả chi tiết.'}"/>
                                    </p>
                                    <div class="pt-3 border-top d-flex justify-content-between align-items-center">
                                        <small class="text-muted"><i class="bi bi-person me-1"></i><c:out value="${c.expertName != null ? c.expertName : 'Courson'}"/></small>
                                        <a href="${targetCourseUrl}" class="btn ${targetBtnClass} btn-sm px-3">
                                            ${targetCourseCta}
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <%-- Thanh phân trang (1, 2, 3...) --%>
                <c:if test="${totalPages >= 1}">
                    <nav aria-label="Phân trang danh sách khóa học" class="mt-5 d-flex justify-content-center">
                        <ul class="pagination catalog-pagination mb-0">
                            <c:url var="prevUrl" value="/courses/catalog">
                                <c:param name="page" value="${currentPage - 1}" />
                                <c:if test="${not empty keyword}">
                                    <c:param name="keyword" value="${keyword}" />
                                </c:if>
                                <c:if test="${not empty selectedCategoryId}">
                                    <c:param name="categoryId" value="${selectedCategoryId}" />
                                </c:if>
                            </c:url>
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${currentPage <= 1 ? '#' : prevUrl}" aria-label="Trang trước">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <c:url var="pageUrl" value="/courses/catalog">
                                    <c:param name="page" value="${p}" />
                                    <c:if test="${not empty keyword}">
                                        <c:param name="keyword" value="${keyword}" />
                                    </c:if>
                                    <c:if test="${not empty selectedCategoryId}">
                                        <c:param name="categoryId" value="${selectedCategoryId}" />
                                    </c:if>
                                </c:url>
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageUrl}">${p}</a>
                                </li>
                            </c:forEach>

                            <c:url var="nextUrl" value="/courses/catalog">
                                <c:param name="page" value="${currentPage + 1}" />
                                <c:if test="${not empty keyword}">
                                    <c:param name="keyword" value="${keyword}" />
                                </c:if>
                                <c:if test="${not empty selectedCategoryId}">
                                    <c:param name="categoryId" value="${selectedCategoryId}" />
                                </c:if>
                            </c:url>
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${currentPage >= totalPages ? '#' : nextUrl}" aria-label="Trang sau">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />