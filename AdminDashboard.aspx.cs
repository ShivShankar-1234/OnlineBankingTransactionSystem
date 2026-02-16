using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;
using System.Web.UI.WebControls;

namespace OnlineBankingTransactionSystem
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 🔐 Admin security check
            if (Session["Role"] == null || Session["Role"].ToString() != "ADMIN")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadPendingKYC();
            }
        }

        void LoadPendingKYC()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                // ✅ ERROR FIXED: 'k.Status' ki jagah 'k.KYCStatus' use kiya hai
                // 'AS Status' isliye lagaya taaki GridView mein column ka naam change na ho
                MySqlDataAdapter da = new MySqlDataAdapter(
                @"SELECT 
                    u.UserID,
                    u.FullName,
                    u.Email,
                    k.AadhaarNumber,
                    k.PANNumber,
                    k.KYCStatus AS Status  
                  FROM Users u
                  INNER JOIN UserKYC k ON u.UserID = k.UserID
                  WHERE k.KYCStatus = 'PENDING'", con);

                DataTable dt = new DataTable();
                da.Fill(dt); // Ab yahan koi error nahi aayega

                gvKYC.DataSource = dt;
                gvKYC.DataBind();
            }
        }

        protected void Approve_Click(object sender, EventArgs e)
        {
            // Button se UserID nikal rahe hain
            Button btn = (Button)sender;
            if (string.IsNullOrEmpty(btn.CommandArgument)) return;

            int uid = Convert.ToInt32(btn.CommandArgument);

            // ✅ ERROR FIXED: 'Status' ki jagah 'KYCStatus'
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();
                MySqlCommand cmd = new MySqlCommand(
                    "UPDATE UserKYC SET KYCStatus='VERIFIED', ApprovedAt=NOW() WHERE UserID=@uid",
                    con);

                cmd.Parameters.AddWithValue("@uid", uid);
                cmd.ExecuteNonQuery();
            }

            // Notification bhejna
            SendNotification(uid, "✅ Your KYC has been Approved successfully!");

            Response.Write("<script>alert('KYC Approved Successfully');</script>");

            // GridView refresh karein
            LoadPendingKYC();
        }

        protected void Reject_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            if (string.IsNullOrEmpty(btn.CommandArgument)) return;

            int uid = Convert.ToInt32(btn.CommandArgument);

            // Reject karne ke liye helper function call kiya
            UpdateKYC(uid, "REJECTED");

            // Notification bhejna
            SendNotification(uid, "❌ Your KYC was rejected. Please check details and re-submit.");

            Response.Write("<script>alert('KYC Rejected');</script>");
            LoadPendingKYC();
        }

        // Helper function to update status
        void UpdateKYC(int uid, string status)
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();
                // ✅ ERROR FIXED: 'Status' -> 'KYCStatus'
                MySqlCommand cmd = new MySqlCommand(
                    @"UPDATE UserKYC 
                      SET KYCStatus=@s, ApprovedAt=NOW()
                      WHERE UserID=@u", con);

                cmd.Parameters.AddWithValue("@s", status);
                cmd.Parameters.AddWithValue("@u", uid);
                cmd.ExecuteNonQuery();
            }
        }

        // Helper function to send notification
        void SendNotification(int uid, string msg)
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();
                MySqlCommand cmd = new MySqlCommand(
                    "INSERT INTO Notifications(UserID, Message) VALUES(@u,@m)", con);

                cmd.Parameters.AddWithValue("@u", uid);
                cmd.Parameters.AddWithValue("@m", msg);
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}