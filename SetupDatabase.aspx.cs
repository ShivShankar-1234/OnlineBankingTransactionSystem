using System;

namespace OnlineBankingTransactionSystem
{
    public partial class SetupDatabase : System.Web.UI.Page
    {
        protected void btnSetup_Click(object sender, EventArgs e)
        {
            // Check if table already exists
            if (DatabaseSetupHelper.CheckIfTableExists())
            {
                lblMessage.Text = "ℹ️ Beneficiaries table already exists. No action needed.";
                lblMessage.CssClass = "message info";
                return;
            }

            // Create the table
            string result = DatabaseSetupHelper.CreateBeneficiariesTable();
            
            if (result.StartsWith("✅"))
            {
                lblMessage.Text = result;
                lblMessage.CssClass = "message success";
            }
            else
            {
                lblMessage.Text = result;
                lblMessage.CssClass = "message error";
            }
        }
    }
}
