/**
 * Courson LMS - Toast Notification Manager
 * Accessible, reusable, non-blocking toast notifications.
 */
(function (global) {
    'use strict';

    let container = null;

    function getOrCreateContainer() {
        if (!container || !document.body.contains(container)) {
            container = document.createElement('div');
            container.className = 'courson-toast-container';
            container.setAttribute('aria-live', 'polite');
            container.setAttribute('aria-atomic', 'true');
            document.body.appendChild(container);
        }
        return container;
    }

    const ICONS = {
        success: 'bi-check-circle-fill',
        error: 'bi-exclamation-triangle-fill',
        warning: 'bi-exclamation-circle-fill',
        info: 'bi-info-circle-fill'
    };

    const CoursonToast = {
        show: function (type, message, duration = 5000) {
            if (!message) return;

            const c = getOrCreateContainer();
            const normalizedType = ['success', 'error', 'warning', 'info'].includes(type) ? type : 'info';
            const iconClass = ICONS[normalizedType];

            const toast = document.createElement('div');
            toast.className = `courson-toast courson-toast-${normalizedType}`;
            toast.setAttribute('role', 'status');

            // Icon
            const iconSpan = document.createElement('span');
            iconSpan.className = `courson-toast-icon bi ${iconClass}`;
            toast.appendChild(iconSpan);

            // Content
            const contentDiv = document.createElement('div');
            contentDiv.className = 'courson-toast-content';
            contentDiv.textContent = message;
            toast.appendChild(contentDiv);

            // Close button
            const closeBtn = document.createElement('button');
            closeBtn.className = 'courson-toast-close';
            closeBtn.setAttribute('type', 'button');
            closeBtn.setAttribute('aria-label', 'Đóng thông báo');
            closeBtn.innerHTML = '&times;';
            closeBtn.onclick = function () {
                dismissToast(toast);
            };
            toast.appendChild(closeBtn);

            c.appendChild(toast);

            // Animate entry
            requestAnimationFrame(() => {
                toast.classList.add('show');
            });

            // Auto dismiss timer
            let timer = null;
            if (duration > 0) {
                timer = setTimeout(() => {
                    dismissToast(toast);
                }, duration);
            }

            // Pause on hover
            toast.onmouseenter = () => {
                if (timer) clearTimeout(timer);
            };
            toast.onmouseleave = () => {
                if (duration > 0) {
                    timer = setTimeout(() => {
                        dismissToast(toast);
                    }, 2000);
                }
            };

            return toast;
        },

        cleanUrlParams: function (paramNames = ['status']) {
            if (!window.history || !window.history.replaceState) return;
            try {
                const url = new URL(window.location.href);
                let changed = false;
                paramNames.forEach(name => {
                    if (url.searchParams.has(name)) {
                        url.searchParams.delete(name);
                        changed = true;
                    }
                });
                if (changed) {
                    const cleanPath = url.pathname + (url.search ? url.search : '') + url.hash;
                    window.history.replaceState(null, '', cleanPath);
                }
            } catch (e) {
                // Ignore url parse errors
            }
        }
    };

    function dismissToast(toast) {
        if (!toast || toast.classList.contains('hide')) return;
        toast.classList.remove('show');
        toast.classList.add('hide');
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 400);
    }

    global.CoursonToast = CoursonToast;
})(window);
