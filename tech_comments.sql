-- fetch tech comments
.headers on
.mode columns

-- comment_text, issue_id, created_by

SELECT
    i.ticket_no AS "Ticket No",
    i.title AS "Title",
    i.description AS "Description",
    c.comment_text AS "Comment",
    u.name AS "Comment By"
FROM Comments c
JOIN User u ON c.created_by = u.id
JOIN Issue i ON c.issue_id = i.id
JOIN Assignment a ON i.id = a.issue_id
WHERE u.id = 4 AND i.id = 2;