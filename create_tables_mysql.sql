-- Active: 1742133204327@@127.0.0.1@3306@service_desk
-- DROP TABLES IF THEY ALREADY EXIST (For reset)
DROP TABLE IF EXISTS TechnicianSection;
DROP TABLE IF EXISTS Issue_Log;
DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS Comment;
DROP TABLE IF EXISTS Assignment;
DROP TABLE IF EXISTS Issue;
DROP TABLE IF EXISTS Request;
DROP TABLE IF EXISTS Status;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS Section;
DROP TABLE IF EXISTS Facility;
DROP TABLE IF EXISTS TicketCounter;

-- CREATE TABLES
CREATE TABLE Role (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Section (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Facility (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    requires_tenant BOOLEAN DEFAULT 0,  -- For staff quarters or rented spaces
    is_custom_location BOOLEAN DEFAULT 0 -- For cases where users specify a location not in facility list
);

CREATE TABLE User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role_id INT,
    section_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Role(id) ON DELETE SET NULL,
    FOREIGN KEY (section_id) REFERENCES Section(id) ON DELETE SET NULL
);

CREATE TABLE Status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    type ENUM('open', 'in_progress', 'pending', 'resolved') NOT NULL,
    visibility ENUM('user', 'admin') NOT NULL,
    description TEXT
);

CREATE TABLE Request (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    submission_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    submission_notes TEXT DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE SET NULL
);

CREATE TABLE Issue (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT,
    ticket_no VARCHAR(20) UNIQUE NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    section_id INT NOT NULL,
    facility_id INT,  -- New column
    location_detail VARCHAR(255), -- New column (e.g., room/house)
    created_by INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    resolved_at DATETIME NULL,
    status_id INT NOT NULL,
    priority ENUM('Low', 'Medium', 'High') NOT NULL,
    FOREIGN KEY (section_id) REFERENCES Section(id) ON DELETE CASCADE,
    FOREIGN KEY (facility_id) REFERENCES Facility(id) ON DELETE SET NULL, 
    FOREIGN KEY (created_by) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES Status(id),
    FOREIGN KEY (request_id) REFERENCES Request(id) ON DELETE CASCADE
);

-- Create TicketCounter table to store the current counter value
CREATE TABLE TicketCounter (
    id INT AUTO_INCREMENT PRIMARY KEY,
    counter INT NOT NULL,
    month_year VARCHAR(6) NOT NULL
);

-- Initialize the counter
INSERT INTO TicketCounter (counter, month_year) VALUES (0, DATE_FORMAT(NOW(), '%m%y'));

-- Trigger to Auto-generate Ticket Number
DELIMITER //
CREATE TRIGGER generate_ticket_no
BEFORE INSERT ON Issue
FOR EACH ROW
BEGIN
    DECLARE current_month_year VARCHAR(6);
    SET current_month_year = DATE_FORMAT(NOW(), '%m%y');
    
    -- Check if the month has changed
    IF (SELECT month_year FROM TicketCounter LIMIT 1) != current_month_year THEN
        -- Reset the counter for the new month
        UPDATE TicketCounter SET counter = 1, month_year = current_month_year;
    ELSE
        -- Increment the counter
        UPDATE TicketCounter SET counter = counter + 1;
    END IF;
    
    -- Get the current counter value
    SET @current_counter = (SELECT counter FROM TicketCounter LIMIT 1);
    
    -- Generate the ticket number
    SET NEW.ticket_no = CONCAT('TKT-', DATE_FORMAT(NOW(), '%m%y'), '/', LPAD(@current_counter, 4, '0'));
END;
//
DELIMITER ;

CREATE TABLE Assignment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    issue_id INT UNIQUE,
    technician_id INT,
    status_id INT,
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES Issue(id) ON DELETE CASCADE,
    FOREIGN KEY (technician_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES Status(id)
);

CREATE TABLE Comment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    comment_text TEXT NOT NULL,
    issue_id INT,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES Issue(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES User(id) ON DELETE SET NULL
);

CREATE TABLE Feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    user_id INT,
    issue_id INT,
    comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    assignment_id INT,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (issue_id) REFERENCES Issue(id) ON DELETE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES Assignment(id) ON DELETE SET NULL,
    UNIQUE (user_id, issue_id)
);

CREATE TABLE Issue_Log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    issue_id INT NOT NULL,
    old_status_id INT NOT NULL,
    new_status_id INT NOT NULL,
    changed_by INT NOT NULL,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES Issue(id) ON DELETE CASCADE,
    FOREIGN KEY (old_status_id) REFERENCES Status(id),
    FOREIGN KEY (new_status_id) REFERENCES Status(id),
    FOREIGN KEY (changed_by) REFERENCES User(id)
);

-- Trigger to update Issue status when Assignment status changes
DELIMITER //
CREATE TRIGGER update_issue_status
AFTER UPDATE ON Assignment
FOR EACH ROW
BEGIN
    IF NEW.status_id != OLD.status_id THEN
        INSERT INTO Issue_Log (issue_id, old_status_id, new_status_id, changed_by, changed_at)
        VALUES (NEW.issue_id, OLD.status_id, NEW.status_id, NEW.technician_id, CURRENT_TIMESTAMP);

        UPDATE Issue
        SET
            status_id = NEW.status_id,
            updated_at = CURRENT_TIMESTAMP,
            resolved_at = CASE
                WHEN (SELECT type FROM Status WHERE id = NEW.status_id) = 'resolved' THEN CURRENT_TIMESTAMP
                ELSE resolved_at
            END
        WHERE id = NEW.issue_id;
    END IF;
END;
//
DELIMITER ;

CREATE TABLE TechnicianSection (
    user_id INT,
    section_id INT,
    PRIMARY KEY (user_id, section_id),
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES Section(id) ON DELETE CASCADE
);
