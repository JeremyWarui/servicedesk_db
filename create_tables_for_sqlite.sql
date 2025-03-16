-- DROP TABLES IF THEY ALREADY EXIST (For reset)
DROP TABLE IF EXISTS Issue_Log;
DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS Assignment;
DROP TABLE IF EXISTS Issue;
DROP TABLE IF EXISTS Request;
DROP TABLE IF EXISTS Status;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS Section;
DROP TABLE IF EXISTS Facility;
DROP TABLE IF EXISTS TechnicianSections;

-- CREATE TABLES
CREATE TABLE Role (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name TEXT UNIQUE NOT NULL
);

CREATE TABLE Section (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE Facility (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    requires_tenant BOOLEAN DEFAULT 0,  -- For staff quarters or rented spaces
    is_custom_location BOOLEAN DEFAULT 0 -- For cases where users specify a location not in facility list
);

CREATE TABLE User (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role_id INTEGER,
    section_id INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Role(id) ON DELETE SET NULL,
    FOREIGN KEY (section_id) REFERENCES Section(id) ON DELETE SET NULL
);

CREATE TABLE Status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    type TEXT CHECK (type IN ('open', 'in_progress', 'pending', 'resolved')),
    visibility TEXT CHECK (visibility IN ('user', 'admin')),
    description TEXT
);

CREATE TABLE Request (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    submission_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    submission_notes TEXT DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE SET NULL
);

CREATE TABLE Issue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    request_id INTEGER,
    ticket_no TEXT UNIQUE NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    section_id INTEGER NOT NULL,
    facility_id INTEGER,  -- New column
    location_detail TEXT, -- New column (e.g., room/house)
    created_by INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    resolved_at DATETIME,
    status_id INTEGER NOT NULL,
    priority TEXT CHECK (priority IN ('Low', 'Medium', 'High')),
    FOREIGN KEY (section_id) REFERENCES Section(id) ON DELETE CASCADE,
    FOREIGN KEY (facility_id) REFERENCES Facility(id) ON DELETE SET NULL, 
    FOREIGN KEY (created_by) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES Status(id),
    FOREIGN KEY (request_id) REFERENCES Request(id) ON DELETE CASCADE
);

-- Trigger to Auto-generate Ticket Number
CREATE TRIGGER generate_ticket_no
AFTER INSERT ON Issue
FOR EACH ROW
BEGIN
    UPDATE Issue
    SET ticket_no = 'TKT-' || printf('%05d', NEW.id)
    WHERE id = NEW.id;
END;

CREATE TABLE Assignment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    issue_id INTEGER UNIQUE,
    technician_id INTEGER,
    status_id INTEGER,
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES Issue(id) ON DELETE CASCADE,
    FOREIGN KEY (technician_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES Status(id)
);

CREATE TABLE Comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    comment_text TEXT NOT NULL,
    issue_id INTEGER,
    created_by INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES Issue(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES User(id) ON DELETE SET NULL
);

CREATE TABLE Feedback (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    user_id INTEGER,
    issue_id INTEGER,
    comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    assignment_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (issue_id) REFERENCES Issue(id) ON DELETE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES Assignment(id) ON DELETE SET NULL,
    UNIQUE (user_id, issue_id)
);

CREATE TABLE Issue_Log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    issue_id INTEGER NOT NULL,
    old_status_id INTEGER NOT NULL,
    new_status_id INTEGER NOT NULL,
    changed_by INTEGER NOT NULL,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES Issue(id) ON DELETE CASCADE,
    FOREIGN KEY (old_status_id) REFERENCES Status(id),
    FOREIGN KEY (new_status_id) REFERENCES Status(id),
    FOREIGN KEY (changed_by) REFERENCES User(id)
);

-- Trigger to update Issue status when Assignment status changes
CREATE TRIGGER update_issue_status
AFTER UPDATE ON Assignment
FOR EACH ROW
WHEN NEW.status_id != OLD.status_id
BEGIN
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
END;

CREATE TABLE TechnicianSections (
    user_id INTEGER,
    section_id INTEGER,
    PRIMARY KEY (user_id, section_id),
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES Section(id) ON DELETE CASCADE
);

PRAGMA foreign_keys = ON;
