begin transaction

select COUNT(*) from tblTransaction

delete tblTransaction
from tblTransaction
where EmployeeNumber in (
select TNumber from (
select E.EmployeeNumber as ENumber, E.EmployeeFirstName, E.EmployeeLastName, T.EmployeeNumber as TNumber, SUM(T.Amount) as TotalAmount
from tblEmployee as E
right join tblTransaction as T
on T.EmployeeNumber = E.EmployeeNumber
group by E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName, T.EmployeeNumber) as newTable
where ENumber is null)

select COUNT(*) from tblTransaction

rollback transaction

select COUNT(*) from tblTransaction