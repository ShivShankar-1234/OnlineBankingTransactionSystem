using System;
using System.Web.UI;

namespace OnlineBankingTransactionSystem
{
    public partial class Main : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Set active navigation item based on current page
            string currentPage = System.IO.Path.GetFileName(Request.Url.AbsolutePath);
            
            switch (currentPage.ToLower())
            {
                case "dashboard.aspx":
                    navDashboard.Attributes["class"] = "nav-item active";
                    break;
                case "billpayment.aspx":
                    navBillPayment.Attributes["class"] = "nav-item active";
                    navMobileDTH.Attributes["class"] = "nav-item active";
                    break;
                case "sendmoney.aspx":
                    navSendMoney.Attributes["class"] = "nav-item active";
                    break;
                case "addmoney.aspx":
                    navAddMoney.Attributes["class"] = "nav-item active";
                    break;
                case "transactionhistory.aspx":
                    navTransactions.Attributes["class"] = "nav-item active";
                    break;
                case "managebeneficiaries.aspx":
                case "addbeneficiary.aspx":
                    navBeneficiaries.Attributes["class"] = "nav-item active";
                    break;
                case "kyc_new.aspx":
                    navKYC.Attributes["class"] = "nav-item active";
                    break;
            }
        }
    }
}
