using MySql.Data.MySqlClient;
using System;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    public partial class KYC_New : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                CheckExistingKYC();
        }

        void CheckExistingKYC()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                // ✅ FIXED: 'Status' ko badal kar 'KYCStatus' kar diya
                MySqlCommand cmd = new MySqlCommand(
                    "SELECT KYCStatus FROM UserKYC WHERE UserID=@uid", con);

                cmd.Parameters.AddWithValue("@uid", Session["UserID"]);
                con.Open();

                object status = cmd.ExecuteScalar();

                if (status == null)
                    return;

                string kycStatus = status.ToString().ToUpper();

                if (kycStatus == "VERIFIED")
                {
                    Response.Write("<script>alert('Your KYC is already VERIFIED');window.location='Dashboard.aspx';</script>");
                }
                else if (kycStatus == "PENDING")
                {
                    lblStatus.Text = "⏳ Your KYC is currently under review. Please wait for admin approval.";
                    lblStatus.ForeColor = System.Drawing.Color.Orange;
                    DisableForm();
                }
                else if (kycStatus == "REJECTED")
                {
                    lblStatus.Text = "❌ Your previous KYC was rejected. Please submit correct details.";
                    lblStatus.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        void DisableForm()
        {
            txtAadhaar.Enabled = false;
            txtPAN.Enabled = false;
            btnSubmit.Enabled = false;
            btnSubmit.Text = "Under Review";
            btnSubmit.CssClass = "btn-disabled"; // Assuming you might want to style it, or just rely on Enabled=false default styling
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (txtAadhaar.Text.Length != 12)
            {
                lblStatus.Text = "❌ Aadhaar must be 12 digits";
                return;
            }

            if (txtPAN.Text.Length != 10)
            {
                lblStatus.Text = "❌ Invalid PAN number";
                return;
            }

            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();

                // Check if user already exists in KYC table
                MySqlCommand check = new MySqlCommand(
                    "SELECT COUNT(*) FROM UserKYC WHERE UserID=@uid", con);
                check.Parameters.AddWithValue("@uid", Session["UserID"]);

                int exists = Convert.ToInt32(check.ExecuteScalar());

                MySqlCommand cmd;

                if (exists > 0)
                {
                    // UPDATE QUERY
                    // ✅ FIXED: 'Status' -> 'KYCStatus'
                    cmd = new MySqlCommand(
                        @"UPDATE UserKYC
                          SET AadhaarNumber=@a,
                              PANNumber=@p,
                              KYCStatus='PENDING',
                              SubmittedAt=NOW()
                          WHERE UserID=@uid", con);
                }
                else
                {
                    // INSERT QUERY
                    // ✅ FIXED: 'Status' -> 'KYCStatus'
                    cmd = new MySqlCommand(
                        @"INSERT INTO UserKYC (UserID, AadhaarNumber, PANNumber, KYCStatus)
                          VALUES (@uid, @a, @p, 'PENDING')", con);
                }

                cmd.Parameters.AddWithValue("@uid", Session["UserID"]);
                cmd.Parameters.AddWithValue("@a", txtAadhaar.Text.Trim());
                cmd.Parameters.AddWithValue("@p", txtPAN.Text.Trim());

                cmd.ExecuteNonQuery();

                lblStatus.Text = "✅ KYC Submitted. Waiting for admin approval.";

                // Optional: Refresh page logic if needed
                Response.Write("<script>alert('KYC Submitted Successfully!');window.location='Dashboard.aspx';</script>");
            }
        }
    }
}