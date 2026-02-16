using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Text.RegularExpressions;

namespace OnlineBankingTransactionSystem
{
    public partial class Register : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // ✅ MOBILE VALIDATION (EXACT 10 DIGITS)
            if (!Regex.IsMatch(txtMobile.Text.Trim(), @"^\d{10}$"))
            {
                Response.Write("<script>alert('Mobile number must be exactly 10 digits');</script>");
                return;
            }

            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();

                /* 
                // 1️⃣ Check user already exists
                MySqlCommand check = new MySqlCommand(
                    "SELECT COUNT(*) FROM Users WHERE Email=@e OR Mobile=@m", con);

                check.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
                check.Parameters.AddWithValue("@m", txtMobile.Text.Trim());

                int exists = Convert.ToInt32(check.ExecuteScalar());

                if (exists > 0)
                {
                    Response.Write("<script>alert('User already exists. Please login.');window.location='Login.aspx';</script>");
                    return;
                }
                */

                // 2️⃣ Insert new user
                MySqlCommand insert = new MySqlCommand(
 @"INSERT INTO Users
(FullName, Email, Password, Mobile, Balance, Role)
VALUES (@n, @e, @p, @m, 1000, 'USER')", con);

                insert.Parameters.AddWithValue("@n", txtName.Text.Trim());
                insert.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
                insert.Parameters.AddWithValue("@p", txtPassword.Text.Trim());
                insert.Parameters.AddWithValue("@m", txtMobile.Text.Trim());

                insert.ExecuteNonQuery();

                Response.Write("<script>alert('Registration successful. Please login.');window.location='Login.aspx';</script>");
            }
        }
    }
}
