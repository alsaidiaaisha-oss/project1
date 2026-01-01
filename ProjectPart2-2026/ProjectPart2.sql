create database Project_Part2
use Project_Part2

CREATE TABLE Library (
    LibraryID INT PRIMARY KEY,
    LibraryName VARCHAR(100)
);
CREATE TABLE Genre (
    GenreID INT PRIMARY KEY,
    GenreName VARCHAR(50)
);
CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    ISBN VARCHAR(20),
    GenreID INT,
    LibraryID INT,
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
);
CREATE TABLE Member (
    MemberID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20)
);
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Position VARCHAR(50),
    LibraryID INT,
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
);
CREATE TABLE Loan (
    LoanID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    LoanDate DATE,
    DueDate DATE,
    ReturnDate DATE NULL,
    Status VARCHAR(20),
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
);
CREATE TABLE Review (
    ReviewID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    Rating INT,
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
);
CREATE TABLE FinePayment (
    PaymentID INT PRIMARY KEY,
    LoanID INT,
    Amount DECIMAL(10,2),
    FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
);
INSERT INTO Library VALUES
(1,'Central Library'),
(2,'City Branch'),
(3,'University Library');

INSERT INTO Genre VALUES
(1, 'Fiction'),
(2, 'Science'),
(3, 'History');
INSERT INTO Book (BookID, Title, ISBN, GenreID, LibraryID) VALUES
(1, 'The Great Gatsby', 'ISBN001', 1, 1),
(2, 'To Kill a Mockingbird', 'ISBN002', 1, 1),
(3, '1984', 'ISBN003', 1, 1),
(4, 'Physics Basics', 'ISBN004', 2, 1),
(5, 'Chemistry 101', 'ISBN005', 2, 1),
(6, 'Biology Fundamentals', 'ISBN006', 2, 2),
(7, 'World History', 'ISBN007', 3, 2),
(8, 'Ancient Civilizations', 'ISBN008', 3, 2),
(9, 'Modern Science', 'ISBN009', 2, 2),
(10, 'Astronomy Today', 'ISBN010', 2, 3),
(11, 'Fictional Tales', 'ISBN011', 1, 3),
(12, 'Classic Literature', 'ISBN012', 1, 3),
(13, 'Mathematics Essentials', 'ISBN013', 2, 3),
(14, 'European History', 'ISBN014', 3, 1),
(15, 'American History', 'ISBN015', 3, 1),
(16, 'Poetry Anthology', 'ISBN016', 1, 2),
(17, 'Environmental Science', 'ISBN017', 2, 2),
(18, 'Civil War Studies', 'ISBN018', 3, 3),
(19, 'Modern Novels', 'ISBN019', 1, 3),
(20, 'Genetics Today', 'ISBN020', 2, 3);

INSERT INTO Member VALUES
(1,'Ali Ahmed','ali@mail.com','9001'),
(2,'Sara Hassan','sara@mail.com','9002'),
(3,'Omar Khalid','omar@mail.com','9003'),
(4,'Aisha Noor','aisha@mail.com','9004'),
(5,'Hassan Ali','hassan@mail.com','9005'),
(6,'Fatima Saleh','fatima@mail.com','9006'),
(7,'Mona Said','mona@mail.com','9007'),
(8,'Yousef Adam','yousef@mail.com','9008'),
(9,'Noura Saeed','noura@mail.com','9009'),
(10,'Salim Rashid','salim@mail.com','9010');
INSERT INTO Staff VALUES
(1, 'Omar Saleh', 'Manager', 1),
(2, 'Fatima Noor', 'Librarian', 2);


INSERT INTO Loan (LoanID, BookID, MemberID, LoanDate, DueDate, ReturnDate, Status) VALUES
(1, 1, 1, '2025-01-01', '2025-01-10', '2025-01-09', 'Returned'),
(2, 2, 1, '2025-01-05', '2025-01-15', NULL, 'Issued'),
(3, 3, 2, '2025-01-02', '2025-01-12', NULL, 'Overdue'),
(4, 1, 2, '2025-01-03', '2025-01-13', '2025-01-12', 'Returned'),
(5, 1, 1, '2025-01-20', '2025-01-30', NULL, 'Issued'),
(6, 2, 1, '2025-01-01', '2025-01-10', '2025-01-09', 'Returned'),
(7, 1, 2, '2025-01-02', '2025-01-12', NULL, 'Issued'),
(8, 2, 3, '2025-01-03', '2025-01-13', NULL, 'Overdue'),
(9, 2, 1, '2025-01-05', '2025-01-15', NULL, 'Issued'),
(10, 3, 2, '2025-01-12', '2025-01-12', NULL, 'Overdue'),
(11, 1, 2, '2025-01-15', '2025-01-13', '2025-01-12', 'Returned'),
(12, 1, 1, '2025-01-19', '2025-01-30', NULL, 'Issued'),
(13, 2, 1, '2025-01-07', '2025-01-10', '2025-01-09', 'Returned'),
(14, 1, 2, '2025-01-12', '2025-01-12', NULL, 'Issued'),
(15, 2, 3, '2025-01-08', '2025-01-13', NULL, 'Overdue');

SELECT * FROM Book;
INSERT INTO Review VALUES
(1, 1, 1, 5),
(2, 1, 2, 4),
(3, 2, 1, 3);

INSERT INTO FinePayment VALUES
(1, 3, 10.00),
(2, 3, 5.00);
---Section 1------

SELECT l.LibraryName,
       COUNT(b.BookID) TotalBooks,
       COUNT(CASE WHEN ln.Status='Returned' THEN 1 END) AvailableBooks,
       COUNT(CASE WHEN ln.Status IN ('Issued','Overdue') THEN 1 END) BooksOnLoan
FROM Library l
LEFT JOIN Book b ON l.LibraryID=b.LibraryID
LEFT JOIN Loan ln ON b.BookID=ln.BookID
GROUP BY l.LibraryName;

SELECT 
    m.FullName AS MemberName,
    m.Email,
    b.Title AS BookTitle,
    ln.LoanDate,
    ln.DueDate,
    ln.Status
FROM Loan ln
JOIN Member m ON ln.MemberID = m.MemberID
JOIN Book b ON ln.BookID = b.BookID
WHERE ln.Status IN ('Issued', 'Overdue');

DELETE FROM FinePayment;
DELETE FROM Review;

DELETE FROM Loan;
DELETE FROM Book;
DELETE FROM Staff;
DELETE FROM Member;
DELETE FROM Library;

select * from Library
select * from Book
select * from Genre
select * from Loan
select * from Staff
select * from Member
select * from Review
select * from FinePayment
SELECT 
    m.FullName AS MemberName,
    m.Phone,
    b.Title AS BookTitle,
    l.LibraryName,
    DATEDIFF(DAY, ln.DueDate, GETDATE()) AS DaysOverdue,
    ISNULL(SUM(fp.Amount), 0) AS FinePaid
FROM Loan ln
JOIN Member m ON ln.MemberID = m.MemberID
JOIN Book b ON ln.BookID = b.BookID
JOIN Library l ON b.LibraryID = l.LibraryID
LEFT JOIN FinePayment fp ON ln.LoanID = fp.LoanID
WHERE ln.Status = 'Overdue'
GROUP BY 
    m.FullName, m.Phone, b.Title, l.LibraryName, ln.DueDate;
SELECT 
    l.LibraryName,
    s.FullName AS StaffName,
    s.Position,
    COUNT(b.BookID) AS BooksManaged
FROM Staff s
JOIN Library l ON s.LibraryID = l.LibraryID
LEFT JOIN Book b ON l.LibraryID = b.LibraryID
GROUP BY 
    l.LibraryName, s.FullName, s.Position;

SELECT 
    b.Title,        ---from Book table
    b.ISBN,
    g.GenreName,           ---from Book Genre   
    COUNT(ln.LoanID) AS TimesLoaned,
    AVG(r.Rating) AS AvgRating
FROM Book b
JOIN Genre g ON b.GenreID = g.GenreID
JOIN Loan ln ON b.BookID = ln.BookID
LEFT JOIN Review r ON b.BookID = r.BookID
GROUP BY 
    b.Title, b.ISBN, g.GenreName
HAVING COUNT(ln.LoanID) >= 3;



SELECT 
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    ln.LoanDate,
    ln.ReturnDate,
    r.Rating,
    r.ReviewID
FROM Member m
JOIN Loan ln ON m.MemberID = ln.MemberID
JOIN Book b ON ln.BookID = b.BookID
LEFT JOIN Review r 
    ON r.BookID = b.BookID 
   AND r.MemberID = m.MemberID
ORDER BY 
    m.FullName, ln.LoanDate;
SELECT 
    g.GenreName,
    COUNT(ln.LoanID) AS TotalLoans,
    SUM(ISNULL(fp.Amount, 0)) AS TotalFineCollected,
    AVG(ISNULL(fp.Amount, 0)) AS AvgFinePerLoan
FROM Genre g
JOIN Book b ON g.GenreID = b.GenreID
JOIN Loan ln ON b.BookID = ln.BookID
LEFT JOIN FinePayment fp ON ln.LoanID = fp.LoanID
GROUP BY g.GenreName;

------Section 2------


SELECT 
    DATENAME(MONTH, LoanDate) AS MonthName,
    COUNT(*) AS TotalLoans,
    SUM(CASE WHEN ReturnDate IS NOT NULL THEN 1 ELSE 0 END) AS TotalReturned,
    SUM(CASE WHEN ReturnDate IS NULL AND DueDate < GETDATE() THEN 1 ELSE 0 END) AS TotalOverdue
FROM Loan
WHERE YEAR(LoanDate) = YEAR(GETDATE())
GROUP BY DATENAME(MONTH, LoanDate), MONTH(LoanDate)
ORDER BY MONTH(LoanDate);


SELECT 
    m.FullName,
    COUNT(l.LoanID) AS TotalBooksBorrowed,
    SUM(CASE WHEN l.ReturnDate IS NULL THEN 1 ELSE 0 END) AS BooksCurrentlyOnLoan,
    ISNULL(SUM(p.Amount), 0) AS TotalFinesPaid,
    ISNULL(AVG(r.Rating), 0) AS AvgRating
FROM Member m
JOIN Loan l ON m.MemberID = l.MemberID
LEFT JOIN FinePayment p ON l.LoanID= p.LoanID
LEFT JOIN Review r ON m.MemberID = r.MemberID
GROUP BY m.FullName
HAVING COUNT(l.LoanID) >= 1;
select *from FinePayment

SELECT 
    lib.LibraryName,
    COUNT(b.BookID) AS TotalBooksOwned,
    COUNT(DISTINCT l.MemberID) AS TotalActiveMembers,
    ISNULL(SUM(p.Amount), 0) AS TotalRevenue
FROM Library lib
LEFT JOIN Book b ON lib.LibraryID = b.LibraryID
LEFT JOIN Loan l ON b.BookID = l.BookID
LEFT JOIN FinePayment p ON l.LoanID = p.LoanID
GROUP BY lib.LibraryName;
select * from book
SELECT 
    b.Title,
    b.GenreID,
    b.Price,
    AVG(b2.Price) AS GenreAvgPrice,
    b.Price - AVG(b2.Price) AS DiffFromAvg
FROM Book b
JOIN Book b2 ON b.GenreID = b2.GenreID
GROUP BY b.BookID, b.Title, b.GenreID, b.Price
HAVING b.Price > AVG(b2.Price);

SELECT * FROM Book;
ALTER TABLE Book
ADD Price DECIMAL(10,2);
UPDATE Book SET Price = 12.50 WHERE BookID = 1;
UPDATE Book SET Price = 15.00 WHERE BookID = 2;
UPDATE Book SET Price = 10.00 WHERE BookID = 3;
UPDATE Book SET Price = 20.00 WHERE BookID = 4;
UPDATE Book SET Price = 18.00 WHERE BookID = 5;
UPDATE Book SET Price = 22.00 WHERE BookID = 6;
UPDATE Book SET Price = 14.00 WHERE BookID = 7;
UPDATE Book SET Price = 16.50 WHERE BookID = 8;
UPDATE Book SET Price = 19.00 WHERE BookID = 9;
UPDATE Book SET Price = 11.00 WHERE BookID = 10;
UPDATE Book SET Price = 24.00 WHERE BookID = 11;
UPDATE Book SET Price = 13.75 WHERE BookID = 12;
UPDATE Book SET Price = 17.25 WHERE BookID = 13;
UPDATE Book SET Price = 21.00 WHERE BookID = 14;
UPDATE Book SET Price = 9.50  WHERE BookID = 15;
UPDATE Book SET Price = 26.00 WHERE BookID = 16;
UPDATE Book SET Price = 18.75 WHERE BookID = 17;
UPDATE Book SET Price = 23.50 WHERE BookID = 18;
UPDATE Book SET Price = 14.25 WHERE BookID = 19;
UPDATE Book SET Price = 27.00 WHERE BookID = 20;


select*from FinePayment
ALTER TABLE FinePayment
ADD PaymentMethod VARCHAR(20);
UPDATE FinePayment SET PaymentMethod = 'Cash' WHERE PaymentID = 1;
UPDATE FinePayment SET PaymentMethod = 'Card' WHERE PaymentID = 2;

SELECT 
    PaymentMethod,
    COUNT(*) AS NumTransactions,
    SUM(Amount) AS TotalCollected,
    AVG(Amount) AS AvgPayment,
    CAST(
        SUM(Amount) * 100.0 /
        (SELECT SUM(Amount) FROM FinePayment)
        AS DECIMAL(5,2)
    ) AS PercentOfTotalRevenue
FROM FinePayment
GROUP BY PaymentMethod
ORDER BY TotalCollected DESC;

-------Section 3------
select *from Book
select *from Loan
select *from Member




CREATE VIEW vw_CurrentLoans
AS
SELECT
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    l.LoanDate,
    l.DueDate,

    -- Status of the loan
    CASE 
        WHEN l.DueDate < GETDATE() THEN 'Overdue'
        ELSE 'Issued'
    END AS LoanStatus,

    -- Days left or overdue
    DATEDIFF(DAY, GETDATE(), l.DueDate) AS DaysLeft

FROM Loan l
JOIN Member m ON l.MemberID = m.MemberID
JOIN Book b ON l.BookID = b.BookID
WHERE l.ReturnDate IS NULL;

select *from vw_CurrentLoans
-----
select * from Library
select * from Book
select * from Member
select * from Loan
select * from vw_LibraryPerformance



CREATE VIEW vw_LibraryPerformance
AS
SELECT
    lib.LibraryName,

     -- Total books owned
    COUNT(DISTINCT b.BookID) AS TotalBooksOwned,

    -- Available books (not currently loaned)
    COUNT(DISTINCT CASE 
        WHEN l.LoanID IS NULL THEN b.BookID 
    END) AS AvailableBooks,

    -- Active members (borrowed books from this library)
    COUNT(DISTINCT l.MemberID) AS TotalActiveMembers,

    -- Active loans for this library
    COUNT(DISTINCT l.LoanID) AS ActiveLoans,

    -- Total staff
    COUNT(DISTINCT s.StaffID) AS TotalStaff,

    -- Total revenue from fines
    ISNULL(SUM(fp.Amount), 0) AS TotalFineRevenue

FROM Library lib
LEFT JOIN Book b ON lib.LibraryID = b.LibraryID
LEFT JOIN Loan l 
    ON b.BookID = l.BookID 
    AND l.ReturnDate IS NULL
LEFT JOIN Staff s ON lib.LibraryID = s.LibraryID
LEFT JOIN FinePayment fp ON l.LoanID = fp.LoanID

GROUP BY lib.LibraryName;

----------

select * from Book
select * from Loan
select * from Review

select * from vw_BookDetailsWithReviews


CREATE VIEW vw_BookDetailsWithReviews
AS
SELECT
    b.BookID,
    b.Title,
    b.ISBN,

    -- Review information
    ISNULL(AVG(r.Rating), 0) AS AvgRating,
    COUNT(r.ReviewID) AS TotalReviews,
    MAX(r.ReviewDate) AS LatestReviewDate,

    -- Availability status
    CASE 
        WHEN COUNT(l.LoanID) > 0 THEN 'On Loan'
        ELSE 'Available'
    END AS AvailabilityStatus

FROM Book b
LEFT JOIN Review r ON b.BookID = r.BookID
LEFT JOIN Loan l 
    ON b.BookID = l.BookID 
    AND l.ReturnDate IS NULL

GROUP BY b.BookID, b.Title, b.ISBN;

ALTER TABLE Review
ADD ReviewDate DATE;
UPDATE Review SET ReviewDate = '2025-12-01' WHERE ReviewID = 1;
UPDATE Review SET ReviewDate = '2025-12-03' WHERE ReviewID = 2;
UPDATE Review SET ReviewDate = '2025-12-04' WHERE ReviewID = 3;
-----------Section 4---
CREATE PROCEDURE sp_IssueBook
    @MemberID INT,
    @BookID INT,
    @DueDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if book exists and is available
    IF NOT EXISTS (
        SELECT 1 FROM Book
        WHERE BookID = @BookID AND Status = 'Available'
    )
    BEGIN
        PRINT 'Error: Book is not available.';
        RETURN;
    END

    -- Check if member has overdue loans
    IF EXISTS (
        SELECT 1 FROM Loan
        WHERE MemberID = @MemberID AND Status = 'Overdue'
    )
    BEGIN
        PRINT 'Error: Member has overdue loans.';
        RETURN;
    END

    -- Create new loan
    INSERT INTO Loan (LoanID, BookID, MemberID, LoanDate, DueDate, Status)
    VALUES (
        (SELECT ISNULL(MAX(LoanID),0)+1 FROM Loan),
        @BookID,
        @MemberID,
        GETDATE(),
        @DueDate,
        'Issued'
    );

    -- Update book status
    UPDATE Book
    SET Status = 'Issued'
    WHERE BookID = @BookID;

    PRINT 'Book issued successfully.';
END;
GO
ALTER TABLE Book
ADD Status VARCHAR(20) DEFAULT 'Available';


select * from Book
UPDATE Book SET Status = 'Available' WHERE BookID BETWEEN 1 AND 10;
UPDATE Book SET Status = 'Issued'    WHERE BookID BETWEEN 11 AND 20;
SELECT * FROM Book WHERE BookID = @BookID;


CREATE PROCEDURE sp_ReturnBook
    @LoanID INT,
    @ReturnDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @BookID INT;
    DECLARE @DueDate DATE;
    DECLARE @OverdueDays INT;
    DECLARE @FineAmount DECIMAL(10,2) = 0;

    -- 1. Get book and due date
    SELECT @BookID = BookID, @DueDate = DueDate
    FROM Loan
    WHERE LoanID = @LoanID;

    IF @BookID IS NULL
    BEGIN
        RAISERROR('Loan not found', 16, 1);
        RETURN;
    END

    -- 2. Update loan
    UPDATE Loan
    SET ReturnDate = @ReturnDate,
        Status = 'Returned'
    WHERE LoanID = @LoanID;

    -- 3. Update book
    UPDATE Book
    SET Status = 'Available'
    WHERE BookID = @BookID;

    -- 4. Calculate fine ($2 per day overdue)
    SET @OverdueDays = DATEDIFF(DAY, @DueDate, @ReturnDate);

    IF @OverdueDays > 0
    BEGIN
        SET @FineAmount = @OverdueDays * 2;

        -- 5. Create payment record
        INSERT INTO Payment (LoanID, Amount, Status)
        VALUES (@LoanID, @FineAmount, 'Pending');
    END

    -- 6. Return fine as result set
    SELECT 
        @LoanID AS LoanID,
        @BookID AS BookID,
        @OverdueDays AS OverdueDays,
        @FineAmount AS FineAmount,
        CASE WHEN @FineAmount > 0 THEN 'Pending Payment' ELSE 'No Fine' END AS PaymentStatus;
END;
GO

------
select * from Loan
ALTER PROCEDURE sp_GetMemberReport
    @MemberID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1️⃣ Member Basic Information
    SELECT MemberID, FullName, Phone, Email
    FROM Member
    WHERE MemberID = @MemberID;

    -- 2️⃣ Current Loans (not yet returned)
    SELECT 
        l.LoanID,
        b.BookID,
        b.Title,
        l.LoanDate,
        l.DueDate,
        l.Status
    FROM Loan l
    JOIN Book b ON l.BookID = b.BookID
    WHERE l.MemberID = @MemberID
      AND l.Status = 'Issued';

    -- 3️⃣ Loan History (all loans)
    SELECT 
        l.LoanID,
        b.BookID,
        b.Title,
        l.LoanDate,
        l.DueDate,
        l.ReturnDate,
        l.Status
    FROM Loan l
    JOIN Book b ON l.BookID = b.BookID
    WHERE l.MemberID = @MemberID
    ORDER BY l.LoanDate DESC;

    -- 4️⃣ Total fines paid and pending
    SELECT
        SUM(CASE WHEN p.Status = 'Paid' THEN p.Amount ELSE 0 END) AS TotalPaid,
        SUM(CASE WHEN p.Status = 'Pending' THEN p.Amount ELSE 0 END) AS PendingFines
    FROM Loan l
    LEFT JOIN Payment p ON l.LoanID = p.LoanID
    WHERE l.MemberID = @MemberID;

    -- 5️⃣ Reviews written by the member
    SELECT 
        r.ReviewID,
        r.BookID,
        b.Title,
        r.Rating,
        r.Comment,
        r.ReviewDate
    FROM Review r
    JOIN Book b ON r.BookID = b.BookID
    WHERE r.MemberID = @MemberID
    ORDER BY r.ReviewDate DESC;
END;
GO
ALTER TABLE Review
ADD Comment VARCHAR(255);
select *from Review
UPDATE Review
SET Comment = CASE ReviewID
    WHEN 1 THEN 'Amazing book!'
    WHEN 2 THEN 'Very informative.'
    WHEN 3 THEN 'Average content.'
    ELSE 'No comment'
END;

-------
select * from Genre
CREATE PROCEDURE sp_MonthlyLibraryReport
    @LibraryID INT,
    @Month INT,
    @Year INT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Total loans issued in that month
    SELECT COUNT(*) AS TotalLoans
    FROM Loan L
    JOIN Book B ON L.BookID = B.BookID
    WHERE B.LibraryID = @LibraryID
      AND MONTH(L.LoanDate) = @Month
      AND YEAR(L.LoanDate) = @Year;

    -- 2. Total books returned in that month
    SELECT COUNT(*) AS TotalReturned
    FROM Loan L
    JOIN Book B ON L.BookID = B.BookID
    WHERE B.LibraryID = @LibraryID
      AND L.ReturnDate IS NOT NULL
      AND MONTH(L.ReturnDate) = @Month
      AND YEAR(L.ReturnDate) = @Year;

    -- 3. Total revenue collected
    SELECT ISNULL(SUM(P.Amount), 0) AS TotalRevenue
    FROM Payment P
    JOIN Loan L ON P.LoanID = L.LoanID
    JOIN Book B ON L.BookID = B.BookID
    WHERE B.LibraryID = @LibraryID
      AND MONTH(P.PaymentDate) = @Month
      AND YEAR(P.PaymentDate) = @Year
      AND P.Status = 'Paid';

    -- 4. Most borrowed genre
    SELECT TOP 1
        G.GenreName,
        COUNT(*) AS BorrowCount
    FROM Loan L
    JOIN Book B ON L.BookID = B.BookID
    JOIN Genre G ON B.GenreID = G.GenreID
    WHERE B.LibraryID = @LibraryID
      AND MONTH(L.LoanDate) = @Month
      AND YEAR(L.LoanDate) = @Year
    GROUP BY G.GenreName
    ORDER BY COUNT(*) DESC;

    -- 5. Top 3 most active members
    SELECT TOP 3
        M.MemberID,
        M.FullName,
        COUNT(*) AS LoanCount
    FROM Loan L
    JOIN Book B ON L.BookID = B.BookID
    JOIN Member M ON L.MemberID = M.MemberID
    WHERE B.LibraryID = @LibraryID
      AND MONTH(L.LoanDate) = @Month
      AND YEAR(L.LoanDate) = @Year
    GROUP BY M.MemberID, M.FullName
    ORDER BY COUNT(*) DESC;
END;
GO


ALTER TABLE Book
ADD GenreID INT;
select *from Book
select *from Genre


