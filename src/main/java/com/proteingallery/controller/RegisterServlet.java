package com.proteingallery.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

import com.proteingallery.dao.UserDAO;
import com.proteingallery.model.User;
import com.proteingallery.util.JsonUtil;
import com.proteingallery.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String name = normalize(request.getParameter("name"));
        String email = normalize(request.getParameter("email"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = normalize(request.getParameter("phone"));

        Map<String, String> errors = new LinkedHashMap<>();
        if (name == null || name.isBlank()) {
            errors.put("name", "Name is required.");
        }
        if (email == null || email.isBlank()) {
            errors.put("email", "Email is required.");
        } else if (!isValidEmail(email)) {
            errors.put("email", "Please enter a valid email address.");
        }
        if (password == null || password.length() < 8) {
            errors.put("password", "Password must be at least 8 characters long.");
        }
        if (confirmPassword == null || !confirmPassword.equals(password)) {
            errors.put("confirmPassword", "Passwords do not match.");
        }
        if (phone != null && !phone.isBlank() && !isValidPhone(phone)) {
            errors.put("phone", "Please enter a valid phone number.");
        }

        if (!errors.isEmpty()) {
            writeJson(response, false, "Please correct the highlighted fields.", null, errors);
            return;
        }

        String normalizedEmail = email == null ? "" : email.trim().toLowerCase(Locale.ROOT);
        if (userDAO.emailExists(normalizedEmail)) {
            errors.put("email", "An account already exists with this email.");
            writeJson(response, false, "Email is already registered.", null, errors);
            return;
        }

        try {
            User user = new User();
            user.setName(name == null ? "" : name.trim());
            user.setEmail(normalizedEmail);
            user.setPhoneNumber(phone == null ? null : phone.trim());
            user.setPasswordHash(PasswordUtil.hash(password));
            user.setRole("USER");

            boolean created = userDAO.createUser(user);
            if (!created) {
                writeJson(response, false, "Unable to create your account right now. Please try again.", null, null);
                return;
            }

            writeJson(response, true, "Registration successful! Please log in to continue.", "login.html", null);
        } catch (RuntimeException ex) {
            writeJson(response, false, "Database error. Please try again later.", null, null);
        }
    }

    private void writeJson(HttpServletResponse response, boolean success, String message, String redirectTo, Map<String, String> errors) throws IOException {
        try (PrintWriter out = response.getWriter()) {
            StringBuilder builder = new StringBuilder();
            builder.append("{\"success\":").append(success).append(",\"message\":")
                    .append(JsonUtil.quote(message));
            if (redirectTo != null) {
                builder.append(",\"redirectTo\":").append(JsonUtil.quote(redirectTo));
            }
            if (errors != null && !errors.isEmpty()) {
                builder.append(",\"errors\":{");
                int index = 0;
                for (Map.Entry<String, String> entry : errors.entrySet()) {
                    if (index++ > 0) {
                        builder.append(',');
                    }
                    builder.append(JsonUtil.quote(entry.getKey())).append(':').append(JsonUtil.quote(entry.getValue()));
                }
                builder.append('}');
            }
            builder.append('}');
            out.print(builder);
        }
    }

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");
    }

    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^[0-9]{10}$");
    }

    private String normalize(String value) {
        return value == null ? null : value.trim();
    }
}
