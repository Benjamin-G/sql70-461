/* create table tblTransaction (
Amount smallmoney not null,
DateOfTransaction smalldatetime null,
EmployeeNumber int not null 


select tblEmployee.EmployeeNumber, EmployeeFirstName, EmployeeLastName, sum(Amount) as SumOfAmount from tblEmployee 
left join tblTransaction
on tblEmployee.EmployeeNumber = tblTransaction.EmployeeNumber
group by tblEmployee.EmployeeNumber, EmployeeFirstName, EmployeeLastName
order by EmployeeNumber
) */

