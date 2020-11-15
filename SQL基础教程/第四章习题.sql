没写commit，语句执行后，表不发生任何变化，相当于对空表进行操作

商品编号会违反主键约束，发生错误，无法进行插入

create table Product
(product_id char(4) NOT NULL,
 product_name varchar(100) NOT NULL,
 product_type varchar(32) NOT NULL,
 sale_price integer,
 purchase_price integer,
 regist_date date,
 PRIMARY KEY (product_id));

create table ProductMargin
(product_id char(4) NOT NULL,
 product_name varchar(100) NOT NULL,
 sale_price int,
 purchase_price int,
 margin int,
 PRIMARY KEY(product_id));

insert into ProductMargin(product_id, product_name, sale_price, purchase_price, margin)
select product_id, product_name, sale_price, purchase_price, sale_price - purchase_price)
from Product;


begin transaction;

	update ProductMargin
	set sale_price = 3000
	where product_name = '运动T恤';

	update ProductMargin
	set margin = sale_price - purchase_price
	where product_name = '运动T恤';

commit;