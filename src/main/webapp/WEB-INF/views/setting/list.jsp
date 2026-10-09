<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Setting List - Courson LMS" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<%
    String currentSortBy = (String) request.getAttribute("currentSortBy");
    String currentSortOrder = (String) request.getAttribute("currentSortOrder");
    if (currentSortOrder == null || currentSortOrder.isEmpty()) currentSortOrder = "asc";
    String nextSortOrder = currentSortOrder.equalsIgnoreCase("asc") ? "desc" : "asc";
%>

<main class="main-content py-5">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Setting List</h3>
                <p class="text-muted small mb-0">View and manage system settings</p>
            </div>
            <a href="${pageContext.request.contextPath}/settings/detail" class="btn btn-primary" title="New Setting">
                <i class="bi bi-plus-lg me-1"></i>New Setting
            </a>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success py-2 small" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i>Action completed successfully!
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger py-2 small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-1"></i>${param.error}
            </div>
        </c:if>
        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-danger py-2 small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-1"></i>${requestScope.error}
            </div>
        </c:if>

        <div class="card border-0 shadow-sm rounded-3 mb-4 p-3">
            <form action="${pageContext.request.contextPath}/settings/list" method="GET" class="row g-3 align-items-end">
                <input type="hidden" name="sortBy" value="${currentSortBy}">
                <input type="hidden" name="sortOrder" value="${currentSortOrder}">
                
                <div class="col-md-3">
                    <label class="form-label small fw-semibold" title="Setting Type">Type Filter</label>
                    <select name="type" class="form-select">
                        <option value="ALL" ${currentType == 'ALL' || empty currentType ? 'selected' : ''}>All Types</option>
                        <option value="USER_ROLE" ${currentType == 'USER_ROLE' ? 'selected' : ''}>USER_ROLE</option>
                        <option value="COURSE_CATEGORY" ${currentType == 'COURSE_CATEGORY' ? 'selected' : ''}>COURSE_CATEGORY</option>
                    </select>
                </div>
                
                <div class="col-md-3">
                    <label class="form-label small fw-semibold" title="Setting Status">Status Filter</label>
                    <select name="status" class="form-select">
                        <option value="ALL" ${currentStatus == 'ALL' || empty currentStatus ? 'selected' : ''}>All Statuses</option>
                        <option value="ACTIVE" ${currentStatus == 'ACTIVE' ? 'selected' : ''}>Active</option>
                        <option value="INACTIVE" ${currentStatus == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label small fw-semibold">Search Box</label>
                    <input type="text" name="keyword" class="form-control" placeholder="Search by name or value..." value="${currentKeyword}">
                </div>

                <div class="col-md-2 text-end">
                    <button type="submit" class="btn btn-secondary w-100" title="Search Button">
                        <i class="bi bi-search me-1"></i>Search
                    </button>
                </div>
            </form>
        </div>

        <div class="card overflow-hidden border-0 shadow-sm">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=id&sortOrder=<%= currentSortBy != null && currentSortBy.equals("id") ? nextSortOrder : "asc" %>" class="text-dark text-decoration-none">
                                    Id <i class="bi bi-arrow-down-up ms-1 small text-muted"></i>
                                </a>
                            </th>
                            <th>
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=name&sortOrder=<%= currentSortBy != null && currentSortBy.equals("name") ? nextSortOrder : "asc" %>" class="text-dark text-decoration-none">
                                    Name <i class="bi bi-arrow-down-up ms-1 small text-muted"></i>
                                </a>
                            </th>
                            <th>
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=type&sortOrder=<%= currentSortBy != null && currentSortBy.equals("type") ? nextSortOrder : "asc" %>" class="text-dark text-decoration-none">
                                    Type <i class="bi bi-arrow-down-up ms-1 small text-muted"></i>
                                </a>
                            </th>
                            <th>
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=value&sortOrder=<%= currentSortBy != null && currentSortBy.equals("value") ? nextSortOrder : "asc" %>" class="text-dark text-decoration-none">
                                    Value <i class="bi bi-arrow-down-up ms-1 small text-muted"></i>
                                </a>
                            </th>
                            <th>
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=priority&sortOrder=<%= currentSortBy != null && currentSortBy.equals("priority") ? nextSortOrder : "asc" %>" class="text-dark text-decoration-none">
                                    Priority <i class="bi bi-arrow-down-up ms-1 small text-muted"></i>
                                </a>
                            </th>
                            <th>
                                <a href="?type=${currentType}&status=${currentStatus}&keyword=${currentKeyword}&sortBy=status&sortOrder=<%= currentSortBy != null && currentSortBy.equals("status") ? nextSortOrder : "asc" %>" class="text-dark text-decoration-none">
                                    Status <i class="bi bi-arrow-down-up ms-1 small text-muted"></i>
                                </a>
                            </th>
                            <th class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${settings}">
                            <tr>
                                <td>${s.id}</td>
                                <td class="fw-semibold">${s.name}</td>
                                <td><span class="badge bg-light text-dark border">${s.type}</span></td>
                                <td><code>${s.value}</code></td>
                                <td>${s.priority}</td>
                                <td>
                                    <span class="badge ${s.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                        ${s.status}
                                    </span>
                                </td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/settings/detail?id=${s.id}" class="btn btn-outline-primary btn-sm me-1" title="Edit Link">
                                        Edit
                                    </a>
                                    <c:choose>
                                        <c:when test="${s.status == 'ACTIVE'}">
                                            <a href="${pageContext.request.contextPath}/settings/toggle-status?id=${s.id}" class="btn btn-outline-warning btn-sm" title="Deactivate Link">
                                                Deactivate
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/settings/toggle-status?id=${s.id}" class="btn btn-outline-success btn-sm" title="Activate Link">
                                                Activate
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty settings}">
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    No settings found matching your criteria.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
