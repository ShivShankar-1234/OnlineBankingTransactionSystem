<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="AdminKYC.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.AdminKYC" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Admin KYC Approval</title>

<style>
body{
    font-family:Segoe UI;
    background:#f2f4f8;
}
.card{
    width:90%;
    margin:40px auto;
    background:white;
    padding:25px;
    border-radius:12px;
    box-shadow:0 15px 30px rgba(0,0,0,.2);
}
table{
    width:100%;
    border-collapse:collapse;
}
th,td{
    padding:12px;
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
    padding:6px 10px;
    border:none;
    cursor:pointer;
    border-radius:6px;
}
.btn-reject{
    background:#e74c3c;
    color:white;
    padding:6px 10px;
    border:none;
    cursor:pointer;
    border-radius:6px;
}
</style>
</head>

<body>
<form runat="server">
<div class="card">
    <h2>🛂 Pending KYC Requests</h2>

    <asp:GridView ID="gvKYC" runat="server"
        AutoGenerateColumns="False"
        OnRowCommand="gvKYC_RowCommand">

        <Columns>
            <asp:BoundField DataField="UserID" HeaderText="User ID" />
            <asp:BoundField DataField="AadhaarNumber" HeaderText="Aadhaar" />
            <asp:BoundField DataField="PANNumber" HeaderText="PAN" />
            <asp:BoundField DataField="KYCStatus" HeaderText="Status" />

            <asp:TemplateField HeaderText="Action">
                <ItemTemplate>
                    <asp:Button ID="btnApprove" runat="server"
                        Text="Approve"
                        CssClass="btn-approve"
                        CommandName="APPROVE"
                        CommandArgument='<%# Eval("UserID") %>' />

                    <asp:Button ID="btnReject" runat="server"
                        Text="Reject"
                        CssClass="btn-reject"
                        CommandName="REJECT"
                        CommandArgument='<%# Eval("UserID") %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>

    </asp:GridView>
</div>
</form>
</body>
</html>
