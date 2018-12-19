/*select distinct Department, COUNT(*) as NumberOfPeopleInDepartment
from tblEmployee

select distinct Department, '' as DepartmentHead
into tblDepartment
from tblEmployee
group by Department

drop table tblDepartment

select distinct Department, convert(varchar(20),'') as DepartmentHead
into tblDepartment
from tblEmployee
group by Department

insert into tblDepartment(Department, DepartmentHead)
values ('Accounts', 'James')
*/


select D.Department, DepartmentHead, SUM(Amount) as SumOfAmount
from tblDepartment as D
left join tblEmployee as E
on D.Department = E.Department
left join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
group by D.Department, DepartmentHead
order by Department


begin tran

select COUNT(*) from tblTransaction

delete tblTransaction
from tblEmployee as E
right join tblTransaction as T
on T.EmployeeNumber = E.EmployeeNumber
where E.EmployeeNumber is null


select COUNT(*) from tblTransaction

rollback tran

select COUNT(*) from tblTransaction