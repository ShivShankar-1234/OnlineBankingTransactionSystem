using MySql.Data.MySqlClient;
using System;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    public partial class AdminLogin : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open(); // ✅ FIRST OPEN CONNECTION

                MySqlCommand cmd = new MySqlCommand(
                    "SELECT UserID FROM Users WHERE Email=@e AND Password=@p AND Role='ADMIN'",
                    con);

                cmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@p", txtPassword.Text.Trim());

                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    Session["AdminID"] = result.ToString();
                    Session["Role"] = "ADMIN";

                    Response.Redirect("AdminDashboard.aspx");
                }
                else
                {
                    Response.Write("<script>alert('Invalid Admin Credentials');</script>");
                }
            }
        }
    }
}
