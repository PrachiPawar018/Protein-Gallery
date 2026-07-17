const api = {
    auth: '/api/auth',
    products: '/api/products',
    cart: '/api/cart',
    orders: '/api/orders',
    admin: '/api/admin',
};

function fetchJson(url, options = {}) {
    return fetch(url, {
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin',
        ...options,
    }).then(async res => {
        const body = await res.text();
        try {
            return JSON.parse(body || '{}');
        } catch (e) {
            return { success: false, message: 'Invalid response from server' };
        }
    });
}

function quote(value) {
    return encodeURIComponent(value);
}

function formatCurrency(value) {
    try {
        return new Intl.NumberFormat('en-IN', {
            style: 'currency',
            currency: 'INR',
            maximumFractionDigits: 0,
        }).format(Number(value));
    } catch (e) {
        return '₹' + value;
    }
}

function showToast(message, type = 'info') {
    const container = document.getElementById('toast-container');
    if (!container) return;
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.textContent = message;
    container.appendChild(toast);
    setTimeout(() => toast.remove(), 3200);
}

function clearFieldErrors(form) {
    form.querySelectorAll('.field-error').forEach(el => el.remove());
    form.querySelectorAll('.text-field, .select-field, .textarea-field').forEach(field => field.classList.remove('field-invalid'));
}

function showFieldErrors(form, errors = {}) {
    clearFieldErrors(form);
    Object.entries(errors).forEach(([fieldName, message]) => {
        const field = form.querySelector(`[name="${fieldName}"]`);
        if (!field) return;
        field.classList.add('field-invalid');
        const error = document.createElement('div');
        error.className = 'field-error';
        error.textContent = message;
        field.insertAdjacentElement('afterend', error);
    });
}

function setFormSubmitting(form, isSubmitting) {
    const button = form.querySelector('button[type="submit"]');
    if (!button) return;
    button.disabled = isSubmitting;
    if (isSubmitting) {
        button.dataset.originalText = button.textContent;
        button.innerHTML = '<span class="spinner"></span> Processing...';
    } else if (button.dataset.originalText) {
        button.textContent = button.dataset.originalText;
    }
}

function getSession() {
    return fetchJson(`${api.auth}/session`);
}

function renderNavbar(session) {
    const userMenu = document.getElementById('navUser');
    const authLinks = document.getElementById('navAuth');
    const adminLink = document.getElementById('navAdmin');
    if (!userMenu || !authLinks) return;
    if (session.authenticated) {
        authLinks.style.display = 'none';
        userMenu.style.display = 'inline-flex';
        userMenu.querySelector('.user-name').textContent = session.name;
        if (session.role === 'admin') {
            adminLink.style.display = 'inline-block';
        }
    } else {
        authLinks.style.display = 'inline-flex';
        userMenu.style.display = 'none';
        if (adminLink) {
            adminLink.style.display = 'none';
        }
    }
}

function attachLogout() {
    const logoutButton = document.getElementById('logoutButton');
    if (!logoutButton) return;
    logoutButton.addEventListener('click', async () => {
        const result = await fetchJson(`${api.auth}/logout`, { method: 'POST' });
        if (result.success) {
            showToast(result.message, 'success');
            setTimeout(() => window.location.href = 'index.html', 600);
        }
    });
}

function parseQuery() {
    return Object.fromEntries(new URLSearchParams(window.location.search));
}

function initPage() {
    const page = window.location.pathname.split('/').pop() || 'index.html';
    const protectedPages = ['profile.html', 'orders.html', 'cart.html', 'checkout.html', 'admin.html'];
    getSession().then(session => {
        renderNavbar(session);
        if (protectedPages.includes(page) && !session.authenticated) {
            window.location.href = `login.html?redirect=${encodeURIComponent(page)}`;
            return;
        }
        if (page === 'admin.html' && session.authenticated && session.role !== 'admin') {
            window.location.href = 'index.html';
        }
    }).catch(() => {
        if (protectedPages.includes(page)) {
            window.location.href = `login.html?redirect=${encodeURIComponent(page)}`;
        }
    });
    attachLogout();
}

window.addEventListener('DOMContentLoaded', () => {
    initPage();
});
