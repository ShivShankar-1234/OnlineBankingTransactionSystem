using MySql.Data.MySqlClient;
using System;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    /// <summary>
    /// One-time database setup helper for Beneficiaries table
    /// Run this from Page_Load or a setup page once
    /// </summary>
    public class DatabaseSetupHelper
    {
        public static string CreateUsersTable()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;
            
            string createTableSQL = @"
                CREATE TABLE IF NOT EXISTS Users (
                    UserID INT AUTO_INCREMENT PRIMARY KEY,
                    FullName VARCHAR(100) NOT NULL,
                    Email VARCHAR(100) NOT NULL UNIQUE,
                    Mobile VARCHAR(20) NOT NULL,
                    Password VARCHAR(255) NOT NULL,
                    Role VARCHAR(20) NOT NULL DEFAULT 'USER',
                    Status VARCHAR(20) NOT NULL DEFAULT 'Active',
                    DateOfBirth DATE,
                    Gender VARCHAR(10),
                    Address TEXT,
                    City VARCHAR(50),
                    State VARCHAR(50),
                    PinCode VARCHAR(10),
                    Branch VARCHAR(50),
                    AadhaarNumber VARCHAR(20),
                    PANNumber VARCHAR(20),
                    AccountNumber VARCHAR(20) UNIQUE,
                    IFSC VARCHAR(20),
                    Balance DECIMAL(18,2) DEFAULT 0.00,
                    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            ";

            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    MySqlCommand cmd = new MySqlCommand(createTableSQL, con);
                    cmd.ExecuteNonQuery();
                    return "✅ Users table created successfully!";
                }
            }
            catch (Exception ex)
            {
                return $"❌ Error creating Users table: {ex.Message}";
            }
        }

        public static string CreateBeneficiariesTable()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

            string createTableSQL = @"
                CREATE TABLE IF NOT EXISTS Beneficiaries (
                    BeneficiaryID INT AUTO_INCREMENT PRIMARY KEY,
                    UserID INT NOT NULL,
                    BeneficiaryUserID INT NOT NULL,
                    Nickname VARCHAR(100) NOT NULL,
                    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
                    FOREIGN KEY (BeneficiaryUserID) REFERENCES Users(UserID) ON DELETE CASCADE,
                    UNIQUE KEY unique_user_beneficiary (UserID, BeneficiaryUserID),
                    INDEX idx_userid (UserID)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            ";

            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    MySqlCommand cmd = new MySqlCommand(createTableSQL, con);
                    cmd.ExecuteNonQuery();
                    return "✅ Beneficiaries table created successfully!";
                }
            }
            catch (MySqlException ex)
            {
                // Table might already exist or other DB error
                return $"❌ Database error: {ex.Message}";
            }
            catch (Exception ex)
            {
                return $"❌ Error: {ex.Message}";
            }
        }

        public static string CreateBankAccountsTable()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

            string createTableSQL = @"
                CREATE TABLE IF NOT EXISTS BankAccounts (
                    BankAccountID INT AUTO_INCREMENT PRIMARY KEY,
                    UserID INT NOT NULL,
                    BankName VARCHAR(100) NOT NULL,
                    AccountNumber VARCHAR(255) NOT NULL,
                    IFSC VARCHAR(20) NOT NULL,
                    IsVerified BOOLEAN DEFAULT FALSE,
                    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            ";

            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    MySqlCommand cmd = new MySqlCommand(createTableSQL, con);
                    cmd.ExecuteNonQuery();
                    return "✅ BankAccounts table created successfully!";
                }
            }
            catch (Exception ex)
            {
                return $"❌ Error creating BankAccounts table: {ex.Message}";
            }
        }

        public static bool CheckIfTableExists()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    MySqlCommand cmd = new MySqlCommand(
                        "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'Beneficiaries'",
                        con);
                    
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        public static string EnsureAdminUser()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;
            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    // Check if admin exists
                    MySqlCommand checkCmd = new MySqlCommand("SELECT COUNT(*) FROM Users WHERE Role='ADMIN'", con);
                    int count = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (count == 0)
                    {
                        // Insert default admin
                        string insertSql = @"
                            INSERT INTO Users (FullName, Email, Password, Role, DateOfBirth, Gender, Address, City, State, PinCode, Status) 
                            VALUES ('System Admin', 'admin@bank.com', 'admin123', 'ADMIN', '1990-01-01', 'Male', 'Admin HQ', 'City', 'State', '000000', 'Active')";
                        
                        MySqlCommand insertCmd = new MySqlCommand(insertSql, con);
                        insertCmd.ExecuteNonQuery();
                        return "✅ Default Admin (admin@bank.com / admin123) created successfully!";
                    }
                    else
                    {
                        return "ℹ️ Admin user already exists.";
                    }
                }
            }
            catch (Exception ex)
            {
                return $"❌ Error creating admin: {ex.Message}";
            }
        }
        public static string UpdateUsersTableSchema()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;
            string status = "";
            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    
                    var columnsToAdd = new System.Collections.Generic.Dictionary<string, string>
                    {
                        { "Mobile", "VARCHAR(20) NOT NULL DEFAULT ''" },
                        { "Role", "VARCHAR(20) NOT NULL DEFAULT 'USER'" },
                        { "Status", "VARCHAR(20) NOT NULL DEFAULT 'Active'" },
                        { "Balance", "DECIMAL(18,2) DEFAULT 0.00" },
                        { "AccountNumber", "VARCHAR(20)" },
                        { "IFSC", "VARCHAR(20)" },
                        { "AadhaarNumber", "VARCHAR(20)" },
                        { "PANNumber", "VARCHAR(20)" },
                        { "DateOfBirth", "DATE" },
                        { "Gender", "VARCHAR(10)" },
                        { "Address", "TEXT" },
                        { "City", "VARCHAR(50)" },
                        { "State", "VARCHAR(50)" },
                        { "PinCode", "VARCHAR(10)" },
                        { "Branch", "VARCHAR(50)" }
                    };

                    foreach (var col in columnsToAdd)
                    {
                        try 
                        {
                            // Try to add the column directly. 
                            // method: ALTER TABLE Users ADD COLUMN Name Type;
                            // If it exists, it will throw an error (1060: Duplicate column name), which we ignore.
                            string alterSql = $"ALTER TABLE Users ADD COLUMN {col.Key} {col.Value}";
                            MySqlCommand alterCmd = new MySqlCommand(alterSql, con);
                            alterCmd.ExecuteNonQuery();
                            status += $"✅ Added {col.Key}<br/>";
                        }
                        catch (MySqlException ex)
                        {
                            if (ex.Number == 1060) // Duplicate column name
                            {
                                // status += $"ℹ️ {col.Key} already exists.<br/>"; // Optional logging
                            }
                            else
                            {
                                status += $"❌ Failed to add {col.Key}: {ex.Message}<br/>";
                            }
                        }
                    }
                    
                    return string.IsNullOrEmpty(status) ? "✅ Users table schema is up to date." : status;
                }
            }
            catch (Exception ex)
            {
                return $"❌ Error updating Users table: {ex.Message}";
            }
        }

        public static string UpdateBankAccountsTableSchema()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;
            string status = "";
            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();

                    var columnsToAdd = new System.Collections.Generic.Dictionary<string, string>
                    {
                        { "AccountType", "VARCHAR(50) DEFAULT 'Savings'" },
                        { "Balance",     "DECIMAL(18,2) DEFAULT 0.00" }
                    };

                    foreach (var col in columnsToAdd)
                    {
                        try
                        {
                            string alterSql = $"ALTER TABLE BankAccounts ADD COLUMN {col.Key} {col.Value}";
                            new MySqlCommand(alterSql, con).ExecuteNonQuery();
                            status += $"✅ Added BankAccounts.{col.Key}<br/>";
                        }
                        catch (MySqlException ex)
                        {
                            if (ex.Number == 1060) { /* Column already exists – skip */ }
                            else status += $"❌ Failed to add {col.Key}: {ex.Message}<br/>";
                        }
                    }

                    return string.IsNullOrEmpty(status)
                        ? "✅ BankAccounts table schema is up to date."
                        : status;
                }
            }
            catch (Exception ex)
            {
                return $"❌ Error updating BankAccounts table: {ex.Message}";
            }
        }

        public static string CreateFixedDepositsTable()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;
            string createTableSQL = @"
                CREATE TABLE IF NOT EXISTS FixedDeposits (
                    FDID INT AUTO_INCREMENT PRIMARY KEY,
                    UserID INT NOT NULL,
                    PrincipalAmount DECIMAL(18,2) NOT NULL,
                    InterestRate DECIMAL(5,2) NOT NULL,
                    TenureMonths INT NOT NULL,
                    MaturityDate DATETIME NOT NULL,
                    MaturityAmount DECIMAL(18,2) NOT NULL,
                    Status VARCHAR(20) DEFAULT 'ACTIVE',
                    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            ";

            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    MySqlCommand cmd = new MySqlCommand(createTableSQL, con);
                    cmd.ExecuteNonQuery();
                    return "✅ FixedDeposits table created successfully!";
                }
            }
            catch (Exception ex)
            {
                return $"❌ Error creating FixedDeposits table: {ex.Message}";
            }
        }

        public static string CreateTransactionsTable()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;
            string createTableSQL = @"
                CREATE TABLE IF NOT EXISTS Transactions (
                    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
                    SenderID INT NOT NULL,
                    ReceiverID INT NOT NULL,
                    ReferenceName VARCHAR(100),
                    Amount DECIMAL(18,2) NOT NULL,
                    TxnType VARCHAR(20) NOT NULL,
                    TxnDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (SenderID) REFERENCES Users(UserID) ON DELETE CASCADE,
                    FOREIGN KEY (ReceiverID) REFERENCES Users(UserID) ON DELETE CASCADE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            ";

            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    MySqlCommand cmd = new MySqlCommand(createTableSQL, con);
                    cmd.ExecuteNonQuery();

                    // Self-healing for TxnDate
                    try {
                        // Check if TransactionDate exists (old schema) and rename it, or add TxnDate
                        // Renaming is safer if data exists, but complicate. Let's just add TxnDate if missing.
                        // Actually, if 'TransactionDate' exists, the code using 'TxnDate' will fail. 
                        // I should probably ALTER TABLE CHANGE COLUMN if exists.
                        // For now, simple ADD IF NOT EXISTS is good.
                        new MySqlCommand("ALTER TABLE Transactions CHANGE COLUMN TransactionDate TxnDate DATETIME DEFAULT CURRENT_TIMESTAMP", con).ExecuteNonQuery();
                    } catch { 
                         // Check if TxnDate missing
                         try { new MySqlCommand("ALTER TABLE Transactions ADD COLUMN IF NOT EXISTS TxnDate DATETIME DEFAULT CURRENT_TIMESTAMP", con).ExecuteNonQuery(); } catch {}
                    }

                    return "✅ Transactions table created successfully!";
                }
            }
            catch (Exception ex)
            {
                return $"❌ Error creating Transactions table: {ex.Message}";
            }
        }

        public static string CreateNotificationsTable()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;
            string createTableSQL = @"
                CREATE TABLE IF NOT EXISTS Notifications (
                    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
                    UserID INT NOT NULL,
                    Message TEXT NOT NULL,
                    IsRead BOOLEAN DEFAULT FALSE,
                    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            ";

            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    MySqlCommand cmd = new MySqlCommand(createTableSQL, con);
                    cmd.ExecuteNonQuery();
                    return "✅ Notifications table created successfully!";
                }
            }
            catch (Exception ex)
            {
                return $"❌ Error creating Notifications table: {ex.Message}";
            }
        }

        public static string CreateUserKYCTable()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;
            string createTableSQL = @"
                CREATE TABLE IF NOT EXISTS UserKYC (
                    KYCID INT AUTO_INCREMENT PRIMARY KEY,
                    UserID INT NOT NULL UNIQUE,
                    Status VARCHAR(50) DEFAULT 'Pending',
                    KYCStatus VARCHAR(50) DEFAULT 'Pending',
                    AadhaarNumber VARCHAR(20),
                    PANNumber VARCHAR(20),
                    DocumentType VARCHAR(50),
                    DocumentNumber VARCHAR(50),
                    DocumentImage VARCHAR(255),
                    SubmittedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
                    ApprovedAt DATETIME,
                    ApprovedBy INT,
                    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            ";

            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    MySqlCommand cmd = new MySqlCommand(createTableSQL, con);
                    cmd.ExecuteNonQuery();

                    // Self-healing: Ensure columns exist if table was already there
                    string[] alterations = {
                        "ADD COLUMN IF NOT EXISTS AadhaarNumber VARCHAR(20)",
                        "ADD COLUMN IF NOT EXISTS PANNumber VARCHAR(20)",
                        "ADD COLUMN IF NOT EXISTS ApprovedAt DATETIME",
                        "ADD COLUMN IF NOT EXISTS ApprovedBy INT",
                        "ADD COLUMN IF NOT EXISTS KYCStatus VARCHAR(50) DEFAULT 'Pending'",
                        "MODIFY COLUMN UserID INT NOT NULL UNIQUE" // Ensure unique constraint
                    };

                    foreach (var alt in alterations)
                    {
                        try {
                            new MySqlCommand($"ALTER TABLE UserKYC {alt}", con).ExecuteNonQuery();
                        } catch { /* Ignore specific alter errors */ }
                    }

                    return "✅ UserKYC table created/updated successfully!";
                }
            }
            catch (Exception ex)
            {
                return $"❌ Error creating UserKYC table: {ex.Message}";
            }
        }
    }
}
