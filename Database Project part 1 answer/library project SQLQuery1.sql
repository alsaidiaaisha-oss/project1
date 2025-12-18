create database libraryproject
use libraryproject


create table library (
          library_id int identity(1,1) primary key,
		  name varchar(100) not null unique,
		  location varchar(100) not null ,
		  contact_no varchar(50) not null ,
		  established_year int,
		  );

create table staff (
           staffid  int identity(1,1) primary key,
		   fullname varchar(100),
		   position varchar(100),
		   contactno varchar(50),
		   libraryid int not null
		   foreign key(libraryid) references library(library_id)
		     on delete cascade
			 on update cascade
			 );






create table book (
                  
				  bookid int primary key identity(1,1),
				  isbn varchar(50) not null unique,
				  title varchar(30) not null,
				  genre varchar(30) not null,
				  price decimal(9,2) check (price> 0),
				  shelflocation varchar(50) not null,
				  status varchar(50),
				  libraryid int not null,
				  check (genre in ('Fiction', 'Non-fiction', 'Reference', 'Children')),
				  foreign key(libraryid) references library(library_id)

				       on delete cascade
			           on update cascade
					   );


create table member (
            memberid int primary key identity(1,1),
			fullname varchar(50),
			emaill varchar(100) not null unique,
			phoneno varchar(50),
			startdate date not null,
			);


);
create table loan (
                loanid int identity(1,1) primary key,
				loandate date not null,
				duedate date not null,
				returndate date,
				status varchar(30) not null,
				bookid int not null,
				memberid INT NOT NULL,
				foreign key (bookid) references book(bookid),
				foreign key (memberid) references member(memberid)

	                    on delete cascade
			           on update cascade
);

create table payment (
                paymentid int identity(1,1) primary key,
				amount decimal(9,2) not null  check (amount >0 ),
				paymentdate date not null,
				method varchar(50),
				loanid int not null,
				foreign key (loanid) references loan(loanid)
				    on delete cascade
			         on update cascade
					 );


create table review (
             reviewid int primary key identity(1,1),
			 rating int not null check (rating between 1 and 5),
			 comments varchar(600),
			 reviewdate date not null,
			 memberid int not null,
			 bookid int not null,
			 foreign key(memberid) references member(memberid),
			 foreign key(bookid) references book(bookid)

			     on delete cascade
			         on update cascade
					 );
----------

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Book';
ALTER TABLE Book
ADD is_available BIT;
ALTER TABLE Book
ADD CONSTRAINT DF_Book_IsAvailable
DEFAULT 1 FOR is_available;
UPDATE Book
SET is_available = 1
WHERE is_available IS NULL;

ALTER TABLE Book
ALTER COLUMN is_available BIT NOT NULL;

-------
ALTER TABLE Loan
ADD CONSTRAINT DF_Loan_Status
DEFAULT 'Issued' FOR Status;

ALTER TABLE Review
ADD CONSTRAINT DF_Review_Comments
DEFAULT 'No comments' FOR Comments;

--------------------------------------------------------
select * from review

insert into library( name, location, contact_no, established_year)
values
('Central Library', 'Muscat', '24567890', 2000),
('Science Library', 'Sohar', '26894512', 2010);

insert into staff(fullname,position,contactno,libraryid) 
values
('Ahmed Al Said', 'Librarian', '91234567', 1),
('Fatma Al Harthy', 'Assistant', '92345678', 2);

insert into book(isbn,title,genre,shelflocation,status,libraryid)
values
('9780131103627', 'Database Systems', 'Reference', 45.50, 'A1', 1),
('9780321751041', 'Learning SQL', 'Non-fiction', 30.00, 'B2', 1),
('9780439708180', 'Harry Potter', 'Children', 25.00, 'C3', 2);

insert into member(fullname,emaill,phoneno,startdate)
values
('Ali Al Zadjali', 'ali@email.com', '91112233', '2024-01-01'),
('Mona Al Balushi', 'mona@email.com', '92223344', '2024-02-15');

insert into loan(loandate,duedate,memberid,bookid)
values
('2025-01-01', '2025-01-15', 1, 1),
('2025-01-05', '2025-01-20', 2, 3);

insert into payment(amount,paymentdate,method,loanid)
values
(5.00, '2025-01-10', 'Cash', 1),
(3.50, '2025-01-12', 'Card', 2);

insert into review(rating,reviewdate,memberid,bookid)
values
(5, '2025-01-20', 1, 1),
(4, '2025-01-22', 2, 3);
------------------------------------------------------------------


 -----Library Database – DQL & DML Tasks-----





---------- Library Database – DQL & DML Tasks------
----Display all book records------

select *from member
---Display each book’s title, genre, and availability.-----
select title, genre, is_available from book
----Display all member names, email, and membership start date.----------
select fullname,emaill,startdate from member
------Display each book’s title and price as BookPrice.----------
           select title ,price as BookPrice from book
------List books priced above 250 LE-----
  select * from book 
  where price > 250;
  -----------List members who joined before 2023----
  select * from member 
  where startdate   < '2023';
  -----Display books published after 2018------

  ------------Display books ordered by price descending----
  select * from book
    order by price desc
	--------------Display the maximum, minimum, and average book price----
	select 
	Max(price) as maxprice,
	Min(price) as minprice,
	Avg(price) as avgprice
	from book
	-----Display total number of books.------
	select count(*) as totalbook
	from book

	--------Display members with NULL email.-----
	select * from member 
	where emaill is null
	-----Display books whose title contains 'Data'--
	select *  from book
	where title like '%Data%'
	------DML---
	---- Insert yourself as a member (Member ID = 405)----
	-----dont answer-------
	
	set identity_insert member on;
insert into member(memberid,fullname,emaill,phoneno,startdate)
values
   (405,'Aaisha Alsaid','aa@email.com','9955213','2024-3-1');
   	set identity_insert member off;
   select* from member
   ---- Register yourself to borrow book ID 1011--
   select* from loan
   set identity_insert loan on;
INSERT INTO Loan (memberid, bookid, loandate, duedate, returndate)
VALUES (405, 1011, GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);


SET IDENTITY_INSERT Loan OFF;
EXEC sp_help Loan;
SET IDENTITY_INSERT Loan ON;

INSERT INTO Loan (loanid, memberid, bookid, loandate, duedate, returndate)
VALUES (9002, 405, 1011, GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);

SET IDENTITY_INSERT Loan OFF;
---------nsert another member with NULL email and phone----
----------Update the return date of your loan to today-------
select * from loan

 update loan
 set returndate = GETDATE()
 where memberid = 405
  and bookid= 3
  and returndate is null
  --------------------------- Increase book prices by 5% for books priced under 200.-----
  select * from book;
update book
set price = price * 1.05
where price < 200;
-----------Delete members who never borrowed a book----------



delete from member 
 where  memberid not  in (
    select distinct memberid
    from Loan
);
select * from member