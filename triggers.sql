/* 
	DML Data Management Language
	after 
	instead of 
*/

--Right click -> insert snippet
CREATE TRIGGER TriggerName
    ON [dbo].[TableName]
    FOR DELETE, INSERT, UPDATE
    AS
    BEGIN
    SET NOCOUNT ON
    END
go


CREATE TRIGGER TR_tblTransaction
ON tblTransaction
AFTER DELETE, INSERT, UPDATE
AS
BEGIN
	--insert into tblTransaction2
	select *, 'Inserted' from Inserted
	--insert into tblTransaction2
	select *, 'Deleted' from Deleted
END
GO

BEGIN TRAN
insert into tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
VALUES (123,'2015-07-10', 123)
--delete tblTransaction 
--where EmployeeNumber = 123 and DateOfTransaction = '2015-07-10'
ROLLBACK TRAN
GO
DISABLE TRIGGER TR_tblTransaction ON tblTransaction;
GO
ENABLE TRIGGER TR_tblTransaction ON tblTransaction;
GO
DROP TRIGGER TR_tblTransaction;
GO


create trigger tr_ViewByDep
on dbo.ViewByDep
instead of delete
as 
begin
	select *, 'ViewByDep' from deleted
end
go


alter TRIGGER tr_ViewByDep
ON dbo.ViewByDep
INSTEAD OF DELETE
AS
BEGIN
    declare @EmployeeNumber as int
	declare @DateOfTransaction as smalldatetime
	declare @Amount as smallmoney
	select @EmployeeNumber = EmployeeNumber, @DateOfTransaction = DateOfTransaction,  @Amount = TotalAmount
	from deleted
	--SELECT * FROM deleted
	delete tblTransaction
	from tblTransaction as T
	where T.EmployeeNumber = @EmployeeNumber
	and T.DateOfTransaction = @DateOfTransaction
	and T.Amount = @Amount
END
go 

begin tran
--SELECT * FROM ViewByDep where TotalAmount = -2.77 and EmployeeNumber = 132
delete from ViewByDep
where TotalAmount = -2.77 and EmployeeNumber = 132
--SELECT * FROM ViewByDep where TotalAmount = -2.77 and EmployeeNumber = 132
rollback tran
go


/* 
	NESTED TRIGGERS
*/

ALTER TRIGGER TR_tblTransaction
ON tblTransaction
AFTER DELETE, INSERT, UPDATE
AS
BEGIN
    if @@NESTLEVEL = 1
	begin
		select *,'TABLEINSERT' from Inserted
		select *, 'TABLEDELETE' from Deleted
	end
END
GO

BEGIN TRAN
insert into tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
VALUES (123,'2015-07-10', 123)
ROLLBACK TRAN

begin tran
--SELECT * FROM ViewByDep where TotalAmount = -2.77 and EmployeeNumber = 132
delete from ViewByDep
where TotalAmount = -2.77 and EmployeeNumber = 132
--SELECT * FROM ViewByDep where TotalAmount = -2.77 and EmployeeNumber = 132
rollback tran

EXEC sp_configure 'nested triggers';

EXEC sp_configure 'nested triggers',0;
RECONFIGURE
GO


/* 
	UPDATE FUNCTIONS
*/


ALTER TRIGGER TR_tblTransaction
ON tblTransaction
AFTER DELETE, INSERT, UPDATE
AS
BEGIN
	IF @@ROWCOUNT > 0
	BEGIN
		select * from Inserted
		select * from Deleted
	END
END
GO

begin tran
insert into tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
VALUES (123,'2015-07-11', 123)

SELECT *, 'yes' FROM ViewByDep where TotalAmount = -2.77 and EmployeeNumber = 132

delete from ViewByDep
where TotalAmount = -2.77 and EmployeeNumber = 132
rollback tran

go

ALTER TRIGGER TR_tblTransaction
ON tblTransaction
AFTER DELETE, INSERT, UPDATE
AS
BEGIN
	--SELECT COLUMNS_UPDATED()
	IF UPDATE(Amount) -- if (COLUMNS_UPDATED() & POWER(2,1-1)) > 0
	BEGIN
		select * from Inserted
		select * from Deleted
	END
END
go

begin tran
--SELECT * FROM ViewByDep where TotalAmount = -2.77 and EmployeeNumber = 132
update ViewByDep
set TotalAmount = +2.77
where TotalAmount = -2.77 and EmployeeNumber = 132
rollback tran
go


/* 
	Handling Multiple Rows
*/ 
alter TRIGGER tr_ViewByDep
ON dbo.ViewByDep
INSTEAD OF DELETE
AS
BEGIN
    declare @EmployeeNumber as int
	declare @DateOfTransaction as smalldatetime
	declare @Amount as smallmoney
	select @EmployeeNumber = EmployeeNumber, @DateOfTransaction = DateOfTransaction,  @Amount = TotalAmount
	from deleted
	--SELECT * FROM deleted
	delete tblTransaction
	from tblTransaction as T
	where T.EmployeeNumber = @EmployeeNumber
	and T.DateOfTransaction = @DateOfTransaction
	and T.Amount = @Amount
END

begin tran
SELECT * FROM ViewByDep where EmployeeNumber = 132
delete from ViewByDep
where EmployeeNumber = 132
SELECT * FROM ViewByDep where EmployeeNumber = 132
rollback tran

-- Good code - allows multiple rows to be deleted

alter TRIGGER tr_ViewByDep
ON dbo.ViewByDep
INSTEAD OF DELETE
AS
BEGIN
	SELECT *, 'To Be Deleted' FROM deleted
    delete from tblTransaction
	from tblTransaction as T
	join deleted as D
	on T.EmployeeNumber = D.EmployeeNumber
	and T.DateOfTransaction = D.DateOfTransaction
	and T.Amount = D.TotalAmount
END
GO

begin tran
SELECT *, 'Before Delete' FROM ViewByDep where EmployeeNumber = 132
delete from ViewByDep
where EmployeeNumber = 132 --and TotalAmount = 861.16
SELECT *, 'After Delete' FROM ViewByDep where EmployeeNumber = 132
rollback tran
