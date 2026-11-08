function openEditModuleModal(id, title, order) {
        document.getElementById('editModuleId').value = id || '';
        document.getElementById('editModuleTitle').value = title || '';
        document.getElementById('editModuleOrder').value = order || '1';
        new bootstrap.Modal(document.getElementById('editModuleModal')).show();
    }

    function confirmDeleteModule(title, moduleId, lessonCount) {
        if (lessonCount && lessonCount > 0) {
            showConfirmModal({
                title: 'Không thể xóa Chương học',
                html: 'Chương "<strong>' + (title || '') + '</strong>" hiện đang có <strong>' + lessonCount + ' bài học</strong> bên trong.<br><span class="text-danger small mt-2 d-inline-block"><i class="bi bi-exclamation-octagon-fill me-1"></i>Hệ thống không cho phép xóa chương đang chứa bài học. Vui lòng di chuyển hoặc xóa các bài học trước khi xóa chương.</span>',
                type: 'warning',
                icon: 'bi bi-shield-exclamation',
                confirmText: 'Đã hiểu',
                confirmIcon: 'bi bi-check2 me-1',
                confirmBtnClass: 'btn-secondary',
                confirmUrl: null
            });
            return;
        }
        showConfirmModal({
            title: 'Xác nhận xóa chương học',
            method: 'POST',
            html: 'Bạn có chắc chắn muốn xóa chương "<strong>' + (title || '') + '</strong>"?<br><span class="text-danger small mt-2 d-inline-block"><i class="bi bi-exclamation-triangle me-1"></i>Thao tác này sẽ xóa vĩnh viễn chương học và không thể hoàn tác.</span>',
            type: 'danger',
            icon: 'bi bi-trash3-fill',
            confirmText: 'Xóa vĩnh viễn',
            confirmIcon: 'bi bi-trash3 me-1',
            confirmBtnClass: 'btn-danger',
            confirmUrl: (window.CONTEXT_PATH||'')+'/expert/delete-module?courseId=' + (window.COURSE_ID || '') + '&moduleId=' + moduleId
        });
    }

    // ==========================================
    // 1. TẠM ẨN / MỞ HIỂN THỊ (ẨN LÀ ẨN)
    // ==========================================
    function confirmToggleVisibility(lessonId, lessonTitle, willActive) {
        if (willActive) {
            showConfirmModal({
                title: 'Mở hiển thị bài học',
                method: 'POST',
                html: 'Bạn có chắc chắn muốn mở hiển thị bài học "<strong>' + (lessonTitle || '') + '</strong>" cho học viên?',
                type: 'success',
                icon: 'bi bi-eye-fill',
                confirmText: 'Mở hiển thị',
                confirmIcon: 'bi bi-eye me-1',
                confirmBtnClass: 'btn-success',
                confirmUrl: (window.CONTEXT_PATH||'')+'/expert/toggle-lesson-status?courseId=' + (window.COURSE_ID || '') + '&lessonId=' + lessonId + '&active=true'
            });
        } else {
            showConfirmModal({
                title: 'Tạm ẩn bài học',
                method: 'POST',
                html: 'Bạn có chắc chắn muốn tạm ẩn bài học "<strong>' + (lessonTitle || '') + '</strong>" với học viên?<br><span class="text-muted small mt-2 d-inline-block"><i class="bi bi-info-circle me-1"></i>Học viên sẽ không thấy bài học này trong danh sách. Dữ liệu bài học vẫn được giữ nguyên an toàn 100%.</span>',
                type: 'warning',
                icon: 'bi bi-eye-slash-fill',
                confirmText: 'Tạm ẩn',
                confirmIcon: 'bi bi-eye-slash me-1',
                confirmBtnClass: 'btn-warning text-dark',
                confirmUrl: (window.CONTEXT_PATH||'')+'/expert/toggle-lesson-status?courseId=' + (window.COURSE_ID || '') + '&lessonId=' + lessonId + '&active=false'
            });
        }
    }

    function confirmDeleteLesson(lessonId, lessonTitle) {
        showConfirmModal({
            title: 'Xác nhận xóa bài học',
            method: 'POST',
            html: 'Bạn có chắc chắn muốn xóa bài học "<strong>' + (lessonTitle || '') + '</strong>"?<br><span class="text-danger small mt-2 d-inline-block"><i class="bi bi-exclamation-triangle me-1"></i>Thao tác này sẽ xóa vĩnh viễn bài học và không thể hoàn tác.</span>',
            type: 'danger',
            icon: 'bi bi-trash3-fill',
            confirmText: 'Xóa vĩnh viễn',
            confirmIcon: 'bi bi-trash3 me-1',
            confirmBtnClass: 'btn-danger',
            confirmUrl: (window.CONTEXT_PATH||'')+'/expert/delete-lesson?courseId=' + (window.COURSE_ID || '') + '&lessonId=' + lessonId
        });
    }

    // ==========================================
    // 3. KÉO THẢ SẮP XẾP BÀI HỌC (DRAG & DROP REORDERING)
    // ==========================================
    let draggedLesson = null;
    let sourceModuleContainer = null;

    function initLessonDragAndDrop() {
        const lessonItems = document.querySelectorAll('.saas-lesson-item[draggable="true"]');
        const moduleLists = document.querySelectorAll('.module-lesson-list');

        lessonItems.forEach(item => {
            item.addEventListener('dragstart', handleDragStart);
            item.addEventListener('dragend', handleDragEnd);
            item.addEventListener('dragover', handleDragOverItem);
            item.addEventListener('dragleave', handleDragLeaveItem);
            item.addEventListener('drop', handleDropOnItem);
        });

        moduleLists.forEach(list => {
            list.addEventListener('dragover', handleDragOverList);
            list.addEventListener('drop', handleDropOnList);
        });
    }

    function handleDragStart(e) {
        draggedLesson = this;
        sourceModuleContainer = this.closest('.module-lesson-list');
        this.classList.add('dragging');
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/plain', this.dataset.lessonId);
    }

    function handleDragEnd(e) {
        this.classList.remove('dragging');
        document.querySelectorAll('.saas-lesson-item.drag-over').forEach(el => el.classList.remove('drag-over'));
        draggedLesson = null;
        sourceModuleContainer = null;
    }

    function handleDragOverItem(e) {
        if (!draggedLesson || draggedLesson === this)
            return;
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
        this.classList.add('drag-over');
    }

    function handleDragLeaveItem(e) {
        this.classList.remove('drag-over');
    }

    // #m_keotha [TRẠM 1/4 - GIAO DIỆN JS]: Tính tọa độ chuột (rect.top + rect.height/2) chèn trên/dưới, rồi gọi AJAX gửi orderedLessonIds sang Servlet
    function handleDropOnItem(e) {
        if (!draggedLesson || draggedLesson === this)
            return;
        e.preventDefault();
        e.stopPropagation();
        this.classList.remove('drag-over');

        const targetList = this.closest('.module-lesson-list');
        if (!targetList)
            return;

        // Determine if drop is above or below middle of target
        const rect = this.getBoundingClientRect();
        const dropMiddle = rect.top + rect.height / 2;
        if (e.clientY < dropMiddle) {
            targetList.insertBefore(draggedLesson, this);
        } else {
            targetList.insertBefore(draggedLesson, this.nextSibling);
        }

        finalizeReorder(targetList);
    }

    function handleDragOverList(e) {
        if (!draggedLesson)
            return;
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
    }

    function handleDropOnList(e) {
        if (!draggedLesson)
            return;
        e.preventDefault();
        const targetList = this;
        if (!targetList.contains(draggedLesson)) {
            targetList.appendChild(draggedLesson);
        }
        finalizeReorder(targetList);
    }

    function finalizeReorder(targetList) {
        const targetModuleId = targetList.dataset.moduleId;
        if (!targetModuleId)
            return;

        // Re-number badges in target module
        updateModuleBadges(targetList);

        // If moved across modules, also re-number source module
        if (sourceModuleContainer && sourceModuleContainer !== targetList) {
            updateModuleBadges(sourceModuleContainer);
            updateModuleLessonCount(sourceModuleContainer);
        }
        updateModuleLessonCount(targetList);

        // Collect new ordered lesson IDs
        const items = targetList.querySelectorAll('.saas-lesson-item');
        const lessonIds = [];
        items.forEach(it => {
            if (it.dataset.lessonId) {
                lessonIds.push(it.dataset.lessonId);
                it.dataset.moduleId = targetModuleId;
            }
        });

        if (lessonIds.length === 0)
            return;

        // Send AJAX request to reorder endpoint
        const formData = new URLSearchParams();
        formData.append('courseId', window.COURSE_ID || '');
        formData.append('moduleId', targetModuleId);
        lessonIds.forEach(id => formData.append('lessonIds[]', id));

        fetch((window.CONTEXT_PATH||'')+'/expert/reorder-lessons', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: formData.toString()
        })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        showFloatingToast(data.message || 'Đã cập nhật vị trí bài học thành công!', 'success');
                    } else {
                        showFloatingToast(data.message || 'Lỗi cập nhật vị trí bài học.', 'danger');
                    }
                })
                .catch(err => {
                    console.error('Lỗi lưu thứ tự bài học:', err);
                    showFloatingToast('Không thể kết nối máy chủ để lưu thứ tự bài học.', 'danger');
                });
    }

    function updateModuleBadges(listContainer) {
        if (!listContainer)
            return;
        const badges = listContainer.querySelectorAll('.lesson-order-badge');
        badges.forEach((b, idx) => {
            b.textContent = 'Bài ' + (idx + 1);
        });
    }

    function updateModuleLessonCount(listContainer) {
        if (!listContainer)
            return;
        const card = listContainer.closest('.saas-module-card');
        if (!card)
            return;
        const countBadge = card.querySelector('.saas-module-header .pill-neutral');
        const items = listContainer.querySelectorAll('.saas-lesson-item');
        if (countBadge) {
            countBadge.textContent = items.length + ' bài học';
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        initLessonDragAndDrop();
    });



    function showFloatingToast(message, type) {
        let toastContainer = document.getElementById('floatingNotificationToast');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.id = 'floatingNotificationToast';
            toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
            toastContainer.style.zIndex = '1090';
            toastContainer.innerHTML = '<div id="floatingToastInner" class="toast align-items-center text-white border-0 shadow rounded-3" role="alert" aria-live="assertive" aria-atomic="true"><div class="d-flex"><div class="toast-body small fw-semibold" id="floatingToastMsg"></div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div></div>';
            document.body.appendChild(toastContainer);
        }
        const inner = document.getElementById('floatingToastInner');
        inner.className = 'toast align-items-center text-white border-0 shadow rounded-3 ' + (type === 'success' ? 'bg-success' : 'bg-danger');
        document.getElementById('floatingToastMsg').textContent = message;
        const bsToast = new bootstrap.Toast(inner, {delay: 3000});
        bsToast.show();
    }

    function confirmPublishCourse(title, url) {
        showConfirmModal({
            title: 'Gửi yêu cầu xuất bản',
            method: 'POST',
            html: 'Bạn có chắc chắn muốn gửi yêu cầu duyệt khóa học "<strong>' + (title || '') + '</strong>" để Quản lý kiểm tra và công khai khóa học?',
            type: 'success',
            icon: 'bi bi-send-check-fill',
            confirmText: 'Gửi duyệt ngay',
            confirmIcon: 'bi bi-send-check me-1',
            confirmBtnClass: 'btn-success',
            confirmUrl: url
        });
    }

    function confirmCancelPublishCourse(title, url) {
        showConfirmModal({
            title: 'Thu hồi yêu cầu xuất bản (Chuyển về Bản nháp)',
            method: 'POST',
            html: 'Bạn có chắc chắn muốn thu hồi yêu cầu duyệt để tiếp tục chỉnh sửa khóa học "<strong>' + (title || '') + '</strong>"?<br><span class="text-muted small mt-2 d-inline-block"><i class="bi bi-info-circle me-1"></i>Khóa học sẽ trở về trạng thái <strong>Bản nháp</strong> để bạn có thể thêm, sửa bài giảng và chương học.</span>',
            type: 'warning',
            icon: 'bi bi-arrow-counterclockwise',
            confirmText: 'Chuyển về Bản nháp',
            confirmIcon: 'bi bi-arrow-counterclockwise me-1',
            confirmBtnClass: 'btn-warning text-dark',
            confirmUrl: url
        });
    }
