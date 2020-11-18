create view ViewPractice5_1(product_name, sale_price, regist_date)
as 
select product_name, sale_price, regist_date
from Product
where sale_price >= 1000 and regist_date = '2009-9-20';

会发生错误
实际的操作相当于如下：
insert into Product
values (NULL, '刀子', NULL， 300， NULL, '2009-11-02');
违反了NOT NULL约束

select product_id, product_name, product_type, sale_price,
	   (select avg(sale_price)
		from Product) as sale_price_all
from Product;

create view AvgPRiceByType
as 
select product_id, product_name, product_type, sale_price, 
	   (select avg(sale_price))
	   from Product as P2
	   where P1.product_type = P2.product_type
	   group by P1.product_type) as avg_sale_price
from Product as P1;