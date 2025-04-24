SELECT 
    *
FROM
    marketing.market;

-- LEVEL 1
-- Total campaigns and average ROI.

SELECT 
    COUNT(*) AS Counts, AVG(roi) AS AvgROI
FROM
    market;

-- List campaigns with Conversion_Rate > 5 and Clicks > 1000.

SELECT 
    Campaign_ID, Company
FROM
    market
WHERE
    Conversion_Rate > 0.06 AND Clicks > 500;


-- Count campaigns per Campaign_Type.

SELECT 
    COUNT(*) Counts, Campaign_Type
FROM
    market
GROUP BY Campaign_Type;

-- LEVEL 2
-- Average Acquisition_Cost and average Conversion_Rate grouped by Channel_Used.

SELECT 
    Channel_Used,
    AVG(Acquisition_Cost) AS AVGAcquisition_Cost,
    AVG(Conversion_Rate) AS AvgConversionRate
FROM
    market
GROUP BY Channel_Used;

-- Total Clicks and total Impressions grouped by Company.

SELECT 
    Company,
    SUM(Clicks) AS TotalClicks,
    SUM(Impressions) AS TotalImpressions
FROM
    market
GROUP BY Company;

-- Top 3 Locations by average Engagement_Score.

SELECT 
    Location, AVG(Engagement_Score) AS AvgEngagement_Score
FROM
    market
GROUP BY Location
ORDER BY AvgEngagement_Score DESC
LIMIT 3;

-- LEVEL 3
-- Categorize Duration into “Short” (<7 days), “Medium” (7–30 days), and “Long” (>30 days).

SELECT 
    Company,
    Duration,
    CASE
        WHEN Duration < '7 days' THEN 'Short'
        WHEN Duration BETWEEN '7 days' AND '30 days' THEN 'Medium'
        ELSE 'Long'
    END AS DurationCategory
FROM
    marketmonth and year from Dates and show monthly totals for Clicks and Impressions.

SELECT 
    SUM(Impressions) AS TotalImpressions,
    SUM(Clicks) AS TotalClicks,
    MONTH(Dates) AS Months,
    YEAR(Dates) AS Years
FROM
    market
GROUP BY MONTH(Dates) , YEAR(Dates);

-- Create a VIEW named high_roi_campaigns for ROI > 1.5.

CREATE VIEW high_roi_campaigns AS
    SELECT 
        Company, ROI
    FROM
        market
    WHERE
        roi > 1.5;
        
-- Write a STORED PROCEDURE GetCompanyROI that accepts a company name and returns:
-- Total campaigns
-- Average ROI
-- Total Acquisition_Cost

CREATE PROCEDURE GetCompanyROI(IN cmpName VARCHAR(255))
BEGIN
  SELECT 
    COUNT(*) AS TotalCampaign, 
    AVG(ROI) AS AverageROI, 
    SUM(Acquisition_Cost) AS TotalAcquisitionCost
  FROM market
  WHERE Company = cmpName;
END

-- LEVEL 5
-- Rank campaigns within each Channel_Used by Conversion_Rate using a window function.

SELECT count(*) as Campaigns, Channel_Used, Conversion_Rate,
rank() over( partition by Channel_Used order by Conversion_Rate desc ) as Ranks
 FROM market group by Channel_Used, Conversion_Rate ;
 
 -- Use a CTE to compute cumulative Clicks over Dates and list campaigns where cumulative Clicks exceed 10,000.

WITH ClicksCTE AS (
  SELECT 
    Campaign_ID,
    Dates,
    Clicks,
    SUM(Clicks) OVER (
      ORDER BY Dates
      ROWS UNBOUNDED PRECEDING
    ) AS CumulativeClicks
  FROM market
)
SELECT 
  Campaign_ID,
  Dates,
  Clicks,
  CumulativeClicks
FROM ClicksCTE
WHERE CumulativeClicks > 10000
ORDER BY Dates;

-- LEVEL 6
-- Identify the top 5 Customer_Segment by average Engagement_Score.

SELECT 
    Customer_Segment,
    AVG(Engagement_Score) AS AverageEngagement_Score
FROM
    market
GROUP BY Customer_Segment
ORDER BY AverageEngagement_Score desc limit 5;

-- For each Company, find the campaign with the highest (ROI minus Acquisition_Cost).

WITH ProfitCTE AS (
  SELECT
    Company,
    Campaign_ID,
    (ROI - Acquisition_Cost) AS NetProfit
  FROM market
)
SELECT
  Company,
  Campaign_ID,
  NetProfit
FROM (
  SELECT
    Company,
    Campaign_ID,
    NetProfit,
    ROW_NUMBER() OVER (
      PARTITION BY Company
      ORDER BY NetProfit DESC
    ) AS rn
  FROM ProfitCTE
) AS ranked
WHERE rn = 1;


-- Show month‑over‑month percentage change in average Conversion_Rate.

WITH MonthlyAvg AS (
  SELECT
    DATE_FORMAT(Dates, '%Y-%m') AS Month,
    AVG(Conversion_Rate) AS AvgConversion
  FROM market
  GROUP BY DATE_FORMAT(Dates, '%Y-%m')
),
MoM AS (
  SELECT
    Month,
    AvgConversion,
    LAG(AvgConversion) OVER (ORDER BY Month) AS PrevMonthAvg
  FROM MonthlyAvg
)
SELECT
  Month,
  AvgConversion,
  PrevMonthAvg,
  ROUND(
    (AvgConversion - PrevMonthAvg) / PrevMonthAvg * 100,
    2
  ) AS PercentChange
FROM MoM
WHERE PrevMonthAvg IS NOT NULL
ORDER BY Month;