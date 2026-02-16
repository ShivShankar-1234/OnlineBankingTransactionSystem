using MySql.Data.MySqlClient;
using System;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    public partial class Login : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open(); // ✅ MUST

                MySqlCommand cmd = new MySqlCommand(
                    @"SELECT UserID, Email, Role 
                      FROM Users 
                      WHERE Email=@e AND Password=@p", con);

                cmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@p", txtPassword.Text.Trim());

                MySqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    // ✅ Session set
                    Session["UserID"] = dr["UserID"].ToString();
                    Session["Email"] = dr["Email"].ToString();
                    Session["Role"] = dr["Role"].ToString();

                    // ✅ Role based redirect
                    if (Session["Role"].ToString() == "ADMIN")
                        Response.Redirect("AdminDashboard.aspx");
                    else
                        Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    Response.Write("<script>alert('Invalid email or password');</script>");
                }
            }
        }
    }
}
