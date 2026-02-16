<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="OnlineBankingTransactionSystem.Login"
    %>

    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>User Login</title>

        <link href="Content/Site.css" rel="stylesheet" />
    </head>

    <body>
        <form runat="server">
            <div class="auth-wrapper">
                <div class="auth-card">
                    <h2>Welcome Back</h2>
                    <p style="color: #666; margin-bottom: 30px;">Please login to your account</p>

                    <div class="form-group">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control-custom"
                            placeholder="Email Address"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control-custom" TextMode="Password"
                            placeholder="Password"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-custom" Width="100%"
                        OnClick="btnLogin_Click" />

                    <div style="margin-top: 20px;">
                        <span style="color: #666;">New here?</span>
                        <a href="Register.aspx" style="color: var(--primary-color); font-weight: 600;">Create
                            Account</a>
                    </div>
                </div>
            </div>
        </form>
    </body>

    </html>