select 学号, 姓名, 课程号, 课程名, 成绩
from xs join cj on xs.学号 = cj.学号, cj join kc on cj.课程号 = kc.课程号
where not exists (select *
				from )