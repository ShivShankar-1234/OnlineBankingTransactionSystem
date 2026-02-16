<%@ Page Title="Transaction History" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true"
    CodeBehind="TransactionHistory.aspx.cs" Inherits="OnlineBankingTransactionSystem.TransactionHistory" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Transaction History - Online Banking
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
        <style>
            .page-container {
                max-width: 1000px;
                margin: 0 auto;
            }

            .table-card {
                background-color: var(--card);
                border: 1px solid var(--border);
                border-radius: var(--radius-xl);
                overflow: hidden;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .table-header {
                padding: 24px;
                border-bottom: 1px solid var(--border);
            }

            .table-title {
                font-size: 20px;
                font-weight: 700;
                color: var(--foreground);
            }

            .table-responsive {
                overflow-x: auto;
            }

            .gv-transactions {
                width: 100%;
                border-collapse: collapse;
            }

            .gv-transactions th {
                background-color: var(--secondary);
                color: var(--foreground);
                font-weight: 600;
                font-size: 13px;
                text-align: left;
                padding: 16px 24px;
                border: none;
            }

            .gv-transactions td {
                padding: 16px 24px;
                border-bottom: 1px solid var(--border);
                font-size: 14px;
            }

            .gv-transactions tr:last-child td {
                border-bottom: none;
            }

            .gv-transactions tr:hover {
                background-color: var(--secondary);
            }

            .empty-state {
                padding: 60px 20px;
                text-align: center;
                color: var(--muted-foreground);
            }

            .table-footer {
                padding: 16px 24px;
                text-align: center;
                border-top: 1px solid var(--border);
                font-size: 13px;
                color: var(--muted-foreground);
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

            @media (max-width: 768px) {

                .gv-transactions th,
                .gv-transactions td {
                    padding: 12px 16px;
                    font-size: 13px;
                }
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageTitle" runat="server">
        Transaction History
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="TopActions" runat="server">
        <a href="Dashboard.aspx" class="back-btn">
            <iconify-icon icon="lucide:arrow-left" style="font-size: 16px"></iconify-icon>
            Back to Dashboard
        </a>
    </asp:Content>

    <asp:Content ID="Content5" ContentPlaceHolderID="MainContent" runat="server">
        <div class="page-container">
            <div class="table-card">
                <div class="table-header">
                    <div class="table-title">All Transactions</div>
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False" CssClass="gv-transactions"
                        GridLines="None" ShowHeader="true">
                        <Columns>
                            <asp:BoundField DataField="TxnDate" HeaderText="Date"
                                DataFormatString="{0:dd MMM yyyy, hh:mm tt}" />
                            <asp:BoundField DataField="CounterParty" HeaderText="To / From" />
                            <asp:BoundField DataField="Amount" HeaderText="Amount (₹)" DataFormatString="{0:N2}" />
                            <asp:BoundField DataField="TxnType" HeaderText="Type" />
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state">
                                <iconify-icon icon="lucide:inbox"
                                    style="font-size: 48px; opacity: 0.3; margin-bottom: 12px"></iconify-icon>
                                <div>No transactions found</div>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

                <div class="table-footer">
                    Showing all transactions
                </div>
            </div>
        </div>
    </asp:Content>