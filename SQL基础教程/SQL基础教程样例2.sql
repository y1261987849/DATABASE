select product_id, product_name, purchase_price
from Product;

select *
from Product;

select product_id as id,
	   product_name as name,
	   purchase_price as price
from Product;

select '商品' as string, 38 as number, '2009-02-24' as date, product_id, product_name
from Product;

select distinct product_type
from Product;

select distinct product_type, regist_date
from Product;

select product_name, product_type
from Product
where product_type = '衣服'；

select product_name
from Product
where product_type = '衣服';

select product_name, sale_price,
	   sale_price * 2 as 'sale_price * 2'
from Product;

select product_name, product_type
from Product
where sale_price = 500;

select product_name, product_type
from Product
where sale_price <> 50;

select product_name, product_type, sale_price
from Product
where sale_price >= 1000;

select product_name, product_type, regist_date
from Product
where regist_date < '2009-09-27'

select product_name, sale_price, purchase_price
from Product
where sale_price - purchase_price >= 500;

create table Chars
(chr char(3) NOT NULL,
PRIMARY KEY (chr));

begin transaction;
insert into Chars values ('1');
insert into Chars values ('2');
insert into Chars values ('3');
commit;

select product_name, purchase_price
from Product
where purchase_price IS NULL;

select product_name, purchase_price
from Product
where purchase_price IS NOT NULL:

select product_name, product_type, sale_price
from Product
where NOT sale_price >= 1000;

select product_name, purchase_price
from Product
where product_type = '厨房用具' and sale_price >= 3000;

select product_name, purchase_price
from Product
where product_type = '厨房用具' or sale_price >= 3000






















