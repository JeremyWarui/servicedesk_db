-- Sample Data for Role Table
INSERT INTO Role (role_name) VALUES ('Admin');
INSERT INTO Role (role_name) VALUES ('Technician');
INSERT INTO Role (role_name) VALUES ('User');

-- Expanded Sample Data for Section Table
INSERT INTO Section (name) VALUES ('Electrical');
INSERT INTO Section (name) VALUES ('Plumbing');
INSERT INTO Section (name) VALUES ('HVAC');
INSERT INTO Section (name) VALUES ('Carpentry');
INSERT INTO Section (name) VALUES ('Painting');
INSERT INTO Section (name) VALUES ('Landscaping');
INSERT INTO Section (name) VALUES ('IT Support');
INSERT INTO Section (name) VALUES ('General Maintenance');

-- Sample Data for User Table
INSERT INTO User (name, username, password, email, role_id, section_id) VALUES ('Alice Admin', 'alice', 'password123', 'alice@example.com', 1, NULL);
INSERT INTO User (name, username, password, email, role_id, section_id) VALUES ('Bob Technician', 'bob', 'securepass', 'bob@example.com', 2, 1);
INSERT INTO User (name, username, password, email, role_id, section_id) VALUES ('Charlie User', 'charlie', 'mysecret', 'charlie@example.com', 3, NULL);
INSERT INTO User (name, username, password, email, role_id, section_id) VALUES ('David Technician', 'david', 'securepass', 'david@example.com', 2, 2);
INSERT INTO User (name, username, password, email, role_id, section_id) VALUES ('Eve Painter', 'eve', 'strongpass', 'eve@example.com', 2, 5);
INSERT INTO User (name, username, password, email, role_id, section_id) VALUES ('Frank Landscaper', 'frank', 'gardenpass', 'frank@example.com', 2, 6);
INSERT INTO User (name, username, password, email, role_id, section_id) VALUES ('Grace IT', 'grace', 'techpass', 'grace@example.com', 2, 7);
INSERT INTO User (name, username, password, email, role_id, section_id) VALUES ('Henry General', 'henry', 'fixitpass', 'henry@example.com', 2, 8);
INSERT INTO User (name, username, password, email, role_id, section_id) VALUES ('Ivy User', 'ivy', 'userpass', 'ivy@example.com', 3, NULL);
INSERT INTO User (name, username, password, email, role_id, section_id) VALUES ('Jack User', 'jack', 'userpass', 'jack@example.com', 3, NULL);

-- Sample Data for Status Table
INSERT INTO Status (name, status_type, visibility, description) VALUES ('Open', 'open', 'user', 'Issue reported and awaiting assignment.');
INSERT INTO Status (name, status_type, visibility, description) VALUES ('In Progress', 'in_progress', 'user', 'Technician assigned and working on the issue.');
INSERT INTO Status (name, status_type, visibility, description) VALUES ('Resolved', 'resolved', 'user', 'Issue resolved.');
INSERT INTO Status (name, status_type, visibility, description) VALUES ('Pending', 'pending', 'admin', 'Issue pending admin approval.');

-- Sample Data for Request Table
INSERT INTO Request (user_id, submission_notes) VALUES (3, 'Multiple issues in the office.');
INSERT INTO Request (user_id, submission_notes) VALUES (3, 'Leaky faucet in the bathroom.');
INSERT INTO Request (user_id, submission_notes) VALUES (5, 'Office needs painting.');
INSERT INTO Request (user_id, submission_notes) VALUES (6, 'Network issues in the conference room.');

-- Sample Data for Issue Table
INSERT INTO Issue (request_id, title, description, section_id, created_by, status_id, priority, location) VALUES (1, 'Lights Flickering', 'Office lights flickering intermittently.', 1, 3, 1, 'Medium', 'Office 101');
INSERT INTO Issue (request_id, title, description, section_id, created_by, status_id, priority, location) VALUES (1, 'AC Not Working', 'AC unit not cooling the office.', 3, 3, 1, 'High', 'Office 102');
INSERT INTO Issue (request_id, title, description, section_id, created_by, status_id, priority, location) VALUES (2, 'Leaky Faucet', 'Bathroom faucet leaking.', 2, 3, 1, 'Low', 'Bathroom 201');
INSERT INTO Issue (request_id, title, description, section_id, created_by, status_id, priority, location) VALUES (3, 'Wall Needs Painting', 'Wall in the lobby needs repainting.', 5, 5, 1, 'Medium', 'Lobby');
INSERT INTO Issue (request_id, title, description, section_id, created_by, status_id, priority, location) VALUES (4, 'Network Down', 'Network down in the conference room.', 7, 6, 1, 'High', 'Conference Room');
INSERT INTO Issue (request_id, title, description, section_id, created_by, status_id, priority, location) VALUES (1, 'Door Handle Broken', 'Door handle in office 103 is broken.', 4, 3, 1, 'Low', 'Office 103');
INSERT INTO Issue (request_id, title, description, section_id, created_by, status_id, priority, location) VALUES (2, 'Garden Overgrown', 'Garden needs trimming and maintenance.', 6, 3, 1, 'Medium', 'Back Garden');
INSERT INTO Issue (request_id, title, description, section_id, created_by, status_id, priority, location) VALUES (1, 'General Repair', 'General repair needed in the break room.', 8, 3, 1, 'Low', 'Break Room');

-- Sample Data for Assignment Table
INSERT INTO Assignment (issue_id, technician_id, status_id) VALUES (1, 2, 2);
INSERT INTO Assignment (issue_id, technician_id, status_id) VALUES (2, 4, 2);
INSERT INTO Assignment (issue_id, technician_id, status_id) VALUES (4, 7, 2);
INSERT INTO Assignment (issue_id, technician_id, status_id) VALUES (5, 5, 2);
INSERT INTO Assignment (issue_id, technician_id, status_id) VALUES (6, 4, 2);
INSERT INTO Assignment (issue_id, technician_id, status_id) VALUES (7, 6, 2);
INSERT INTO Assignment (issue_id, technician_id, status_id) VALUES (8, 8, 2);

-- Sample Data for Comments Table
INSERT INTO Comments (comment_text, issue_id, created_by) VALUES ('Checking the circuit breaker.', 2, 4);
INSERT INTO Comments (comment_text, issue_id, created_by) VALUES ('Need to replace the AC filter.', 2, 4);
INSERT INTO Comments (comment_text, issue_id, created_by) VALUES ('Checking the pipes.', 3, 4);
INSERT INTO Comments (comment_text, issue_id, created_by) VALUES ('Ordering paint for the wall.', 5, 5);
INSERT INTO Comments (comment_text, issue_id, created_by) VALUES ('Checking the network cables.', 4, 7);
INSERT INTO Comments (comment_text, issue_id, created_by) VALUES ('Replacing the door handle.', 6, 4);
INSERT INTO Comments (comment_text, issue_id, created_by) VALUES ('Trimming the hedges.', 7, 6);
INSERT INTO Comments (comment_text, issue_id, created_by) VALUES ('Fixing the broken shelf.', 8, 8);

-- Sample Data for Feedback Table
INSERT INTO Feedback (rating, user_id, issue_id, comment, assignment_id) VALUES (4, 3, 2, 'Good job fixing the AC.', 2);
INSERT INTO Feedback (rating, user_id, issue_id, comment, assignment_id) VALUES (5, 3, 3, 'Fast and efficient.', 3);
INSERT INTO Feedback (rating, user_id, issue_id, comment, assignment_id) VALUES (5, 5, 5, 'Wall looks great!', 5);
INSERT INTO Feedback (rating, user_id, issue_id, comment, assignment_id) VALUES (4, 6, 4, 'Network is working now.', 4);
INSERT INTO Feedback (rating, user_id, issue_id, comment, assignment_id) VALUES (3, 3, 6, 'Door handle fixed, but not perfect.', 6);
INSERT INTO Feedback (rating, user_id, issue_id, comment, assignment_id) VALUES (5, 3, 7, 'Garden looks amazing!', 7);
INSERT INTO Feedback (rating, user_id, issue_id, comment, assignment_id) VALUES (4, 3, 8, 'Shelf is sturdy now.', 8);


-- Sample Data for TechnicianSections Table
INSERT INTO TechnicianSections (user_id, section_id) VALUES (2, 1);
INSERT INTO TechnicianSections (user_id, section_id) VALUES (4, 2);
INSERT INTO TechnicianSections (user_id, section_id) VALUES (4, 3);
INSERT INTO TechnicianSections (user_id, section_id) VALUES (5, 5);
INSERT INTO TechnicianSections (user_id, section_id) VALUES (6, 6);
INSERT INTO TechnicianSections (user_id, section_id) VALUES (7, 7);
INSERT INTO TechnicianSections (user_id, section_id) VALUES (8, 8);