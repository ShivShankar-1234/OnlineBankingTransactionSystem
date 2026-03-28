<%@ Page Title="Link Bank Account" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true"
    CodeBehind="LinkBankAccount.aspx.cs" Inherits="OnlineBankingTransactionSystem.LinkBankAccount" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <style>
            .link-bank-container {
                perspective: 1000px;
                max-width: 600px;
                margin: 2rem auto;
            }

            .bank-card {
                background: linear-gradient(135deg, #1e293b, #0f172a);
                border-radius: 20px;
                padding: 2rem;
                color: white;
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
                transform-style: preserve-3d;
                transition: transform 0.3s ease;
                border: 1px solid rgba(255, 255, 255, 0.1);
            }

            .bank-card:hover {
                transform: translateY(-5px) rotateX(2deg);
            }

            .card-header-icon {
                font-size: 2rem;
                margin-bottom: 1rem;
                color: #4ade80;
            }

            .form-group {
                margin-bottom: 1.5rem;
            }

            .form-label {
                display: block;
                margin-bottom: 0.5rem;
                font-size: 0.875rem;
                color: #94a3b8;
                font-weight: 500;
            }

            .form-control-dark {
                width: 100%;
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.1);
                padding: 0.75rem 1rem;
                border-radius: 10px;
                color: white;
                font-size: 1rem;
                transition: all 0.2s;
            }

            .form-control-dark:focus {
                background: rgba(255, 255, 255, 0.1);
                border-color: #4ade80;
                outline: none;
                box-shadow: 0 0 0 2px rgba(74, 222, 128, 0.2);
            }

            .btn-link-bank {
                width: 100%;
                background: linear-gradient(to right, #4ade80, #22c55e);
                color: #064e3b;
                border: none;
                padding: 1rem;
                border-radius: 10px;
                font-weight: 600;
                font-size: 1rem;
                cursor: pointer;
                transition: transform 0.2s, box-shadow 0.2s;
                margin-top: 1rem;
            }

            .btn-link-bank:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 15px -3px rgba(74, 222, 128, 0.3);
            }

            .chip-icon {
                width: 50px;
                height: 35px;
                background: linear-gradient(135deg, #fbbf24, #d97706);
                border-radius: 6px;
                margin-bottom: 1.5rem;
                position: relative;
                overflow: hidden;
            }

            .chip-icon::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 1px;
                background: rgba(0, 0, 0, 0.2);
            }

            /* OTP Modal Styles */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.8);
                display: none;
                justify-content: center;
                align-items: center;
                z-index: 1000;
            }

            .otp-modal {
                background: white;
                padding: 2rem;
                border-radius: 15px;
                text-align: center;
                max-width: 400px;
                width: 90%;
            }
        </style>
        <script>
            function showOTPModal() {
                var bank = document.getElementById('<%= txtBankName.ClientID %>').value;
                if (bank) {
                    document.getElementById('otpModal').style.display = 'flex';
                    document.getElementById('<%= pnlForm.ClientID %>').style.display = 'none';
                    return false; // Prevent postback initially
                }
                return true;
            }
        </script>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="PageTitle" runat="server">
        Link Bank Account
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <div class="link-bank-container">
            <asp:Panel ID="pnlForm" runat="server" CssClass="bank-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="chip-icon"></div>
                    <div class="text-right">
                        <span style="font-size: 0.8rem; opacity: 0.7;">SECURE LINKING</span>
                        <div style="font-size: 1.2rem; font-weight: bold;">BANK CARD</div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12 form-group">
                        <label class="form-label">Bank Name</label>
                        <asp:TextBox ID="txtBankName" runat="server" CssClass="form-control-dark"
                            placeholder="e.g. HDFC Bank"></asp:TextBox>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-8 form-group">
                        <label class="form-label">Account Number</label>
                        <asp:TextBox ID="txtAccountNumber" runat="server" CssClass="form-control-dark"
                            placeholder="XXXX XXXX XXXX 1234" MaxLength="18"></asp:TextBox>
                    </div>
                    <div class="col-md-4 form-group">
                        <label class="form-label">Type</label>
                        <asp:DropDownList ID="ddlAccountType" runat="server" CssClass="form-control-dark">
                            <asp:ListItem Value="Savings">Savings</asp:ListItem>
                            <asp:ListItem Value="Current">Current</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">IFSC Code</label>
                    <asp:TextBox ID="txtIFSC" runat="server" CssClass="form-control-dark" placeholder="e.g. HDFC0001234"
                        MaxLength="11"></asp:TextBox>
                </div>

                <asp:Button ID="btnLink" runat="server" Text="Verify & Link Account" CssClass="btn-link-bank"
                    OnClick="btnLink_Click" />

                <div class="mt-3 text-center">
                    <asp:Label ID="lblMessage" runat="server" ForeColor="#ef4444"></asp:Label>
                </div>
            </asp:Panel>
        </div>

        <!-- Simulated OTP Modal -->
        <asp:Panel ID="pnlOTP" runat="server" Visible="false">
            <div class="modal-overlay" style="display:flex;">
                <div class="otp-modal">
                    <h3>🔐 Verify OTP</h3>
                    <p>Enter the OTP sent to your registered mobile number.</p>
                    <input type="text" value="123456" class="form-control text-center mb-3"
                        style="letter-spacing: 5px; font-size: 1.2rem;" readonly />
                    <p class="text-muted small">Use 123456 for testing</p>
                    <asp:Button ID="btnVerifyOTP" runat="server" Text="Confirm" CssClass="btn btn-primary w-100"
                        OnClick="btnVerifyOTP_Click" />
                </div>
            </div>
        </asp:Panel>

    </asp:Content>