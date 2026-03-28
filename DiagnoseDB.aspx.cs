using System;
using System.Configuration;
using System.Data;
using MySql.Data.MySqlClient;
using System.Text;

namespace OnlineBankingTransactionSystem
{
    public partial class DiagnoseDB : System.Web.UI.Page
    {
        protected void btnRun_Click(object sender, EventArgs e)
        {
            StringBuilder sb = new StringBuilder();
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

            sb.Append("<h3>Connection String Check</h3>");
            sb.Append($"<p>Connection Key Found: {(!string.IsNullOrEmpty(cs))}</p>");

            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    sb.Append("<p class='success'>✅ Connection Opened Successfully</p>");
                    sb.Append($"<p>Database: {con.Database}</p>");

                    // 1. Check Required Tables
                    string[] requiredTables = { "Users", "BankAccounts", "Beneficiaries", "FixedDeposits", "Transactions", "Notifications", "UserKYC" };
                    sb.Append("<h3>Missing Tables Check</h3>");
                    
                    foreach (string tbl in requiredTables)
                    {
                        MySqlCommand cmd = new MySqlCommand($"SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '{con.Database}' AND table_name = '{tbl}'", con);
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        if (count == 0) sb.Append($"<p class='error'>❌ Missing Table: {tbl}</p>");
                        else sb.Append($"<p class='success'>✅ Found Table: {tbl}</p>");
                    }

                    // 2. Check Users Columns (Deep Check)
                    sb.Append("<h3>Users Table - Column Check</h3>");
                    string[] userColumns = { 
                        "FullName", "Email", "Mobile", "Password", "DateOfBirth", "Gender", "Address", 
                        "City", "State", "PinCode",
                        "AadhaarNumber", "PANNumber", "AccountNumber", "IFSC", "Balance", "Role", "Status" 
                    };

                    foreach (string col in userColumns)
                    {
                         MySqlCommand cmd = new MySqlCommand($"SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = '{con.Database}' AND table_name = 'Users' AND column_name = '{col}'", con);
                         int exists = Convert.ToInt32(cmd.ExecuteScalar());
                         if(exists > 0) sb.Append($"<div class='success'>✅ {col} exists</div>");
                         else sb.Append($"<div class='error'>❌ {col} MISSING!</div>");
                    }
                }
            }
            catch (Exception ex)
            {
                sb.Append($"<p class='error'>❌ Error: {ex.Message}</p>");
            }

            litResult.Text = sb.ToString();
        }
    }
}
