package com.proteingallery.model;

import java.math.BigDecimal;

public class CartItem {
    private int id;
    private int userId;
    private int productId;
    private int quantity;
    
    // Additional fields for display
    private String productName;
    private String productImage;
    private BigDecimal productPrice;
    private int productDiscount;

    public CartItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    public BigDecimal getProductPrice() { return productPrice; }
    public void setProductPrice(BigDecimal productPrice) { this.productPrice = productPrice; }

    public int getProductDiscount() { return productDiscount; }
    public void setProductDiscount(int productDiscount) { this.productDiscount = productDiscount; }

    public BigDecimal getFinalPrice() {
        if (productDiscount > 0 && productPrice != null) {
            BigDecimal discount = productPrice.multiply(BigDecimal.valueOf(productDiscount)).divide(BigDecimal.valueOf(100));
            return productPrice.subtract(discount).setScale(2, java.math.RoundingMode.HALF_UP);
        }
        return productPrice;
    }

    public BigDecimal getTotalPrice() {
        if (getFinalPrice() == null) return BigDecimal.ZERO;
        return getFinalPrice().multiply(BigDecimal.valueOf(quantity)).setScale(2, java.math.RoundingMode.HALF_UP);
    }
}
