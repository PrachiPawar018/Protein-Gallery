(function () {
    const currentPage = (window.location.pathname.split('/').pop() || 'index.html').toLowerCase();
    const navItems = [
        { href: 'index.html', label: 'Home', key: 'home' },
        { href: 'shop.html', label: 'Shop', key: 'shop' },
        { href: 'categories.html', label: 'Categories', key: 'categories' },
        { href: 'brands.html', label: 'Brands', key: 'brands' },
        { href: 'offers.html', label: 'Offers', key: 'offers' },
        { href: 'about.html', label: 'About', key: 'about' },
        { href: 'contact.html', label: 'Contact', key: 'contact' }
    ];

    function getActiveKey() {
        if (currentPage === 'single-product.html' || currentPage === 'product.html') return 'shop';
        if (currentPage === 'cart.html') return 'shop';
        if (currentPage === 'login.html' || currentPage === 'register.html' || currentPage === 'forgot-password.html' || currentPage === 'profile.html' || currentPage === 'orders.html') return 'home';
        return navItems.find(item => item.href === currentPage)?.key || 'home';
    }

    function renderNavbar() {
        const mountPoint = document.getElementById('shared-navbar');
        if (!mountPoint) return;

        const activeKey = getActiveKey();
        const linksHtml = navItems.map(item => `
            <a href="${item.href}" class="nav-item nav-link${item.key === activeKey ? ' active' : ''}">${item.label}</a>
        `).join('');

        mountPoint.innerHTML = `
            <div class="container-fluid fixed-top px-0">
                <nav class="navbar navbar-expand-lg navbar-light py-2 px-4 px-lg-5">
                    <a href="index.html" class="navbar-brand ms-2 ms-lg-0 d-flex align-items-center gap-3">
                        <span class="brand-mark"><i class="fas fa-dumbbell"></i></span>
                        <span>
                            <span class="brand-title d-block">Protein Gallery</span>
                            <small class="brand-subtitle">Premium Fitness Nutrition</small>
                        </span>
                    </a>
                    <button type="button" class="navbar-toggler me-2" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarCollapse">
                        <div class="navbar-nav mx-auto align-items-center gap-1 p-3 p-lg-0">
                            ${linksHtml}
                        </div>
                        <div class="navbar-actions d-flex align-items-center gap-2 ms-lg-3">
                            <a class="nav-icon-btn" href="shop.html" title="Search"><i class="fa fa-search"></i></a>
                            <a class="nav-icon-btn" href="login.html" title="Account"><i class="fa fa-user"></i></a>
                            <a class="nav-icon-btn" href="cart.html" title="Cart"><i class="fa fa-shopping-bag"></i><span class="cart-badge">0</span></a>
                            <a class="btn btn-primary rounded-pill px-4 py-2 ms-2 d-none d-lg-inline-flex" href="shop.html">Shop Now</a>
                        </div>
                    </div>
                </nav>
            </div>
        `;
    }

    function renderFooter() {
        const mountPoint = document.getElementById('shared-footer');
        if (!mountPoint) return;

        mountPoint.innerHTML = `
            <div class="container-fluid footer pt-5 wow fadeIn" data-wow-delay="0.1s">
                <div class="container py-5">
                    <div class="row g-5 align-items-start">
                        <div class="col-lg-3 col-md-6">
                            <h4 class="fw-bold mb-3">Protein Gallery</h4>
                            <p class="mb-4">Premium supplements, expert guidance, and performance nutrition crafted for strength, recovery, and daily wellness.</p>
                            <div class="d-flex gap-2">
                                <a class="social-link" href="#"><i class="fab fa-facebook-f"></i></a>
                                <a class="social-link" href="#"><i class="fab fa-instagram"></i></a>
                                <a class="social-link" href="#"><i class="fab fa-twitter"></i></a>
                                <a class="social-link" href="#"><i class="fab fa-youtube"></i></a>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <h5 class="fw-bold mb-3">Shop Categories</h5>
                            <a class="btn btn-link" href="shop.html">Whey Protein</a>
                            <a class="btn btn-link" href="shop.html?category=Mass%20Gainer">Mass Gainer</a>
                            <a class="btn btn-link" href="shop.html?category=Creatine">Creatine</a>
                            <a class="btn btn-link" href="shop.html?category=Pre-Workout">Pre-Workout</a>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <h5 class="fw-bold mb-3">Quick Links</h5>
                            <a class="btn btn-link" href="about.html">About Us</a>
                            <a class="btn btn-link" href="contact.html">Contact</a>
                            <a class="btn btn-link" href="offers.html">Offers</a>
                            <a class="btn btn-link" href="orders.html">My Orders</a>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <h5 class="fw-bold mb-3">Visit Us</h5>
                            <p class="mb-2"><i class="fa fa-map-marker-alt me-2 text-primary"></i>123 Fitness Avenue, Mumbai</p>
                            <p class="mb-2"><i class="fa fa-phone-alt me-2 text-primary"></i>+91 98765 43210</p>
                            <p class="mb-0"><i class="fa fa-envelope me-2 text-primary"></i>hello@proteingallery.in</p>
                        </div>
                    </div>
                </div>
                <div class="container-fluid copyright">
                    <div class="container py-4">
                        <div class="row align-items-center">
                            <div class="col-md-6 text-center text-md-start mb-2 mb-md-0">
                                © <a href="index.html">Protein Gallery</a> 2026. All Rights Reserved.
                            </div>
                            <div class="col-md-6 text-center text-md-end">
                                <a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a> | <a href="#">Return Policy</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    function init() {
        renderNavbar();
        renderFooter();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
