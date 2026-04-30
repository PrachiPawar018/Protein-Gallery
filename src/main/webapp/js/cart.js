function updateCartCount() {
    fetch('cart/count', {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(response => response.json())
    .then(data => {
        const badge = document.getElementById('cart-badge');
        if (badge && data.count !== undefined) {
            badge.innerText = data.count;
            if (data.count > 0) {
                badge.style.display = 'inline-block';
            } else {
                badge.style.display = 'none';
            }
        }
    })
    .catch(error => console.error('Error fetching cart count:', error));
}

function updateQuantity(cartId, quantity) {
    if (quantity < 1) return;
    
    const formData = new URLSearchParams();
    formData.append('cartId', cartId);
    formData.append('quantity', quantity);
    formData.append('csrf_token', window.csrfToken || '');

    fetch('cart/update', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            window.location.reload();
        }
    });
}

function removeItem(cartId) {
    const formData = new URLSearchParams();
    formData.append('cartId', cartId);
    formData.append('csrf_token', window.csrfToken || '');

    fetch('cart/remove', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            window.location.reload();
        }
    });
}

document.addEventListener('DOMContentLoaded', () => {
    updateCartCount();
});
