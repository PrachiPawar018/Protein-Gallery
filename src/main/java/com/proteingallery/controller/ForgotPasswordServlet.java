package com.proteingallery.controller;

import java.io.IOException;
import java.security.SecureRandom;

import com.proteingallery.dao.UserDAO;
import com.proteingallery.model.User;
import com.proteingallery.util.EmailUtil;
import com.proteingallery.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ForgotPasswordServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show the forgot password page (step 1 by default)
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("sendOtp".equals(action)) {
            handleSendOtp(request, response);
        } else if ("verifyOtp".equals(action)) {
            handleVerifyOtp(request, response);
        } else if ("resetPassword".equals(action)) {
            handleResetPassword(request, response);
        } else {
            response.sendRedirect("forgot-password.jsp");
        }
    }

    /**
     * STEP 1 — User submits their email.
     *  - Verify the email exists.
     *  - Generate a random 6-digit OTP.
     *  - Save it to DB with a 10-minute expiry.
     *  - Send it via email.
     *  - Redirect to step 2.
     */
    private void handleSendOtp(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect("forgot-password.jsp?step=1&error=Please+enter+your+email+address.");
            return;
        }

        email = email.trim().toLowerCase();
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            // Don't reveal whether email exists for security — still show "sent" message
            response.sendRedirect("forgot-password.jsp?step=2&email=" + encode(email));
            return;
        }

        // Generate 6-digit OTP
        String otp = String.format("%06d", new SecureRandom().nextInt(999999));

        boolean saved = userDAO.saveOtp(email, otp);
        if (!saved) {
            response.sendRedirect("forgot-password.jsp?step=1&error=Something+went+wrong.+Try+again.");
            return;
        }

        // Send email asynchronously to avoid blocking the request
        final String finalEmail = email;
        final String finalOtp   = otp;
        final String userName   = user.getName();
        new Thread(() -> EmailUtil.sendOtpEmail(finalEmail, userName, finalOtp)).start();

        // Move to step 2
        response.sendRedirect("forgot-password.jsp?step=2&email=" + encode(email));
    }

    /**
     * STEP 2 — User submits the OTP they received.
     *  - Verify OTP against DB (checks email + OTP + expiry).
     *  - On success: store email in session, redirect to step 3.
     */
    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String email = request.getParameter("email");
        String otp   = request.getParameter("otp");

        if (email == null || otp == null || otp.trim().isEmpty()) {
            response.sendRedirect("forgot-password.jsp?step=2&email=" + encode(email) + "&error=Please+enter+the+OTP.");
            return;
        }

        email = email.trim().toLowerCase();
        otp   = otp.trim();

        User user = userDAO.getUserByValidOtp(email, otp);

        if (user == null) {
            response.sendRedirect("forgot-password.jsp?step=2&email=" + encode(email)
                    + "&error=Invalid+or+expired+OTP.+Please+try+again.");
            return;
        }

        // OTP verified — store verified email in session so step 3 is secure
        HttpSession session = request.getSession();
        session.setAttribute("otpVerifiedEmail", email);

        response.sendRedirect("forgot-password.jsp?step=3");
    }

    /**
     * STEP 3 — User sets a new password.
     *  - Read verified email from session.
     *  - Validate + BCrypt the new password.
     *  - Update DB, clear OTP, invalidate the special session flag.
     */
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        String verifiedEmail = (session != null) ? (String) session.getAttribute("otpVerifiedEmail") : null;

        if (verifiedEmail == null) {
            // Session expired or tampered — restart
            response.sendRedirect("forgot-password.jsp?step=1&error=Session+expired.+Please+start+again.");
            return;
        }

        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.length() < 8) {
            response.sendRedirect("forgot-password.jsp?step=3&error=Password+must+be+at+least+8+characters.");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("forgot-password.jsp?step=3&error=Passwords+do+not+match.");
            return;
        }

        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        boolean updated = userDAO.updatePasswordAndClearOtp(verifiedEmail, hashedPassword);

        if (updated) {
            // Clear the OTP session flag
            session.removeAttribute("otpVerifiedEmail");
            response.sendRedirect("login.jsp?message=Password+reset+successful!+Please+log+in+with+your+new+password.");
        } else {
            response.sendRedirect("forgot-password.jsp?step=3&error=Failed+to+update+password.+Try+again.");
        }
    }

    private String encode(String s) {
        try {
            return java.net.URLEncoder.encode(s != null ? s : "", "UTF-8");
        } catch (Exception e) {
            return "";
        }
    }
}
