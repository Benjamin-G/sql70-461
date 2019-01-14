--Adding constraints
alter table tblEmployee
add constraint unqGovernmentID unique (EmployeeGovernmentID)

alter table tblTransaction
add constraint unqTransaction unique (Amount, DateOfTransaction, EmployeeNumber)


select EmployeeGovernmentID, COUNT(*) as myCount 
from tblEmployee group by EmployeeGovernmentID
having COUNT(EmployeeGovernmentID) > 1

--adding column
alter table tblTransaction
add DateOfEntry datetime

--adding default for DateOfEntry in tblTransation
alter table tblTransaction
add constraint defDateOfTime default GETDATE() for DateOfEntry

select * from tblTransaction

alter table tblTransaction
drop constraint defDateOfTime

alter table tblTransaction
drop column DateOfEntry

--check constraints
alter table tblTransaction
add constraint chkAmount check (Amount>-1000 and Amount <1000)

--Does not have a full stop in middle name
alter table tblEmployee with nocheck
add constraint chkMiddleName check
(REPLACE(EmployeeMiddleName,'.','') = EmployeeMiddleName)-- or EmployeeMiddleName is null

--names the check constraint for the EmployeeMiddleName column
create table tblEmployee2
(EmployeeMiddleName varchar(50) null, constraint CK_EmployeeMiddleName check
(REPLACE(EmployeeMiddleName,'.','') = EmployeeMiddleName or EmployeeMiddleName is null))


--date of birth must be between now and 1900
alter table tblEmployee with nocheck
add constraint chkDateOfBirth check (DateOfBirth between '1900-01-01' and getdate())


alter table tblEmployee
drop constraint chkMiddleName

begin tran
  insert into tblEmployee
  output inserted.*
  values (2003, 'A', null, 'C', 'D', '2014-01-01', 'Accounts')
rollback tran



--Primary Key

--adding primary key to tblEmployee
alter table tblEmployee
add constraint PK_tblEmployee PRIMARY KEY (EmployeeNumber)

--IDENTITY('starting','inc by')
create table tblEmployee2
(EmployeeNumber int CONSTRAINT PK_tblEmployee2 PRIMARY KEY IDENTITY(1,1),
EmployeeName nvarchar(20))

insert into tblEmployee2
values ('My Name'),
('My Name')

select * from tblEmployee2

--this will just delete the infromation but will not reset back to the seed state
delete from tblEmployee2

--truncate basically resets the table
truncate table tblEmployee2


--you can turn on and off IDENTITY_INSERT
SET IDENTITY_INSERT tblEmployee2 ON

insert into tblEmployee2(EmployeeNumber, EmployeeName)
values (18, 'My Name'), (39, 'My Name')

SET IDENTITY_INSERT tblEmployee2 OFF
select * from tblEmployee2

drop table tblEmployee2

--last identity used
select @@IDENTITY
select SCOPE_IDENTITY()

--current identity 
select IDENT_CURRENT('dbo.tblEmployee2')

--foreign keys
BEGIN TRAN
ALTER TABLE tblTransaction ALTER COLUMN EmployeeNumber INT NULL 
ALTER TABLE tblTransaction ADD CONSTRAINT DF_tblTransaction DEFAULT 124 FOR EmployeeNumber
ALTER TABLE tblTransaction WITH NOCHECK
ADD CONSTRAINT FK_tblTransaction_EmployeeNumber FOREIGN KEY (EmployeeNumber)
REFERENCES tblEmployee(EmployeeNumber)
ON UPDATE CASCADE
ON DELETE CASCADE

--UPDATE tblEmployee SET EmployeeNumber = 9123 Where EmployeeNumber = 123
--DELETE tblEmployee Where EmployeeNumber = 123

SELECT E.EmployeeNumber, T.*
FROM tblEmployee as E
RIGHT JOIN tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
where T.Amount IN (-179.47, 786.22, -967.36, 957.03)

ROLLBACK TRAN

--Test Data
select * from tblEmployee where EmployeeNumber = 2001

select T.EmployeeNumber as TEmployeeNumber,
       E.EmployeeNumber as EEmployeeNumber,
	   sum(Amount) as SumAmount
from tblTransaction AS T
LEFT JOIN tblEmployee AS E
ON T.EmployeeNumber = E.EmployeeNumber
group by T.EmployeeNumber, E.EmployeeNumber
order by EEmployeeNumber

BEGIN TRAN
UPDATE tblEmployee
SET DateOfBirth = '2101-01-01'
output deleted.*, inserted.*
WHERE EmployeeNumber = 537
select * from tblEmployee ORDER BY DateOfBirth DESC
ROLLBACK TRAN

BEGIN TRAN
UPDATE tblEmployee
SET EmployeeGovernmentID = 'aaaa'
WHERE EmployeeNumber BETWEEN 530 AND 539
select * from tblEmployee ORDER BY EmployeeGovernmentID ASC
ROLLBACK TRAN
