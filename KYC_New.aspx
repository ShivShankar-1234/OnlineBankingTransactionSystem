<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="KYC_New.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.KYC_New" %>

    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>KYC Verification</title>
        <style>
            body {
                font-family: Segoe UI;
                background: linear-gradient(120deg, #1d2671, #c33764);
                margin: 0;
            }

            .card {
                width: 420px;
                margin: 80px auto;
                background: #fff;
                padding: 30px;
                border-radius: 16px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, .3);
            }

            h2 {
                text-align: center;
                margin-bottom: 20px;
            }

            input,
            button {
                width: 100%;
                padding: 12px;
                margin: 10px 0;
                border-radius: 8px;
                border: 1px solid #ccc;
                font-size: 15px;
            }

            button {
                background: #27ae60;
                color: white;
                border: none;
                font-size: 16px;
                cursor: pointer;
            }

            button:hover {
                background: #219150;
            }

            .status {
                text-align: center;
                margin-top: 15px;
                font-weight: bold;
            }
        </style>
    </head>

    <body>
        <form runat="server">
            <div class="card">
                <h2>🛂 Complete Your KYC</h2>

                <asp:TextBox ID="txtAadhaar" runat="server" placeholder="Aadhaar Number (12 digits)" MaxLength="12">
                </asp:TextBox>

                <asp:TextBox ID="txtPAN" runat="server" placeholder="PAN Number (ABCDE1234F)" MaxLength="10">
                </asp:TextBox>

                <asp:Button ID="btnSubmit" runat="server" Text="Submit KYC" OnClick="btnSubmit_Click" />

                <asp:Label ID="lblStatus" runat="server" CssClass="status"></asp:Label>
            </div>
        </form>
    </body>

    </html>