·���ҵĴ𰸣�

������������xsgl������������

--��xs���������֤���������У�Ҫ����18λ���ַ�����

Alter table xs add ���֤���� char(18)

Go



--1.��ѯ��ֱ�����пεĿγ̵Ŀκţ����������пκš�

select �γ̺�,�γ���,���пκ� from kc

where ���пκ� is not null

Go



--2.��ѯ���пκ��ǡ�J001���ſγ̵ĿκźͿ���

select �γ̺�,�γ��� from kc

where ���пκ� = 'J001'

Go



--3.��ѯ���е����繤��ϵ����ţ�����ͬѧ��ѧ�ź�����

select ѧ��,���� from xs

where (���� like '��%' 

 or ���� like '��%'

 or ���� like '��%')

 and רҵ = '���繤��'

Go



--4.��ѯ�������繤�̺���Ϣ����רҵѧϰ��ѧ����ѧ�ź�������ϵ�𣬲��Բ�ѯ�������רҵ�������ѧ�ŵĽ�������

select ѧ��,����,רҵ from xs

where רҵ not in('���繤��','��Ϣ����')

order by רҵ asc, ѧ�� desc

Go



--5.��ѯÿ�ſβ������ѧ������������ʾ�κź�����

select �γ̺�,count(�ɼ�) as ���������� from cj

where �ɼ� < 60

group by �γ̺�

Go



--6.��ѯ���䲻��30-35֮������繤��ϵ��ѧ����ѧ�ţ�����������

select ѧ��,����, datediff(yy,����ʱ��,getdate())as ���� from xs

where datediff(yy,����ʱ��,getdate()) > 35

 or datediff(yy,����ʱ��,getdate()) < 30

Go



--7.��ѯû��ѡ�ޡ�J001���ſγ̵�ѧ����ѧ�ţ�ע��ȥ���ظ���Ԫ�飩

select distinct ѧ�� from cj

except 

select distinct ѧ�� from cj

where �γ̺� = 'J001'

Go



--8.��ѯÿ��ѧ����ѧ�ţ�������������ݣ�����������������Ϊchusheng 

select ѧ��,����,year(����ʱ��) as chusheng from xs

Go



--9.��ѯÿ��ѧ����ѧ�ţ������ͳ������ڣ��������ڸ������֤�����ѯ��

select ѧ��,����,convert(date,SUBSTRING(���֤����,7,8) )as ������� from xs

Go



--10.��ѯѡ��J001�γ̳ɼ�������һ��ͬѧ��ѧ�źͳɼ�

select top(1) ѧ��,�ɼ� from cj

where �γ̺� = 'J001'

order by �ɼ� desc

Go



--11.��ѯ���������к��С��������ߡ�������ͬѧ��ѧ�ţ�����

select ѧ��, ���� from xs

where ���� like '%[��,��]%'

Go



--12.��ѯ��Ϣ����רҵ���䳬��20���ѧ��������

select count(*) as ���� from xs

where רҵ = '��Ϣ����' and datediff(yy,����ʱ��,getdate()) >= 20

Go



--13.��ѯƽ���ɼ�����80�ֵĿγ̵Ŀγ̺ź�ƽ���ɼ�

select �γ̺�, avg(�ɼ�)as ƽ���� from cj

group by �γ̺�

having avg(�ɼ�) >80

Go



--14.��ѯÿ��רҵ�������ŵ�����

select רҵ, count(*) as �������� from xs

where ���� like '��%'

group by רҵ

Go
select  b.רҵ,count(a.ѧ��)
from xs a right join xs b 
on  a.ѧ�� = b.ѧ�� and a.���� like '��%'
where b.רҵ is not null
group by b.רҵ   


--15.��ѯ�������ϵ�����������û�и��գ�

select distinct left(����,1) as ����, count(*)from xs

group by left(����,1)

Go



--16.��ѯѡ�޿γ̳���5�ŵ�ѧ����ѧ�ź�ѡ���������Լ�ƽ���ɼ�

select ѧ��, count(�γ̺�) as ѡ������, avg(�ɼ�) as ƽ���ɼ� from cj

group by ѧ��

having count(�γ̺�)>=5

Go



--17.��ѯѡ�ޡ�J001���γ̵ĳɼ�����ǰ���ѧ����ѧ�źͳɼ�

select top(5) ѧ��, �ɼ� from cj 

where �γ̺� = 'J001'

order by �ɼ� desc

Go



--18.��ѯÿ��ѧ������ͷֺ�ѡ������

select ѧ��, min(�ɼ�) as ��ͷ�, count(�γ̺�)as ѡ������ from cj

group by ѧ��

Go



--19.��ѯ����רҵ�����Ա������

select רҵ, 

 sum(case �Ա� when '��' then 1 else 0 end) as ������,

 sum(case �Ա� when 'Ů' then 1 else 0 end) as Ů���� 

from xs

group by רҵ

Go
select  רҵ,�Ա�,count(*) ����
from xs
group by  רҵ,�Ա�


--20.��ѯ����רҵ����������

select רҵ,count(�Ա�) as �������� from xs

where �Ա� = '��'

group by רҵ

Go



--21.�г��ж������Ͽγ̣������ţ��������ѧ����ѧ�ż���ѧ����ƽ���ɼ���

select ѧ��,avg(�ɼ�) from cj

group by ѧ��

having sum(case when �ɼ� < 60 then 1 else 0 end) >=2

Go



--22.��ʾѧ�ŵ���λ���ߵ���λ��1��2��3��4����9��ѧ����ѧ�š��������Ա����估רҵ��

select ѧ��,����,�Ա�,datediff(yy,����ʱ��,getdate()) as ����,רҵ from xs

where 

SUBSTRING(ѧ��,5,1) in('1','2','3','4','9')

or SUBSTRING(ѧ��,6,1) in('1','2','3','4','9')

Go



--23.��ѯѡ����A001��A002�γ̵�ѧ����ѧ�ţ��γ̺ţ��ɼ���ʹ�����ӣ���

select *

from cj

where cj.ѧ�� in(

select s1.ѧ��

from cj s1, cj s2

where s1.ѧ�� = s2.ѧ�� and s1.�γ̺� = 'A001' and s2.�γ̺� = 'A002');

select *

from cj

where cj.ѧ�� in(

select s1.ѧ��

from cj s1

where s1.�γ̺� = 'A001' and 
     s1.ѧ�� in(
	 select ѧ��
	 from cj
	 where �γ̺� = 'A002'));


--24.��ѯѡ����A001����A002����J001����J002�γ̵�ѧ����ѧ�źͿγ̺�

select ѧ��, �γ̺� from cj

where

 �γ̺� in('A001','A002', 'J001', 'J002')

Go



--25.��ѯ����Ϊ�����ֵĲ�ͬ���ϵ�������������ϣ�������

select distinct left(����,1) as ����, count(*)from xs

where len(����) = 2

group by left(����,1)

Go



--26.��ѯѡ���˸�������Ӣ���ѧ����ѧ�ź�����

select distinct xs.ѧ��,���� from xs,kc,cj

where xs.ѧ�� = cj.ѧ��

 and cj.�γ̺� =kc.�γ̺�

 and �γ��� in('��ѧ','Ӣ��')

Go



--27.��ѯû��ѡ�ε�ѧ����ѧ�ź�����

select distinct ѧ��, ����  from xs

where ѧ�� not in(

select ѧ�� from cj)

Go
select xs.ѧ�� ,xs.���� 
from xs left join cj
on xs.ѧ�� =cj.ѧ�� 
where cj.�γ̺�  is null



--28.��ѯÿ��ѧ����ѧ�ţ�������ѡ��������ƽ����

select /*distinct*/ xs.ѧ��,����, count(cj.�γ̺�) as ѡ������, avg(cj.�ɼ�) as ƽ���� from xs, cj

where xs.ѧ�� = cj.ѧ��

group by xs.ѧ��,xs.����

Go



--29.��ѯѡ����������5�˵Ŀγ̵Ŀγ̺ţ��γ�����ѡ��������ƽ����

select cj.�γ̺�,�γ���, count(ѧ��) as ѡ������, avg(�ɼ�) as ƽ���� from cj,kc

where kc.�γ̺� = cj.�γ̺�

group by cj.�γ̺�,�γ���

Go



--30.��ѯ�����ϵѡ���ݿ���߷�

select max(�ɼ�) as ��߷� from xs,cj,kc

where xs.ѧ�� = cj.ѧ�� 

 and cj.�γ̺� = kc.�γ̺�

 and �γ��� = '���ݿ�SQL Server'

 and רҵ = '�����'

Go

������������SPJ������������

--1.��Ӧ����J1����Ĺ�Ӧ�̺���SNO

select distinct SNO from SPJ

where JNO = 'J1'

Go



--2.���ѯÿ������ʹ�ò�ͬ��Ӧ�̵�����ĸ���

select JNO,SNO,sum(QTY) from SPJ

group by JNO, SNO

order by JNO asc

Go



--3.��Ӧ����ʹ�����P3��������200�Ĺ��̺�JNO

select spj.jno from SPJ

where PNO = 'P3'

 group by jno
 having sum(qty)>200

Go



--4.����ɫΪ��ɫ����ɫ�����������ź�����

select PNO, PNAME from P

where COLOR in('��','��')

Go



--5.��ʹ�����������200-400֮��Ĺ��̺�

select JNO,sum(QTY) from SPJ

group by JNO

having sum(QTY) between 200  and 400

Go



--6.��ѯÿ�����������ţ��Լ�ʹ�ø�����Ĺ�������

select  SPJ.PNO, count(distinct JNO) from P left join SPJ

on P.PNO = SPJ.PNO

group by SPJ.PNO

Go