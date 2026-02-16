using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;

namespace OnlineBankingTransactionSystem
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadBalance();
                CheckKYCStatus();
                LoadNotifications();
                LoadMiniStatement();
            }
        }

        void LoadBalance()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                // Balance Users table se hi aayega
                string query = "SELECT Balance FROM Users WHERE UserID=@id";
                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", Session["UserID"]);

                con.Open();
                object result = cmd.ExecuteScalar();

                if (result != null && result != DBNull.Value)
                {
                    lblBalance.Text = "₹ " + Convert.ToDecimal(result).ToString("0.00");
                }
                else
                {
                    lblBalance.Text = "₹ 0.00";
                }
            }
        }

        void CheckKYCStatus()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                // ✅ FIXED: Ab ye 'UserKYC' table aur 'KYCStatus' column use karega
                string query = "SELECT KYCStatus FROM UserKYC WHERE UserID=@id";

                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", Session["UserID"]);

                con.Open();
                object result = cmd.ExecuteScalar();

                string status = result == null ? "NOT_SUBMITTED" : result.ToString().ToUpper();

                if (status == "VERIFIED")
                {
                    lblKYC.Text = "✅ VERIFIED";
                    lblKYC.ForeColor = System.Drawing.Color.LightGreen;
                }
                else if (status == "PENDING")
                {
                    lblKYC.Text = "⏳ PENDING";
                    lblKYC.ForeColor = System.Drawing.Color.Orange;
                }
                else if (status == "REJECTED")
                {
                    lblKYC.Text = "❌ REJECTED";
                    lblKYC.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblKYC.Text = "❌ NOT SUBMITTED";
                    lblKYC.ForeColor = System.Drawing.Color.Gray;
                }
            }
        }

        void LoadNotifications()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();
                MySqlDataAdapter da = new MySqlDataAdapter(
                    "SELECT Message, CreatedAt FROM Notifications WHERE UserID=@uid ORDER BY CreatedAt DESC",
                    con);

                da.SelectCommand.Parameters.AddWithValue("@uid", Session["UserID"]);

                DataTable dt = new DataTable();
                da.Fill(dt);

                rptNotify.DataSource = dt;
                rptNotify.DataBind();

                lblNotifyCount.Text = dt.Rows.Count > 0 ? dt.Rows.Count.ToString() : "";
            }
        }

        protected void btnAddMoney_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddMoney.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        void LoadMiniStatement()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                con.Open();
                string query = @"
                    SELECT * FROM Transactions 
                    WHERE SenderID=@uid OR ReceiverID=@uid 
                    ORDER BY TxnDate DESC LIMIT 5";

                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@uid", Session["UserID"]);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Add formatting columns
                dt.Columns.Add("Description", typeof(string));
                dt.Columns.Add("Sign", typeof(string));
                dt.Columns.Add("Color", typeof(string));

                int currentUserId = Convert.ToInt32(Session["UserID"]);

                foreach (DataRow row in dt.Rows)
                {
                    int senderId = Convert.ToInt32(row["SenderID"]);
                    string refName = row["ReferenceName"].ToString();
                    
                    if (senderId == currentUserId)
                    {
                        // Sent Money
                        row["Description"] = "Sent to " + refName;
                        row["Sign"] = "-";
                        row["Color"] = "color: red;";
                    }
                    else
                    {
                        // Received Money
                        row["Description"] = "Received from " + refName; 
                        row["Sign"] = "+";
                        row["Color"] = "color: green;";
                    }
                }

                gvMiniStatement.DataSource = dt;
                gvMiniStatement.DataBind();
            }
        }
    }
}