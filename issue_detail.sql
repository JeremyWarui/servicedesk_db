-- fetch details of the issue

.headers on
.mode columns

SELECT
    i.ticket_no AS "Ticket No",
    i.title AS "Title",
    i.description AS "Description",
    s.name AS "Section",
    st.name AS "Status",
    a.technician_id AS "Assigned Technician",
    i.priority AS "Priority",
    i.location AS "Location",
    i.created_at AS "Created At"
FROM Issue i
JOIN Section s ON i.section_id = s.id
JOIN Status st ON i.status_id = st.id
LEFT JOIN Assignment a ON i.id = a.issue_id
WHERE i.ticket_no = 'TKT-00001'; --replace with desired ticket number