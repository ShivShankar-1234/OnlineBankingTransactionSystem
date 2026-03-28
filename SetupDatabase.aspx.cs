using System;

namespace OnlineBankingTransactionSystem
{
    public partial class SetupDatabase : System.Web.UI.Page
    {
        protected void btnSetup_Click(object sender, EventArgs e)
        {
            // Check if table already exists
            // Create the table
            string status = "";
            bool success = false;

            // 1. Create Users Table (Core Dependency)
            string usersResult = DatabaseSetupHelper.CreateUsersTable();
            status += usersResult + "<br/>";
            if (usersResult.StartsWith("✅")) success = true;

            // Check/Create Beneficiaries Table
            if (DatabaseSetupHelper.CheckIfTableExists())
            {
               status += "ℹ️ Beneficiaries table already exists.<br/>";
            }
            else
            {
               string beneficiariesResult = DatabaseSetupHelper.CreateBeneficiariesTable();
               status += beneficiariesResult + "<br/>";
               if (beneficiariesResult.StartsWith("✅")) success = true;
            }

            string adminResult = DatabaseSetupHelper.EnsureAdminUser();
            status += adminResult + "<br/>";
            if (adminResult.StartsWith("✅")) success = true;

            string bankAccountResult = DatabaseSetupHelper.CreateBankAccountsTable();
            status += bankAccountResult + "<br/>";
            if (bankAccountResult.StartsWith("✅")) success = true;
            
            // Call new schema update methods
            string usersSchemaUpdateResult = DatabaseSetupHelper.UpdateUsersTableSchema();
            status += usersSchemaUpdateResult + "<br/>";
            if (usersSchemaUpdateResult.StartsWith("✅")) success = true;

            string bankAccountsSchemaUpdateResult = DatabaseSetupHelper.UpdateBankAccountsTableSchema();
            status += bankAccountsSchemaUpdateResult + "<br/>";
            if (bankAccountsSchemaUpdateResult.StartsWith("✅")) success = true;

            string fdResult = DatabaseSetupHelper.CreateFixedDepositsTable();
            status += fdResult + "<br/>";
            if (fdResult.StartsWith("✅")) success = true;

            string txnResult = DatabaseSetupHelper.CreateTransactionsTable();
            status += txnResult + "<br/>";
            if (txnResult.StartsWith("✅")) success = true;

            string notifResult = DatabaseSetupHelper.CreateNotificationsTable();
            status += notifResult + "<br/>";
            if (notifResult.StartsWith("✅")) success = true;

            string kycResult = DatabaseSetupHelper.CreateUserKYCTable();
            status += kycResult + "<br/>";
            if (kycResult.StartsWith("✅")) success = true;

            if (success)
            {
                lblMessage.Text = status;
                lblMessage.CssClass = "message success";
            }
            else
            {
                lblMessage.Text = status;
                lblMessage.CssClass = "message error";
            }
        }
    }
}
