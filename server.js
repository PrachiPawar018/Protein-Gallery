const fs = require('fs');
const express = require('express');
const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');
const session = require('express-session');
const Razorpay = require('razorpay');
const nodemailer = require('nodemailer');
const cors = require('cors');
const path = require('path');
const dotenv = require('dotenv');

const envPath = fs.existsSync(path.resolve(__dirname, '.env'))
    ? path.resolve(__dirname, '.env')
    : path.resolve(__dirname, '.env.example');
dotenv.config({ path: envPath });
console.log(`Loaded environment variables from ${envPath}`);

const app = express();
const PORT = process.env.PORT || 5000;
const isProduction = process.env.NODE_ENV === 'production';

// Body Parsers & CORS
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({
    origin: true,
    credentials: true
}));

app.set('trust proxy', 1);

// Express Session Setup
app.use(session({
    secret: process.env.SESSION_SECRET || 'protein_gallery_secret_key_2026',
    resave: false,
    saveUninitialized: false,
    proxy: true,
    cookie: {
        maxAge: 1000 * 60 * 60 * 24 * 7, // 7 days
        httpOnly: true,
        sameSite: process.env.SESSION_COOKIE_SAMESITE || 'lax',
        secure: process.env.SESSION_COOKIE_SECURE === 'true' || isProduction
    }
}));

// MySQL Database Connection Pool
const db = mysql.createPool({
    host: process.env.DB_HOST || '127.0.0.1',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'root',
    database: process.env.DB_NAME || 'protein_gallery',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Test DB Connection
(async () => {
    try {
        const connection = await db.getConnection();
        console.log('Connected successfully to MySQL database: protein_gallery');
        connection.release();
    } catch (err) {
        console.warn('MySQL Database warning (check credentials/server if offline):', err.message);
    }
})();

// Razorpay Instance (Uses test key fallback if env missing)
const razorpay = new Razorpay({
    key_id: process.env.RAZORPAY_KEY_ID || 'rzp_test_ProteinGalleryKey',
    key_secret: process.env.RAZORPAY_KEY_SECRET || 'SecretProteinGallery123'
});

// Nodemailer Transporter for OTP
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER || 'helpreach18@gmail.com',
        pass: process.env.EMAIL_PASS || 'xgyp lyjw snna awjv'
    }
});

const EMAIL_FROM = process.env.EMAIL_FROM || process.env.EMAIL_USER || 'helpreach18@gmail.com';

async function sendAuthEmail(to, subject, text, html) {
    if (!to) return;

    try {
        await transporter.sendMail({
            from: `"Protein Gallery" <${EMAIL_FROM}>`,
            to,
            subject,
            text,
            html
        });
        console.log(`✅ Email sent successfully to ${to}`);
    } catch (error) {
        console.warn(`❌ Email could not be sent to ${to}:`, error.message);
    }
}

// ==========================================
// 1. AUTHENTICATION ENDPOINTS
// ==========================================

// Register User
app.post('/api/auth/register', async (req, res) => {
    try {
        const { name, email, phone_number, password } = req.body;

        if (!name || !email || !password) {
            return res.status(400).json({ success: false, message: 'Name, email, and password are required.' });
        }

        // Check if user already exists
        const [existing] = await db.query('SELECT id FROM users WHERE email = ?', [email]);
        if (existing.length > 0) {
            return res.status(400).json({ success: false, message: 'Email address is already registered.' });
        }

        // Hash password with BCrypt
        const salt = await bcrypt.genSalt(10);
        const password_hash = await bcrypt.hash(password, salt);

        // Default role = USER, default is_active = 1
        const [result] = await db.query(
            `INSERT INTO users (name, email, phone_number, password_hash, role, is_active, created_at)
             VALUES (?, ?, ?, ?, 'USER', 1, NOW())`,
            [name, email, phone_number || null, password_hash]
        );

        await sendAuthEmail(
            email,
            'Welcome to Protein Gallery!',
            `Hello ${name}, your account has been created successfully. Welcome to our family!`,
            `<h3>Welcome to Protein Gallery!</h3><p>Hello ${name}, your account has been created successfully. Welcome to our family!</p>`
        );

        res.status(201).json({
            success: true,
            message: 'Registration successful! Please login to continue.',
            userId: result.insertId
        });
    } catch (error) {
        console.error('Registration Error:', error);

        let message = 'Server error during registration.';
        if (error && error.code) {
            if (error.code === 'ER_ACCESS_DENIED_ERROR') {
                message = 'Database access denied. Check DB credentials in .env.';
            } else if (error.code === 'ER_BAD_DB_ERROR') {
                message = 'Database not found. Create the database and update DB_NAME in .env.';
            } else if (error.code === 'ER_NO_SUCH_TABLE') {
                message = 'Required table missing. Initialize the database schema first.';
            }
        }

        res.status(500).json({ success: false, message });
    }
});

// Login User
app.post('/api/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ success: false, message: 'Email and password are required.' });
        }

        const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
        if (users.length === 0) {
            return res.status(401).json({ success: false, message: 'Invalid email or password.' });
        }

        const user = users[0];

        if (!user.is_active) {
            return res.status(403).json({ success: false, message: 'Account is deactivated. Contact support.' });
        }

        const isMatch = await bcrypt.compare(password, user.password_hash);
        if (!isMatch) {
            return res.status(401).json({ success: false, message: 'Invalid email or password.' });
        }

        // Save session data
        req.session.user = {
            id: user.id,
            name: user.name,
            email: user.email,
            phone_number: user.phone_number,
            role: user.role
        };

        await sendAuthEmail(
            user.email,
            'Protein Gallery Security Alert',
            `Hello ${user.name}, your account was logged in successfully. If this wasn't you, please change your password immediately.`,
            `<h3>Security Alert</h3><p>Hello ${user.name}, your account was logged in successfully. If this wasn't you, please change your password immediately.</p>`
        );

        res.json({
            success: true,
            message: 'Login successful!',
            user: req.session.user,
            redirectUrl: user.role === 'ADMIN' ? 'dashboard.html' : 'index.html'
        });
    } catch (error) {
        console.error('Login Error:', error);
        res.status(500).json({ success: false, message: 'Server error during login.' });
    }
});

// Get Current User Profile
app.get('/api/auth/me', async (req, res) => {
    if (!req.session.user) {
        return res.json({ loggedIn: false });
    }

    try {
        const [users] = await db.query('SELECT id, name, email, phone_number, role, is_active, created_at FROM users WHERE id = ?', [req.session.user.id]);
        if (users.length === 0) {
            req.session.destroy();
            return res.json({ loggedIn: false });
        }

        res.json({
            loggedIn: true,
            user: users[0]
        });
    } catch (error) {
        console.error('Auth Me Error:', error);
        res.status(500).json({ loggedIn: false });
    }
});

// Logout User
app.post('/api/auth/logout', (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            return res.status(500).json({ success: false, message: 'Logout failed.' });
        }
        res.clearCookie('connect.sid');
        res.json({ success: true, message: 'Logged out successfully.' });
    });
});

// Forgot Password - Send OTP
app.post('/api/auth/forgot-password', async (req, res) => {
    try {
        const { email } = req.body;
        if (!email) {
            return res.status(400).json({ success: false, message: 'Email address is required.' });
        }

        const [users] = await db.query('SELECT id, name FROM users WHERE email = ?', [email]);
        if (users.length === 0) {
            return res.status(404).json({ success: false, message: 'No account found with this email address.' });
        }

        // Generate 6-digit OTP & 15-minute expiry
        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const otp_expiry = new Date(Date.now() + 15 * 60 * 1000); // 15 mins

        await db.query('UPDATE users SET reset_otp = ?, otp_expiry = ? WHERE email = ?', [otp, otp_expiry, email]);

        await sendAuthEmail(
            email,
            'Protein Gallery - Password Reset OTP',
            `Your password reset OTP is: ${otp}. It is valid for 15 minutes.`,
            `<h3>Protein Gallery Password Reset</h3><p>Your OTP code is: <strong>${otp}</strong></p><p>Valid for 15 minutes.</p>`
        );

        res.json({
            success: true,
            message: 'OTP has been generated and sent to your email.',
            devOtp: otp // Included for testing convenience
        });
    } catch (error) {
        console.error('Forgot Password Error:', error);
        res.status(500).json({ success: false, message: 'Failed to process forgot password request.' });
    }
});

// Verify OTP
app.post('/api/auth/verify-otp', async (req, res) => {
    try {
        const { email, otp } = req.body;
        if (!email || !otp) {
            return res.status(400).json({ success: false, message: 'Email and OTP are required.' });
        }

        const [users] = await db.query(
            'SELECT id, otp_expiry FROM users WHERE email = ? AND reset_otp = ?',
            [email, otp]
        );

        if (users.length === 0) {
            return res.status(400).json({ success: false, message: 'Invalid OTP code.' });
        }

        const user = users[0];
        if (new Date() > new Date(user.otp_expiry)) {
            return res.status(400).json({ success: false, message: 'OTP has expired. Please request a new one.' });
        }

        res.json({ success: true, message: 'OTP verified successfully.' });
    } catch (error) {
        console.error('Verify OTP Error:', error);
        res.status(500).json({ success: false, message: 'Failed to verify OTP.' });
    }
});

// Reset Password
app.post('/api/auth/reset-password', async (req, res) => {
    try {
        const { email, otp, newPassword } = req.body;
        if (!email || !otp || !newPassword) {
            return res.status(400).json({ success: false, message: 'Email, OTP, and new password are required.' });
        }

        const [users] = await db.query(
            'SELECT id, otp_expiry FROM users WHERE email = ? AND reset_otp = ?',
            [email, otp]
        );

        if (users.length === 0) {
            return res.status(400).json({ success: false, message: 'Invalid OTP or email.' });
        }

        const salt = await bcrypt.genSalt(10);
        const password_hash = await bcrypt.hash(newPassword, salt);

        await db.query(
            'UPDATE users SET password_hash = ?, reset_otp = NULL, otp_expiry = NULL WHERE email = ?',
            [password_hash, email]
        );

        await sendAuthEmail(
            email,
            'Protein Gallery Password Updated',
            'Your password has been reset successfully. If this was not you, contact support immediately.',
            '<h3>Password Updated</h3><p>Your password has been reset successfully. If this was not you, contact support immediately.</p>'
        );

        res.json({ success: true, message: 'Password reset successful! Please login with your new password.' });
    } catch (error) {
        console.error('Reset Password Error:', error);
        res.status(500).json({ success: false, message: 'Failed to reset password.' });
    }
});

// ==========================================
// 2. USER PROFILE ENDPOINTS
// ==========================================

// Update User Profile
app.put('/api/user/profile', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Unauthorized. Please login.' });
    }

    try {
        const { name, phone_number } = req.body;
        if (!name) {
            return res.status(400).json({ success: false, message: 'Name is required.' });
        }

        await db.query('UPDATE users SET name = ?, phone_number = ? WHERE id = ?', [
            name,
            phone_number || null,
            req.session.user.id
        ]);

        req.session.user.name = name;
        req.session.user.phone_number = phone_number || null;

        res.json({ success: true, message: 'Profile updated successfully!', user: req.session.user });
    } catch (error) {
        console.error('Update Profile Error:', error);
        res.status(500).json({ success: false, message: 'Failed to update profile.' });
    }
});

// Change Password
app.put('/api/user/change-password', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Unauthorized. Please login.' });
    }

    try {
        const { currentPassword, newPassword } = req.body;
        if (!currentPassword || !newPassword) {
            return res.status(400).json({ success: false, message: 'Current and new passwords are required.' });
        }

        const [users] = await db.query('SELECT password_hash FROM users WHERE id = ?', [req.session.user.id]);
        if (users.length === 0) {
            return res.status(404).json({ success: false, message: 'User not found.' });
        }

        const isMatch = await bcrypt.compare(currentPassword, users[0].password_hash);
        if (!isMatch) {
            return res.status(400).json({ success: false, message: 'Current password is incorrect.' });
        }

        const salt = await bcrypt.genSalt(10);
        const password_hash = await bcrypt.hash(newPassword, salt);

        await db.query('UPDATE users SET password_hash = ? WHERE id = ?', [password_hash, req.session.user.id]);

        await sendAuthEmail(
            req.session.user.email,
            'Protein Gallery Password Changed',
            'Your password has been changed successfully. If this was not you, contact support immediately.',
            '<h3>Password Changed</h3><p>Your password has been changed successfully. If this was not you, contact support immediately.</p>'
        );

        res.json({ success: true, message: 'Password changed successfully!' });
    } catch (error) {
        console.error('Change Password Error:', error);
        res.status(500).json({ success: false, message: 'Failed to change password.' });
    }
});

// ==========================================
// 3. PRODUCTS ENDPOINTS
// ==========================================

// Get All Active Products
app.get('/api/products', async (req, res) => {
    try {
        const { category, brand, search } = req.query;
        let sql = 'SELECT * FROM products WHERE is_active = 1';
        let params = [];

        if (category) {
            sql += ' AND category = ?';
            params.push(category);
        }
        if (brand) {
            sql += ' AND brand = ?';
            params.push(brand);
        }
        if (search) {
            sql += ' AND (name LIKE ? OR brand LIKE ? OR category LIKE ?)';
            const term = `%${search}%`;
            params.push(term, term, term);
        }

        sql += ' ORDER BY id DESC';

        const [products] = await db.query(sql, params);
        res.json({ success: true, products });
    } catch (error) {
        console.error('Get Products Error:', error);
        res.status(500).json({ success: false, message: 'Failed to fetch products.' });
    }
});

// Get Single Product
app.get('/api/products/:id', async (req, res) => {
    try {
        const [products] = await db.query('SELECT * FROM products WHERE id = ?', [req.params.id]);
        if (products.length === 0) {
            return res.status(404).json({ success: false, message: 'Product not found.' });
        }

        const product = products[0];

        // Fetch product reviews
        const [reviews] = await db.query(
            `SELECT r.*, u.name as user_name 
             FROM reviews r 
             JOIN users u ON r.user_id = u.id 
             WHERE r.product_id = ? 
             ORDER BY r.created_at DESC`,
            [product.id]
        );

        res.json({ success: true, product, reviews });
    } catch (error) {
        console.error('Get Product Error:', error);
        res.status(500).json({ success: false, message: 'Failed to fetch product details.' });
    }
});

// ==========================================
// 4. SHOPPING CART ENDPOINTS
// ==========================================

// Get Cart Items
app.get('/api/cart', async (req, res) => {
    if (!req.session.user) {
        return res.json({ success: true, items: [], totalAmount: 0 });
    }

    try {
        const [items] = await db.query(
            `SELECT c.id as cart_id, c.quantity, p.* 
             FROM cart c 
             JOIN products p ON c.product_id = p.id 
             WHERE c.user_id = ?`,
            [req.session.user.id]
        );

        let totalAmount = 0;
        items.forEach(item => {
            totalAmount += parseFloat(item.price) * item.quantity;
        });

        res.json({ success: true, items, totalAmount });
    } catch (error) {
        console.error('Get Cart Error:', error);
        res.status(500).json({ success: false, message: 'Failed to fetch cart items.' });
    }
});

// Add Item to Cart
app.post('/api/cart/add', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Please login to add products to your cart.' });
    }

    try {
        const { product_id, quantity } = req.body;
        const qty = parseInt(quantity) || 1;

        const [existing] = await db.query('SELECT id, quantity FROM cart WHERE user_id = ? AND product_id = ?', [
            req.session.user.id,
            product_id
        ]);

        if (existing.length > 0) {
            const newQty = existing[0].quantity + qty;
            await db.query('UPDATE cart SET quantity = ? WHERE id = ?', [newQty, existing[0].id]);
        } else {
            await db.query('INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)', [
                req.session.user.id,
                product_id,
                qty
            ]);
        }

        res.json({ success: true, message: 'Product added to cart!' });
    } catch (error) {
        console.error('Add Cart Error:', error);
        res.status(500).json({ success: false, message: 'Failed to add item to cart.' });
    }
});

// Update Cart Quantity
app.put('/api/cart/update', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Unauthorized.' });
    }

    try {
        const { cart_id, quantity } = req.body;
        if (quantity <= 0) {
            await db.query('DELETE FROM cart WHERE id = ? AND user_id = ?', [cart_id, req.session.user.id]);
        } else {
            await db.query('UPDATE cart SET quantity = ? WHERE id = ? AND user_id = ?', [
                quantity,
                cart_id,
                req.session.user.id
            ]);
        }

        res.json({ success: true, message: 'Cart updated.' });
    } catch (error) {
        console.error('Update Cart Error:', error);
        res.status(500).json({ success: false, message: 'Failed to update cart.' });
    }
});

// Remove Cart Item
app.delete('/api/cart/remove/:id', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Unauthorized.' });
    }

    try {
        await db.query('DELETE FROM cart WHERE id = ? AND user_id = ?', [req.params.id, req.session.user.id]);
        res.json({ success: true, message: 'Item removed from cart.' });
    } catch (error) {
        console.error('Remove Cart Error:', error);
        res.status(500).json({ success: false, message: 'Failed to remove item.' });
    }
});

// ==========================================
// 5. COUPON VERIFICATION ENDPOINT
// ==========================================
app.post('/api/coupons/apply', async (req, res) => {
    try {
        const { code, orderAmount } = req.body;
        if (!code) {
            return res.status(400).json({ success: false, message: 'Coupon code is required.' });
        }

        const [coupons] = await db.query(
            'SELECT * FROM coupons WHERE code = ? AND is_active = 1 AND expiry_date >= CURDATE()',
            [code.trim().toUpperCase()]
        );

        if (coupons.length === 0) {
            return res.status(404).json({ success: false, message: 'Invalid or expired coupon code.' });
        }

        const coupon = coupons[0];
        if (orderAmount < parseFloat(coupon.min_order_amount)) {
            return res.status(400).json({
                success: false,
                message: `Minimum order amount for code ${coupon.code} is ₹${coupon.min_order_amount}.`
            });
        }

        const discountAmount = (orderAmount * parseFloat(coupon.discount_percent)) / 100;

        res.json({
            success: true,
            coupon_code: coupon.code,
            discount_percent: coupon.discount_percent,
            discount_amount: discountAmount,
            message: `Coupon '${coupon.code}' applied successfully! (${coupon.discount_percent}% off)`
        });
    } catch (error) {
        console.error('Coupon Error:', error);
        res.status(500).json({ success: false, message: 'Failed to apply coupon.' });
    }
});

// ==========================================
// 6. CHECKOUT & RAZORPAY PAYMENT ENDPOINTS
// ==========================================

// Direct Checkout / COD Order Placement (Server-Side 18% GST calculation)
app.post('/api/checkout/place-order', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Please login to checkout.' });
    }

    try {
        const { shipping_address, coupon_code } = req.body;
        if (!shipping_address || !shipping_address.trim()) {
            return res.status(400).json({ success: false, message: 'Shipping address is required.' });
        }

        // Fetch user cart items
        const [cartItems] = await db.query(
            `SELECT c.product_id, c.quantity, p.price 
             FROM cart c 
             JOIN products p ON c.product_id = p.id 
             WHERE c.user_id = ?`,
            [req.session.user.id]
        );

        if (cartItems.length === 0) {
            return res.status(400).json({ success: false, message: 'Your cart is empty.' });
        }

        // Server-side financial calculations
        let subtotal = 0;
        cartItems.forEach(item => {
            subtotal += parseFloat(item.price) * item.quantity;
        });

        let discount_amount = 0;
        if (coupon_code) {
            const [coupons] = await db.query(
                'SELECT * FROM coupons WHERE code = ? AND is_active = 1 AND expiry_date >= CURDATE()',
                [coupon_code.trim().toUpperCase()]
            );
            if (coupons.length > 0 && subtotal >= parseFloat(coupons[0].min_order_amount)) {
                discount_amount = (subtotal * parseFloat(coupons[0].discount_percent)) / 100;
            }
        }

        const discountedSubtotal = Math.max(0, subtotal - discount_amount);
        const gst_amount = discountedSubtotal * 0.18; // Server-side 18% GST
        const total_amount = discountedSubtotal + gst_amount;
        const tracking_number = 'PG-TRACK-' + Math.floor(100000 + Math.random() * 900000);

        // Insert into orders table (status = PENDING, payment_method = COD)
        const [orderResult] = await db.query(
            `INSERT INTO orders (user_id, total_amount, discount_amount, coupon_code, status, shipping_address, tracking_number, payment_method, created_at)
             VALUES (?, ?, ?, ?, 'PENDING', ?, ?, 'COD', NOW())`,
            [
                req.session.user.id,
                total_amount,
                discount_amount,
                coupon_code || null,
                shipping_address,
                tracking_number
            ]
        );

        const order_id = orderResult.insertId;

        // Insert into order_items table
        for (const item of cartItems) {
            await db.query(
                `INSERT INTO order_items (order_id, product_id, quantity, price)
                 VALUES (?, ?, ?, ?)`,
                [order_id, item.product_id, item.quantity, item.price]
            );
        }

        // Clear user cart
        await db.query('DELETE FROM cart WHERE user_id = ?', [req.session.user.id]);

        res.json({
            success: true,
            message: 'Order placed successfully! Payment Method: Cash on Delivery (COD).',
            order_id,
            tracking_number,
            total_amount
        });
    } catch (error) {
        console.error('Place Order Error:', error);
        res.status(500).json({ success: false, message: 'Failed to place order.' });
    }
});

// Create Order & Razorpay Order ID
app.post('/api/checkout/create-razorpay-order', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Please login to checkout.' });
    }

    try {
        const { coupon_code, shipping_address } = req.body;

        // Fetch user cart
        const [cartItems] = await db.query(
            `SELECT c.product_id, c.quantity, p.price 
             FROM cart c 
             JOIN products p ON c.product_id = p.id 
             WHERE c.user_id = ?`,
            [req.session.user.id]
        );

        if (cartItems.length === 0) {
            return res.status(400).json({ success: false, message: 'Your shopping cart is empty.' });
        }

        let subtotal = 0;
        cartItems.forEach(item => {
            subtotal += parseFloat(item.price) * item.quantity;
        });

        let discount_amount = 0;
        if (coupon_code) {
            const [coupons] = await db.query(
                'SELECT * FROM coupons WHERE code = ? AND is_active = 1 AND expiry_date >= CURDATE()',
                [coupon_code.trim().toUpperCase()]
            );
            if (coupons.length > 0 && subtotal >= parseFloat(coupons[0].min_order_amount)) {
                discount_amount = (subtotal * parseFloat(coupons[0].discount_percent)) / 100;
            }
        }

        const total_amount = Math.max(0, subtotal - discount_amount);

        // Create Razorpay Order
        const razorpayOrder = await razorpay.orders.create({
            amount: Math.round(total_amount * 100), // in paise
            currency: 'INR',
            receipt: `receipt_order_${Date.now()}`
        });

        res.json({
            success: true,
            razorpay_order_id: razorpayOrder.id,
            amount: total_amount,
            currency: 'INR',
            key: process.env.RAZORPAY_KEY_ID || 'rzp_test_ProteinGalleryKey'
        });
    } catch (error) {
        console.error('Create Razorpay Order Error:', error);
        res.status(500).json({ success: false, message: 'Failed to initiate Razorpay order.' });
    }
});

// Verify Payment & Finalize Order
app.post('/api/checkout/verify-payment', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Unauthorized.' });
    }

    try {
        const {
            razorpay_order_id,
            razorpay_payment_id,
            razorpay_signature,
            shipping_address,
            coupon_code,
            payment_method
        } = req.body;

        // Fetch cart items
        const [cartItems] = await db.query(
            `SELECT c.product_id, c.quantity, p.price 
             FROM cart c 
             JOIN products p ON c.product_id = p.id 
             WHERE c.user_id = ?`,
            [req.session.user.id]
        );

        if (cartItems.length === 0) {
            return res.status(400).json({ success: false, message: 'Cart is empty.' });
        }

        let subtotal = 0;
        cartItems.forEach(item => {
            subtotal += parseFloat(item.price) * item.quantity;
        });

        let discount_amount = 0;
        if (coupon_code) {
            const [coupons] = await db.query('SELECT discount_percent FROM coupons WHERE code = ?', [coupon_code]);
            if (coupons.length > 0) {
                discount_amount = (subtotal * parseFloat(coupons[0].discount_percent)) / 100;
            }
        }

        const total_amount = Math.max(0, subtotal - discount_amount);
        const tracking_number = 'PG-TRACK-' + Math.floor(100000 + Math.random() * 900000);

        // 1. Create order record
        const [orderResult] = await db.query(
            `INSERT INTO orders (user_id, total_amount, discount_amount, coupon_code, status, shipping_address, tracking_number, payment_method, created_at)
             VALUES (?, ?, ?, ?, 'CONFIRMED', ?, ?, ?, NOW())`,
            [
                req.session.user.id,
                total_amount,
                discount_amount,
                coupon_code || null,
                shipping_address,
                tracking_number,
                payment_method || 'RAZORPAY'
            ]
        );

        const order_id = orderResult.insertId;

        // 2. Create order_items records
        for (const item of cartItems) {
            await db.query(
                `INSERT INTO order_items (order_id, product_id, quantity, price)
                 VALUES (?, ?, ?, ?)`,
                [order_id, item.product_id, item.quantity, item.price]
            );
        }

        // 3. Create payment record
        await db.query(
            `INSERT INTO payments (order_id, razorpay_order_id, razorpay_payment_id, razorpay_signature, status, paid_at)
             VALUES (?, ?, ?, ?, 'SUCCESS', NOW())`,
            [order_id, razorpay_order_id, razorpay_payment_id, razorpay_signature]
        );

        // 4. Clear User Cart
        await db.query('DELETE FROM cart WHERE user_id = ?', [req.session.user.id]);

        res.json({
            success: true,
            message: 'Payment verified and order placed successfully!',
            order_id,
            tracking_number
        });
    } catch (error) {
        console.error('Verify Payment Error:', error);
        res.status(500).json({ success: false, message: 'Failed to process payment and order.' });
    }
});

// ==========================================
// 7. MY ORDERS ENDPOINTS
// ==========================================

// Get All Orders for Logged-In User
app.get('/api/orders', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Unauthorized. Please login.' });
    }

    try {
        const [orders] = await db.query(
            `SELECT o.*, p.razorpay_payment_id, p.status as payment_status 
             FROM orders o 
             LEFT JOIN payments p ON o.id = p.order_id 
             WHERE o.user_id = ? 
             ORDER BY o.created_at DESC`,
            [req.session.user.id]
        );

        // Fetch items for each order
        for (let order of orders) {
            const [items] = await db.query(
                `SELECT oi.*, pr.name as product_name, pr.image_url, pr.brand 
                 FROM order_items oi 
                 JOIN products pr ON oi.product_id = pr.id 
                 WHERE oi.order_id = ?`,
                [order.id]
            );
            order.items = items;
        }

        res.json({ success: true, orders });
    } catch (error) {
        console.error('Get Orders Error:', error);
        res.status(500).json({ success: false, message: 'Failed to fetch user orders.' });
    }
});

// ==========================================
// 8. PRODUCT REVIEWS ENDPOINTS
// ==========================================

// Helper function to update product rating_avg automatically
async function updateProductRatingAvg(productId) {
    try {
        const [rows] = await db.query('SELECT AVG(rating) as avg_rating FROM reviews WHERE product_id = ?', [productId]);
        const avgRating = rows[0].avg_rating ? parseFloat(rows[0].avg_rating).toFixed(1) : 0.0;
        await db.query('UPDATE products SET rating_avg = ? WHERE id = ?', [avgRating, productId]);
    } catch (err) {
        console.error('Error updating product rating average:', err);
    }
}

// Add Review
app.post('/api/reviews', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Please login to post a review.' });
    }

    try {
        const { product_id, rating, comment } = req.body;
        if (!product_id || !rating || !comment) {
            return res.status(400).json({ success: false, message: 'Product ID, rating, and comment are required.' });
        }

        // Check if user has reviewed this product
        const [existing] = await db.query('SELECT id FROM reviews WHERE user_id = ? AND product_id = ?', [
            req.session.user.id,
            product_id
        ]);

        if (existing.length > 0) {
            return res.status(400).json({ success: false, message: 'You have already reviewed this product.' });
        }

        await db.query(
            'INSERT INTO reviews (user_id, product_id, rating, comment, created_at) VALUES (?, ?, ?, ?, NOW())',
            [req.session.user.id, product_id, rating, comment]
        );

        // Recalculate average rating
        await updateProductRatingAvg(product_id);

        res.status(201).json({ success: true, message: 'Review added successfully!' });
    } catch (error) {
        console.error('Add Review Error:', error);
        res.status(500).json({ success: false, message: 'Failed to submit review.' });
    }
});

// Edit Review
app.put('/api/reviews/:id', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Unauthorized.' });
    }

    try {
        const { rating, comment } = req.body;
        const [reviews] = await db.query('SELECT product_id FROM reviews WHERE id = ? AND user_id = ?', [
            req.params.id,
            req.session.user.id
        ]);

        if (reviews.length === 0) {
            return res.status(404).json({ success: false, message: 'Review not found or unauthorized.' });
        }

        const productId = reviews[0].product_id;

        await db.query('UPDATE reviews SET rating = ?, comment = ? WHERE id = ? AND user_id = ?', [
            rating,
            comment,
            req.params.id,
            req.session.user.id
        ]);

        await updateProductRatingAvg(productId);

        res.json({ success: true, message: 'Review updated successfully!' });
    } catch (error) {
        console.error('Edit Review Error:', error);
        res.status(500).json({ success: false, message: 'Failed to update review.' });
    }
});

// Delete Review
app.delete('/api/reviews/:id', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Unauthorized.' });
    }

    try {
        const [reviews] = await db.query('SELECT product_id FROM reviews WHERE id = ? AND user_id = ?', [
            req.params.id,
            req.session.user.id
        ]);

        if (reviews.length === 0) {
            return res.status(404).json({ success: false, message: 'Review not found or unauthorized.' });
        }

        const productId = reviews[0].product_id;

        await db.query('DELETE FROM reviews WHERE id = ? AND user_id = ?', [req.params.id, req.session.user.id]);

        await updateProductRatingAvg(productId);

        res.json({ success: true, message: 'Review deleted.' });
    } catch (error) {
        console.error('Delete Review Error:', error);
        res.status(500).json({ success: false, message: 'Failed to delete review.' });
    }
});

// Get Logged-In User's Reviews
app.get('/api/user/reviews', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Unauthorized.' });
    }

    try {
        const [reviews] = await db.query(
            `SELECT r.*, p.name as product_name, p.image_url, p.brand
             FROM reviews r
             JOIN products p ON r.product_id = p.id
             WHERE r.user_id = ?
             ORDER BY r.created_at DESC`,
            [req.session.user.id]
        );
        res.json({ success: true, reviews });
    } catch (error) {
        console.error('Get User Reviews Error:', error);
        res.status(500).json({ success: false, message: 'Failed to fetch reviews.' });
    }
});

// ==========================================
// 9. ADMIN DASHBOARD & MANAGEMENT ENDPOINTS
// ==========================================

// Middleware for Admin check
function requireAdmin(req, res, next) {
    if (!req.session.user || req.session.user.role !== 'ADMIN') {
        return res.status(403).json({ success: false, message: 'Admin access required.' });
    }
    next();
}

// Get Admin Overview Stats
app.get('/api/admin/stats', requireAdmin, async (req, res) => {
    try {
        const [[ordersCount]] = await db.query('SELECT COUNT(*) as total_orders, COALESCE(SUM(total_amount), 0) as total_sales FROM orders WHERE status = "CONFIRMED" OR status = "DELIVERED"');
        const [[usersCount]] = await db.query('SELECT COUNT(*) as total_users FROM users WHERE role = "USER"');
        const [[productsCount]] = await db.query('SELECT COUNT(*) as total_products FROM products');

        res.json({
            success: true,
            stats: {
                totalOrders: ordersCount.total_orders,
                totalSales: parseFloat(ordersCount.total_sales),
                totalUsers: usersCount.total_users,
                totalProducts: productsCount.total_products
            }
        });
    } catch (error) {
        console.error('Admin Stats Error:', error);
        res.status(500).json({ success: false, message: 'Failed to fetch admin stats.' });
    }
});

// Get All Orders for Admin
app.get('/api/admin/orders', requireAdmin, async (req, res) => {
    try {
        const [orders] = await db.query(
            `SELECT o.*, u.name as customer_name, u.email as customer_email 
             FROM orders o 
             JOIN users u ON o.user_id = u.id 
             ORDER BY o.created_at DESC`
        );

        res.json({ success: true, orders });
    } catch (error) {
        console.error('Admin Get Orders Error:', error);
        res.status(500).json({ success: false, message: 'Failed to fetch orders.' });
    }
});

// Update Order Status
app.put('/api/admin/orders/:id/status', requireAdmin, async (req, res) => {
    try {
        const { status } = req.body;
        await db.query('UPDATE orders SET status = ? WHERE id = ?', [status, req.params.id]);
        res.json({ success: true, message: `Order #${req.params.id} status updated to ${status}.` });
    } catch (error) {
        console.error('Admin Update Order Error:', error);
        res.status(500).json({ success: false, message: 'Failed to update order status.' });
    }
});

// Serve Static Files (Frontend HTML, CSS, JS, Images)
app.use(express.static(path.join(__dirname)));

// Catch-all route to serve index.html for undefined HTML pages
app.get('*', (req, res) => {
    if (!req.path.startsWith('/api')) {
        res.sendFile(path.join(__dirname, 'index.html'));
    } else {
        res.status(404).json({ success: false, message: 'API Endpoint Not Found' });
    }
});

// Start Express Server
app.listen(PORT, () => {
    console.log(`====================================================`);
    console.log(` Protein Gallery Server running on http://127.0.0.1:${PORT}`);
    console.log(`====================================================`);
});
