--一．	对xsgl数据库完成以下操作
use xsgl
--1.	查询没有选修英语的学生的学号，姓名和课程号，课程名，成绩
select  xs.学号,姓名,kc.课程号,课程名,成绩
from xs left join cj
on xs.学号=cj.学号  left join kc
on  kc.课程号=cj.课程号 
where not exists
(select *
 from cj c1,kc k1
 where k1.课程号=c1.课程号 and c1.学号=cj.学号 and k1.课程名='英语')

 select  xs.学号,姓名,kc.课程号,课程名,成绩
from xs left join cj
on xs.学号=cj.学号  left join kc
on  kc.课程号=cj.课程号 
where xs.学号 not in 
(select cj.学号
 from cj ,kc 
 where kc.课程号=cj.课程号  and kc.课程名='英语')

--2.	查询英语成绩高于英语的平均成绩的学生的学号，姓名，成绩
select xs.学号,姓名,成绩
from xs,cj,kc
where xs.学号=cj.学号 and cj.课程号=kc.课程号 and 课程名='英语' and 成绩> (select avg(成绩) from cj,kc where cj.课程号=kc.课程号 and 课程名='英语' )
--3.	查询选修了英语和高数的学生的学号和姓名（要求使用两种方法实现）
--法一   
select 学号,姓名
from xs
where 学号 in(select 学号 from cj,kc where cj.课程号=kc.课程号 and 课程名='英语') and 
学号 in(select 学号 from cj,kc where cj.课程号=kc.课程号 and 课程名='数学')

--法二               除运算
select 学号,姓名     
from xs
where not exists(
select *
from kc k1
where  (课程名='英语' or 课程名= '数学') and not exists(         
select * 
from cj c1
where xs.学号=c1.学号 and k1.课程号=c1.课程号 ))
--方法三
select xs.学号,xs.姓名

from xs,cj,kc

where xs.学号 = cj.学号 and cj.课程号 = kc.课程号 and kc.课程名 = '英语'

 and xs.学号 in

 (

 select cj.学号

 from cj,kc

 where cj.课程号 = kc.课程号 and kc.课程名 = '数学'

 )
--法五   自身连接  
select xs.学号,xs.姓名

from xs,cj cj1,cj cj2,kc kc1,kc kc2

where cj1.学号 = cj2.学号 and xs.学号 = cj1.学号 and cj1.课程号 = kc1.课程号 and cj2.课程号 = kc2.课程号

 and kc1.课程名 = '数学' and kc2.课程名 = '英语'

--4.	查询没有选修程明所选修的全部课程的学生的姓名
select 姓名
from xs
where not exists(
select *
from cj c1,xs x1        --xs.学号=cj.学号
where c1.学号=x1.学号 and 姓名='程明'and  exists(
 select *
 from cj
 where xs.学号=cj.学号 and cj.课程号=c1.课程号 
)
)
--5.	查询每个专业年龄超过该专业平均年龄的学生的姓名和专业
select 姓名,专业
from xs
where datediff(yy,出生时间,getdate())>
(select avg(datediff(yy,出生时间,getdate())) from xs x1 where x1.专业=xs.专业)
--6.	查询每个专业每门课程的专业，课程号，课程名，选课人数，平均分和最高分
select 专业,cj.课程号,课程名,count(*) 选课人数,avg(成绩) 平均分,max(成绩) 最高分
from xs,cj,kc
where xs.学号=cj.学号 and cj.课程号=kc.课程号 
group by 专业, cj.课程号,课程名
--7.	查询每个学生取得最高分的课程的课程号，课程名和成绩
select xs.学号,cj.课程号, 课程名, 成绩
from xs,cj,kc
where xs.学号=cj.学号 and cj.课程号=kc.课程号 and 成绩>=all(select 成绩 from cj c1 where  c1.学号=cj.学号  )

SELECT XS1.姓名,KC1.课程号,课程名,成绩
FROM xs XS1,cj CJ1,kc KC1
WHERE KC1.课程号 = CJ1.课程号 AND XS1.学号 = CJ1.学号
AND CJ1.成绩 >=(SELECT  MAX(成绩) 最高分
                FROM cj CJ2
                WHERE XS1.学号 = CJ2.学号
                )
--8.	查询每个专业年龄最高的学生的学号，姓名，专业和年龄
select 学号,姓名,专业,datediff(yy,出生时间,getdate()) 年龄
from xs
where datediff(yy,出生时间,getdate())>=all(select datediff(yy,出生时间,getdate()) from xs x1 where x1.专业=xs.专业)
--9.	查询没有选修数据结构和操作系统的学生的学号和姓名。（使用存在量词实现）
select 学号,姓名
from xs
where not exists(
select *
from cj,kc
where   cj.课程号=kc.课程号  and  xs.学号=cj.学号 and (课程名='数据结构' or 课程名='操作系统' ))

select 学号,姓名
from xs
where xs.学号 not in(
select cj.学号
from cj,kc
where   cj.课程号=kc.课程号   and (课程名='数据结构' or 课程名='操作系统' ))
--10.	查询网络工程专业年龄最小的学生的学号和姓名
select 学号,姓名
from xs
where 专业='网络工程' 
and  datediff(yy,出生时间,getdate()) =
(select top 1 datediff(yy,出生时间,getdate())
from xs
where 专业='网络工程' 
order by  datediff(yy,出生时间,getdate()))
--11.	查询选课人数超过5人的课程的课程号，课程名和成绩
select cj.课程号,课程名,成绩
from cj,kc
where cj.课程号=kc.课程号 and (select count(*) from cj c1 where cj.课程号=c1.课程号 )>5;

select kc.课程号,kc.课程名,cj.成绩

from kc,cj

where kc.课程号 = cj.课程号 

 and kc.课程号 in

 (

 select cj.课程号

 from cj

 group by cj.课程号

 having count(cj.学号)>5

 )
--12.	查询选修了信息管理专业所有学生选修的全部课程的学生的学号和姓名
select 学号,姓名
from xs
where not exists(
select *
from xs x1,cj
where x1.学号=cj.学号 and 专业='信息管理' and  not exists(
select *
from cj c1
where xs.学号=c1.学号 and c1.课程号=cj.课程号))
--13.	使用存在量词实现查询没有被学生选修的课程的课程号和课程名
select 课程号,课程名
from kc
where   not exists(
select *
from cj
where kc.课程号=cj.课程号)
--14.	查询选课人数最多和选课人数最少的课程的课程号，课程名和人数
select  kc.课程号,课程名,count(*)人数
from kc,cj
where kc.课程号=cj.课程号  
group by kc.课程号,课程名
having count(*)=(select  top 1 count(*)
from kc,cj
where kc.课程号=cj.课程号  
group by kc.课程号,课程名
order by count(*)  desc)
or 
count(*)=(select  top 1 count(*)
from kc,cj
where kc.课程号=cj.课程号  
group by kc.课程号,课程名
order by count(*)  asc)
--15.	查询选修英语的成绩高于英语课程的平均成绩的学生的学号，姓名和成绩
select xs.学号,姓名,成绩
from xs,cj,kc
where xs.学号=cj.学号 and cj.课程号=kc.课程号 and 课程名='英语' and 成绩> (select avg(成绩) from cj,kc where cj.课程号=kc.课程号 and 课程名='英语' )
--16.	查询各门课中成绩最高分的学生的学号，姓名，课程号，课程名，分数
select xs.学号,姓名,cj.课程号,课程名,成绩 分数
from xs,cj,kc
where xs.学号=cj.学号 and cj.课程号=kc.课程号 and 成绩>=all(select 成绩 from cj c1 where c1.课程号=cj.课程号)
--17.	查询每门课中成绩低于该课程的平均成绩的学号，课程号，成绩
select 学号,课程号,成绩
from cj
where 成绩<(select avg(成绩) from cj c1 where cj.课程号=c1.课程号)
--18.	查询各个专业每门课程取得最高分的学生的学号，姓名，专业，课程号，课程名，成绩
select xs.学号,姓名,专业,cj.课程号,课程名,成绩
from xs,cj,kc
where xs.学号=cj.学号 and cj.课程号=kc.课程号 and 成绩>=
all(select 成绩 from cj c1 ,xs x1 where  x1.学号=c1.学号 and  c1.课程号=cj.课程号 and x1.专业=xs.专业 )
--19.	查询没有选修全部课程的学生的学号和姓名，
select 学号,姓名
from xs
where   exists(
select *
from kc
where  not exists(
select *
from cj
where xs.学号=cj.学号 and cj.课程号=kc.课程号))

select xs.学号 ,xs.姓名 
from xs left join cj
on xs.学号=cj.学号
group by xs.学号 ,xs.姓名
having count(cj.课程号 )<(select count(*) from kc)
--20.	查询没有被全部学生都选修了的课程的课程号和课程名
select 课程号,课程名
from kc
where  exists(
select *
from xs
where not exists(
select *
from cj
where xs.学号=cj.学号 and cj.课程号=kc.课程号))
--21.	查询选课门数少于网络工程专业某个学生的选课门数的学生的学号，姓名和选课门数
select xs.学号,姓名,count(*) 选课门数
from xs,cj
where xs.学号=cj.学号 
group by xs.学号,姓名
having count(*)<=any(select count(*) from xs x1,cj c1
where x1.学号=c1.学号 and 专业='网络工程' group by x1.学号,姓名)
--22.	查询选课人数超过英语的选课人数的课程的课程号，课程名和人数
select kc.课程号,课程名,count(*)人数
from kc,cj
where kc.课程号=cj.课程号 
group by kc.课程号,课程名
having count(*)>(select count(*)from cj c1,kc k1
where  c1.课程号=k1.课程号 and 课程名='英语')
--23.	查询成绩高于选修英语的某个学生的成绩的学生的学号，姓名，课程号，课程名，成绩
select xs.学号,姓名,kc.课程号,课程名,成绩
from xs,cj,kc
where xs.学号=cj.学号 and cj.课程号=kc.课程号 and 成绩>any(
select 成绩
from cj c1,kc k1
where  c1.课程号=k1.课程号 and 课程名='英语')
--24.	查询选修了程明和方可以同学所选修的全部课程的学生的学号和姓名
select 学号,姓名
from xs
where not exists(
select *
from xs x1,cj
where x1.学号=cj.学号 and (姓名='程明' or 姓名='方可以') and not exists(
select *
from cj c1
where c1.学号=xs.学号 and c1.课程号=cj.课程号))
--25.	查询选课学生包含了选修英语的全部学生的课程的课程号和课程名
select 课程号,课程名
from kc
where not exists(
select *
from cj,kc k1
where cj.课程号=k1.课程名 and 课程名='英语' and not exists(
select * 
from cj c1
where kc.课程号=c1.课程号 and c1.学号=cj.学号 ))


--二．对罗斯文数据库完成一下查询
use Northwind
--26.	查询每个订单购买产品的数量和总金额，输出订单号，数量，总金额  
select OrderID,sum(Quantity) 数量,sum(UnitPrice*Quantity*(1-discount)) 总金额
from [Order Details]
group by OrderID
--27.	查询每个员工在7月份处理订单的数量
select Employeeid,count(*)  处理的订单数量
from Orders
where month(ShippedDate)=7
group by Employeeid
--28.	查询每个顾客的订单总数，显示顾客ID，订单总数
select c.CustomerID,count(o.OrderID) 订单总数
from Customers c left join Orders o
on c.CustomerID=o.CustomerID
group by c.CustomerID
--29.	查询每个顾客的订单总数和订单总金额
--不考虑运费
select CustomerID,count(distinct Orders.OrderID) 订单总数,sum(UnitPrice*Quantity*(1-discount))订单总金额
from Orders,[Order Details]
where Orders.OrderID=[Order Details].OrderID
group by CustomerID
--考虑运费
select CustomerID,count(distinct Orders.OrderID) 订单总数,sum(UnitPrice*Quantity*(1-discount))+sum(distinct Freight) 订单总金额
from Orders,[Order Details]
where Orders.OrderID=[Order Details].OrderID
group by CustomerID
--30.	查询每种产品的卖出总数和总金额
select p.productid,sum(Quantity) 卖出总数,sum(Quantity*o.UnitPrice*(1-discount)) 总金额
from [Products] p left join [Order Details] o
on p.ProductID=o.ProductID
group by p.productid

--三、	对books数据库完成以下操作
use books
--31.	查询各种类别的图书的类别和数量（包含目前没有图书的类别）
select Booktype.typeid,count(BookInfo.TypeID)
from Booktype  left join BookInfo
on Booktype.TypeID=BookInfo.TypeID
group by Booktype.typeid
--32.	查询借阅了‘数据库基础’的读者的卡编号和姓名
select CardInfo.cardno,Reader
from BorrowInfo,CardInfo,BookInfo
where BorrowInfo.BookNo=BookInfo.BookNo and  BorrowInfo.CardNo=CardInfo.CardNo and BookName='数据库基础'
--33.	查询各个出版社的图书价格超过这个出版社图书的平均价格的图书的编号和名称。
select bookno,bookname
from BookInfo B2
where price>(select avg(price) from BookInfo B1 where B2.Publisher=b1.Publisher)
--34.	查询没有借过图书的读者的编号和姓名
select cardno,reader
from CardInfo
where CardInfo.CardNo not in(
select CardNo
from BorrowInfo
)
--35.	查询借阅次数超过2次的读者的编号和姓名
select CardInfo.cardno,reader
from CardInfo,BorrowInfo
where BorrowInfo.CardNo=CardInfo.CardNo
group by CardInfo.cardno,reader
having count(*)>2
--36.	查询借阅卡的类型为老师和研究生的读者人数
select typename,count(CardInfo.CTypeID) 读者人数
from CardInfo right join CardType
on CardInfo.CTypeID=CardType.CTypeID
where  (typename='教师' or  typename='研究生')
group by typename
--37.	查询没有被借过的图书的编号和名称
select bookno,bookname
from Bookinfo 
where not exists(
select *
from BorrowInfo
where BookInfo.BookNo=BorrowInfo.BookNo)
--38.	查询没有借阅过英语类型的图书的教师的编号和姓名
select cardno,reader
 from CardInfo , CardType
where CardInfo.CTypeID=CardType.CTypeID and typename='教师' and not exists(
select *
from BorrowInfo,BookInfo,booktype
where    BookInfo.BookNo=BorrowInfo.BookNo and BookInfo.TypeID=BookType.TypeID and  
CardInfo.CardNo=BorrowInfo.CardNo and  Typename='英语' )

select cardinfo.IDCard,cardinfo.Reader

from cardinfo,cardtype

where cardinfo.CTypeID = cardtype.CTypeID and cardtype.TypeName = '教师'

 and cardinfo.IDCard not in

 (

 select cardinfo.IDCard

 from cardinfo, BorrowInfo,bookinfo ,BookType

 where cardinfo.CardNo = borrowinfo.CardNo and BorrowInfo.BookNo = bookinfo.BookNo

 and bookinfo.TypeID = booktype.TypeID and booktype.TypeName = '英语'

 )
--39.	查询借阅了‘计算机应用’类别的‘数据库基础’课程的读者的编号，读者姓名以及该读者的借阅卡的类型。
select cardinfo.IDCard,cardinfo.Reader,cardtype.TypeName

from cardinfo,cardtype,BorrowInfo,bookinfo,BookType

where cardinfo.CTypeID = cardtype.CTypeID and cardinfo.CardNo = BorrowInfo.CardNo and

 BorrowInfo.BookNo = bookinfo.BookNo and bookinfo.BookName = '数据库基础' and BookInfo.TypeID=BookType.TypeID
  and BookType.TypeName='计算机应用'
--40.	查询没有被全部的读者都借阅过的图书的编号和图书名称
select bookno,bookname
from BookInfo
where  exists(
select *
from CardInfo
where  not exists(
select *
from BorrowInfo
where CardInfo.CardNo=BorrowInfo.CardNo and BookInfo.BookNo=BorrowInfo.BookNo))
--41.	查询借阅过清华大学出版社的所有图书的读者编号和姓名
select cardno,reader
from CardInfo
where not exists(
select *
from BookInfo
where  Publisher='清华大学出版社' and not exists(
select *
from BorrowInfo
where CardInfo.CardNo=BorrowInfo.CardNo and BookInfo.BookNo=BorrowInfo.BookNo))
--42.	查询借阅过王明所借阅过的全部图书的读者编号和姓名
select cardno,reader
from CardInfo
where not exists(
select *
from BorrowInfo B1,CardInfo c1
where  b1.CardNo=c1.CardNo and reader='王明'  and not exists(
select *
from BorrowInfo
where CardInfo.CardNo=BorrowInfo.CardNo and B1.BookNo=BorrowInfo.BookNo))
--43.	查询每种类型的借阅者借阅过的图书的次数
select CardType.CTypeID ,CardType.TypeName,count(b1.BookNo) 借阅图书次数
from BorrowInfo B1 right join CardInfo c1
on b1.CardNo=c1.CardNo right join CardType 
on C1.CTypeID=CardType.CTypeID
group by CardType.CTypeID ,CardType.TypeName
--44.	查询价格高于清华大学出版社的所有图书价格的图书的编号，图书名称和价格，出版社
select bookno,bookname,price,publisher
from BookInfo
where price>all(select price from BookInfo where  publisher='清华大学出版社')
--45.	查询没有借阅过王明所借过的所有图书的借阅者的编号姓名
select cardno,reader
from CardInfo
where   exists(
select *
from BorrowInfo B1,CardInfo c1
where  b1.CardNo=c1.CardNo and reader='王明'  and  not  exists(
select *
from BorrowInfo
where CardInfo.CardNo=BorrowInfo.CardNo and B1.BookNo=BorrowInfo.BookNo))
--四．	对商场数据库完成以下操作
use 商场
--Market (mno, mname, city)
--Item (ino, iname, type, color)
--Sales (mno, ino, price)
--其中，market表示商场，它的属性依次为商场号、商场名和所在城市；item表示商品，它的属性依次为商品号、商品名、商品类别和颜色；sales表示销售，它的属性依次为商场号、商品号和售价。用SQL语句实现下面的查询要求：
--1.	列出北京各个商场都销售，且售价均超过10000 元的商品的商品号和商品名
select ino,iname
from Item
where not exists(
select *
from Market
where city='北京' and not exists(
select *
from Sales
where Item.ino=sales.ino and sales.mno=market.mno and sales.price>10000))
--2.	列出在不同商场中最高售价和最低售价只差超过100 元的商品的商品号、最高售价和最低售价
select ino,max(price)最高售价,min(price)最低售价
from sales
group by ino
having max(price)-min(price)>100
--3.	列出售价超过该商品的平均售价的各个商品的商品号和售价
select ino,price
from sales
where price>(select avg(price) from sales s1 where sales.ino=s1.ino)
--4.	查询每个每个城市各个商场售价最高的商品的商场名，城市，商品号和商品名
select mname,city,item.ino,iname
from market,item,sales
where market.mno=sales.mno and sales.ino=item.ino and price>=
all(select price from sales s1,market m1 where  m1.mno=s1.mno and m1.mname=market.mname and m1.city=market.city )
--5.	查询销售商品数量最多的商场的商场号，商场名和城市
select market.mno,mname,city
from market,sales
where market.mno=sales.mno
group by market.mno,mname,city
having count(*)>=all(select count(*)
from sales
group by mno)
--6.	查询销售了冰箱和洗衣机的商场号，商场名和城市
select market.mname,city      
from market
where not exists(
select *
from item
where  (iname='冰箱' or iname= '洗衣机') and not exists(         
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

 where sales.ino = item.ino and item.iname = '冰箱' and sales.mno in

 (

 select sales.mno

 from sales,item

 where sales.ino = item.ino and item.iname = '洗衣机'

 )

--7.	查询销售过海尔品牌的所有商品的商场编号和商场名称
select mno,mname
from market
where not exists(
select *
from item
where type='海尔' and not exists(
select*
from sales
where sales.ino=item.ino and sales.mno=market.mno))
--8.	查询销售了所有商品的商场编号和商场名称
select mno,mname
from market
where not exists(
select *
from item
where  not exists(
select*
from sales
where sales.ino=item.ino and sales.mno=market.mno))
--9.	查询在北京的各个商场都有销售的商品的编号和商品名称
select ino,iname
from item
where not exists(
select *
from market
where  city='北京' and not exists(
select*
from sales
where sales.ino=item.ino and sales.mno=market.mno))
--10.	查询价格高于北京的所有商场所销售的产品的价格的商品编号和商品名称。
select distinct item.ino,iname
from item,sales
where item.ino=sales.ino and price>=all
(select price from market,sales where sales.mno=market.mno and city='北京')

