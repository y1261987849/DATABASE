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

--1.	��stu���ݿ���student���sno����Ϊ������
USE STU
go
ALTER TABLE STUDENT 
ALTER COLUMN SNO CHAR(9) NOT NULL/*��ĳ��������Ϊ����֮ǰ�������Ƚ�����������ΪNOT NULL*/
ALTER TABLE STUDENT
ADD CONSTRAINT P1 PRIMARY KEY(SNO)
--2.	�����ݿ�stu�ı�course��cno�ֶζ���Ϊ������Լ������Ϊcno_pk;
ALTER TABLE COURSE
ALTER COLUMN CNO CHAR(4) NOT NULL
ALTER TABLE COURSE 
ADD CONSTRAINT CNO_PK PRIMARY KEY(CNO)
--3.	Ϊ��course�е��ֶ�cname���ΨһֵԼ����
ALTER TABLE COURSE
ADD CONSTRAINT U1 UNIQUE(CNAME)
--4.	�����ݿ�stu�ı�sc��sno��cno�ֶ���϶���Ϊ������Լ������Ϊsc_pk;
ALTER TABLE SC
ALTER COLUMN SNO CHAR(9) NOT NULL
ALTER TABLE SC
ALTER COLUMN CNO CHAR(4) NOT NULL
ALTER TABLE SC
ADD CONSTRAINT SC_PK PRIMARY KEY(SNO,CNO)
--5.	�������ݱ�sc��sno��cno�ֶζ���Ϊ���룬ʹ֮���student������sno����course������cno��Ӧ��ʵ�����²��������ԣ�
--1)	ɾ��student���м�¼��ͬʱɾ��sc������ü�¼sno�ֶ�ֵ��ͬ�ļ�¼��
--2)	�޸�student��ĳ��¼��snoʱ����sc��������ֶ�ֵ��Ӧ������������¼����ܾ��޸ģ�
ALTER TABLE SC
ADD CONSTRAINT F1 FOREIGN KEY(SNO) REFERENCES STUDENT(SNO)
ON DELETE CASCADE
ON UPDATE NO ACTION 
--3)	�޸�course��cno�ֶ�ֵʱ�����ֶ���sc���еĶ�ӦֵҲӦ�޸ģ�
ALTER TABLE SC
ADD CONSTRAINT F2 FOREIGN KEY(CNO) REFERENCES COURSE(CNO)
ON UPDATE CASCADE

--4)	ɾ��course��һ����¼ʱ�������ֶ�����sc���д��ڣ���ɾ�����ֶζ�Ӧ�ļ�¼��

ALTER TABLE SC
ADD CONSTRAINT F3 FOREIGN KEY(CNO) REFERENCES COURSE(CNO)
ON DELETE CASCADE 

--5)	��sc����Ӽ�¼ʱ������ü�¼��sno�ֶε�ֵ��student�в����ڣ���ܾ����룻
ALTER TABLE SC
ADD CONSTRAINT F4 FOREIGN KEY(SNO)  REFERENCES STUDENT(SNO)


--6.	����checkԼ����Ҫ��ѧ��ѧ��sno����Ϊ9λ�����ַ����Ҳ�����0��ͷ���ڶ���λ��Ϊ0��
ALTER TABLE STUDENT 
ADD CONSTRAINT C1 CHECK(SNO LIKE '[1-9]00[0-9][0-9][0-9][0-9][0-9][0-9]')
--7.	����stu���ݿ���student����ѧ������ֵ��16-25��Χ�ڣ�
ALTER TABLE STUDENT 
ADD CONSTRAINT C2 CHECK(SAGE BETWEEN 16 AND 25)
--8.	����stu���ݿ���student����ѧ������������2-8֮�䣻
ALTER TABLE STUDENT 
ADD CONSTRAINT C3 CHECK(LEN(SNAME) BETWEEN 2 AND 8)
--9.	����stu���ݿ���student����ѧ���Ա�����ֻ�����롰�С���Ů����
ALTER TABLE STUDENT 
ADD CONSTRAINT C4 CHECK(SSEX IN ('��','Ů'))
--10.	����stu���ݿ�student����ѧ������ֵĬ��ֵΪ20��
ALTER TABLE STUDENT 
ADD CONSTRAINT D_SAGE DEFAULT 20 FOR SAGE
--11.	�޸�student��ѧ��������ֵԼ������Ϊ15-30��Χ�ڣ�
ALTER TABLE STUDENT 
DROP CONSTRAINT C2;
ALTER TABLE STUDENT 
ADD CONSTRAINT C2 CHECK(SAGE BETWEEN 15 AND 30)
--12.	ɾ������ΨһֵԼ�������Լ����checkԼ����
ALTER TABLE COURSE
DROP CONSTRAINT U1 
ALTER TABLE STUDENT 
DROP CONSTRAINT C2
--13.	��ƴ�����ʵ�����һ��ѧ��תרҵ�ˣ���ô���һ����Ϣ��ʾ��ѧ�����ſγ̵�ƽ���֡�
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
PRINT @SNO+'���ſε�ƽ���ɼ�'+cast(@AVG as CHAR(5))
END
--����
UPDATE STUDENT SET SDEPT='CS' WHERE SNO='200515008'/*ֻ���޸�sdeptʱ���������Ŵ���ִ��*/
UPDATE STUDENT SET SAGE=26 WHERE SNO='200515008'/*�����ֻ�޸���ѧ�������䣬A1��������û��ִ��*/

--14.	��ƴ�����ʵ������ɼ����޸���20�����ϣ��������ʾ��Ϣ���޸ĳɼ�����20�֣�	�����ء���
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
PRINT'�޸ĳɼ�����20�֣�������'
END
--����
update sc
set grade=grade+15
where sno='200515002' and cno='5'/*������ûִ��*/
update sc
set grade=grade+25
where sno='200515001' and cno='4'
--15. (1)��student��������һ��total,��ʾѧ��ѡ������������ʼֵΪ0
--    ����һ����������ʵ������������Լ����
--    ����SC�����ѡ�μ�¼ʱ���Զ�����student���Ӧѧ�ŵ�totalֵ,���ǳ����������ݵ������
ALTER TABLE student
ADD total SMALLINT DEFAULT 0
GO

--�Ƚ����е��������ݵ�totalֵ���ú�:
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
    ('200515002',2)--����
--(2)��student��������һ��total,��ʾѧ������ѧ�֣���ʼֵΪ0������һ����������ʵ���й�ѧ�ֵ�������Լ��������SC�����һ��ѡ�μ�¼ʱ�����ɼ����ڵ���60�֣��Զ����ÿγ̵�ѧ���ۼӵ�ѧ������ѧ���С�
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
--����
	insert into sc
	values('200515004','3',56)/*ֻ��sc�в���һ��*/
	insert into sc
	values('200515004','4',86)/*��sc�в���һ�У�student����ѧ��total����*/
--16.���һ��������Լ�����ݿ�ϵͳ�γ̵Ŀ�����Ϊ120��
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
			print '�γ�'+@kecheng+'�����Ѿ��ﵽ������'
			rollback
		end
	else
		begin
			print 'ѡ��'+@kecheng+'�ɹ�'
		end
--����
insert into sc(sno,cno)
	values('200515009','1')
--17��������������Ʒ������Ʒ��ţ���Ʒ���ƣ������������浥�ۣ���������Ʒ���۱���Ʒ��ţ���Ʒ���ƣ������̺ţ��������������۵��ۣ����۽������һ������ʵ������ҵ�����
--��1����֤����Ʒ�����в�������ݣ������ = ������� * ��浥�ۡ�
CREATE TABLE ��Ʒ���۱� 
( 
��Ʒ��� char(6)PRIMARY KEY,
��Ʒ���� VARCHAR(40)  NOT NULL,  
������ VARCHAR(40) NULL,  
�������� INT NULL,
���۵��� MONEY NULL,  
���۽�� MONEY NULL  )  
CREATE TABLE ��Ʒ����
  (  ��Ʒ��� char(6)PRIMARY KEY,
��Ʒ���� VARCHAR(40)  NOT NULL, 
������� INT NULL,  
��浥�� MONEY NULL,  
����� MONEY NULL  ) 
go
CREATE TRIGGER INSERT_��Ʒ����  
ON ��Ʒ����  
FOR INSERT 
 AS  
 UPDATE ��Ʒ����  
SET ����� = ������� * ��浥��  
WHERE ��Ʒ��� IN (SELECT ��Ʒ��� from INSERTED)  
go
--����
INSERT INTO ��Ʒ����(��Ʒ���,��Ʒ����,�������,��浥��,�����) 
values('100000', '����ɽ',100,12,1200), 
 ('100001','����',100,22,NULL ), 
('100002' ,'�л�',100,60,500 ), 
('100003','��Ϫ',0,30,0 )
go

--��2��������۵���Ʒ�����ڿ����߿��Ϊ�㣬�򷵻���ʾ��Ϣ�������Զ�������Ʒ�����ж�Ӧ��Ʒ�Ŀ�������Ϳ���
CREATE TRIGGER INSERT_��Ʒ���۱� 
ON ��Ʒ���۱� 
FOR INSERT 
AS 
BEGIN TRANSACTION 
--������ݵĺϷ��ԣ����۵���Ʒ�Ƿ��п�棬���߿���Ƿ������ 
IF NOT EXISTS ( 
SELECT ������� 
FROM ��Ʒ���� 
WHERE ��Ʒ��� IN (SELECT ��Ʒ��� FROM INSERTED) 
) 
BEGIN 
--���ش�����ʾ 
RAISERROR('���󣡸���Ʒ�����ڿ�棬�������ۣ�',16,1) 
--�ع����� 
ROLLBACK 
RETURN 
END 

IF EXISTS ( 
SELECT ������� 
FROM ��Ʒ���� 
WHERE ��Ʒ��� IN (SELECT ��Ʒ��� FROM INSERTED) AND 
������� <= 0 
) 
BEGIN 
--���ش�����ʾ 
RAISERROR('���󣡸���Ʒ���С�ڵ���0����������!',16,1) --�����û�����Ĵ�����Ϣ
--�ع����� 
ROLLBACK 
RETURN 
END 

--�ԺϷ������ݽ��д��� 

--ǿ��ִ��������䣬��֤ҵ����� 
UPDATE ��Ʒ���۱� 
SET ���۽�� = �������� * ���۵��� 
WHERE ��Ʒ��� IN (SELECT ��Ʒ��� FROM INSERTED) 

DECLARE @��Ʒ��� CHAR(6) 
SET @��Ʒ��� = (SELECT ��Ʒ��� FROM INSERTED) 

DECLARE @�������� MONEY 
SET @�������� = (SELECT �������� FROM INSERTED) 

UPDATE ��Ʒ���� 
SET ������� = ������� - @��������, 
����� = (������� - @��������)*��浥�� 
WHERE ��Ʒ��� = @��Ʒ��� 
COMMIT TRANSACTION 
GO 
--����
INSERT INTO ��Ʒ���۱�(��Ʒ���,��Ʒ����,������,��������,���۵���,���۽��) 
values('100000' ,'����ɽ','��Ⱥ',10,12,120)
INSERT INTO ��Ʒ���۱�(��Ʒ���,��Ʒ����,������,��������,���۵���,���۽��) 
values('100001','����','�Ҽ���',10,22,1200)
INSERT INTO ��Ʒ���۱�(��Ʒ���,��Ʒ����,������,��������,���۵���,���۽��) 
values('100004','���','�Ҽ���',10,22,220)

INSERT INTO ��Ʒ���۱�(��Ʒ���,��Ʒ����,������,��������,���۵���,���۽��) 
values('100003','��Ϫ','�Ҽ���',10,22,220)
--����18����Ϊ��һ��ʵ����׼����
--18.���������lendt(bno������ţ�,sno��ѧ�ţ�,ldate���������ڣ�,rdate��Ӧ�����ڣ���relend���Ƿ����裩)
CREATE TABLE LENDT(
	BNO CHAR(9) NOT NULL,
	SNO CHAR(9) NOT NULL,
	LDATE DATETIME ,
	RDATE DATETIME,
	RELEND CHAR (2))

--��Ϊ�ñ������ĸ�Լ��������
--��1����������Լ����bno,sno��
ALTER TABLE LENDT
ADD CONSTRAINT PK PRIMARY KEY(BNO,SNO)
--��2��Ϊ������������Ĭ��ֵԼ����Ĭ��ֵΪ��ǰ����
ALTER TABLE LENDT
ADD CONSTRAINT C_GETDAY DEFAULT GETDATE() FOR LDATE
--��3��ΪӦ����������Ĭ��ֵԼ����Ĭ��ֵΪ��ǰ����+30��
ALTER TABLE LENDT
ADD CONSTRAINT C_ADDDAY DEFAULT DATEADD(DAY,30,GETDATE())for RDATE
--��4��Ϊ�Ƿ���������Ĭ��ֵԼ����Ĭ��ֵΪ��
ALTER TABLE LENDT
ADD CONSTRAINT C_RELEND DEFAULT '��' FOR RELEND 
--19��������ʦ���̹���ţ�������רҵ��ְ�ƣ����ʣ��͹��ʱ仯���̹���ţ�ԭ���ʣ��¹��ʣ���
--��ƴ�����ʵ�ֽ��ڵĹ��ʲ��õ���4000Ԫ���������4000Ԫ���Զ���Ϊ4000Ԫ��
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
	IF(@JOB='����'AND @SA<4000)
	UPDATE TEACHER 
	SET SALARY=4000
	WHERE TNO=@TNO
END
--����
insert into teacher values('200199801','��Դ','�����','����',8500)/*����ִ��,��������ִ��*/
insert into teacher values('200199802','��ΰԴ','�����','����',3500)
--20.	ʹ�õ�19�����������ƴ�����ʵ�����Ա���Ĺ��ʷ����仯�����ʱ仯�����һ����¼�������̹���ţ�ԭ���ʣ��¹��ʡ�
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
--����
update teacher
set salary=salary+200 where tno='200199802'
