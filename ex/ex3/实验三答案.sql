--һ��	��xsgl���ݿ�������²���
use xsgl
--1.	��ѯû��ѡ��Ӣ���ѧ����ѧ�ţ������Ϳγ̺ţ��γ������ɼ�
select  xs.ѧ��,����,kc.�γ̺�,�γ���,�ɼ�
from xs left join cj
on xs.ѧ��=cj.ѧ��  left join kc
on  kc.�γ̺�=cj.�γ̺� 
where not exists
(select *
 from cj c1,kc k1
 where k1.�γ̺�=c1.�γ̺� and c1.ѧ��=cj.ѧ�� and k1.�γ���='Ӣ��')

 select  xs.ѧ��,����,kc.�γ̺�,�γ���,�ɼ�
from xs left join cj
on xs.ѧ��=cj.ѧ��  left join kc
on  kc.�γ̺�=cj.�γ̺� 
where xs.ѧ�� not in 
(select cj.ѧ��
 from cj ,kc 
 where kc.�γ̺�=cj.�γ̺�  and kc.�γ���='Ӣ��')

--2.	��ѯӢ��ɼ�����Ӣ���ƽ���ɼ���ѧ����ѧ�ţ��������ɼ�
select xs.ѧ��,����,�ɼ�
from xs,cj,kc
where xs.ѧ��=cj.ѧ�� and cj.�γ̺�=kc.�γ̺� and �γ���='Ӣ��' and �ɼ�> (select avg(�ɼ�) from cj,kc where cj.�γ̺�=kc.�γ̺� and �γ���='Ӣ��' )
--3.	��ѯѡ����Ӣ��͸�����ѧ����ѧ�ź�������Ҫ��ʹ�����ַ���ʵ�֣�
--��һ   
select ѧ��,����
from xs
where ѧ�� in(select ѧ�� from cj,kc where cj.�γ̺�=kc.�γ̺� and �γ���='Ӣ��') and 
ѧ�� in(select ѧ�� from cj,kc where cj.�γ̺�=kc.�γ̺� and �γ���='��ѧ')

--����               ������
select ѧ��,����     
from xs
where not exists(
select *
from kc k1
where  (�γ���='Ӣ��' or �γ���= '��ѧ') and not exists(         
select * 
from cj c1
where xs.ѧ��=c1.ѧ�� and k1.�γ̺�=c1.�γ̺� ))
--������
select xs.ѧ��,xs.����

from xs,cj,kc

where xs.ѧ�� = cj.ѧ�� and cj.�γ̺� = kc.�γ̺� and kc.�γ��� = 'Ӣ��'

 and xs.ѧ�� in

 (

 select cj.ѧ��

 from cj,kc

 where cj.�γ̺� = kc.�γ̺� and kc.�γ��� = '��ѧ'

 )
--����   ��������  
select xs.ѧ��,xs.����

from xs,cj cj1,cj cj2,kc kc1,kc kc2

where cj1.ѧ�� = cj2.ѧ�� and xs.ѧ�� = cj1.ѧ�� and cj1.�γ̺� = kc1.�γ̺� and cj2.�γ̺� = kc2.�γ̺�

 and kc1.�γ��� = '��ѧ' and kc2.�γ��� = 'Ӣ��'

--4.	��ѯû��ѡ�޳�����ѡ�޵�ȫ���γ̵�ѧ��������
select ����
from xs
where not exists(
select *
from cj c1,xs x1        --xs.ѧ��=cj.ѧ��
where c1.ѧ��=x1.ѧ�� and ����='����'and  exists(
 select *
 from cj
 where xs.ѧ��=cj.ѧ�� and cj.�γ̺�=c1.�γ̺� 
)
)
--5.	��ѯÿ��רҵ���䳬����רҵƽ�������ѧ����������רҵ
select ����,רҵ
from xs
where datediff(yy,����ʱ��,getdate())>
(select avg(datediff(yy,����ʱ��,getdate())) from xs x1 where x1.רҵ=xs.רҵ)
--6.	��ѯÿ��רҵÿ�ſγ̵�רҵ���γ̺ţ��γ�����ѡ��������ƽ���ֺ���߷�
select רҵ,cj.�γ̺�,�γ���,count(*) ѡ������,avg(�ɼ�) ƽ����,max(�ɼ�) ��߷�
from xs,cj,kc
where xs.ѧ��=cj.ѧ�� and cj.�γ̺�=kc.�γ̺� 
group by רҵ, cj.�γ̺�,�γ���
--7.	��ѯÿ��ѧ��ȡ����߷ֵĿγ̵Ŀγ̺ţ��γ����ͳɼ�
select xs.ѧ��,cj.�γ̺�, �γ���, �ɼ�
from xs,cj,kc
where xs.ѧ��=cj.ѧ�� and cj.�γ̺�=kc.�γ̺� and �ɼ�>=all(select �ɼ� from cj c1 where  c1.ѧ��=cj.ѧ��  )

SELECT XS1.����,KC1.�γ̺�,�γ���,�ɼ�
FROM xs XS1,cj CJ1,kc KC1
WHERE KC1.�γ̺� = CJ1.�γ̺� AND XS1.ѧ�� = CJ1.ѧ��
AND CJ1.�ɼ� >=(SELECT  MAX(�ɼ�) ��߷�
                FROM cj CJ2
                WHERE XS1.ѧ�� = CJ2.ѧ��
                )
--8.	��ѯÿ��רҵ������ߵ�ѧ����ѧ�ţ�������רҵ������
select ѧ��,����,רҵ,datediff(yy,����ʱ��,getdate()) ����
from xs
where datediff(yy,����ʱ��,getdate())>=all(select datediff(yy,����ʱ��,getdate()) from xs x1 where x1.רҵ=xs.רҵ)
--9.	��ѯû��ѡ�����ݽṹ�Ͳ���ϵͳ��ѧ����ѧ�ź���������ʹ�ô�������ʵ�֣�
select ѧ��,����
from xs
where not exists(
select *
from cj,kc
where   cj.�γ̺�=kc.�γ̺�  and  xs.ѧ��=cj.ѧ�� and (�γ���='���ݽṹ' or �γ���='����ϵͳ' ))

select ѧ��,����
from xs
where xs.ѧ�� not in(
select cj.ѧ��
from cj,kc
where   cj.�γ̺�=kc.�γ̺�   and (�γ���='���ݽṹ' or �γ���='����ϵͳ' ))
--10.	��ѯ���繤��רҵ������С��ѧ����ѧ�ź�����
select ѧ��,����
from xs
where רҵ='���繤��' 
and  datediff(yy,����ʱ��,getdate()) =
(select top 1 datediff(yy,����ʱ��,getdate())
from xs
where רҵ='���繤��' 
order by  datediff(yy,����ʱ��,getdate()))
--11.	��ѯѡ����������5�˵Ŀγ̵Ŀγ̺ţ��γ����ͳɼ�
select cj.�γ̺�,�γ���,�ɼ�
from cj,kc
where cj.�γ̺�=kc.�γ̺� and (select count(*) from cj c1 where cj.�γ̺�=c1.�γ̺� )>5;

select kc.�γ̺�,kc.�γ���,cj.�ɼ�

from kc,cj

where kc.�γ̺� = cj.�γ̺� 

 and kc.�γ̺� in

 (

 select cj.�γ̺�

 from cj

 group by cj.�γ̺�

 having count(cj.ѧ��)>5

 )
--12.	��ѯѡ������Ϣ����רҵ����ѧ��ѡ�޵�ȫ���γ̵�ѧ����ѧ�ź�����
select ѧ��,����
from xs
where not exists(
select *
from xs x1,cj
where x1.ѧ��=cj.ѧ�� and רҵ='��Ϣ����' and  not exists(
select *
from cj c1
where xs.ѧ��=c1.ѧ�� and c1.�γ̺�=cj.�γ̺�))
--13.	ʹ�ô�������ʵ�ֲ�ѯû�б�ѧ��ѡ�޵Ŀγ̵Ŀγ̺źͿγ���
select �γ̺�,�γ���
from kc
where   not exists(
select *
from cj
where kc.�γ̺�=cj.�γ̺�)
--14.	��ѯѡ����������ѡ���������ٵĿγ̵Ŀγ̺ţ��γ���������
select  kc.�γ̺�,�γ���,count(*)����
from kc,cj
where kc.�γ̺�=cj.�γ̺�  
group by kc.�γ̺�,�γ���
having count(*)=(select  top 1 count(*)
from kc,cj
where kc.�γ̺�=cj.�γ̺�  
group by kc.�γ̺�,�γ���
order by count(*)  desc)
or 
count(*)=(select  top 1 count(*)
from kc,cj
where kc.�γ̺�=cj.�γ̺�  
group by kc.�γ̺�,�γ���
order by count(*)  asc)
--15.	��ѯѡ��Ӣ��ĳɼ�����Ӣ��γ̵�ƽ���ɼ���ѧ����ѧ�ţ������ͳɼ�
select xs.ѧ��,����,�ɼ�
from xs,cj,kc
where xs.ѧ��=cj.ѧ�� and cj.�γ̺�=kc.�γ̺� and �γ���='Ӣ��' and �ɼ�> (select avg(�ɼ�) from cj,kc where cj.�γ̺�=kc.�γ̺� and �γ���='Ӣ��' )
--16.	��ѯ���ſ��гɼ���߷ֵ�ѧ����ѧ�ţ��������γ̺ţ��γ���������
select xs.ѧ��,����,cj.�γ̺�,�γ���,�ɼ� ����
from xs,cj,kc
where xs.ѧ��=cj.ѧ�� and cj.�γ̺�=kc.�γ̺� and �ɼ�>=all(select �ɼ� from cj c1 where c1.�γ̺�=cj.�γ̺�)
--17.	��ѯÿ�ſ��гɼ����ڸÿγ̵�ƽ���ɼ���ѧ�ţ��γ̺ţ��ɼ�
select ѧ��,�γ̺�,�ɼ�
from cj
where �ɼ�<(select avg(�ɼ�) from cj c1 where cj.�γ̺�=c1.�γ̺�)
--18.	��ѯ����רҵÿ�ſγ�ȡ����߷ֵ�ѧ����ѧ�ţ�������רҵ���γ̺ţ��γ������ɼ�
select xs.ѧ��,����,רҵ,cj.�γ̺�,�γ���,�ɼ�
from xs,cj,kc
where xs.ѧ��=cj.ѧ�� and cj.�γ̺�=kc.�γ̺� and �ɼ�>=
all(select �ɼ� from cj c1 ,xs x1 where  x1.ѧ��=c1.ѧ�� and  c1.�γ̺�=cj.�γ̺� and x1.רҵ=xs.רҵ )
--19.	��ѯû��ѡ��ȫ���γ̵�ѧ����ѧ�ź�������
select ѧ��,����
from xs
where   exists(
select *
from kc
where  not exists(
select *
from cj
where xs.ѧ��=cj.ѧ�� and cj.�γ̺�=kc.�γ̺�))

select xs.ѧ�� ,xs.���� 
from xs left join cj
on xs.ѧ��=cj.ѧ��
group by xs.ѧ�� ,xs.����
having count(cj.�γ̺� )<(select count(*) from kc)
--20.	��ѯû�б�ȫ��ѧ����ѡ���˵Ŀγ̵Ŀγ̺źͿγ���
select �γ̺�,�γ���
from kc
where  exists(
select *
from xs
where not exists(
select *
from cj
where xs.ѧ��=cj.ѧ�� and cj.�γ̺�=kc.�γ̺�))
--21.	��ѯѡ�������������繤��רҵĳ��ѧ����ѡ��������ѧ����ѧ�ţ�������ѡ������
select xs.ѧ��,����,count(*) ѡ������
from xs,cj
where xs.ѧ��=cj.ѧ�� 
group by xs.ѧ��,����
having count(*)<=any(select count(*) from xs x1,cj c1
where x1.ѧ��=c1.ѧ�� and רҵ='���繤��' group by x1.ѧ��,����)
--22.	��ѯѡ����������Ӣ���ѡ�������Ŀγ̵Ŀγ̺ţ��γ���������
select kc.�γ̺�,�γ���,count(*)����
from kc,cj
where kc.�γ̺�=cj.�γ̺� 
group by kc.�γ̺�,�γ���
having count(*)>(select count(*)from cj c1,kc k1
where  c1.�γ̺�=k1.�γ̺� and �γ���='Ӣ��')
--23.	��ѯ�ɼ�����ѡ��Ӣ���ĳ��ѧ���ĳɼ���ѧ����ѧ�ţ��������γ̺ţ��γ������ɼ�
select xs.ѧ��,����,kc.�γ̺�,�γ���,�ɼ�
from xs,cj,kc
where xs.ѧ��=cj.ѧ�� and cj.�γ̺�=kc.�γ̺� and �ɼ�>any(
select �ɼ�
from cj c1,kc k1
where  c1.�γ̺�=k1.�γ̺� and �γ���='Ӣ��')
--24.	��ѯѡ���˳����ͷ�����ͬѧ��ѡ�޵�ȫ���γ̵�ѧ����ѧ�ź�����
select ѧ��,����
from xs
where not exists(
select *
from xs x1,cj
where x1.ѧ��=cj.ѧ�� and (����='����' or ����='������') and not exists(
select *
from cj c1
where c1.ѧ��=xs.ѧ�� and c1.�γ̺�=cj.�γ̺�))
--25.	��ѯѡ��ѧ��������ѡ��Ӣ���ȫ��ѧ���Ŀγ̵Ŀγ̺źͿγ���
select �γ̺�,�γ���
from kc
where not exists(
select *
from cj,kc k1
where cj.�γ̺�=k1.�γ��� and �γ���='Ӣ��' and not exists(
select * 
from cj c1
where kc.�γ̺�=c1.�γ̺� and c1.ѧ��=cj.ѧ�� ))


--��������˹�����ݿ����һ�²�ѯ
use Northwind
--26.	��ѯÿ�����������Ʒ���������ܽ���������ţ��������ܽ��  
select OrderID,sum(Quantity) ����,sum(UnitPrice*Quantity*(1-discount)) �ܽ��
from [Order Details]
group by OrderID
--27.	��ѯÿ��Ա����7�·ݴ�����������
select Employeeid,count(*)  ����Ķ�������
from Orders
where month(ShippedDate)=7
group by Employeeid
--28.	��ѯÿ���˿͵Ķ�����������ʾ�˿�ID����������
select c.CustomerID,count(o.OrderID) ��������
from Customers c left join Orders o
on c.CustomerID=o.CustomerID
group by c.CustomerID
--29.	��ѯÿ���˿͵Ķ��������Ͷ����ܽ��
--�������˷�
select CustomerID,count(distinct Orders.OrderID) ��������,sum(UnitPrice*Quantity*(1-discount))�����ܽ��
from Orders,[Order Details]
where Orders.OrderID=[Order Details].OrderID
group by CustomerID
--�����˷�
select CustomerID,count(distinct Orders.OrderID) ��������,sum(UnitPrice*Quantity*(1-discount))+sum(distinct Freight) �����ܽ��
from Orders,[Order Details]
where Orders.OrderID=[Order Details].OrderID
group by CustomerID
--30.	��ѯÿ�ֲ�Ʒ�������������ܽ��
select p.productid,sum(Quantity) ��������,sum(Quantity*o.UnitPrice*(1-discount)) �ܽ��
from [Products] p left join [Order Details] o
on p.ProductID=o.ProductID
group by p.productid

--����	��books���ݿ�������²���
use books
--31.	��ѯ��������ͼ�����������������Ŀǰû��ͼ������
select Booktype.typeid,count(BookInfo.TypeID)
from Booktype  left join BookInfo
on Booktype.TypeID=BookInfo.TypeID
group by Booktype.typeid
--32.	��ѯ�����ˡ����ݿ�������Ķ��ߵĿ���ź�����
select CardInfo.cardno,Reader
from BorrowInfo,CardInfo,BookInfo
where BorrowInfo.BookNo=BookInfo.BookNo and  BorrowInfo.CardNo=CardInfo.CardNo and BookName='���ݿ����'
--33.	��ѯ�����������ͼ��۸񳬹����������ͼ���ƽ���۸��ͼ��ı�ź����ơ�
select bookno,bookname
from BookInfo B2
where price>(select avg(price) from BookInfo B1 where B2.Publisher=b1.Publisher)
--34.	��ѯû�н��ͼ��Ķ��ߵı�ź�����
select cardno,reader
from CardInfo
where CardInfo.CardNo not in(
select CardNo
from BorrowInfo
)
--35.	��ѯ���Ĵ�������2�εĶ��ߵı�ź�����
select CardInfo.cardno,reader
from CardInfo,BorrowInfo
where BorrowInfo.CardNo=CardInfo.CardNo
group by CardInfo.cardno,reader
having count(*)>2
--36.	��ѯ���Ŀ�������Ϊ��ʦ���о����Ķ�������
select typename,count(CardInfo.CTypeID) ��������
from CardInfo right join CardType
on CardInfo.CTypeID=CardType.CTypeID
where  (typename='��ʦ' or  typename='�о���')
group by typename
--37.	��ѯû�б������ͼ��ı�ź�����
select bookno,bookname
from Bookinfo 
where not exists(
select *
from BorrowInfo
where BookInfo.BookNo=BorrowInfo.BookNo)
--38.	��ѯû�н��Ĺ�Ӣ�����͵�ͼ��Ľ�ʦ�ı�ź�����
select cardno,reader
 from CardInfo , CardType
where CardInfo.CTypeID=CardType.CTypeID and typename='��ʦ' and not exists(
select *
from BorrowInfo,BookInfo,booktype
where    BookInfo.BookNo=BorrowInfo.BookNo and BookInfo.TypeID=BookType.TypeID and  
CardInfo.CardNo=BorrowInfo.CardNo and  Typename='Ӣ��' )

select cardinfo.IDCard,cardinfo.Reader

from cardinfo,cardtype

where cardinfo.CTypeID = cardtype.CTypeID and cardtype.TypeName = '��ʦ'

 and cardinfo.IDCard not in

 (

 select cardinfo.IDCard

 from cardinfo, BorrowInfo,bookinfo ,BookType

 where cardinfo.CardNo = borrowinfo.CardNo and BorrowInfo.BookNo = bookinfo.BookNo

 and bookinfo.TypeID = booktype.TypeID and booktype.TypeName = 'Ӣ��'

 )
--39.	��ѯ�����ˡ������Ӧ�á����ġ����ݿ�������γ̵Ķ��ߵı�ţ����������Լ��ö��ߵĽ��Ŀ������͡�
select cardinfo.IDCard,cardinfo.Reader,cardtype.TypeName

from cardinfo,cardtype,BorrowInfo,bookinfo,BookType

where cardinfo.CTypeID = cardtype.CTypeID and cardinfo.CardNo = BorrowInfo.CardNo and

 BorrowInfo.BookNo = bookinfo.BookNo and bookinfo.BookName = '���ݿ����' and BookInfo.TypeID=BookType.TypeID
  and BookType.TypeName='�����Ӧ��'
--40.	��ѯû�б�ȫ���Ķ��߶����Ĺ���ͼ��ı�ź�ͼ������
select bookno,bookname
from BookInfo
where  exists(
select *
from CardInfo
where  not exists(
select *
from BorrowInfo
where CardInfo.CardNo=BorrowInfo.CardNo and BookInfo.BookNo=BorrowInfo.BookNo))
--41.	��ѯ���Ĺ��廪��ѧ�����������ͼ��Ķ��߱�ź�����
select cardno,reader
from CardInfo
where not exists(
select *
from BookInfo
where  Publisher='�廪��ѧ������' and not exists(
select *
from BorrowInfo
where CardInfo.CardNo=BorrowInfo.CardNo and BookInfo.BookNo=BorrowInfo.BookNo))
--42.	��ѯ���Ĺ����������Ĺ���ȫ��ͼ��Ķ��߱�ź�����
select cardno,reader
from CardInfo
where not exists(
select *
from BorrowInfo B1,CardInfo c1
where  b1.CardNo=c1.CardNo and reader='����'  and not exists(
select *
from BorrowInfo
where CardInfo.CardNo=BorrowInfo.CardNo and B1.BookNo=BorrowInfo.BookNo))
--43.	��ѯÿ�����͵Ľ����߽��Ĺ���ͼ��Ĵ���
select CardType.CTypeID ,CardType.TypeName,count(b1.BookNo) ����ͼ�����
from BorrowInfo B1 right join CardInfo c1
on b1.CardNo=c1.CardNo right join CardType 
on C1.CTypeID=CardType.CTypeID
group by CardType.CTypeID ,CardType.TypeName
--44.	��ѯ�۸�����廪��ѧ�����������ͼ��۸��ͼ��ı�ţ�ͼ�����ƺͼ۸񣬳�����
select bookno,bookname,price,publisher
from BookInfo
where price>all(select price from BookInfo where  publisher='�廪��ѧ������')
--45.	��ѯû�н��Ĺ����������������ͼ��Ľ����ߵı������
select cardno,reader
from CardInfo
where   exists(
select *
from BorrowInfo B1,CardInfo c1
where  b1.CardNo=c1.CardNo and reader='����'  and  not  exists(
select *
from BorrowInfo
where CardInfo.CardNo=BorrowInfo.CardNo and B1.BookNo=BorrowInfo.BookNo))
--�ģ�	���̳����ݿ�������²���
use �̳�
--Market (mno, mname, city)
--Item (ino, iname, type, color)
--Sales (mno, ino, price)
--���У�market��ʾ�̳���������������Ϊ�̳��š��̳��������ڳ��У�item��ʾ��Ʒ��������������Ϊ��Ʒ�š���Ʒ������Ʒ������ɫ��sales��ʾ���ۣ�������������Ϊ�̳��š���Ʒ�ź��ۼۡ���SQL���ʵ������Ĳ�ѯҪ��
--1.	�г����������̳������ۣ����ۼ۾�����10000 Ԫ����Ʒ����Ʒ�ź���Ʒ��
select ino,iname
from Item
where not exists(
select *
from Market
where city='����' and not exists(
select *
from Sales
where Item.ino=sales.ino and sales.mno=market.mno and sales.price>10000))
--2.	�г��ڲ�ͬ�̳�������ۼۺ�����ۼ�ֻ���100 Ԫ����Ʒ����Ʒ�š�����ۼۺ�����ۼ�
select ino,max(price)����ۼ�,min(price)����ۼ�
from sales
group by ino
having max(price)-min(price)>100
--3.	�г��ۼ۳�������Ʒ��ƽ���ۼ۵ĸ�����Ʒ����Ʒ�ź��ۼ�
select ino,price
from sales
where price>(select avg(price) from sales s1 where sales.ino=s1.ino)
--4.	��ѯÿ��ÿ�����и����̳��ۼ���ߵ���Ʒ���̳��������У���Ʒ�ź���Ʒ��
select mname,city,item.ino,iname
from market,item,sales
where market.mno=sales.mno and sales.ino=item.ino and price>=
all(select price from sales s1,market m1 where  m1.mno=s1.mno and m1.mname=market.mname and m1.city=market.city )
--5.	��ѯ������Ʒ���������̳����̳��ţ��̳����ͳ���
select market.mno,mname,city
from market,sales
where market.mno=sales.mno
group by market.mno,mname,city
having count(*)>=all(select count(*)
from sales
group by mno)
--6.	��ѯ�����˱����ϴ�»����̳��ţ��̳����ͳ���
select market.mname,city      
from market
where not exists(
select *
from item
where  (iname='����' or iname= 'ϴ�»�') and not exists(         
select * 
from sales
where  market.mno=sales.mno and sales.ino=item.ino ))

select distinct market.mno,market.mname,market.city

from market,sales

where market.mno = sales.mno 

and market.mno in

(

 select sales.mno

 from sales,item

 where sales.ino = item.ino and item.iname = '����' and sales.mno in

 (

 select sales.mno

 from sales,item

 where sales.ino = item.ino and item.iname = 'ϴ�»�'

 )

--7.	��ѯ���۹�����Ʒ�Ƶ�������Ʒ���̳���ź��̳�����
select mno,mname
from market
where not exists(
select *
from item
where type='����' and not exists(
select*
from sales
where sales.ino=item.ino and sales.mno=market.mno))
--8.	��ѯ������������Ʒ���̳���ź��̳�����
select mno,mname
from market
where not exists(
select *
from item
where  not exists(
select*
from sales
where sales.ino=item.ino and sales.mno=market.mno))
--9.	��ѯ�ڱ����ĸ����̳��������۵���Ʒ�ı�ź���Ʒ����
select ino,iname
from item
where not exists(
select *
from market
where  city='����' and not exists(
select*
from sales
where sales.ino=item.ino and sales.mno=market.mno))
--10.	��ѯ�۸���ڱ����������̳������۵Ĳ�Ʒ�ļ۸����Ʒ��ź���Ʒ���ơ�
select distinct item.ino,iname
from item,sales
where item.ino=sales.ino and price>=all
(select price from market,sales where sales.mno=market.mno and city='����')

