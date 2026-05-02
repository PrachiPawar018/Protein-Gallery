<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Toast Notification Container -->
<div id="toast-container" class="toast-container">
    <!-- Toasts will be dynamically added here -->
</div>

<style>
.toast-container {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 10000;
    pointer-events: none;
}

.toast {
    background: var(--card-bg);
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 8px;
    padding: 1rem 1.5rem;
    margin-bottom: 0.5rem;
    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    display: flex;
    align-items: center;
    gap: 0.75rem;
    min-width: 300px;
    max-width: 500px;
    pointer-events: auto;
    transform: translateX(100%);
    opacity: 0;
    transition: all 0.3s ease;
}

.toast.show {
    transform: translateX(0);
    opacity: 1;
}

.toast.success {
    border-color: var(--success);
    background: rgba(34, 197, 94, 0.1);
}

.toast.error {
    border-color: var(--danger);
    background: rgba(239, 68, 68, 0.1);
}

.toast.warning {
    border-color: #f59e0b;
    background: rgba(245, 158, 11, 0.1);
}

.toast.info {
    border-color: var(--primary-color);
    background: rgba(249, 115, 22, 0.1);
}

.toast-icon {
    font-size: 1.25rem;
    flex-shrink: 0;
}

.toast-content {
    flex-grow: 1;
}

.toast-title {
    font-weight: 600;
    font-size: 0.9rem;
    margin-bottom: 0.25rem;
}

.toast-message {
    font-size: 0.85rem;
    color: var(--text-muted);
    line-height: 1.4;
}

.toast-close {
    background: none;
    border: none;
    color: var(--text-muted);
    cursor: pointer;
    font-size: 1.25rem;
    padding: 0;
    width: 20px;
    height: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    transition: color 0.2s;
}

.toast-close:hover {
    color: var(--text-light);
}

@media (max-width: 480px) {
    .toast-container {
        left: 10px;
        right: 10px;
        top: 10px;
    }

    .toast {
        min-width: auto;
        max-width: none;
    }
}
</style>

<script>
// Toast notification system
class ToastManager {
    constructor() {
        this.container = document.getElementById('toast-container');
        this.toasts = [];
    }

    show(message, type = 'info', title = '', duration = 5000) {
        const toast = this.createToast(message, type, title);
        this.container.appendChild(toast);

        // Trigger animation
        setTimeout(() => toast.classList.add('show'), 10);

        // Auto remove
        if (duration > 0) {
            setTimeout(() => this.remove(toast), duration);
        }

        return toast;
    }

    createToast(message, type, title) {
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;

        const icon = this.getIcon(type);
        const titleHtml = title ? `<div class="toast-title">${title}</div>` : '';

        toast.innerHTML = `
            <div class="toast-icon">${icon}</div>
            <div class="toast-content">
                ${titleHtml}
                <div class="toast-message">${message}</div>
            </div>
            <button class="toast-close" onclick="toastManager.remove(this.parentElement)">&times;</button>
        `;

        return toast;
    }

    getIcon(type) {
        const icons = {
            success: '✅',
            error: '❌',
            warning: '⚠️',
            info: 'ℹ️'
        };
        return icons[type] || icons.info;
    }

    remove(toast) {
        toast.classList.remove('show');
        setTimeout(() => {
            if (toast.parentElement) {
                toast.parentElement.removeChild(toast);
            }
        }, 300);
    }

    success(message, title = 'Success') {
        return this.show(message, 'success', title);
    }

    error(message, title = 'Error') {
        return this.show(message, 'error', title);
    }

    warning(message, title = 'Warning') {
        return this.show(message, 'warning', title);
    }

    info(message, title = 'Info') {
        return this.show(message, 'info', title);
    }
}

// Global toast manager instance
const toastManager = new ToastManager();

// Make it globally available
window.showToast = (message, type, title, duration) => toastManager.show(message, type, title, duration);
window.showSuccess = (message, title) => toastManager.success(message, title);
window.showError = (message, title) => toastManager.error(message, title);
window.showWarning = (message, title) => toastManager.warning(message, title);
window.showInfo = (message, title) => toastManager.info(message, title);
</script>