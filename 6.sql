USE LibraryDB;
SELECT name 
FROM Members 
WHERE member_id = (
    SELECT member_id 
    FROM BorrowRecords 
    GROUP BY member_id 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);


SELECT * 
FROM Members 
WHERE member_id IN (
    SELECT DISTINCT member_id FROM BorrowRecords
);


SELECT * 
FROM Books b 
WHERE EXISTS (
    SELECT 1 
    FROM BorrowRecords br 
    WHERE br.book_id = b.book_id
);


SELECT * 
FROM Members m 
WHERE (
    SELECT COUNT(*) 
    FROM BorrowRecords br 
    WHERE br.member_id = m.member_id
) > 1;

SELECT 
    title,
    (SELECT COUNT(*) FROM BorrowRecords br WHERE br.book_id = b.book_id) AS borrow_count
FROM Books b;


SELECT m.name, br_count.total_borrows
FROM Members m
JOIN (
    SELECT member_id, COUNT(*) AS total_borrows
    FROM BorrowRecords
    GROUP BY member_id
) AS br_count
ON m.member_id = br_count.member_id;

SELECT title 
FROM Books 
WHERE book_id IN (
    SELECT book_id 
    FROM BorrowRecords 
    WHERE member_id = (
        SELECT member_id 
        FROM Members 
        ORDER BY join_date ASC 
        LIMIT 1
    )
);