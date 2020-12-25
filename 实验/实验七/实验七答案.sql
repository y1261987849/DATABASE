--使用数据库student，完成以下操作，并写出相应的代码
--1.	用函数实现：求某个专业选修了某门课程的学生人数，并调用函数求出计算机系“数据库”课程的选课人数。
create function tongji(@dept as varchar(8),@cname  as varchar(20))
returns int
begin
declare @sum int
select @sum=count(*)
from sc,course,student
where sc.cno=course.cno and sc.sno=student.sno and course.cname=@cname and student.sdept=@dept
return @sum
end
--测试
select dbo.tongji('CS','数据库')as 人数 
--2.	用内嵌表值函数实现：查询某个专业所有学生所选的每门课的平均成绩；调用该函数求出计算机系的所有课程的平均成绩。
create function cavg2(@dept as varchar(8))
returns table 
as return(
select course.cno,avg(grade) 平均成绩
from sc,course,student
where sc.cno=course.cno and sc.sno=student.sno and student.sdept=@dept
group by course.cno)
--测试
select * from  dbo.cavg2('CS')
--3.	创建多语句表值函数，通过学号作为实参调用该函数，可显示该学生的姓名以及各门课的成绩和学分，
--调用该函数求出“200515002”的各门课成绩和学分。
create function gstu (@no char(9)) returns @score table 
( xs_no char(9) ,
xs_name varchar(8) ,
kc_name  varchar(20) ,
cj int ,
xf numeric(2,1) ) 
as 
begin
insert @score  select s.sno,s.sname,c.cname,sc.grade,c.credit  
from student s,course  c, sc
where s.sno=sc.sno AND c.cno=sc.cno
and  s.sno=@no 
return 
end
--测试
SELECT * FROM gstu ('200515002')


--4.	编写一个存储过程，统计某门课程的优秀（90-100）人数、良好（80-89）人数、中等（70-79）人数、及格（60-69）人数和及格率，
--其输入参数是课程号，输出的是各级别人数及及格率，及格率的形式是90.25%，执行存储过程，在消息区显示1号课程的统计信息。
create procedure p1
@cno char(4),
@great int output,
@good int output,
@medium int output,
@pass int output,
@passper varchar(10) output
as
	declare @sum float
	select @great=count(*)	from sc where cno=@cno and grade between 90 and 100
	select @good=count(*)	from sc where cno=@cno and grade between 80 and 89
	select @medium=count(*)	from sc where cno=@cno and grade between 70 and 79
	select @pass=count(*)	from sc where cno=@cno and grade between 60 and 69
	select @sum=count(*)	from sc where cno=@cno
	select @passper = str(cast((@great+@good+@medium+@pass)*100/@sum as numeric(5,2)))
	--select @passper=(str(cast((@great)*100.0/@sum*1.0 as ) ) +'%')
declare	@gr int,@go int,@me int,@pa int,@pap varchar(10)
exec p1 '1' ,
@gr output,
@go  output,
@me  output,
@pa output,
@pap output
print '优秀人数'+str(@gr) 
print '良好人数'+str(@go)  
print '中等人数'+str(@me) 
print '及格人数'+str(@pa) 
print '及格率'+@pap+'%'


--5.	创建一个带有输入参数的存储过程，该存储过程根据传入的学生名字，查询其选修的课程名和成绩，
--执行存储过程，在消息区显示赵箐箐的相关信息。
create procedure p5 @sname nchar(6)
as
declare @cname char(20) , @grade int 
declare c scroll cursor for
select	course.cname,sc.grade	
from sc,student,course	
where sc.cno=course.cno and sc.sno=student.sno and student.sname=@sname
open c
print '课程名'+'                    '+'成绩'
fetch next from c into @cname,@grade
while @@FETCH_STATUS=0
begin
print @cname+'      '+cast(@grade as char(4))
fetch next from c into @cname,@grade
end
close c
deallocate c
--测试
exec p5 '赵菁菁'

--6.	以基本表 course为基础，完成如下操作
--生成显示如下报表形式的游标：报表首先列出学生的学号和姓名，然后在此学生下，
--列出其所选的全部课程的课程号、课程名和学分；依此类推，直到列出全部学生。
declare @sno char(9), @sname nchar(6)
declare @cno char(4),@cname char(20),@credit int
declare c1 scroll cursor	for
select student.sno,student.sname
from student
open c1
fetch next from c1 into @sno,@sname
while @@FETCH_STATUS=0
begin
print @sno+'    '+@sname
print'_______________________________________'
print '课程号'+'    '+'课程名'+'            '+'学分'
declare c2 scroll cursor for
select course.cno,course.cname,course.credit
from course,sc
where course.cno=sc.cno and sc.sno=@sno
open c2
fetch next from c2 into @cno,@cname,@credit
while @@FETCH_STATUS=0
begin 
print @cno+'      '+@cname+cast(@credit as char(4))
fetch next from c2 into @cno,@cname,@credit
end
close c2
deallocate c2
print'======================================='
fetch next from c1 into @sno,@sname
end
close c1
deallocate c1

--7. 请设计一个存储过程实现下列功能：
--判断某个专业某门课程成绩排名为n的学生的成绩是否低于该门课程的平均分，如果低于平均分
--，则将其成绩改为平均分，否则输出学号、姓名、课程号、课程名、成绩。（提示：可以在存储过程内部使用游标）。
create procedure ex7 @dept varchar(8),@cno char(4),@n int
as
declare @avggrade int
select @avggrade=(select avg(grade)	from sc	where cno=@cno)
declare c scroll cursor for
select student.sno,sname,sc.cno,cname,grade from student,sc,course
where student.sno=sc.sno and course.cno=sc.cno and course.cno=@cno and student.sdept=@dept 
order by grade desc
open c
declare @sno char(9),@sname nchar(6),@cno1  char(4),@cname varchar(20),@grade int
fetch absolute @n from c into @sno,@sname,@cno1,@cname,@grade
if @grade>@avggrade
print @sno+'   '+@sname+'    '+@cno1+'    '+@cname+'    '+cast(@grade as char(4))
else
update sc
set grade=@avggrade
where current of c
close c
deallocate c
--测试
exec  ex7 'CS', '1',3
--8.	对student数据库设计存储过程，实现将某门课程成绩低于课程平均成绩的学生成绩都加上3分。（提示可以使用存储过程内部使用游标）
--方法一：
create proc addgrade  @cno char(4)
as
	declare @avergrade decimal(4,1)
	select @avergrade = AVG(grade)
	from sc
	where cno = @cno
	update sc
	set grade = grade+3
	where cno = @cno and grade <= @avergrade
go

--测试：
select * from sc where cno='2'
exec addgrade '2'
--方法二：
create procedure addgrade1 @cno char(4)
as
declare @avg decimal(4,1),@sno char(9),@grade int
set @avg=(select avg(grade) from sc where cno=@cno)
declare c scroll cursor for 
select sno,grade from sc where  cno=@cno
open c
fetch next from c into @sno,@grade
while(@@FETCH_STATUS=0)
begin
	if(@grade<@avg)
	update sc set grade=@grade+3 where current of c
	fetch next from c into @sno,@grade
end
close c
deallocate c
--测试
select * from sc where cno='2'
exec addgrade1 '2'
--8.	对student数据库设计存储过程，实现将某门课程成绩低于课程平均成绩的学生成绩都加上3分。（提示可以使用存储过程内部使用游标）
--方法一：
create proc addgrade  @cno char(4)
as
	declare @avergrade decimal(4,1)
	select @avergrade = AVG(grade)
	from sc
	where cno = @cno
	update sc
	set grade = grade+3
	where cno = @cno and grade <= @avergrade
go

--测试：
select * from sc where cno='2'
exec addgrade '2'
--方法二：
create procedure addgrade1 @cno char(4)
as
declare @avg decimal(4,1),@sno char(9),@grade int
set @avg=(select avg(grade) from sc where cno=@cno)
declare c scroll cursor for 
select sno,grade from sc where  cno=@cno
open c
fetch next from c into @sno,@grade
while(@@FETCH_STATUS=0)
begin
	if(@grade<@avg)
	update sc set grade=@grade+3 where current of c
	fetch next from c into @sno,@grade
end
close c
deallocate c
--测试
select * from sc where cno='2'
exec addgrade1 '2'
--9.	设计存储过程实现学生转专业功能：某个学生（学号）在转专业时，如果想转入的专业是计算机专业那么要求该学生的平均成绩必须超过95分，否则不允许转专业，并将转专业的信息插入到一个转专业的表里，changesd(学号，原专业，新专业，平均成绩)
create table changesd
(学号 char(9),原专业 varchar(8),新专业 varchar(8),平均成绩 numeric(4,1))

create procedure change @sno char(9),@n_sdept varchar(8)
as
declare @avg numeric(4,1),@o_sdept varchar(8)
select @avg=avg(Grade)
from sc
where  Sno=@sno
select @o_sdept=Sdept
from student
where Sno=@sno
if(@n_sdept='CS' and @avg<=95)
print '成绩没超过95分，无法转入计算机专业'
else
begin
update student
set Sdept=@n_sdept
where Sno=@sno
insert into changesd
values(@sno,@o_sdept,@n_sdept,@avg)
end
--测试
exec change '200515004','CS'
--提示：成绩没超过95分，无法转入计算机专业
exec change '200515004','MA'
--成功
--10.	现有图书管理数据库， 其中包含如下几个表：
--读者表：reader(学号，姓名，性别，余额)
--借书表：lend（学号，书号，借书日期，应还日期，是否续借）
--欠款表：debt(学号，日期，欠款金额)
--还书表：return(学号，书号，还书日期) 
--请设计一个存储过程实现续借或还书操作，具体要求如下：
--只有没有超期的书才可以续借（借书和续借时间都为30天），并修改应还日期，否则只能还书；还书时删除借书表内的借阅记录，并向还书表中插入一条还书记录，注意还书日期为当前日期，并且对超期图书，按照超期的天数计算出罚款金额（每天每本书罚款0.1元），并将罚款信息插入到欠款表中，同时将罚款从读者表的余额里扣除。
use 图书管理--已建数据库
create table reader
(学号 char(9),姓名 varchar(10),性别 char(2),余额 money)
create table lend
(学号 char(9),书号 char(20),借书日期 date,应还日期 date,是否续借 varchar(6))

create table debt
(学号 char(9),日期 date,欠款金额 money)

create table [return]
(学号 char(9),书号 char(20),还书日期 date)
create procedure return_book @sno char(9),@bno char(20)
as
declare @rdate date,@xujie varchar(6),@day int
select @rdate=应还日期,@xujie=是否续借
from lend
where 学号=@sno and 书号=@bno
 if (@xujie='续借' and @rdate>=getdate() ) 
 update lend set 应还日期=dateadd(day,30,应还日期)
  else begin
       delete from lend
	   where 学号=@sno and 书号=@bno
	   insert into [return] values (@sno,@bno,getdate())
	   end
if(@rdate<getdate())
begin
set @day=datediff(day,@rdate,getdate())
insert into debt values(@sno,getdate(),@day*0.1)
update reader set 余额=余额-@day*0.1
where 学号=@sno 
end
--测试
exec return_book '201900801','12345678'
exec return_book '201900801','112345678'
exec return_book '201900802','12345678'