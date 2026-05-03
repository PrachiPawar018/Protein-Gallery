package com.proteingallery.util;

public class AppConfig {
    
    // Database Configuration
    public static final String DB_URL = getEnvOrDefault("DB_URL", "jdbc:mysql://localhost:3306/protein_gallery?useSSL=false&serverTimezone=UTC");
    public static final String DB_USER = getEnvOrDefault("DB_USER", "root");
    public static final String DB_PASSWORD = getEnvOrDefault("DB_PASSWORD", "root"); // Change this to your local pass or use env

    // Razorpay Configuration
    public static final String RAZORPAY_KEY_ID = getEnvOrDefault("RAZORPAY_KEY_ID", "test_key_id");
    public static final String RAZORPAY_KEY_SECRET = getEnvOrDefault("RAZORPAY_KEY_SECRET", "test_key_secret");

    // Email Configuration
    public static final String SMTP_HOST = getEnvOrDefault("SMTP_HOST", "smtp.gmail.com");
    public static final String SMTP_PORT = getEnvOrDefault("SMTP_PORT", "587");
    public static final boolean SMTP_TLS = Boolean.parseBoolean(getEnvOrDefault("SMTP_TLS", "true"));
    public static final String SMTP_USER = getEnvOrDefault("SMTP_USER", "prachipawar5133@gmail.com");
    public static final String SMTP_PASSWORD = getEnvOrDefault("SMTP_PASSWORD", "xraxfoacdqwahcsj");

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.trim().isEmpty()) ? value : defaultValue;
    }
}
