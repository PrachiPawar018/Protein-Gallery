package com.proteingallery.controller.admin;

import com.proteingallery.dao.ProductDAO;
import com.proteingallery.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/products", "/admin/products/add", "/admin/products/update", "/admin/products/delete"})
public class AdminProductServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/admin/products".equals(path)) {
            List<Product> products = productDAO.getProductsByGoal(null);
            request.setAttribute("products", products);
            request.getRequestDispatcher("/admin-products.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            if ("/admin/products/add".equals(path)) {
                // stub
            } else if ("/admin/products/update".equals(path)) {
                // stub
            } else if ("/admin/products/delete".equals(path)) {
                // stub
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}
