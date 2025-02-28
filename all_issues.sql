-- fetch all issues

.headers on
.mode columns

SELECT i.ticket_no "Ticket No",
    i.title "Title",
    s.name "Section",
    reporter.name "Reported By",
    st.name "Status",
    tech.name "Assigned Technician",
    i.priority "Priority",
    i.location "Location",
    i.created_at "Created At"
FROM Issue i
JOIN Section s ON i.section_id = s.id
JOIN User reporter ON i.created_by = reporter.id
JOIN Assignment a ON i.id = a.issue_id
JOIN User tech ON a.technician_id = tech.id
JOIN Status st ON i.status_id = st.id;