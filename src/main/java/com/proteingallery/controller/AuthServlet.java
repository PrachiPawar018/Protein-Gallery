package com.proteingallery.controller;

import com.proteingallery.dao.UserDAO;
import com.proteingallery.model.User;
import com.proteingallery.util.JsonUtil;
import com.proteingallery.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        if ("/session".equals(path)) {
            sendSessionStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null || "/login".equals(path)) {
            login(request, response);
        } else if ("/register".equals(path)) {
            register(request, response);
        } else if ("/logout".equals(path)) {
            logout(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            User user = userDAO.findByEmail(email);
            if (user == null || !PasswordUtil.verify(password, user.getPasswordHash())) {
                out.print(JsonUtil.object("success:false", "message:" + JsonUtil.quote("Invalid email or password.")));
                return;
            }
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userRole", user.getRole());
            out.print(JsonUtil.object(
                    "success:true",
                    "message:" + JsonUtil.quote("Welcome back, " + user.getName() + "!"),
                    "role:" + JsonUtil.quote(user.getRole())
            ));
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            if (name == null || email == null || password == null || name.isBlank() || email.isBlank() || password.isBlank()) {
                out.print(JsonUtil.object("success:false", "message:" + JsonUtil.quote("All fields are required.")));
                return;
            }
            if (userDAO.emailExists(email)) {
                out.print(JsonUtil.object("success:false", "message:" + JsonUtil.quote("Email is already registered.")));
                return;
            }
            User user = new User();
            user.setName(name.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPasswordHash(PasswordUtil.hash(password));
            user.setRole("customer");
            boolean created = userDAO.createUser(user);
            if (!created) {
                out.print(JsonUtil.object("success:false", "message:" + JsonUtil.quote("Unable to complete registration.")));
                return;
            }
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userRole", user.getRole());
            out.print(JsonUtil.object(
                    "success:true",
                    "message:" + JsonUtil.quote("Account created successfully."),
                    "role:" + JsonUtil.quote(user.getRole())
            ));
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            out.print(JsonUtil.object("success:true", "message:" + JsonUtil.quote("Logged out successfully.")));
        }
    }

    private void sendSessionStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        HttpSession session = request.getSession(false);
        try (PrintWriter out = response.getWriter()) {
            if (session == null || session.getAttribute("userId") == null) {
                out.print(JsonUtil.object("authenticated:false"));
            } else {
                out.print(JsonUtil.object(
                        "authenticated:true",
                        "name:" + JsonUtil.quote((String) session.getAttribute("userName")),
                        "email:" + JsonUtil.quote((String) session.getAttribute("userEmail")),
                        "role:" + JsonUtil.quote((String) session.getAttribute("userRole"))
                ));
            }
        }
    }
}
