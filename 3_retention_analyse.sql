with customer_lastest_puchase as (
	SELECT
	customerkey,
	full_name,
	orderdate,
	cohort_year,
	first_order_date,
	row_number() over (partition by customerkey order by orderdate desc) as rn,
	case 
		when orderdate < (select max(orderdate) from sales) - interval '6 months' then 'inactive'
		else 'active'
	end as customer_status
	
	FROM 
	public.public_cohort_analysis
), status as (
select 
customerkey,
full_name,
cohort_year,
orderdate as lastest_order,
customer_status
from customer_lastest_puchase
where rn=1
and first_order_date < (select max(orderdate) from sales) - interval '6 months'
)

select cohort_year,
customer_status,
count(customerkey) as num_customer,
sum(count(customerkey)) over(partition by cohort_year) as total_customers,
round(count(customerkey) / sum(count(customerkey)) over(partition by cohort_year),4) *100 as percent
from status
group by cohort_year, customer_status
