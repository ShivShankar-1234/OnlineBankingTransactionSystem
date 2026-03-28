<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.Dashboard" %>

    <!DOCTYPE html>
    <html>

    <head runat="server">
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Dashboard - Online Banking</title>

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
                border-bottom: 1px solid transparent;
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

            .icon-btn {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                background-color: var(--secondary);
                color: var(--foreground);
                position: relative;
                cursor: pointer;
                border: none;
                transition: all 0.2s;
            }

            .icon-btn:hover {
                background-color: var(--muted);
            }

            .badge {
                position: absolute;
                top: -2px;
                right: -2px;
                background-color: var(--destructive);
                color: white;
                font-size: 10px;
                font-weight: 700;
                height: 16px;
                min-width: 16px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 0 4px;
                border: 2px solid var(--card);
            }

            .logout-btn {
                background-color: var(--destructive);
                color: var(--destructive-foreground);
                border: none;
                padding: 8px 16px;
                border-radius: var(--radius-md);
                font-size: 13px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
            }

            .logout-btn:hover {
                opacity: 0.9;
            }

            /* Notification Box */
            .notify-box {
                display: none;
                position: absolute;
                right: 0;
                top: 50px;
                width: 320px;
                background: var(--card);
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
                border-radius: var(--radius-lg);
                padding: 16px;
                z-index: 9999;
                border: 1px solid var(--border);
            }

            .notify-box h6 {
                font-size: 14px;
                font-weight: 600;
                margin-bottom: 12px;
                padding-bottom: 12px;
                border-bottom: 1px solid var(--border);
            }

            .notify-item {
                padding: 12px 0;
                border-bottom: 1px solid var(--border);
            }

            .notify-item:last-child {
                border-bottom: none;
            }

            /* Scrollable Area */
            .dashboard-scroll {
                flex: 1;
                overflow-y: auto;
                padding: 32px;
            }

            .dashboard-container {
                max-width: 1200px;
                margin: 0 auto;
            }

            /* Balance Card */
            .balance-section {
                margin-bottom: 40px;
            }

            .balance-card {
                background: linear-gradient(135deg, #4f46e5 0%, #3730a3 100%);
                border-radius: var(--radius-xl);
                padding: 40px;
                color: white;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                position: relative;
                overflow: hidden;
                box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.3);
            }

            .balance-card::before {
                content: "";
                position: absolute;
                top: -50px;
                right: -50px;
                width: 200px;
                height: 200px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 50%;
            }

            .balance-card::after {
                content: "";
                position: absolute;
                bottom: -30px;
                left: -30px;
                width: 150px;
                height: 150px;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 50%;
            }

            .balance-label {
                font-size: 16px;
                font-weight: 500;
                opacity: 0.9;
                margin-bottom: 12px;
                z-index: 1;
            }

            .balance-amount {
                font-size: 48px;
                font-weight: 700;
                margin-bottom: 24px;
                letter-spacing: -0.02em;
                z-index: 1;
            }

            .kyc-badge {
                background-color: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                padding: 6px 16px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 6px;
                z-index: 1;
            }

            /* Section Headers */
            .section-header {
                margin-bottom: 20px;
            }

            .section-title {
                font-size: 18px;
                font-weight: 600;
                color: var(--foreground);
            }

            /* Quick Actions Grid */
            .actions-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 40px;
            }

            .action-card {
                background-color: var(--card);
                border: 1px solid var(--border);
                border-radius: var(--radius-lg);
                padding: 24px;
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                cursor: pointer;
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .action-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            }

            .action-icon-wrapper {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 16px;
            }

            .action-title {
                font-size: 15px;
                font-weight: 600;
                margin-bottom: 6px;
                color: var(--foreground);
            }

            .action-desc {
                font-size: 12px;
                color: var(--muted-foreground);
                line-height: 1.4;
            }

            /* Recent Activity */
            .activity-section {
                background-color: var(--card);
                border: 1px solid var(--border);
                border-radius: var(--radius-lg);
                overflow: hidden;
            }

            .activity-header {
                padding: 20px 24px;
                border-bottom: 1px solid var(--border);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .view-all {
                font-size: 13px;
                font-weight: 500;
                color: var(--primary);
                text-decoration: none;
            }

            .view-all:hover {
                text-decoration: underline;
            }

            .transaction-list {
                display: flex;
                flex-direction: column;
            }

            .transaction-item {
                display: flex;
                align-items: center;
                padding: 16px 24px;
                border-bottom: 1px solid var(--border);
            }

            .transaction-item:last-child {
                border-bottom: none;
            }

            .t-icon {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: var(--secondary);
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 16px;
                color: var(--foreground);
            }

            .t-details {
                flex: 1;
            }

            .t-title {
                font-size: 14px;
                font-weight: 600;
                color: var(--foreground);
                margin-bottom: 4px;
            }

            .t-meta {
                font-size: 12px;
                color: var(--muted-foreground);
            }

            .t-amount {
                font-weight: 600;
                font-size: 14px;
            }

            .t-amount.debit {
                color: var(--foreground);
            }

            .t-amount.credit {
                color: #10b981;
            }

            .empty-state {
                padding: 40px 20px;
                text-align: center;
                color: var(--muted-foreground);
            }

            /* ── Hero Balance Card ─────────────────────────────────── */
            .hero-card {
                background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 60%, #0ea5e9 100%);
                border-radius: 20px;
                padding: 36px 40px;
                color: white;
                position: relative;
                overflow: hidden;
                box-shadow: 0 20px 60px rgba(79, 70, 229, .35);
                margin-bottom: 36px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 24px;
            }

            .hero-card::before {
                content: '';
                position: absolute;
                top: -60px;
                right: -60px;
                width: 260px;
                height: 260px;
                background: rgba(255, 255, 255, .08);
                border-radius: 50%;
                pointer-events: none;
            }

            .hero-card::after {
                content: '';
                position: absolute;
                bottom: -80px;
                left: 30px;
                width: 200px;
                height: 200px;
                background: rgba(255, 255, 255, .05);
                border-radius: 50%;
                pointer-events: none;
            }

            .hero-left {
                flex: 1;
                z-index: 1;
            }

            .hero-greeting {
                font-size: 13px;
                font-weight: 500;
                opacity: .75;
                letter-spacing: .04em;
                text-transform: uppercase;
                margin-bottom: 4px;
            }

            .hero-balance-label {
                font-size: 14px;
                font-weight: 500;
                opacity: .85;
                margin-bottom: 6px;
            }

            .hero-balance {
                font-size: 52px;
                font-weight: 800;
                line-height: 1;
                letter-spacing: -2px;
                margin-bottom: 20px;
            }

            .hero-chips {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .hero-chip {
                background: rgba(255, 255, 255, .15);
                backdrop-filter: blur(8px);
                -webkit-backdrop-filter: blur(8px);
                border: 1px solid rgba(255, 255, 255, .2);
                border-radius: 100px;
                padding: 5px 14px;
                font-size: 12px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 6px;
                letter-spacing: .01em;
            }

            .hero-right {
                z-index: 1;
                text-align: right;
            }

            .hero-kyc-badge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 8px 18px;
                border-radius: 100px;
                font-size: 13px;
                font-weight: 700;
                letter-spacing: .02em;
            }

            .hero-kyc-badge.verified {
                background: rgba(16, 185, 129, .25);
                border: 1.5px solid rgba(16, 185, 129, .5);
                color: #6ee7b7;
            }

            .hero-kyc-badge.pending {
                background: rgba(245, 158, 11, .2);
                border: 1.5px solid rgba(245, 158, 11, .45);
                color: #fcd34d;
            }

            .hero-card-icon {
                width: 80px;
                height: 80px;
                border-radius: 20px;
                background: rgba(255, 255, 255, .12);
                border: 1.5px solid rgba(255, 255, 255, .2);
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 12px;
                margin-left: auto;
            }

            /* top-bar user greeting */
            .user-greeting {
                display: flex;
                flex-direction: column;
            }

            .user-greeting .hello {
                font-size: 12px;
                color: var(--muted-foreground);
            }

            .user-greeting .uname {
                font-size: 16px;
                font-weight: 700;
                color: var(--foreground);
            }

            .avatar {
                width: 38px;
                height: 38px;
                border-radius: 50%;
                background: linear-gradient(135deg, #4f46e5, #7c3aed);
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                font-weight: 700;
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

                .hero-balance {
                    font-size: 36px;
                }

                .hero-card {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .actions-grid {
                    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                }
            }
        </style>

        <script>
            function toggleNotify() {
                let box = document.getElementById("notifyBox");
                if (box.offsetParent === null) {
                    box.style.display = 'block';
                } else {
                    box.style.display = 'none';
                }
            }

            // KYC RESTRICTION LOGIC
            function checkKYC(action) {
                var kycElement = document.getElementById('<%= lblKYC.ClientID %>');
                if (!kycElement) return true;

                var kyc = kycElement.innerText.trim();
                if (!kyc.includes("VERIFIED")) {
                    alert("⚠ Please complete KYC before using this service.");
                    return false;
                }
                window.location.href = action;
                return false;
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
                        <a href="Dashboard.aspx" class="nav-item active">
                            <iconify-icon icon="lucide:layout-dashboard" style="font-size: 20px"></iconify-icon>
                            Dashboard
                        </a>
                        <a href="#" onclick="return checkKYC('BillPayment.aspx')" class="nav-item">
                            <iconify-icon icon="lucide:file-text" style="font-size: 20px"></iconify-icon>
                            Bill Payments
                        </a>
                        <a href="#" onclick="return checkKYC('BillPayment.aspx')" class="nav-item">
                            <iconify-icon icon="lucide:smartphone" style="font-size: 20px"></iconify-icon>
                            Mobile / DTH
                        </a>
                        <a href="#" onclick="return checkKYC('SendMoney.aspx')" class="nav-item">
                            <iconify-icon icon="lucide:send" style="font-size: 20px"></iconify-icon>
                            Send Money
                        </a>
                        <a href="#" onclick="return checkKYC('AddMoney.aspx')" class="nav-item">
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
                        <div class="user-greeting">
                            <span class="hello">Welcome back 👋</span>
                            <span class="uname">My Dashboard</span>
                        </div>
                        <div class="top-actions">
                            <!-- Notification Bell -->
                            <div class="icon-btn" onclick="toggleNotify()" style="position: relative;">
                                <iconify-icon icon="lucide:bell" style="font-size: 20px"></iconify-icon>
                                <asp:Label ID="lblNotifyCount" runat="server" CssClass="badge"></asp:Label>
                                <!-- Notifications Dropdown -->
                                <div id="notifyBox" class="notify-box">
                                    <h6>Notifications</h6>
                                    <asp:Repeater ID="rptNotify" runat="server">
                                        <ItemTemplate>
                                            <div class="notify-item">
                                                <div style="font-size: 13px; margin-bottom: 4px;">
                                                    <%# Eval("Message") %>
                                                </div>
                                                <small style="color: var(--muted-foreground); font-size: 11px;">
                                                    <%# Eval("CreatedAt") %>
                                                </small>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <div class="empty-state" style="padding: 20px;" runat="server"
                                        visible='<%# rptNotify.Items.Count == 0 %>'>
                                        <small>No new notifications</small>
                                    </div>
                                </div>
                            </div>
                            <!-- Avatar -->
                            <div class="avatar">U</div>
                            <!-- Logout -->
                            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="logout-btn"
                                OnClick="BtnLogout_Click" />
                        </div>
                    </header>

                    <!-- Body -->
                    <div class="dashboard-scroll">
                        <div class="dashboard-container">
                            <!-- ── Hero Balance Card ── -->
                            <div class="hero-card">
                                <div class="hero-left">
                                    <div class="hero-greeting">Wallet Balance</div>
                                    <div class="hero-balance">
                                        <asp:Label ID="lblBalance" runat="server" Text="₹ 0.00"></asp:Label>
                                    </div>
                                    <div class="hero-chips">
                                        <div class="hero-chip">
                                            <iconify-icon icon="lucide:credit-card"
                                                style="font-size:13px"></iconify-icon>
                                            <asp:Label ID="lblAccountNumber" runat="server" Text="XXXXXXXXXX">
                                            </asp:Label>
                                        </div>
                                        <div class="hero-chip">
                                            <iconify-icon icon="lucide:building-2"
                                                style="font-size:13px"></iconify-icon>
                                            IFSC:&nbsp;<asp:Label ID="lblIFSC" runat="server" Text="OBTS0000001">
                                            </asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="hero-right">
                                    <div class="hero-card-icon">
                                        <iconify-icon icon="lucide:landmark"
                                            style="font-size:36px; color:white"></iconify-icon>
                                    </div>
                                    <asp:Label ID="lblKYC" runat="server" Text="Pending" Font-Bold="true"
                                        CssClass="hero-kyc-badge pending"></asp:Label>
                                </div>
                            </div>

                            <!-- Quick Actions -->
                            <section class="quick-actions">
                                <div class="section-header">
                                    <div class="section-title">Quick Actions</div>
                                </div>

                                <div class="actions-grid">
                                    <!-- KYC Verification -->
                                    <div class="action-card" onclick="location.href='KYC_New.aspx'">
                                        <div class="action-icon-wrapper"
                                            style="background-color: #e0e7ff; color: #4f46e5">
                                            <iconify-icon icon="lucide:shield-check"
                                                style="font-size: 24px"></iconify-icon>
                                        </div>
                                        <div class="action-title">KYC Verification</div>
                                        <div class="action-desc">Complete or update KYC</div>
                                    </div>

                                    <!-- Beneficiaries -->
                                    <div class="action-card" onclick="location.href='ManageBeneficiaries.aspx'">
                                        <div class="action-icon-wrapper"
                                            style="background-color: #fae8ff; color: #a855f7">
                                            <iconify-icon icon="lucide:users" style="font-size: 24px"></iconify-icon>
                                        </div>
                                        <div class="action-title">Beneficiaries</div>
                                        <div class="action-desc">Manage saved recipients</div>
                                    </div>

                                    <!-- Pay Bills -->
                                    <div class="action-card" onclick="return checkKYC('BillPayment.aspx')">
                                        <div class="action-icon-wrapper"
                                            style="background-color: #fef3c7; color: #d97706">
                                            <iconify-icon icon="lucide:lightbulb"
                                                style="font-size: 24px"></iconify-icon>
                                        </div>
                                        <div class="action-title">Pay Bills</div>
                                        <div class="action-desc">Electricity, Water, Gas</div>
                                    </div>

                                    <!-- Recharge -->
                                    <div class="action-card" onclick="return checkKYC('BillPayment.aspx')">
                                        <div class="action-icon-wrapper"
                                            style="background-color: #fee2e2; color: #ef4444">
                                            <iconify-icon icon="lucide:zap" style="font-size: 24px"></iconify-icon>
                                        </div>
                                        <div class="action-title">Recharge</div>
                                        <div class="action-desc">Mobile &amp; DTH services</div>
                                    </div>

                                    <!-- Send Money -->
                                    <div class="action-card" onclick="return checkKYC('SendMoney.aspx')">
                                        <div class="action-icon-wrapper"
                                            style="background-color: #dcfce7; color: #10b981">
                                            <iconify-icon icon="lucide:send" style="font-size: 24px"></iconify-icon>
                                        </div>
                                        <div class="action-title">Send Money</div>
                                        <div class="action-desc">Transfer to Bank/User</div>
                                    </div>

                                    <!-- Add Money -->
                                    <div class="action-card" onclick="return checkKYC('AddMoney.aspx')">
                                        <div class="action-icon-wrapper"
                                            style="background-color: #e0f2fe; color: #0ea5e9">
                                            <iconify-icon icon="lucide:wallet" style="font-size: 24px"></iconify-icon>
                                        </div>
                                        <div class="action-title">Add Money</div>
                                        <div class="action-desc">Top-up your wallet</div>
                                    </div>

                                    <!-- History -->
                                    <div class="action-card" onclick="location.href='TransactionHistory.aspx'">
                                        <div class="action-icon-wrapper"
                                            style="background-color: #ffedd5; color: #f97316">
                                            <iconify-icon icon="lucide:scroll-text"
                                                style="font-size: 24px"></iconify-icon>
                                        </div>
                                        <div class="action-title">History</div>
                                        <div class="action-desc">View past transactions</div>
                                    </div>
                                </div>
                            </section>

                            <!-- Recent Activity -->
                            <section class="activity-section">
                                <div class="activity-header">
                                    <div class="section-title">Recent Activity</div>
                                    <a href="TransactionHistory.aspx" class="view-all">View Full History</a>
                                </div>
                                <div class="transaction-list">
                                    <asp:GridView ID="gvMiniStatement" runat="server" AutoGenerateColumns="False"
                                        GridLines="None" ShowHeader="false" CssClass="transaction-list">
                                        <Columns>
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <div class="transaction-item">
                                                        <div class="t-icon">
                                                            <iconify-icon
                                                                icon='<%# Convert.ToInt32(Eval("SenderID")) == Convert.ToInt32(Session["UserID"]) ? "lucide:arrow-up-right" : "lucide:arrow-down-left" %>'
                                                                style="font-size: 20px"></iconify-icon>
                                                        </div>
                                                        <div class="t-details">
                                                            <div class="t-title">
                                                                <%# Eval("Description") %>
                                                            </div>
                                                            <div class="t-meta">
                                                                <%# Eval("TxnDate", "{0:dd MMM yyyy, hh:mm tt}" ) %>
                                                            </div>
                                                        </div>
                                                        <div
                                                            class='t-amount <%# Eval("Sign").ToString() == "+" ? "credit" : "debit" %>'>
                                                            <%# Eval("Sign") %> ₹ <%# Eval("Amount") %>
                                                        </div>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <div class="empty-state">
                                                <iconify-icon icon="lucide:inbox"
                                                    style="font-size: 48px; opacity: 0.3; margin-bottom: 12px"></iconify-icon>
                                                <div>No recent transactions</div>
                                            </div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                            </section>
                        </div>
                    </div>
                </main>
            </div>
        </form>
    </body>

    </html>