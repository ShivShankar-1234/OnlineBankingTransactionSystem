<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DiagnoseDB.aspx.cs"
    Inherits="OnlineBankingTransactionSystem.DiagnoseDB" %>

    <!DOCTYPE html>
    <html>

    <head>
        <title>Database Diagnosis</title>
        <style>
            body {
                font-family: monospace;
                padding: 20px;
            }

            .success {
                color: green;
            }

            .error {
                color: red;
            }

            table {
                border-collapse: collapse;
                width: 100%;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }

            th {
                background-color: #f2f2f2;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <h1>Database Diagnostic Report</h1>
            <asp:Button ID="btnRun" runat="server" Text="Run Diagnosis" OnClick="btnRun_Click" />
            <hr />
            <asp:Literal ID="litResult" runat="server"></asp:Literal>
        </form>
    </body>

    </html>