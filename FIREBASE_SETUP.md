# Firebase Database Setup Guide for Protein Gallery

## Overview

User data (registrations, logins, password resets) is now stored in **Firebase Realtime Database** with automatic fallback to browser localStorage if Firebase is not available.

## Quick Setup (2 minutes)

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a project"
3. Enter project name: `protein-gallery`
4. Accept terms and click "Create project"
5. Wait for project to be created

### Step 2: Get Firebase Credentials

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll down to "Your apps" section
3. Click on Web app icon (`</>`), or create new if none exists
4. Copy the **firebaseConfig** object (it looks like this):

```javascript
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "your-project.firebaseapp.com",
  databaseURL: "https://your-project-default-rtdb.firebaseio.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "1:YOUR_APP_ID:web:YOUR_WEB_ID",
};
```

### Step 3: Update firebase-config.js

1. Open `firebase-config.js` in your project folder
2. Replace the placeholder `firebaseConfig` with your actual credentials from Step 2
3. Save the file

### Step 4: Enable Realtime Database

1. In Firebase Console, go to **Realtime Database**
2. Click "Create Database"
3. Choose region (closest to your users, e.g., "us-central1" or "asia-southeast1")
4. Select "Start in Test Mode" (for development)
5. Click "Enable"

### Step 5: Set Database Rules (Optional but Recommended)

For security in production, add these rules in Realtime Database → Rules:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "auth.uid === $uid",
        ".write": "auth.uid === $uid",
        ".validate": "newData.hasChildren(['email', 'name', 'phone', 'password'])"
      }
    }
  }
}
```

## Testing

### Test 1: Register New User

1. Go to http://127.0.0.1:8000/register.html
2. Fill in form:
   - Name: "John Doe"
   - Email: "john@example.com"
   - Phone: "9876543210"
   - Password: "password123"
3. Click "Register Account"
4. Should redirect to login page

### Test 2: Verify in Firebase Console

1. Go to Firebase Console → Realtime Database
2. Look for `users` → `john_example_com` entry
3. Should see your user data stored there

### Test 3: Login with Registered Account

1. Go to http://127.0.0.1:8000/login.html
2. Email: "john@example.com"
3. Password: "password123"
4. Should login successfully and redirect to home page

## Data Structure in Firebase

User data is stored with this structure:

```
users/
  ├─ john_example_com/
  │  ├─ name: "John Doe"
  │  ├─ email: "john@example.com"
  │  ├─ phone: "9876543210"
  │  ├─ password: "password123" (PLAINTEXT - NOT FOR PRODUCTION!)
  │  ├─ createdAt: "2026-07-23T10:30:00Z"
  │  └─ updatedAt: "2026-07-23T10:30:00Z"
  │
  └─ jane_example_com/
     ├─ name: "Jane Smith"
     ├─ email: "jane@example.com"
     └─ ...
```

**Email encoding:** Special characters in emails (. # $ [ ]) are replaced with underscores for Firebase compatibility.

## Features Included

✅ **User Registration** - Stores user data in Firebase  
✅ **User Login** - Validates credentials from Firebase  
✅ **Password Reset** - Updates password in Firebase with OTP verification  
✅ **Fallback Storage** - Uses localStorage if Firebase unavailable  
✅ **Session Management** - Current user stored in localStorage as `pg_currentUser`

## LocalStorage Data

- `pg_users` - Array of all registered users (backup)
- `pg_currentUser` - Current logged-in user info

## Troubleshooting

### "Registration failed" Error

- Check that Firebase credentials are correct in `firebase-config.js`
- Verify Realtime Database is enabled and in Test Mode
- Check browser console for errors (F12)

### Data not showing in Firebase

- Verify database rules allow writes
- Check email was formatted correctly (special chars replaced with \_)
- Ensure `createdAt` timestamp is included

### Can't login after registration

- Verify user data exists in Firebase Console
- Check password matches exactly (case-sensitive)
- Ensure localStorage fallback is working (if Firebase fails)

## Security Notes

⚠️ **WARNING:** This setup stores passwords in plaintext, which is NOT secure for production!

For production deployment:

1. Use Firebase Authentication instead of custom registration
2. Hash passwords using bcrypt or similar
3. Use environment variables for firebase-config
4. Implement proper database rules with security
5. Add rate limiting for login attempts
6. Enable HTTPS only

## Additional Resources

- [Firebase Console](https://console.firebase.google.com)
- [Firebase Realtime Database Docs](https://firebase.google.com/docs/database)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
