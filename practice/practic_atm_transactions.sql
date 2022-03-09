use Lab_5
GO
--1)
drop table if exists transactions
drop table if exists cards 
drop table if exists accounts 
drop table if exists atms
drop table if exists customers 

create table customers(
	cid int primary key identity (1,1),
	cname varchar(100),
	dob varchar(10)
);


create table atms(
	atid int primary key identity (1,1),
	addr varchar(100)
);

create table accounts(
	aid int primary key identity (1,1),
	iban varchar (20), 
	balance int,
	holder INT FOREIGN KEY REFERENCES customers(cid)
);  

create table cards(
	cid int primary key identity (1,1),
	number varchar(20) ,
	cvv int, 
	account int foreign key references accounts(aid)
);

create table transactions(
	tid int primary key identity(1,1),
	trans_time datetime,
	moneyy int, 
	
	atm int foreign key references atms(atid),
	cardId int foreign key references cards(cid)
);

GO


insert into customers values ('alex', '10-8-2010')
insert into customers values ('alin', '10-8-2010')
insert into customers values ('magda', '10-8-2010')
insert into atms values ('al vaida voievod')
insert into atms values ('al vaida voievod2')
insert into accounts values ('123',100,1)
insert into accounts values ('456',999,2)
insert into accounts values ('457',923, 3)
insert into cards values ('12313',313, 2)
insert into cards values ('5444' ,2132,1)
insert into cards values ('2356' ,2192, 4)
insert into transactions values ('01/01/98 23:59:59.999', 4000,1, 1)
insert into transactions values ('01/01/98 23:59:59.999', 10, 1, 1)
insert into transactions values ('08/02/90 23:59:59.999', 1999, 2, 2)
insert into transactions values ('08/02/90 23:59:59.999', 1999, 1, 2)
insert into transactions values ('08/02/91 23:59:59.999', 1979, 2, 5)
insert into transactions values ('08/02/21 23:59:59.999', 2001, 1, 5)

GO

select * from cards
select * from accounts
select * from transactions
go

--2)
CREATE OR ALTER PROC uspDeleteCardTransactions @cid INT 
AS
	DELETE 
	FROM transactions
	WHERE cardId = @cid
GO

exec uspDeleteCardTransactions 5;

select * from transactions
go


--3)
go

create or alter view Allcards
as
	select c.number
	from cards c
	where c.cid in
		(select t.cardId
		from transactions t inner join atms a on t.atm=a.atid)
go

create or alter view Allcards2
as
	select c.number
	from cards c
	where (select count(*) from atms) = 
		(select count(distinct t.atm) 
		from atms a inner join transactions t on t.atm = a.atid
		where t.cardId = c.cid)
go

select * from Allcards
select * from Allcards2



--4)
go
create or alter function listCards (@sum int) RETURNS TABLE 
as 
return 
	(
		select c.number, c.cvv
		from transactions t
		inner join cards c on t.cardId=c.cid
		group by c.number, c.cvv
		having sum(t.moneyy)>@sum
	);

go

select * from listCards(2000)