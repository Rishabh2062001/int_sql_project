with customer as (	
	SELECT 
	customerkey,
	full_name,
	sum(net_revenue ) as total_ltv
	FROM public_cohort_analysis
	group by customerkey,
	full_name
),
segmentation as (
select PERCENTILE_CONT(0.25) within group (order by total_ltv) as ltv_25_percent,
 PERCENTILE_CONT(0.75) within group (order by total_ltv) as ltv_75_percent

from customer
),segment_values as (
	select 
	c.*,
	case
		when c.total_ltv < s.ltv_25_percent then '1-low_value'
		when c.total_ltv <= s.ltv_75_percent then '2-mid_value'
		else '3-high_value'
	end
	as customer_seg
	from customer c,
	segmentation s
)

select 
customer_seg,
sum(total_ltv) as total_ltv ,
count(customerkey) as customer_count
from segment_values
group by customer_seg 