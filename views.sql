/* 
Create View must be a block
Alter and Drop view must be on existing views
sys.views is where to find all views in server

its best practice to drop a table if it already exists and create new over altering an existing table

select * from sys.views 
*/


create view ViewByDep as 
select D.Department, T.EmployeeNumber, T.DateOfTransaction, T.Amount as TotalAmount
from dbo.tblDepartment as D
left join dbo.tblEmployee as E
on D.Department = E.Department
left join dbo.tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
where T.EmployeeNumber between 120 and 139
--order by D.Department, T.EmployeeNumber
go

create view ViewSummary /*with encryption*/ as
select D.Department, T.EmployeeNumber as EmpNum, sum(T.Amount) as TotalAmount
from tblDepartment as D
left join tblEmployee as E
on D.Department = E.Department
left join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
group by D.Department, T.EmployeeNumber
--order by D.Department, T.EmployeeNumber
go

select * from ViewByDep order by Department, EmployeeNumber desc
select * from ViewSummary


--This will get the queries because they are unprotected
select V.name, S.text from sys.syscomments as S
inner join sys.views as V
on S.id = V.object_id

select OBJECT_DEFINITION(OBJECT_ID('dbo.ViewByDep'))
select * from sys.sql_modules

/*
	INSERT ROWS
	This will alter the underlying table and can only modify a single table at a time
	 use WITH CHECK OPTION to add a constraint 
*/


begin tran
--this will insert into the underlying table
select * from tblTransaction where EmployeeNumber = 132
insert into ViewByDep(EmployeeNumber,DateOfTransaction,TotalAmount)
values (132,'2015-07-07', 999.99)

select * from ViewByDep order by Department, EmployeeNumber
select * from tblTransaction where EmployeeNumber = 132
rollback tran



begin tran
select * from ViewByDep order by EmployeeNumber, DateOfTransaction
--Select * from tblTransaction where EmployeeNumber in (132,142)

update ViewByDep
set EmployeeNumber = 142
where EmployeeNumber = 132

select * from ViewByDep order by EmployeeNumber, DateOfTransaction
--Select * from tblTransaction where EmployeeNumber in (132,142)
rollback tran



--if exists(select * from sys.views where name = 'ViewByDep')

/* WITH CHECK OPTION */
if exists(select * from INFORMATION_SCHEMA.VIEWS
where [TABLE_NAME] = 'ViewByDep' and [TABLE_SCHEMA] = 'dbo')
   drop view dbo.ViewByDep
go

CREATE view [dbo].[ViewByDep] as 
select D.Department, T.EmployeeNumber, T.DateOfTransaction, T.Amount as TotalAmount
from tblDepartment as D
left join tblEmployee as E
on D.Department = E.Department
left join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
where T.EmployeeNumber between 120 and 139
WITH CHECK OPTION
--order by D.Department, T.EmployeeNumber
GO



/*
	DELETE ROWS
	you cannot delete from more than one single table
*/


SELECT * FROM ViewByDep
delete from ViewByDep
where TotalAmount = 999.99 and EmployeeNumber = 132
GO
CREATE VIEW ViewSimple
as
SELECT * FROM tblTransaction
GO
BEGIN TRAN
delete from ViewSimple
where EmployeeNumber = 132
select * from ViewSimple
ROLLBACK TRAN



--lots of hoops to jump through all views must be "with schemabinding" and using schemas
create unique clustered index inx_ViewByDep on dbo.ViewByDep (EmployeeNumber, Department)