using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;

namespace OnlineBankingTransactionSystem
{
    public partial class AdminKYC : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 🔐 Admin check
            if (Session["Role"] == null || Session["Role"].ToString() != "ADMIN")
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadPendingKYC();
        }

        void LoadPendingKYC()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                MySqlDataAdapter da = new MySqlDataAdapter(
                    "SELECT UserID, AadhaarNumber, PANNumber, KYCStatus FROM UserKYC WHERE KYCStatus='PENDING'",
                    con);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvKYC.DataSource = dt;
                gvKYC.DataBind();
            }
        }

        protected void gvKYC_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int userId = Convert.ToInt32(e.CommandArgument);

            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();

                if (e.CommandName == "APPROVE")
                {
                    MySqlCommand cmd = new MySqlCommand(
                        @"UPDATE UserKYC 
                          SET KYCStatus='VERIFIED',
                              ApprovedAt=NOW(),
                              ApprovedBy=@admin
                          WHERE UserID=@uid", con);

                    cmd.Parameters.AddWithValue("@uid", userId);
                    cmd.Parameters.AddWithValue("@admin", Session["UserID"]);
                    cmd.ExecuteNonQuery();
                }

                if (e.CommandName == "REJECT")
                {
                    MySqlCommand cmd = new MySqlCommand(
                        @"UPDATE UserKYC 
                          SET KYCStatus='REJECTED'
                          WHERE UserID=@uid", con);

                    cmd.Parameters.AddWithValue("@uid", userId);
                    cmd.ExecuteNonQuery();
                }
            }

            LoadPendingKYC();
        }
    }
}
