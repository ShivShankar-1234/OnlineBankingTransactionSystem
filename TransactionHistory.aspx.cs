using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;

namespace OnlineBankingTransactionSystem
{
    public partial class TransactionHistory : System.Web.UI.Page
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
                LoadHistory();
            }
        }

        void LoadHistory()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                MySqlDataAdapter da = new MySqlDataAdapter(@"
                    SELECT 
                        t.TxnDate AS TxnDate,
                        CASE 
                            WHEN t.SenderID = @uid THEN 
                                COALESCE(u2.Email, u2.Mobile, u2.UPI_ID, 'SELF / BILL')
                            ELSE 
                                COALESCE(u1.Email, u1.Mobile, u1.UPI_ID, 'SELF / BILL')
                        END AS CounterParty,
                        t.Amount,
                        t.TxnType
                    FROM Transactions t
                    LEFT JOIN Users u1 ON t.SenderID = u1.UserID
                    LEFT JOIN Users u2 ON t.ReceiverID = u2.UserID
                    WHERE t.SenderID = @uid OR t.ReceiverID = @uid
                    ORDER BY t.TxnDate DESC
                ", con);

                da.SelectCommand.Parameters.AddWithValue("@uid", Session["UserID"]);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvHistory.DataSource = dt;
                gvHistory.DataBind();
            }
        }
    }
}
