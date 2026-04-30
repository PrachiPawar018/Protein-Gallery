package com.proteingallery.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // Hash a plain text password using BCrypt
    public static String hashPassword(String plainTextPassword) {
        // Gensalt with log_rounds=12 is a good balance between security and performance
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(12));
    }

    // Check if a plain text password matches a hashed password
    public static boolean checkPassword(String plainTextPassword, String hashedPassword) {
        if (hashedPassword == null || !hashedPassword.startsWith("$2a$")) {
            return false;
        }
        return BCrypt.checkpw(plainTextPassword, hashedPassword);
    }
}
