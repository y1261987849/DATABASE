1.结果是order by product_id后的Product表

2.SELECT COALESCE(SP.shop_id, '不确定') AS shop_id,
COALESCE(SP.shop_name, '不确定') AS shop_name,
P.product_id,
P.product_name,
P.sale_price
FROM ShopProduct SP RIGHT OUTER JOIN Product P
ON SP.product_id = P.product_id
ORDER BY shop_id;

select 
case when SP.shop_id is null
					then '不确定' 
					else SP.shop_id 
					end as shop_id,
case when SP.shop_name is null
					then '不确定'
					else SP.shop_name
					end as shop_name,
SP.product_id, P.product_name, P.sale_price
from ShopProduct as SP outer join Product as P
on SP.product_id = P.product_id
order by shop_id;