using MySql.Data.MySqlClient;
using System;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    public partial class SendMoney : System.Web.UI.Page
    {
        readonly string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // ✅ Page load hone par hi KYC check karega (Sahi Table se)
            if (GetKYCStatus() != "VERIFIED")
            {
                Response.Write("<script>alert('⚠ Please complete KYC before using this service.');window.location='KYC_New.aspx';</script>");
                return;
            }

            // Load beneficiaries dropdown on first load
            if (!IsPostBack)
            {
                LoadBeneficiaries();
            }
        }

        void LoadBeneficiaries()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Check if Beneficiaries table exists
                    if (!DatabaseSetupHelper.CheckIfTableExists())
                    {
                        ddlBeneficiaries.Items.Clear();
                        ddlBeneficiaries.Items.Add(new System.Web.UI.WebControls.ListItem("-- No beneficiaries (Table not created) --", "0"));
                        return;
                    }

                    string query = @"
                        SELECT b.BeneficiaryUserID, b.Nickname, u.Email, u.Mobile
                        FROM Beneficiaries b
                        INNER JOIN Users u ON b.BeneficiaryUserID = u.UserID
                        WHERE b.UserID = @uid
                        ORDER BY b.Nickname";

                    MySqlCommand cmd = new MySqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@uid", Session["UserID"]);

                    using (MySqlDataReader dr = cmd.ExecuteReader())
                    {
                        ddlBeneficiaries.Items.Clear();
                        ddlBeneficiaries.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select Beneficiary --", "0"));

                        while (dr.Read())
                        {
                            string nickname = dr["Nickname"].ToString();
                            string email = dr["Email"].ToString();
                            string display = $"{nickname} ({email})";
                            ddlBeneficiaries.Items.Add(new System.Web.UI.WebControls.ListItem(display, email));
                        }

                        if (ddlBeneficiaries.Items.Count == 1)
                        {
                            ddlBeneficiaries.Items.Add(new System.Web.UI.WebControls.ListItem("-- No saved beneficiaries --", "0"));
                        }
                    }
                }
                catch (Exception ex)
                {
                    ddlBeneficiaries.Items.Clear();
                    ddlBeneficiaries.Items.Add(new System.Web.UI.WebControls.ListItem("-- Error loading beneficiaries --", "0"));
                    System.Diagnostics.Debug.WriteLine("LoadBeneficiaries Error: " + ex.Message);
                }
            }
        }

        protected void ddlBeneficiaries_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlBeneficiaries.SelectedValue != "0")
            {
                txtReceiver.Text = ddlBeneficiaries.SelectedValue;
            }
        }

        string GetKYCStatus()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                // ✅ FIXED: Using 'KYCStatus' column form 'UserKYC' table
                MySqlCommand cmd = new MySqlCommand(
                    "SELECT KYCStatus FROM UserKYC WHERE UserID=@id", con);

                cmd.Parameters.AddWithValue("@id", Session["UserID"]);
                con.Open();

                object status = cmd.ExecuteScalar();
                return status == null ? "NOT_SUBMITTED" : status.ToString().Trim().ToUpper();
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int senderId = Convert.ToInt32(Session["UserID"]);
            string receiverInput = txtReceiver.Text.Trim();

            // Decimal parse check
            decimal amount;
            if (!decimal.TryParse(txtAmount.Text, out amount) || amount <= 0)
            {
                Response.Write("<script>alert('Invalid Amount');</script>");
                return;
            }

            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();
                MySqlTransaction transaction = con.BeginTransaction();

                try
                {
                    // Double check KYC before transaction (Inline with transaction)
                    MySqlCommand kycCmd = new MySqlCommand("SELECT KYCStatus FROM UserKYC WHERE UserID=@id", con, transaction);
                    kycCmd.Parameters.AddWithValue("@id", senderId);
                    object statusObj = kycCmd.ExecuteScalar();
                    string kyc = statusObj == null ? "NOT_SUBMITTED" : statusObj.ToString().Trim().ToUpper();

                    if (kyc != "VERIFIED")
                    {
                        transaction.Rollback();
                        Response.Write("<script>alert('Please complete KYC before using this service');window.location='KYC_New.aspx';</script>");
                        return;
                    }

                    // 1. Find Receiver by Email, Mobile, or Account Number
                    MySqlCommand find = new MySqlCommand(
                        "SELECT UserID FROM Users WHERE Email=@v OR Mobile=@v OR AccountNumber=@v", con, transaction);
                    find.Parameters.AddWithValue("@v", receiverInput);

                    object recObj = find.ExecuteScalar();

                    if (recObj == null)
                    {
                        transaction.Rollback();
                        Response.Write("<script>alert('Receiver not found. Please enter a valid Email, Mobile or Account Number.');</script>");
                        return;
                    }

                    int receiverId = Convert.ToInt32(recObj);

                    // 3. Check Sender Balance
                    MySqlCommand balCmd = new MySqlCommand(
                        "SELECT Balance FROM Users WHERE UserID=@id", con, transaction);
                    balCmd.Parameters.AddWithValue("@id", senderId);

                    decimal balance = Convert.ToDecimal(balCmd.ExecuteScalar());

                    if (balance < amount)
                    {
                        transaction.Rollback();
                        Response.Write("<script>alert('Insufficient balance');</script>");
                        return;
                    }

                    // 4. Update Balances (Deduct from Sender)
                    MySqlCommand deduct = new MySqlCommand(
                        "UPDATE Users SET Balance = Balance - @a WHERE UserID=@s", con, transaction);
                    deduct.Parameters.AddWithValue("@a", amount);
                    deduct.Parameters.AddWithValue("@s", senderId);
                    deduct.ExecuteNonQuery();

                    // 5. Update Balances (Add to Receiver)
                    MySqlCommand add = new MySqlCommand(
                        "UPDATE Users SET Balance = Balance + @a WHERE UserID=@r", con, transaction);
                    add.Parameters.AddWithValue("@a", amount);
                    add.Parameters.AddWithValue("@r", receiverId);
                    add.ExecuteNonQuery();

                    // 6. Transaction Record
                    MySqlCommand txn = new MySqlCommand(
                     @"INSERT INTO Transactions 
                     (SenderID, ReceiverID, ReferenceName, Amount, TxnType)
                     VALUES (@s,@r,@ref,@a,'SEND')", con, transaction);

                    txn.Parameters.AddWithValue("@s", senderId);
                    txn.Parameters.AddWithValue("@r", receiverId);
                    txn.Parameters.AddWithValue("@ref", receiverInput);
                    txn.Parameters.AddWithValue("@a", amount);
                    txn.ExecuteNonQuery();

                    // 7. Notification
                    MySqlCommand notify = new MySqlCommand(
                        "INSERT INTO Notifications (UserID, Message) VALUES (@u,@m)", con, transaction);

                    notify.Parameters.AddWithValue("@u", receiverId);
                    notify.Parameters.AddWithValue("@m", "₹" + amount + " received via Send Money");
                    notify.ExecuteNonQuery();

                    // ✅ COMMIT TRANSACION
                    transaction.Commit();


                    // 8. SEND EMAILS (Now safely outside the rollback risk)
                    // We reuse the same connection which is still open
                    
                    string userEmail = "N/A";
                    string senderEmailResult = "N/A";
                    string recEmail = "N/A";
                    string recEmailResult = "N/A";

                    // First get sender's email
                    // Note: No transaction object needed now as we committed, or we can start a new one, 
                    // or just run commands. But we must clear the params or make new commands.
                    
                    MySqlCommand getEmail = new MySqlCommand("SELECT Email FROM Users WHERE UserID=@id", con);
                    getEmail.Parameters.AddWithValue("@id", senderId);
                    object senderEmailObj = getEmail.ExecuteScalar();

                    if (senderEmailObj != null)
                    {
                        userEmail = senderEmailObj.ToString();
                        string subject = "Money Sent Successfully - ₹" + amount;
                        string body = $@"
                        <h2>Transaction Successful</h2>
                        <p>You have successfully sent <b>₹{amount}</b>.</p>
                        <p><b>To:</b> {receiverInput}</p>
                        <p><b>Date:</b> {DateTime.Now}</p>
                        <br/>
                        <p>Thank you for banking with us.</p>";

                        senderEmailResult = EmailHelper.SendEmail(userEmail, subject, body);
                    }

                    // 9. Send Email Notification to Receiver
                    MySqlCommand getReceiverInfo = new MySqlCommand("SELECT Email, FullName FROM Users WHERE UserID=@id", con);
                    getReceiverInfo.Parameters.AddWithValue("@id", receiverId);

                    using (MySqlDataReader loader = getReceiverInfo.ExecuteReader())
                    {
                        if (loader.Read() && loader["Email"] != DBNull.Value)
                        {
                            recEmail = loader["Email"].ToString();
                            string recName = loader["FullName"].ToString();

                            string recSubject = "You received ₹" + amount;
                            string recBody = $@"
                        <h2>Money Received</h2>
                        <p>Hello {recName},</p>
                        <p>You have received <b>₹{amount}</b> in your wallet.</p>
                        <p><b>Date:</b> {DateTime.Now}</p>
                        <br/>
                        <p>Login to check your balance.</p>";

                            recEmailResult = EmailHelper.SendEmail(recEmail, recSubject, recBody);
                        }
                    }

                    Response.Write("<script>alert('Money sent successfully! \\nSender (" + userEmail + "): " + senderEmailResult + "\\nReceiver (" + recEmail + "): " + recEmailResult + "');window.location='Dashboard.aspx';</script>");

                }
                catch (Exception ex)
                {
                   try { transaction.Rollback(); } catch { }
                   System.Diagnostics.Debug.WriteLine(ex.ToString());
                   Response.Write("<script>alert('Transaction Failed. No money was deducted. Error: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
        }
    }
}