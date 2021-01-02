路龙灰的答案：

——————xsgl——————

--对xs表增加身份证号码属性列，要求是18位的字符类型

Alter table xs add 身份证号码 char(18)

Go



--1.查询有直接先行课的课程的课号，课名和先行课号。

select 课程号,课程名,先行课号 from kc

where 先行课号 is not null

Go



--2.查询先行课号是“J001”号课程的课号和课名

select 课程号,课程名 from kc

where 先行课号 = 'J001'

Go



--3.查询所有的网络工程系姓李，张，王的同学的学号和姓名

select 学号,姓名 from xs

where (姓名 like '李%' 

 or 姓名 like '王%'

 or 姓名 like '张%')

 and 专业 = '网络工程'

Go



--4.查询不在网络工程和信息管理专业学习的学生的学号和姓名，系别，并对查询结果按照专业的升序和学号的降序排序

select 学号,姓名,专业 from xs

where 专业 not in('网络工程','信息管理')

order by 专业 asc, 学号 desc

Go



--5.查询每门课不及格的学生的人数，显示课号和人数

select 课程号,count(成绩) as 不及格人数 from cj

where 成绩 < 60

group by 课程号

Go



--6.查询年龄不在30-35之间的网络工程系的学生的学号，姓名和年龄

select 学号,姓名, datediff(yy,出生时间,getdate())as 年龄 from xs

where datediff(yy,出生时间,getdate()) > 35

 or datediff(yy,出生时间,getdate()) < 30

Go



--7.查询没有选修‘J001’号课程的学生的学号（注意去掉重复的元组）

select distinct 学号 from cj

except 

select distinct 学号 from cj

where 课程号 = 'J001'

Go



--8.查询每个学生的学号，姓名，出生年份，并给出生年份起别名为chusheng 

select 学号,姓名,year(出生时间) as chusheng from xs

Go



--9.查询每个学生的学号，姓名和出生日期（出生日期根据身份证号码查询）

select 学号,姓名,convert(date,SUBSTRING(身份证号码,7,8) )as 出生年份 from xs

Go



--10.查询选修J001课程成绩排名第一的同学的学号和成绩

select top(1) 学号,成绩 from cj

where 课程号 = 'J001'

order by 成绩 desc

Go



--11.查询所有名字中含有’明’或者’丽’的同学的学号，姓名

select 学号, 姓名 from xs

where 姓名 like '%[明,丽]%'

Go



--12.查询信息管理专业年龄超过20岁的学生的人数

select count(*) as 人数 from xs

where 专业 = '信息管理' and datediff(yy,出生时间,getdate()) >= 20

Go



--13.查询平均成绩超过80分的课程的课程号和平均成绩

select 课程号, avg(成绩)as 平均分 from cj

group by 课程号

having avg(成绩) >80

Go



--14.查询每个专业所有姓张的人数

select 专业, count(*) as 姓张人数 from xs

where 姓名 like '张%'

group by 专业

Go
select  b.专业,count(a.学号)
from xs a right join xs b 
on  a.学号 = b.学号 and a.姓名 like '张%'
where b.专业 is not null
group by b.专业   


--15.查询各种姓氏的人数（假设没有复姓）

select distinct left(姓名,1) as 姓氏, count(*)from xs

group by left(姓名,1)

Go



--16.查询选修课程超过5门的学生的学号和选课门数，以及平均成绩

select 学号, count(课程号) as 选课门数, avg(成绩) as 平均成绩 from cj

group by 学号

having count(课程号)>=5

Go



--17.查询选修‘J001’课程的成绩排名前五的学生的学号和成绩

select top(5) 学号, 成绩 from cj 

where 课程号 = 'J001'

order by 成绩 desc

Go



--18.查询每个学生的最低分和选课门数

select 学号, min(成绩) as 最低分, count(课程号)as 选课门数 from cj

group by 学号

Go



--19.查询各个专业各种性别的人数

select 专业, 

 sum(case 性别 when '男' then 1 else 0 end) as 男生数,

 sum(case 性别 when '女' then 1 else 0 end) as 女生数 

from xs

group by 专业

Go
select  专业,性别,count(*) 人数
from xs
group by  专业,性别


--20.查询各个专业男生的人数

select 专业,count(性别) as 男生人数 from xs

where 性别 = '男'

group by 专业

Go



--21.列出有二门以上课程（含两门）不及格的学生的学号及该学生的平均成绩；

select 学号,avg(成绩) from cj

group by 学号

having sum(case when 成绩 < 60 then 1 else 0 end) >=2

Go



--22.显示学号第五位或者第六位是1、2、3、4或者9的学生的学号、姓名、性别、年龄及专业；

select 学号,姓名,性别,datediff(yy,出生时间,getdate()) as 年龄,专业 from xs

where 

SUBSTRING(学号,5,1) in('1','2','3','4','9')

or SUBSTRING(学号,6,1) in('1','2','3','4','9')

Go



--23.查询选修了A001和A002课程的学生的学号，课程号，成绩（使用连接）；

select *

from cj

where cj.学号 in(

select s1.学号

from cj s1, cj s2

where s1.学号 = s2.学号 and s1.课程号 = 'A001' and s2.课程号 = 'A002');

select *

from cj

where cj.学号 in(

select s1.学号

from cj s1

where s1.课程号 = 'A001' and 
     s1.学号 in(
	 select 学号
	 from cj
	 where 课程号 = 'A002'));


--24.查询选修了A001或者A002或者J001或者J002课程的学生的学号和课程号

select 学号, 课程号 from cj

where

 课程号 in('A001','A002', 'J001', 'J002')

Go



--25.查询姓名为两个字的不同姓氏的人数，输出姓氏，人数。

select distinct left(姓名,1) as 姓氏, count(*)from xs

where len(姓名) = 2

group by left(姓名,1)

Go



--26.查询选修了高数或者英语的学生的学号和姓名

select distinct xs.学号,姓名 from xs,kc,cj

where xs.学号 = cj.学号

 and cj.课程号 =kc.课程号

 and 课程名 in('数学','英语')

Go



--27.查询没有选课的学生的学号和姓名

select distinct 学号, 姓名  from xs

where 学号 not in(

select 学号 from cj)

Go
select xs.学号 ,xs.姓名 
from xs left join cj
on xs.学号 =cj.学号 
where cj.课程号  is null



--28.查询每个学生的学号，姓名，选课门数和平均分

select /*distinct*/ xs.学号,姓名, count(cj.课程号) as 选课门数, avg(cj.成绩) as 平均分 from xs, cj

where xs.学号 = cj.学号

group by xs.学号,xs.姓名

Go



--29.查询选课人数超过5人的课程的课程号，课程名，选课人数和平均分

select cj.课程号,课程名, count(学号) as 选课人数, avg(成绩) as 平均分 from cj,kc

where kc.课程号 = cj.课程号

group by cj.课程号,课程名

Go



--30.查询计算机系选数据库最高分

select max(成绩) as 最高分 from xs,cj,kc

where xs.学号 = cj.学号 

 and cj.课程号 = kc.课程号

 and 课程名 = '数据库SQL Server'

 and 专业 = '计算机'

Go

——————SPJ——————

--1.求供应工程J1零件的供应商号码SNO

select distinct SNO from SPJ

where JNO = 'J1'

Go



--2.求查询每个工程使用不同供应商的零件的个数

select JNO,SNO,sum(QTY) from SPJ

group by JNO, SNO

order by JNO asc

Go



--3.求供应工程使用零件P3数量超过200的工程号JNO

select spj.jno from SPJ

where PNO = 'P3'

 group by jno
 having sum(qty)>200

Go



--4.求颜色为红色和蓝色的零件的零件号和名称

select PNO, PNAME from P

where COLOR in('红','蓝')

Go



--5.求使用零件数量在200-400之间的工程号

select JNO,sum(QTY) from SPJ

group by JNO

having sum(QTY) between 200  and 400

Go



--6.查询每种零件的零件号，以及使用该零件的工程数。

select  SPJ.PNO, count(distinct JNO) from P left join SPJ

on P.PNO = SPJ.PNO

group by SPJ.PNO

Go