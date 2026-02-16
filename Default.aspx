<%@ Page Title="Online Banking System"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Default.aspx.cs"
    Inherits="OnlineBankingTransactionSystem._Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Online Banking Transaction System</h2>
    <hr />

    <asp:Button 
        ID="btnTest" 
        runat="server" 
        Text="Test Database Connection" 
        OnClick="btnTest_Click" />

</asp:Content>
