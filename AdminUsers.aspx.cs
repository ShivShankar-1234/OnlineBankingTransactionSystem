using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;

namespace OnlineBankingTransactionSystem
{
    public partial class AdminUsers : System.Web.UI.Page
    {
        readonly string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "ADMIN")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
                LoadUsers();
        }

        private void LoadUsers(string search = "")
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                string query = @"
                    SELECT u.UserID, u.FullName, u.Email, u.AccountNumber, u.IFSC,
                           u.Balance, u.Role, u.CreatedAt,
                           k.KYCStatus
                    FROM Users u
                    LEFT JOIN UserKYC k ON u.UserID = k.UserID";

                if (!string.IsNullOrEmpty(search))
                    query += " WHERE u.FullName LIKE @s OR u.Email LIKE @s OR u.AccountNumber LIKE @s";

                query += " ORDER BY u.CreatedAt DESC";

                MySqlCommand cmd = new MySqlCommand(query, con);
                if (!string.IsNullOrEmpty(search))
                    cmd.Parameters.AddWithValue("@s", "%" + search + "%");

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvUsers.DataSource = dt;
                gvUsers.DataBind();

                lblCount.Text = dt.Rows.Count + " user(s) found";
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadUsers(txtSearch.Text.Trim());
        }

        // Helper for KYC CSS class
        protected string GetKycClass(object kycStatus)
        {
            if (kycStatus == null || kycStatus == DBNull.Value) return "kyc-none";
            switch (kycStatus.ToString().ToUpper())
            {
                case "VERIFIED": return "kyc-verified";
                case "PENDING":  return "kyc-pending";
                case "REJECTED": return "kyc-rejected";
                default:         return "kyc-none";
            }
        }
    }
}
