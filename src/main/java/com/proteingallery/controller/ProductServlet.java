package com.proteingallery.controller;

import com.proteingallery.dao.ProductDAO;
import com.proteingallery.model.Product;
import com.proteingallery.util.JsonUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            if (path != null && path.equals("/detail")) {
                handleDetail(request, out);
            } else {
                handleList(request, out);
            }
        }
    }

    private void handleList(HttpServletRequest request, PrintWriter out) {
        String search = request.getParameter("search");
        String category = request.getParameter("category");
        String goal = request.getParameter("goal");
        BigDecimal minPrice = parseDecimal(request.getParameter("minPrice"));
        BigDecimal maxPrice = parseDecimal(request.getParameter("maxPrice"));
        String featured = request.getParameter("featured");
        List<Product> products;
        if (featured != null && featured.equalsIgnoreCase("true")) {
            products = productDAO.findFeatured();
        } else {
            products = productDAO.findAll(search, category, goal, minPrice, maxPrice);
        }
        out.print(JsonUtil.array(products.stream().map(this::productJson).toArray(String[]::new)));
    }

    private void handleDetail(HttpServletRequest request, PrintWriter out) {
        String idValue = request.getParameter("id");
        if (idValue == null) {
            out.print(JsonUtil.object("success:false", "message:" + JsonUtil.quote("Product id is required.")));
            return;
        }
        try {
            int id = Integer.parseInt(idValue);
            Product product = productDAO.findById(id);
            if (product == null) {
                out.print(JsonUtil.object("success:false", "message:" + JsonUtil.quote("Product not found.")));
                return;
            }
            out.print(productJson(product));
        } catch (NumberFormatException e) {
            out.print(JsonUtil.object("success:false", "message:" + JsonUtil.quote("Invalid product id.")));
        }
    }

    private String productJson(Product product) {
        return JsonUtil.object(
                "id:" + product.getId(),
                "name:" + JsonUtil.quote(product.getName()),
                "description:" + JsonUtil.quote(product.getDescription()),
                "category:" + JsonUtil.quote(product.getCategory()),
                "goalTag:" + JsonUtil.quote(product.getGoalTag()),
                "price:" + product.getPrice(),
                "imageUrl:" + JsonUtil.quote(product.getImageUrl()),
                "stock:" + product.getStock(),
                "featured:" + product.isFeatured()
        );
    }

    private BigDecimal parseDecimal(String value) {
        try {
            return value == null || value.isBlank() ? null : new BigDecimal(value);
        } catch (NumberFormatException ignored) {
            return null;
        }
    }
}
