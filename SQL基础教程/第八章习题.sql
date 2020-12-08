1.
按照商品编号（product_id）的升序进行排序，
计算出截至当前行的最高销售单价”。
因此，在显示出最高销售单价的同时，
窗口函数的返回结果也会变化。
随着商品编号越来越大，计算最大值的对象范围也不断扩大。
2.
select regist_date, product_name, sale_price,
sum(sale_price) over(order by regist_date nulls first) as current_sum_price
from product;

select regist_date,product_id,product_name,sale_price,
sum(sale_price) over (ORDER BY regist_date) as sum_price
from product;

# 其它方法：
# regist_date 为NULL 时，显示“1 年1 月1 日”
SELECT regist_date, product_name, sale_price,
SUM (sale_price) OVER (ORDER BY COALESCE(regist_date, CAST('0001-01- 01' AS DATE))) AS current_sum_price
FROM Product;

