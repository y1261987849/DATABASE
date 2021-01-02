1.
2)
create database student
on primary
(
	name = 'stu',
	filename = 'D:\201900800559\stu_data.mdf',
	size = 5MB,
	maxsize = 500MB,
	filegrowth = 10%
)
log on
(
	name = 'stu_log',
	filename = 'D:\201900800559\stu_log.ldf',
	size = 3MB,
	maxsize = unlimited,
	filegrowth = 1MB
)
go

3)
create database SPJ
on primary
(
	name = 'SPJ_data',
	filename = 'D:\201900800559\SPJ.mdf',
	size = 10MB,
	maxsize = unlimited,
	filegrowth = 10%
)
log on
(
	name = 'SPJ_log',
	filename = 'D:\201900800559\SPJ.ldf',
	size = 1MB,
	maxsize = 50MB,
	filegrowth = 1MB
)
go

2.

create table student
(
	Sno varchar(12) NOT NULL,
	Sname varchar(16),
	Ssex varchar(16),
	Sage integer,
	Sdept char(2)
);

create table course
(
	Cno int NOT NULL,
	Cname varchar(16),
	Cpno int,
	Ccredit int
);

create table sc
(
	Sno varchar(12) NOT NULL,
	Cno int NOT NULL,
	Grade int
);

3.


4.
create login teachers
with password = 'Ydp010403';
create user teacher for login teachers;
create schema teacher authorization [teacher];

5.
create table teacher.tea
(
    tno     varchar(12),
    tname   varchar(16),
    tsd     varchar(20),
    tphone  varchar(11),
    te_mail varchar(24)
);

6.
alter table student
add phone varchar(11);

alter table student
add e_mail varchar(24);

7.
alter table student
alter column Sdept varchar(20);

8.
alter table teacher.tea
drop column tphone;