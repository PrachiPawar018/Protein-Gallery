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

    public static void sendOrderConfirmation(String toEmail, int orderId, String totalAmount, String address) {
        String from = AppConfig.SMTP_USER;
        String password = AppConfig.SMTP_PASSWORD;

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); 
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, "Protein Gallery"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Order Confirmation - #" + orderId);

            String htmlContent = "<h2>Thank you for your order!</h2>" +
                    "<p>Your order <strong>#" + orderId + "</strong> has been successfully confirmed.</p>" +
                    "<p><strong>Total Amount:</strong> $" + totalAmount + "</p>" +
                    "<p><strong>Shipping Address:</strong><br/>" + address + "</p>" +
                    "<br/><p>We will notify you once it ships. Thanks for choosing Protein Gallery!</p>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email sent successfully to " + toEmail);
        } catch (Exception e) {
            System.err.println("Failed to send email to " + toEmail);
            e.printStackTrace();
        }
    }
}
