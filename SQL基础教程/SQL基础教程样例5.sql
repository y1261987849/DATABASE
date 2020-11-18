create view ProductSum(product_type, cnt_product)
as --as一定不要省略
select product_type, count(*)
from Product
group by product_type;

select product_type, cnt_product
from ProductSum;

create view ProductSumJim (product_type, cnt_product)
as
select product_type, cnt_product
from ProductSum --以视图为基础创建视图
where product_type = '办公用品'

select product_type, cnt_product
from ProductSumJim;

create view ProductJim (product_id, product_name, product_type, sale_price, purchase_price, regist_date)
as
select *
from Product
where product_type = '办公用品';

insert into ProductJim
values ('0009', '印章', '办公用品', 95, 10, '2009-11-30');

select product_type, cnt_product
from (select product_type, count(*) as cnt_product
	  from Product
	  group by prodcut_type) as ProductSum;

select product_type, cnt_product
from (select *
	  from (select product_type, count(*) as cnt_product
	  		from Product
	  		group by product_type) as ProductSum
	  where cnt_product = 4) as ProductSum2;

select product_id, product_name, sale_price
from ProductSum
where sale_price > (select avg(sale_price)
					from Product);

select product_id, product_name, sale_price, 
	   (select avg(sale_price)
	   	from Product) as avg_price
from Product;

select product_type, avg(sale_price)
from Product
group by product_type
having avg(sale_price) > (select avg(sale_price)
						  from Product);

select product_type, product_name, sale_price
from Product as P1
where sale_price > (select avg(sale_price)
					from Product as P2
					where P1.product_type = P2.product_type
					--group by product_type
					)




















