<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Không gian học tập - ${course.title}" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-4">
    <div class="container-fluid px-4">
        <div class="row g-4">
            <!-- Sidebar: Course outline -->
            <div class="col-md-4 col-lg-3">
                <div class="card p-3 shadow-sm" style="max-height: 80vh; overflow-y: auto;">
                    <h5 class="fw-bold mb-3 border-bottom pb-2">${course.title}</h5>
                    <c:forEach var="m" items="${course.modules}">
                        <div class="mb-3">
                            <h6 class="fw-bold text-muted small text-uppercase mb-2">Chương ${m.orderIndex}: ${m.title}</h6>
                            <div class="list-group list-group-flush small">
                                <c:forEach var="l" items="${m.lessons}">
                                    <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registrationId}&lessonId=${l.id}"
                                       class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-2 ${currentLessonId == l.id ? 'active' : ''}">
                                        <span class="text-truncate">${l.title}</span>
                                        <c:if test="${l.progressStatus == 'COMPLETED'}">
                                            <i class="bi bi-check-circle-fill text-success"></i>
                                        </c:if>
                                    </a>
                                </c:forEach>
                                <c:forEach var="q" items="${m.quizzes}">
                                    <a href="${pageContext.request.contextPath}/quizzes/attempt?registrationId=${registrationId}&quizId=${q.id}"
                                       class="list-group-item list-group-item-action list-group-item-warning d-flex justify-content-between align-items-center py-2">
                                        <span class="text-truncate"><i class="bi bi-question-circle me-1"></i>${q.title}</span>
                                        <span class="badge bg-warning text-dark">Thi</span>
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Main Learning Area -->
            <div class="col-md-8 col-lg-9">
                <c:set var="activeLesson" value="${null}" />
                <c:forEach var="m" items="${course.modules}">
                    <c:forEach var="l" items="${m.lessons}">
                        <c:if test="${l.id == currentLessonId}">
                            <c:set var="activeLesson" value="${l}" />
                        </c:if>
                    </c:forEach>
                </c:forEach>

                <c:choose>
                    <c:when test="${activeLesson != null}">
                        <div class="card p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2">
                                <h3 class="fw-bold mb-0">${activeLesson.title}</h3>
                                <form action="${pageContext.request.contextPath}/courses/update-progress" method="POST">
                                    <input type="hidden" name="registrationId" value="${registrationId}">
                                    <input type="hidden" name="lessonId" value="${activeLesson.id}">
                                    <input type="hidden" name="status" value="COMPLETED">
                                    <button type="submit" class="btn btn-success btn-sm px-3">
                                        <i class="bi bi-check2 me-1"></i>Hoàn thành bài học
                                    </button>
                                </form>
                            </div>

                            <c:if test="${not empty activeLesson.videoUrl}">
                                <div class="ratio ratio-16x9 mb-4 rounded bg-dark shadow-sm">
                                    <iframe src="${activeLesson.videoUrl}" allowfullscreen></iframe>
                                </div>
                            </c:if>

                            <div class="lesson-content lh-lg">
                                ${activeLesson.content != null ? activeLesson.content : "<p class='text-muted'>Bài học chưa có nội dung văn bản chi tiết.</p>"}
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card p-5 text-center">
                            <i class="bi bi-book-half fs-1 text-primary mb-3"></i>
                            <h4>Chào mừng bạn đến với khóa học!</h4>
                            <p class="text-muted">Vui lòng chọn một bài học từ menu bên trái để bắt đầu học tập.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
