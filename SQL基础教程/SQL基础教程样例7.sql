create table Product2
(product_id char(4) NOT NULL,
 product_name varchar(100) NOT NULL,
 product_type varchar(32) NOT NULL,
 sale_price integer,
 purchase_price integer,
 regist_date date,
 PRIMARY KEY(product_id));

begin transaction;

insert into Product2 values('0001', 'T恤衫', '衣服', 1000, 500, '2008-09-20'),
						   ('0002', '打孔器', '办公用品', 500, 320, '2009-09-11'),
						   ('0003', '运动T恤', '衣服', 4000, 2800, NULL),
						   ('0009', '手套', '衣服', 800, 500, NULL),
						   ('0010', '水壶', '厨房用具', 2000, 1700, '2009-09-20');

commit;

select product_id, product_name
from Product
union
select product_id, product_name
from Product2;

select product_id, product_name
from Product
where product_type = '厨房用具'
union
select product_id, product_name
from Product2
where product_type = '厨房用具'
order by product_id;

select product_id, product_name
from Product
union all
select product_id, product_name
from Product2;

select product_id, product_name
from Product
intersect
select product_id, product_name
from Product2
order by product_id;

select product_type, product_name
from Product
except -- minus
select product_id, product_name
from Product2
order by product_id;

select SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
from ShopProduct as SP inner join Product as P
on SP.product_id = P.product_id

select SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
from ShopProduct as SP inner join Product as P
on SP.product_type = P.product_id
where SP.shop_id = '000A';

select SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
from ShopProduct as SP outer join Product as P
on SP.product_id = P.product_id

CREATE TABLE InventoryProduct
(inventory_id CHAR(4) NOT NULL, 
 product_id CHAR(4) NOT NULL, 
 inventory_quantity INTEGER NOT NULL, 
 PRIMARY KEY (inventory_id, product_id));

INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES ('P001', '0001', 0); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES ('P001', '0002', 120); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) 
VALUES ('P001', '0003', 200); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES ('P001', '0004', 3); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) 
VALUES ('P001', '0005', 0); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES ('P001', '0006', 99); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES ('P001', '0007', 999); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES ('P001', '0008', 200); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) 
VALUES ('P002', '0001', 10); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES ('P002', '0002', 25); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES ('P002', '0003', 34); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES ('P002', '0004', 19);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES ('P002', '0005', 99); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES ('P002', '0006', 0); 
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity)
VALUES (' P002 ', ' 0007 ', 0 ); 
INSERT INTO InventoryProduct (inventory_id , product_id , inventory_quantity)
VALUES ('P002', '0008', 18);

COMMIT;

select SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price, IP.inventory_quantity
from ShopProduct as SP inner join Product as P
on SP.product_type = P.product_id
inner join InventoryProduct as IP on SP.product_id = IP.product_id
where IP.inventory_id = 'P001';

select SP.shop_id, SP.shop_name, SP.product_type, P.product_name
from ShopProduct as SP cross jion Product as P;

select distinct emp
from EmpSkills ES1
where not exists 
		(select skill
		 from Skills
		 except
		 select skill
		 from EmpSkills ES2
		 where ES1.emp = ES2.emp);


























































