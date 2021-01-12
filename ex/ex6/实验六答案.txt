USE STU
go
CREATE TABLE COURSE(
	CNO CHAR(4),
	CNAME CHAR(40),
	CPNO CHAR(4),
	CCREDIT SMALLINT
);

CREATE TABLE SC(
	SNO CHAR(9),
	CNO CHAR(4),
	GRADE SMALLINT
);

CREATE TABLE STUDENT(
	SNO CHAR(9),
	SNAME CHAR(20),
	SSEX CHAR(4),
	SAGE SMALLINT,
	SDEPT CHAR(10)
)

--1.	将stu数据库中student表的sno定义为主键；
USE STU
go
ALTER TABLE STUDENT 
ALTER COLUMN SNO CHAR(9) NOT NULL/*将某属性设置为主键之前，必须先将该属性设置为NOT NULL*/
ALTER TABLE STUDENT
ADD CONSTRAINT P1 PRIMARY KEY(SNO)
--2.	将数据库stu的表course的cno字段定义为主键，约束名称为cno_pk;
ALTER TABLE COURSE
ALTER COLUMN CNO CHAR(4) NOT NULL
ALTER TABLE COURSE 
ADD CONSTRAINT CNO_PK PRIMARY KEY(CNO)
--3.	为表course中的字段cname添加唯一值约束；
ALTER TABLE COURSE
ADD CONSTRAINT U1 UNIQUE(CNAME)
--4.	将数据库stu的表sc的sno及cno字段组合定义为主键，约束名称为sc_pk;
ALTER TABLE SC
ALTER COLUMN SNO CHAR(9) NOT NULL
ALTER TABLE SC
ALTER COLUMN CNO CHAR(4) NOT NULL
ALTER TABLE SC
ADD CONSTRAINT SC_PK PRIMARY KEY(SNO,CNO)
--5.	对于数据表sc的sno、cno字段定义为外码，使之与表student的主码sno及表course的主码cno对应，实现如下参照完整性：
--1)	删除student表中记录的同时删除sc表中与该记录sno字段值相同的记录；
--2)	修改student表某记录的sno时，若sc表中与该字段值对应的有若干条记录，则拒绝修改；
ALTER TABLE SC
ADD CONSTRAINT F1 FOREIGN KEY(SNO) REFERENCES STUDENT(SNO)
ON DELETE CASCADE
ON UPDATE NO ACTION 
--3)	修改course表cno字段值时，该字段在sc表中的对应值也应修改；
ALTER TABLE SC
ADD CONSTRAINT F2 FOREIGN KEY(CNO) REFERENCES COURSE(CNO)
ON UPDATE CASCADE

--4)	删除course表一条记录时，若该字段在在sc表中存在，则删除该字段对应的记录；

ALTER TABLE SC
ADD CONSTRAINT F3 FOREIGN KEY(CNO) REFERENCES COURSE(CNO)
ON DELETE CASCADE 

--5)	向sc表添加记录时，如果该记录的sno字段的值在student中不存在，则拒绝插入；
ALTER TABLE SC
ADD CONSTRAINT F4 FOREIGN KEY(SNO)  REFERENCES STUDENT(SNO)


--6.	定义check约束，要求学生学号sno必须为9位数字字符，且不能以0开头，第二三位皆为0；
ALTER TABLE STUDENT 
ADD CONSTRAINT C1 CHECK(SNO LIKE '[1-9]00[0-9][0-9][0-9][0-9][0-9][0-9]')
--7.	定义stu数据库中student表中学生年龄值在16-25范围内；
ALTER TABLE STUDENT 
ADD CONSTRAINT C2 CHECK(SAGE BETWEEN 16 AND 25)
--8.	定义stu数据库中student表中学生姓名长度在2-8之间；
ALTER TABLE STUDENT 
ADD CONSTRAINT C3 CHECK(LEN(SNAME) BETWEEN 2 AND 8)
--9.	定义stu数据库中student表中学生性别列中只能输入“男”或“女”；
ALTER TABLE STUDENT 
ADD CONSTRAINT C4 CHECK(SSEX IN ('男','女'))
--10.	定义stu数据库student表中学生年龄值默认值为20；
ALTER TABLE STUDENT 
ADD CONSTRAINT D_SAGE DEFAULT 20 FOR SAGE
--11.	修改student表学生的年龄值约束可以为15-30范围内；
ALTER TABLE STUDENT 
DROP CONSTRAINT C2;
ALTER TABLE STUDENT 
ADD CONSTRAINT C2 CHECK(SAGE BETWEEN 15 AND 30)
--12.	删除上述唯一值约束、外键约束及check约束；
ALTER TABLE COURSE
DROP CONSTRAINT U1 
ALTER TABLE STUDENT 
DROP CONSTRAINT C2
--13.	设计触发器实现如果一个学生转专业了，那么输出一条信息显示该学生各门课程的平均分。
USE STUDENT
GO
CREATE TRIGGER A1
ON STUDENT
FOR
UPDATE
AS 
IF UPDATE(SDEPT)
BEGIN
DECLARE @AVG NUMERIC(4,1),@SNO CHAR(9)
SELECT @SNO=(SELECT SNO FROM DELETED)
SELECT @AVG=(SELECT AVG(GRADE) FROM SC WHERE SNO=@SNO) 
PRINT @SNO+'各门课的平均成绩'+cast(@AVG as CHAR(5))
END
--测试
UPDATE STUDENT SET SDEPT='CS' WHERE SNO='200515008'/*只有修改sdept时，触发器才触发执行*/
UPDATE STUDENT SET SAGE=26 WHERE SNO='200515008'/*该语句只修改了学生的年龄，A1触发器并没有执行*/

--14.	设计触发器实现如果成绩被修改了20分以上，则输出提示信息“修改成绩超过20分，	请慎重”。
CREATE TRIGGER A2
ON SC
FOR UPDATE
AS
IF UPDATE(GRADE)
BEGIN
DECLARE @OLD INT
DECLARE @NEW INT
SELECT @OLD = GRADE FROM DELETED
SELECT @NEW = GRADE FROM INSERTED
IF abs(@NEW-@OLD)>=20
PRINT'修改成绩超过20分，请慎重'
END
--测试
update sc
set grade=grade+15
where sno='200515002' and cno='5'/*触发器没执行*/
update sc
set grade=grade+25
where sno='200515001' and cno='4'
--15. (1)在student表中增加一列total,表示学生选课总门数，初始值为0
--    定义一个触发器，实现如下完整性约束：
--    当向SC表插入选课记录时，自动更新student表对应学号的total值,考虑成批插入数据的情况。
ALTER TABLE student
ADD total SMALLINT DEFAULT 0
GO

--先将表中的现有数据的total值设置好:
UPDATE student
SET total = (
    SELECT COUNT(*) FROM SC
    WHERE Sno = student.sno
) GO
CREATE TRIGGER TRI_add_course 
ON SC 
FOR INSERT 
AS
    UPDATE student
        SET total = total + (SELECT COUNT(*) FROM INSERTED WHERE sno = Student.sno)
        WHERE sno IN( SELECT Sno FROM INSERTED )
INSERT SC(Sno,Cno) VALUES
    ('200515001',2),
    ('200515001',3),
    ('200515002',2)--测试
--(2)在student表中增加一列total,表示学生的总学分，初始值为0。定义一个触发器，实现有关学分的完整性约束：当向SC表插入一行选课记录时，若成绩大于等于60分，自动将该课程的学分累加到学生的总学分中。
create trigger tr_insert on sc
for insert
as
declare @sno char(9)
declare @credit int
declare @cno char(4)
declare @grade int
select @sno=sno,@cno=cno,@grade=grade
from inserted
if @grade>=60
begin
select @credit=credit from sc,course
where sc.cno=course.cno and sc.cno=@cno
update student set total=total+@credit
where sno=@sno
end
--测试
	insert into sc
	values('200515004','3',56)/*只在sc中插入一行*/
	insert into sc
	values('200515004','4',86)/*在sc中插入一行，student的总学分total增加*/
--16.设计一触发器，约束数据库系统课程的课容量为120。
use student
go
create trigger ex16
on sc
for insert
as 
	declare @count int,@kecheng varchar(20)
	select @count=count(*) from sc where cno=(select cno from inserted)
	select @kecheng=cname from course where cno=(select cno from inserted)
	if(@count>120)
		begin
			print '课程'+@kecheng+'人数已经达到课容量'
			rollback
		end
	else
		begin
			print '选课'+@kecheng+'成功'
		end
--测试
insert into sc(sno,cno)
	values('200515009','1')
--17．设有两个表：商品库存表（商品编号，商品名称，库存数量，库存单价，库存金额）；商品销售表（商品编号，商品名称，购货商号，销售数量，销售单价，销售金额）；设计一触发器实现如下业务规则：
--（1）保证在商品库存表中插入的数据，库存金额 = 库存数量 * 库存单价。
CREATE TABLE 商品销售表 
( 
商品编号 char(6)PRIMARY KEY,
商品名称 VARCHAR(40)  NOT NULL,  
购货商 VARCHAR(40) NULL,  
销售数量 INT NULL,
销售单价 MONEY NULL,  
销售金额 MONEY NULL  )  
CREATE TABLE 商品库存表
  (  商品编号 char(6)PRIMARY KEY,
商品名称 VARCHAR(40)  NOT NULL, 
库存数量 INT NULL,  
库存单价 MONEY NULL,  
库存金额 MONEY NULL  ) 
go
CREATE TRIGGER INSERT_商品库存表  
ON 商品库存表  
FOR INSERT 
 AS  
 UPDATE 商品库存表  
SET 库存金额 = 库存数量 * 库存单价  
WHERE 商品编号 IN (SELECT 商品编号 from INSERTED)  
go
--测试
INSERT INTO 商品库存表(商品编号,商品名称,库存数量,库存单价,库存金额) 
values('100000', '红塔山',100,12,1200), 
 ('100001','将军',100,22,NULL ), 
('100002' ,'中华',100,60,500 ), 
('100003','玉溪',0,30,0 )
go

--（2）如果销售的商品不存在库存或者库存为零，则返回提示信息。否则自动减少商品库存表中对应商品的库存数量和库存金额。
CREATE TRIGGER INSERT_商品销售表 
ON 商品销售表 
FOR INSERT 
AS 
BEGIN TRANSACTION 
--检查数据的合法性：销售的商品是否有库存，或者库存是否大于零 
IF NOT EXISTS ( 
SELECT 库存数量 
FROM 商品库存表 
WHERE 商品编号 IN (SELECT 商品编号 FROM INSERTED) 
) 
BEGIN 
--返回错误提示 
RAISERROR('错误！该商品不存在库存，不能销售！',16,1) 
--回滚事务 
ROLLBACK 
RETURN 
END 

IF EXISTS ( 
SELECT 库存数量 
FROM 商品库存表 
WHERE 商品编号 IN (SELECT 商品编号 FROM INSERTED) AND 
库存数量 <= 0 
) 
BEGIN 
--返回错误提示 
RAISERROR('错误！该商品库存小于等于0，不能销售!',16,1) --返回用户定义的错误信息
--回滚事务 
ROLLBACK 
RETURN 
END 

--对合法的数据进行处理 

--强制执行下列语句，保证业务规则 
UPDATE 商品销售表 
SET 销售金额 = 销售数量 * 销售单价 
WHERE 商品编号 IN (SELECT 商品编号 FROM INSERTED) 

DECLARE @商品编号 CHAR(6) 
SET @商品编号 = (SELECT 商品编号 FROM INSERTED) 

DECLARE @销售数量 MONEY 
SET @销售数量 = (SELECT 销售数量 FROM INSERTED) 

UPDATE 商品库存表 
SET 库存数量 = 库存数量 - @销售数量, 
库存金额 = (库存数量 - @销售数量)*库存单价 
WHERE 商品编号 = @商品编号 
COMMIT TRANSACTION 
GO 
--测试
INSERT INTO 商品销售表(商品编号,商品名称,购货商,销售数量,销售单价,销售金额) 
values('100000' ,'红塔山','利群',10,12,120)
INSERT INTO 商品销售表(商品编号,商品名称,购货商,销售数量,销售单价,销售金额) 
values('100001','将军','家家悦',10,22,1200)
INSERT INTO 商品销售表(商品编号,商品名称,购货商,销售数量,销售单价,销售金额) 
values('100004','红河','家家悦',10,22,220)

INSERT INTO 商品销售表(商品编号,商品名称,购货商,销售数量,销售单价,销售金额) 
values('100003','玉溪','家家悦',10,22,220)
--以下18题是为下一个实验做准备的
--18.创建借书表：lendt(bno（索书号）,sno（学号）,ldate（借阅日期）,rdate（应还日期），relend（是否续借）)
CREATE TABLE LENDT(
	BNO CHAR(9) NOT NULL,
	SNO CHAR(9) NOT NULL,
	LDATE DATETIME ,
	RDATE DATETIME,
	RELEND CHAR (2))

--请为该表增加四个约束条件：
--（1）增加主码约束（bno,sno）
ALTER TABLE LENDT
ADD CONSTRAINT PK PRIMARY KEY(BNO,SNO)
--（2）为借阅日期增加默认值约束，默认值为当前日期
ALTER TABLE LENDT
ADD CONSTRAINT C_GETDAY DEFAULT GETDATE() FOR LDATE
--（3）为应还日期增加默认值约束，默认值为当前日期+30天
ALTER TABLE LENDT
ADD CONSTRAINT C_ADDDAY DEFAULT DATEADD(DAY,30,GETDATE())for RDATE
--（4）为是否续借增加默认值约束，默认值为否
ALTER TABLE LENDT
ADD CONSTRAINT C_RELEND DEFAULT '否' FOR RELEND 
--19．建立教师表（教工编号，姓名，专业，职称，工资）和工资变化表（教工编号，原工资，新工资），
--设计触发器实现教授的工资不得低于4000元，如果低于4000元则自动改为4000元。
CREATE TABLE TEACHER(
	TNO CHAR(9) PRIMARY KEY,
	TNAME VARCHAR(20),
	ZY VARCHAR(20),
	ZC VARCHAR(20),
	SALARY INT);

CREATE TABLE SALARY_CHANGE(
	TNO CHAR(9),
	OLD_SALARY INT ,
	NEW_SALARY INT)

GO 
CREATE TRIGGER T1
ON TEACHER 
FOR INSERT,UPDATE
AS
BEGIN
	DECLARE @SA INT ,@JOB CHAR(20),@TNO CHAR(9)
	SELECT @JOB=ZC,@SA=SALARY,@TNO=TNO FROM INSERTED
	IF(@JOB='教授'AND @SA<4000)
	UPDATE TEACHER 
	SET SALARY=4000
	WHERE TNO=@TNO
END
--测试
insert into teacher values('200199801','丁源','计算机','教授',8500)/*正常执行,触发器不执行*/
insert into teacher values('200199802','王伟源','计算机','教授',3500)
--20.	使用第19题的两个表设计触发器实现如果员工的工资发生变化则向工资变化表插入一条记录，包含教工编号，原工资，新工资。
create trigger tri20 on teacher
after update
as
begin
declare @a char(9), @b int, @c int
select @a = tno, @b = salary from deleted
select @c = salary from inserted
if (@b<>@c) 
		insert into salary_change
		values(@a, @b, @c)
end
--测试
update teacher
set salary=salary+200 where tno='200199802'
