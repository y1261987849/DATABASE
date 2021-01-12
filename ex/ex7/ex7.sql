--1.用函数实现：求某个专业选修了某门课程的学生人数，并调用函数求出计算机系“数据库”课程的选课人数。
create function number (@dept varchar(8), @cnmae varchar(20))
returns int
as
begin
	declare @sum int
	select @sum = count(*)
	from student as s join sc on s.sno = sc.sno
					join course as c on sc.cno = c.cno
	where student.sdept = @dept and course.cname = @cname
	return @sum
end;

select dbo.number('CS', '数据库') as 人数

--2.用内嵌表值函数实现：查询某个专业所有学生所选的每门课的平均成绩；调用该函数求出计算机系的所有课程的平均成绩。
create function avg_grade (@dept varchar(8))
returns table
as
	return (select course.cname, avg(grade) as 平均成绩
			from student as s join sc on s.sno = sc.sno
					join course as c on sc.cno = c.cno
			where student.sdept = @dept
			group by course.cname);

select *
from dbo.avg_grade('CS');

--3.创建多语句表值函数，通过学号作为实参调用该函数，可显示该学生的姓名以及各门课的成绩和学分，调用该函数求出“200515002”的各门课成绩和学分。
create function stu_info(@sno char(9))
returns @info table (stu_name varchar(8), cname varchar(20), grade int, credit numeric(2, 1))
as
begin
	insert @info
	select student.sname, course.cname, sc.grade, course.credit
	from student as s join sc on s.sno = sc.sno
					join course as c on sc.cno = c.cno
	where student.sno = @sno
	return
end;

select *
from stu_info('200515002');

--4.编写一个存储过程，统计某门课程的优秀（90-100）人数、良好（80-89）人数、中等（70-79）人数、及格（60-69）人数和及格率，其输入参数是课程号，输出的是各级别人数及及格率，及格率的形式是90.25%，执行存储过程，在消息区显示1号课程的统计信息。
create procedure p1
@cno char(4),
@great int output,
@good int output,
@medium int output,
@pass int output,
@per varchar(10) output,
as
	declare @sum float
	select @greate = count(*) from sc where sc.cno = @cno and grade between 90 and 100
	select @good  = count(*) from sc where sc.cno = @cno and grade between 80 and 89
	select @medium = count(*) from sc where sc.cno = @cno and grade between 70 and 79
	select @pass = count(*) from sc where sc.cno = @cno and grade between 60 and 69
	select @sum = count(*) from sc where sc.cno = @cno
	select @per = str(cast((@greate + @good + @medium + @pass) / @sum as numeric(5, 2)) * 100) + '%'

declare @ngreat int, @ngood int, @nmedium int, @npass int, @per varchar(10)
exec p1 '1', @ngreat output, @ngood output, @nmedium output, @npass output @per output
print '优秀人数' + str(@ngreat)
print '良好人数' + str(@ngreat)
print '中等人数' + str(@ngreat)
print '及格人数' + str(@ngreat)
print '及格率' + @per

--5.创建一个带有输入参数的存储过程，该存储过程根据传入的学生名字，查询其选修的课程名和成绩，执行存储过程，在消息区显示赵箐箐的相关信息。
create procedure p2
@sname varchar(10)
as
	declare @cname varchar(20), @grade int
	declare c scroll cursor
	for select course.cname, sc.grade
	from sc join course on sc.cno = course.cno
			join student on sc.sno = student.sno
	where student.sname = @sname
	open c
	print '课程名' + '             ' + '成绩'
	fetch next from c into @cname, @grade
	while @@fetch_status  = 0
	begin
		print @cname + '             ' + cast(@grade as char(4))
		fetch next from c into @cname, @grade
	end
	close c
	deallocate c;

exec p2 '赵菁菁';

--6.以基本表course为基础，完成如下操作生成显示如下报表形式的游标：报表首先列出学生的学号和姓名，然后在此学生下，列出其所选的全部课程的课程号、课程名和学分；依此类推，直到列出全部学生。
declare @sno char(9), @sname nchar(6)
declare @cno char(4), @cname char(20), @credit int

declare c1 scroll cursor
for select student.sno, student.sname
	from student

open c1
fetch next from c1 into @sno, @sname

while @@fetch_status = 0
begin
	print @sno + '               ' + @sname
	print '_________________________'
	print '课程号' + '   ' + '课程名' + '    ' + '学分'

	declare c2 scroll cursor
	for select course.cno, course.cname, course.credit
		from course join scn on course.cno = sc.cno
		where sc.cno = @sno
	open c2
	fetch next from c2 into @cno, @cname, @credit
	while @@fetch_status = 0
	begin
		print @cno + '    ' + @cname + '    ' + cast(@credit as char(4))
		fetch next from c2 into @cno, @cname, @credit
	end
	close c2
	deallocate c2
	print '========================'

	fetch next from c1 into @sno, @sname
end

close c1
deallocate c1


--7.请设计一个存储过程实现下列功能：判断某个专业某门课程成绩排名为n的学生的成绩是否低于该门课程的平均分，如果低于平均分，则将其成绩改为平均分，否则输出学号、姓名、班号、课程号、课程名、成绩。（提示：可以在存储过程内部使用游标）。
create procedure p3
@dept varchar(8), 
@cname1 varchar(20), 
@n int
as
	declare @avg float
	select @avg = avg(grade)
	from sc join course on sc.cno = course.cno
	where course.cname = @cname

	declare c scroll cursor
	for select student.sno, student.name, course.cno, course.cname, sc.grade
		from student join sc on student.sno = sc.sno
					join course on sc.cno = course.cno
		where student.dept = @dept
		order by grade desc

	open c

	declare @sno char(9), @sname ncahr(6), @cno char(4), @cname2 varchar(20), @grade int
	fetch absolute @n from c into @sno, @sname, @cno, @cname2, @grade
	if @grade > @avg
		print @sno + '   ' + @sname + '   ' + @cno + '   ' + @cname2 + '   ' + cast(@grade as char(4))
	else
		update sc
		set grade = @avg
		where current of c

	close c
	deallocate c

exec p3 'CS', '数据库', '3'

--8.对student数据库设计存储过程，实现将某门课程成绩低于课程平均成绩的学生成绩都加上3分。（提示可以使用存储过程内部使用游标）
create proc addgrade @cname char(4)
as
	declare @avg float
	select @avg = avg(grade)
	from sc join course on sc.cno = course.cno
	where course.cname = @cname

	declare c scroll cursor
	for select grade
		from sc
		where sc.cno = @cno

	open c

	fetch next from c into @grade
	while @@fetch_status = 0
	begin
		if @grade < @avg
			update sc
			set grade = @grade + 3
			where current of c
			fetch next from c into @sno, @grade
	end

	close c
	deallocate c

--9.设计存储过程实现学生转专业功能：某个学生（学号）在转专业时，如果想转入的专业是计算机专业那么要求该学生的平均成绩必须超过95分，否则不允许转专业，并将转专业的信息插入到一个转专业的表里，changesd(学号，原专业，新专业，平均成绩)
create proc p4 @sno char(9), @dept varchar(20)
as 
	declare @avg numeric(4, 1), @odept varchar(20)

	select @avg = avg(grade)
	from sc
	where sc.sno = @sno

	select @odept = sdept
	from student
	where student.sno = @sno

	if @dept = 'CS' and @avg < = 95
		print '不允许转专业'
	else
		begin
			update student
			set sdept = @dept
			where student.sno = @sno

			insert into changed
			values (@sno, @odept, @dept, @avg)
		end


--10.
create proc op_book @sno char(9), @bno char(20)
as
	declare @s_date date, @kl varchar(6), @day int
	
	select @s_date = 应还日期, @kl = 是否续借
	from lend
	where 学号 = @sno and 书号 = @bno

	if @kl = '是' and @s_date >= getdate()
		update lend
		set 应还日期 = dateadd(day, 30, 应还日期)
	else
		begin
			delete from lend
			where 学号 = @sno and 书号 = @bno

			insert into [return] --与关键字重名
			values (@sno, @bno, getdate())
		end

	if @s_date < getdate()
		begin
			set @day = datediff(day, @s_date, getdate())
			insert into debt values(@sno, getdate(), @day * 0.1)
			update reader
			set 余额 = 余额 - @day * 0.1
			where 学号 = @sno
		end





































