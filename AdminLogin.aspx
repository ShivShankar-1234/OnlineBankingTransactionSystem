<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="AdminLogin.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.AdminLogin" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Admin Login</title>

<style>
body{
    background:linear-gradient(120deg,#141e30,#243b55);
    font-family:Segoe UI;
}
.card{
    width:380px;
    margin:120px auto;
    background:white;
    padding:30px;
    border-radius:15px;
    box-shadow:0 20px 40px rgba(0,0,0,.4);
}
input,button{
    width:100%;
    padding:12px;
    margin:10px 0;
    border-radius:8px;
    border:1px solid #ccc;
}
button{
    background:#27ae60;
    color:white;
    border:none;
    font-size:16px;
    cursor:pointer;
}
</style>
</head>

<body>
<form runat="server">
<div class="card">
    <h2>👨‍💼 Admin Login</h2>

    <asp:TextBox ID="txtEmail" runat="server"
        placeholder="Admin Email"></asp:TextBox>

    <asp:TextBox ID="txtPassword" runat="server"
        TextMode="Password"
        placeholder="Password"></asp:TextBox>

    <asp:Button ID="btnLogin" runat="server"
        Text="Login"
        OnClick="btnLogin_Click" />
</div>
</form>
</body>
</html>
