<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SetupDatabase.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.SetupDatabase" %>

    <!DOCTYPE html>
    <html>

    <head>
        <title>Database Setup</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 40px;
                background: #f5f5f5;
            }

            .container {
                max-width: 600px;
                margin: 0 auto;
                background: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            h1 {
                color: #333;
            }

            .btn {
                padding: 12px 24px;
                background: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
            }

            .btn:hover {
                background: #0056b3;
            }

            .message {
                margin-top: 20px;
                padding: 15px;
                border-radius: 4px;
            }

            .success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .error {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .info {
                background: #d1ecf1;
                color: #0c5460;
                border: 1px solid #bee5eb;
            }
        </style>
    </head>

    <body>
        <form runat="server">
            <div class="container">
                <h1>Database Setup & Repair</h1>
                <p>Click the button below to Create Missing Tables and Fix Schema Issues.</p>

                <asp:Button ID="btnSetup" runat="server" Text="Run Database Setup & Update Schema" CssClass="btn"
                    OnClick="btnSetup_Click" />

                <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>

                <div style="margin-top: 20px; border-top: 1px solid #ddd; padding-top: 20px;">
                    <a href="Dashboard.aspx"
                        style="text-decoration: none; color: #007bff; font-weight: bold; margin-right: 15px;">Go to
                        Dashboard</a>
                    <a href="Login.aspx" style="text-decoration: none; color: #555;">Go to Login</a>
                </div>
            </div>
        </form>
    </body>

    </html>