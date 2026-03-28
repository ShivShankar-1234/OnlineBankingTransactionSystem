<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.AdminLogin" %>

    <!DOCTYPE html>
    <html lang="en">

    <head runat="server">
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Admin Login — NeoBank</title>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
            rel="stylesheet" />
        <script src="https://code.iconify.design/iconify-icon/3.0.0/iconify-icon.min.js"></script>
        <style>
            *,
            *::before,
            *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Inter', sans-serif;
                min-height: 100vh;
                display: flex;
                background: #0a0f1e;
                overflow: hidden;
            }

            /* ── Left Art Panel ──────────────────────────────── */
            .art-panel {
                flex: 1;
                background: linear-gradient(135deg, #1e1b4b 0%, #312e81 40%, #4c1d95 100%);
                position: relative;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 60px;
                overflow: hidden;
            }

            .art-panel::before {
                content: '';
                position: absolute;
                width: 500px;
                height: 500px;
                border-radius: 50%;
                background: radial-gradient(circle, rgba(139, 92, 246, .25) 0%, transparent 70%);
                top: -100px;
                right: -100px;
            }

            .art-panel::after {
                content: '';
                position: absolute;
                width: 350px;
                height: 350px;
                border-radius: 50%;
                background: radial-gradient(circle, rgba(99, 102, 241, .2) 0%, transparent 70%);
                bottom: -80px;
                left: 60px;
            }

            .art-logo {
                display: flex;
                align-items: center;
                gap: 14px;
                margin-bottom: 56px;
                z-index: 1;
            }

            .art-logo-icon {
                width: 50px;
                height: 50px;
                background: linear-gradient(135deg, #8b5cf6, #6366f1);
                border-radius: 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 8px 24px rgba(139, 92, 246, .4);
            }

            .art-logo-text {
                font-size: 26px;
                font-weight: 800;
                color: white;
            }

            .art-tagline {
                font-size: 38px;
                font-weight: 800;
                color: white;
                line-height: 1.2;
                text-align: center;
                margin-bottom: 20px;
                z-index: 1;
            }

            .art-sub {
                font-size: 16px;
                color: rgba(255, 255, 255, .6);
                text-align: center;
                z-index: 1;
                max-width: 380px;
            }

            .art-badges {
                display: flex;
                gap: 12px;
                margin-top: 48px;
                z-index: 1;
                flex-wrap: wrap;
                justify-content: center;
            }

            .art-badge {
                background: rgba(255, 255, 255, .1);
                border: 1px solid rgba(255, 255, 255, .15);
                border-radius: 100px;
                padding: 8px 18px;
                font-size: 13px;
                color: rgba(255, 255, 255, .8);
                display: flex;
                align-items: center;
                gap: 7px;
            }

            /* ── Right Login Panel ──────────────────────────── */
            .login-panel {
                width: 480px;
                flex-shrink: 0;
                background: #0d1117;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 48px 40px;
                border-left: 1px solid rgba(255, 255, 255, .06);
            }

            .login-box {
                width: 100%;
            }

            .login-header {
                margin-bottom: 36px;
            }

            .login-title {
                font-size: 28px;
                font-weight: 800;
                color: #f1f5f9;
                margin-bottom: 6px;
            }

            .login-desc {
                font-size: 14px;
                color: #64748b;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: #94a3b8;
                margin-bottom: 8px;
                letter-spacing: .04em;
                text-transform: uppercase;
            }

            .input-wrapper {
                position: relative;
            }

            .input-icon {
                position: absolute;
                left: 14px;
                top: 50%;
                transform: translateY(-50%);
                color: #475569;
                display: flex;
            }

            .form-input {
                width: 100%;
                background: #1e2533;
                border: 1.5px solid #2d3748;
                border-radius: 12px;
                padding: 14px 14px 14px 44px;
                font-size: 14px;
                color: #f1f5f9;
                font-family: 'Inter', sans-serif;
                transition: border-color .2s, box-shadow .2s;
                outline: none;
            }

            .form-input:focus {
                border-color: #7c3aed;
                box-shadow: 0 0 0 3px rgba(124, 58, 237, .2);
            }

            .form-input::placeholder {
                color: #475569;
            }

            .btn-login {
                width: 100%;
                background: linear-gradient(135deg, #7c3aed, #6366f1);
                color: white;
                border: none;
                border-radius: 12px;
                padding: 15px;
                font-size: 15px;
                font-weight: 700;
                font-family: 'Inter', sans-serif;
                cursor: pointer;
                transition: transform .15s, box-shadow .15s, opacity .15s;
                box-shadow: 0 8px 24px rgba(124, 58, 237, .35);
                margin-top: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 12px 32px rgba(124, 58, 237, .45);
            }

            .btn-login:active {
                transform: translateY(0);
            }

            .error-msg {
                background: rgba(239, 68, 68, .12);
                border: 1px solid rgba(239, 68, 68, .25);
                border-radius: 10px;
                padding: 12px 16px;
                font-size: 13px;
                color: #f87171;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .back-link {
                display: block;
                text-align: center;
                margin-top: 28px;
                font-size: 13px;
                color: #475569;
                text-decoration: none;
                transition: color .2s;
            }

            .back-link:hover {
                color: #7c3aed;
            }

            .security-note {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-top: 32px;
                padding: 12px 16px;
                background: rgba(16, 185, 129, .08);
                border: 1px solid rgba(16, 185, 129, .15);
                border-radius: 10px;
                font-size: 12px;
                color: #34d399;
            }

            @media (max-width: 900px) {
                .art-panel {
                    display: none;
                }

                .login-panel {
                    width: 100%;
                    border: none;
                    background: #0a0f1e;
                }
            }
        </style>
    </head>

    <body>
        <form runat="server">
            <div style="display:flex; min-height:100vh;">

                <!-- ── Art Panel ── -->
                <div class="art-panel">
                    <div class="art-logo">
                        <div class="art-logo-icon">
                            <iconify-icon icon="lucide:landmark" style="font-size:26px; color:white"></iconify-icon>
                        </div>
                        <span class="art-logo-text">NeoBank</span>
                    </div>
                    <h1 class="art-tagline">Admin Control<br />Centre</h1>
                    <p class="art-sub">Manage KYC approvals, monitor accounts, and oversee all banking operations from
                        one place.</p>
                    <div class="art-badges">
                        <div class="art-badge">
                            <iconify-icon icon="lucide:shield-check" style="font-size:14px"></iconify-icon>
                            KYC Management
                        </div>
                        <div class="art-badge">
                            <iconify-icon icon="lucide:users" style="font-size:14px"></iconify-icon>
                            User Oversight
                        </div>
                        <div class="art-badge">
                            <iconify-icon icon="lucide:activity" style="font-size:14px"></iconify-icon>
                            Live Monitoring
                        </div>
                    </div>
                </div>

                <!-- ── Login Panel ── -->
                <div class="login-panel">
                    <div class="login-box">
                        <div class="login-header">
                            <h2 class="login-title">Admin Sign In</h2>
                            <p class="login-desc">Enter your credentials to access the admin panel</p>
                        </div>

                        <asp:Label ID="lblError" runat="server" Visible="false">
                            <div class="error-msg">
                                <iconify-icon icon="lucide:alert-triangle" style="font-size:16px"></iconify-icon>
                                <span id="errText"></span>
                            </div>
                        </asp:Label>

                        <div class="form-group">
                            <label class="form-label">Admin Email</label>
                            <div class="input-wrapper">
                                <span class="input-icon">
                                    <iconify-icon icon="lucide:mail" style="font-size:18px"></iconify-icon>
                                </span>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input"
                                    placeholder="admin@neobank.com"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Password</label>
                            <div class="input-wrapper">
                                <span class="input-icon">
                                    <iconify-icon icon="lucide:lock" style="font-size:18px"></iconify-icon>
                                </span>
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-input"
                                    placeholder="••••••••"></asp:TextBox>
                            </div>
                        </div>

                        <asp:Button ID="btnLogin" runat="server" OnClick="btnLogin_Click" CssClass="btn-login"
                            Text="Sign In to Admin Panel" />

                        <div class="security-note">
                            <iconify-icon icon="lucide:lock" style="font-size:14px"></iconify-icon>
                            Secured with end-to-end encryption. Unauthorised access is prohibited.
                        </div>

                        <a href="Login.aspx" class="back-link">← Back to User Login</a>
                    </div>
                </div>

            </div>
        </form>
    </body>

    </html>