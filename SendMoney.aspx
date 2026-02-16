<%@ Page Title="Send Money" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true"
    CodeBehind="SendMoney.aspx.cs" Inherits="OnlineBankingTransactionSystem.SendMoney" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Send Money - Online Banking
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
        <style>
            .page-container {
                max-width: 600px;
                margin: 0 auto;
            }

            .form-card {
                background-color: var(--card);
                border: 1px solid var(--border);
                border-radius: var(--radius-xl);
                padding: 40px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .form-header {
                text-align: center;
                margin-bottom: 32px;
            }

            .form-icon {
                width: 64px;
                height: 64px;
                background: linear-gradient(135deg, #4f46e5 0%, #3730a3 100%);
                border-radius: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 16px;
                color: white;
            }

            .form-title {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 8px;
                color: var(--foreground);
            }

            .form-subtitle {
                font-size: 14px;
                color: var(--muted-foreground);
            }

            .form-group {
                margin-bottom: 24px;
            }

            .form-label {
                display: block;
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 8px;
                color: var(--foreground);
            }

            .form-input,
            .form-select {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid var(--border);
                border-radius: var(--radius-md);
                font-size: 14px;
                font-family: 'Inter', sans-serif;
                transition: all 0.2s;
                background-color: var(--card);
            }

            .form-input:focus,
            .form-select:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            }

            .divider {
                text-align: center;
                margin: 20px 0;
                color: var(--muted-foreground);
                font-size: 13px;
                position: relative;
            }

            .divider::before,
            .divider::after {
                content: "";
                position: absolute;
                top: 50%;
                width: 40%;
                height: 1px;
                background-color: var(--border);
            }

            .divider::before {
                left: 0;
            }

            .divider::after {
                right: 0;
            }

            .btn-primary {
                width: 100%;
                padding: 14px 24px;
                background-color: var(--primary);
                color: var(--primary-foreground);
                border: none;
                border-radius: var(--radius-md);
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
            }

            .btn-primary:hover {
                background-color: #4338ca;
            }

            .back-btn {
                background-color: var(--secondary);
                color: var(--foreground);
                border: none;
                padding: 8px 16px;
                border-radius: var(--radius-md);
                font-size: 13px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .back-btn:hover {
                background-color: var(--muted);
            }

            @media (max-width: 768px) {
                .form-card {
                    padding: 24px;
                }
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageTitle" runat="server">
        Send Money
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="TopActions" runat="server">
        <a href="Dashboard.aspx" class="back-btn">
            <iconify-icon icon="lucide:arrow-left" style="font-size: 16px"></iconify-icon>
            Back to Dashboard
        </a>
    </asp:Content>

    <asp:Content ID="Content5" ContentPlaceHolderID="MainContent" runat="server">
        <div class="page-container">
            <div class="form-card">
                <div class="form-header">
                    <div class="form-icon">
                        <iconify-icon icon="lucide:send" style="font-size: 32px"></iconify-icon>
                    </div>
                    <div class="form-title">Send Money</div>
                    <div class="form-subtitle">Transfer money securely to any user</div>
                </div>

                <!-- Beneficiary Dropdown -->
                <div class="form-group">
                    <label class="form-label">Select from Saved Beneficiaries</label>
                    <asp:DropDownList ID="ddlBeneficiaries" runat="server" CssClass="form-select" AutoPostBack="true"
                        OnSelectedIndexChanged="ddlBeneficiaries_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>

                <!-- Divider -->
                <div class="divider">OR</div>

                <!-- Manual Entry -->
                <div class="form-group">
                    <label class="form-label">Enter Manually</label>
                    <asp:TextBox ID="txtReceiver" runat="server" CssClass="form-input"
                        placeholder="Email / Mobile / UPI ID"></asp:TextBox>
                </div>

                <!-- Amount -->
                <div class="form-group">
                    <label class="form-label">Amount</label>
                    <asp:TextBox ID="txtAmount" runat="server" CssClass="form-input" placeholder="Enter amount in ₹"
                        TextMode="Number"></asp:TextBox>
                </div>

                <!-- Submit Button -->
                <asp:Button ID="btnSend" runat="server" Text="Send Securely" CssClass="btn-primary"
                    OnClick="btnSend_Click" />
            </div>
        </div>
    </asp:Content>