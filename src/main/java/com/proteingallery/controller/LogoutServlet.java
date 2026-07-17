package com.proteingallery.controller;

import java.io.IOException;
import java.io.PrintWriter;

import com.proteingallery.util.JsonUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LogoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        try (PrintWriter out = response.getWriter()) {
            out.print("{\"success\":true,\"message\":" + JsonUtil.quote("You have been logged out.") + "}");
        }
    }
}
