<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddMoney.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.AddMoney" %>

    <!DOCTYPE html>
    <html>

    <head runat="server">
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Add Money - Online Banking</title>

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

            /* Quick Amounts */
            .quick-amounts {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 12px;
                margin-bottom: 24px;
            }

            .amount-btn {
                padding: 12px;
                border: 1px solid var(--border);
                background-color: var(--card);
                border-radius: var(--radius-md);
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
                color: var(--foreground);
            }

            .amount-btn:hover {
                border-color: var(--primary);
                background-color: rgba(79, 70, 229, 0.05);
            }

            /* Primary Button */
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

                .quick-amounts {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
        </style>

        <script>
            function setAmount(amt) {
                document.getElementById('<%= txtAmount.ClientID %>').value = amt;
            }
        </script>
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
                        <a href="AddMoney.aspx" class="nav-item active">
                            <iconify-icon icon="lucide:plus-circle" style="font-size: 20px"></iconify-icon>
                            Add Money
                        </a>
                        <a href="TransactionHistory.aspx" class="nav-item">
                            <iconify-icon icon="lucide:history" style="font-size: 20px"></iconify-icon>
                            Transactions
                        </a>
                    </nav>
                </aside>

                <!-- Main Content -->
                <main class="main-content">
                    <!-- Header -->
                    <header class="top-bar">
                        <div class="page-title">Add Money</div>
                        <div class="top-actions">
                            <a href="Dashboard.aspx" class="back-btn">
                                <iconify-icon icon="lucide:arrow-left" style="font-size: 16px"></iconify-icon>
                                Back to Dashboard
                            </a>
                        </div>
                    </header>

                    <!-- Body -->
                    <div class="page-scroll">
                        <div class="page-container">
                            <div class="form-card">
                                <div class="form-header">
                                    <div class="form-icon">
                                        <iconify-icon icon="lucide:wallet" style="font-size: 32px"></iconify-icon>
                                    </div>
                                    <div class="form-title">Add Money</div>
                                    <div class="form-subtitle">Top up your wallet instantly</div>
                                </div>

                                <!-- Quick Amount Selection -->
                                <div class="quick-amounts">
                                    <button type="button" class="amount-btn" onclick="setAmount(500)">₹500</button>
                                    <button type="button" class="amount-btn" onclick="setAmount(1000)">₹1,000</button>
                                    <button type="button" class="amount-btn" onclick="setAmount(2000)">₹2,000</button>
                                    <button type="button" class="amount-btn" onclick="setAmount(5000)">₹5,000</button>
                                </div>

                                <!-- Amount Input -->
                                <div class="form-group">
                                    <label class="form-label">Enter Amount</label>
                                    <asp:TextBox ID="txtAmount" runat="server" CssClass="form-input"
                                        placeholder="Enter amount in ₹" TextMode="Number"></asp:TextBox>
                                </div>

                                <!-- Submit Button -->
                                <asp:Button ID="btnAdd" runat="server" Text="Add Money" CssClass="btn-primary"
                                    OnClick="btnAdd_Click" />
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </form>
    </body>

    </html>