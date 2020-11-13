create database shop;

create table Product
(product_id char(4) NOT NULL,
 product_name varchar(100) NOT NULL,
 product_type varchar(32) NOT NULL,
 sale_price int,
 purchase_price int,
 regist_date date,
 PRIMARY KEY (product_id));

drop table Product;

alter table Product add product_name_pinyin varchar(100);

alter table Product drop column product_name_pinyin;

begin transaction; #开始插入行的指令语句
insert into Product values('0001', 'T恤衫', '衣服', 1000, 500, '2009-09-20');
commit; #确定插入行的指令语句

sp_rename 'Poduct', 'Product'; 
