using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;
using System.Web.UI.WebControls;

namespace OnlineBankingTransactionSystem
{
    public partial class ManageBeneficiaries : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Check if table exists, if not redirect to setup
            if (!DatabaseSetupHelper.CheckIfTableExists())
            {
                Response.Redirect("SetupDatabase.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadBeneficiaries();
            }
        }

        void LoadBeneficiaries()
        {
            using (MySqlConnection con = new MySqlConnection(cs))
            {
                try
                {
                    con.Open();

                    string query = @"
                        SELECT 
                            b.BeneficiaryID,
                            b.Nickname,
                            u.Email AS BeneficiaryEmail,
                            u.Mobile AS BeneficiaryMobile,
                            b.CreatedAt
                        FROM Beneficiaries b
                        INNER JOIN Users u ON b.BeneficiaryUserID = u.UserID
                        WHERE b.UserID = @uid
                        ORDER BY b.CreatedAt DESC";

                    MySqlDataAdapter da = new MySqlDataAdapter(query, con);
                    da.SelectCommand.Parameters.AddWithValue("@uid", Session["UserID"]);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvBeneficiaries.DataSource = dt;
                    gvBeneficiaries.DataBind();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error loading beneficiaries: " + ex.Message + "');</script>");
                }
            }
        }

        protected void btnAddNew_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddBeneficiary.aspx");
        }

        protected void gvBeneficiaries_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteBeneficiary")
            {
                int beneficiaryId = Convert.ToInt32(e.CommandArgument);

                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    try
                    {
                        con.Open();

                        // Verify ownership before deleting
                        using (MySqlCommand deleteCmd = new MySqlCommand(
                            "DELETE FROM Beneficiaries WHERE BeneficiaryID = @bid AND UserID = @uid",
                            con))
                        {
                            deleteCmd.Parameters.AddWithValue("@bid", beneficiaryId);
                            deleteCmd.Parameters.AddWithValue("@uid", Session["UserID"]);

                            int rowsAffected = deleteCmd.ExecuteNonQuery();

                            if (rowsAffected > 0)
                            {
                                // Success - Reload grid
                                LoadBeneficiaries();
                            }
                            else
                            {
                                // Show error (optional, maybe use a label or script)
                                Response.Write("<script>alert('Unable to delete beneficiary.');</script>");
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
                    }
                }
            }
        }
    }
}
