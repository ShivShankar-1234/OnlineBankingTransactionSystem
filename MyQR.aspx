<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyQR.aspx.cs" Inherits="OnlineBankingTransactionSystem.MyQR"
    %>

    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>My QR Code</title>
        <link href="Content/bootstrap.min.css" rel="stylesheet" />
        <link href="Content/Site.css" rel="stylesheet" />
        <style>
            .qr-wrapper {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .qr-id-box {
                background: #f8f9fa;
                padding: 10px;
                border-radius: 8px;
                font-weight: 600;
                color: #555;
                word-break: break-all;
                margin-bottom: 20px;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="qr-wrapper">
                <div class="card-premium" style="width: 100%; max-width: 400px; text-align: center;">
                    <h2 style="color: var(--primary-color); font-weight: 700;">Scan to Pay</h2>

                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=upi://pay?pa=shivshankargupta4280-1@okicici&pn=Shivshankar%20Gupta"
                        alt="My QR Code" style="width: 250px; height: 250px; margin: 20px 0; border-radius: 10px;" />

                    <div class="qr-id-box">
                        UPI ID: shivshankargupta4280-1@okicici
                    </div>

                    <div class="form-group">
                        <asp:TextBox ID="txtAmount" runat="server" placeholder="Enter Amount" TextMode="Number"
                            CssClass="form-control-custom" Style="text-align: center;"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnSimulate" runat="server" Text="Pay & Receive Money" OnClick="btnSimulate_Click"
                        CssClass="btn-custom" Style="width: 100%; margin-bottom: 15px;" />

                    <a href="Dashboard.aspx" style="color: var(--secondary-color); font-weight: 600;">← Back to
                        Dashboard</a>
                </div>
            </div>
        </form>
    </body>

    </html>