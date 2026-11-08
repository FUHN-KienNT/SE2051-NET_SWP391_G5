let quill = null;
    let isUserTypingTitleManually = (window.IS_USER_TYPING_MANUALLY === true);
    let lastFetchedVideoId = null;
    let lastFetchedVideoTitle = '';
    let isFetchingTitle = false;

    document.addEventListener('DOMContentLoaded', function() {
        const titleInp = document.getElementById('lessonTitle');
        if (titleInp) {
            if (titleInp.value && titleInp.value.trim()) {
                lastFetchedVideoTitle = titleInp.value.trim();
            }
            titleInp.addEventListener('input', function() {
                if (this.value.trim().length > 0) {
                    isUserTypingTitleManually = true;
                } else {
                    // Khi người dùng xóa hết chữ, mở khóa auto-fill để nhận diện lại lần thứ 2 trở đi
                    isUserTypingTitleManually = false;
                    lastFetchedVideoId = null;
                }
            });

            // Khi tiêu đề trống, người dùng nhấn Enter -> tự động fill lại tiêu đề theo link!
            titleInp.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    if (!this.value || this.value.trim() === '') {
                        e.preventDefault();
                        isUserTypingTitleManually = false;
                        lastFetchedVideoId = null;
                        if (lastFetchedVideoTitle && lastFetchedVideoTitle.trim()) {
                            this.value = lastFetchedVideoTitle;
                        }
                        fetchAndApplyVideoTitle(true);
                    }
                }
            });
        }
        
        const videoInp = document.getElementById('lessonVideoUrl');
        if (videoInp) {
            videoInp.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    const titleInput = document.getElementById('lessonTitle');
                    if (!titleInput || !titleInput.value || titleInput.value.trim() === '') {
                        e.preventDefault();
                        lastFetchedVideoId = null;
                        isUserTypingTitleManually = false;
                        fetchAndApplyVideoTitle(true);
                    }
                }
            });

            // Initial check if video URL is present and title is empty
            if (videoInp.value.trim() && titleInp && !titleInp.value.trim()) {
                handleVideoUrlChange();
            }
        }
    });

    function extractYoutubeId(url) {
        if (!url) return null;
        url = url.trim();
        // Match 11 char ID directly
        if (/^[a-zA-Z0-9_-]{11}$/.test(url)) {
            return url;
        }
        // Match embed, watch?v=, youtu.be/, shorts/
        const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|shorts\/|watch\?v=|\&v=)([^#\&\?]*).*/;
        const match = url.match(regExp);
        return (match && match[2].length === 11) ? match[2] : null;
    }

    function handleVideoUrlChange() {
        updateVideoPreview();
        const inputEl = document.getElementById('lessonVideoUrl');
        if (!inputEl) return;
        const url = inputEl.value.trim();
        const ytId = extractYoutubeId(url);

        const titleInput = document.getElementById('lessonTitle');
        const isTitleEmpty = !titleInput || !titleInput.value || titleInput.value.trim() === '';

        // Tự động lấy tiêu đề nếu bài học mới hoặc tiêu đề đang để trống / chưa được người dùng tự gõ
        if (url && (isTitleEmpty || !isUserTypingTitleManually)) {
            if (isTitleEmpty || ytId !== lastFetchedVideoId) {
                if (isTitleEmpty) {
                    lastFetchedVideoId = null;
                }
                fetchAndApplyVideoTitle(false);
            }
        }
    }

    async function fetchAndApplyVideoTitle(isManualClick = false) {
        const inputEl = document.getElementById('lessonVideoUrl');
        const titleInput = document.getElementById('lessonTitle');
        const feedbackEl = document.getElementById('titleFetchFeedback');
        if (!inputEl || !titleInput) return;

        const url = inputEl.value.trim();
        if (!url) {
            if (isManualClick && feedbackEl) {
                feedbackEl.style.display = 'block';
                feedbackEl.innerHTML = '<span class="text-danger"><i class="bi bi-exclamation-circle me-1"></i>Vui lòng nhập đường dẫn video trước!</span>';
                setTimeout(() => { feedbackEl.style.display = 'none'; }, 3000);
            }
            return;
        }

        const ytId = extractYoutubeId(url);
        if (isFetchingTitle) return;
        isFetchingTitle = true;

        if (feedbackEl) {
            feedbackEl.style.display = 'block';
            feedbackEl.innerHTML = '<span class="text-primary"><span class="spinner-border spinner-border-sm me-1" role="status"></span>Đang tự động lấy tiêu đề video...</span>';
        }

        let videoTitle = null;

        // 1. Nếu là YouTube, thử gọi trực tiếp YouTube oEmbed từ Client
        if (ytId) {
            try {
                const oembedUrl = 'https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=' + ytId + '&format=json';
                const controller = new AbortController();
                const timeoutId = setTimeout(() => controller.abort(), 3500);
                const resp = await fetch(oembedUrl, { signal: controller.signal });
                clearTimeout(timeoutId);
                if (resp.ok) {
                    const data = await resp.json();
                    if (data && data.title) {
                        videoTitle = data.title;
                        lastFetchedVideoId = ytId;
                    }
                }
            } catch (err) {
                console.log('Client oEmbed fallback:', err);
            }
        }

        // 2. Fallback sang Backend API Courson: /expert/get-video-title
        if (!videoTitle) {
            try {
                const backendUrl = (window.CONTEXT_PATH || '') + '/expert/get-video-title?url=' + encodeURIComponent(url);
                const resp = await fetch(backendUrl);
                if (resp.ok) {
                    const data = await resp.json();
                    if (data && data.success && data.title) {
                        videoTitle = data.title;
                        if (ytId) lastFetchedVideoId = ytId;
                    }
                }
            } catch (err) {
                console.warn('Backend get-video-title error:', err);
            }
        }

        // 3. Fallback cho file MP4 trực tiếp: lấy tên file làm tiêu đề
        if (!videoTitle && (url.toLowerCase().endsWith('.mp4') || url.toLowerCase().endsWith('.webm'))) {
            try {
                const pathname = new URL(url).pathname;
                let filename = pathname.substring(pathname.lastIndexOf('/') + 1);
                filename = filename.replace(/\.(mp4|webm)$/i, '').replace(/[-_]+/g, ' ').trim();
                if (filename.length > 0) {
                    videoTitle = filename.charAt(0).toUpperCase() + filename.slice(1);
                }
            } catch (e) {}
        }

        isFetchingTitle = false;

        if (videoTitle) {
            titleInput.value = videoTitle;
            lastFetchedVideoTitle = videoTitle;
            isUserTypingTitleManually = false;
            if (feedbackEl) {
                feedbackEl.style.display = 'block';
                feedbackEl.innerHTML = '<span class="text-success fw-medium"><i class="bi bi-check-circle-fill me-1"></i>Đã tự động đặt tiêu đề theo video: <strong>' + escapeHtml(videoTitle) + '</strong></span>';
                setTimeout(() => {
                    feedbackEl.style.display = 'none';
                }, 5000);
            }
        } else {
            if (feedbackEl) {
                if (isManualClick) {
                    feedbackEl.style.display = 'block';
                    feedbackEl.innerHTML = '<span class="text-warning"><i class="bi bi-exclamation-triangle me-1"></i>Không thể tự động nhận diện tiêu đề từ video này. Vui lòng nhập tiêu đề bằng tay.</span>';
                } else {
                    feedbackEl.style.display = 'none';
                }
            }
        }
    }

    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function updateVideoPreview() {
        const inputEl = document.getElementById('lessonVideoUrl');
        if (!inputEl) return;
        const inputVal = inputEl.value.trim();
        const container = document.getElementById('videoContainer');
        const wrapper = document.getElementById('videoWrapper');
        const iframe = document.getElementById('videoPreviewIframe');

        if (!inputVal) {
            if (container) container.classList.add('d-none');
            if (iframe) iframe.src = "";
            return;
        }

        const isShorts = /\/shorts\//i.test(inputVal);
        const id = extractYoutubeId(inputVal);
        let finalUrl = inputVal;
        if (id) {
            finalUrl = "https://www.youtube.com/embed/" + id;
            inputEl.value = finalUrl;
        }

        if (iframe) iframe.src = finalUrl;
        if (wrapper) {
            if (isShorts) {
                wrapper.style.maxWidth = '340px';
                wrapper.style.aspectRatio = '9 / 16';
            } else {
                wrapper.style.maxWidth = '100%';
                wrapper.style.aspectRatio = '16 / 9';
            }
        }
        if (container) container.classList.remove('d-none');
    }

    // =========================================================================
    // QUILL WYSIWYG RICH TEXT EDITOR LOGIC
    // =========================================================================
    function getEditorContent() {
        if (quill) {
            const text = quill.getText().trim();
            // Nếu không có ký tự thực tế nào, coi như rỗng
            return text.length === 0 ? '' : quill.root.innerHTML;
        }
        const el = document.getElementById('lessonContent');
        return el ? el.value : '';
    }

    function initQuillEditor() {
        const editorContainer = document.getElementById('quillEditor');
        if (!editorContainer) return;

        const toolbarOptions = [
            [{ 'header': [1, 2, 3, false] }],
            ['bold', 'italic', 'underline', 'strike'],
            [{ 'color': [] }, { 'background': [] }],
            [{ 'list': 'ordered'}, { 'list': 'bullet' }],
            ['blockquote', 'code-block'],
            [{ 'align': [] }],
            ['link', 'clean']
        ];

        quill = new Quill('#quillEditor', {
            theme: 'snow',
            placeholder: 'Nhập nội dung bài học hoặc ghi chú lý thuyết tại đây...',
            modules: {
                toolbar: toolbarOptions
            }
        });

        quill.on('text-change', function() {
            updateCharCount();
            const hiddenEl = document.getElementById('lessonContent');
            if (hiddenEl) {
                hiddenEl.value = getEditorContent();
            }
            ensureHistoryIntercepted();
            triggerAutoSave(false);
        });

        updateCharCount();
    }

    function updateCharCount() {
        const counter = document.getElementById('contentCharCount');
        if (counter && quill) {
            const text = quill.getText().trim();
            counter.textContent = text.length.toLocaleString('vi-VN') + ' ký tự';
        }
    }

    // =========================================================================
    // AUTO-SAVE DRAFT SYSTEM (TỰ ĐỘNG LƯU LIÊN TỤC / REAL-TIME AUTO-SAVE)
    // =========================================================================
    const AUTO_SAVE_INTERVAL_MS = 15 * 1000; // 15 giây đồng bộ nền định kỳ
    let autoSaveTimeout = null;
    const courseId = document.getElementById('lessonCourseId') ? document.getElementById('lessonCourseId').value : (window.COURSE_ID || '');
    const lessonIdEl = document.getElementById('lessonId');
    const lessonId = lessonIdEl ? lessonIdEl.value : 'new';
    const DRAFT_KEY = 'courson_draft_lesson_' + courseId + '_' + lessonId;

    let isSubmitting = false;
    let bypassExitPrompt = false;
    let isSavingDraft = false;
    let initialFormData = null;
    let cachedDraft = null;

    function getFormData() {
        const activeEl = document.getElementById('lessonIsActive') || document.querySelector('select[name="isActive"]');
        const newModEl = document.getElementById('newModuleTitle');
        return {
            courseId: courseId,
            lessonId: lessonId,
            moduleId: document.getElementById('lessonModuleId') ? document.getElementById('lessonModuleId').value : '',
            newModuleTitle: newModEl ? newModEl.value : '',
            title: document.getElementById('lessonTitle') ? document.getElementById('lessonTitle').value : '',
            orderIndex: document.getElementById('lessonOrderIndex') ? document.getElementById('lessonOrderIndex').value : '1',
            isActive: activeEl ? activeEl.value : 'true',
            videoUrl: document.getElementById('lessonVideoUrl') ? document.getElementById('lessonVideoUrl').value : '',
            documentUrl: document.getElementById('lessonDocumentUrl') ? document.getElementById('lessonDocumentUrl').value : '',
            content: getEditorContent()
        };
    }

    function isFormDirty() {
        if (!initialFormData) return false;
        const cur = getFormData();
        return cur.title !== initialFormData.title ||
               cur.moduleId !== initialFormData.moduleId ||
               cur.newModuleTitle !== initialFormData.newModuleTitle ||
               cur.orderIndex !== initialFormData.orderIndex ||
               cur.isActive !== initialFormData.isActive ||
               cur.videoUrl !== initialFormData.videoUrl ||
               cur.documentUrl !== initialFormData.documentUrl ||
               cur.content !== initialFormData.content;
    }

    function formatTime(d = new Date()) {
        const pad = (n) => String(n).padStart(2, '0');
        const hh = pad(d.getHours());
        const mm = pad(d.getMinutes());
        const ss = pad(d.getSeconds());
        const dd = pad(d.getDate());
        const mo = pad(d.getMonth() + 1);
        const yyyy = d.getFullYear();
        return hh + ':' + mm + ':' + ss + ' ' + dd + '/' + mo + '/' + yyyy;
    }

    function saveDraftLocalOnly() {
        if (isSubmitting || bypassExitPrompt) return;
        if (!isFormDirty()) return;
        try {
            const cur = getFormData();
            cur.savedAt = formatTime();
            localStorage.setItem(DRAFT_KEY, JSON.stringify(cur));
        } catch (e) {
            console.warn('Lỗi lưu nháp localStorage:', e);
        }
    }

    function triggerAutoSave(immediate = false) {
        if (isSubmitting) return;

        // 1. Lưu ngay vào localStorage tức thì (0ms) để không bao giờ mất ký tự
        saveDraftLocalOnly();

        // 2. Xóa bộ đếm debounce cũ
        if (autoSaveTimeout) {
            clearTimeout(autoSaveTimeout);
            autoSaveTimeout = null;
        }

        if (immediate) {
            saveDraft(false);
        } else {
            const statusEl = document.getElementById('autoSaveStatusText');
            if (statusEl && isFormDirty()) {
                statusEl.innerHTML = '<span class="text-muted"><span class="spinner-grow spinner-grow-sm me-1" style="width: 8px; height: 8px;"></span>Đang ghi nhận thay đổi...</span>';
            }
            // Debounce 1.5 giây sau khi ngừng gõ để gửi backup lên server
            autoSaveTimeout = setTimeout(function() {
                saveDraft(false);
            }, 1500);
        }
    }

    function saveDraft(isManual = false) {
        if (isSubmitting || isSavingDraft) return;

        // Nếu là tự động theo chu kỳ 5 phút mà form không có gì thay đổi thì bỏ qua
        if (!isManual && !isFormDirty()) {
            return;
        }

        isSavingDraft = true;
        const nowStr = formatTime();
        const currentData = getFormData();
        currentData.savedAt = nowStr;

        const statusEl = document.getElementById('autoSaveStatusText');
        if (statusEl) {
            statusEl.textContent = isManual ? 'Đang lưu nháp...' : 'Đang tự động lưu nháp...';
        }

        // 1. Lưu ngay vào localStorage của trình duyệt
        let localSuccess = false;
        try {
            localStorage.setItem(DRAFT_KEY, JSON.stringify(currentData));
            localSuccess = true;
        } catch (e) {
            console.warn('Lỗi lưu nháp localStorage:', e);
        }

        // 2. Gửi lưu backup lên Session server
        const params = new URLSearchParams();
        for (const key in currentData) {
            params.append(key, currentData[key]);
        }

        fetch((window.CONTEXT_PATH || '') + '/expert/save-lesson-draft', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params.toString()
        })
        .then(res => {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.json();
        })
        .then(data => {
            isSavingDraft = false;
            if (data && data.success) {
                const timeDisplay = (data && data.savedAt) ? data.savedAt : nowStr;
                if (statusEl) {
                    statusEl.innerHTML = '<span class="text-success"><i class="bi bi-check2 me-1"></i>Đã tự động lưu nháp (' + timeDisplay + ')</span>';
                    setTimeout(() => { if (statusEl) statusEl.innerHTML = ''; }, 4000);
                }
            } else {
                throw new Error(data && data.message ? data.message : 'Lỗi từ máy chủ');
            }
        })
        .catch(err => {
            isSavingDraft = false;
            if (statusEl) {
                if (localSuccess) {
                    statusEl.innerHTML = '<span class="text-warning"><i class="bi bi-exclamation-triangle me-1"></i>Đã lưu nháp cục bộ</span>';
                } else {
                    statusEl.innerHTML = '<span class="text-danger"><i class="bi bi-x-circle me-1"></i>Lỗi lưu nháp</span>';
                }
                setTimeout(() => { if (statusEl) statusEl.innerHTML = ''; }, 4000);
            }
        });
    }

    function manualSaveDraft() {
        saveDraft(true);
    }

    function hasMeaningfulDiff(draft, current) {
        if (!draft) return false;
        const hasData = (draft.title && draft.title.trim() !== '') ||
                        (draft.content && draft.content.trim() !== '') ||
                        (draft.videoUrl && draft.videoUrl.trim() !== '');
        if (!hasData) return false;

        return (draft.title || '') !== (current.title || '') ||
               (draft.content || '') !== (current.content || '') ||
               (draft.videoUrl || '') !== (current.videoUrl || '') ||
               (draft.documentUrl || '') !== (current.documentUrl || '') ||
               (draft.moduleId || '') !== (current.moduleId || '') ||
               (draft.orderIndex || '') !== (current.orderIndex || '');
    }

    function showRecoveryBanner(draft) {
        cachedDraft = draft;
        const container = document.getElementById('draftRecoveryAlertContainer');
        if (!container) return;

        const timeStr = draft.savedAt ? ' (lúc ' + draft.savedAt + ')' : '';
        container.innerHTML = 
            '<div class="alert alert-warning alert-dismissible fade show shadow-sm mb-4 border-warning border-start border-4 rounded-3" role="alert">' +
                '<div class="d-flex align-items-center justify-content-between flex-wrap gap-2">' +
                    '<div class="d-flex align-items-center gap-3">' +
                        '<i class="bi bi-clock-history fs-3 text-warning"></i>' +
                        '<div>' +
                            '<strong class="text-dark">Phát hiện bản nháp chưa lưu trước đó' + timeStr + '!</strong>' +
                            '<div class="small text-muted">Hệ thống đã tự động lưu trữ dữ liệu soạn thảo bài học của bạn. Bạn có muốn khôi phục không?</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="d-flex gap-2">' +
                        '<button type="button" class="btn btn-warning btn-sm fw-bold shadow-sm" onclick="restoreDraft()">' +
                            '<i class="bi bi-arrow-counterclockwise me-1"></i>Khôi phục bài' +
                        '</button>' +
                        '<button type="button" class="btn btn-outline-secondary btn-sm" onclick="dismissDraft()">' +
                            'Bỏ qua' +
                        '</button>' +
                    '</div>' +
                '</div>' +
            '</div>';
    }

    function restoreDraft() {
        if (!cachedDraft) return;

        if (cachedDraft.title !== undefined) {
            const el = document.getElementById('lessonTitle');
            if (el) el.value = cachedDraft.title;
        }
        if (cachedDraft.moduleId !== undefined) {
            const el = document.getElementById('lessonModuleId');
            if (el) el.value = cachedDraft.moduleId;
        }
        if (cachedDraft.orderIndex !== undefined) {
            const el = document.getElementById('lessonOrderIndex');
            if (el) el.value = cachedDraft.orderIndex;
        }
        if (cachedDraft.videoUrl !== undefined) {
            const el = document.getElementById('lessonVideoUrl');
            if (el) {
                el.value = cachedDraft.videoUrl;
                updateVideoPreview();
            }
        }
        if (cachedDraft.documentUrl !== undefined) {
            const el = document.getElementById('lessonDocumentUrl');
            if (el) el.value = cachedDraft.documentUrl;
        }
        if (cachedDraft.content !== undefined) {
            if (quill) {
                quill.root.innerHTML = cachedDraft.content || '';
            }
            const el = document.getElementById('lessonContent');
            if (el) el.value = cachedDraft.content || '';
            updateCharCount();
        }

        const container = document.getElementById('draftRecoveryAlertContainer');
        if (container) {
            container.innerHTML = 
                '<div class="alert alert-success alert-dismissible fade show shadow-sm mb-4 py-2 px-3 small rounded-3" role="alert">' +
                    '<i class="bi bi-check-circle-fill me-2"></i>Đã khôi phục thành công dữ liệu từ bản nháp ' + (cachedDraft.savedAt ? '(' + cachedDraft.savedAt + ')' : '') + '.' +
                    '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                '</div>';
        }

        const statusEl = document.getElementById('autoSaveStatusText');
        if (statusEl) {
            statusEl.innerHTML = '<span class="text-success"><i class="bi bi-arrow-counterclockwise me-1"></i>Đã khôi phục bản nháp</span>';
        }
    }

    function dismissDraft() {
        const container = document.getElementById('draftRecoveryAlertContainer');
        if (container) {
            container.innerHTML = '';
        }
        try {
            localStorage.removeItem(DRAFT_KEY);
        } catch (e) {}
        fetch('/expert/delete-lesson-draft?courseId=' + encodeURIComponent(courseId) + '&lessonId=' + encodeURIComponent(lessonId), { method: 'POST' });
    }

    function checkExistingDraft() {
        // 1. Kiểm tra localStorage máy khách
        let localDraft = null;
        try {
            const raw = localStorage.getItem(DRAFT_KEY);
            if (raw) {
                localDraft = JSON.parse(raw);
            }
        } catch (e) {}

        if (localDraft && hasMeaningfulDiff(localDraft, initialFormData)) {
            showRecoveryBanner(localDraft);
            return;
        }

        // 2. Dự phòng: Kiểm tra Session máy chủ
        fetch((window.CONTEXT_PATH || '') + '/expert/get-lesson-draft?courseId=' + encodeURIComponent(courseId) + '&lessonId=' + encodeURIComponent(lessonId))
            .then(res => res.json())
            .then(data => {
                if (data && data.exists && hasMeaningfulDiff(data, initialFormData)) {
                    showRecoveryBanner(data);
                }
            })
            .catch(err => {
                // Ignore fetch error
            });
    }

    // Khởi tạo các sự kiện khi DOM sẵn sàng
    document.addEventListener('DOMContentLoaded', function() {
        initQuillEditor();
        initialFormData = getFormData();

        // Khởi tạo video nếu đã có sẵn URL
        const curVal = document.getElementById('lessonVideoUrl') ? document.getElementById('lessonVideoUrl').value.trim() : '';
        if (curVal) {
            updateVideoPreview();
        }

        // Kiểm tra xem có bản nháp chưa lưu không
        checkExistingDraft();

        // Lắng nghe thay đổi trên tất cả các trường để tự động lưu tức thì
        const inputsToWatch = ['lessonTitle', 'lessonVideoUrl', 'lessonDocumentUrl', 'lessonModuleId', 'lessonOrderIndex', 'newModuleTitle', 'lessonIsActive'];
        inputsToWatch.forEach(id => {
            const el = document.getElementById(id);
            if (el) {
                el.addEventListener('input', () => {
                    ensureHistoryIntercepted();
                    triggerAutoSave(false);
                });
                el.addEventListener('change', () => {
                    ensureHistoryIntercepted();
                    triggerAutoSave(true);
                });
                el.addEventListener('blur', () => triggerAutoSave(true));
            }
        });

        // Định kỳ kiểm tra đồng bộ nền mỗi 15 giây
        setInterval(function() {
            if (isFormDirty() && !isSavingDraft) {
                saveDraft(false);
            }
        }, AUTO_SAVE_INTERVAL_MS);

        // Bắt sự kiện nộp biểu mẫu: đồng bộ nội dung từ Quill (giữ nguyên nháp local phòng sự cố nộp lỗi)
        const formEl = document.getElementById('lessonForm');
        if (formEl) {
            formEl.addEventListener('submit', function() {
                const hiddenEl = document.getElementById('lessonContent');
                if (hiddenEl) {
                    hiddenEl.value = getEditorContent();
                }
                isSubmitting = true;
                // [Zero Data Loss]: KHÔNG xóa localStorage tại đây. Chỉ xóa khi server xác nhận lưu thành công.
            });
        }

        // Cảnh báo khi người dùng tắt tab/rời trang khi chưa lưu và cố gắng bảo toàn nháp
        window.addEventListener('beforeunload', function(e) {
            if (isSubmitting || bypassExitPrompt) return;
            if (isFormDirty()) {
                const cur = getFormData();
                cur.savedAt = formatTime();
                try {
                    localStorage.setItem(DRAFT_KEY, JSON.stringify(cur));
                } catch (err) {}

                if (navigator.sendBeacon) {
                    const params = new URLSearchParams();
                    for (const key in cur) {
                        params.append(key, cur[key]);
                    }
                    navigator.sendBeacon((window.CONTEXT_PATH || '') + '/expert/save-lesson-draft', params);
                }

                e.preventDefault();
                e.returnValue = 'Bạn có thay đổi chưa lưu. Dữ liệu đã được tự động bảo toàn.';
                return e.returnValue;
            }
        });
    });

    function handleModuleSelectChange(val) {
        const group = document.getElementById('newModuleInputGroup');
        const inp = document.getElementById('newModuleTitle');
        if (!group || !inp) return;
        if (val === '__NEW__') {
            group.classList.remove('d-none');
            inp.required = true;
            inp.focus();
        } else {
            group.classList.add('d-none');
            inp.required = false;
            inp.value = '';
        }
    }



    // =========================================================================
    // BOOTSTRAP EXIT CONFIRMATION MODAL KHI ĐANG SỬA MÀ THOÁT RA
    // =========================================================================
    let pendingNavigationUrl = null;
        let isHistoryIntercepted = false;

    function getExitModal() {
        const modalEl = document.getElementById('unsavedChangesModal');
        if (!modalEl) return null;
        if (window.bootstrap && bootstrap.Modal) {
            return bootstrap.Modal.getOrCreateInstance(modalEl);
        }
        return null;
    }

    function showExitModal(targetUrl) {
        pendingNavigationUrl = targetUrl;
        const modal = getExitModal();
        if (modal) {
            modal.show();
        } else {
            if (confirm('Bạn có thay đổi chưa lưu trong bài học. Bạn có chắc chắn muốn rời đi không?')) {
                bypassExitPrompt = true;
                window.location.href = targetUrl;
            }
        }
    }

    function ensureHistoryIntercepted() {
        if (!isHistoryIntercepted && isFormDirty()) {
            try {
                history.pushState({ dirtyLesson: true }, '', window.location.href);
                isHistoryIntercepted = true;
            } catch (e) {}
        }
    }

    // Bắt sự kiện click vào các liên kết điều hướng khi form có thay đổi chưa lưu
    document.addEventListener('click', function(e) {
        if (bypassExitPrompt || isSubmitting) return;

        const anchor = e.target.closest('a');
        if (!anchor) return;

        // Bỏ qua các nút toggle / dismiss modal Bootstrap nội bộ
        if (anchor.getAttribute('data-bs-dismiss') || anchor.getAttribute('data-bs-toggle')) return;

        const href = anchor.getAttribute('href');
        if (!href || href === '#' || href.startsWith('javascript:') || href.startsWith('#')) return;
        if (anchor.target === '_blank') return;

        if (isFormDirty()) {
            e.preventDefault();
            e.stopPropagation();
            showExitModal(anchor.href);
        }
    }, true);

    // Bắt sự kiện bấm nút Back / Forward trên trình duyệt
    window.addEventListener('popstate', function(e) {
        if (bypassExitPrompt || isSubmitting) return;

        if (isFormDirty()) {
            try {
                history.pushState({ dirtyLesson: true }, '', window.location.href);
            } catch (err) {}
            showExitModal('HISTORY_BACK');
        }
    });

    // Phím tắt Ctrl + S để lưu nhanh tức thì
    window.addEventListener('keydown', function(e) {
        if ((e.ctrlKey || e.metaKey) && (e.key === 's' || e.key === 'S')) {
            e.preventDefault();
            const formEl = document.getElementById('lessonForm');
            if (formEl) {
                const submitBtn = document.getElementById('btnSubmitLesson');
                if (submitBtn) submitBtn.click();
                else formEl.submit();
            }
        }
    });

    // Xử lý sự kiện các nút bên trong Exit Modal khi DOM sẵn sàng
    document.addEventListener('DOMContentLoaded', function() {
        // Nút "Vẫn thoát (Không lưu)"
        const btnDiscard = document.getElementById('modalBtnDiscardAndExit');
        if (btnDiscard) {
            btnDiscard.addEventListener('click', function() {
                bypassExitPrompt = true;
                saveDraftLocalOnly(); // Lưu bản nháp một lần cuối để phòng hờ

                const modal = getExitModal();
                if (modal) modal.hide();

                if (pendingNavigationUrl === 'HISTORY_BACK') {
                    history.go(-2);
                } else if (pendingNavigationUrl) {
                    window.location.href = pendingNavigationUrl;
                } else {
                    window.location.href = (window.CONTEXT_PATH || '') + '/expert/lessons?courseId=' + (window.COURSE_ID || '');
                }
            });
        }

        // Nút "Lưu bài học rồi thoát"
        const btnSaveExit = document.getElementById('modalBtnSaveAndExit');
        if (btnSaveExit) {
            btnSaveExit.addEventListener('click', function() {
                bypassExitPrompt = true;
                const modal = getExitModal();
                if (modal) modal.hide();

                const formEl = document.getElementById('lessonForm');
                if (formEl) {
                    if (formEl.checkValidity && !formEl.checkValidity()) {
                        formEl.reportValidity();
                        return;
                    }
                    const submitBtn = document.getElementById('btnSubmitLesson');
                    if (submitBtn) {
                        submitBtn.click();
                    } else {
                        const hiddenEl = document.getElementById('lessonContent');
                        if (hiddenEl) hiddenEl.value = getEditorContent();
                        isSubmitting = true;
                        formEl.submit();
                    }
                }
            });
        }
    });
