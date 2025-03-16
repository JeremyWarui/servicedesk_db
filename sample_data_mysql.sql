-- Sample Data for Role Table
INSERT INTO Role (role_name) VALUES 
('Admin'),
('Technician'),
('User');

-- Expanded Sample Data for Section Table
INSERT INTO Section (name) VALUES 
('Electrical'),
('Plumbing'),
('HVAC'),
('Carpentry'),
('Painting'),
('Landscaping'),
('IT Support'),
('General Maintenance');

-- Sample Data for Facility Table (Updated for MySQL Boolean Values)
INSERT INTO Facility (name, requires_tenant, is_custom_location) VALUES 
('Margaret Kobia Hostel', 0, 0),
('Wamalwa Hostel', 0, 0),
('Gateere Hostel', 0, 0),
('Mekatilili Hostel', 0, 0),
('Maandalizi Hall', 0, 0),
('Laundry House', 0, 0),
('Power House', 0, 0),
('Sawe Hostel', 0, 0),
('Sacho', 0, 0),
('Kamoche', 0, 0),
('Maasai Mara', 0, 0),
('Gate A', 0, 0),
('Mt. Kenya-Procurement', 0, 0),
('Registry Archives', 0, 0),
('Administration Block', 0, 0),
('Convention Centre', 0, 0),
('Habel Nyamu Library', 0, 0),
('Gate B', 0, 0),
('Staff Quarters', 1, 0),
('Others', 0, 1);

-- Sample Data for User Table (Passwords should be hashed in real use)
INSERT INTO User (name, username, password, email, role_id, section_id) VALUES 
('Alice Admin', 'alice', 'password123', 'alice@example.com', 1, NULL),
('Bob Technician', 'bob', 'securepass', 'bob@example.com', 2, 1),
('Charlie User', 'charlie', 'mysecret', 'charlie@example.com', 3, NULL),
('David Technician', 'david', 'securepass', 'david@example.com', 2, 2),
('Eve Painter', 'eve', 'strongpass', 'eve@example.com', 2, 5),
('Frank Landscaper', 'frank', 'gardenpass', 'frank@example.com', 2, 6),
('Grace IT', 'grace', 'techpass', 'grace@example.com', 2, 7),
('Henry General', 'henry', 'fixitpass', 'henry@example.com', 2, 8),
('Ivy User', 'ivy', 'userpass', 'ivy@example.com', 3, NULL),
('Jack User', 'jack', 'userpass', 'jack@example.com', 3, NULL);

-- Sample Data for Status Table (Fixed Reserved Keyword `type`)
INSERT INTO Status (name, `type`, visibility, description) VALUES 
('Open', 'open', 'user', 'Issue reported and awaiting assignment.'),
('In Progress', 'in_progress', 'user', 'Technician assigned and working on the issue.'),
('Resolved', 'resolved', 'user', 'Issue resolved.'),
('Pending', 'pending', 'admin', 'Issue pending admin approval.');

-- Sample Data for Request Table
INSERT INTO Request (user_id, submission_notes) VALUES 
(3, 'Multiple issues in the office.'),
(3, 'Leaky faucet in the bathroom.'),
(5, 'Office needs painting.'),
(6, 'Network issues in the conference room.');

-- Sample Data for Issue Table (Using Subqueries for Facility ID)
INSERT INTO Issue (request_id, title, description, section_id, created_by, status_id, priority, facility_id, location_detail) VALUES 
(1, 'Lights Flickering', 'Office lights flickering intermittently.', 1, 3, 1, 'Medium', (SELECT id FROM Facility WHERE name = 'Administration Block'), 'Office 101'),
(1, 'AC Not Working', 'AC unit not cooling the office.', 3, 3, 1, 'High', (SELECT id FROM Facility WHERE name = 'Margaret Kobia Hostel'), 'Room 202'),
(2, 'Leaky Faucet', 'Bathroom faucet leaking.', 2, 3, 1, 'Low', (SELECT id FROM Facility WHERE name = 'Maandalizi Hall'), 'Bathroom 201'),
(3, 'Wall Needs Painting', 'Wall in the lobby needs repainting.', 5, 5, 1, 'Medium', (SELECT id FROM Facility WHERE name = 'Convention Centre'), 'Lobby'),
(4, 'Network Down', 'Network down in the conference room.', 7, 6, 1, 'High', (SELECT id FROM Facility WHERE name = 'Habel Nyamu Library'), 'Conference Room'),
(1, 'Door Handle Broken', 'Door handle in office 103 is broken.', 4, 3, 1, 'Low', (SELECT id FROM Facility WHERE name = 'Mt. Kenya-Procurement'), 'Office 103'),
(2, 'Garden Overgrown', 'Garden needs trimming and maintenance.', 6, 3, 1, 'Medium', (SELECT id FROM Facility WHERE name = 'Sawe Hostel'), 'Back Garden');

-- Sample Data for Assignment Table
INSERT INTO Assignment (issue_id, technician_id, status_id) VALUES 
(1, 2, 2),
(2, 4, 2),
(3, 7, 2),
(4, 5, 2),
(5, 4, 2),
(6, 6, 2);

-- Sample Data for Comment Table
INSERT INTO Comment (comment_text, issue_id, created_by) VALUES 
('Checking the circuit breaker.', 2, 4),
('Need to replace the AC filter.', 2, 4),
('Checking the pipes.', 3, 4),
('Ordering paint for the wall.', 5, 5),
('Checking the network cables.', 4, 7),
('Replacing the door handle.', 6, 4);

-- Sample Data for Feedback Table
INSERT INTO Feedback (rating, user_id, issue_id, comment, assignment_id) VALUES 
(4, 3, 2, 'Good job fixing the AC.', 2),
(5, 3, 3, 'Fast and efficient.', 3),
(5, 5, 4, 'Wall looks great!', 4),
(4, 6, 5, 'Network is working now.', 5),
(3, 3, 6, 'Door handle fixed, but not perfect.', 6),
(5, 3, 1, 'Garden looks amazing!', 1);

-- Sample Data for TechnicianSection Table
INSERT INTO TechnicianSection (user_id, section_id) VALUES 
(2, 1),
(4, 2),
(4, 3),
(5, 5),
(6, 6),
(7, 7),
(8, 8);
