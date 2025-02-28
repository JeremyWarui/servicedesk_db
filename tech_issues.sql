-- fetch issues assigned to specific technician

.headers on
.mode columns

SELECT i.ticket_no,
    i.title,
    i.description,
    reporter.name "Reported By",
    st.name "Status",
    s.name "Section",
    tech.name "Assigned To",
    a.assigned_at "Assigned At"
FROM Assignment a
JOIN User tech ON a.technician_id = tech.id
JOIN User reporter ON i.created_by = reporter.id
JOIN Issue i ON a.issue_id = i.id
JOIN Section s ON i.section_id = s.id
JOIN Status st ON i.status_id = st.id
WHERE tech.name = 'Bob Technician';