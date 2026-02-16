-- =====================================================
-- Online Banking Transaction System
-- Beneficiary Management Module - Database Setup
-- =====================================================

USE onlinebanking_new;

-- Create Beneficiaries table
CREATE TABLE IF NOT EXISTS Beneficiaries (
    BeneficiaryID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    BeneficiaryUserID INT NOT NULL,
    Nickname VARCHAR(100) NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BeneficiaryUserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    
    -- Prevent duplicate beneficiaries
    UNIQUE KEY unique_user_beneficiary (UserID, BeneficiaryUserID),
    
    -- Index for performance
    INDEX idx_userid (UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Verify table creation
DESCRIBE Beneficiaries;

-- Display success message
SELECT 'Beneficiaries table created successfully!' AS Status;
