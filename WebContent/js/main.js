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
    getSession().then(renderNavbar).catch(() => {});
    attachLogout();
}

window.addEventListener('DOMContentLoaded', () => {
    initPage();
});
