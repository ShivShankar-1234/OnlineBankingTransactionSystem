<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminUsers.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.AdminUsers" %>

    <!DOCTYPE html>
    <html lang="en">

    <head runat="server">
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>All Users — NeoBank Admin</title>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
            rel="stylesheet" />
        <script src="https://code.iconify.design/iconify-icon/3.0.0/iconify-icon.min.js"></script>
        <style>
            :root {
                --bg: #0d1117;
                --sidebar: #010409;
                --card: #161b22;
                --card2: #1c2128;
                --border: rgba(255, 255, 255, .08);
                --primary: #7c3aed;
                --primary2: #6366f1;
                --success: #10b981;
                --warning: #f59e0b;
                --danger: #ef4444;
                --text: #e6edf3;
                --muted: #7d8590;
                --radius: 12px;
            }

            *,
            *::before,
            *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: var(--bg);
                color: var(--text);
                display: flex;
                height: 100vh;
                overflow: hidden;
            }

            /* Sidebar */
            .sidebar {
                width: 240px;
                flex-shrink: 0;
                background: var(--sidebar);
                border-right: 1px solid var(--border);
                display: flex;
                flex-direction: column;
                height: 100vh;
                overflow-y: auto;
            }

            .sb-logo {
                padding: 24px 20px 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                border-bottom: 1px solid var(--border);
            }

            .sb-logo-icon {
                width: 36px;
                height: 36px;
                border-radius: 10px;
                background: linear-gradient(135deg, var(--primary), var(--primary2));
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 4px 12px rgba(124, 58, 237, .4);
            }

            .sb-logo-text {
                font-size: 17px;
                font-weight: 800;
                color: var(--text);
            }

            .sb-badge {
                font-size: 9px;
                font-weight: 700;
                background: var(--primary);
                color: white;
                padding: 2px 7px;
                border-radius: 100px;
                margin-left: 6px;
                letter-spacing: .05em;
                text-transform: uppercase;
            }

            .sb-section {
                padding: 20px 12px 8px;
                font-size: 11px;
                font-weight: 600;
                color: var(--muted);
                letter-spacing: .08em;
                text-transform: uppercase;
            }

            .sb-item {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 16px;
                border-radius: 9px;
                margin: 2px 8px;
                font-size: 14px;
                font-weight: 500;
                color: var(--muted);
                text-decoration: none;
                transition: all .15s;
            }

            .sb-item:hover {
                background: rgba(255, 255, 255, .06);
                color: var(--text);
            }

            .sb-item.active {
                background: rgba(124, 58, 237, .18);
                color: #a78bfa;
            }

            .sb-spacer {
                flex: 1;
            }

            .sb-user {
                padding: 16px 20px;
                border-top: 1px solid var(--border);
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .sb-avatar {
                width: 34px;
                height: 34px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--primary), var(--primary2));
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
                font-weight: 700;
                color: white;
                flex-shrink: 0;
            }

            .sb-user-name {
                font-size: 13px;
                font-weight: 600;
                color: var(--text);
            }

            .sb-user-role {
                font-size: 11px;
                color: var(--muted);
            }

            /* Main */
            .main {
                flex: 1;
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }

            .topbar {
                height: 62px;
                background: var(--card);
                border-bottom: 1px solid var(--border);
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 28px;
                flex-shrink: 0;
            }

            .topbar-title {
                font-size: 17px;
                font-weight: 700;
                color: var(--text);
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .topbar-right {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .btn-back {
                background: rgba(255, 255, 255, .07);
                border: 1px solid var(--border);
                color: var(--muted);
                padding: 8px 14px;
                border-radius: 9px;
                font-size: 13px;
                font-weight: 500;
                font-family: 'Inter', sans-serif;
                cursor: pointer;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 7px;
                transition: all .15s;
            }

            .btn-back:hover {
                background: rgba(255, 255, 255, .12);
                color: var(--text);
            }

            .main-body {
                flex: 1;
                overflow-y: auto;
                padding: 28px;
            }

            /* Search bar */
            .search-card {
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                padding: 18px 22px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 12px;
                flex-wrap: wrap;
            }

            .search-input-wrap {
                position: relative;
                flex: 1;
                min-width: 220px;
                max-width: 380px;
            }

            .search-icon {
                position: absolute;
                left: 13px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--muted);
                display: flex;
            }

            .search-input {
                width: 100%;
                background: #1e2533;
                border: 1.5px solid #2d3748;
                border-radius: 10px;
                padding: 11px 11px 11px 40px;
                font-size: 13px;
                color: var(--text);
                font-family: 'Inter', sans-serif;
                transition: border-color .2s;
                outline: none;
            }

            .search-input:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(124, 58, 237, .15);
            }

            .search-input::placeholder {
                color: var(--muted);
            }

            .btn-search {
                background: linear-gradient(135deg, var(--primary), var(--primary2));
                color: white;
                border: none;
                padding: 11px 20px;
                border-radius: 10px;
                font-size: 13px;
                font-weight: 700;
                font-family: 'Inter', sans-serif;
                cursor: pointer;
                transition: all .15s;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn-search:hover {
                opacity: .9;
                transform: translateY(-1px);
            }

            /* Table card */
            .table-card {
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                overflow: hidden;
            }

            .table-header {
                padding: 18px 24px;
                border-bottom: 1px solid var(--border);
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .table-title {
                font-size: 15px;
                font-weight: 700;
                color: var(--text);
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .table-desc {
                font-size: 13px;
                color: var(--muted);
                margin-top: 3px;
            }

            .admin-grid {
                width: 100%;
                border-collapse: collapse;
            }

            .admin-grid th {
                background: var(--card2);
                color: var(--muted);
                font-size: 11px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: .07em;
                padding: 12px 18px;
                text-align: left;
                border-bottom: 1px solid var(--border);
                white-space: nowrap;
            }

            .admin-grid td {
                padding: 14px 18px;
                border-bottom: 1px solid rgba(255, 255, 255, .04);
                font-size: 13px;
                color: var(--text);
                vertical-align: middle;
            }

            .admin-grid tr:last-child td {
                border-bottom: none;
            }

            .admin-grid tr:hover td {
                background: rgba(255, 255, 255, .025);
            }

            .user-avatar {
                width: 32px;
                height: 32px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--primary), var(--primary2));
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                font-weight: 700;
                color: white;
                flex-shrink: 0;
            }

            .user-cell {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .user-name {
                font-weight: 600;
                color: var(--text);
            }

            .user-email {
                font-size: 11px;
                color: var(--muted);
            }

            .balance-val {
                font-weight: 700;
                color: #34d399;
            }

            .acno {
                font-family: monospace;
                font-size: 12px;
                color: #94a3b8;
                background: rgba(255, 255, 255, .05);
                padding: 2px 8px;
                border-radius: 5px;
            }

            .kyc-chip {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 3px 10px;
                border-radius: 100px;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .04em;
            }

            .kyc-verified {
                background: rgba(16, 185, 129, .15);
                border: 1px solid rgba(16, 185, 129, .3);
                color: #34d399;
            }

            .kyc-pending {
                background: rgba(245, 158, 11, .12);
                border: 1px solid rgba(245, 158, 11, .3);
                color: #fbbf24;
            }

            .kyc-rejected {
                background: rgba(239, 68, 68, .12);
                border: 1px solid rgba(239, 68, 68, .3);
                color: #f87171;
            }

            .kyc-none {
                background: rgba(125, 133, 144, .1);
                border: 1px solid rgba(125, 133, 144, .2);
                color: var(--muted);
            }

            .role-chip {
                display: inline-flex;
                align-items: center;
                padding: 3px 10px;
                border-radius: 100px;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
            }

            .role-admin {
                background: rgba(124, 58, 237, .2);
                border: 1px solid rgba(124, 58, 237, .4);
                color: #a78bfa;
            }

            .role-user {
                background: rgba(99, 102, 241, .1);
                border: 1px solid rgba(99, 102, 241, .2);
                color: #818cf8;
            }

            .empty-td {
                text-align: center;
                padding: 60px 20px !important;
                color: var(--muted);
            }
        </style>
    </head>

    <body>
        <form runat="server">
            <div style="display:flex;height:100vh;overflow:hidden;">

                <!-- Sidebar -->
                <aside class="sidebar">
                    <div class="sb-logo">
                        <div class="sb-logo-icon">
                            <iconify-icon icon="lucide:landmark" style="font-size:20px;color:white"></iconify-icon>
                        </div>
                        <span class="sb-logo-text">NeoBank <span class="sb-badge">Admin</span></span>
                    </div>
                    <div class="sb-section">Navigation</div>
                    <a href="AdminDashboard.aspx" class="sb-item">
                        <iconify-icon icon="lucide:layout-dashboard" style="font-size:18px"></iconify-icon>Dashboard
                    </a>
                    <a href="AdminKYC.aspx" class="sb-item">
                        <iconify-icon icon="lucide:shield-check" style="font-size:18px"></iconify-icon>KYC Requests
                    </a>
                    <a href="AdminUsers.aspx" class="sb-item active">
                        <iconify-icon icon="lucide:users" style="font-size:18px"></iconify-icon>All Users
                    </a>
                    <a href="AdminTransactions.aspx" class="sb-item">
                        <iconify-icon icon="lucide:activity" style="font-size:18px"></iconify-icon>Transactions
                    </a>
                    <a href="AdminLinkedAccounts.aspx" class="sb-item">
                        <iconify-icon icon="lucide:credit-card" style="font-size:18px"></iconify-icon>Linked Accounts
                    </a>
                    <div class="sb-spacer"></div>
                    <div class="sb-user">
                        <div class="sb-avatar">A</div>
                        <div>
                            <div class="sb-user-name">Administrator</div>
                            <div class="sb-user-role">Super Admin</div>
                        </div>
                    </div>
                </aside>

                <!-- Main -->
                <div class="main">
                    <header class="topbar">
                        <div class="topbar-title">
                            <iconify-icon icon="lucide:users" style="font-size:20px;color:#a78bfa"></iconify-icon>
                            All Registered Users
                        </div>
                        <div class="topbar-right">
                            <a href="AdminDashboard.aspx" class="btn-back">
                                <iconify-icon icon="lucide:arrow-left" style="font-size:14px"></iconify-icon>
                                Back to Dashboard
                            </a>
                        </div>
                    </header>

                    <div class="main-body">

                        <!-- Search -->
                        <div class="search-card">
                            <div class="search-input-wrap">
                                <span class="search-icon">
                                    <iconify-icon icon="lucide:search" style="font-size:16px"></iconify-icon>
                                </span>
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input"
                                    placeholder="Search by name, email or account number..."></asp:TextBox>
                            </div>
                            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-search"
                                OnClick="btnSearch_Click" />
                        </div>

                        <!-- Table -->
                        <div class="table-card">
                            <div class="table-header">
                                <div>
                                    <div class="table-title">
                                        <iconify-icon icon="lucide:users-2"
                                            style="font-size:16px;color:#a78bfa"></iconify-icon>
                                        User Directory
                                    </div>
                                    <div class="table-desc">All registered customers and their account details</div>
                                </div>
                                <asp:Label ID="lblCount" runat="server" style="font-size:12px;color:#7d8590;">
                                </asp:Label>
                            </div>

                            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="admin-grid"
                                GridLines="None" Width="100%">
                                <Columns>
                                    <asp:BoundField DataField="UserID" HeaderText="ID" />
                                    <asp:TemplateField HeaderText="User">
                                        <ItemTemplate>
                                            <div class="user-cell">
                                                <div class="user-avatar">
                                                    <%# Eval("FullName") !=null && Eval("FullName").ToString().Length> 0
                                                        ? Eval("FullName").ToString()[0].ToString().ToUpper() : "?" %>
                                                </div>
                                                <div>
                                                    <div class="user-name">
                                                        <%# Eval("FullName") %>
                                                    </div>
                                                    <div class="user-email">
                                                        <%# Eval("Email") %>
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Account No.">
                                        <ItemTemplate>
                                            <span class="acno">
                                                <%# Eval("AccountNumber") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="IFSC" HeaderText="IFSC" />
                                    <asp:TemplateField HeaderText="Balance">
                                        <ItemTemplate>
                                            <span class="balance-val">&#8377;<%# string.Format("{0:N2}",
                                                    Eval("Balance")) %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="KYC Status">
                                        <ItemTemplate>
                                            <span class='kyc-chip <%# GetKycClass(Eval("KYCStatus")) %>'>
                                                <%# Eval("KYCStatus") ?? "Not Submitted" %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Role">
                                        <ItemTemplate>
                                            <span
                                                class='role-chip <%# Eval("Role").ToString() == "ADMIN" ? "role-admin" : "role-user" %>'>
                                                <%# Eval("Role") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CreatedAt" HeaderText="Joined"
                                        DataFormatString="{0:dd MMM yyyy}" />
                                </Columns>
                                <EmptyDataTemplate>
                                    <table style="width:100%">
                                        <tr>
                                            <td class="empty-td" colspan="8">
                                                <iconify-icon icon="lucide:users"
                                                    style="font-size:48px;color:#7d8590;display:block;margin:0 auto 14px;"></iconify-icon>
                                                <strong
                                                    style="color:#e6edf3;font-size:15px;display:block;margin-bottom:8px;">No
                                                    users found</strong>
                                                No matching users found for your search.
                                            </td>
                                        </tr>
                                    </table>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </body>

    </html>