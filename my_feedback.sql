-- users feedback on an issue

.headers on
.mode columns

SELECT
    i.ticket_no AS "Ticket No",
    f.rating AS "Rating",
    i.title AS "Title",
    f.comment AS "Comment",
    reporter.name AS "Comment By",
    tech.name AS "Technician"
FROM Feedback f
JOIN Issue i ON f.issue_id = i.id
JOIN User reporter ON f.user_id = reporter.id
JOIN Assignment a ON i.id = a.issue_id
JOIN User tech ON a.technician_id = tech.id
WHERE f.user_id = 3; -- Replace 3 with the user's ID