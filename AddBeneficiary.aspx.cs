using MySql.Data.MySqlClient;
using System;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    public partial class AddBeneficiary : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;
        private int verifiedBeneficiaryUserID = -1;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Table check removed to prevent redirect loop.

            // Store verified ID in ViewState
            if (ViewState["VerifiedBeneficiaryUserID"] != null)
            {
                verifiedBeneficiaryUserID = (int)ViewState["VerifiedBeneficiaryUserID"];
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            string recipient = txtRecipient.Text.Trim();

            if (string.IsNullOrEmpty(recipient))
            {
                ShowError("Please enter a recipient Email, Mobile, or UPI ID");
                return;
            }

            using (MySqlConnection con = new MySqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Find user by Email, Mobile, or UPI
                    MySqlCommand cmd = new MySqlCommand(
                        "SELECT UserID, FullName, Email FROM Users WHERE Email=@v OR Mobile=@v OR UPI_ID=@v",
                        con);
                    cmd.Parameters.AddWithValue("@v", recipient);

                    MySqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        int foundUserId = Convert.ToInt32(dr["UserID"]);
                        string fullName = dr["FullName"].ToString();
                        string email = dr["Email"].ToString();

                        dr.Close();

                        // Check if trying to add self
                        if (foundUserId == Convert.ToInt32(Session["UserID"]))
                        {
                            ShowError("❌ You cannot add yourself as a beneficiary");
                            return;
                        }

                        // Check if already exists
                        MySqlCommand checkCmd = new MySqlCommand(
                            "SELECT COUNT(*) FROM Beneficiaries WHERE UserID=@uid AND BeneficiaryUserID=@buid",
                            con);
                        checkCmd.Parameters.AddWithValue("@uid", Session["UserID"]);
                        checkCmd.Parameters.AddWithValue("@buid", foundUserId);

                        int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                        if (exists > 0)
                        {
                            ShowError("❌ This beneficiary already exists in your list");
                            return;
                        }

                        // Success - show recipient info
                        lblRecipientName.Text = $"<strong>{fullName}</strong><br/>Email: {email}";
                        pnlRecipientInfo.CssClass = "alert alert-success show";
                        pnlError.CssClass = "alert alert-error";

                        // Store verified user ID
                        ViewState["VerifiedBeneficiaryUserID"] = foundUserId;
                        verifiedBeneficiaryUserID = foundUserId;

                        // Auto-set nickname if empty
                        if (string.IsNullOrEmpty(txtNickname.Text))
                        {
                            txtNickname.Text = fullName;
                        }
                    }
                    else
                    {
                        dr.Close();
                        ShowError("❌ No user found with this Email/Mobile/UPI ID");
                    }
                }
                catch (Exception ex)
                {
                    ShowError("Error: " + ex.Message);
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Get verified user ID from ViewState
            if (ViewState["VerifiedBeneficiaryUserID"] == null)
            {
                ShowError("Please verify the recipient first");
                return;
            }

            int beneficiaryUserId = (int)ViewState["VerifiedBeneficiaryUserID"];
            string nickname = txtNickname.Text.Trim();

            if (string.IsNullOrEmpty(nickname))
            {
                ShowError("Please enter a nickname for this beneficiary");
                return;
            }

            using (MySqlConnection con = new MySqlConnection(cs))
            {
                try
                {
                    con.Open();

                    MySqlCommand cmd = new MySqlCommand(
                        @"INSERT INTO Beneficiaries (UserID, BeneficiaryUserID, Nickname) 
                          VALUES (@uid, @buid, @nick)",
                        con);

                    cmd.Parameters.AddWithValue("@uid", Session["UserID"]);
                    cmd.Parameters.AddWithValue("@buid", beneficiaryUserId);
                    cmd.Parameters.AddWithValue("@nick", nickname);

                    cmd.ExecuteNonQuery();

                    Response.Write("<script>alert('✅ Beneficiary added successfully!'); window.location='ManageBeneficiaries.aspx';</script>");
                }
                catch (MySqlException ex)
                {
                    if (ex.Number == 1062) // Duplicate entry
                    {
                        ShowError("This beneficiary already exists in your list");
                    }
                    else
                    {
                        ShowError("Database error: " + ex.Message);
                    }
                }
                catch (Exception ex)
                {
                    ShowError("Error: " + ex.Message);
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageBeneficiaries.aspx");
        }

        private void ShowError(string message)
        {
            lblError.Text = message;
            pnlError.CssClass = "alert alert-error show";
            pnlRecipientInfo.CssClass = "alert alert-success";
        }
    }
}
