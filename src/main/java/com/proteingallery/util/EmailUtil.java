package com.proteingallery.util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtil {

    private static Session createMailSession() {
        String from = AppConfig.SMTP_USER;
        String password = AppConfig.SMTP_PASSWORD;
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });
    }

    public static void sendOrderConfirmation(String toEmail, int orderId, String totalAmount, String address) {
        try {
            Session session = createMailSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(AppConfig.SMTP_USER, "Protein Gallery"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Order Confirmation - #" + orderId);

            String htmlContent = "<h2>Thank you for your order!</h2>" +
                    "<p>Your order <strong>#" + orderId + "</strong> has been successfully confirmed.</p>" +
                    "<p><strong>Total Amount:</strong> ₹" + totalAmount + "</p>" +
                    "<p><strong>Shipping Address:</strong><br/>" + address + "</p>" +
                    "<br/><p>We will notify you once it ships. Thanks for choosing Protein Gallery!</p>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println("Order confirmation email sent to " + toEmail);
        } catch (Exception e) {
            System.err.println("Failed to send order confirmation email to " + toEmail);
            e.printStackTrace();
        }
    }

    /**
     * Sends a 6-digit OTP to the given email for password reset.
     */
    public static void sendOtpEmail(String toEmail, String userName, String otp) {
        try {
            Session session = createMailSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(AppConfig.SMTP_USER, "Protein Gallery"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("🔐 Password Reset OTP - Protein Gallery");

            String htmlContent =
                "<!DOCTYPE html><html><head>" +
                "<style>" +
                "  body { font-family: 'Inter', Arial, sans-serif; background: #f8f9fa; margin:0; padding:0; }" +
                "  .container { max-width:560px; margin:40px auto; background:#ffffff; border-radius:12px; overflow:hidden; box-shadow:0 4px 20px rgba(0,0,0,0.08); }" +
                "  .header { background: linear-gradient(135deg,#FF6B35,#f7931e); padding:32px 40px; text-align:center; }" +
                "  .header h1 { color:#fff; margin:0; font-size:24px; letter-spacing:1px; }" +
                "  .body { padding:40px; }" +
                "  .otp-box { background:#f0f4ff; border:2px dashed #FF6B35; border-radius:12px; text-align:center; padding:24px; margin:28px 0; }" +
                "  .otp-code { font-size:42px; font-weight:800; letter-spacing:10px; color:#FF6B35; }" +
                "  .note { font-size:13px; color:#888; margin-top:8px; }" +
                "  .footer { background:#2C3E50; padding:20px 40px; text-align:center; color:#aaa; font-size:12px; }" +
                "  p { color:#444; line-height:1.7; }" +
                "</style></head><body>" +
                "<div class='container'>" +
                "  <div class='header'><h1>🏋️ Protein Gallery</h1></div>" +
                "  <div class='body'>" +
                "    <p>Hi <strong>" + escapeHtml(userName) + "</strong>,</p>" +
                "    <p>We received a request to reset your password. Use the OTP below to continue:</p>" +
                "    <div class='otp-box'>" +
                "      <div class='otp-code'>" + otp + "</div>" +
                "      <div class='note'>⏱️ This OTP is valid for <strong>10 minutes</strong> only.</div>" +
                "    </div>" +
                "    <p>If you did NOT request a password reset, please ignore this email. Your account remains secure.</p>" +
                "    <p style='margin-top:32px;'>Stay strong,<br/><strong>The Protein Gallery Team 💪</strong></p>" +
                "  </div>" +
                "  <div class='footer'>© 2024 Protein Gallery · Nashik, Maharashtra, India<br/>" +
                "  support@proteingallery.com · +91 98765 43210</div>" +
                "</div></body></html>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println("OTP email sent to " + toEmail);
        } catch (Exception e) {
            System.err.println("Failed to send OTP email to " + toEmail);
            e.printStackTrace();
        }
    }

    private static String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
