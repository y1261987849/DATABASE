create table ProductIns
(product_id char(4) NOT NULL,
 product_name varchar(100) NOT NULL,
 product_type varchar(32) NOT NULL,
 sale_price integer DEFAULT 0,
 purchase_price integer,
 regist_date date,
 PRIMARY KEY (product_id));

insert into ProductIns (product_id, product_name, product_type, sale_price, purchase_price, regist_date)
values ('0001', 'T恤衫', '衣服', 1000, 500, '2009-09-20');

insert into ProductIns
values ('0002', '打孔器', '办公用品', 500, 320, '2009-09-11'),
	   ('0003', '运动T恤', '衣服', 4000, 2800, NULL),
	   ('0004', '菜刀', '厨房用具', 3000, 2800, '2009-09-20');

insert into ProductIns (product_id, product_name, product_type, sale_price, purchase_price, regist_date)
values ('0007', '擦菜板', '厨房用具', DEFAULT, 790, '2009-04-28');

insert into ProductIns (product_id, product_name, product_type, purchase_price, regist_date)
values ('0007', '擦菜板', '厨房用具', 790, '2009-04-28');

create table ProductCopy
(product_id char(4) NOT NULL,
 product_name varchar(100) NOT NULL,
 product_type varchar(32) NOT NULL,
 sale_price integer DEFAULT 0,
 purchase_price integer,
 regist_date date,
 PRIMARY KEY (product_id));

--可以省略列清单
insert into ProductCopy
select *
from Product;
--

create table product_type
(product_type varchar(32) NOT NULL,
 sum_sale_price integer,
 sum_purchase_price integer,
 PRIMARY KEY(product_type));

insert into ProductType(product_type, sum_sale_price, sum_purchase_price)
select product_type, sum(sale_price), sum(purchase_price)
from Product
group by product_type;

delete from Product;

delete from Product
where sale_price >= 4000;

--一次性地从表中删除所有的数据并且不把单独的删除造作记录记入日志保存
truncate Product;

update Product
set regist_date = '2009-10-10';

update Product
set sale_price = sale_price * 10
where product_type = '厨房用具';

update Product
set regist_date = NULL
where product_id = '0008';

update Product
set sale_price = sale_price * 10,
	purchase_price = purchase_price / 2
where product_type = '厨房用具';

begin transaction;

	update Product
	set sale_price = sale_price - 1000
	where product_name = '运动T恤';

	update Product
	set sale_price = sale_price + 1000
	where product_name = 'T恤衫';

commit;



















