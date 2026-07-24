/**
 * Protein Gallery - Frontend Master Application & API Integration
 */

const App = {
    user: null,

    // Initialize Global Features
    async init() {
        this.injectToastContainer();
        await this.checkAuthStatus();
        this.bindGlobalEvents();
    },

    // Get Product Image URL with High-Quality Fallback
    getImageUrl(url, product = {}) {
        const normalizedUrl = typeof url === 'string' ? url.trim() : '';
        const category = typeof product.category === 'string' ? product.category.trim() : '';
        const name = typeof product.name === 'string' ? product.name : '';

        const hasRealImage = normalizedUrl && !/placeholder|dummy|example|undefined/i.test(normalizedUrl);
        if (hasRealImage) {
            return normalizedUrl;
        }

        const keywordMap = [
            { pattern: /whey|protein/i, image: 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=900&q=80' },
            { pattern: /mass|gainer|bulk/i, image: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=900&q=80' },
            { pattern: /creatine|strength|power/i, image: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=900&q=80' },
            { pattern: /pre|workout|energy|focus/i, image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=80' },
            { pattern: /vitamin|multivitamin|daily/i, image: 'https://images.unsplash.com/photo-1615485737419-8f7d6eb9f177?auto=format&fit=crop&w=900&q=80' },
            { pattern: /beginner|stack|starter/i, image: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=900&q=80' }
        ];

        const matchedImage = keywordMap.find(item => item.pattern.test(`${name} ${category}`));
        if (matchedImage) {
            return matchedImage.image;
        }

        const paletteByCategory = {
            'Whey Protein': ['#ff6b35', '#f59e0b', '#2563eb'],
            'Mass Gainer': ['#7c3aed', '#2563eb', '#0f172a'],
            'Creatine': ['#0f766e', '#22c55e', '#2563eb'],
            'Pre-Workout': ['#dc2626', '#f97316', '#1d4ed8'],
            'Vitamins': ['#0ea5e9', '#10b981', '#1e293b'],
            'Beginner Pack': ['#ef4444', '#f59e0b', '#4f46e5']
        };

        const [colorA, colorB, colorC] = paletteByCategory[category] || ['#ff6b35', '#2563eb', '#0f172a'];
        const title = (name || category || 'Premium Supplement').toUpperCase();
        const badge = (category || 'Performance').toUpperCase();
        const icon = category === 'Mass Gainer' ? '⚡' : category === 'Creatine' ? '💪' : category === 'Pre-Workout' ? '🔥' : category === 'Vitamins' ? '✦' : '🥤';

        const svg = `
            <svg xmlns="http://www.w3.org/2000/svg" width="800" height="800" viewBox="0 0 800 800">
                <rect width="800" height="800" rx="48" fill="url(#bg)"/>
                <rect x="56" y="56" width="688" height="688" rx="36" fill="rgba(255,255,255,0.16)" stroke="rgba(255,255,255,0.35)" stroke-width="4"/>
                <circle cx="620" cy="220" r="140" fill="rgba(255,255,255,0.18)"/>
                <circle cx="210" cy="635" r="180" fill="rgba(255,255,255,0.12)"/>
                <path d="M265 230c27-72 100-112 175-106 73 6 132 55 154 127" stroke="rgba(255,255,255,0.55)" stroke-width="18" stroke-linecap="round" fill="none"/>
                <rect x="252" y="320" width="296" height="214" rx="28" fill="rgba(255,255,255,0.95)"/>
                <rect x="280" y="350" width="120" height="110" rx="24" fill="${colorA}"/>
                <rect x="420" y="350" width="100" height="110" rx="24" fill="${colorB}"/>
                <circle cx="400" cy="266" r="86" fill="rgba(255,255,255,0.92)"/>
                <text x="400" y="286" text-anchor="middle" font-size="78" font-family="Segoe UI, Arial, sans-serif">${icon}</text>
                <rect x="180" y="590" width="440" height="54" rx="27" fill="rgba(15,23,42,0.75)"/>
                <text x="400" y="626" text-anchor="middle" font-size="30" fill="white" font-family="Segoe UI, Arial, sans-serif" font-weight="700">${badge}</text>
                <text x="400" y="722" text-anchor="middle" font-size="32" fill="white" font-family="Segoe UI, Arial, sans-serif" font-weight="700">${title}</text>
                <defs>
                    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="${colorA}"/>
                        <stop offset="50%" stop-color="${colorB}"/>
                        <stop offset="100%" stop-color="${colorC}"/>
                    </linearGradient>
                </defs>
            </svg>`;

        return `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(svg)}`;
    },

    // Inject Toast Container DOM
    injectToastContainer() {
        if (!document.getElementById('toast-container')) {
            const container = document.createElement('div');
            container.id = 'toast-container';
            container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
            container.style.zIndex = '99999';
            document.body.appendChild(container);
        }
    },

    // Show Custom Animated Toast Notification
    toast(message, type = 'success') {
        const container = document.getElementById('toast-container');
        if (!container) return;

        const toastId = 'toast-' + Date.now();
        const bgClass = type === 'success' ? 'bg-dark text-white border-primary' : (type === 'error' ? 'bg-danger text-white' : 'bg-primary text-white');
        const icon = type === 'success' ? 'fa-check-circle text-primary' : (type === 'error' ? 'fa-exclamation-triangle text-white' : 'fa-info-circle text-white');

        const toastHtml = `
            <div id="${toastId}" class="toast show align-items-center ${bgClass} border-2 shadow-lg mb-2" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body d-flex align-items-center gap-2 font-weight-medium">
                        <i class="fas ${icon} fa-lg"></i>
                        <span>${message}</span>
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" onclick="document.getElementById('${toastId}').remove()"></button>
                </div>
            </div>
        `;
        container.insertAdjacentHTML('beforeend', toastHtml);

        setTimeout(() => {
            const el = document.getElementById(toastId);
            if (el) el.remove();
        }, 4000);
    },

    // Check User Authentication Status & Update Header Navigation
    async checkAuthStatus() {
        try {
            const res = await fetch('/api/auth/me');
            const data = await res.json();

            if (data.loggedIn && data.user) {
                this.user = data.user;
                this.renderUserNav(data.user);
                this.updateCartBadge();
            } else {
                this.user = null;
                this.renderGuestNav();
                this.updateCartBadge();
            }
        } catch (err) {
            console.error('Auth Check Error:', err);
        }
    },

    // Render User Header Navigation (Avatar + Dropdown)
    renderUserNav(user) {
        const navActions = document.querySelector('.navbar-actions');
        if (!navActions) return;

        // Find Account icon link or replace
        const accountLinks = navActions.querySelectorAll('a[href="login.html"], .user-nav-dropdown');
        accountLinks.forEach(el => el.remove());

        const dropdownHtml = `
            <div class="dropdown user-nav-dropdown d-inline-block ms-1">
                <button class="btn btn-outline-primary rounded-pill px-3 py-1 dropdown-toggle d-flex align-items-center gap-2" type="button" id="userMenuBtn" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user-circle fa-lg"></i>
                    <span class="d-none d-md-inline fw-semibold">${user.name.split(' ')[0]}</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 mt-2" aria-labelledby="userMenuBtn">
                    <li class="px-3 py-2 border-bottom bg-light">
                        <div class="fw-bold text-dark">${user.name}</div>
                        <small class="text-muted">${user.email}</small>
                    </li>
                    <li><a class="dropdown-item py-2" href="profile.html"><i class="fas fa-id-card me-2 text-primary"></i>My Profile</a></li>
                    <li><a class="dropdown-item py-2" href="orders.html"><i class="fas fa-box-open me-2 text-primary"></i>My Orders</a></li>
                    <li><a class="dropdown-item py-2" href="dashboard.html"><i class="fas fa-heart me-2 text-primary"></i>Wishlist</a></li>
                    ${user.role === 'ADMIN' ? '<li><a class="dropdown-item py-2" href="dashboard.html"><i class="fas fa-chart-line me-2 text-primary"></i>Admin Dashboard</a></li>' : ''}
                    <li><hr class="dropdown-divider"></li>
                    <li><button class="dropdown-item py-2 text-danger" onclick="App.logout()"><i class="fas fa-sign-out-alt me-2"></i>Logout</button></li>
                </ul>
            </div>
        `;

        // Insert before Cart icon
        const cartBtn = navActions.querySelector('a[href="cart.html"]');
        if (cartBtn) {
            cartBtn.insertAdjacentHTML('beforebegin', dropdownHtml);
        } else {
            navActions.insertAdjacentHTML('beforeend', dropdownHtml);
        }
    },

    // Render Guest Header Navigation
    renderGuestNav() {
        const navActions = document.querySelector('.navbar-actions');
        if (!navActions) return;

        const existingDropdown = navActions.querySelector('.user-nav-dropdown');
        if (existingDropdown) existingDropdown.remove();

        if (!navActions.querySelector('a[href="login.html"]')) {
            const loginLinkHtml = `<a class="nav-icon-btn" href="login.html" title="Account"><i class="fa fa-user"></i></a>`;
            const cartBtn = navActions.querySelector('a[href="cart.html"]');
            if (cartBtn) {
                cartBtn.insertAdjacentHTML('beforebegin', loginLinkHtml);
            } else {
                navActions.insertAdjacentHTML('beforeend', loginLinkHtml);
            }
        }
    },

    // Update Cart Badge Counter dynamically
    async updateCartBadge() {
        try {
            const res = await fetch('/api/cart');
            const data = await res.json();

            let count = 0;
            if (data.success && data.items) {
                count = data.items.reduce((sum, item) => sum + item.quantity, 0);
            }

            const badges = document.querySelectorAll('.cart-badge');
            badges.forEach(b => {
                b.textContent = count;
                b.style.display = count > 0 ? 'inline-block' : 'inline-block';
            });
        } catch (err) {
            console.error('Update Cart Badge Error:', err);
        }
    },

    // Global Logout Handler
    async logout() {
        try {
            const res = await fetch('/api/auth/logout', { method: 'POST' });
            const data = await res.json();
            if (data.success) {
                this.toast('Logged out successfully.', 'info');
                setTimeout(() => {
                    window.location.href = 'index.html';
                }, 800);
            }
        } catch (err) {
            this.toast('Logout failed.', 'error');
        }
    },

    // Global Event Binding
    bindGlobalEvents() {
        // Password Visibility Toggle
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('toggle-password') || e.target.closest('.toggle-password')) {
                const btn = e.target.classList.contains('toggle-password') ? e.target : e.target.closest('.toggle-password');
                const targetId = btn.getAttribute('data-target');
                const input = document.getElementById(targetId);
                if (input) {
                    const isPass = input.type === 'password';
                    input.type = isPass ? 'text' : 'password';
                    const icon = btn.querySelector('i');
                    if (icon) {
                        icon.className = isPass ? 'fas fa-eye-slash' : 'fas fa-eye';
                    }
                }
            }
        });

        // Add to Cart global click handler for buttons with data-product-id
        document.addEventListener('click', async (e) => {
            const addBtn = e.target.closest('.add-to-cart-btn');
            if (addBtn) {
                e.preventDefault();
                const productId = addBtn.getAttribute('data-product-id');
                const qtyInput = document.getElementById('productQuantity');
                const qty = qtyInput ? parseInt(qtyInput.value) : 1;

                if (!productId) return;

                if (!App.user) {
                    App.toast('Please login to add products to your cart.', 'error');
                    setTimeout(() => window.location.href = 'login.html', 1200);
                    return;
                }

                try {
                    addBtn.disabled = true;
                    const res = await fetch('/api/cart/add', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ product_id: productId, quantity: qty })
                    });
                    const data = await res.json();

                    if (data.success) {
                        App.toast(data.message, 'success');
                        App.updateCartBadge();
                    } else {
                        App.toast(data.message, 'error');
                    }
                } catch (err) {
                    App.toast('Failed to add product to cart.', 'error');
                } finally {
                    addBtn.disabled = false;
                }
            }
        });
    }
};

// Initialize Application on Page Load
document.addEventListener('DOMContentLoaded', () => {
    App.init();
});
