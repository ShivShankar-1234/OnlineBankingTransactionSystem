using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;
using System.Web.UI.WebControls;

namespace OnlineBankingTransactionSystem
{
    public partial class FixedDeposit : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;
        const decimal INTEREST_RATE = 6.5m; // Simple logic for demo

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Initial Calc
                lblInterestRate.Text = INTEREST_RATE.ToString() + "%";
                CalculateMaturity(null, null);
                LoadMyFDs();
            }
        }

        protected void CalculateMaturity(object sender, EventArgs e)
        {
            if (decimal.TryParse(txtAmount.Text, out decimal principal) && principal > 0)
            {
                int months = Convert.ToInt32(ddlTenure.SelectedValue);
                decimal rate = INTEREST_RATE;

                // Formula: A = P(1 + (r/n))^(nt) -> Compound Interest? 
                // Let's use Simple Interest for simplicity or basic Compounding Quarterly
                // A = P * (1 + r/400)^(4 * years)
                
                double years = months / 12.0;
                double amount = (double)principal * Math.Pow((1 + (double)rate / 400.0), 4 * years);
                
                lblMaturityAmount.Text = "₹" + amount.ToString("N2");
                lblMaturityDate.Text = DateTime.Now.AddMonths(months).ToString("dd-MMM-yyyy");
            }
            else
            {
                lblMaturityAmount.Text = "₹0.00";
                lblMaturityDate.Text = "-";
            }
        }

        protected void btnInvest_Click(object sender, EventArgs e)
        {
            if (!decimal.TryParse(txtAmount.Text, out decimal principal) || principal < 1000)
            {
                ShowMessage("Minimim investment amount is ₹1,000", "error");
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);
            int months = Convert.ToInt32(ddlTenure.SelectedValue);
            
            // Recalculate maturity to be safe
            double years = months / 12.0;
            decimal maturityAmount = (decimal)((double)principal * Math.Pow((1 + (double)INTEREST_RATE / 400.0), 4 * years));
            DateTime maturityDate = DateTime.Now.AddMonths(months);

            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();
                MySqlTransaction txn = con.BeginTransaction();

                try
                {
                    // 1. Check Balance
                    string balQuery = "SELECT Balance FROM Users WHERE UserID=@uid";
                    MySqlCommand cmdBal = new MySqlCommand(balQuery, con, txn);
                    cmdBal.Parameters.AddWithValue("@uid", userId);
                    object result = cmdBal.ExecuteScalar();
                    decimal currentBal = result != null ? Convert.ToDecimal(result) : 0;

                    if (currentBal < principal)
                    {
                        txn.Rollback();
                        ShowMessage("Insufficient wallet balance.", "error");
                        return;
                    }

                    // 2. Deduct Balance
                    string deductQuery = "UPDATE Users SET Balance = Balance - @amt WHERE UserID=@uid";
                    MySqlCommand cmdDeduct = new MySqlCommand(deductQuery, con, txn);
                    cmdDeduct.Parameters.AddWithValue("@amt", principal);
                    cmdDeduct.Parameters.AddWithValue("@uid", userId);
                    cmdDeduct.ExecuteNonQuery();

                    // 3. Create FD
                    string fdQuery = "INSERT INTO FixedDeposits (UserID, PrincipalAmount, InterestRate, TenureMonths, MaturityDate, MaturityAmount, Status) VALUES (@uid, @p, @r, @t, @d, @m, 'ACTIVE')";
                    MySqlCommand cmdFD = new MySqlCommand(fdQuery, con, txn);
                    cmdFD.Parameters.AddWithValue("@uid", userId);
                    cmdFD.Parameters.AddWithValue("@p", principal);
                    cmdFD.Parameters.AddWithValue("@r", INTEREST_RATE);
                    cmdFD.Parameters.AddWithValue("@t", months);
                    cmdFD.Parameters.AddWithValue("@d", maturityDate);
                    cmdFD.Parameters.AddWithValue("@m", maturityAmount);
                    cmdFD.ExecuteNonQuery();

                    // 4. Record Transaction
                    string txnQuery = "INSERT INTO Transactions (SenderID, ReceiverID, ReferenceName, Amount, TxnType) VALUES (@uid, @uid, 'Fixed Deposit Open', @amt, 'FD_OPEN')";
                    MySqlCommand cmdTxn = new MySqlCommand(txnQuery, con, txn);
                    cmdTxn.Parameters.AddWithValue("@uid", userId);
                    cmdTxn.Parameters.AddWithValue("@amt", principal);
                    cmdTxn.ExecuteNonQuery();

                    txn.Commit();

                    ShowMessage("✅ Fixed Deposit Opened Successfully!", "success");
                    LoadMyFDs();
                    txtAmount.Text = "";
                }
                catch (Exception ex)
                {
                    txn.Rollback();
                    ShowMessage("Error: " + ex.Message, "error");
                }
            }
        }

        private void LoadMyFDs()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                string query = "SELECT * FROM FixedDeposits WHERE UserID=@uid ORDER BY CreatedAt DESC";
                using (MySqlCommand cmd = new MySqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@uid", Session["UserID"]);
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvFDs.DataSource = dt;
                        gvFDs.DataBind();
                    }
                }
            }
        }

        private void ShowMessage(string msg, string type)
        {
            lblMessage.Text = msg;
            pnlMessage.CssClass = type == "success" ? "alert alert-success" : "alert alert-danger";
            pnlMessage.Visible = true;
        }
    }
}
