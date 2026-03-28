using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;

namespace OnlineBankingTransactionSystem
{
    public partial class AdminTransactions : System.Web.UI.Page
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
                LoadTransactions();
        }

        private void LoadTransactions(string search = "", string txnType = "")
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                string query = @"
                    SELECT TransactionID, SenderID, ReceiverID, ReferenceName,
                           Amount, TxnType, TxnDate
                    FROM Transactions
                    WHERE 1=1";

                if (!string.IsNullOrEmpty(search))
                    query += " AND (SenderID LIKE @s OR ReferenceName LIKE @s)";

                if (!string.IsNullOrEmpty(txnType))
                    query += " AND TxnType = @t";

                query += " ORDER BY TxnDate DESC LIMIT 500";

                MySqlCommand cmd = new MySqlCommand(query, con);

                if (!string.IsNullOrEmpty(search))
                    cmd.Parameters.AddWithValue("@s", "%" + search + "%");

                if (!string.IsNullOrEmpty(txnType))
                    cmd.Parameters.AddWithValue("@t", txnType);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();

                lblCount.Text = dt.Rows.Count + " transaction(s) found";
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadTransactions(txtSearch.Text.Trim(), ddlType.SelectedValue);
        }

        // Helper: amount CSS class by TxnType
        protected string GetAmtClass(object txnType)
        {
            if (txnType == null) return "amt-credit";
            switch (txnType.ToString().ToUpper())
            {
                case "TRANSFER":  return "amt-debit";
                case "BILL_PAY":  return "amt-bill";
                case "FD_OPEN":   return "amt-fd";
                case "ADD_MONEY": return "amt-credit";
                default:          return "amt-credit";
            }
        }

        // Helper: type chip CSS class
        protected string GetTypeClass(object txnType)
        {
            if (txnType == null) return "type-other";
            switch (txnType.ToString().ToUpper())
            {
                case "TRANSFER":  return "type-transfer";
                case "ADD_MONEY": return "type-add";
                case "BILL_PAY":  return "type-bill";
                case "FD_OPEN":   return "type-fd";
                default:          return "type-other";
            }
        }
    }
}
