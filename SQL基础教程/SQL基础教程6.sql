create table SampleMath
(m numeric (10, 3),
 n integer,
 p integer);

begin transaction;

insert into SampleMath(m, n, p)
values (500, 0, NULL),
	   (-180, 0, NULL),
	   (NULL, NULL, NULL),
	   (NULL, 7, 3),
	   (NULL, 5, 2),
	   (NULL, 4, NULL),
	   (8, NULL, 3),
	   (2.27, 1, NULL),
	   (5.555, 2, NULL),
	   (NULL, 1, NULL),
	   (8.76, NULL, NULL);

commit;

select m, abs(m) as abs_col
from SampleMath;

select n, p, mod(n, p) as mod_col
from SampleMath;

--SQL server
--select n, p, n % p as mod_col
--from SampleMath;

select m, n, rount(m, n) as rount_col
from SampleMath;

create table SampleStr
(str1 varchar(40),
 str2 varchar(40),
 str3 varchar(40));

begin transaction;

insert into SampleStr (str1, str2, str3)
values ('opx', 'rt', NULL),
	   ('abc', 'def', NULL),
	   ('山田', '太郎', '是我'),
	   ('aaa', NULL, NULL),
	   (NULL, 'xyz', NULL),
	   ('@!#$%', NULL, NULL),
	   ('ABC', NULL, NULL),
	   ('aBC', NULL, NULL),
	   ('abc太郎', 'abc', 'ABC'),
	   ('abcdefabc', 'abc', 'ABC'),
	   ('micmic', 'i', 'I');

commit;

select str1, str2, str1 || str2 as str_concat
from SampleStr;

select str1, str2, str3, str1 || str2 || str3 as str_concat
from SampleStr
where str1 = '山田';

--SQL server
--select str1, str2, str3, str1 + str2 + str3 as str_concat
--from SampleStr;

select str1, length(str1) as len_str
from SampleStr;

--SQL server
--select str1, len(str1) as len_str
--from SampleStr;

select str1, lower(str1) as low_str
from SampleStr
where str1 in ('ABC', 'aBC', 'abc', '山田');

select str1, upper(str1) as up_str
from SampleStr
where str1 in ('ABC', 'aBC', 'abc', '山田');

select str1, str2, str3, replace(str1, str2, str3) as rep_str
from SampleStr;

select str1, substring(str1 from 3 for 2) as sub_str
from SampleStr;

select str1, substring(str1, 3, 2) as sub_str
from SampleStr;

select current_date;

--SQL server
--使用cast()函数将current_timestamp转换为日期类型
--select cast(current_timestamp as date) as cur_date;

select current_time;

--SQL server
--使用cast()函数将current_timestamp转换为时间类型
--select cast(current_timestamp as time) as cur_time;

select current_timestamp;

select current_timestamp,
       extract(year from current_timestamp) as year,
       extract(month from current_timestamp) as month,
       extract(day from current_timestamp) as day,
       extract(hour from current_timestamp) as hour,
       extract(minute from current_timestamp) as minute,
       extract(second from current_timestamp) as second;

--SQL server
--select current_timestamp,
--		 datepart(year, current_timestamp) as year,
--		 datepart(month, current_timestamp) as month,
--		 datepart(day, current_timestamp) as day,
--		 datepart(hour, current_timestamp) as hour,
--		 datepart(minute, current_timestamp) as minute,
--		 datepart(second, current_timestamp) as second;

select cast('0001' as integer) as in_col;
select cast('2009-12-14' as date) as date_col;

select coalesce(NULL, 1) as col_1,
	   coalesce(NULL, 'test', NULL) as col_2,
	   coalesce(NULL, NULL, '2009-11-01') as col_3;

select coalesce(str2, 'NULL')
from SampleStr;















