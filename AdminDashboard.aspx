   <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.AdminDashboard" %>

    <!DOCTYPE html>
    <html lang="en">

    <head runat="server">
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Admin Dashboard — NeoBank</title>
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

            /* ── Sidebar ──────────────────────────────────── */
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
                cursor: pointer;
            }

            .sb-item:hover {
                background: rgba(255, 255, 255, .06);
                color: var(--text);
            }

            .sb-item.active {
                background: rgba(124, 58, 237, .18);
                color: #a78bfa;
            }

            .sb-item.active iconify-icon {
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

            /* ── Main ────────────────────────────────────── */
            .main {
                flex: 1;
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }

            /* Top bar */
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
            }

            .topbar-right {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .topbar-badge {
                background: rgba(16, 185, 129, .15);
                border: 1px solid rgba(16, 185, 129, .3);
                color: #34d399;
                font-size: 12px;
                font-weight: 600;
                padding: 4px 12px;
                border-radius: 100px;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .topbar-badge::before {
                content: '';
                width: 7px;
                height: 7px;
                background: #10b981;
                border-radius: 50%;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {

                0%,
                100% {
                    opacity: 1
                }

                50% {
                    opacity: .4
                }
            }

            .btn-logout {
                background: rgba(239, 68, 68, .15);
                border: 1px solid rgba(239, 68, 68, .25);
                color: #f87171;
                padding: 8px 16px;
                border-radius: 9px;
                font-size: 13px;
                font-weight: 600;
                font-family: 'Inter', sans-serif;
                cursor: pointer;
                transition: all .15s;
                display: flex;
                align-items: center;
                gap: 7px;
            }

            .btn-logout:hover {
                background: rgba(239, 68, 68, .25);
            }

            /* Scroll body */
            .main-body {
                flex: 1;
                overflow-y: auto;
                padding: 28px;
            }

            /* Stats row */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 16px;
                margin-bottom: 28px;
            }

            .stat-card {
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                padding: 20px 22px;
                display: flex;
                align-items: center;
                gap: 16px;
            }

            .stat-icon {
                width: 46px;
                height: 46px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
            }

            .stat-val {
                font-size: 26px;
                font-weight: 800;
                color: var(--text);
                line-height: 1;
            }

            .stat-label {
                font-size: 12px;
                color: var(--muted);
                margin-top: 4px;
                font-weight: 500;
            }

            /* KYC Table card */
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

            .quick-link {
                background: rgba(124, 58, 237, .15);
                border: 1px solid rgba(124, 58, 237, .25);
                color: #a78bfa;
                padding: 7px 14px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 600;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 7px;
                transition: background .15s;
            }

            .quick-link:hover {
                background: rgba(124, 58, 237, .25);
            }

            /* Grid overrides */
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
                padding: 12px 20px;
                text-align: left;
                border-bottom: 1px solid var(--border);
            }

            .admin-grid td {
                padding: 14px 20px;
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

            .kyc-badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 4px 10px;
                border-radius: 100px;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .05em;
            }

            .kyc-badge.pending {
                background: rgba(245, 158, 11, .15);
                border: 1px solid rgba(245, 158, 11, .3);
                color: #fbbf24;
            }

            .kyc-badge.verified {
                background: rgba(16, 185, 129, .15);
                border: 1px solid rgba(16, 185, 129, .3);
                color: #34d399;
            }

            .kyc-badge.rejected {
                background: rgba(239, 68, 68, .15);
                border: 1px solid rgba(239, 68, 68, .3);
                color: #f87171;
            }

            .btn-approve {
                background: rgba(16, 185, 129, .15);
                border: 1px solid rgba(16, 185, 129, .3);
                color: #34d399;
                padding: 6px 14px;
                border-radius: 7px;
                font-size: 12px;
                font-weight: 600;
                font-family: 'Inter', sans-serif;
                cursor: pointer;
                transition: all .15s;
                margin-right: 6px;
            }

            .btn-approve:hover {
                background: rgba(16, 185, 129, .28);
            }

            .btn-reject {
                background: rgba(239, 68, 68, .12);
                border: 1px solid rgba(239, 68, 68, .25);
                color: #f87171;
                padding: 6px 14px;
                border-radius: 7px;
                font-size: 12px;
                font-weight: 600;
                font-family: 'Inter', sans-serif;
                cursor: pointer;
                transition: all .15s;
            }

            .btn-reject:hover {
                background: rgba(239, 68, 68, .25);
            }

            .empty-row td {
                text-align: center;
                color: var(--muted);
                padding: 48px 20px;
                font-size: 14px;
            }
        </style>
    </head>

    <body>
        <form runat="server">
            <div style="display:flex; height:100vh; overflow:hidden;">

                <!-- ── Sidebar ── -->
                <aside class="sidebar">
                    <div class="sb-logo">
                        <div class="sb-logo-icon">
                            <iconify-icon icon="lucide:landmark" style="font-size:20px; color:white"></iconify-icon>
                        </div>
                        <span class="sb-logo-text">NeoBank <span class="sb-badge">Admin</span></span>
                    </div>

                    <div class="sb-section">Navigation</div>
                    <a href="AdminDashboard.aspx" class="sb-item active">
                        <iconify-icon icon="lucide:layout-dashboard" style="font-size:18px"></iconify-icon>
                        Dashboard
                    </a>
                    <a href="AdminKYC.aspx" class="sb-item">
                        <iconify-icon icon="lucide:shield-check" style="font-size:18px"></iconify-icon>
                        KYC Requests
                    </a>
                    <a href="AdminUsers.aspx" class="sb-item">
                        <iconify-icon icon="lucide:users" style="font-size:18px"></iconify-icon>
                        All Users
                    </a>
                    <a href="AdminTransactions.aspx" class="sb-item">
                        <iconify-icon icon="lucide:activity" style="font-size:18px"></iconify-icon>
                        Transactions
                    </a>
                    <a href="AdminLinkedAccounts.aspx" class="sb-item">
                        <iconify-icon icon="lucide:credit-card" style="font-size:18px"></iconify-icon>
                        Linked Accounts
                    </a>

                    <div class="sb-spacer"></div>

                    <div class="sb-user">
                        <div class="sb-avatar">A</div>
                        <div class="sb-user-info">
                            <div class="sb-user-name">Administrator</div>
                            <div class="sb-user-role">Super Admin</div>
                        </div>
                    </div>
                </aside>

                <!-- ── Main ── -->
                <div class="main">
                    <!-- Top Bar -->
                    <header class="topbar">
                        <span class="topbar-title">Dashboard Overview</span>
                        <div class="topbar-right">
                            <div class="topbar-badge">System Online</div>
                            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout"
                                OnClick="BtnLogout_Click" />
                        </div>
                    </header>

                    <!-- Body -->
                    <div class="main-body">

                        <!-- Stats -->
                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(124,58,237,.15);">
                                    <iconify-icon icon="lucide:users"
                                        style="font-size:22px; color:#a78bfa"></iconify-icon>
                                </div>
                                <div>
                                    <div class="stat-val">–</div>
                                    <div class="stat-label">Total Users</div>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(245,158,11,.12);">
                                    <iconify-icon icon="lucide:clock"
                                        style="font-size:22px; color:#fbbf24"></iconify-icon>
                                </div>
                                <div>
                                    <div class="stat-val">–</div>
                                    <div class="stat-label">Pending KYC</div>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(16,185,129,.12);">
                                    <iconify-icon icon="lucide:shield-check"
                                        style="font-size:22px; color:#34d399"></iconify-icon>
                                </div>
                                <div>
                                    <div class="stat-val">–</div>
                                    <div class="stat-label">Verified KYC</div>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background:rgba(99,102,241,.12);">
                                    <iconify-icon icon="lucide:landmark"
                                        style="font-size:22px; color:#818cf8"></iconify-icon>
                                </div>
                                <div>
                                    <div class="stat-val">–</div>
                                    <div class="stat-label">Linked Accounts</div>
                                </div>
                            </div>
                        </div>

                        <!-- KYC Table -->
                        <div class="table-card">
                            <div class="table-header">
                                <div class="table-title">
                                    <iconify-icon icon="lucide:shield-alert"
                                        style="font-size:18px; color:#a78bfa"></iconify-icon>
                                    Pending KYC Requests
                                </div>
                                <a href="AdminLinkedAccounts.aspx" class="quick-link">
                                    <iconify-icon icon="lucide:credit-card" style="font-size:14px"></iconify-icon>
                                    View Linked Accounts
                                </a>
                            </div>

                            <asp:GridView ID="gvKYC" runat="server" AutoGenerateColumns="False" CssClass="admin-grid"
                                Width="100%" HeaderStyle-CssClass="grid-header" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="UserID" HeaderText="User ID" />
                                    <asp:BoundField DataField="FullName" HeaderText="Name" />
                                    <asp:BoundField DataField="Email" HeaderText="Email" />
                                    <asp:BoundField DataField="AadhaarNumber" HeaderText="Aadhaar" />
                                    <asp:BoundField DataField="PANNumber" HeaderText="PAN" />
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class='kyc-badge pending'>⏳ Pending</span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:Button ID="btnApprove" runat="server" Text="✓ Approve"
                                                CssClass="btn-approve" CommandArgument='<%# Eval("UserID") %>'
                                                OnClick="Approve_Click" />
                                            <asp:Button ID="btnReject" runat="server" Text="✕ Reject"
                                                CssClass="btn-reject" CommandArgument='<%# Eval("UserID") %>'
                                                OnClick="Reject_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <table class="admin-grid" style="width:100%">
                                        <tr class="empty-row">
                                            <td colspan="7">
                                                <iconify-icon icon="lucide:check-circle-2"
                                                    style="font-size:40px; color:#34d399; display:block; margin:0 auto 12px;"></iconify-icon>
                                                All KYC requests have been processed!
                                            </td>
                                        </tr>
                                    </table>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>

                    </div><!-- /main-body -->
                </div><!-- /main -->
            </div>
        </form>
    </body>

    </html>