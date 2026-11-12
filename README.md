## Project-1 E_Commerce_Data_Analysis
This project analyzes e-commerce customer behavior using SQL Server to evaluate conversion rates, marketing channel performance, customer purchasing journeys, and revenue metrics.

### 📌 Business Objectives
Measure conversion across five funnel stages.
Identify customer drop-off points.
Compare marketing channel effectiveness.
Analyze time to purchase.
Evaluate revenue and average order value (AOV).


### Business Recommendations
- UX/Product:  Maintain checkout flow; improve page-to-cart conversion. 
- Marketing: Prioritize email and retargeting; optimize low-converting social campaigns. 
- Finance/Leadership: Monitor CAC and ROAS; increase AOV through upselling and product bundles. 

## Key Skills Demonstrated
- SQL querying and data aggregation
- Conversion funnel analysis
- Marketing performance analysis
- Customer journey analysis
- Revenue and KPI calculations
- Data-driven business recommendations

**Outcome:** Transformed e-commerce event data into actionable insights to improve customer conversion, marketing efficiency, and revenue performance.

----------------------------------------------------------------------------------------------------------------------------------
## Project-2 AtData_Data_Wrangling
This is a complete, data wrangling project based on an inventory dataset scraped from AtData. This project simulates real analyst workflows, from raw data exploration to business-focused data analysis.

### 📌 Project Overview

The goal is to simulate how actual data analysts in the e-commerce or retail industries work behind the scenes to use SQL to:
✅ Set up a messy, real-world e-commerce inventory **database**
✅ Perform **Exploratory Data Analysis (EDA)** to explore product categories, availability, and pricing inconsistencies
✅ Implement **Data Cleaning** to handle null values, remove invalid entries, and convert pricing from paise to rupees
✅ Write **business-driven SQL queries** to derive insights around **pricing, inventory, stock availability, revenue** and more

### 📁 Dataset Overview
The dataset was sourced from [Kaggle](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv) and was originally scraped from atdata’s official product listings. It mimics what you’d typically encounter in a real-world e-commerce inventory system.

Each row represents a unique SKU (Stock Keeping Unit) for a product. Duplicate product names exist because the same product may appear multiple times in different package sizes, weights, discounts, or categories to improve visibility – exactly how real catalog data looks.

🧾 Columns:
- **sku_id:** Unique identifier for each product entry (Synthetic Primary Key)
- **name:** Product name as it appears on the app
- **category:** Product category like Fruits, Snacks, Beverages, etc.
- **mrp:** Maximum Retail Price (originally in paise, converted to ₹)
- **discountPercent:** Discount applied on MRP
- **discountedSellingPrice:** Final price after discount (also converted to ₹)
- **availableQuantity:** Units available in inventory
- **weightInGms:** Product weight in grams
- **outOfStock:** Boolean flag indicating stock availability
- **quantity:** Number of units per package (mixed with grams for loose produce)


### 🔧 Project Workflow

Here’s a step-by-step breakdown of the project:

### 1. Database & Table Creation
We start by creating a SQL table with appropriate data types:

```sql
CREATE TABLE atdata (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);
```

### 2. 🔍 Data Exploration
- Counted the total number of records in the dataset
- Viewed a sample of the dataset to understand structure and content
- Checked for null values across all columns
- Identified distinct product categories available in the dataset
- Compared in-stock vs out-of-stock product counts
- Detected products present multiple times, representing different SKUs

### 3. 🧹 Data Cleaning
- Identified and removed rows where MRP or discounted selling price was zero
- Converted mrp and discountedSellingPrice from paise to rupees for consistency and readability
  
### 4. 📊 Business Insights
- Found top 10 best-value products based on discount percentage
- Identified high-MRP products that are currently out of stock
- Estimated potential revenue for each product category
- Filtered expensive products (MRP > ₹500) with minimal discount
- Ranked top 5 categories offering highest average discounts
- Calculated price per gram to identify value-for-money products
- Grouped products based on weight into Low, Medium, and Bulk categories
- Measured total inventory weight per product category
