--ʹ�����ݿ�student��������²�������д����Ӧ�Ĵ���
--1.	�ú���ʵ�֣���ĳ��רҵѡ����ĳ�ſγ̵�ѧ�������������ú�����������ϵ�����ݿ⡱�γ̵�ѡ��������
create function tongji(@dept as varchar(8),@cname  as varchar(20))
returns int
begin
declare @sum int
select @sum=count(*)
from sc,course,student
where sc.cno=course.cno and sc.sno=student.sno and course.cname=@cname and student.sdept=@dept
return @sum
end
--����
select dbo.tongji('CS','���ݿ�')as ���� 
--2.	����Ƕ��ֵ����ʵ�֣���ѯĳ��רҵ����ѧ����ѡ��ÿ�ſε�ƽ���ɼ������øú�����������ϵ�����пγ̵�ƽ���ɼ���
create function cavg2(@dept as varchar(8))
returns table 
as return(
select course.cno,avg(grade) ƽ���ɼ�
from sc,course,student
where sc.cno=course.cno and sc.sno=student.sno and student.sdept=@dept
group by course.cno)
--����
select * from  dbo.cavg2('CS')
--3.	����������ֵ������ͨ��ѧ����Ϊʵ�ε��øú���������ʾ��ѧ���������Լ����ſεĳɼ���ѧ�֣�
--���øú��������200515002���ĸ��ſγɼ���ѧ�֡�
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
--����
SELECT * FROM gstu ('200515002')


--4.	��дһ���洢���̣�ͳ��ĳ�ſγ̵����㣨90-100�����������ã�80-89���������еȣ�70-79������������60-69�������ͼ����ʣ�
--����������ǿγ̺ţ�������Ǹ����������������ʣ������ʵ���ʽ��90.25%��ִ�д洢���̣�����Ϣ����ʾ1�ſγ̵�ͳ����Ϣ��
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
print '��������'+str(@gr) 
print '��������'+str(@go)  
print '�е�����'+str(@me) 
print '��������'+str(@pa) 
print '������'+@pap+'%'


--5.	����һ��������������Ĵ洢���̣��ô洢���̸��ݴ����ѧ�����֣���ѯ��ѡ�޵Ŀγ����ͳɼ���
--ִ�д洢���̣�����Ϣ����ʾ������������Ϣ��
create procedure p5 @sname nchar(6)
as
declare @cname char(20) , @grade int 
declare c scroll cursor for
select	course.cname,sc.grade	
from sc,student,course	
where sc.cno=course.cno and sc.sno=student.sno and student.sname=@sname
open c
print '�γ���'+'                    '+'�ɼ�'
fetch next from c into @cname,@grade
while @@FETCH_STATUS=0
begin
print @cname+'      '+cast(@grade as char(4))
fetch next from c into @cname,@grade
end
close c
deallocate c
--����
exec p5 '��ݼݼ'

--6.	�Ի����� courseΪ������������²���
--������ʾ���±�����ʽ���α꣺���������г�ѧ����ѧ�ź�������Ȼ���ڴ�ѧ���£�
--�г�����ѡ��ȫ���γ̵Ŀγ̺š��γ�����ѧ�֣��������ƣ�ֱ���г�ȫ��ѧ����
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
print '�γ̺�'+'    '+'�γ���'+'            '+'ѧ��'
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

--7. �����һ���洢����ʵ�����й��ܣ�
--�ж�ĳ��רҵĳ�ſγ̳ɼ�����Ϊn��ѧ���ĳɼ��Ƿ���ڸ��ſγ̵�ƽ���֣��������ƽ����
--������ɼ���Ϊƽ���֣��������ѧ�š��������γ̺š��γ������ɼ�������ʾ�������ڴ洢�����ڲ�ʹ���α꣩��
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
--����
exec  ex7 'CS', '1',3
--8.	��student���ݿ���ƴ洢���̣�ʵ�ֽ�ĳ�ſγ̳ɼ����ڿγ�ƽ���ɼ���ѧ���ɼ�������3�֡�����ʾ����ʹ�ô洢�����ڲ�ʹ���α꣩
--����һ��
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

--���ԣ�
select * from sc where cno='2'
exec addgrade '2'
--��������
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
--����
select * from sc where cno='2'
exec addgrade1 '2'
--8.	��student���ݿ���ƴ洢���̣�ʵ�ֽ�ĳ�ſγ̳ɼ����ڿγ�ƽ���ɼ���ѧ���ɼ�������3�֡�����ʾ����ʹ�ô洢�����ڲ�ʹ���α꣩
--����һ��
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

--���ԣ�
select * from sc where cno='2'
exec addgrade '2'
--��������
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
--����
select * from sc where cno='2'
exec addgrade1 '2'
--9.	��ƴ洢����ʵ��ѧ��תרҵ���ܣ�ĳ��ѧ����ѧ�ţ���תרҵʱ�������ת���רҵ�Ǽ����רҵ��ôҪ���ѧ����ƽ���ɼ����볬��95�֣���������תרҵ������תרҵ����Ϣ���뵽һ��תרҵ�ı��changesd(ѧ�ţ�ԭרҵ����רҵ��ƽ���ɼ�)
create table changesd
(ѧ�� char(9),ԭרҵ varchar(8),��רҵ varchar(8),ƽ���ɼ� numeric(4,1))

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
print '�ɼ�û����95�֣��޷�ת������רҵ'
else
begin
update student
set Sdept=@n_sdept
where Sno=@sno
insert into changesd
values(@sno,@o_sdept,@n_sdept,@avg)
end
--����
exec change '200515004','CS'
--��ʾ���ɼ�û����95�֣��޷�ת������רҵ
exec change '200515004','MA'
--�ɹ�
--10.	����ͼ��������ݿ⣬ ���а������¼�����
--���߱�reader(ѧ�ţ��������Ա����)
--�����lend��ѧ�ţ���ţ��������ڣ�Ӧ�����ڣ��Ƿ����裩
--Ƿ���debt(ѧ�ţ����ڣ�Ƿ����)
--�����return(ѧ�ţ���ţ���������) 
--�����һ���洢����ʵ������������������Ҫ�����£�
--ֻ��û�г��ڵ���ſ������裨���������ʱ�䶼Ϊ30�죩�����޸�Ӧ�����ڣ�����ֻ�ܻ��飻����ʱɾ��������ڵĽ��ļ�¼����������в���һ�������¼��ע�⻹������Ϊ��ǰ���ڣ����ҶԳ���ͼ�飬���ճ��ڵ���������������ÿ��ÿ���鷣��0.1Ԫ��������������Ϣ���뵽Ƿ����У�ͬʱ������Ӷ��߱�������۳���
use ͼ�����--�ѽ����ݿ�
create table reader
(ѧ�� char(9),���� varchar(10),�Ա� char(2),��� money)
create table lend
(ѧ�� char(9),��� char(20),�������� date,Ӧ������ date,�Ƿ����� varchar(6))

create table debt
(ѧ�� char(9),���� date,Ƿ���� money)

create table [return]
(ѧ�� char(9),��� char(20),�������� date)
create procedure return_book @sno char(9),@bno char(20)
as
declare @rdate date,@xujie varchar(6),@day int
select @rdate=Ӧ������,@xujie=�Ƿ�����
from lend
where ѧ��=@sno and ���=@bno
 if (@xujie='����' and @rdate>=getdate() ) 
 update lend set Ӧ������=dateadd(day,30,Ӧ������)
  else begin
       delete from lend
	   where ѧ��=@sno and ���=@bno
	   insert into [return] values (@sno,@bno,getdate())
	   end
if(@rdate<getdate())
begin
set @day=datediff(day,@rdate,getdate())
insert into debt values(@sno,getdate(),@day*0.1)
update reader set ���=���-@day*0.1
where ѧ��=@sno 
end
--����
exec return_book '201900801','12345678'
exec return_book '201900801','112345678'
exec return_book '201900802','12345678'