// Global UI helpers for Protein Gallery

window.contextPath = window.contextPath || '';

function scrollToTop() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function normalizePath(path) {
    if (path.startsWith('/')) {
        return window.contextPath + path;
    }
    return window.contextPath + '/' + path;
}

if (typeof window.setLoading === 'undefined') {
    window.setLoading = function(form) {
        const button = form.querySelector('button[type="submit"]');
        if (button) {
            button.dataset.originalText = button.innerHTML;
            button.innerHTML = 'Please wait...';
            button.disabled = true;
        }
        return true;
    };
}

window.updateCartBadge = function() {
    if (typeof updateCartCount === 'function') {
        updateCartCount();
    }
};

window.addEventListener('error', (event) => {
    console.error('Global script error:', event.message, event.filename, event.lineno, event.colno);
});

document.addEventListener('DOMContentLoaded', function() {
    if (!document.getElementById('toast-container')) {
        const container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
    }

    const backToTopBtn = document.getElementById('backToTop');
    if (backToTopBtn) {
        backToTopBtn.addEventListener('click', scrollToTop);
    }
});
