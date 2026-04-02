-- Combine fact, product, and location data for all analysis.
CREATE VIEW Master_Table AS
SELECT 
    f.Date,
    f.ProductId,
    p.Product,
    p.Product_Type,
    p.Type AS Product_Category,
    f.Sales,
    f.Profit,
    f.Margin,
    f.COGS,
    f.Total_Expenses,
    f.Marketing,
    f.Inventory,
    f.Budget_Profit,
    f.Budget_COGS,
    f.Budget_Margin,
    f.Budget_Sales,
    l.Area_Code,
    l.State,
    l.Market,
    l.Market_Size
FROM fact f
JOIN Product p ON f.ProductId = p.ProductId
JOIN Location_01 l ON f.Area_Code = l.Area_Code;

Select * from Master_Table

--Total Sales & Profit by State
SELECT State,SUM(Sales) AS Total_Sales,SUM(Profit) AS Total_Profit FROM Master_Table
GROUP BY State
ORDER BY Total_Profit DESC;
--Insight: Identify top and underperforming states.

--Top 5 Products by Profit
SELECT Top 5 Product, SUM(Profit) as Total_Profit from Master_Table
group by Product
order by Total_Profit DESC;
--Insight: Focus marketing & inventory on profitable products.

--Profit Margin by Product Type and Product Category
SELECT Product_Type,Product_Category,
    SUM(CAST(Profit AS DECIMAL(10,2))) AS Total_Profit,
    SUM(CAST(Sales AS DECIMAL(10,2))) AS Total_Sales,
    CASE 
        WHEN SUM(Sales) = 0 THEN 0
        ELSE (SUM(CAST(Profit AS DECIMAL(10,2))) / SUM(CAST(Sales AS DECIMAL(10,2)))) * 100
    END AS Profit_Margin
FROM Master_Table
GROUP BY Product_Type, Product_Category
ORDER BY Profit_Margin DESC;
--Insight: Some product type have high sales but low profit margins, indicating potential cost inefficiencies or pricing issues.”

--Loss-Making Areas
SELECT Market AS Area,State,SUM(Profit) AS Total_Profit FROM Master_Table
GROUP BY Market, State
HAVING SUM(Profit) < 0;
--Insight: No loss-making areas were found — all regions are profitable.

--Monthly Sales Trend
SELECT DATEPART(YEAR, Date) AS Year, DATEPART(MONTH, Date) AS Month, SUM(Sales) AS Monthly_Sales FROM Master_Table
GROUP BY DATEPART(YEAR, Date), DATEPART(MONTH, Date)
ORDER BY Year, Month;
--Insight: Identify seasonal trends.

--Sales & Profit by Product_Type and Product Category
SELECT Product_Type, Product_Category, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit FROM Master_Table
GROUP BY Product_Type, Product_Category
ORDER BY Total_Profit DESC;
--Insight: Shows combined effect of type and category on sales/profit

--Marketing Spend vs Profit by product and state
SELECT Product, State, SUM(Marketing) AS Total_Marketing, SUM(Profit) AS Total_Profit FROM Master_Table
GROUP BY Product,State
ORDER BY Total_Profit DESC;
--Shows which products in which states are generating profit compared to marketing spend

--High-Cost Products
SELECT Product,SUM(COGS) AS Total_Cost FROM Master_Table
GROUP BY Product
ORDER BY Total_Cost DESC;
--Insight: Manage high-cost products to improve profit.

--Inventory Analysis
SELECT Product, SUM(Inventory) AS Total_Inventory FROM Master_Table
GROUP BY Product
ORDER BY Total_Inventory DESC;
--Insight: Optimize slow-moving stock.

--Marketing Spend vs Profit
SELECT Product, SUM(Marketing) AS Total_Marketing, SUM(Profit) AS Total_Profit FROM Master_Table
GROUP BY Product
ORDER BY Total_Profit DESC;
--Insight: Evaluate marketing ROI.

--Scenario: Increase Sales by 5%
SELECT Product, SUM(Sales) AS Current_Sales, SUM(Sales)*1.05 AS Forecasted_Sales FROM Master_Table
GROUP BY Product
ORDER BY Forecasted_Sales DESC;
--Insight: Forecast potential revenue increase.

--Lowest Performing Markets by Profit
SELECT Market, State, SUM(Profit) AS Total_Profit FROM Master_Table
GROUP BY Market, State
ORDER BY Total_Profit ASC;
/*Insight: Although no region is making losses, some markets have significantly lower profit compared to others 
and may require attention.*/

--Weekly Sales Trend
SELECT DATEPART(YEAR, Date) AS Year, DATEPART(WEEK, Date) AS Week, SUM(Sales) AS Weekly_Sales FROM Master_Table
GROUP BY DATEPART(YEAR, Date), DATEPART(WEEK, Date)
ORDER BY Year, Week;
--Insight: Identify weekly trends and sales spikes.

--State + Product Performance
SELECT State, Product, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit FROM Master_Table
GROUP BY State, Product
ORDER BY State, Total_Profit DESC;
--Insight: Recommend region-specific product strategies.

SELECT * FROM Master_Table
SELECT * FROM Location_01
SELECT * FROM Product
SELECT * FROM fact