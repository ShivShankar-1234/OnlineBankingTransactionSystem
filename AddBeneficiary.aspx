<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddBeneficiary.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.AddBeneficiary" %>

    <!DOCTYPE html>
    <html>

    <head runat="server">
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Add Beneficiary - Online Banking</title>

        <!-- Google Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link
            href="https://fonts.googleapis.com/css2?family=Inter:wght@100;200;300;400;500;600;700;800;900&display=swap"
            rel="stylesheet" />

        <!-- Iconify Icons -->
        <script src="https://code.iconify.design/iconify-icon/3.0.0/iconify-icon.min.js"></script>

        <style>
            :root {
                --background: #f8f9fa;
                --foreground: #0f172a;
                --card: #ffffff;
                --card-foreground: #0f172a;
                --primary: #4f46e5;
                --primary-foreground: #ffffff;
                --secondary: #f1f5f9;
                --secondary-foreground: #1e293b;
                --muted: #f1f5f9;
                --muted-foreground: #64748b;
                --success: #10b981;
                --success-foreground: #ffffff;
                --destructive: #ef4444;
                --destructive-foreground: #ffffff;
                --border: #e2e8f0;
                --radius-sm: 4px;
                --radius-md: 8px;
                --radius-lg: 12px;
                --radius-xl: 16px;
            }

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
                background-color: var(--background);
                color: var(--foreground);
                height: 100vh;
                overflow: hidden;
            }

            .dashboard-wrapper {
                display: flex;
                height: 100vh;
                overflow: hidden;
            }

            /* Sidebar Styles */
            .sidebar {
                width: 260px;
                background-color: var(--card);
                border-right: 1px solid var(--border);
                display: flex;
                flex-direction: column;
                height: 100%;
                flex-shrink: 0;
            }

            .sidebar-header {
                height: 70px;
                display: flex;
                align-items: center;
                padding: 0 24px;
            }

            .brand {
                font-size: 20px;
                font-weight: 700;
                color: var(--primary);
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .brand-icon {
                width: 32px;
                height: 32px;
                background: var(--primary);
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
            }

            .nav-menu {
                flex: 1;
                padding: 24px 16px;
                display: flex;
                flex-direction: column;
                gap: 4px;
                overflow-y: auto;
            }

            .nav-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 16px;
                border-radius: var(--radius-md);
                color: var(--muted-foreground);
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                cursor: pointer;
                transition: all 0.2s;
            }

            .nav-item:hover {
                background-color: var(--secondary);
            }

            .nav-item.active {
                background-color: var(--primary);
                color: var(--primary-foreground);
            }

            /* Main Content */
            .main-content {
                flex: 1;
                display: flex;
                flex-direction: column;
                height: 100%;
                overflow: hidden;
            }

            .top-bar {
                height: 70px;
                background-color: var(--card);
                border-bottom: 1px solid var(--border);
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 32px;
                flex-shrink: 0;
            }

            .page-title {
                font-size: 18px;
                font-weight: 600;
                color: var(--foreground);
            }

            .top-actions {
                display: flex;
                align-items: center;
                gap: 16px;
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

            /* Scrollable Area */
            .page-scroll {
                flex: 1;
                overflow-y: auto;
                padding: 32px;
            }

            .page-container {
                max-width: 600px;
                margin: 0 auto;
            }

            /* Form Card */
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

            /* Form Elements */
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

            .form-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid var(--border);
                border-radius: var(--radius-md);
                font-size: 14px;
                font-family: 'Inter', sans-serif;
                transition: all 0.2s;
            }

            .form-input:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            }

            .form-hint {
                font-size: 12px;
                color: var(--muted-foreground);
                margin-top: 6px;
            }

            /* Buttons */
            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: var(--radius-md);
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
            }

            .btn-primary {
                background-color: var(--primary);
                color: var(--primary-foreground);
            }

            .btn-primary:hover {
                background-color: #4338ca;
            }

            .btn-success {
                background-color: var(--success);
                color: var(--success-foreground);
            }

            .btn-success:hover {
                background-color: #059669;
            }

            .btn-secondary {
                background-color: var(--secondary);
                color: var(--secondary-foreground);
            }

            .btn-secondary:hover {
                background-color: var(--muted);
            }

            .button-group {
                display: flex;
                gap: 12px;
                margin-top: 32px;
            }

            .button-group .btn {
                flex: 1;
            }

            /* Alerts */
            .alert {
                padding: 16px;
                border-radius: var(--radius-md);
                margin-top: 16px;
                display: none;
            }

            .alert.show {
                display: block;
            }

            .alert-success {
                background-color: #ecfdf5;
                border: 1px solid var(--success);
                color: #047857;
            }

            .alert-error {
                background-color: #fee2e2;
                border: 1px solid var(--destructive);
                color: #991b1b;
            }

            .alert-title {
                font-weight: 600;
                margin-bottom: 4px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .sidebar {
                    position: fixed;
                    left: -260px;
                    z-index: 1000;
                    transition: left 0.3s;
                }

                .sidebar.active {
                    left: 0;
                }

                .form-card {
                    padding: 24px;
                }

                .button-group {
                    flex-direction: column;
                }
            }
        </style>
    </head>

    <body>
        <form runat="server">
            <div class="dashboard-wrapper">
                <!-- Sidebar -->
                <aside class="sidebar">
                    <div class="sidebar-header">
                        <div class="brand">
                            <div class="brand-icon">
                                <iconify-icon icon="lucide:landmark" style="font-size: 20px"></iconify-icon>
                            </div>
                            NeoBank
                        </div>
                    </div>

                    <nav class="nav-menu">
                        <a href="Dashboard.aspx" class="nav-item">
                            <iconify-icon icon="lucide:layout-dashboard" style="font-size: 20px"></iconify-icon>
                            Dashboard
                        </a>
                        <a href="BillPayment.aspx" class="nav-item">
                            <iconify-icon icon="lucide:file-text" style="font-size: 20px"></iconify-icon>
                            Bill Payments
                        </a>
                        <a href="BillPayment.aspx" class="nav-item">
                            <iconify-icon icon="lucide:smartphone" style="font-size: 20px"></iconify-icon>
                            Mobile / DTH
                        </a>
                        <a href="SendMoney.aspx" class="nav-item">
                            <iconify-icon icon="lucide:send" style="font-size: 20px"></iconify-icon>
                            Send Money
                        </a>
                        <a href="AddMoney.aspx" class="nav-item">
                            <iconify-icon icon="lucide:plus-circle" style="font-size: 20px"></iconify-icon>
                            Add Money
                        </a>
                        <a href="TransactionHistory.aspx" class="nav-item">
                            <iconify-icon icon="lucide:history" style="font-size: 20px"></iconify-icon>
                            Transactions
                        </a>
                        <a href="ManageBeneficiaries.aspx" class="nav-item active">
                            <iconify-icon icon="lucide:users" style="font-size: 20px"></iconify-icon>
                            Beneficiaries
                        </a>
                    </nav>
                </aside>

                <!-- Main Content -->
                <main class="main-content">
                    <!-- Header -->
                    <header class="top-bar">
                        <div class="page-title">Add Beneficiary</div>
                        <div class="top-actions">
                            <a href="ManageBeneficiaries.aspx" class="back-btn">
                                <iconify-icon icon="lucide:arrow-left" style="font-size: 16px"></iconify-icon>
                                Back to Beneficiaries
                            </a>
                        </div>
                    </header>

                    <!-- Body -->
                    <div class="page-scroll">
                        <div class="page-container">
                            <div class="form-card">
                                <div class="form-header">
                                    <div class="form-icon">
                                        <iconify-icon icon="lucide:user-plus" style="font-size: 32px"></iconify-icon>
                                    </div>
                                    <div class="form-title">Add New Beneficiary</div>
                                    <div class="form-subtitle">Add a recipient to your saved beneficiaries for quick
                                        transfers</div>
                                </div>

                                <!-- Recipient Input -->
                                <div class="form-group">
                                    <label class="form-label">Recipient Email / Mobile / UPI ID</label>
                                    <asp:TextBox ID="txtRecipient" runat="server" CssClass="form-input"
                                        placeholder="Enter email, mobile, or UPI ID"></asp:TextBox>
                                    <div class="form-hint">Enter the recipient's registered email, mobile number, or UPI
                                        ID</div>
                                </div>

                                <!-- Verify Button -->
                                <asp:Button ID="btnVerify" runat="server" Text="Verify Recipient"
                                    CssClass="btn btn-success" OnClick="btnVerify_Click" />

                                <!-- Success Panel -->
                                <asp:Panel ID="pnlRecipientInfo" runat="server" CssClass="alert alert-success">
                                    <div class="alert-title">✅ Recipient Found</div>
                                    <asp:Label ID="lblRecipientName" runat="server"></asp:Label>
                                </asp:Panel>

                                <!-- Error Panel -->
                                <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-error">
                                    <asp:Label ID="lblError" runat="server"></asp:Label>
                                </asp:Panel>

                                <!-- Nickname Input -->
                                <div class="form-group" style="margin-top: 24px;">
                                    <label class="form-label">Nickname (Optional)</label>
                                    <asp:TextBox ID="txtNickname" runat="server" CssClass="form-input"
                                        placeholder="e.g., Mom, John, Office Account"></asp:TextBox>
                                    <div class="form-hint">Give this beneficiary a friendly name for easy identification
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="button-group">
                                    <asp:Button ID="btnSave" runat="server" Text="Save Beneficiary"
                                        CssClass="btn btn-primary" OnClick="btnSave_Click" />
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary"
                                        OnClick="btnCancel_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </form>
    </body>

    </html>