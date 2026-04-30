package com.proteingallery.controller;

import com.proteingallery.dao.ProductDAO;
import com.proteingallery.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/products", "/search", "/product"})
public class ProductServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/search".equals(path)) {
            String query = request.getParameter("q");
            List<Product> products = productDAO.searchProducts(query);
            request.setAttribute("products", products);
            request.setAttribute("searchQuery", query);
            request.getRequestDispatcher("products.jsp").forward(request, response);
            return;
        }

        if ("/product".equals(path)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Product product = productDAO.getProductById(id);
                if (product != null) {
                    com.proteingallery.dao.ReviewDAO reviewDAO = new com.proteingallery.dao.ReviewDAO();
                    java.util.List<com.proteingallery.model.Review> reviews = reviewDAO.getReviewsByProductId(id);
                    request.setAttribute("product", product);
                    request.setAttribute("reviews", reviews);
                    request.getRequestDispatcher("product-detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("products?error=Product+not+found");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("products?error=Invalid+Product+ID");
            }
            return;
        }

        // Default /products logic
        String goal = request.getParameter("goal");
        List<Product> products;

        if (goal != null && !goal.trim().isEmpty()) {
            products = productDAO.getProductsByGoal(goal);
            request.setAttribute("currentGoal", goal);
        } else {
            products = productDAO.getAllActiveProducts();
        }

        request.setAttribute("products", products);
        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
}
