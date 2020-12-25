alter table xs
add 身份证号码 char(18);

1.
select 课程号, 课程名, 先行课号
from kc
where 先行课号 is not null;

2.
select 课程号, 课程名
from kc
where 先行课号 = 'J001';

3.
select 学号, 姓名
from xs
where 专业 = '网络工程' and 姓名 like '[张, 李, 王]%';

4.
select 学号, 姓名, 专业
from xs
where 专业 not in ('网络工程', '信息管理')
order by 专业 asc, 学号 desc;

5.
select 课程号, count(成绩) as 不及格人数
from cj
where 成绩 < 60
group by 课程号;

6.
--where子句中不可以使用select子句中定义的列名
select 学号, 姓名, datediff(year, 出生时间, getdate()) as 年龄
from xs
where 专业 = '网络工程' 
and (datediff(year, 出生时间, getdate()) > 35 or datediff(year, 出生时间, getdate()) < 30);

7.
select distinct 学号
from cj
except
select distinct 学号
from cj
where 课程号 = 'J001';

8.
select 学号, 姓名, year(出生时间) as chusheng
from xs;

9.
select 学号, 姓名, year(cast(substring(身份证号码, 7, 8) as date)) as 出生年份
from xs;

10.
select 学号, 成绩
from cj
where 成绩 = (select max(成绩)
			 from cj
			 where 课程号 = 'J001');

11.
select 学号, 姓名
from xs
where 姓名 like '%明%' or 姓名 like '%丽%';


12.
select count(*) as 人数
from xs
where 专业 = '信息管理' and datediff(year, 出生时间, getdate()) > 20;

13.
select 课程号, avg(成绩) as 平均成绩
from cj
group by 课程号
having avg(成绩) > 80;

14.
select 专业, count(*) as 人数
from xs
where 姓名 like '张%'
group by 专业;

15.
select distinct left(姓名, 1) as 姓氏, count(*) as 人数
from xs
group by left(姓名, 1);

16.
select 学号, count(课程号) as 选课门数, avg(成绩) as 平均成绩
from cj
group by 学号
where count(课程号) >= 5;

17.
select top(5) 学号, 成绩
from cj
where 课程号 = "J001"
order by 成绩 desc;

18.
select 学号, min(成绩) as 最低分, count(课程号) as 选课门数
from cj
group by 学号;

19.
select 专业, sum(case 性别 when '男' then 1 else 0 end) as 男生数，
sum(case 性别 when '女' then 1 else 0 end) as 女生数
from xs
group by 专业;

select 专业, 性别, count(*) as 人数
from xs
group by 专业, 性别;

20.
select 专业, count(性别) as 男生数
from xs
where 性别 like '男';

21.
select 学号, avg(成绩) as 平均成绩
from cj
group by 学号
having sum(case when 成绩 < 60 then 1 else 0 end) >= 2;

select 学号, avg(成绩) as 平均成绩
from cj
group by 学号
having (select count(*)
		from cj as cj1
		where cj.学号 = cj1.学号 and 成绩 < 60) >= 2;

22.
select 学号, 姓名, 性别, datediff(year, 出生时间, getdate()) as 年龄, 专业 
from xs
where substring(学号, 5, 1) in ('1', '2', '3', '4', '9') or substring(学号, 6, 1) in ('1', '2', '3', '4', '9');

23.
select 学号, 课程号, 成绩
from cj
where cj.学号 in (select 学号
				from cj
				where cj.课程号 = 'A001' and cj.学号 in (select 学号
															from cj
															where 课程号 = 'A002'));

24.
select 学号, 课程号
from cj
where cj.课程号 in ('A001', 'A002', 'J001', 'J002');

25.
select left(姓名, 1) as 姓氏, count(*) as 人数
from xs
where len(姓名) = 2
group by left(姓名, 1);

26.
select distinct xs.学号, 姓名
from cj join xs on cj.学号 = xs.学号
where 课程号 in (select 课程号
				from kc
				where 课程名 in ('数学', '英语'));

27.
select 学号, 姓名
from 

28.
select cj.学号, 姓名, count(课程号) as 选课门数, avg(成绩) as 平均分
from cj left join xs on cj.学号 = xs.学号
group by cj.学号, 姓名

29.
--having子句中不可以使用select子句中定义的列名
select kc.课程号, 课程名, count(*) as 选课人数, avg(成绩) as 平均分
from kc left join cj on kc.课程号 = cj.课程号
group by kc.课程号, 课程名
having count(*) > 5;

30.
select max(成绩) as 最高分
from cj left join kc on cj.课程号 = kc.课程号
		left join xs on cj.学号 = xs.学号
where xs.专业 like '计算机' and 课程名 like '数据库SQL Server';











































