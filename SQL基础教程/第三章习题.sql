①where语句应在from语句之后，group by语句之前使用。
②把聚合键之外的列名写在了select语句中
③使用了字符类型的列（product_name)作为sum函数的参数

select product_type, sum(sale_price), sum(purchase_price)
from Product 
group by product_type
having sum(sale_price) > sum(purchase_price) * 1.5;

order by regist_date desc， sale_price;