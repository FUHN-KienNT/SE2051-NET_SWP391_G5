<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer class="cf-footer mt-auto">
    <div class="container py-2.5" style="padding-top: 0.75rem; padding-bottom: 0.75rem;">
        <div class="row g-2 align-items-center justify-content-between">
            <div class="col-md-7 col-lg-8">
                <div class="d-flex align-items-center gap-2 mb-1 flex-wrap">
                    <a class="cf-footer-brand d-inline-flex align-items-center gap-1.5 text-decoration-none" 
                       href="${pageContext.request.contextPath}/home">
                        <svg width="24" height="17" viewBox="0 0 38 26" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M31.2 10.9C30.4 5.5 25.8 1.4 20.2 1.4C15.6 1.4 11.5 4.3 9.9 8.5C9.2 8.2 8.4 8.0 7.6 8.0C3.4 8.0 0 11.4 0 15.6C0 19.8 3.4 23.2 7.6 23.2H30.9C34.8 23.2 38 20.0 38 16.1C38 12.5 35.1 9.5 31.2 10.9Z" fill="url(#cfFootGrad)" />
                            <path d="M22.5 1.5C21.7 1.4 21.0 1.4 20.2 1.4C15.6 1.4 11.5 4.3 9.9 8.5C10.7 8.5 11.5 8.7 12.3 9.0C13.5 5.8 16.6 3.5 20.2 3.5C23.2 3.5 25.8 4.9 27.5 7.1C26.1 4.5 24.5 2.6 22.5 1.5Z" fill="#FAAD3F" />
                            <defs>
                                <linearGradient id="cfFootGrad" x1="0" y1="0" x2="38" y2="24" gradientUnits="userSpaceOnUse">
                                    <stop stop-color="#FAAD3F" />
                                    <stop offset="0.45" stop-color="#F38020" />
                                    <stop offset="1" stop-color="#E56B00" />
                                </linearGradient>
                            </defs>
                        </svg>
                        <span class="cf-footer-brand-name">COURSON<span>.</span></span>
                        <span class="cf-footer-brand-tag">LMS</span>
                    </a>
                    <span class="text-muted d-none d-sm-inline" style="font-size: 0.75rem;">&bull; Hệ thống quản lý học tập</span>
                </div>
                <div class="cf-footer-copy" style="font-size: 0.78rem;">
                    &copy; 2026 <strong>Courson LMS</strong>. Tất cả các quyền được bảo lưu.
                </div>
            </div>

            <div class="col-md-5 col-lg-4 text-md-end">
                <div class="d-flex justify-content-md-end gap-3 flex-wrap">
                    <a href="${pageContext.request.contextPath}/home" class="cf-footer-link">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/courses/catalog" class="cf-footer-link">Khóa học</a>
                </div>
            </div>
        </div>
    </div>
</footer>

<style>
    .cf-footer {
        background-color: #F5EFEB;
        border-top: 1px solid #E6DDD4;
    }

    .cf-footer-brand-name {
        font-weight: 800;
        font-size: 1.05rem;
        letter-spacing: -0.5px;
        color: #111827; 
        line-height: 1;
    }

    .cf-footer-brand-name span {
        color: #F38020;
    }

    .cf-footer-brand-tag {
        font-size: 9px;
        font-weight: 700;
        background: #FFF5EB;
        color: #F38020;
        border: 1px solid #FCD5B5;
        padding: 0 4px;
        border-radius: 4px;
        letter-spacing: 0.5px;
        margin-left: 4px;
        vertical-align: middle;
    }

    .cf-footer-link {
        font-size: 0.8rem;
        font-weight: 600;
        color: #4b5563;
        text-decoration: none;
        transition: color 0.15s ease;
    }

    .cf-footer-link:hover {
        color: #F38020;
    }

    .cf-footer-copy {
        color: #6B7280;
    }
</style>

<!-- Universal Confirmation Modal (Thay thế hoàn toàn window.confirm mặc định) -->
<div class="modal fade" id="coursonConfirmModal" tabindex="-1" aria-labelledby="coursonConfirmTitle" aria-hidden="true" style="z-index: 1065;">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 420px;">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-body text-center p-4">
                <div id="coursonConfirmIconWrapper" class="rounded-circle d-inline-flex align-items-center justify-content-center mb-3 bg-danger-subtle text-danger"
                    style="width: 60px; height: 60px; font-size: 1.6rem; transition: all 0.2s ease;">
                    <i id="coursonConfirmIcon" class="bi bi-trash3-fill"></i>
                </div>
                <h5 class="fw-bold text-dark mb-2" id="coursonConfirmTitle">Xác nhận thao tác</h5>
                <div class="small text-muted mb-4" id="coursonConfirmMessage">
                    Bạn có chắc chắn muốn thực hiện thao tác này?
                </div>
                <div class="d-flex justify-content-center gap-2">
                    <button type="button" class="btn btn-light border btn-sm fw-semibold rounded-3 px-3 py-2" data-bs-dismiss="modal" id="coursonConfirmCancelBtn">
                        Hủy bỏ
                    </button>
                    <a href="javascript:void(0)" id="coursonConfirmActionBtn" class="btn btn-danger btn-sm fw-semibold rounded-3 px-3.5 py-2 text-decoration-none">
                        <i class="bi bi-trash3 me-1" id="coursonConfirmActionIcon"></i>
                        <span id="coursonConfirmActionText">Xác nhận xóa</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function(global) {
        'use strict';
        global.showConfirmModal = function(options) {
            const modalEl = document.getElementById('coursonConfirmModal');
            if (!modalEl || typeof bootstrap === 'undefined') {
                if (confirm(options.message || 'Bạn có chắc chắn muốn tiếp tục?')) {
                    if (typeof options.onConfirm === 'function') options.onConfirm();
                    else if (options.confirmUrl) window.location.href = options.confirmUrl;
                }
                return;
            }

            const titleEl = document.getElementById('coursonConfirmTitle');
            const msgEl = document.getElementById('coursonConfirmMessage');
            const iconWrapper = document.getElementById('coursonConfirmIconWrapper');
            const iconEl = document.getElementById('coursonConfirmIcon');
            const actionBtn = document.getElementById('coursonConfirmActionBtn');
            const actionText = document.getElementById('coursonConfirmActionText');
            const actionIcon = document.getElementById('coursonConfirmActionIcon');

            if (titleEl) titleEl.textContent = options.title || 'Xác nhận thao tác';
            if (msgEl) {
                if (options.html) {
                    msgEl.innerHTML = options.html;
                } else {
                    msgEl.textContent = options.message || 'Bạn có chắc chắn muốn thực hiện thao tác này?';
                }
            }

            const type = options.type || 'danger';
            if (iconWrapper && iconEl) {
                iconWrapper.className = 'rounded-circle d-inline-flex align-items-center justify-content-center mb-3 ';
                if (type === 'danger') {
                    iconWrapper.classList.add('bg-danger-subtle', 'text-danger');
                    iconEl.className = options.icon || 'bi bi-trash3-fill';
                } else if (type === 'warning') {
                    iconWrapper.classList.add('bg-warning-subtle', 'text-warning');
                    iconEl.className = options.icon || 'bi bi-exclamation-triangle-fill';
                } else if (type === 'success') {
                    iconWrapper.classList.add('bg-success-subtle', 'text-success');
                    iconEl.className = options.icon || 'bi bi-check-circle-fill';
                } else {
                    iconWrapper.classList.add('bg-primary-subtle', 'text-primary');
                    iconEl.className = options.icon || 'bi bi-info-circle-fill';
                }
            }

            if (actionText) actionText.textContent = options.confirmText || 'Xác nhận';
            if (actionIcon) actionIcon.className = options.confirmIcon || (type === 'danger' ? 'bi bi-trash3 me-1' : 'bi bi-check-lg me-1');

            if (actionBtn) {
                let btnClass = options.confirmBtnClass;
                if (!btnClass) {
                    btnClass = (type === 'danger' ? 'btn-danger' : (type === 'warning' ? 'btn-warning' : (type === 'success' ? 'btn-success' : 'btn-primary')));
                }
                actionBtn.className = 'btn btn-sm fw-semibold rounded-3 px-3.5 py-2 text-decoration-none ' + btnClass;

                // Clone button to remove previous event listeners
                const newBtn = actionBtn.cloneNode(true);
                actionBtn.parentNode.replaceChild(newBtn, actionBtn);

                newBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const modalInst = bootstrap.Modal.getInstance(modalEl);
                    if (modalInst) modalInst.hide();

                    if (typeof options.onConfirm === 'function') {
                        options.onConfirm();
                    } else if (options.confirmUrl) {
                        window.location.href = options.confirmUrl;
                    }
                });
            }

            const modalInstance = bootstrap.Modal.getOrCreateInstance(modalEl);
            modalInstance.show();
        };

        // Helper tiện ích xóa bài học / đối tượng
        global.confirmDeleteAction = function(targetName, deleteUrl, targetType) {
            targetType = targetType || 'bài học';
            global.showConfirmModal({
                title: 'Xác nhận xóa ' + targetType,
                html: 'Bạn có chắc chắn muốn xóa ' + targetType + ' "<strong>' + (targetName || '') + '</strong>"?<br><span class="text-danger small mt-1 d-inline-block"><i class="bi bi-exclamation-triangle me-1"></i>Thao tác này sẽ xóa vĩnh viễn và không thể hoàn tác.</span>',
                type: 'danger',
                icon: 'bi bi-trash3-fill',
                confirmText: 'Xóa ' + targetType,
                confirmIcon: 'bi bi-trash3 me-1',
                confirmBtnClass: 'btn-danger',
                confirmUrl: deleteUrl
            });
        };
    })(window);
</script>
</body>
</html>