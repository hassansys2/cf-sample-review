-- Initialize ColdFusion Test Database
-- This script creates the required tables and sample data for testing

USE cf_test_db;

-- Create Users table
CREATE TABLE IF NOT EXISTS Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(50) NOT NULL UNIQUE,
    EmailAddress VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Activities table
CREATE TABLE IF NOT EXISTS Activities (
    ActivityID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    ActivityType VARCHAR(50) NOT NULL,
    ActivityDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Insert sample users
INSERT INTO Users (UserID, UserName, EmailAddress) VALUES
(1, 'john_doe', 'john.doe@example.com'),
(2, 'jane_smith', 'jane.smith@example.com'),
(3, 'bob_wilson', 'bob.wilson@example.com'),
(4, 'alice_brown', 'alice.brown@example.com'),
(5, 'charlie_davis', 'charlie.davis@example.com');

-- Insert sample activities
INSERT INTO Activities (UserID, ActivityType, ActivityDate) VALUES
(1, 'login', '2025-07-11 09:00:00'),
(1, 'profile_update', '2025-07-11 09:15:00'),
(2, 'login', '2025-07-11 09:30:00'),
(3, 'file_upload', '2025-07-11 10:00:00'),
(2, 'logout', '2025-07-11 10:30:00'),
(4, 'login', '2025-07-11 11:00:00'),
(1, 'logout', '2025-07-11 11:15:00'),
(5, 'login', '2025-07-11 12:00:00'),
(3, 'profile_update', '2025-07-11 12:30:00'),
(4, 'file_download', '2025-07-11 13:00:00');

-- Create indexes for better performance
CREATE INDEX idx_users_username ON Users(UserName);
CREATE INDEX idx_activities_userid ON Activities(UserID);
CREATE INDEX idx_activities_date ON Activities(ActivityDate);

-- Show the created data
SELECT 'Users table:' as info;
SELECT * FROM Users;

SELECT 'Activities table:' as info;
SELECT a.ActivityID, a.UserID, u.UserName, a.ActivityType, a.ActivityDate 
FROM Activities a 
JOIN Users u ON a.UserID = u.UserID 
ORDER BY a.ActivityDate DESC; 