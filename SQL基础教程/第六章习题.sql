--6.1
执行第二条语句时会返回空

--书上：使用IN和NOT IN是无法选取出NULL数据的

NOT IN参数中含有NULL则不会返回任何数据！

不包含NULL不仅仅是指定NULL为参数的情况，使用子查询作为IN和NOT IN的参数时，该子查询的返回值也不能包含NULL
--6.2
select count(case when sale_price < 1000
				  then 1 else 0 end) as low_price,
	   count(case when sale_price >= 1001 && sale_price <= 3000
	   			  then 1 else 0 end) as mid_price,
	   count(case when sale_price > 3001
	   			  then 1 else 0 end) as high_price
from Product;