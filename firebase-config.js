// Firebase Configuration
// Replace these values with your own Firebase project credentials from https://console.firebase.google.com

const firebaseConfig = {
    apiKey: "AIzaSyDemoKey123456789ABCDEFGHIJKLMNOPQRST",
    authDomain: "protein-gallery-demo.firebaseapp.com",
    databaseURL: "https://protein-gallery-demo-default-rtdb.firebaseio.com",
    projectId: "protein-gallery-demo",
    storageBucket: "protein-gallery-demo.appspot.com",
    messagingSenderId: "1234567890",
    appId: "1:1234567890:web:abcdef1234567890ghijkl"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
const database = firebase.database();

// Auth Manager with Firebase & LocalStorage Fallback
const AuthManager = {
    // Check if Firebase is available
    isFirebaseReady: () => {
        return typeof firebase !== 'undefined' && firebase.database;
    },

    // Register user
    registerUser: async (name, email, phone, password) => {
        try {
            if (AuthManager.isFirebaseReady()) {
                // Firebase path: users/{email_without_special_chars}/
                const safeEmail = email.replace(/[.#$[\]]/g, '_');
                
                const userData = {
                    name,
                    email,
                    phone,
                    password, // WARNING: Never store plain passwords in production!
                    createdAt: new Date().toISOString(),
                    updatedAt: new Date().toISOString()
                };

                await database.ref('users/' + safeEmail).set(userData);
                
                // Also store in localStorage as backup
                const users = JSON.parse(localStorage.getItem('pg_users') || '[]');
                users.push(userData);
                localStorage.setItem('pg_users', JSON.stringify(users));

                return { success: true, message: 'Account created successfully!' };
            } else {
                // Fallback to localStorage
                const users = JSON.parse(localStorage.getItem('pg_users') || '[]');
                if (users.some(u => u.email === email)) {
                    return { success: false, message: 'Email already registered' };
                }
                users.push({ name, email, phone, password, createdAt: new Date().toISOString() });
                localStorage.setItem('pg_users', JSON.stringify(users));
                return { success: true, message: 'Account created (Local storage)' };
            }
        } catch (error) {
            return { success: false, message: error.message };
        }
    },

    // Login user
    loginUser: async (email, password) => {
        try {
            if (AuthManager.isFirebaseReady()) {
                const safeEmail = email.replace(/[.#$[\]]/g, '_');
                const snapshot = await database.ref('users/' + safeEmail).once('value');
                const user = snapshot.val();

                if (user && user.password === password) {
                    localStorage.setItem('pg_currentUser', JSON.stringify({ name: user.name, email: user.email, phone: user.phone }));
                    return { success: true, user };
                } else {
                    return { success: false, message: 'Invalid credentials' };
                }
            } else {
                // Fallback to localStorage
                const users = JSON.parse(localStorage.getItem('pg_users') || '[]');
                const user = users.find(u => u.email === email && u.password === password);
                if (user) {
                    localStorage.setItem('pg_currentUser', JSON.stringify({ name: user.name, email: user.email, phone: user.phone }));
                    return { success: true, user };
                }
                return { success: false, message: 'Invalid credentials' };
            }
        } catch (error) {
            return { success: false, message: error.message };
        }
    },

    // Reset password
    resetPassword: async (email, newPassword) => {
        try {
            if (AuthManager.isFirebaseReady()) {
                const safeEmail = email.replace(/[.#$[\]]/g, '_');
                await database.ref('users/' + safeEmail + '/password').set(newPassword);
                
                // Update localStorage too
                const users = JSON.parse(localStorage.getItem('pg_users') || '[]');
                const user = users.find(u => u.email === email);
                if (user) {
                    user.password = newPassword;
                    localStorage.setItem('pg_users', JSON.stringify(users));
                }

                return { success: true, message: 'Password updated successfully!' };
            } else {
                // Fallback to localStorage
                const users = JSON.parse(localStorage.getItem('pg_users') || '[]');
                const user = users.find(u => u.email === email);
                if (user) {
                    user.password = newPassword;
                    localStorage.setItem('pg_users', JSON.stringify(users));
                    return { success: true, message: 'Password updated!' };
                }
                return { success: false, message: 'User not found' };
            }
        } catch (error) {
            return { success: false, message: error.message };
        }
    },

    // Save user profile data
    saveUserData: async (email, userData) => {
        try {
            if (AuthManager.isFirebaseReady()) {
                const safeEmail = email.replace(/[.#$[\]]/g, '_');
                await database.ref('users/' + safeEmail).update({
                    ...userData,
                    updatedAt: new Date().toISOString()
                });
                return { success: true };
            } else {
                const users = JSON.parse(localStorage.getItem('pg_users') || '[]');
                const user = users.find(u => u.email === email);
                if (user) {
                    Object.assign(user, userData);
                    localStorage.setItem('pg_users', JSON.stringify(users));
                }
                return { success: true };
            }
        } catch (error) {
            return { success: false, message: error.message };
        }
    },

    // Logout
    logout: () => {
        localStorage.removeItem('pg_currentUser');
        return { success: true };
    }
};
