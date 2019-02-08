/* 
	Procedures
	While loops
	Outputs
	Return
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
	/*begin
		while(@EmployeeNumberFrom <= @EmployeeNumberTo)
		begin
			if exists(select * from tblEmployee where EmployeeNumber = @EmployeeNumberFrom)
			begin
				select EmployeeNumber, EmployeeFirstName, EmployeeLastName
				from tblEmployee 
				where EmployeeNumber = @EmployeeNumberFrom 
			end
			set @EmployeeNumberFrom += 1
		end
	end

	begin
		if (@EmployeeNumber < 200)
		begin
			select EmployeeNumber, EmployeeFirstName, EmployeeLastName
			from tblEmployee 
			where EmployeeNumber = @EmployeeNumber
		end
		else
		--if (@EmployeeNumber > 200)
		begin
			select EmployeeNumber, EmployeeFirstName, EmployeeLastName, Department
			from tblEmployee 
			where EmployeeNumber = @EmployeeNumber
			select Amount, DateOfTransaction, EmployeeNumber
			from tblTransaction
			where EmployeeNumber = @EmployeeNumber
		end
	end*/
end



go
declare @NumberRows int 
exec NameEmployees 123, 4, @NumberRows OUTPUT
select @NumberRows
execute NameEmployees 223, 227, @NumberRows OUTPUT
select @NumberRows


exec NameEmployees @EmployeeNumberFrom = 212, @EmployeeNumberTo = 500

declare @EmployeeName int = 123
set @EmployeeName +=1 
select @EmployeeName