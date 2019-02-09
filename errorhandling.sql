/* 
	Error Handling
*/

if exists (select * from sys.procedures where name='NameEmployees')if OBJECT_ID('NameEmployees','P') IS NOT NULL
drop proc NameEmployees 
go

create proc NameEmployees(@EmployeeNumberFrom int , @EmployeeNumberTo int, @NumberOfRows int OUTPUT) as
begin
	if exists(select * from tblEmployee where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo)
	begin
		select EmployeeNumber, EmployeeFirstName, EmployeeLastName
		from tblEmployee 
		where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo
		set @NumberOfRows = @@ROWCOUNT
	end
	else
	begin
		set @NumberOfRows = 0
	end
end


go
declare @NumberRows int 
exec NameEmployees 123, 4, @NumberRows OUTPUT
select @NumberRows
execute NameEmployees 223, 227, @NumberRows OUTPUT
select @NumberRows