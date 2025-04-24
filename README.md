# Marketing Campaign Performance Analysis

A collection of advanced MySQL queries analyzing marketing campaign data. This project demonstrates key SQL techniques—CTEs, window functions, views, stored procedures, and more—applied to real-world campaign metrics.

## Dataset Schema

| Column               | Type               | Description                                           |
|----------------------|--------------------|-------------------------------------------------------|
| Campaign_ID          | INT (PK)           | Unique identifier for each campaign                   |
| Company              | VARCHAR(255)       | Company running the campaign                          |
| Campaign_Type        | VARCHAR(30)        | Type (e.g. Email, Display, Influencer)                |
| Target_Audience      | VARCHAR(40)        | Segment targeted (e.g. “Men 18-24”, “All Ages”)       |
| Duration             | VARCHAR(25)        | Campaign duration (e.g. “30 days”)                    |
| Channel_Used         | VARCHAR(35)        | Marketing channel (e.g. “Google Ads”)                 |
| Conversion_Rate      | DECIMAL(10,2)      | % of visitors converting                              |
| Acquisition_Cost     | INT                | Cost per acquisition                                  |
| ROI                  | DECIMAL(10,2)      | Return on investment (ratio)                          |
| Location             | VARCHAR(30)        | Campaign geography                                    |
| Languages            | VARCHAR(34)        | Ad languages                                           |
| Clicks               | INT                | Number of clicks                                      |
| Impressions          | INT                | Number of impressions                                 |
| Engagement_Score     | INT                | Composite engagement metric                           |
| Customer_Segment     | VARCHAR(255)       | Customer segment                                      |
| Dates                | DATE               | Campaign start date                                   |

## Key Queries

### Level 1 – Basic Metrics & Filtering
1. **Total campaigns & average ROI**  
2. **High-conversion campaigns** (`Conversion_Rate > 5%` & `Clicks > 1000`)  
3. **Campaign count by type**

### Level 2 – Aggregation & Grouping
4. **Avg acquisition cost & conversion rate by channel**  
5. **Total clicks & impressions by company**  
6. **Top 3 locations by avg engagement score**

### Level 3 – Conditional Logic & Dates
7. **Duration categories** (Short/Medium/Long)  
8. **Monthly totals** for clicks & impressions

### Level 4 – Views & Stored Procedures
9. **View `high_roi_campaigns`** (`ROI > 1.5`)  
10. **Stored procedure `GetCompanyROI`** (returns total campaigns, avg ROI, total cost by company)

### Level 5 – Window Functions & CTEs
11. **Rank campaigns** by conversion rate within each channel  
12. **Cumulative clicks** over time (list when cumulative clicks exceed 10,000)

### Level 6 – Advanced Analytics
13. **Top 5 customer segments** by avg engagement  
14. **Highest net-profit campaign** per company (ROI – acquisition cost)  
15. **MoM % change** in avg conversion rate

## Usage

1. Clone this repo:  
   ```bash
   git clone https://github.com/Adarsh9930/marketing-analysis.git
   cd marketing-analysis
