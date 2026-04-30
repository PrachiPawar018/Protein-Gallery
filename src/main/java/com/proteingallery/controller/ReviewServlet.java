package com.proteingallery.controller;

import com.proteingallery.dao.ReviewDAO;
import com.proteingallery.model.Review;
import com.proteingallery.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private ReviewDAO reviewDAO;

    @Override
    public void init() {
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect("login.jsp?error=You must be logged in to leave a review.");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            Review review = new Review();
            review.setUserId(user.getId());
            review.setProductId(productId);
            review.setRating(rating);
            review.setComment(comment);

            boolean success = reviewDAO.addReview(review);
            
            if (success) {
                response.sendRedirect("product?id=" + productId + "&msg=Review+added+successfully");
            } else {
                response.sendRedirect("product?id=" + productId + "&error=Failed+to+add+review");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("index.jsp?error=Invalid+product+ID");
        }
    }
}
