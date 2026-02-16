using System;
using MySql.Data.MySqlClient;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    public partial class MyQR : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnSimulate_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(txtAmount.Text))
                {
                    Response.Write("<script>alert('Please enter an amount.');</script>");
                    return;
                }

                int userId = Convert.ToInt32(Session["UserID"]);
                decimal amount = Convert.ToDecimal(txtAmount.Text); 

                if (amount <= 0)
                {
                    Response.Write("<script>alert('Please enter a valid amount.');</script>");
                    return;
                }

                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();

                    // 1. Add Money to User Balance
                    MySqlCommand cmd = new MySqlCommand("UPDATE Users SET Balance = Balance + @a WHERE UserID=@u", con);
                    cmd.Parameters.AddWithValue("@a", amount);
                    cmd.Parameters.AddWithValue("@u", userId);
                    cmd.ExecuteNonQuery();

                    // 2. Log Transaction
                    MySqlCommand txn = new MySqlCommand(@"
                        INSERT INTO Transactions (SenderID, ReceiverID, ReferenceName, Amount, TxnType)
                        VALUES (@u, @u, 'UPI Payment Received', @a, 'RECEIVE')", con);
                    txn.Parameters.AddWithValue("@u", userId);
                    txn.Parameters.AddWithValue("@a", amount);
                    txn.ExecuteNonQuery();

                    // 3. Send Email Notification
                    MySqlCommand getUser = new MySqlCommand("SELECT Email, FullName FROM Users WHERE UserID=@u", con);
                    getUser.Parameters.AddWithValue("@u", userId);

                    using (MySqlDataReader reader = getUser.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string email = reader["Email"].ToString();
                            string name = reader["FullName"].ToString();

                            string subject = "Payment Received via QR - ₹" + amount;
                            string body = $@"
                                <h2>Payment Received</h2>
                                <p>Hello {name},</p>
                                <p>You have received <b>₹{amount}</b> via UPI QR Scan.</p>
                                <p><b>Date:</b> {DateTime.Now}</p>
                                <br/>
                                <p>This is a simulated transaction for testing.</p>";

                            string emailResult = EmailHelper.SendEmail(email, subject, body);
                            Response.Write("<script>alert('Simulated Payment Received! \\nRecipient (" + email + "): " + emailResult + "');</script>");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }
    }
}
