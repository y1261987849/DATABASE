create table Addressbook
(regist_no int NOT NULL,
 name varchar(128) NOT NULL,
 address varchar(256) NOT NULL,
 tel_no char(10),
 mail_address char(20),
 PRIMARY KEY (regist_no)
);

alter table Addressbook add postal_code char(8) NOT NULL;

drop table Addressbook;

删除后的表无法使用命令进行恢复