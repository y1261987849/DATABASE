select count(*)
from Product;

select count(purchase_price)
from Product;

select sum(sale_price)
from Product;

select sum(sale_price), sum(purchase_price)
from Product;

select avg(sale_price), avg(purchase_price)
from Product;

select max(sale_price), min(purchase_price)
from Product;

select count(distinct product_type)
from Product;

select product_type, count(*)
from Product
group by product_type;

select purchase_price, count(*)
from Product
group by purchase_price;

select product_type, count(*)
from Product
group by product_type
having count(*) = 2;

select product_type, avg(sale_price)
from Product
group by product_type
having avg(sale_price) >= 2500;

select product_id, product_name, sale_price, purchase_price
from Product
order by sale_price asc;

select product_id, product_name, sale_price, purchase_price
from Product
order by sale_price desc;

select product_id, product_name, sale_price, purchase_price
from Product
order by sale_price, product_id;

select product_id as id, product_name, sale_price as sp, purchase_price
from Product
order by sp, id;

select product_name, sale_price, purchase_price
from Product
order by product_id;

select product_type, count(*)
from Product
group by product_type
order by count(*);

select product_id, product_name, sale_price, purchase_price
from Product
order by 3 desc, 1;
