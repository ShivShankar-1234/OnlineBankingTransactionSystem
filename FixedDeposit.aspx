<%@ Page Title="Fixed Deposit" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true"
    CodeBehind="FixedDeposit.aspx.cs" Inherits="OnlineBankingTransactionSystem.FixedDeposit" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Fixed Deposit
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="PageTitle" runat="server">
        Fixed Deposits
    </asp:Content>

    <%-- Scoped CSS injected into HeadContent --%>
        <asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
            <style>
                /* ── FD Page Styles ──────────────────────────────────────── */
                .fd-grid {
                    display: grid;
                    grid-template-columns: 400px 1fr;
                    gap: 24px;
                    align-items: start;
                }

                /* ── New FD Card ─────────────────────────────────────────── */
                .fd-new-card {
                    background: #ffffff;
                    border: 1px solid #e2e8f0;
                    border-radius: 20px;
                    overflow: hidden;
                    box-shadow: 0 4px 24px rgba(79, 70, 229, .07);
                }

                .fd-new-header {
                    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
                    padding: 24px 28px;
                    position: relative;
                    overflow: hidden;
                }

                .fd-new-header::before {
                    content: '';
                    position: absolute;
                    width: 160px;
                    height: 160px;
                    border-radius: 50%;
                    background: rgba(255, 255, 255, .08);
                    top: -50px;
                    right: -40px;
                    pointer-events: none;
                }

                .fd-new-header-icon {
                    width: 44px;
                    height: 44px;
                    background: rgba(255, 255, 255, .15);
                    border: 1.5px solid rgba(255, 255, 255, .25);
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-bottom: 12px;
                }

                .fd-new-header h5 {
                    font-size: 18px;
                    font-weight: 700;
                    color: white;
                    margin: 0;
                }

                .fd-new-header p {
                    font-size: 13px;
                    color: rgba(255, 255, 255, .7);
                    margin: 4px 0 0;
                }

                .fd-new-body {
                    padding: 24px 28px;
                }

                /* Alert message */
                .fd-alert {
                    border-radius: 10px;
                    padding: 12px 16px;
                    font-size: 13px;
                    margin-bottom: 18px;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    border: 1px solid;
                }

                .fd-alert-info {
                    background: #eff6ff;
                    border-color: #bfdbfe;
                    color: #1d4ed8;
                }

                .fd-alert-success {
                    background: #f0fdf4;
                    border-color: #bbf7d0;
                    color: #15803d;
                }

                .fd-alert-danger {
                    background: #fef2f2;
                    border-color: #fecaca;
                    color: #dc2626;
                }

                /* Bootstrap alert classes — set by code-behind on pnlMessage */
                .alert {
                    border-radius: 10px;
                    padding: 12px 16px;
                    font-size: 13px;
                    margin-bottom: 18px;
                    border: 1.5px solid;
                    font-family: 'Inter', sans-serif;
                    font-weight: 500;
                }

                .alert-success {
                    background: #f0fdf4;
                    border-color: #86efac;
                    color: #15803d;
                }

                .alert-danger {
                    background: #fef2f2;
                    border-color: #fca5a5;
                    color: #dc2626;
                }

                .alert-info {
                    background: #eff6ff;
                    border-color: #93c5fd;
                    color: #1d4ed8;
                }

                /* Form elements */
                .fd-form-group {
                    margin-bottom: 20px;
                }

                .fd-label {
                    display: block;
                    font-size: 12px;
                    font-weight: 600;
                    color: #64748b;
                    margin-bottom: 7px;
                    text-transform: uppercase;
                    letter-spacing: .05em;
                }

                .fd-input {
                    width: 100%;
                    border: 1.5px solid #e2e8f0;
                    border-radius: 11px;
                    padding: 12px 14px;
                    font-size: 14px;
                    font-family: 'Inter', sans-serif;
                    color: #0f172a;
                    background: #f8fafc;
                    transition: border-color .2s, box-shadow .2s;
                    outline: none;
                }

                .fd-input:focus {
                    border-color: #4f46e5;
                    box-shadow: 0 0 0 3px rgba(79, 70, 229, .12);
                    background: #ffffff;
                }

                .fd-hint {
                    font-size: 11.5px;
                    color: #94a3b8;
                    margin-top: 5px;
                    display: flex;
                    align-items: center;
                    gap: 5px;
                }

                .fd-error {
                    font-size: 12px;
                    color: #ef4444;
                    margin-top: 4px;
                }

                /* Summary preview box */
                .fd-summary {
                    background: linear-gradient(135deg, #f8fafc 0%, #f0f9ff 100%);
                    border: 1.5px solid #e0f2fe;
                    border-radius: 14px;
                    padding: 18px 20px;
                    margin-bottom: 20px;
                }

                .fd-summary-title {
                    font-size: 12px;
                    font-weight: 700;
                    color: #4f46e5;
                    text-transform: uppercase;
                    letter-spacing: .07em;
                    margin-bottom: 14px;
                    display: flex;
                    align-items: center;
                    gap: 6px;
                }

                .fd-summary-row {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    padding: 8px 0;
                    border-bottom: 1px solid #e2e8f0;
                    font-size: 13px;
                }

                .fd-summary-row:last-child {
                    border-bottom: none;
                }

                .fd-summary-key {
                    color: #64748b;
                    font-weight: 500;
                }

                .fd-summary-val {
                    font-weight: 700;
                    color: #0f172a;
                }

                .fd-summary-val.green {
                    color: #10b981;
                    font-size: 15px;
                }

                /* Invest button */
                .fd-btn-invest {
                    width: 100%;
                    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
                    color: white;
                    border: none;
                    border-radius: 12px;
                    padding: 14px;
                    font-size: 15px;
                    font-weight: 700;
                    font-family: 'Inter', sans-serif;
                    cursor: pointer;
                    box-shadow: 0 6px 20px rgba(79, 70, 229, .3);
                    transition: transform .15s, box-shadow .15s, opacity .15s;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 8px;
                }

                .fd-btn-invest:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 10px 28px rgba(79, 70, 229, .4);
                }

                .fd-btn-invest:active {
                    transform: translateY(0);
                }

                /* ── My FDs Card ───────────────────────────────────────── */
                .fd-list-card {
                    background: #ffffff;
                    border: 1px solid #e2e8f0;
                    border-radius: 20px;
                    overflow: hidden;
                    box-shadow: 0 4px 24px rgba(0, 0, 0, .04);
                }

                .fd-list-header {
                    padding: 20px 24px;
                    border-bottom: 1px solid #f1f5f9;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                }

                .fd-list-title {
                    font-size: 16px;
                    font-weight: 700;
                    color: #0f172a;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }

                .fd-count-badge {
                    background: #ede9fe;
                    color: #7c3aed;
                    font-size: 11px;
                    font-weight: 700;
                    padding: 3px 10px;
                    border-radius: 100px;
                }

                /* FD table */
                .fd-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .fd-table th {
                    background: #f8fafc;
                    color: #94a3b8;
                    font-size: 11px;
                    font-weight: 600;
                    text-transform: uppercase;
                    letter-spacing: .06em;
                    padding: 12px 20px;
                    text-align: left;
                    border-bottom: 1px solid #f1f5f9;
                }

                .fd-table td {
                    padding: 16px 20px;
                    border-bottom: 1px solid #f8fafc;
                    font-size: 13px;
                    color: #1e293b;
                    vertical-align: middle;
                }

                .fd-table tr:last-child td {
                    border-bottom: none;
                }

                .fd-table tr:hover td {
                    background: #fafbff;
                }

                .fd-amt {
                    font-weight: 700;
                }

                .fd-matval {
                    font-weight: 800;
                    color: #10b981;
                    font-size: 14px;
                }

                .fd-rate-chip {
                    display: inline-flex;
                    align-items: center;
                    gap: 4px;
                    background: #ede9fe;
                    color: #7c3aed;
                    padding: 3px 10px;
                    border-radius: 100px;
                    font-size: 12px;
                    font-weight: 700;
                }

                .fd-status-chip {
                    display: inline-flex;
                    align-items: center;
                    gap: 5px;
                    padding: 4px 12px;
                    border-radius: 100px;
                    font-size: 11px;
                    font-weight: 700;
                    text-transform: uppercase;
                    letter-spacing: .05em;
                    background: #f0fdf4;
                    border: 1px solid #bbf7d0;
                    color: #15803d;
                }

                .fd-date {
                    color: #64748b;
                    font-size: 12.5px;
                }

                .fd-ref {
                    color: #94a3b8;
                    font-size: 12px;
                    font-family: monospace;
                }

                /* Empty state */
                .fd-empty {
                    padding: 56px 24px;
                    text-align: center;
                }

                .fd-empty-icon {
                    width: 72px;
                    height: 72px;
                    background: linear-gradient(135deg, #ede9fe, #e0f2fe);
                    border-radius: 20px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 16px;
                }

                .fd-empty-title {
                    font-size: 16px;
                    font-weight: 700;
                    color: #1e293b;
                    margin-bottom: 6px;
                }

                .fd-empty-desc {
                    font-size: 13px;
                    color: #94a3b8;
                }

                /* Info strip */
                .fd-info-strip {
                    display: grid;
                    grid-template-columns: repeat(3, 1fr);
                    gap: 12px;
                    margin-bottom: 24px;
                }

                .fd-info-chip {
                    background: white;
                    border: 1px solid #e2e8f0;
                    border-radius: 14px;
                    padding: 14px 18px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }

                .fd-info-chip-icon {
                    width: 38px;
                    height: 38px;
                    border-radius: 10px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    flex-shrink: 0;
                }

                .fd-info-chip-val {
                    font-size: 18px;
                    font-weight: 800;
                    color: #0f172a;
                    line-height: 1;
                }

                .fd-info-chip-lbl {
                    font-size: 11px;
                    color: #94a3b8;
                    font-weight: 500;
                    margin-top: 2px;
                }

                @media (max-width: 960px) {
                    .fd-grid {
                        grid-template-columns: 1fr;
                    }

                    .fd-info-strip {
                        grid-template-columns: repeat(2, 1fr);
                    }
                }
            </style>
        </asp:Content>

        <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

            <%-- Info strip --%>
                <div class="fd-info-strip">
                    <div class="fd-info-chip">
                        <div class="fd-info-chip-icon" style="background:#ede9fe;">
                            <iconify-icon icon="lucide:percent" style="font-size:20px; color:#7c3aed"></iconify-icon>
                        </div>
                        <div>
                            <div class="fd-info-chip-val">6.5%</div>
                            <div class="fd-info-chip-lbl">Interest Rate p.a.</div>
                        </div>
                    </div>
                    <div class="fd-info-chip">
                        <div class="fd-info-chip-icon" style="background:#f0fdf4;">
                            <iconify-icon icon="lucide:indian-rupee"
                                style="font-size:20px; color:#10b981"></iconify-icon>
                        </div>
                        <div>
                            <div class="fd-info-chip-val">&#8377;1,000</div>
                            <div class="fd-info-chip-lbl">Minimum Deposit</div>
                        </div>
                    </div>
                    <div class="fd-info-chip">
                        <div class="fd-info-chip-icon" style="background:#fef9c3;">
                            <iconify-icon icon="lucide:calendar" style="font-size:20px; color:#ca8a04"></iconify-icon>
                        </div>
                        <div>
                            <div class="fd-info-chip-val">6&ndash;60M</div>
                            <div class="fd-info-chip-lbl">Flexible Tenures</div>
                        </div>
                    </div>
                </div>

                <%-- Main 2-column grid --%>
                    <div class="fd-grid">

                        <%-- ── New FD Card ── --%>
                            <div class="fd-new-card">
                                <div class="fd-new-header">
                                    <div class="fd-new-header-icon">
                                        <iconify-icon icon="lucide:piggy-bank"
                                            style="font-size:22px; color:white"></iconify-icon>
                                    </div>
                                    <h5>Open Fixed Deposit</h5>
                                    <p>Earn guaranteed returns on your savings</p>
                                </div>
                                <div class="fd-new-body">

                                    <%-- Message panel — CssClass set by code-behind: alert alert-success / alert
                                        alert-danger --%>
                                        <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                                            <asp:Label ID="lblMessage" runat="server"></asp:Label>
                                        </asp:Panel>

                                        <%-- Principal Amount --%>
                                            <div class="fd-form-group">
                                                <label class="fd-label">Principal Amount (&#8377;)</label>
                                                <asp:TextBox ID="txtAmount" runat="server" CssClass="fd-input"
                                                    TextMode="Number" placeholder="e.g. 10,000"
                                                    OnTextChanged="CalculateMaturity" AutoPostBack="true"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvAmount" runat="server"
                                                    ControlToValidate="txtAmount" ErrorMessage="⚠ Amount is required"
                                                    CssClass="fd-error" Display="Dynamic" ValidationGroup="FD">
                                                </asp:RequiredFieldValidator>
                                                <div class="fd-hint"
                                                    style="font-size:11.5px;color:#94a3b8;margin-top:5px;">
                                                    <iconify-icon icon="lucide:info"
                                                        style="font-size:12px"></iconify-icon>
                                                    Minimum &#8377;1,000 &middot; Interest: 6.5% p.a.
                                                </div>
                                            </div>

                                            <%-- Tenure --%>
                                                <div class="fd-form-group">
                                                    <label class="fd-label">Tenure</label>
                                                    <asp:DropDownList ID="ddlTenure" runat="server" CssClass="fd-input"
                                                        OnSelectedIndexChanged="CalculateMaturity" AutoPostBack="true">
                                                        <asp:ListItem Value="6">6 Months</asp:ListItem>
                                                        <asp:ListItem Value="12" Selected="True">12 Months (1 Year)
                                                        </asp:ListItem>
                                                        <asp:ListItem Value="24">24 Months (2 Years)</asp:ListItem>
                                                        <asp:ListItem Value="36">36 Months (3 Years)</asp:ListItem>
                                                        <asp:ListItem Value="60">60 Months (5 Years)</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>

                                                <%-- Summary Preview --%>
                                                    <div class="fd-summary">
                                                        <div class="fd-summary-title">
                                                            <iconify-icon icon="lucide:bar-chart-2"
                                                                style="font-size:13px"></iconify-icon>
                                                            Projected Returns
                                                        </div>
                                                        <div class="fd-summary-row">
                                                            <span class="fd-summary-key">Interest Rate</span>
                                                            <asp:Label ID="lblInterestRate" runat="server" Text="6.5%"
                                                                Font-Bold="true" CssClass="fd-summary-val"></asp:Label>
                                                        </div>
                                                        <div class="fd-summary-row">
                                                            <span class="fd-summary-key">Maturity Amount</span>
                                                            <asp:Label ID="lblMaturityAmount" runat="server"
                                                                Text="&#8377;0.00" CssClass="fd-summary-val green">
                                                            </asp:Label>
                                                        </div>
                                                        <div class="fd-summary-row">
                                                            <span class="fd-summary-key">Maturity Date</span>
                                                            <asp:Label ID="lblMaturityDate" runat="server" Text="—"
                                                                CssClass="fd-summary-val"></asp:Label>
                                                        </div>
                                                    </div>

                                                    <%-- Invest Button --%>
                                                        <asp:Button ID="btnInvest" runat="server"
                                                            CssClass="fd-btn-invest" OnClick="btnInvest_Click"
                                                            ValidationGroup="FD" Text="Invest Now" />

                                </div>
                            </div>

                            <%-- ── My FDs Card ── --%>
                                <div class="fd-list-card">
                                    <div class="fd-list-header">
                                        <div class="fd-list-title">
                                            <iconify-icon icon="lucide:layers"
                                                style="font-size:18px; color:#7c3aed"></iconify-icon>
                                            My Fixed Deposits
                                        </div>
                                        <span class="fd-count-badge">Active</span>
                                    </div>

                                    <asp:GridView ID="gvFDs" runat="server" AutoGenerateColumns="False"
                                        CssClass="fd-table" GridLines="None" Width="100%">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Ref #">
                                                <ItemTemplate>
                                                    <span class="fd-ref">#<%# Eval("FDID") %></span>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Principal">
                                                <ItemTemplate>
                                                    <span class="fd-amt">&#8377;<%# string.Format("{0:N2}",
                                                            Eval("PrincipalAmount")) %></span>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Rate">
                                                <ItemTemplate>
                                                    <span class="fd-rate-chip">
                                                        <iconify-icon icon="lucide:trending-up"
                                                            style="font-size:11px"></iconify-icon>
                                                        <%# Eval("InterestRate") %>%
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:BoundField DataField="TenureMonths" HeaderText="Tenure"
                                                DataFormatString="{0} M" />

                                            <asp:TemplateField HeaderText="Maturity Value">
                                                <ItemTemplate>
                                                    <span class="fd-matval">&#8377;<%# string.Format("{0:N2}",
                                                            Eval("MaturityAmount")) %></span>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Matures On">
                                                <ItemTemplate>
                                                    <span class="fd-date">
                                                        <%# string.Format("{0:dd MMM yyyy}", Eval("MaturityDate")) %>
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Status">
                                                <ItemTemplate>
                                                    <span class="fd-status-chip">
                                                        &#10003; <%# Eval("Status") %>
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <div class="fd-empty">
                                                <div class="fd-empty-icon">
                                                    <iconify-icon icon="lucide:piggy-bank"
                                                        style="font-size:36px; color:#7c3aed"></iconify-icon>
                                                </div>
                                                <div class="fd-empty-title">No Fixed Deposits Yet</div>
                                                <div class="fd-empty-desc">Open your first FD using the form on the left
                                                    to start earning guaranteed returns.</div>
                                            </div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>

                    </div><%-- /fd-grid --%>

        </asp:Content>