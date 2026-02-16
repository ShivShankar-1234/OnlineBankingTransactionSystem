using MySql.Data.MySqlClient;
using System;
using System.Configuration;

namespace OnlineBankingTransactionSystem
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnTest_Click(object sender, EventArgs e)
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

            MySqlConnection con = new MySqlConnection(cs);

            try
            {
                con.Open();
                Response.Write("<script>alert('Database Connected Successfully');</script>");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
            finally
            {
                con.Close();
            }
        }
    }
}
