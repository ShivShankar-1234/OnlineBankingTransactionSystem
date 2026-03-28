using MySql.Data.MySqlClient;
using System;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    public partial class Login : System.Web.UI.Page
    {
        readonly string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                Response.Redirect("Dashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    
                    // Fetch User by Email
                    string query = "SELECT UserID, Email, Password, Role, Status FROM Users WHERE Email=@e";
                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
                        string inputPassword = txtPassword.Text.Trim();

                        using (MySqlDataReader rdr = cmd.ExecuteReader())
                        {
                            if (rdr.Read())
                            {
                                string storedPassword = rdr["Password"].ToString();
                                string role = rdr["Role"].ToString();
                                string status = rdr["Status"].ToString();

                                if (status != "Active")
                                {
                                    Response.Write("<script>alert('Account is Inactive or Blocked.');</script>");
                                    return;
                                }

                                // Verify Password (Hash or Fallback)
                                bool isVerified = false;
                                if (SecurityHelper.VerifyPassword(inputPassword, storedPassword))
                                {
                                    isVerified = true;
                                }
                                else if (storedPassword == inputPassword) // Legacy Plain Text Fallback
                                {
                                    isVerified = true;
                                }

                                if (isVerified)
                                {
                                    Session["UserID"] = rdr["UserID"];
                                    Session["Email"] = rdr["Email"];
                                    Session["Role"] = role;

                                    if (role == "ADMIN")
                                        Response.Redirect("AdminDashboard.aspx");
                                    else
                                        Response.Redirect("Dashboard.aspx");
                                }
                                else
                                {
                                    Response.Write("<script>alert('Invalid Password.');</script>");
                                }
                            }
                            else
                            {
                                Response.Write("<script>alert('User not found.');</script>");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error: {ex.Message}');</script>");
            }
        }
    }
}
