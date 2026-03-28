using System;
using System.Configuration;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineBankingTransactionSystem
{
    public partial class LinkBankAccount : System.Web.UI.Page
    {
        readonly string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Optional: Ensure table exists (fail-safe)
                DatabaseSetupHelper.CreateBankAccountsTable();
            }
        }

        protected void btnLink_Click(object sender, EventArgs e)
        {
            if (!ValidateInput()) return;

            // Show OTP Modal
            pnlForm.Visible = false;
            pnlOTP.Visible = true;
        }

        protected void btnVerifyOTP_Click(object sender, EventArgs e)
        {
            // Simulate OTP Verification (Always success for '123456' or any input for now as per plan)
            LinkAccount();
        }

        private void LinkAccount()
        {
            string bankName = txtBankName.Text.Trim();
            string accNum = txtAccountNumber.Text.Trim();
            string ifsc = txtIFSC.Text.Trim();
            string accType = ddlAccountType.SelectedValue;
            int userId = Convert.ToInt32(Session["UserID"]);

            // Simulate Balance (Random between 10k and 1L)
            Random rand = new Random();
            decimal balance = rand.Next(10000, 100000);

            try
            {
                string encryptedAccNum = SecurityHelper.Encrypt(accNum);

                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();

                    // Check Duplicate
                    string checkQuery = "SELECT COUNT(*) FROM BankAccounts WHERE AccountNumber = @acc AND BankName = @bank";
                    using (MySqlCommand checkCmd = new MySqlCommand(checkQuery, con))
                    {
                        checkCmd.Parameters.AddWithValue("@acc", encryptedAccNum);
                        checkCmd.Parameters.AddWithValue("@bank", bankName);
                        int count = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowError("This bank account is already linked.");
                            pnlOTP.Visible = false;
                            pnlForm.Visible = true;
                            return;
                        }
                    }

                    string query = @"INSERT INTO BankAccounts (UserID, BankName, AccountNumber, IFSC, AccountType, Balance, IsVerified) 
                                   VALUES (@uid, @bank, @acc, @ifsc, @type, @bal, 1)";

                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@uid", userId);
                        cmd.Parameters.AddWithValue("@bank", bankName);
                        cmd.Parameters.AddWithValue("@acc", encryptedAccNum);
                        cmd.Parameters.AddWithValue("@ifsc", ifsc);
                        cmd.Parameters.AddWithValue("@type", accType);
                        cmd.Parameters.AddWithValue("@bal", balance);
                        cmd.ExecuteNonQuery();
                    }

                    // Success
                    Response.Write("<script>alert('✅ Bank Account Linked Successfully!');window.location='AddMoney.aspx';</script>");
                }
            }
            catch (Exception ex)
            {
                ShowError("Error: " + ex.Message);
                pnlOTP.Visible = false;
                pnlForm.Visible = true;
            }
        }

        private bool ValidateInput()
        {
            lblMessage.Visible = false;

            if (string.IsNullOrWhiteSpace(txtBankName.Text))
            {
                ShowError("Please enter Bank Name");
                return false;
            }
            if (string.IsNullOrWhiteSpace(txtAccountNumber.Text))
            {
                ShowError("Please enter Account Number");
                return false;
            }
            if (string.IsNullOrWhiteSpace(txtIFSC.Text))
            {
                ShowError("Please enter IFSC Code");
                return false;
            }
            return true;
        }

        private void ShowError(string msg)
        {
            lblMessage.Text = msg;
            lblMessage.Visible = true;
        }
    }
}
