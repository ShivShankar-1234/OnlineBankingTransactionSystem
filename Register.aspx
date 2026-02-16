<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.Register" %>

    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>User Registration</title>

        <link href="Content/Site.css" rel="stylesheet" />
    </head>

    <body>
        <form runat="server">
            <div class="auth-wrapper">
                <div class="auth-card">
                    <h2>Create Account</h2>
                    <p style="color: #666; margin-bottom: 30px;">Join us for better banking</p>

                    <div class="form-group">
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control-custom" placeholder="Full Name">
                        </asp:TextBox>
                    </div>

                    <div class="form-group">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control-custom"
                            placeholder="Email Address"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control-custom"
                            placeholder="Mobile Number"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control-custom" TextMode="Password"
                            placeholder="Password"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn-custom" Width="100%"
                        OnClick="btnRegister_Click" />

                    <div style="margin-top: 20px;">
                        <span style="color: #666;">Already have an account?</span>
                        <a href="Login.aspx" style="color: var(--primary-color); font-weight: 600;">Login</a>
                    </div>
                </div>
            </div>
        </form>
    </body>

    </html>