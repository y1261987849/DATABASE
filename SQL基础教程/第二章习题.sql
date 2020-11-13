select product_name, regist_date
from Product 
where regist_date > '2009-4-28';

一条数据也取不出来

select product_name, sale_price, purchase_price
from Product
where NOT sale_price - purchase_price < 500

select product_name,sale_price,purchase_price
from product
where sale_price>=purchase_price+500;

select product_name, product_type, sale_price * 0.9 - purchase_price as profit
from Product
where profit > 100 and (product_type = '办公用品' or product_type = '厨房用具');