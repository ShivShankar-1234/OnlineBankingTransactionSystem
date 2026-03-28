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
                <div class="auth-card" style="max-width: 800px; width: 95%;">
                    <h2>Create Account</h2>
                    <p style="color: #666; margin-bottom: 30px;">Join us for better banking</p>

                    <div class="row">
                        <!-- Personal Details -->
                        <div class="col-md-6">
                            <h4 style="margin-bottom: 15px; color: #4f46e5;">Personal Details</h4>
                            <div class="form-group">
                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control-custom"
                                    placeholder="Full Name *"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control-custom" TextMode="Date"
                                    placeholder="Date of Birth *"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control-custom">
                                    <asp:ListItem Value="" Text="Select Gender *" />
                                    <asp:ListItem Value="Male" Text="Male" />
                                    <asp:ListItem Value="Female" Text="Female" />
                                    <asp:ListItem Value="Other" Text="Other" />
                                </asp:DropDownList>
                            </div>
                            <div class="form-group">
                                <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control-custom"
                                    placeholder="Mobile Number *" MaxLength="10"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control-custom"
                                    placeholder="Email Address *"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Identity & Address -->
                        <div class="col-md-6">
                            <h4 style="margin-bottom: 15px; color: #4f46e5;">Identity & Address</h4>
                            <div class="form-group">
                                <asp:TextBox ID="txtAadhaar" runat="server" CssClass="form-control-custom"
                                    placeholder="Aadhaar Number (12 digits) *" MaxLength="12"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:TextBox ID="txtPAN" runat="server" CssClass="form-control-custom"
                                    placeholder="PAN Number (10 chars) *" MaxLength="10"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control-custom"
                                    placeholder="Current Address *" TextMode="MultiLine" Rows="2"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:DropDownList ID="ddlBranch" runat="server" CssClass="form-control-custom">
                                    <asp:ListItem Value="" Text="-- Select Branch --"></asp:ListItem>
                                    <asp:ListItem Value="Main Branch" Text="Main Branch (Mumbai)"></asp:ListItem>
                                    <asp:ListItem Value="Delhi Branch" Text="Delhi Branch"></asp:ListItem>
                                    <asp:ListItem Value="Bangalore Branch" Text="Bangalore Branch"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="form-group">
                                <asp:TextBox ID="txtCity" runat="server" CssClass="form-control-custom"
                                    placeholder="City *"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <h4 style="margin-bottom: 15px; color: #4f46e5; margin-top: 10px;">Security</h4>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control-custom"
                                    TextMode="Password" placeholder="Password *"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control-custom"
                                    TextMode="Password" placeholder="Confirm Password *"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn-custom" Width="100%"
                        OnClick="BtnRegister_Click" />

                    <div style="margin-top: 20px;">
                        <span style="color: #666;">Already have an account?</span>
                        <a href="Login.aspx" style="color: var(--primary-color); font-weight: 600;">Login</a>
                    </div>
                </div>
            </div>
        </form>
    </body>

    </html>