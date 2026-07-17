package com.proteingallery.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;

import com.proteingallery.dao.UserDAO;
import com.proteingallery.model.User;
import com.proteingallery.util.JsonUtil;
import com.proteingallery.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email") == null ? "" : request.getParameter("email").trim().toLowerCase(Locale.ROOT);
        String password = request.getParameter("password");

        if (email.isBlank() || password == null || password.isBlank()) {
            writeJson(response, false, "Email and password are required.", null);
            return;
        }

        try {
            User user = userDAO.findByEmail(email);
            if (user == null) {
                writeJson(response, false, "No account found with that email.", null);
                return;
            }

            if (!PasswordUtil.verify(password, user.getPasswordHash())) {
                writeJson(response, false, "Wrong password. Please try again.", null);
                return;
            }

            if (!Boolean.TRUE.equals(user.isActive())) {
                writeJson(response, false, "This account is inactive. Please contact support.", null);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userRole", user.getRole());

            String redirectPage = "ADMIN".equalsIgnoreCase(user.getRole()) ? "admin.html" : "index.html";
            writeJson(response, true, "Login successful. Welcome back!", redirectPage);
        } catch (RuntimeException ex) {
            writeJson(response, false, "Database error. Please try again later.", null);
        }
    }

    private void writeJson(HttpServletResponse response, boolean success, String message, String redirectTo) throws IOException {
        try (PrintWriter out = response.getWriter()) {
            out.print("{\"success\":" + success + ",\"message\":" + JsonUtil.quote(message)
                    + (redirectTo == null ? "}" : ",\"redirectTo\":" + JsonUtil.quote(redirectTo) + "}"));
        }
    }
}
