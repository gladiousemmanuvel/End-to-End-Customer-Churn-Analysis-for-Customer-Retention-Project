# 📊 Customer Churn Analysis & Customer Retention Dashboard

An end-to-end data analytics project designed to evaluate customer retention, identify churn drivers, and isolate high-value accounts at risk for an e-commerce platform using **MySQL**, **Power BI**, and **DAX Modeling**.

---

## 📸 Dashboard Overview

![Customer Churn Dashboard](Customer%20Churn%20Analysis%20for%20Customer%20Retention%20Dashboard.png)

---

## 💡 Executive Summary & Business Problem

Customer churn directly impacts revenue growth in e-commerce business models. This dashboard analyzes customer transaction history to identify drop-off patterns, measure overall churn rates, and provide actionable insights for target win-back marketing campaigns.

### Key Metrics Summary:
* **Total User Base:** 25,000 unique customers
* **Active Customers:** 20,488 users
* **Churned Customers:** 4,423 users (>180 days inactivity bound)
* **Overall Churn Rate:** 17.76%

---

## 🛠️ Tech Stack & Analytical Pipeline

* **Database / Backend:** MySQL (`ecommerce_master_final` dataset with 138K+ orders)
* **Data Modeling & Visualization:** Power BI Desktop
* **Calculations & Business Logic:** Advanced DAX (Calculated Columns & Dynamic Measures)

---

## 📐 Business Logic & DAX Implementation

To avoid temporal data drift across historical records prior to 2026, dynamic DAX modeling was anchored to static dataset bounds (`2024-12-31` offset by 180 days):

### 1. Customer Status Calculated Column
```dax
customer_status = 
IF(
    CALCULATE(
        MAX('ecommerce_analytics_db ecommerce_master_final'[order_date]), 
        ALLEXCEPT('ecommerce_analytics_db ecommerce_master_final', 'ecommerce_analytics_db ecommerce_master_final'[customer_id])
    ) < (DATE(2024, 12, 31) - 180),
    "Churned Customer",
    "Active Customer"
)
```

### 2. Core KPI Measures
```dax
Total Customers = DISTINCTCOUNT('ecommerce_analytics_db ecommerce_master_final'[customer_id])

Churned Customers = 
CALCULATE(
    [Total Customers],
    'ecommerce_analytics_db ecommerce_master_final'[customer_status] = "Churned Customer"
)

Active Customers = [Total Customers] - [Churned Customers]

Churn Rate % = DIVIDE([Churned Customers], [Total Customers], 0) * 100
```

## 📈 Key Insights & Strategic Recommendations
1.Segment Vulnerability: The Consumer segment exhibits the highest total volume of churned users compared to Corporate and VIP tiers.

2.High-Value Account Risk: Isolated top accounts with historical spend exceeding high-value thresholds who have lapsed >180 days to prioritize localized retention outreach.

3.Channel Performance: Payment method trends indicate specific drop-offs in cash-on-delivery transactions versus digital wallet purchases.

## 📂 Repository Structure

├── Customer_Churn_Analysis.pbix  # Main Power BI Workbook File
├── dashboard_screenshot.png      # High-resolution Dashboard Output
├── README.md                     # Project Documentation & Insights
