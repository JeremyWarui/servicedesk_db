-- fetch tasks assigned to a technician

.headers on
.mode columns

SELECT
    i.ticket_no AS "Ticket No",
    i.title AS "Title",
    st.name AS "Status"
FROM Issue i
JOIN Assignment a ON i.id = a.issue_id
JOIN Status st ON a.status_id = st.id
WHERE a.technician_id = 2; -- Replace 2 with the technician's ID