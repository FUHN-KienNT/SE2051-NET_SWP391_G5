<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Không gian học tập - ${course.title}" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<main class="main-content py-4">
    <div class="container-fluid px-4">
        <div class="row g-4">
            <!-- Sidebar: Streamlined Course Outline -->
            <div class="col-md-4 col-lg-3">
                <div class="card p-3 shadow-sm border-0" style="max-height: 85vh; display: flex; flex-direction: column;">
                    <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                        <h6 class="fw-bold mb-0 text-truncate" title="${course.title}">${course.title}</h6>
                        <span class="badge bg-primary-subtle text-primary">${course.totalLessons} bài</span>
                    </div>

                    <!-- Quick search in lesson list -->
                    <div class="mb-3">
                        <input type="text" id="learnLessonFilter" class="form-control form-control-sm" placeholder="Tìm kiếm bài học..." onkeyup="filterLearningLessons()">
                    </div>

                    <div class="overflow-y-auto flex-grow-1" id="learnLessonListContainer">
                        <c:set var="lessonSeq" value="1" />
                        <div class="list-group list-group-flush small" id="learnLessonList">
                            <c:forEach var="m" items="${course.modules}">
                                <c:forEach var="l" items="${m.lessons}">
                                    <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registrationId}&lessonId=${l.id}"
                                       class="list-group-item list-group-item-action d-flex align-items-center gap-2 py-2 px-2 rounded-2 mb-1 ${currentLessonId == l.id ? 'active bg-primary text-white border-primary' : ''} learn-item"
                                       data-title="${l.title.toLowerCase()}">
                                        <span class="badge ${currentLessonId == l.id ? 'bg-white text-primary' : 'bg-light text-muted border'} flex-shrink-0" style="width: 28px;">
                                            ${lessonSeq}
                                        </span>
                                        <img src="${l.thumbnailUrl}" class="rounded flex-shrink-0" style="width: 44px; height: 26px; object-fit: cover;" alt="${l.title}"
                                             onerror="this.src='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300'">
                                        <div class="text-truncate flex-grow-1">
                                            <span class="d-block text-truncate fw-semibold">${l.title}</span>
                                        </div>
                                        <c:if test="${l.progressStatus == 'COMPLETED'}">
                                            <i class="bi bi-check-circle-fill ${currentLessonId == l.id ? 'text-white' : 'text-success'} flex-shrink-0"></i>
                                        </c:if>
                                    </a>
                                    <c:set var="lessonSeq" value="${lessonSeq + 1}" />
                                </c:forEach>

                                <c:forEach var="q" items="${m.quizzes}">
                                    <a href="${pageContext.request.contextPath}/quizzes/attempt?registrationId=${registrationId}&quizId=${q.id}"
                                       class="list-group-item list-group-item-action list-group-item-warning d-flex justify-content-between align-items-center py-2 px-2 rounded-2 mb-1 learn-item"
                                       data-title="${q.title.toLowerCase()}">
                                        <span class="text-truncate"><i class="bi bi-patch-question me-1"></i>${q.title}</span>
                                        <span class="badge bg-warning text-dark">Kiểm tra</span>
                                    </a>
                                </c:forEach>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Learning Area -->
            <div class="col-md-8 col-lg-9">
                <c:set var="activeLesson" value="${null}" />
                <c:set var="prevLessonId" value="${null}" />
                <c:set var="nextLessonId" value="${null}" />
                <c:set var="foundCurrent" value="false" />
                <c:set var="lastLessonId" value="${null}" />

                <c:forEach var="m" items="${course.modules}">
                    <c:forEach var="l" items="${m.lessons}">
                        <c:choose>
                            <c:when test="${l.id == currentLessonId}">
                                <c:set var="activeLesson" value="${l}" />
                                <c:set var="prevLessonId" value="${lastLessonId}" />
                                <c:set var="foundCurrent" value="true" />
                            </c:when>
                            <c:when test="${foundCurrent == true && nextLessonId == null}">
                                <c:set var="nextLessonId" value="${l.id}" />
                            </c:when>
                        </c:choose>
                        <c:set var="lastLessonId" value="${l.id}" />
                    </c:forEach>
                </c:forEach>

                <c:choose>
                    <c:when test="${activeLesson != null}">
                        <div class="card p-4 shadow-sm border-0 rounded-3">
                            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3 border-bottom pb-3">
                                <div>
                                    <span class="badge bg-primary-subtle text-primary border mb-1">Đang học</span>
                                    <h3 class="fw-bold mb-0">${activeLesson.title}</h3>
                                </div>
                                <div class="d-flex gap-2">
                                    <form action="${pageContext.request.contextPath}/courses/update-progress" method="POST" class="d-inline">
                                        <input type="hidden" name="registrationId" value="${registrationId}">
                                        <input type="hidden" name="lessonId" value="${activeLesson.id}">
                                        <input type="hidden" name="status" value="COMPLETED">
                                        <button type="submit" class="btn btn-success fw-semibold btn-sm px-3 shadow-sm">
                                            <i class="bi bi-check2-circle me-1"></i>Đánh dấu hoàn thành
                                        </button>
                                    </form>
                                </div>
                            </div>

                            <c:if test="${not empty activeLesson.videoUrl}">
                                <div class="ratio ratio-16x9 mb-4 rounded-3 bg-dark shadow overflow-hidden">
                                    <iframe src="${activeLesson.videoUrl}" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                                </div>
                            </c:if>

                            <!-- Navigation buttons between lessons -->
                            <div class="d-flex justify-content-between align-items-center py-2 px-3 bg-light rounded-3 mb-4 border">
                                <c:choose>
                                    <c:when test="${prevLessonId != null}">
                                        <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registrationId}&lessonId=${prevLessonId}" class="btn btn-outline-secondary btn-sm">
                                            <i class="bi bi-arrow-left me-1"></i>Bài trước
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-outline-secondary btn-sm" disabled><i class="bi bi-arrow-left me-1"></i>Bài trước</button>
                                    </c:otherwise>
                                </c:choose>

                                <span class="small text-muted fw-semibold">Điều hướng bài học</span>

                                <c:choose>
                                    <c:when test="${nextLessonId != null}">
                                        <a href="${pageContext.request.contextPath}/courses/learn?registrationId=${registrationId}&lessonId=${nextLessonId}" class="btn btn-primary btn-sm">
                                            Bài kế tiếp <i class="bi bi-arrow-right ms-1"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-secondary btn-sm" disabled>Đã hết bài <i class="bi bi-check2 ms-1"></i></button>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <c:if test="${not empty activeLesson.documentUrl}">
                                <div class="alert alert-info py-2 px-3 small d-flex justify-content-between align-items-center mb-4">
                                    <span><i class="bi bi-file-earmark-arrow-down me-1"></i>Tài liệu đính kèm bài giảng</span>
                                    <a href="${activeLesson.documentUrl}" target="_blank" class="btn btn-info btn-sm text-white fw-semibold">
                                        <i class="bi bi-box-arrow-up-right me-1"></i>Mở tài liệu
                                    </a>
                                </div>
                            </c:if>

                            <div class="lesson-content lh-lg">
                                <h5 class="fw-bold mb-3"><i class="bi bi-journal-text text-primary me-2"></i>Ghi chú bài học</h5>
                                ${activeLesson.content != null ? activeLesson.content : "<p class='text-muted'>Bài học này chủ yếu tập trung qua video hướng dẫn trực tiếp ở trên.</p>"}
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card p-5 text-center border-0 shadow-sm rounded-3">
                            <i class="bi bi-play-circle fs-1 text-primary mb-3"></i>
                            <h4 class="fw-bold">Chào mừng bạn đến với khóa học!</h4>
                            <p class="text-muted">Vui lòng chọn một bài học trong danh sách bên trái để bắt đầu học.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<script>
    function filterLearningLessons() {
        const input = document.getElementById('learnLessonFilter').value.toLowerCase().trim();
        const items = document.querySelectorAll('#learnLessonList .learn-item');
        items.forEach(function(item) {
            const title = item.getAttribute('data-title') || '';
            if (!input || title.includes(input)) {
                item.style.display = '';
            } else {
                item.style.display = 'none';
            }
        });
    }
</script>

<jsp:include page="../common/footer.jsp" />
