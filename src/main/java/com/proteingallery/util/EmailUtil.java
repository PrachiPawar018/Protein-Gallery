package com.proteingallery.util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class EmailUtil {

    private static Session createMailSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host", AppConfig.SMTP_HOST);
        props.put("mail.smtp.port", AppConfig.SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", String.valueOf(AppConfig.SMTP_TLS));
        props.put("mail.smtp.starttls.required", String.valueOf(AppConfig.SMTP_TLS));
        props.put("mail.smtp.ssl.trust", AppConfig.SMTP_HOST);

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(AppConfig.SMTP_USER, AppConfig.SMTP_PASSWORD);
            }
        });
    }

    public static boolean sendEmail(String toEmail, String subject, String htmlBody) {
        try {
            Session session = createMailSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(AppConfig.SMTP_USER, "Protein Gallery"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println("Email sent successfully to " + toEmail + " with subject: " + subject);
            return true;
        } catch (Exception e) {
            System.err.println("Failed to send email to " + toEmail + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static void sendWelcomeEmail(String toEmail, String userName) {
        String subject = "Welcome to Protein Gallery";
        String body = "<html><body style='background:#0f172a;color:#f8fafc;font-family:Inter,Arial,sans-serif;'>"
                + "<div style='max-width:650px;margin:0 auto;padding:32px;background:#111827;border-radius:20px;'>"
                + "<h1 style='color:#ff6b35;margin-bottom:0.5rem;'>Welcome, " + escapeHtml(userName) + "!</h1>"
                + "<p style='color:#cbd5e1;font-size:1rem;line-height:1.8;'>Thanks for registering at <strong>Protein Gallery</strong>. Your fitness journey is important to us.</p>"
                + "<div style='background:#111827;border:1px solid rgba(255,107,53,0.15);border-radius:16px;padding:20px;margin:24px 0;'>"
                + "<p style='margin:0;color:#f8fafc;'><strong>What to expect:</strong></p>"
                + "<ul style='padding-left:1.2rem;color:#cbd5e1;'>"
                + "<li>Order confirmations and shipping updates</li>"
                + "<li>New product launches and promotions</li>"
                + "<li>Fast support for your supplement questions</li>"
                + "</ul></div>"
                + "<p style='color:#cbd5e1;'>If you need help, reply to this email or visit our website.</p>"
                + "<p style='margin-top:32px;color:#f8fafc;'>Stay strong,<br>The Protein Gallery Team</p>"
                + "</div></body></html>";
        sendEmail(toEmail, subject, body);
    }

    public static void sendOrderConfirmation(int orderId) {
        String sql = "SELECT o.total_amount, o.discount_amount, o.coupon_code, o.shipping_address, o.status, u.email, u.name "
                + "FROM orders o JOIN users u ON o.user_id = u.id WHERE o.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String email = rs.getString("email");
                    String name = rs.getString("name");
                    BigDecimal totalAmount = rs.getBigDecimal("total_amount");
                    BigDecimal discountAmount = rs.getBigDecimal("discount_amount");
                    String coupon = rs.getString("coupon_code");
                    String address = rs.getString("shipping_address");
                    String status = rs.getString("status");

                    String itemsHtml = buildOrderItemsHtml(orderId);
                    String subject = "Order Confirmation - #" + orderId;
                    String body = "<html><body style='background:#0f172a;color:#f8fafc;font-family:Inter,Arial,sans-serif;'>"
                            + "<div style='max-width:700px;margin:0 auto;padding:32px;background:#111827;border-radius:20px;'>"
                            + "<h1 style='color:#ff6b35;'>Order Confirmed!</h1>"
                            + "<p style='color:#cbd5e1;font-size:1rem;'>Hi " + escapeHtml(name) + ", your order <strong>" + orderId + "</strong> is confirmed.</p>"
                            + "<div style='margin:24px 0;padding:24px;background:#1f2937;border-radius:16px;'>"
                            + "<h2 style='color:#f8fafc;margin-bottom:12px;'>Order summary</h2>"
                            + itemsHtml
                            + "<div style='margin-top:20px;'>"
                            + "<p style='margin:4px 0;color:#cbd5e1;'><strong>Total:</strong> ₹" + totalAmount + "</p>"
                            + "<p style='margin:4px 0;color:#cbd5e1;'><strong>Discount:</strong> ₹" + discountAmount + "</p>"
                            + (coupon != null ? "<p style='margin:4px 0;color:#cbd5e1;'><strong>Coupon:</strong> " + escapeHtml(coupon) + "</p>" : "")
                            + "<p style='margin:4px 0;color:#cbd5e1;'><strong>Shipping Address:</strong><br/>" + escapeHtml(address) + "</p>"
                            + "<p style='margin:4px 0;color:#cbd5e1;'><strong>Status:</strong> " + escapeHtml(status) + "</p>"
                            + "</div></div>"
                            + "<p style='color:#cbd5e1;'>We will send another update when your order ships. Thank you for shopping with Protein Gallery.</p>"
                            + "</div></body></html>";
                    sendEmail(email, subject, body);
                }
            }
        } catch (Exception e) {
            System.err.println("Error sending order confirmation email for order " + orderId);
            e.printStackTrace();
        }
    }

    public static void sendOrderStatusUpdate(int orderId, String newStatus) {
        String sql = "SELECT o.status, o.total_amount, o.shipping_address, u.email, u.name "
                + "FROM orders o JOIN users u ON o.user_id = u.id WHERE o.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String email = rs.getString("email");
                    String name = rs.getString("name");
                    String address = rs.getString("shipping_address");
                    BigDecimal totalAmount = rs.getBigDecimal("total_amount");

                    String subject = "Order Update - #" + orderId + " is now " + newStatus;
                    String body = "<html><body style='background:#0f172a;color:#f8fafc;font-family:Inter,Arial,sans-serif;'>"
                            + "<div style='max-width:700px;margin:0 auto;padding:32px;background:#111827;border-radius:20px;'>"
                            + "<h1 style='color:#ff6b35;'>Order Status Updated</h1>"
                            + "<p style='color:#cbd5e1;'>Hi " + escapeHtml(name) + ",</p>"
                            + "<p style='color:#cbd5e1;'>Your order <strong>" + orderId + "</strong> status has changed to <strong>" + escapeHtml(newStatus) + "</strong>.</p>"
                            + "<p style='color:#cbd5e1;'><strong>Total:</strong> ₹" + totalAmount + "</p>"
                            + "<p style='color:#cbd5e1;'><strong>Shipping Address:</strong><br/>" + escapeHtml(address) + "</p>"
                            + "<p style='margin-top:24px;color:#cbd5e1;'>We will keep you posted on delivery progress.</p>"
                            + "</div></body></html>";
                    sendEmail(email, subject, body);
                }
            }
        } catch (Exception e) {
            System.err.println("Error sending order status update for order " + orderId);
            e.printStackTrace();
        }
    }

    public static void sendOtpEmail(String toEmail, String userName, String otp) {
        String subject = "Your Password Reset OTP";
        String body = "<html><body style='background:#0f172a;color:#f8fafc;font-family:Inter,Arial,sans-serif;'>"
                + "<div style='max-width:650px;margin:0 auto;padding:32px;background:#111827;border-radius:20px;'>"
                + "<h1 style='color:#ff6b35; margin-bottom:0.5rem;'>Password Reset OTP</h1>"
                + "<p style='color:#cbd5e1;font-size:1rem;'>Hello " + escapeHtml(userName) + ",</p>"
                + "<p style='color:#cbd5e1;'>Use the code below to reset your password. It expires in 10 minutes.</p>"
                + "<div style='margin:24px 0;padding:24px;background:#0f172a;border:1px dashed #ff6b35;border-radius:16px;text-align:center;'>"
                + "<span style='font-size:38px;font-weight:800;letter-spacing:12px;color:#ff6b35;'>" + escapeHtml(otp) + "</span>"
                + "</div>"
                + "<p style='color:#cbd5e1;'>If you did not request a password reset, please ignore this email.</p>"
                + "<p style='margin-top:24px;color:#cbd5e1;'>Thanks,<br>The Protein Gallery Team</p>"
                + "</div></body></html>";
        sendEmail(toEmail, subject, body);
    }

    private static String buildOrderItemsHtml(int orderId) {
        StringBuilder builder = new StringBuilder();
        builder.append("<table style='width:100%;border-collapse:collapse;color:#cbd5e1;'>");
        builder.append("<thead><tr><th style='padding:10px 0;text-align:left;border-bottom:1px solid rgba(255,255,255,0.1);'>Product</th><th style='padding:10px 0;text-align:right;border-bottom:1px solid rgba(255,255,255,0.1);'>Qty</th><th style='padding:10px 0;text-align:right;border-bottom:1px solid rgba(255,255,255,0.1);'>Price</th></tr></thead>");
        builder.append("<tbody>");

        String sql = "SELECT p.name, oi.quantity, oi.price FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String name = rs.getString("name");
                    int qty = rs.getInt("quantity");
                    BigDecimal price = rs.getBigDecimal("price");
                    builder.append("<tr>");
                    builder.append("<td style='padding:12px 0;border-bottom:1px solid rgba(255,255,255,0.08);'>" + escapeHtml(name) + "</td>");
                    builder.append("<td style='padding:12px 0;border-bottom:1px solid rgba(255,255,255,0.08);text-align:right;'>" + qty + "</td>");
                    builder.append("<td style='padding:12px 0;border-bottom:1px solid rgba(255,255,255,0.08);text-align:right;'>₹" + price + "</td>");
                    builder.append("</tr>");
                }
            }
        } catch (Exception e) {
            System.err.println("Error building order item html for order " + orderId);
            e.printStackTrace();
        }

        builder.append("</tbody></table>");
        return builder.toString();
    }

    private static String escapeHtml(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}
