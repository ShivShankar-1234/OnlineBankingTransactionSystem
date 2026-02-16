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

        public static bool CheckIfTableExists()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    MySqlCommand cmd = new MySqlCommand(
                        "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'onlinebanking_new' AND table_name = 'Beneficiaries'",
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
    }
}
