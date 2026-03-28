using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;
using System.Web.UI.WebControls;

namespace OnlineBankingTransactionSystem
{
    public partial class AdminLinkedAccounts : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "ADMIN")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAccounts();
            }
        }

        private void LoadAccounts(string searchTerm = "")
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                string query = @"SELECT BankAccountID, UserID, BankName, AccountNumber, IFSC, AccountType, Balance, IsVerified, CreatedAt 
                               FROM BankAccounts";
                
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " WHERE UserID LIKE @search OR BankName LIKE @search";
                }

                query += " ORDER BY CreatedAt DESC";

                MySqlCommand cmd = new MySqlCommand(query, con);
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    cmd.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                }

                con.Open();
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Decrypt Account Numbers for display (masking logic)
                foreach(DataRow row in dt.Rows)
                {
                    string encrypted = row["AccountNumber"].ToString();
                    try {
                        string decrypted = SecurityHelper.Decrypt(encrypted);
                        // Mask: Show only last 4
                        row["AccountNumber"] = decrypted.Length > 4 ? "XXXX " + decrypted.Substring(decrypted.Length - 4) : decrypted;
                    } catch {
                        row["AccountNumber"] = "Error";
                    }
                }

                gvAccounts.DataSource = dt;
                gvAccounts.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadAccounts(txtSearch.Text.Trim());
        }
    }
}
