using MySql.Data.MySqlClient;
using System;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    public class KYC_Helper
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        // 🔹 Get KYC Status
        public string GetStatus(int userId)
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                MySqlCommand cmd = new MySqlCommand(
                    "SELECT KYCStatus FROM UserKYC WHERE UserID=@uid",
                    con);

                cmd.Parameters.AddWithValue("@uid", userId);
                con.Open();

                object result = cmd.ExecuteScalar();

                if (result == null)
                    return "NOT_SUBMITTED";

                return result.ToString().ToUpper();
            }
        }

        // 🔹 Check if VERIFIED
        public bool IsKYCVerified(int userId)
        {
            return GetStatus(userId) == "VERIFIED";
        }
    }
}
