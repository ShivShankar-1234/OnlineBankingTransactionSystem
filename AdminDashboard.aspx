<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="AdminDashboard.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.AdminDashboard" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Admin KYC Dashboard</title>

<style>
body{
    font-family:Segoe UI;
    background:linear-gradient(120deg,#141e30,#243b55);
    margin:0;
}
.card{
    width:90%;
    margin:40px auto;
    background:white;
    padding:20px;
    border-radius:15px;
    box-shadow:0 20px 40px rgba(0,0,0,.4);
}
table{
    width:100%;
    border-collapse:collapse;
}
th,td{
    padding:10px;
    border-bottom:1px solid #ddd;
    text-align:center;
}
th{
    background:#2c3e50;
    color:white;
}
.btn-approve{
    background:#27ae60;
    color:white;
    border:none;
    padding:6px 10px;
    border-radius:6px;
    cursor:pointer;
}
.btn-reject{
    background:#e74c3c;
    color:white;
    border:none;
    padding:6px 10px;
    border-radius:6px;
    cursor:pointer;
}
.logout{
    float:right;
    background:#e74c3c;
    color:white;
    border:none;
    padding:6px 12px;
    border-radius:6px;
}
</style>
</head>

<body>
<form runat="server">

<div class="card">
    <h2>🛂 Admin KYC Approval Panel</h2>

    <asp:Button ID="btnLogout" runat="server"
        Text="Logout"
        CssClass="logout"
        OnClick="btnLogout_Click" />

    <br /><br />

  <asp:GridView ID="gvKYC" runat="server" AutoGenerateColumns="False">
    <Columns>

        <asp:BoundField DataField="UserID" HeaderText="User ID" />
        <asp:BoundField DataField="FullName" HeaderText="Name" />
        <asp:BoundField DataField="Email" HeaderText="Email" />
        <asp:BoundField DataField="AadhaarNumber" HeaderText="Aadhaar" />
        <asp:BoundField DataField="PANNumber" HeaderText="PAN" />
        <asp:BoundField DataField="Status" HeaderText="Status" />

        <asp:TemplateField HeaderText="Action">
            <ItemTemplate>

               <asp:Button 
                   ID="btnApprove"
                   runat="server"
                   Text="Approve"
                   CommandArgument='<%# Eval("UserID") %>'
                   OnClick="Approve_Click"
                   UseSubmitBehavior="false" />


                <asp:Button ID="btnReject"
                    runat="server"
                    Text="Reject"
                    CssClass="btn btn-danger"
                    CommandArgument='<%# Eval("UserID") %>'
                    OnClick="Reject_Click" />

            </ItemTemplate>
        </asp:TemplateField>

    </Columns>
</asp:GridView>

</div>

</form>
</body>
</html>
