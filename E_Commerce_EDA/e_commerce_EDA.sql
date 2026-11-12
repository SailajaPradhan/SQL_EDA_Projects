
--VIEW DATA
SELECT * FROM [dbo].[user_events] 

--------------------------
--1. FUNNEL BY EVENT STAGE
--------------------------
WITH funnel_stages AS(

  SELECT 
	  COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
	  COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
	  COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
	  COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
	  COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
  FROM user_events
  WHERE event_date >= '2026-01-01' AND event_date < '2026-02-02'
)


SELECT 
    stage_1_views,
    stage_2_cart,
    stage_3_checkout,
    stage_4_payment,
    stage_5_purchase,
	stage_2_cart,
	ROUND((stage_2_cart * 100 / stage_1_views),2) AS view_to_cart_rate,
	ROUND((stage_3_checkout * 100 / stage_2_cart),2) AS cart_to_checkout_rate,
	ROUND((stage_4_payment * 100 / stage_3_checkout),2) AS checkout_to_payment_rate,
	ROUND((stage_5_purchase * 100 / stage_4_payment),2) AS payment_to_purchase_rate,
	ROUND((stage_5_purchase * 100 / stage_1_views),2) AS overall_conversion_rate
FROM funnel_stages


------------------------
--2. FUNNEL BY SOURCE
------------------------
WITH source_funnel AS(

SELECT
	 traffic_source,
	 COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
	 COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS carts,
	 COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases
  FROM user_events
  WHERE event_date >= '2026-01-01' AND event_date < '2026-02-02'
  GROUP BY traffic_source
)

SELECT
	traffic_source,
	views,
	carts,
	purchases,
	ROUND((carts * 100 / views),2) AS cart_conversion_rate,
	ROUND((purchases * 100 / views),2) AS purchases_conversion_rate,
	ROUND((purchases * 100 / carts),2) AS cart_to_purchases_conversion_rate
FROM source_funnel
ORDER BY purchases DESC



---------------------------- 
--3. TIME TO CONVERSION
----------------------------

WITH user_journey AS(

SELECT
	user_id,
	MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time,
	MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
	MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_time
  FROM user_events
  WHERE event_date >= '2026-01-01' AND event_date < '2026-02-02'
  GROUP BY user_id
  HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL
)

SELECT
	COUNT(*) AS converted_users,
	ROUND(AVG(DATEDIFF(MINUTE, view_time, cart_time)),2) AS avg_view_to_cart_minutes,
	ROUND(AVG(DATEDIFF(MINUTE, cart_time, purchase_time)),2) AS avg_cart_to_purchase_minutes,
	ROUND(AVG(DATEDIFF(MINUTE, view_time, purchase_time)),2) AS avg_total_journey_minutes
FROM user_journey


----------------------------
--4. REVENUE FUNNEL ANLYSIS
----------------------------
WITH funnel_revenue AS(

SELECT
	 COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,
	 COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,
	 SUM(CASE WHEN event_type = 'purchase' THEN TRY_CAST(amount AS DECIMAL(18,2)) ELSE 0.00 END) AS total_revenue,
	 COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders

  FROM user_events
  WHERE event_date >= '2026-01-01' AND event_date < '2026-02-02'
)

SELECT
	total_visitors,
	total_buyers,
	total_orders,
	total_revenue,
	ROUND(total_revenue / total_orders,2) AS avg_order_value,
	ROUND(total_revenue / total_visitors,2) AS revenue_per_visitor,
	ROUND(total_revenue / total_buyers,2) AS revenue_per_buyer
FROM funnel_revenue