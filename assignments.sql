-- fetch assignments

.header on
.mode columns

SELECT i.ticket_no "Ticket No",
    i.title "Title",
    i.priority "Priority",
    s.name "Section",
    reporter.name "Reported By",
    st.name "Status",
    tech.name "Assigned To"
FROM Assignment a
JOIN Issue i ON a.issue_id = i.id
JOIN Section s ON i.section_id = s.id
JOIN Status st ON a.status_id = st.id
JOIN User tech ON a.technician_id = tech.id
JOIN User reporter ON i.created_by = reporter.id;