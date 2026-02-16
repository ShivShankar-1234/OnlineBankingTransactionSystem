using MySql.Data.MySqlClient;
using System;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    public partial class BillPayment : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // ✅ Checks KYC using 'KYCStatus'
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
                // ✅ FIXED: Using 'KYCStatus' column from 'UserKYC'
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

        protected void btnPay_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            // Ensure these controls exist in your ASPX
            string billType = ddlBillType.SelectedItem.Text;
            string consumer = txtConsumer.Text.Trim();
            decimal amount;

            if (!decimal.TryParse(txtAmount.Text, out amount) || amount <= 0)
            {
                Response.Write("<script>alert('Invalid Amount');</script>");
                return;
            }

            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();

                // Double check KYC
                string kyc = GetKYCStatus();
                if (kyc != "VERIFIED")
                {
                    Response.Write("<script>alert('Please complete KYC before using this service');window.location='KYC_New.aspx';</script>");
                    return;
                }

                // Check Balance
                MySqlCommand bal = new MySqlCommand(
                    "SELECT Balance FROM Users WHERE UserID=@u", con);
                bal.Parameters.AddWithValue("@u", userId);

                decimal balance = Convert.ToDecimal(bal.ExecuteScalar());

                if (balance < amount)
                {
                    Response.Write("<script>alert('Insufficient balance');</script>");
                    return;
                }

                // Deduct Balance
                MySqlCommand deduct = new MySqlCommand(
                    "UPDATE Users SET Balance = Balance - @a WHERE UserID=@u", con);
                deduct.Parameters.AddWithValue("@a", amount);
                deduct.Parameters.AddWithValue("@u", userId);
                deduct.ExecuteNonQuery();

                // Transaction Record
                MySqlCommand txn = new MySqlCommand(@"
                    INSERT INTO Transactions
                    (SenderID, ReceiverID, ReferenceName, Amount, TxnType)
                    VALUES (@s, @r, @ref, @a, 'BILL')", con);

                txn.Parameters.AddWithValue("@s", userId);
                txn.Parameters.AddWithValue("@r", userId);
                txn.Parameters.AddWithValue("@ref", billType + " - " + consumer);
                txn.Parameters.AddWithValue("@a", amount);
                txn.ExecuteNonQuery();

                // Notification
                MySqlCommand notify = new MySqlCommand(
                    "INSERT INTO Notifications (UserID, Message) VALUES (@u,@m)", con);

                notify.Parameters.AddWithValue("@u", userId);
                notify.Parameters.AddWithValue("@m", billType + " bill of ₹" + amount + " paid successfully");

                notify.ExecuteNonQuery();

                Response.Write("<script>alert('Bill Paid Successfully');window.location='Dashboard.aspx';</script>");
            }
        }
    }
}