function showModerationNoteModal(courseTitle, note) {
        var titleEl = document.getElementById('moderationCourseTitle');
        var noteEl = document.getElementById('moderationNoteContent');
        if (titleEl)
            titleEl.textContent = courseTitle || '';
        if (noteEl)
            noteEl.textContent = note || '';
        var modalEl = document.getElementById('moderationNoteModal');
        if (modalEl) {
            var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }
    }

    function autoResizeTextarea(el) {
        if (!el)
            return;
        el.style.height = 'auto';
        el.style.height = Math.max(105, el.scrollHeight + 4) + 'px';
    }

    // =========================================================================
    // CLIENT-SIDE FILTER & INSTANT SEARCH
    // =========================================================================
    let currentFilter = 'all';

    function filterCourses(status, btnEl) {
        currentFilter = status;
        const tabBtns = document.querySelectorAll('#statusFilterTabs .saas-tab-btn');
        tabBtns.forEach(btn => btn.classList.remove('active'));
        if (btnEl)
            btnEl.classList.add('active');

        applyFilters();
    }

    function handleCourseSearch() {
        applyFilters();
    }

    function removeVietnameseDiacritics(str) {
        if (!str) return '';
        return str.normalize('NFD')
                  .replace(/[\u0300-\u036f]/g, '')
                  .replace(/đ/g, 'd').replace(/Đ/g, 'D');
    }

    function applyFilters() {
        const searchInput = document.getElementById('courseSearchInput');
        const rawQuery = (searchInput ? searchInput.value : '').trim();
        const query = rawQuery.toLowerCase();
        const queryNoAccents = removeVietnameseDiacritics(query);

        const rows = document.querySelectorAll('.course-row');
        let visibleCount = 0;

        rows.forEach(row => {
            const status = row.getAttribute('data-status') || '';
            const title = (row.getAttribute('data-title') || '').toLowerCase();
            const titleNoAccents = removeVietnameseDiacritics(title);
            const category = (row.getAttribute('data-category') || '').toLowerCase();

            const matchesStatus = (currentFilter === 'all') || (status === currentFilter);
            const matchesQuery = !query || 
                title.includes(query) || titleNoAccents.includes(queryNoAccents) ||
                category.includes(query);

            if (matchesStatus && matchesQuery) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        const noMatchRow = document.getElementById('noMatchRow');
        if (noMatchRow) {
            noMatchRow.style.display = (visibleCount === 0 && rows.length > 0) ? '' : 'none';
        }
    }

    function resetFilters() {
        const searchInput = document.getElementById('courseSearchInput');
        if (searchInput) searchInput.value = '';
        const allTab = document.querySelector('#statusFilterTabs .saas-tab-btn[data-filter="all"]');
        filterCourses('all', allTab);
    }

    // =========================================================================
    // EDIT COURSE MODAL LOGIC (Preserved O(1) Fetch)
    // =========================================================================
    function openEditCourseModal(courseId) {
        const modalEl = document.getElementById('editCourseModal');
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);

        document.getElementById('editCourseModalTitle').innerHTML = '<i class="bi bi-gear-fill text-primary me-2"></i>Chỉnh sửa Khóa học #' + courseId;
        document.getElementById('editCourseId').value = courseId;
        document.getElementById('editCourseLoading').style.display = 'block';
        document.getElementById('editCourseFormFields').style.display = 'none';
        document.getElementById('editCourseSubmitBtn').disabled = true;

        const customDiv = document.getElementById('editCourseCustomCatDiv');
        if (customDiv)
            customDiv.style.display = 'none';

        modal.show();

        fetch((window.CONTEXT_PATH||'')+'/expert/get-course?id=' + encodeURIComponent(courseId))
                .then(res => {
                    if (!res.ok)
                        throw new Error('Không thể tải khóa học #' + courseId);
                    return res.json();
                })
                .then(data => {
                    if (data.error) {
                        alert(data.error);
                        modal.hide();
                        return;
                    }
                    document.getElementById('editCourseId').value = data.id;
                    document.getElementById('editCourseTitle').value = data.title || '';
                    if (data.categoryId) {
                        setComboboxValue('editCourseCategoryCombobox', data.categoryId, data.categoryName);
                    } else if (data.categoryName) {
                        setComboboxValue('editCourseCategoryCombobox', '__NEW__', data.categoryName);
                        const customDiv = document.getElementById('editCourseCustomCatDiv');
                        if (customDiv) {
                            customDiv.style.display = 'block';
                            const inp = customDiv.querySelector('input');
                            if (inp)
                                inp.value = data.categoryName;
                        }
                    }
                    let pVal = data.price != null ? parseInt(data.price, 10) : 0;
                    document.getElementById('editCoursePrice').value = pVal > 0 ? pVal.toLocaleString('en-US') : '0';
                    const editDescEl = document.getElementById('editCourseDescription');
                    editDescEl.value = data.description || '';
                    autoResizeTextarea(editDescEl);

                    document.getElementById('editCourseLoading').style.display = 'none';
                    document.getElementById('editCourseFormFields').style.display = 'block';
                    document.getElementById('editCourseSubmitBtn').disabled = false;

                    // Quy tắc: Chỉ khóa học ở trạng thái DRAFT mới cho phép Expert xóa
                    const delBtn = document.getElementById('editCourseDeleteBtn');
                    if (delBtn) {
                        if (data.status === 'DRAFT') {
                            delBtn.style.display = 'inline-block';
                        } else {
                            delBtn.style.display = 'none';
                        }
                    }
                })
                .catch(err => {
                    alert('Lỗi khi truy vấn khóa học từ CSDL: ' + err.message);
                    modal.hide();
                });
    }

    // =========================================================================
    // ARCHIVE & UNARCHIVE (INSTANT CONFIRMATION)
    // =========================================================================
    function confirmArchiveCourse(title, url) {
        showConfirmModal({
            title: 'Lưu trữ / Ẩn khóa học',
            method: 'POST',
            html: 'Bạn có chắc chắn muốn lưu trữ khóa học "<strong>' + (title || '') + '</strong>"?<br><br>' +
                    '<span class="text-muted small"><i class="bi bi-info-circle me-1"></i>' +
                    'Khóa học sẽ <strong>lập tức ẩn khỏi trang Chủ và Danh mục</strong> (ngừng nhận học viên mới).<br>' +
                    '<i class="bi bi-shield-check text-success me-1"></i>Học viên đã mua trước đây vẫn học tập bình thường.<br>' +
                    '<i class="bi bi-exclamation-circle text-danger me-1"></i>Lưu ý: Thao tác này là vĩnh viễn và không thể hoàn tác.</span>',
            type: 'warning',
            icon: 'bi bi-archive-fill',
            confirmText: 'Lưu trữ ngay',
            confirmIcon: 'bi bi-archive me-1',
            confirmBtnClass: 'btn-warning text-dark fw-bold',
            confirmUrl: url
        });
    }

    // =========================================================================
    // SAAS SEARCHABLE SELECT (COMBOBOX) CONTROLLER
    // =========================================================================
    function removeVietnameseDiacritics(str) {
        if (!str)
            return '';
        return str.normalize("NFD")
                .replace(/[\u0300-\u036f]/g, "")
                .replace(/đ/g, "d").replace(/Đ/g, "D")
                .toLowerCase()
                .trim();
    }

    function initSearchableSelect(comboboxId, customDivId) {
        const box = document.getElementById(comboboxId);
        if (!box)
            return;

        const trigger = box.querySelector('.saas-combobox-trigger');
        const labelSpan = box.querySelector('.selected-text');
        const hiddenInput = box.querySelector('input[type="hidden"]');
        const searchInput = box.querySelector('.saas-combobox-search');
        const searchClear = box.querySelector('.saas-combobox-search-clear');
        const items = box.querySelectorAll('.saas-combobox-list .saas-combobox-item');
        const emptyBox = box.querySelector('.saas-combobox-empty');
        const addNewBtn = box.querySelector('.add-new-btn');
        const customDiv = document.getElementById(customDivId);
        const customInput = customDiv ? customDiv.querySelector('input') : null;

        function openDropdown() {
            document.querySelectorAll('.saas-combobox.open').forEach(cb => {
                if (cb !== box)
                    cb.classList.remove('open');
            });
            box.classList.add('open');
            trigger.setAttribute('aria-expanded', 'true');
            if (searchInput) {
                searchInput.value = '';
                filterItems('');
                setTimeout(() => searchInput.focus(), 50);
            }
        }

        function closeDropdown() {
            box.classList.remove('open');
            trigger.setAttribute('aria-expanded', 'false');
        }

        function toggleDropdown() {
            if (box.classList.contains('open')) {
                closeDropdown();
            } else {
                openDropdown();
            }
        }

        trigger.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            toggleDropdown();
        });

        document.addEventListener('click', function (e) {
            if (!box.contains(e.target)) {
                closeDropdown();
            }
        });

        box.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                closeDropdown();
                trigger.focus();
            }
        });

        function filterItems(query) {
            const cleanQuery = removeVietnameseDiacritics(query);
            let matchCount = 0;

            if (searchClear) {
                if (query.trim()) {
                    searchClear.classList.remove('d-none');
                } else {
                    searchClear.classList.add('d-none');
                }
            }

            items.forEach(it => {
                const label = it.getAttribute('data-label') || it.textContent;
                const cleanLabel = removeVietnameseDiacritics(label);
                if (!cleanQuery || cleanLabel.includes(cleanQuery)) {
                    it.classList.remove('d-none');
                    matchCount++;
                } else {
                    it.classList.add('d-none');
                }
            });

            if (emptyBox) {
                if (matchCount === 0) {
                    emptyBox.classList.remove('d-none');
                } else {
                    emptyBox.classList.add('d-none');
                }
            }

            if (addNewBtn) {
                if (query.trim()) {
                    addNewBtn.innerHTML = '<i class="bi bi-plus-circle text-primary me-2"></i>+ Thêm danh mục "' + escapeHtml(query.trim()) + '"...';
                    addNewBtn.dataset.customText = query.trim();
                } else {
                    addNewBtn.innerHTML = '<i class="bi bi-plus-circle text-primary me-2"></i>+ Thêm danh mục mới...';
                    delete addNewBtn.dataset.customText;
                }
            }
        }

        if (searchInput) {
            searchInput.addEventListener('input', function () {
                filterItems(this.value);
            });
            searchInput.addEventListener('click', function (e) {
                e.stopPropagation();
            });
        }

        if (searchClear) {
            searchClear.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                searchInput.value = '';
                filterItems('');
                searchInput.focus();
            });
        }

        items.forEach(it => {
            it.addEventListener('click', function (e) {
                e.stopPropagation();
                const val = this.getAttribute('data-value');
                const label = this.getAttribute('data-label') || this.querySelector('.item-text').textContent;

                items.forEach(i => i.classList.remove('selected'));
                this.classList.add('selected');

                hiddenInput.value = val;
                labelSpan.textContent = label;

                if (customDiv) {
                    customDiv.style.display = 'none';
                    if (customInput) {
                        customInput.required = false;
                        customInput.value = '';
                    }
                }

                closeDropdown();
                trigger.focus();
            });
        });

        if (addNewBtn) {
            addNewBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                hiddenInput.value = '__NEW__';
                const customVal = addNewBtn.dataset.customText || '';
                labelSpan.textContent = customVal ? ('Mới: ' + customVal) : '+ Danh mục mới';

                items.forEach(i => i.classList.remove('selected'));

                if (customDiv) {
                    customDiv.style.display = 'block';
                    if (customInput) {
                        customInput.required = true;
                        if (customVal)
                            customInput.value = customVal;
                        setTimeout(() => customInput.focus(), 50);
                    }
                }

                closeDropdown();
            });
        }

        if (customInput) {
            customInput.addEventListener('input', function () {
                if (this.value.trim()) {
                    labelSpan.textContent = 'Mới: ' + this.value.trim();
                } else {
                    labelSpan.textContent = '+ Danh mục mới';
                }
            });
        }
    }

    function setComboboxValue(comboboxId, value, fallbackName) {
        const box = document.getElementById(comboboxId);
        if (!box)
            return;

        const hiddenInput = box.querySelector('input[type="hidden"]');
        const labelSpan = box.querySelector('.selected-text');
        const items = box.querySelectorAll('.saas-combobox-list .saas-combobox-item');

        let matched = false;
        items.forEach(it => {
            if (it.getAttribute('data-value') == value) {
                it.classList.add('selected');
                labelSpan.textContent = it.getAttribute('data-label') || it.textContent.trim();
                hiddenInput.value = value;
                matched = true;
            } else {
                it.classList.remove('selected');
            }
        });

        if (!matched && fallbackName) {
            hiddenInput.value = value || '__NEW__';
            labelSpan.textContent = fallbackName;
        }
    }

    function cancelCustomCategory(comboboxId, customDivId) {
        const box = document.getElementById(comboboxId);
        const customDiv = document.getElementById(customDivId);
        if (customDiv) {
            customDiv.style.display = 'none';
            const inp = customDiv.querySelector('input');
            if (inp) {
                inp.required = false;
                inp.value = '';
            }
        }
        if (box) {
            const firstItem = box.querySelector('.saas-combobox-list .saas-combobox-item');
            if (firstItem) {
                const val = firstItem.getAttribute('data-value');
                const label = firstItem.getAttribute('data-label') || firstItem.textContent.trim();
                setComboboxValue(comboboxId, val, label);
            }
        }
    }

    function escapeHtml(text) {
        if (!text)
            return '';
        return text.replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
    }

    document.addEventListener('DOMContentLoaded', function () {
        initSearchableSelect('editCourseCategoryCombobox', 'editCourseCustomCatDiv');
    });

    // =========================================================================
    // YOUTUBE PLAYLIST BATCH AUTO-DETECT & PREVIEW
    // =========================================================================
    let courseBatchTimer = null;
    let courseBatchAbortController = null;

    function hasYoutubeVideoOrPlaylist(text) {
        if (!text || !text.trim())
            return false;
        const playlistRegex = /(?:[?&]list=|playlist\?list=)[a-zA-Z0-9_-]+|^PL[a-zA-Z0-9_-]{16,}/i;
        const videoRegex = /(?:youtu\.be\/|youtube\.com\/(?:watch\?.*v=|embed\/|v\/|shorts\/)|youtube\.com\/live\/)[a-zA-Z0-9_-]{11}/i;
        return playlistRegex.test(text) || videoRegex.test(text);
    }

    function previewCourseBatchVideos() {
        const text = document.getElementById('newCourseBatchText').value;
        const feedback = document.getElementById('newCourseBatchFeedback');

        // 1. Hủy ngay request cũ đang bay dở dang nếu có
        if (courseBatchAbortController) {
            courseBatchAbortController.abort();
            courseBatchAbortController = null;
        }

        // 2. Xóa bộ đếm chờ trước đó
        clearTimeout(courseBatchTimer);

        // 3. Nếu rỗng -> ẩn feedback và dừng lại
        if (!text || !text.trim()) {
            feedback.className = 'mt-2 small d-none';
            feedback.innerHTML = '';
            return;
        }

        // 4. KIỂM TRA ĐỊNH DẠNG: Chỉ gọi API nếu thực sự có link Playlist hoặc video YouTube!
        if (!hasYoutubeVideoOrPlaylist(text)) {
            feedback.className = 'mt-2 small text-muted';
            feedback.innerHTML = '<i class="bi bi-info-circle me-1"></i>Hệ thống nhận diện link Playlist (có ?list=...) hoặc link video YouTube (watch?v=, youtu.be, shorts).';
            return;
        }

        feedback.className = 'mt-2 small text-muted';
        feedback.innerHTML = '<span class="spinner-border spinner-border-sm text-danger me-1"></span>Đang phân tích video / playlist YouTube...';

        // 5. Chờ 300ms sau khi người dùng dừng nhập/dán thì mới gửi request mới
        courseBatchTimer = setTimeout(() => {
            courseBatchAbortController = new AbortController();
            const signal = courseBatchAbortController.signal;

            const params = new URLSearchParams();
            params.append('batchText', text);
            fetch((window.CONTEXT_PATH||'')+'/expert/preview-batch-videos', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
                body: params.toString(),
                signal: signal
            })
                    .then(r => r.json())
                    .then(data => {
                        const list = Array.isArray(data) ? data : (data.videos || []);
                        if (list && list.length > 0) {
                            const plTitle = data.playlistTitle;
                            let infoText = 'Đã nhận diện: <strong>' + list.length + ' bài giảng</strong>';
                            if (plTitle) {
                                infoText += ' từ Playlist: "<strong>' + plTitle + '</strong>"';
                                const titleInp = document.getElementById('newCourseTitle');
                                if (titleInp && (!titleInp.value.trim() || titleInp.dataset.autofilled === 'true')) {
                                    titleInp.value = plTitle;
                                    titleInp.dataset.autofilled = 'true';
                                }
                            }

                            // Tự động gán danh mục nếu phát hiện (chọn ngầm định)
                            if (data.suggestedCategoryId && data.suggestedCategoryName) {
                                setComboboxValue('newCourseCategoryCombobox', data.suggestedCategoryId, data.suggestedCategoryName);
                            }

                            // Tự động điền mô tả tóm tắt nếu AI sinh thành công
                            if (data.suggestedDescription) {
                                const descInp = document.getElementById('newCourseDescription');
                                if (descInp && (!descInp.value.trim() || descInp.dataset.autofilled === 'true')) {
                                    let cleanDesc = data.suggestedDescription.replace(/\\"/g, '"').replace(/^"+|"+$/g, '').trim();
                                    descInp.value = cleanDesc;
                                    descInp.dataset.autofilled = 'true';
                                    autoResizeTextarea(descInp);
                                }
                            }


                            feedback.className = 'mt-2 small alert alert-success py-1 px-2 mb-0 d-flex align-items-center justify-content-between';
                            feedback.innerHTML = '<span><i class="bi bi-check-circle-fill text-success me-1"></i>' + infoText + '</span>';
                        } else {
                            feedback.className = 'mt-2 small text-muted';
                            feedback.innerHTML = '<i class="bi bi-info-circle me-1"></i>Chưa nhận diện được video YouTube hợp lệ.';
                        }
                    })
                    .catch(err => {
                        // Nếu bị abort do người dùng đổi link khác -> im lặng bỏ qua, không nhận dữ liệu cũ
                        if (err.name === 'AbortError')
                            return;
                        feedback.className = 'mt-2 small d-none';
                    });
        }, 300);
    }

    function generateAiDescription(titleInputId, descInputId, categoryComboboxId, btnEl) {
        const titleInp = document.getElementById(titleInputId);
        const descInp = document.getElementById(descInputId);
        if (!titleInp || !titleInp.value.trim()) {
            alert('Vui lòng nhập tên khóa học trước khi yêu cầu AI viết mô tả!');
            titleInp.focus();
            return;
        }

        let catName = '';
        if (categoryComboboxId) {
            const box = document.getElementById(categoryComboboxId);
            if (box) {
                const label = box.querySelector('.selected-text');
                if (label)
                    catName = label.textContent.trim();
            }
        }

        const originalBtnHtml = btnEl ? btnEl.innerHTML : '';
        if (btnEl) {
            btnEl.disabled = true;
            btnEl.innerHTML = '<span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span>Đang viết...';
        }

        const params = new URLSearchParams();
        params.append('title', titleInp.value.trim());
        if (catName && catName !== 'Chọn danh mục...') {
            params.append('categoryName', catName);
        }

        fetch((window.CONTEXT_PATH||'')+'/expert/generate-ai-description', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
            body: params.toString()
        })
                .then(r => r.json())
                .then(data => {
                    if (data && data.description) {
                        descInp.value = data.description;
                        descInp.dataset.autofilled = 'false';
                        descInp.style.transition = 'all 0.3s ease';
                        descInp.style.backgroundColor = 'rgba(37, 99, 235, 0.08)';
                        setTimeout(() => {
                            descInp.style.backgroundColor = '';
                        }, 800);
                    } else {
                        if (data && data.aiAvailable === false) {
                            alert('⚠️ Chưa cấu hình GEMINI_API_KEY trong hệ thống! Vui lòng cấu hình file ai.properties hoặc biến môi trường để sử dụng tính năng này.');
                        } else {
                            alert('⚠️ Kết nối đến Google Gemini AI thất bại hoặc vượt quá hạn mức (Quota limit)! Vui lòng kiểm tra lại API Key hoặc kết nối mạng.');
                        }
                    }
                })
                .catch(err => {
                    alert('Lỗi kết nối khi gọi AI: ' + err.message);
                })
                .finally(() => {
                    if (btnEl) {
                        btnEl.disabled = false;
                        btnEl.innerHTML = originalBtnHtml;
                    }
                });
    }

    function deleteEditingCourse() {
        const id = document.getElementById('editCourseId').value;
        const title = document.getElementById('editCourseTitle').value;
        const modalEl = document.getElementById('editCourseModal');
        const modalInstance = bootstrap.Modal.getInstance(modalEl);
        if (modalInstance)
            modalInstance.hide();
        startDeleteCourseCountdown(id, title);
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

    function confirmCancelArchive(title, url) {
        showConfirmModal({
            title: 'Hủy lịch lưu trữ',
            method: 'POST',
            html: 'Bạn có chắc chắn muốn hủy lịch lưu trữ và tiếp tục giữ khóa học "<strong>' + (title || '') + '</strong>" công khai bình thường?',
            type: 'primary',
            icon: 'bi bi-calendar-x-fill',
            confirmText: 'Hủy lịch lưu trữ',
            confirmIcon: 'bi bi-calendar-x me-1',
            confirmBtnClass: 'btn-primary',
            confirmUrl: url
        });
    }



    function confirmDeleteCourse(title, url) {
        showConfirmModal({
            title: 'Xác nhận xóa khóa học nháp',
            method: 'POST',
            html: 'Bạn có chắc chắn muốn xóa vĩnh viễn khóa học nháp "<strong>' + (title || '') + '</strong>"?<br><span class="text-danger small mt-2 d-inline-block"><i class="bi bi-exclamation-triangle me-1"></i>Toàn bộ nội dung bài học bên trong sẽ bị xóa vĩnh viễn và không thể hoàn tác.</span>',
            type: 'danger',
            icon: 'bi bi-trash3-fill',
            confirmText: 'Xóa vĩnh viễn',
            confirmIcon: 'bi bi-trash3 me-1',
            confirmBtnClass: 'btn-danger',
            confirmUrl: url
        });
    }


function formatPriceInputRealtime(el) {
    if (!el) return;
    let raw = el.value.replace(/\D/g, '');
    if (!raw) {
        el.value = '';
        return;
    }
    raw = raw.replace(/^0+(?=\d)/, '');
    try {
        let num = BigInt(raw);
        el.value = num.toLocaleString('en-US');
    } catch (e) {
        el.value = raw;
    }
}
