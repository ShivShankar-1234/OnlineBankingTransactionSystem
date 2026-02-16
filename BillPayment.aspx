<%@ Page Title="Bill Payment" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true"
    CodeBehind="BillPayment.aspx.cs" Inherits="OnlineBankingTransactionSystem.BillPayment" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Bill Payment - Online Banking
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
        Bill Payment & Recharge
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
                        <iconify-icon icon="lucide:receipt" style="font-size: 32px"></iconify-icon>
                    </div>
                    <div class="form-title">Pay Bills & Recharge</div>
                    <div class="form-subtitle">Pay utility bills and recharge mobile/DTH services</div>
                </div>

                <!-- Service Type Selection -->
                <div class="form-group">
                    <label class="form-label">Select Service</label>
                    <asp:DropDownList ID="ddlBillType" runat="server" CssClass="form-select">
                        <asp:ListItem Text="-- Select Bill Type --" Value="" />
                        <asp:ListItem Text="💧 Water Bill" Value="WATER" />
                        <asp:ListItem Text="⚡ Electricity Bill" Value="ELECTRICITY" />
                        <asp:ListItem Text="🔥 Gas Bill" Value="GAS" />
                        <asp:ListItem Text="📱 Mobile Recharge" Value="MOBILE" />
                        <asp:ListItem Text="📺 DTH Recharge" Value="DTH" />
                    </asp:DropDownList>
                </div>

                <!-- Consumer Number -->
                <div class="form-group">
                    <label class="form-label">Consumer / Account / Mobile Number</label>
                    <asp:TextBox ID="txtConsumer" runat="server" CssClass="form-input"
                        placeholder="Enter consumer number or mobile"></asp:TextBox>
                </div>

                <!-- Amount -->
                <div class="form-group">
                    <label class="form-label">Amount</label>
                    <asp:TextBox ID="txtAmount" runat="server" CssClass="form-input" placeholder="Enter amount in ₹"
                        TextMode="Number"></asp:TextBox>
                </div>

                <!-- Submit Button -->
                <asp:Button ID="btnPay" runat="server" Text="Pay Bill" CssClass="btn-primary" OnClick="btnPay_Click" />
            </div>
        </div>
    </asp:Content>