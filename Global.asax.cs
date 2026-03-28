using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;

namespace OnlineBankingTransactionSystem
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            // Auto-fix database schema on startup (adds missing columns if any)
            try
            {
                DatabaseSetupHelper.CreateUsersTable();
                DatabaseSetupHelper.UpdateUsersTableSchema();
                DatabaseSetupHelper.CreateTransactionsTable();
                DatabaseSetupHelper.CreateNotificationsTable();
                DatabaseSetupHelper.CreateUserKYCTable();
                DatabaseSetupHelper.CreateBeneficiariesTable();
                DatabaseSetupHelper.CreateBankAccountsTable();
                DatabaseSetupHelper.UpdateBankAccountsTableSchema();
                DatabaseSetupHelper.CreateFixedDepositsTable();
                DatabaseSetupHelper.EnsureAdminUser();
            }
            catch { /* Silently ignore if DB is not yet available */ }
        }
    }
}