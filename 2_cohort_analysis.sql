SELECT
cohort_year,
count(DISTINCT customerkey) AS customer_count,
sum(net_revenue) AS revenue,
sum(net_revenue) / count(DISTINCT customerkey) AS customer_revenue
FROM public_cohort_analysis pca 
WHERE orderdate=pca.first_order_date 
GROUP BY cohort_year 