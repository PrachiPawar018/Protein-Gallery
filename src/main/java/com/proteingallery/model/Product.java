package com.proteingallery.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Product {
    private int id;
    private String name;
    private String brand;
    private String category;
    private String goalTag;
    private BigDecimal price;
    private int discountPercent;
    private String description;
    private String nutritionInfo;
    private int stock;
    private String imageUrl;
    private BigDecimal ratingAvg;
    private boolean isActive;
    private Timestamp createdAt;

    public Product() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getGoalTag() { return goalTag; }
    public void setGoalTag(String goalTag) { this.goalTag = goalTag; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getNutritionInfo() { return nutritionInfo; }
    public void setNutritionInfo(String nutritionInfo) { this.nutritionInfo = nutritionInfo; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public BigDecimal getRatingAvg() { return ratingAvg; }
    public void setRatingAvg(BigDecimal ratingAvg) { this.ratingAvg = ratingAvg; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    // Helper to calculate final price after discount
    public BigDecimal getFinalPrice() {
        if (discountPercent > 0 && price != null) {
            BigDecimal discount = price.multiply(BigDecimal.valueOf(discountPercent)).divide(BigDecimal.valueOf(100));
            return price.subtract(discount).setScale(2, java.math.RoundingMode.HALF_UP);
        }
        return price;
    }
}
