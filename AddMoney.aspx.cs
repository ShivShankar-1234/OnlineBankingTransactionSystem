using MySql.Data.MySqlClient;
using System;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    public partial class AddMoney : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // ✅ Checks KYC using the correct column 'KYCStatus'
            if (GetKYCStatus() != "VERIFIED")
            {
                Response.Write("<script>alert('⚠ Please complete KYC before using this service.');window.location='KYC_New.aspx';</script>");
                return;
            }
        }

        string GetKYCStatus()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                // ✅ FIXED: Using 'KYCStatus' column from 'UserKYC' table
                MySqlCommand cmd = new MySqlCommand(
                    "SELECT KYCStatus FROM UserKYC WHERE UserID=@id", con);

                cmd.Parameters.AddWithValue("@id", Session["UserID"]);
                con.Open();

                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    return result.ToString().Trim().ToUpper();
                }
                return "NOT_SUBMITTED";
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            decimal amount;

            if (!decimal.TryParse(txtAmount.Text, out amount) || amount <= 0)
            {
                Response.Write("<script>alert('Invalid amount');</script>");
                return;
            }

            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();

                // 1. Update Balance in Users Table
                MySqlCommand cmd = new MySqlCommand(
                    "UPDATE Users SET Balance = Balance + @a WHERE UserID=@id", con);

                cmd.Parameters.AddWithValue("@a", amount);
                cmd.Parameters.AddWithValue("@id", Session["UserID"]);

                cmd.ExecuteNonQuery();

                // 2. Add Entry in Transactions Table
                MySqlCommand txn = new MySqlCommand(
                    @"INSERT INTO Transactions 
                      (SenderID, ReceiverID, ReferenceName, Amount, TxnType)
                      VALUES (@s, @r, @ref, @a, 'ADD_MONEY')", con);

                txn.Parameters.AddWithValue("@s", Session["UserID"]);
                txn.Parameters.AddWithValue("@r", Session["UserID"]);
                txn.Parameters.AddWithValue("@ref", "Wallet Topup");
                txn.Parameters.AddWithValue("@a", amount);

                txn.ExecuteNonQuery();
            }

            Response.Write("<script>alert('✅ Money added successfully');window.location='Dashboard.aspx';</script>");
        }
    }
}