select * from tblTransaction where EmployeeNumber = 3


begin tran
select * from tblTransaction where EmployeeNumber = 194
update tblTransaction
set EmployeeNumber = 194
from tblTransaction
where EmployeeNumber in (3,5,7,9)
select * from tblTransaction where EmployeeNumber = 194
rollback tran