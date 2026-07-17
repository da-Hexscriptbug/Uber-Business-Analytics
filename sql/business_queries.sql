/* ===========================================================
   UBER DECISION ANALYTICS
   Business SQL Queries
   =========================================================== */

/* 1. Total Bookings */
SELECT COUNT(*) AS Total_Bookings
FROM Uber;


/* 2. Total Revenue */
SELECT SUM(Booking_Value) AS Total_Revenue
FROM Uber;


/* 3. Average Booking Value */
SELECT ROUND(AVG(Booking_Value),2) AS Avg_Booking_Value
FROM Uber;


/* 4. Revenue by Vehicle Type */
SELECT Vehicle_Type,
       SUM(Booking_Value) AS Revenue
FROM Uber
GROUP BY Vehicle_Type
ORDER BY Revenue DESC;


/* 5. Total Bookings by Vehicle Type */
SELECT Vehicle_Type,
       COUNT(*) AS Total_Bookings
FROM Uber
GROUP BY Vehicle_Type
ORDER BY Total_Bookings DESC;


/* 6. Booking Status Distribution */
SELECT Booking_Status,
       COUNT(*) AS Total
FROM Uber
GROUP BY Booking_Status
ORDER BY Total DESC;


/* 7. Customer Cancellation Count */
SELECT COUNT(*) AS Customer_Cancellations
FROM Uber
WHERE Booking_Status='Cancelled by Customer';


/* 8. Driver Cancellation Count */
SELECT COUNT(*) AS Driver_Cancellations
FROM Uber
WHERE Booking_Status='Cancelled by Driver';


/* 9. Top 10 Pickup Locations */
SELECT Pickup_Location,
       COUNT(*) AS Total_Rides
FROM Uber
GROUP BY Pickup_Location
ORDER BY Total_Rides DESC
LIMIT 10;


/* 10. Top 10 Drop Locations */
SELECT Drop_Location,
       COUNT(*) AS Total_Rides
FROM Uber
GROUP BY Drop_Location
ORDER BY Total_Rides DESC
LIMIT 10;


/* 11. Most Popular Route */
SELECT Pickup_Location,
       Drop_Location,
       COUNT(*) AS Trips
FROM Uber
GROUP BY Pickup_Location,Drop_Location
ORDER BY Trips DESC
LIMIT 10;


/* 12. Monthly Revenue */
SELECT MONTH(Date) AS Month_No,
       SUM(Booking_Value) AS Revenue
FROM Uber
GROUP BY MONTH(Date)
ORDER BY Month_No;


/* 13. Monthly Booking Trend */
SELECT MONTH(Date) AS Month_No,
       COUNT(*) AS Bookings
FROM Uber
GROUP BY MONTH(Date)
ORDER BY Month_No;


/* 14. Revenue by Payment Method */
SELECT Payment_Method,
       SUM(Booking_Value) AS Revenue
FROM Uber
GROUP BY Payment_Method
ORDER BY Revenue DESC;


/* 15. Top 10 Customers by Revenue */
SELECT Customer_ID,
       SUM(Booking_Value) AS Revenue
FROM Uber
GROUP BY Customer_ID
ORDER BY Revenue DESC
LIMIT 10;


/* 16. Average Customer Rating by Vehicle */
SELECT Vehicle_Type,
       ROUND(AVG(Customer_Rating),2) AS Avg_Rating
FROM Uber
GROUP BY Vehicle_Type
ORDER BY Avg_Rating DESC;


/* 17. Average Driver Rating by Vehicle */
SELECT Vehicle_Type,
       ROUND(AVG(Driver_Ratings),2) AS Avg_Rating
FROM Uber
GROUP BY Vehicle_Type
ORDER BY Avg_Rating DESC;


/* 18. Vehicle Revenue Contribution */
SELECT Vehicle_Type,
       SUM(Booking_Value) AS Revenue,
       ROUND(
       SUM(Booking_Value)*100/
       (SELECT SUM(Booking_Value) FROM Uber),2)
       AS Revenue_Percentage
FROM Uber
GROUP BY Vehicle_Type
ORDER BY Revenue DESC;


/* 19. Weekend vs Weekday Bookings */
SELECT
CASE
WHEN DAYNAME(Date) IN ('Saturday','Sunday')
THEN 'Weekend'
ELSE 'Weekday'
END AS Day_Type,
COUNT(*) AS Total_Bookings
FROM Uber
GROUP BY Day_Type;


/* 20. Peak Booking Hours */
SELECT HOUR(Time) AS Hour_of_Day,
       COUNT(*) AS Total_Bookings
FROM Uber
GROUP BY Hour_of_Day
ORDER BY Total_Bookings DESC;


/* 21. Top Cancellation Reasons */
SELECT Reason_for_cancelling_by_Customer,
       COUNT(*) AS Total
FROM Uber
GROUP BY Reason_for_cancelling_by_Customer
ORDER BY Total DESC;


/* 22. Revenue Lost due to Customer Cancellations */
SELECT SUM(Booking_Value) AS Lost_Revenue
FROM Uber
WHERE Booking_Status='Cancelled by Customer';


/* 23. Top Revenue Vehicle using Window Function */
SELECT *
FROM
(
SELECT
Vehicle_Type,
SUM(Booking_Value) AS Revenue,
RANK() OVER(ORDER BY SUM(Booking_Value) DESC) AS Revenue_Rank
FROM Uber
GROUP BY Vehicle_Type
)t;


/* 24. Customer Revenue Segmentation */
SELECT
Customer_ID,
SUM(Booking_Value) AS Total_Revenue,
CASE
WHEN SUM(Booking_Value)>5000 THEN 'High Value'
WHEN SUM(Booking_Value)>2000 THEN 'Medium Value'
ELSE 'Low Value'
END AS Customer_Category
FROM Uber
GROUP BY Customer_ID;


/* 25. Running Monthly Revenue */
WITH MonthlyRevenue AS
(
SELECT
MONTH(Date) AS Month_No,
SUM(Booking_Value) AS Revenue
FROM Uber
GROUP BY MONTH(Date)
)

SELECT
Month_No,
Revenue,
SUM(Revenue) OVER(ORDER BY Month_No)
AS Running_Revenue
FROM MonthlyRevenue;


/* ===========================================================
End of Queries
=========================================================== */