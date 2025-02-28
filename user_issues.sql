-- fetch issues related to a single user

.headers on
.mode columns

SELECT i.ticket_no,
    i.title,
    i.description,
    i.created_at,
    st.name "Status",
    u.name "Reported By"
FROM Issue i
JOIN Status st ON i.status_id = st.id
JOIN User u ON i.created_by = u.id
WHERE i.created_by = 3;