// Toast notification system for Protein Gallery

function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.innerHTML = `
        <span class="toast-icon">
            ${type === 'success' ? '✅' :
              type === 'error'   ? '❌' :
              type === 'info'    ? 'ℹ️' : '⚠️'}
        </span>
        <span class="toast-msg">${message}</span>
        <button class="toast-close"
                onclick="this.parentElement.remove()">
            ✕
        </button>
    `;

    document.getElementById('toast-container')
            .appendChild(toast);

    setTimeout(() => {
        toast.classList.add('toast-show');
    }, 10);

    setTimeout(() => {
        toast.classList.remove('toast-show');
        setTimeout(() => toast.remove(), 300);
    }, 3500);
}

// Auto-initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    // Create toast container if it doesn't exist
    if (!document.getElementById('toast-container')) {
        const container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
    }
});