<%@ Page Title="Manage Beneficiaries" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true"
    CodeBehind="ManageBeneficiaries.aspx.cs" Inherits="OnlineBankingTransactionSystem.ManageBeneficiaries" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Manage Beneficiaries - Online Banking
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
        <style>
            .page-container {
                max-width: 900px;
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

            .gv-beneficiaries {
                width: 100%;
                border-collapse: collapse;
            }

            .gv-beneficiaries th {
                background-color: var(--secondary);
                color: var(--foreground);
                font-weight: 600;
                font-size: 13px;
                text-align: left;
                padding: 16px 24px;
                border: none;
            }

            .gv-beneficiaries td {
                padding: 16px 24px;
                border-bottom: 1px solid var(--border);
                font-size: 14px;
            }

            .gv-beneficiaries tr:last-child td {
                border-bottom: none;
            }

            .gv-beneficiaries tr:hover {
                background-color: var(--secondary);
            }

            .btn-delete {
                background-color: var(--destructive);
                color: var(--destructive-foreground);
                border: none;
                padding: 6px 12px;
                border-radius: var(--radius-sm);
                font-size: 12px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
            }

            .btn-delete:hover {
                background-color: #dc2626;
            }

            .empty-state {
                padding: 60px 20px;
                text-align: center;
                color: var(--muted-foreground);
            }

            .btn-add {
                background-color: var(--primary);
                color: var(--primary-foreground);
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

            .btn-add:hover {
                background-color: #4338ca;
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

                .gv-beneficiaries th,
                .gv-beneficiaries td {
                    padding: 12px 16px;
                    font-size: 13px;
                }
            }
        </style>

        <script>
            function confirmDelete() {
                return confirm('Are you sure you want to delete this beneficiary?');
            }
        </script>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageTitle" runat="server">
        Manage Beneficiaries
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="TopActions" runat="server">
        <asp:Button ID="btnAddNew" runat="server" Text="Add New" CssClass="btn-add" OnClick="btnAddNew_Click" />
        <a href="Dashboard.aspx" class="back-btn">
            <iconify-icon icon="lucide:arrow-left" style="font-size: 16px"></iconify-icon>
            Back to Dashboard
        </a>
    </asp:Content>

    <asp:Content ID="Content5" ContentPlaceHolderID="MainContent" runat="server">
        <div class="page-container">
            <div class="table-card">
                <div class="table-header">
                    <div class="table-title">Saved Beneficiaries</div>
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="gvBeneficiaries" runat="server" AutoGenerateColumns="False"
                        CssClass="gv-beneficiaries" GridLines="None" ShowHeader="true"
                        OnRowCommand="gvBeneficiaries_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="Nickname" HeaderText="Nickname" />
                            <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn-delete"
                                        CommandName="DeleteBeneficiary" CommandArgument='<%# Eval("BeneficiaryID") %>'
                                        OnClientClick="return confirmDelete();" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state">
                                <iconify-icon icon="lucide:users"
                                    style="font-size: 48px; opacity: 0.3; margin-bottom: 12px"></iconify-icon>
                                <div>No beneficiaries added yet</div>
                                <div style="margin-top: 8px; font-size: 13px;">Click "Add New" to add your first
                                    beneficiary</div>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </asp:Content>