--根据不同的商品种类，按照销售单价从低到高的顺序创建排序表
select product_name, product_type, sale_price,
	   rank() over (partition by product_type
	   					order by sale_price) as ranking
from Product;

select product_name, product_type, sale_price,
	   rank() over (order by sale_price) as ranking,
	   dense_rank() over (order by sale_price) as dense_ranking,
	   row_number() over (order by sale_price) as row_number
from Product;

select product_id, product_name, sale_price,
	   sum(sale_price) over (order by product_id) as current_sum
from Product;

select product_id, product_name, sale_price,
	   avg(sale_price) over (order by product_id) as current_avg
from Product;

select product_id, product_name, sale_price,
	   avg(sale_price) over (order by product_id
	   							rows 2 preceding) as moving_avg
from Prodct;

select product_id, product_name, sale_price,
	   avg(sale_price) over (order by product_id
	   							rows between 1 preceding and 1 following) as moving_avg
from Product;

select product_name, product_type, sale_price,
	   rank() over (order by sale_price) as ranking
from Product
order by ranking;

select '合计' as product_type, sum(sale_price)
from Product
union all
select product_type, sum(sale_price)
from Product
group by product_type;

select product_type, sum(sale_price) as sum_price
from Product
group by rollup(product_type);

select product_type, regist_date, sum(sale_price) as sum_price
from Product
group by product_type, regist_date;

select product_type, regist_date, sum(sale_price) as sum_price
from Product
group by rollup(product_type, regist_date);

select grouping(product_type) as product_type,
	   grouping(regist_date) as regist_date,
	   sum(sale_price) as sum_price
from Product
group by rollup(product_type, regist_date);


select case when grouping(product_type) = 1
			then '商品种类 合计'
			else product_type end as product_type,
	   case when grouping(regist_date) = 1
	   		then '登记日期 合计'
	   		else cast(regist_date as varchar(16)) end as regist_date,
	   sum(sale_price) as sum_price
from Product
group by rollup(product_type, regist_date);


select case when grouping(product_type) = 1
			then '商品种类 合计'
			else product_type end as product_type,
	   case when grouping(regist_date) = 1
	   		then '登记日期 合计'
	   		else cast(regist_date as varchar(16)) end as regist_date,
	   sum(sale_price) as sum_price
from Product
group by cube(product_type, regist_date);

select case when grouping(product_type) = 1
			then '商品种类 合计'
			else product_type end as product_type,
	   case when grouping(regist_date) = 1
	   		then '登记日期 合计'
	   		else cast(regist_date as varchar(16)) end as regist_date,
	   sum(sale_price) as sum_price
from Product
group by grouping set(product_type, regist_date);



























