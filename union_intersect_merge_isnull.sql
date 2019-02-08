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
into tblTransactionNew
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



/*
	CASE
	it must return the same data type or one that can be casted into
*/
declare @myOption as varchar(10) = 'Option a'

select case 
	when @myOption = 'Option A' then 'First option'
    when @myOption = 'Option B' then 'Second option'
	else 'No Option' 
	END as MyOptions
go

select case @myOption 
	when 'Option A' then 'First option'
    when 'Option B' then 'Second option' 
	else 'No Option' END as MyOptions
go

/* 
	ISNULL and COALESCE
	coalesce should use the same data type
*/
select * from tblEmployee where EmployeeMiddleName is null

declare @myOption as varchar(10) -- = 'Option B'
select isnull(@myOption, 'No Option') as MyOptions
go

declare @myFirstOption as varchar(10) --= 'Option A'
declare @mySecondOption as varchar(10) = 'Option B'

select coalesce(@myFirstOption, @mySecondOption, 'No option') as MyOptions
go

select isnull('ABC',1) as MyAnswer
select coalesce('ABC',1) as MyOtherAnswer
go

select isnull(null,null) as MyAnswer
select coalesce(null,null) as MyOtherAnswer
go

create table tblExample
(myOption nvarchar(10) null)
go
insert into tblExample (myOption)
values ('Option A')

select coalesce(myOption, 'No option') as MyOptions
into tblIsCoalesce
from tblExample 
select case when myOption is not null then myOption else 'No option' end as myOptions from tblExample
go
select isnull(myOption, 'No option') as MyOptions
into tblIsNull
from tblExample 
go

drop table tblExample
drop table tblIsCoalesce
drop table tblIsNull
go

/* 
	MERGE
*/

BEGIN TRAN
alter table tblTransaction add Comments varchar(50) null
go

MERGE INTO tblTransaction as T --target
USING (select EmployeeNumber, DateOfTransaction, SUM(Amount) as Amount
from tblTransactionNew
group by EmployeeNumber, DateOfTransaction) as S --source
ON T.EmployeeNumber = S.EmployeeNumber AND T.DateOfTransaction = S.DateOfTransaction
when matched then
	update set Amount = T.Amount + S.Amount, Comments = 'Updated Row'
when not matched by target then
	insert ([Amount],[DateOfTransaction],[EmployeeNumber],[Comments])
	values (S.Amount, S.DateOfTransaction, S.EmployeeNumber, 'Inserted Row')
When not matched by source then
	update set Comments = 'Unchanged';
select * from tblTransaction order by EmployeeNumber, DateOfTransaction
ROLLBACK TRAN

-- tblTransaction (no) - tblTransactionNew (yes)
-- 1 tblTransaction - 1 tblTransactionNew
-- 1 tblTransaction - multiple rows TblTransactionNew
