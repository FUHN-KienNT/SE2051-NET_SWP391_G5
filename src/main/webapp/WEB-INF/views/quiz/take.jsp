<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Làm bài kiểm tra - ${quiz.title}" />
<jsp:include page="../common/header.jsp" />

<style>
    /* Courson Quiz Taking Styles */
    :root {
        --cf-orange: #F38020;
        --cf-orange-hover: #E56B00;
        --cf-orange-light: #FFF5EB;
        --cf-orange-border: #FCD5B5;
    }

    .question-block {
        scroll-margin-top: 85px;
        transition: border-color 0.25s ease, box-shadow 0.25s ease;
    }

    .question-block.highlight-target {
        border-color: var(--cf-orange) !important;
        box-shadow: 0 0 0 3px rgba(243, 128, 32, 0.25) !important;
    }

    /* Option Card Styling */
    .quiz-option-card {
        cursor: pointer;
        transition: all 0.18s ease-in-out;
        border: 1.5px solid #e2e8f0;
        background-color: #f8fafc;
        user-select: none;
    }

    .quiz-option-card:hover {
        background-color: #f1f5f9;
        border-color: #cbd5e1;
        transform: translateY(-1px);
    }

    .quiz-option-card.selected {
        background-color: #fff8f3 !important;
        border-color: var(--cf-orange) !important;
        box-shadow: 0 0 0 1px var(--cf-orange);
    }

    .quiz-option-card .form-check-input {
        cursor: pointer;
        width: 1.25rem;
        height: 1.25rem;
        margin-top: 0;
    }

    .quiz-option-card .form-check-input:checked {
        background-color: var(--cf-orange);
        border-color: var(--cf-orange);
    }

    /* Navigator Pills */
    .q-nav-pill {
        width: 40px;
        height: 38px;
        font-weight: 600;
        font-size: 0.88rem;
        transition: all 0.18s ease;
    }

    .q-nav-pill.answered {
        background-color: var(--cf-orange) !important;
        border-color: var(--cf-orange) !important;
        color: #fff !important;
    }

    .q-nav-pill.nav-pill-active {
        box-shadow: 0 0 0 3px rgba(30, 41, 59, 0.35) !important;
        transform: scale(1.08);
    }

    /* Timer Urgency Animations */
    @keyframes pulseDanger {
        0%, 100% { transform: scale(1); opacity: 1; }
        50% { transform: scale(1.04); opacity: 0.85; }
    }

    .timer-danger {
        animation: pulseDanger 1.2s infinite ease-in-out;
    }

    /* Mobile Sticky Bar */
    .mobile-quiz-bar {
        position: sticky;
        top: 64px;
        z-index: 1020;
        background: rgba(255, 255, 255, 0.98);
        backdrop-filter: blur(8px);
        border-bottom: 1px solid #e2e8f0;
    }
</style>

<!-- MOBILE TOP STATUS BAR (chỉ hiển thị trên thiết bị nhỏ < lg) -->
<div class="mobile-quiz-bar d-lg-none py-2 px-3 shadow-sm mb-3">
    <div class="container d-flex justify-content-between align-items-center">
        <c:choose>
            <c:when test="${quiz.timeLimitMinutes != null && quiz.timeLimitMinutes > 0}">
                <div class="badge bg-light text-dark border px-3 py-2 d-inline-flex align-items-center gap-1.5 fs-6" id="mobileTimerBadge">
                    <i class="bi bi-stopwatch text-danger"></i>
                    <span id="mobileCountdownDisplay" class="fw-bold font-monospace">--:--</span>
                </div>
            </c:when>
            <c:otherwise>
                <span class="badge bg-light text-muted border px-2 py-1 small">
                    <i class="bi bi-infinity me-1"></i>Không giới hạn
                </span>
            </c:otherwise>
        </c:choose>

        <div class="d-flex align-items-center gap-2">
            <span class="badge bg-secondary-subtle text-secondary border small">
                Đã làm <strong id="mobileAnsweredCount">0</strong>/${quiz.questions != null ? quiz.questions.size() : 0}
            </span>
            <button type="button" class="btn btn-sm btn-primary fw-semibold" onclick="openSubmitModal();">
                <i class="bi bi-send-check me-1"></i>Nộp bài
            </button>
        </div>
    </div>
</div>

<!-- OFFLINE WARNING BANNER -->
<div class="container mt-2">
    <div id="offlineAlert" class="alert alert-danger shadow-sm text-center py-2 mb-0 rounded-3" style="display: none;">
        <i class="bi bi-wifi-off me-1.5 fw-bold"></i>
        <strong>Mất kết nối Internet!</strong> Bài làm vẫn đang được lưu an toàn trên trình duyệt. Vui lòng kiểm tra lại kết nối mạng trước khi nộp bài.
    </div>
</div>

<main class="main-content py-3 py-lg-4">
    <div class="container">
        <form id="quizForm" action="${pageContext.request.contextPath}/quizzes/submit" method="POST">
            <input type="hidden" name="attemptId" value="${attempt.id}">
            <input type="hidden" name="registrationId" value="${attempt.registrationId}">
            <input type="hidden" name="quizId" value="${attempt.quizId}">

            <div class="row g-4">
                <!-- ==========================================
                     1. CỘT TRÁI: DANH SÁCH CÂU HỎI
                     ========================================== -->
                <div class="col-lg-8">
                    <!-- QUIZ TITLE (TẬP TRUNG, TINH GỌN, KHÔNG THÔNG TIN TRÙNG LẶP) -->
                    <div class="mb-3 pb-2 border-bottom">
                        <h4 class="fw-bold mb-0 text-dark">${quiz.title}</h4>
                    </div>

                    <!-- QUESTIONS LIST -->
                    <c:forEach var="q" items="${quiz.questions}" varStatus="status">
                        <input type="hidden" name="questionId" value="${q.id}">
                        <div class="card p-3 p-md-4 mb-3.5 bg-white border rounded-3 shadow-sm question-block" id="q_card_${q.id}" data-qid="${q.id}">
                            <!-- Question Header -->
                            <div class="d-flex justify-content-between align-items-start mb-3 pb-2 border-bottom">
                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                    <span class="badge bg-dark text-white rounded-pill px-2.5 py-1 small fw-semibold">
                                        Câu ${status.count}
                                    </span>
                                    <c:choose>
                                        <c:when test="${q.questionType == 'MULTI_CHOICE'}">
                                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle small">
                                                <i class="bi bi-ui-checks me-1"></i>Chọn nhiều đáp án
                                            </span>
                                        </c:when>
                                        <c:when test="${q.questionType == 'TRUE_FALSE'}">
                                            <span class="badge bg-secondary-subtle text-secondary border small">
                                                <i class="bi bi-check2-circle me-1"></i>Đúng / Sai
                                            </span>
                                        </c:when>
                                    </c:choose>
                                </div>

                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge bg-light text-secondary border small">
                                        ${q.assignedPoints != null ? q.assignedPoints : q.defaultPoints} đ
                                    </span>
                                    <button type="button" class="btn btn-sm btn-link text-muted text-decoration-none p-0 ms-1 small" 
                                            title="Xóa lựa chọn của câu này" onclick="clearQuestionAnswer('${q.id}');">
                                        <i class="bi bi-arrow-counterclockwise"></i> Bỏ chọn
                                    </button>
                                </div>
                            </div>

                            <!-- Question Text -->
                            <h6 class="fw-semibold text-dark lh-base mb-3" style="font-size: 1.02rem;">
                                ${q.questionText}
                            </h6>

                            <c:if test="${q.questionType == 'MULTI_CHOICE'}">
                                <div class="text-muted small mb-2 fst-italic">
                                    <i class="bi bi-info-circle me-1"></i>Lưu ý: Có thể chọn một hoặc nhiều phương án đúng.
                                </div>
                            </c:if>

                            <!-- Options List -->
                            <div class="d-flex flex-column gap-2">
                                <c:forEach var="opt" items="${q.options}">
                                    <label class="quiz-option-card d-flex align-items-center p-3 rounded-3" for="opt_${opt.id}">
                                        <c:choose>
                                            <c:when test="${q.questionType == 'MULTI_CHOICE'}">
                                                <input class="form-check-input flex-shrink-0 me-3 quiz-option-input" type="checkbox"
                                                    name="question_${q.id}" id="opt_${opt.id}"
                                                    value="${opt.id}" data-qid="${q.id}">
                                            </c:when>
                                            <c:otherwise>
                                                <input class="form-check-input flex-shrink-0 me-3 quiz-option-input" type="radio"
                                                    name="question_${q.id}" id="opt_${opt.id}"
                                                    value="${opt.id}" data-qid="${q.id}">
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="option-label text-dark flex-grow-1 lh-sm" style="font-size: 0.95rem;">
                                            ${opt.optionText}
                                        </div>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- ==========================================
                     2. CỘT PHẢI: QUESTION NAVIGATOR & TIMER (STICKY)
                     ========================================== -->
                <div class="col-lg-4">
                    <div class="card shadow-sm border-0 rounded-3 p-3 p-md-4 sticky-top bg-white" style="top: 84px; z-index: 10;">
                        <!-- COUNTDOWN TIMER -->
                        <c:choose>
                            <c:when test="${quiz.timeLimitMinutes != null && quiz.timeLimitMinutes > 0}">
                                <div class="text-center mb-3 pb-3 border-bottom">
                                    <small class="text-muted d-block mb-1 text-uppercase fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.5px;">
                                        Thời gian còn lại
                                    </small>
                                    <div class="badge bg-light text-dark border border-2 fs-3 px-4 py-2 shadow-sm d-inline-flex align-items-center gap-2 rounded-3" id="timerBadge">
                                        <i class="bi bi-stopwatch text-danger" id="timerIcon"></i>
                                        <span id="countdownDisplay" class="font-monospace fw-bold">--:--</span>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center mb-3 pb-3 border-bottom">
                                    <small class="text-muted d-block mb-1 text-uppercase fw-semibold" style="font-size: 0.75rem;">Thời gian làm bài</small>
                                    <span class="badge bg-light text-secondary border px-3 py-2 fs-6">
                                        <i class="bi bi-infinity me-1"></i>Không giới hạn
                                    </span>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- PROGRESS COUNTER -->
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fw-semibold text-dark small">Tiến độ bài làm:</span>
                            <span class="badge bg-light text-dark border fs-6 px-2.5 py-1">
                                <span id="answeredCount" class="text-primary fw-bold">0</span> / ${quiz.questions != null ? quiz.questions.size() : 0} câu
                            </span>
                        </div>
                        <div class="progress mb-3" style="height: 8px;">
                            <div class="progress-bar bg-primary" id="progressBar" role="progressbar" style="width: 0%;"></div>
                        </div>

                        <!-- QUESTION PALETTE / NAVIGATOR -->
                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <small class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem;">Mục lục câu hỏi:</small>
                                <span class="badge bg-light text-muted border" style="font-size: 0.72rem;">
                                    <span class="text-primary fw-bold" id="completionRate">0%</span>
                                </span>
                            </div>

                            <div class="d-flex flex-wrap gap-2" id="questionNavigator" style="max-height: 280px; overflow-y: auto; padding: 2px;">
                                <c:forEach var="q" items="${quiz.questions}" varStatus="status">
                                    <button type="button" class="btn btn-sm btn-outline-secondary q-nav-pill rounded-2"
                                            id="nav_pill_${q.id}" data-qid="${q.id}"
                                            onclick="scrollToQuestion('${q.id}');">
                                        ${status.count}
                                    </button>
                                </c:forEach>
                            </div>

                            <!-- Legend -->
                            <div class="d-flex align-items-center gap-3 mt-3 pt-2 border-top text-muted small" style="font-size: 0.78rem;">
                                <div class="d-flex align-items-center gap-1.5">
                                    <span class="badge bg-outline-secondary border text-muted" style="width: 14px; height: 14px; padding: 0;"> </span>
                                    <span>Chưa làm</span>
                                </div>
                                <div class="d-flex align-items-center gap-1.5">
                                    <span class="badge rounded" style="width: 14px; height: 14px; padding: 0; background-color: var(--cf-orange);"> </span>
                                    <span>Đã làm</span>
                                </div>
                            </div>
                        </div>

                        <!-- ACTIONS -->
                        <div class="d-grid gap-2">
                            <button type="button" id="btnSubmitQuiz" class="btn btn-primary btn-lg fw-semibold shadow-sm py-2.5" onclick="openSubmitModal();">
                                <i class="bi bi-send-check me-1.5"></i>Nộp bài kiểm tra
                            </button>
                            <button type="button" class="btn btn-outline-secondary py-2" onclick="openExitModal();">
                                <i class="bi bi-box-arrow-left me-1.5"></i>Thoát bài thi
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>

<!-- ==========================================
     3. BOOTSTRAP MODALS CHO SUBMIT & EXIT
     ========================================== -->
<!-- Modal xác nhận nộp bài -->
<div class="modal fade" id="submitConfirmModal" tabindex="-1" aria-labelledby="submitModalLabel" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow rounded-4">
            <div class="modal-body p-4 text-center">
                <div class="mb-3">
                    <span class="d-inline-flex align-items-center justify-content-center rounded-circle" id="submitModalIconWrap"
                          style="width: 64px; height: 64px; background-color: #FFF5EB;">
                        <i class="bi bi-patch-question fs-1" id="submitModalIcon" style="color: var(--cf-orange);"></i>
                    </span>
                </div>
                <h5 class="fw-bold text-dark mb-2" id="submitModalLabel">Xác nhận nộp bài thi</h5>
                <p class="text-muted small mb-3" id="submitModalDesc">
                    Bạn có chắc chắn muốn nộp bài kiểm tra ngay bây giờ?
                </p>

                <!-- Thống kê câu hỏi -->
                <div class="alert alert-light border rounded-3 p-3 text-start mb-3" id="submitModalStats">
                    <div class="d-flex justify-content-between mb-1.5">
                        <span class="text-muted small">Số câu đã hoàn thành:</span>
                        <strong class="text-primary" id="modalAnsweredStat">0 / 0</strong>
                    </div>
                    <div id="unansweredAlertBox" style="display: none;">
                        <div class="text-danger small fw-semibold mt-2 pt-2 border-top">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i>Các câu chưa trả lời:
                        </div>
                        <div class="d-flex flex-wrap gap-1.5 mt-1.5" id="unansweredList"></div>
                    </div>
                </div>

                <div class="d-flex gap-2 justify-content-end">
                    <button type="button" class="btn btn-light px-3 py-2 border rounded-3" data-bs-dismiss="modal">
                        Kiểm tra lại
                    </button>
                    <button type="button" class="btn btn-primary px-4 py-2 rounded-3 fw-semibold shadow-sm" id="btnConfirmSubmit" onclick="executeSubmit();">
                        <i class="bi bi-check2-circle me-1"></i>Xác nhận nộp bài
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal xác nhận thoát bài thi -->
<div class="modal fade" id="exitConfirmModal" tabindex="-1" aria-labelledby="exitModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow rounded-4">
            <div class="modal-body p-4 text-center">
                <div class="mb-3">
                    <span class="d-inline-flex align-items-center justify-content-center rounded-circle bg-danger-subtle text-danger" style="width: 60px; height: 60px;">
                        <i class="bi bi-exclamation-octagon fs-2"></i>
                    </span>
                </div>
                <h5 class="fw-bold text-dark mb-2" id="exitModalLabel">Rời khỏi bài kiểm tra?</h5>
                <p class="text-muted small mb-4">
                    Tiến trình làm bài hiện tại sẽ không được nộp để chấm điểm. Bạn có chắc chắn muốn thoát về trang tổng quan?
                </p>
                <div class="d-flex gap-2 justify-content-center">
                    <button type="button" class="btn btn-light px-3.5 py-2 border rounded-3" data-bs-dismiss="modal">
                        Tiếp tục làm bài
                    </button>
                    <button type="button" class="btn btn-outline-danger px-4 py-2 rounded-3 fw-semibold" onclick="executeExit();">
                        <i class="bi bi-box-arrow-left me-1"></i>Thoát bài thi
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal hết giờ tự động nộp -->
<div class="modal fade" id="timeUpModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow rounded-4 text-center p-4">
            <div class="mb-3">
                <span class="d-inline-flex align-items-center justify-content-center rounded-circle bg-warning-subtle text-warning-emphasis" style="width: 68px; height: 68px;">
                    <i class="bi bi-alarm fs-1"></i>
                </span>
            </div>
            <h4 class="fw-bold text-dark mb-2">Đã hết thời gian làm bài!</h4>
            <p class="text-muted small mb-4">
                Thời gian quy định cho bài thi đã kết thúc. Hệ thống đang tiến hành nộp bài tự động...
            </p>
            <div class="d-flex justify-content-center">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Đang nộp...</span>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
(function() {
    const quizId = '${attempt.quizId}';
    const regId = '${attempt.registrationId}';
    const totalQuestions = ${quiz.questions != null ? quiz.questions.size() : 0};
    const storageKey = 'courson_quiz_answers_' + quizId + '_' + regId;
    const timerKey = 'courson_quiz_timer_' + quizId + '_' + regId;
    const form = document.getElementById('quizForm');
    const urlParams = new URLSearchParams(window.location.search);
    const isRetake = urlParams.get('retake') === 'true';

    let isSubmitting = false;

    // 1. NẾU LÀ RETAKE CHỦ ĐỘNG TỪ OVERVIEW -> XÓA SẠCH DRAFT CŨ
    if (isRetake) {
        localStorage.removeItem(storageKey);
        localStorage.removeItem(timerKey);
    }

    // 2. KHÔI PHỤC ĐÁP ÁN ĐÃ LÀM TỪ LOCAL STORAGE (CHỐNG MẤT DỮ LIỆU KHI F5)
    function restoreAnswers() {
        const saved = localStorage.getItem(storageKey);
        if (!saved) return;
        try {
            const answersMap = JSON.parse(saved);
            for (const qId in answersMap) {
                const optIds = answersMap[qId];
                if (Array.isArray(optIds)) {
                    optIds.forEach(optId => {
                        const input = document.getElementById('opt_' + optId);
                        if (input) {
                            input.checked = true;
                        }
                    });
                }
            }
        } catch (e) {
            console.error('Lỗi khôi phục câu trả lời từ localStorage', e);
        }
    }

    // 3. THU THẬP VÀ LƯU VÀO LOCAL STORAGE + CẬP NHẬT NAVIGATOR & CARD STATE
    function saveAnswersAndUpdateNav() {
        const answersMap = {};
        let answeredCount = 0;

        document.querySelectorAll('.question-block').forEach(block => {
            const qId = block.getAttribute('data-qid');
            const checkedInputs = block.querySelectorAll('.quiz-option-input:checked');
            const pill = document.getElementById('nav_pill_' + qId);

            // Cập nhật class selected cho từng option card
            block.querySelectorAll('.quiz-option-card').forEach(card => {
                const inp = card.querySelector('.quiz-option-input');
                if (inp && inp.checked) {
                    card.classList.add('selected');
                } else {
                    card.classList.remove('selected');
                }
            });

            if (checkedInputs.length > 0) {
                answeredCount++;
                answersMap[qId] = Array.from(checkedInputs).map(i => i.value);
                if (pill) {
                    pill.classList.remove('btn-outline-secondary');
                    pill.classList.add('answered');
                }
            } else {
                if (pill) {
                    pill.classList.remove('answered');
                    pill.classList.add('btn-outline-secondary');
                }
            }
        });

        localStorage.setItem(storageKey, JSON.stringify(answersMap));

        // Cập nhật text số lượng và thanh progress
        const answeredEl = document.getElementById('answeredCount');
        if (answeredEl) answeredEl.innerText = answeredCount;
        const mobileAnsweredEl = document.getElementById('mobileAnsweredCount');
        if (mobileAnsweredEl) mobileAnsweredEl.innerText = answeredCount;

        if (totalQuestions > 0) {
            const pct = Math.round((answeredCount / totalQuestions) * 100);
            const progressBar = document.getElementById('progressBar');
            if (progressBar) progressBar.style.width = pct + '%';
            const compRate = document.getElementById('completionRate');
            if (compRate) compRate.innerText = pct + '%';
        }

        return answeredCount;
    }

    // Gắn sự kiện change cho tất cả radio/checkbox
    document.querySelectorAll('.quiz-option-input').forEach(input => {
        input.addEventListener('change', saveAnswersAndUpdateNav);
    });

    // Bỏ chọn toàn bộ lựa chọn trong 1 câu hỏi
    window.clearQuestionAnswer = function(qId) {
        const block = document.getElementById('q_card_' + qId);
        if (!block) return;
        block.querySelectorAll('.quiz-option-input').forEach(inp => {
            inp.checked = false;
        });
        saveAnswersAndUpdateNav();
    };

    // 4. ĐỒNG HỒ ĐẾM NGƯỢC ĐỒNG BỘ TỪ SERVER (SERVER-ANCHORED COUNTDOWN)
    <c:if test="${quiz.timeLimitMinutes != null && quiz.timeLimitMinutes > 0}">
    const serverRemainingSeconds = ${attempt.remainingSeconds != null ? attempt.remainingSeconds : (quiz.timeLimitMinutes * 60)};
    const targetEndTime = Date.now() + (serverRemainingSeconds * 1000);
    localStorage.setItem(timerKey, targetEndTime);

    const displayEl = document.getElementById('countdownDisplay');
    const mobileDisplayEl = document.getElementById('mobileCountdownDisplay');
    const timerBadge = document.getElementById('timerBadge');
    const mobileTimerBadge = document.getElementById('mobileTimerBadge');
    const timerIcon = document.getElementById('timerIcon');

    function updateTimer() {
        const remainingMs = targetEndTime - Date.now();
        const remainingSec = Math.floor(remainingMs / 1000);

        if (remainingSec <= 0) {
            if (displayEl) displayEl.innerText = '00:00';
            if (mobileDisplayEl) mobileDisplayEl.innerText = '00:00';
            isSubmitting = true;
            localStorage.removeItem(timerKey);

            // Mở modal hết giờ và submit tự động
            try {
                const timeUpEl = document.getElementById('timeUpModal');
                if (timeUpEl && window.bootstrap) {
                    const m = new bootstrap.Modal(timeUpEl);
                    m.show();
                }
            } catch (ignored) {}

            setTimeout(() => {
                form.submit();
            }, 1200);
            return;
        }

        const m = Math.floor(remainingSec / 60);
        const s = remainingSec % 60;
        const formatted = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;

        if (displayEl) displayEl.innerText = formatted;
        if (mobileDisplayEl) mobileDisplayEl.innerText = formatted;

        // Trạng thái khẩn cấp: <= 60 giây (Đỏ nhấp nháy), <= 5 phút (Vàng)
        if (remainingSec <= 60) {
            if (timerBadge) {
                timerBadge.className = 'badge bg-danger text-white border border-danger fs-3 px-4 py-2 shadow-sm d-inline-flex align-items-center gap-2 rounded-3 timer-danger';
            }
            if (mobileTimerBadge) {
                mobileTimerBadge.className = 'badge bg-danger text-white border px-3 py-2 d-inline-flex align-items-center gap-1.5 fs-6 timer-danger';
            }
            if (timerIcon) timerIcon.className = 'bi bi-stopwatch text-white';
        } else if (remainingSec <= 300) {
            if (timerBadge) {
                timerBadge.className = 'badge bg-warning-subtle text-dark border border-warning fs-3 px-4 py-2 shadow-sm d-inline-flex align-items-center gap-2 rounded-3';
            }
            if (mobileTimerBadge) {
                mobileTimerBadge.className = 'badge bg-warning-subtle text-dark border border-warning px-3 py-2 d-inline-flex align-items-center gap-1.5 fs-6';
            }
            if (timerIcon) timerIcon.className = 'bi bi-stopwatch text-warning-emphasis';
        } else {
            if (timerBadge) {
                timerBadge.className = 'badge bg-light text-dark border border-2 fs-3 px-4 py-2 shadow-sm d-inline-flex align-items-center gap-2 rounded-3';
            }
            if (mobileTimerBadge) {
                mobileTimerBadge.className = 'badge bg-light text-dark border px-3 py-2 d-inline-flex align-items-center gap-1.5 fs-6';
            }
            if (timerIcon) timerIcon.className = 'bi bi-stopwatch text-danger';
        }
    }

    updateTimer();
    const timerInterval = setInterval(updateTimer, 1000);
    </c:if>

    // 5. CUỘN NHANH ĐẾN CÂU HỎI KHI BẤM NAV PILL
    window.scrollToQuestion = function(qId) {
        const target = document.getElementById('q_card_' + qId);
        if (target) {
            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            target.classList.add('highlight-target');
            setTimeout(() => target.classList.remove('highlight-target'), 1600);
        }
    };

    // 6. INTERSECTION OBSERVER ĐỂ HIGHLIGHT PILL ĐANG XEM
    if ('IntersectionObserver' in window) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const qId = entry.target.getAttribute('data-qid');
                    document.querySelectorAll('.q-nav-pill').forEach(p => p.classList.remove('nav-pill-active'));
                    const activePill = document.getElementById('nav_pill_' + qId);
                    if (activePill) activePill.classList.add('nav-pill-active');
                }
            });
        }, { rootMargin: '-90px 0px -55% 0px' });

        document.querySelectorAll('.question-block').forEach(el => observer.observe(el));
    }

    // 7. XÁC NHẬN NỘP BÀI (MỞ BOOTSTRAP MODAL VÀ THỐNG KÊ CHI TIẾT)
    window.openSubmitModal = function() {
        const answered = saveAnswersAndUpdateNav();
        const statEl = document.getElementById('modalAnsweredStat');
        if (statEl) statEl.innerText = answered + ' / ' + totalQuestions + ' câu';

        const unansweredBox = document.getElementById('unansweredAlertBox');
        const unansweredList = document.getElementById('unansweredList');
        const icon = document.getElementById('submitModalIcon');
        const iconWrap = document.getElementById('submitModalIconWrap');
        const desc = document.getElementById('submitModalDesc');

        const unanswered = [];
        document.querySelectorAll('.question-block').forEach((block, idx) => {
            const hasChecked = block.querySelectorAll('.quiz-option-input:checked').length > 0;
            if (!hasChecked) {
                unanswered.push({ index: idx + 1, qId: block.getAttribute('data-qid') });
            }
        });

        if (unanswered.length === 0) {
            if (iconWrap) iconWrap.style.backgroundColor = '#ecfdf5';
            if (icon) {
                icon.className = 'bi bi-check-circle-fill fs-1 text-success';
            }
            if (desc) desc.innerText = 'Xuất sắc! Bạn đã hoàn thành toàn bộ ' + totalQuestions + ' câu hỏi. Bạn có muốn nộp bài ngay?';
            if (unansweredBox) unansweredBox.style.display = 'none';
        } else {
            if (iconWrap) iconWrap.style.backgroundColor = '#FFF5EB';
            if (icon) {
                icon.className = 'bi bi-exclamation-triangle-fill fs-1 text-warning';
            }
            if (desc) desc.innerText = 'Bạn vẫn còn ' + unanswered.length + ' câu hỏi chưa được trả lời. Bạn có chắc chắn muốn nộp bài?';
            if (unansweredBox) unansweredBox.style.display = 'block';
            if (unansweredList) {
                unansweredList.innerHTML = '';
                unanswered.forEach(item => {
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'btn btn-xs btn-outline-danger small py-0 px-2 rounded-pill';
                    btn.style.fontSize = '0.78rem';
                    btn.innerText = 'Câu ' + item.index;
                    btn.onclick = function() {
                        const m = bootstrap.Modal.getInstance(document.getElementById('submitConfirmModal'));
                        if (m) m.hide();
                        scrollToQuestion(item.qId);
                    };
                    unansweredList.appendChild(btn);
                });
            }
        }

        const modalEl = document.getElementById('submitConfirmModal');
        if (modalEl && window.bootstrap) {
            const modal = new bootstrap.Modal(modalEl);
            modal.show();
        } else {
            // Fallback nếu modal lỗi
            if (confirm('Bạn có chắc chắn muốn nộp bài thi?')) {
                executeSubmit();
            }
        }
    };

    window.executeSubmit = function() {
        isSubmitting = true;
        // Giữ lại storageKey để bảo vệ bài làm nếu mạng rớt; chỉ xóa timer
        localStorage.removeItem(timerKey);
        const btn = document.getElementById('btnConfirmSubmit');
        if (btn) {
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Đang nộp...';
        }
        form.submit();
    };

    // 8. THOÁT BÀI THI AN TOÀN
    window.openExitModal = function() {
        const exitModalEl = document.getElementById('exitConfirmModal');
        if (exitModalEl && window.bootstrap) {
            const m = new bootstrap.Modal(exitModalEl);
            m.show();
        } else {
            if (confirm('Lưu ý: Thoát ra lúc này sẽ không nộp bài. Bạn có chắc chắn muốn thoát?')) {
                executeExit();
            }
        }
    };

    window.executeExit = function() {
        isSubmitting = true;
        localStorage.removeItem(storageKey);
        localStorage.removeItem(timerKey);
        window.location.href = '${pageContext.request.contextPath}/quizzes/overview?registrationId=' + regId + '&quizId=' + quizId;
    };

    // 9. CẢNH BÁO MẤT KẾT NỐI MẠNG (ONLINE/OFFLINE LISTENER)
    window.addEventListener('offline', function() {
        const alertEl = document.getElementById('offlineAlert');
        if (alertEl) alertEl.style.display = 'block';
    });
    window.addEventListener('online', function() {
        const alertEl = document.getElementById('offlineAlert');
        if (alertEl) alertEl.style.display = 'none';
    });

    // 10. CẢNH BÁO VÔ TÌNH THOÁT TRANG (BEFOREUNLOAD)
    window.addEventListener('beforeunload', function(e) {
        if (!isSubmitting) {
            e.preventDefault();
            e.returnValue = '';
        }
    });

    // Khởi chạy khôi phục đáp án khi tải trang
    restoreAnswers();
    saveAnswersAndUpdateNav();
})();
</script>

<jsp:include page="../common/footer.jsp" />
