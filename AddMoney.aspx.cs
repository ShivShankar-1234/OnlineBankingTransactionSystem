using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Web.UI.WebControls;

namespace OnlineBankingTransactionSystem
{
    public partial class AddMoney : System.Web.UI.Page
    {
        readonly string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (GetKYCStatus() != "VERIFIED")
            {
                Response.Write("<script>alert('⚠ Please complete KYC before using this service.');window.location='KYC_New.aspx';</script>");
                return;
            }

            if (!IsPostBack)
            {
                LoadLinkedBanks(Convert.ToInt32(Session["UserID"]));
            }
        }

        private void LoadLinkedBanks(int userId)
        {
            try
            {
                LoadLinkedBanksInternal(userId);
            }
            catch (MySqlException ex) when (ex.Message.Contains("Unknown column"))
            {
                // Balance or AccountType column missing — auto-fix and retry
                DatabaseSetupHelper.UpdateBankAccountsTableSchema();
                LoadLinkedBanksInternal(userId);
            }
        }

        private void LoadLinkedBanksInternal(int userId)
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();
                string query = "SELECT BankAccountID, BankName, AccountNumber, Balance FROM BankAccounts WHERE UserID = @uid AND IsVerified = 1";
                using (MySqlCommand cmd = new MySqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    using (MySqlDataReader dr = cmd.ExecuteReader())
                    {
                        ddlBanks.Items.Clear();
                        ddlBanks.Items.Add(new ListItem("-- Select Bank Account --", "0"));

                        while (dr.Read())
                        {
                            string bankName = dr["BankName"].ToString();
                            string encryptedAcc = dr["AccountNumber"].ToString(); // Encrypted
                            string decryptedAcc = SecurityHelper.Decrypt(encryptedAcc);
                            string maskAcc = decryptedAcc.Length > 4 ? decryptedAcc.Substring(decryptedAcc.Length - 4) : decryptedAcc;
                            decimal balance = Convert.ToDecimal(dr["Balance"]);

                            ListItem item = new ListItem(bankName + " - " + maskAcc + " (Bal: ₹" + balance.ToString("0.00") + ")", dr["BankAccountID"].ToString());
                            item.Attributes.Add("data-balance", balance.ToString());
                            ddlBanks.Items.Add(item);
                        }
                    }
                }
            }
        }

        private string GetKYCStatus()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                string query = "SELECT KYCStatus FROM UserKYC WHERE UserID=@id";
                using (MySqlCommand cmd = new MySqlCommand(query, con))
                {
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
        }

        protected void AddButton_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!decimal.TryParse(txtAmount.Text, out decimal amount) || amount <= 0)
            {
                Response.Write("<script>alert('Please enter a valid amount');</script>");
                return;
            }

            string bankValue = ddlBanks.SelectedValue;
            if (bankValue == "0")
            {
                Response.Write("<script>alert('Please select a bank account');</script>");
                return;
            }

            int bankAccountId = Convert.ToInt32(bankValue);
            int userId = Convert.ToInt32(Session["UserID"]);

            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();
                MySqlTransaction txn = con.BeginTransaction();
                try
                {
                    // 1. Check Balance
                    string checkQuery = "SELECT Balance FROM BankAccounts WHERE BankAccountID=@bid AND UserID=@uid";
                    MySqlCommand checkCmd = new MySqlCommand(checkQuery, con, txn);
                    checkCmd.Parameters.AddWithValue("@bid", bankAccountId);
                    checkCmd.Parameters.AddWithValue("@uid", userId);

                    object balanceObj = checkCmd.ExecuteScalar();
                    if (balanceObj == null)
                    {
                        txn.Rollback();
                        Response.Write("<script>alert('Bank account not found');</script>");
                        return;
                    }

                    decimal bankBalance = Convert.ToDecimal(balanceObj);
                    if (bankBalance < amount)
                    {
                        txn.Rollback();
                        Response.Write("<script>alert('Insufficient balance in selected bank account');</script>");
                        return;
                    }

                    // 2. Deduct from Bank Account
                    string deductQuery = "UPDATE BankAccounts SET Balance = Balance - @amt WHERE BankAccountID=@bid";
                    MySqlCommand deductCmd = new MySqlCommand(deductQuery, con, txn);
                    deductCmd.Parameters.AddWithValue("@amt", amount);
                    deductCmd.Parameters.AddWithValue("@bid", bankAccountId);
                    deductCmd.ExecuteNonQuery();

                    // 3. Add to User Wallet
                    string addQuery = "UPDATE Users SET Balance = Balance + @amt WHERE UserID=@uid";
                    MySqlCommand addCmd = new MySqlCommand(addQuery, con, txn);
                    addCmd.Parameters.AddWithValue("@amt", amount);
                    addCmd.Parameters.AddWithValue("@uid", userId);
                    addCmd.ExecuteNonQuery();

                    // 4. Record Transaction
                    string logQuery = "INSERT INTO Transactions (SenderID, ReceiverID, ReferenceName, Amount, TxnType) VALUES (@uid, @uid, 'Self (Add Money)', @amt, 'BANK_ADD')";
                    MySqlCommand logCmd = new MySqlCommand(logQuery, con, txn);
                    logCmd.Parameters.AddWithValue("@uid", userId);
                    logCmd.Parameters.AddWithValue("@amt", amount);
                    logCmd.ExecuteNonQuery();

                    txn.Commit();

                    // Refresh UI
                    LoadLinkedBanks(userId);
                    Response.Write("<script>alert('✅ Money added successfully');window.location='Dashboard.aspx';</script>");
                }
                catch (Exception ex)
                {
                    txn.Rollback();
                    string cleanMsg = ex.Message.Replace("'", "");
                    Response.Write("<script>alert('Error: " + cleanMsg + "');</script>");
                }
            } // End Using
        } // End Method
    } // End Class
} // End Namespace