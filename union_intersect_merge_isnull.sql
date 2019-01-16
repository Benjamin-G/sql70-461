/* 
	UNION 
	same # of columns with compatible data types

	union vs union all ->  union removes dups; all does not
*/

select * from (select convert(char(5),'hi') as Greeting) t1
join
(select convert(char(11),'hello there') as GreetingNow) t2 on t1.Greeting != t2.GreetingNow 

--versus 


select convert(char(5),'hi') as Greeting
union all
select convert(char(11),'hello there') as GreetingNow
union all
select convert(char(11),'bonjour') as GreetingLater
union all
select convert(char(11),'hi') as GreetingNow


select convert(tinyint, 45) as Mycolumn
union
select convert(bigint, 456)


/* 
	INTERSECT AND EXCEPT
	order by must be at the end

	except ->  total of first expect dups in second,
	intersect ->  just that which is shared between tables
*/
select *, Row_Number() over(order by (select null)) % 3 as ShouldIDelete
--into tblTransactionNew
from tblTransaction

delete from tblTransactionNew
where ShouldIDelete = 1

update tblTransactionNew
set DateOfTransaction = dateadd(day,1,DateOfTransaction)
Where ShouldIDelete = 2

alter table tblTransactionNew
drop column ShouldIDelete

select * from tblTransaction -- 2486 rows
intersect--except--union--union all
select * from tblTransactionNew -- 1657 rows, 829 changed rows, 828 unchanged
order by EmployeeNumber
