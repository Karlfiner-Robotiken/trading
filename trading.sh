#!/data/data/com.termux/files/usr/bin/bash

# =============================================
# NovaTrade - Termux Install & Run Script
#              (Port 5000)
# =============================================

# 1. Create working directory
mkdir -p ~/trading
cd ~/trading || exit

# 2. Write the HTML content to index.html
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>NovaTrade - Trading Platform</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz@14..32&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        /* ========== RESET & BASE ========== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Inter', sans-serif;
            background: #0b0e14;
            color: #e8edf5;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }
        ::-webkit-scrollbar {
            width: 4px;
        }
        ::-webkit-scrollbar-track {
            background: #141a24;
        }
        ::-webkit-scrollbar-thumb {
            background: #2e7dff;
            border-radius: 4px;
        }

        /* ========== SIDEBAR ========== */
        .sidebar {
            width: 220px;
            background: #0f141e;
            border-right: 1px solid #1e2735;
            display: flex;
            flex-direction: column;
            padding: 20px 16px;
            flex-shrink: 0;
            height: 100vh;
            position: sticky;
            top: 0;
            overflow-y: auto;
        }
        .sidebar .logo {
            font-size: 22px;
            font-weight: 700;
            color: #2e7dff;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 30px;
            letter-spacing: -0.5px;
        }
        .sidebar .logo i {
            font-size: 26px;
        }
        .sidebar .logo span {
            color: #e8edf5;
        }
        .sidebar nav {
            display: flex;
            flex-direction: column;
            gap: 4px;
            flex: 1;
        }
        .sidebar nav a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            border-radius: 10px;
            color: #8a94a6;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: 0.2s;
            cursor: pointer;
        }
        .sidebar nav a i {
            width: 20px;
            font-size: 16px;
            text-align: center;
        }
        .sidebar nav a:hover {
            background: #1a2332;
            color: #e8edf5;
        }
        .sidebar nav a.active {
            background: #1a2a4a;
            color: #2e7dff;
            box-shadow: inset 3px 0 0 #2e7dff;
        }
        .sidebar .user-card {
            margin-top: auto;
            padding: 14px 12px;
            background: #141c2a;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 12px;
            border: 1px solid #1e2735;
        }
        .sidebar .user-card .avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: linear-gradient(135deg, #2e7dff, #6a4cff);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 16px;
            color: #fff;
        }
        .sidebar .user-card .info {
            flex: 1;
        }
        .sidebar .user-card .info .name {
            font-size: 13px;
            font-weight: 600;
            color: #e8edf5;
        }
        .sidebar .user-card .info .role {
            font-size: 11px;
            color: #8a94a6;
        }

        /* ========== MAIN CONTENT ========== */
        .main {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            background: #0b0e14;
        }
        .main .topbar {
            background: #0f141e;
            padding: 14px 28px;
            border-bottom: 1px solid #1e2735;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-shrink: 0;
        }
        .main .topbar .page-title {
            font-size: 18px;
            font-weight: 600;
        }
        .main .topbar .page-title small {
            font-weight: 400;
            color: #8a94a6;
            font-size: 13px;
            margin-left: 8px;
        }
        .main .topbar .actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        .main .topbar .actions .balance-badge {
            background: #141c2a;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            color: #2e7dff;
            border: 1px solid #1e2735;
        }
        .main .topbar .actions .balance-badge i {
            margin-right: 6px;
        }
        .main .topbar .actions .btn-icon {
            background: #141c2a;
            border: 1px solid #1e2735;
            color: #8a94a6;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: 0.2s;
        }
        .main .topbar .actions .btn-icon:hover {
            background: #1a2332;
            color: #e8edf5;
        }

        .main .content {
            flex: 1;
            overflow-y: auto;
            padding: 24px 28px 40px;
        }

        /* ========== PAGES ========== */
        .page {
            display: none;
            animation: fadeUp 0.3s ease;
        }
        .page.active {
            display: block;
        }
        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(12px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ========== CARDS ========== */
        .card {
            background: #0f141e;
            border: 1px solid #1e2735;
            border-radius: 16px;
            padding: 20px 24px;
            margin-bottom: 20px;
        }
        .card .card-title {
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 14px;
            color: #e8edf5;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .card .card-title i {
            color: #2e7dff;
        }

        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .grid-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
        }
        .grid-4 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr;
            gap: 20px;
        }

        /* ========== STAT CARDS ========== */
        .stat-card {
            background: #0f141e;
            border: 1px solid #1e2735;
            border-radius: 14px;
            padding: 18px 20px;
        }
        .stat-card .label {
            font-size: 12px;
            color: #8a94a6;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 500;
        }
        .stat-card .value {
            font-size: 26px;
            font-weight: 700;
            margin-top: 4px;
        }
        .stat-card .change {
            font-size: 12px;
            margin-top: 6px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 2px 10px;
            border-radius: 12px;
            background: #14221e;
            color: #2ecc71;
        }
        .stat-card .change.down {
            background: #2a1a1a;
            color: #e74c3c;
        }
        .stat-card .change i {
            font-size: 10px;
        }

        /* ========== CHARTS ========== */
        .chart-container {
            position: relative;
            height: 280px;
            width: 100%;
        }
        .chart-container canvas {
            width: 100% !important;
            height: 100% !important;
        }

        /* ========== TABLE ========== */
        .table-wrap {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        table th {
            text-align: left;
            padding: 10px 8px;
            color: #8a94a6;
            font-weight: 500;
            border-bottom: 1px solid #1e2735;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        table td {
            padding: 10px 8px;
            border-bottom: 1px solid #141c2a;
        }
        table tr:hover td {
            background: #0d121c;
        }
        .badge {
            padding: 3px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            display: inline-block;
        }
        .badge.success {
            background: #14221e;
            color: #2ecc71;
        }
        .badge.danger {
            background: #2a1a1a;
            color: #e74c3c;
        }
        .badge.warning {
            background: #2a2416;
            color: #f1c40f;
        }
        .badge.info {
            background: #141f2a;
            color: #3498db;
        }
        .badge.green {
            background: #14221e;
            color: #2ecc71;
        }
        .badge.red {
            background: #2a1a1a;
            color: #e74c3c;
        }

        /* ========== FORMS ========== */
        input,
        select,
        textarea {
            background: #0b0e14;
            border: 1px solid #1e2735;
            border-radius: 10px;
            padding: 10px 14px;
            color: #e8edf5;
            font-size: 14px;
            width: 100%;
            font-family: inherit;
            transition: 0.2s;
        }
        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #2e7dff;
            box-shadow: 0 0 0 3px rgba(46, 125, 255, 0.15);
        }
        input::placeholder {
            color: #5a6478;
        }
        select option {
            background: #0b0e14;
        }
        .form-group {
            margin-bottom: 14px;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 5px;
            color: #aab2c4;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .btn {
            padding: 10px 22px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-family: inherit;
        }
        .btn-primary {
            background: #2e7dff;
            color: #fff;
        }
        .btn-primary:hover {
            background: #1a6aff;
            transform: translateY(-1px);
            box-shadow: 0 4px 20px rgba(46, 125, 255, 0.3);
        }
        .btn-success {
            background: #2ecc71;
            color: #fff;
        }
        .btn-success:hover {
            background: #27ae60;
        }
        .btn-danger {
            background: #e74c3c;
            color: #fff;
        }
        .btn-danger:hover {
            background: #c0392b;
        }
        .btn-outline {
            background: transparent;
            border: 1px solid #1e2735;
            color: #8a94a6;
        }
        .btn-outline:hover {
            background: #1a2332;
            color: #e8edf5;
        }
        .btn-sm {
            padding: 6px 14px;
            font-size: 12px;
        }
        .btn-block {
            width: 100%;
            justify-content: center;
        }

        /* ========== BOT CARDS ========== */
        .bot-card {
            background: #0f141e;
            border: 1px solid #1e2735;
            border-radius: 14px;
            padding: 18px 20px;
            transition: 0.2s;
        }
        .bot-card:hover {
            border-color: #2e7dff;
        }
        .bot-card .bot-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .bot-card .bot-name {
            font-weight: 600;
            font-size: 15px;
        }
        .bot-card .bot-status {
            font-size: 11px;
            padding: 3px 12px;
            border-radius: 20px;
        }
        .bot-card .bot-status.running {
            background: #14221e;
            color: #2ecc71;
        }
        .bot-card .bot-status.stopped {
            background: #1a1a1a;
            color: #8a94a6;
        }
        .bot-card .bot-details {
            margin-top: 10px;
            font-size: 13px;
            color: #8a94a6;
        }
        .bot-card .bot-details span {
            margin-right: 16px;
        }
        .bot-card .bot-actions {
            margin-top: 14px;
            display: flex;
            gap: 8px;
        }

        /* ========== PAYMENT ========== */
        .payment-method {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 12px 16px;
            background: #0b0e14;
            border: 1px solid #1e2735;
            border-radius: 10px;
            cursor: pointer;
            transition: 0.2s;
        }
        .payment-method:hover {
            border-color: #2e7dff;
        }
        .payment-method.selected {
            border-color: #2e7dff;
            background: #0f1a2e;
        }
        .payment-method i {
            font-size: 22px;
            color: #2e7dff;
        }
        .payment-method .pm-name {
            font-weight: 500;
        }
        .payment-method .pm-desc {
            font-size: 12px;
            color: #8a94a6;
        }

        /* ========== TOGGLE ========== */
        .toggle {
            width: 42px;
            height: 24px;
            background: #1e2735;
            border-radius: 12px;
            cursor: pointer;
            position: relative;
            transition: 0.3s;
            flex-shrink: 0;
        }
        .toggle.active {
            background: #2e7dff;
        }
        .toggle .toggle-knob {
            width: 18px;
            height: 18px;
            background: #e8edf5;
            border-radius: 50%;
            position: absolute;
            top: 3px;
            left: 3px;
            transition: 0.3s;
        }
        .toggle.active .toggle-knob {
            left: 21px;
            background: #fff;
        }

        /* ========== UTILITY ========== */
        .flex {
            display: flex;
        }
        .flex-center {
            align-items: center;
        }
        .flex-between {
            justify-content: space-between;
        }
        .gap-8 {
            gap: 8px;
        }
        .gap-12 {
            gap: 12px;
        }
        .gap-16 {
            gap: 16px;
        }
        .gap-20 {
            gap: 20px;
        }
        .mt-8 {
            margin-top: 8px;
        }
        .mt-12 {
            margin-top: 12px;
        }
        .mt-16 {
            margin-top: 16px;
        }
        .mt-20 {
            margin-top: 20px;
        }
        .mb-8 {
            margin-bottom: 8px;
        }
        .mb-12 {
            margin-bottom: 12px;
        }
        .mb-16 {
            margin-bottom: 16px;
        }
        .text-center {
            text-align: center;
        }
        .text-muted {
            color: #8a94a6;
        }
        .text-success {
            color: #2ecc71;
        }
        .text-danger {
            color: #e74c3c;
        }
        .text-warning {
            color: #f1c40f;
        }
        .text-primary {
            color: #2e7dff;
        }
        .w-full {
            width: 100%;
        }

        /* ========== RESPONSIVE ========== */
        @media (max-width: 1024px) {
            .grid-4 {
                grid-template-columns: 1fr 1fr;
            }
            .grid-3 {
                grid-template-columns: 1fr 1fr;
            }
        }
        @media (max-width: 768px) {
            .sidebar {
                width: 60px;
                padding: 16px 10px;
            }
            .sidebar .logo span,
            .sidebar nav a span,
            .sidebar .user-card .info {
                display: none;
            }
            .sidebar .logo {
                justify-content: center;
                font-size: 20px;
            }
            .sidebar nav a {
                justify-content: center;
                padding: 12px;
            }
            .sidebar nav a i {
                font-size: 18px;
            }
            .sidebar .user-card {
                justify-content: center;
                padding: 10px;
            }
            .sidebar .user-card .avatar {
                width: 32px;
                height: 32px;
                font-size: 12px;
            }
            .main .content {
                padding: 16px;
            }
            .grid-2,
            .grid-3,
            .grid-4 {
                grid-template-columns: 1fr;
            }
            .form-row {
                grid-template-columns: 1fr;
            }
            .main .topbar {
                padding: 12px 16px;
                flex-wrap: wrap;
                gap: 8px;
            }
            .main .topbar .page-title {
                font-size: 15px;
            }
            .main .topbar .actions .balance-badge {
                font-size: 12px;
                padding: 4px 12px;
            }
        }
        @media (max-width: 480px) {
            .sidebar {
                width: 50px;
                padding: 12px 6px;
            }
            .sidebar nav a {
                padding: 10px;
            }
            .main .content {
                padding: 12px;
            }
            .card {
                padding: 14px 16px;
            }
            .stat-card .value {
                font-size: 20px;
            }
        }

        /* ========== TOAST ========== */
        .toast-container {
            position: fixed;
            bottom: 24px;
            right: 24px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 8px;
            max-width: 380px;
            width: 100%;
        }
        .toast {
            background: #0f141e;
            border: 1px solid #1e2735;
            border-radius: 12px;
            padding: 14px 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
            animation: slideUp 0.3s ease;
        }
        .toast.success {
            border-left: 4px solid #2ecc71;
        }
        .toast.error {
            border-left: 4px solid #e74c3c;
        }
        .toast.info {
            border-left: 4px solid #2e7dff;
        }
        .toast .toast-icon {
            font-size: 20px;
        }
        .toast .toast-msg {
            flex: 1;
            font-size: 13px;
        }
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ========== EMPTY STATE ========== */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #5a6478;
        }
        .empty-state i {
            font-size: 48px;
            margin-bottom: 12px;
            opacity: 0.4;
        }
        .empty-state p {
            font-size: 14px;
        }

        /* ========== MISC ========== */
        .divider {
            border: none;
            border-top: 1px solid #1e2735;
            margin: 16px 0;
        }
        .chip {
            display: inline-block;
            padding: 2px 12px;
            border-radius: 12px;
            font-size: 11px;
            background: #141c2a;
            color: #8a94a6;
        }
        .highlight {
            color: #2e7dff;
        }
    </style>
</head>
<body>

    <!-- ==================== SIDEBAR ==================== -->
    <aside class="sidebar" id="sidebar">
        <div class="logo">
            <i class="fas fa-chart-line"></i>
            <span>Nova<span>Trade</span></span>
        </div>
        <nav>
            <a class="active" data-page="dashboard"><i class="fas fa-th-large"></i><span>Dashboard</span></a>
            <a data-page="trading"><i class="fas fa-arrow-right-arrow-left"></i><span>Trading</span></a>
            <a data-page="bots"><i class="fas fa-robot"></i><span>Bots</span></a>
            <a data-page="strategies"><i class="fas fa-code-branch"></i><span>Strategies</span></a>
            <a data-page="payments"><i class="fas fa-credit-card"></i><span>Payments</span></a>
            <a data-page="settings"><i class="fas fa-sliders-h"></i><span>Settings</span></a>
            <a data-page="data"><i class="fas fa-database"></i><span>User Data</span></a>
        </nav>
        <div class="user-card">
            <div class="avatar" id="avatarLetter">JD</div>
            <div class="info">
                <div class="name" id="userNameDisplay">John Doe</div>
                <div class="role">Trader</div>
            </div>
        </div>
    </aside>

    <!-- ==================== MAIN ==================== -->
    <div class="main">

        <!-- Topbar -->
        <div class="topbar">
            <div class="page-title" id="pageTitle">Dashboard <small>overview</small></div>
            <div class="actions">
                <div class="balance-badge"><i class="fas fa-wallet"></i> $<span id="headerBalance">10,000.00</span></div>
                <button class="btn-icon" title="Notifications"><i class="fas fa-bell"></i></button>
                <button class="btn-icon" title="Refresh" onclick="refreshData()"><i class="fas fa-sync-alt"></i></button>
            </div>
        </div>

        <!-- Content -->
        <div class="content">

            <!-- ===== DASHBOARD ===== -->
            <div class="page active" id="page-dashboard">
                <div class="grid-4" id="statsGrid">
                    <div class="stat-card"><div class="label">Balance</div><div class="value" id="dashBalance">$10,000.00</div><div class="change"><i class="fas fa-arrow-up"></i> +2.4%</div></div>
                    <div class="stat-card"><div class="label">Profit / Loss</div><div class="value" id="dashPnL">+$342.50</div><div class="change"><i class="fas fa-arrow-up"></i> +3.5%</div></div>
                    <div class="stat-card"><div class="label">Trades</div><div class="value" id="dashTrades">47</div><div class="change">Win Rate 68%</div></div>
                    <div class="stat-card"><div class="label">Active Bots</div><div class="value" id="dashBots">2</div><div class="change"><i class="fas fa-circle" style="color:#2ecc71;font-size:8px;"></i> Running</div></div>
                </div>

                <div class="card">
                    <div class="card-title"><i class="fas fa-chart-area"></i> Performance Chart</div>
                    <div class="chart-container"><canvas id="dashboardChart"></canvas></div>
                </div>

                <div class="grid-2">
                    <div class="card">
                        <div class="card-title"><i class="fas fa-clock-rotate-left"></i> Recent Trades</div>
                        <div class="table-wrap">
                            <table>
                                <thead><tr><th>Asset</th><th>Type</th><th>Amount</th><th>Result</th><th>Time</th></tr></thead>
                                <tbody id="recentTradesBody">
                                    <tr><td colspan="5" class="text-muted text-center">No recent trades</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-title"><i class="fas fa-robot"></i> Bot Activity</div>
                        <div id="botActivityList">
                            <div class="text-muted text-center" style="padding:20px 0;">No active bots</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== TRADING ===== -->
            <div class="page" id="page-trading">
                <div class="grid-2">
                    <div class="card">
                        <div class="card-title"><i class="fas fa-chart-simple"></i> Price Chart <span class="chip" id="tradingAssetLabel">BTC/USD</span></div>
                        <div class="chart-container" style="height:320px;"><canvas id="tradingChart"></canvas></div>
                        <div class="flex flex-between mt-12">
                            <div><span class="text-muted">Current Price</span> <strong id="tradingPrice">$42,350.00</strong></div>
                            <div><span class="text-muted">Change</span> <span id="tradingChange" class="text-success">+1.23%</span></div>
                        </div>
                    </div>
                    <div>
                        <div class="card">
                            <div class="card-title"><i class="fas fa-hand-pointer"></i> Quick Trade</div>
                            <div class="form-group">
                                <label>Asset</label>
                                <select id="tradeAsset"><option value="BTC/USD">BTC/USD</option><option value="ETH/USD">ETH/USD</option><option value="SOL/USD">SOL/USD</option></select>
                            </div>
                            <div class="form-row">
                                <div class="form-group"><label>Amount ($)</label><input type="number" id="tradeAmount" value="100" min="1" /></div>
                                <div class="form-group"><label>Direction</label>
                                    <select id="tradeDirection"><option value="buy">BUY</option><option value="sell">SELL</option></select>
                                </div>
                            </div>
                            <button class="btn btn-primary btn-block" onclick="executeTrade()"><i class="fas fa-bolt"></i> Execute Trade</button>
                        </div>
                        <div class="card">
                            <div class="card-title"><i class="fas fa-clock-rotate-left"></i> Trade History</div>
                            <div class="table-wrap" style="max-height:180px;overflow-y:auto;">
                                <table>
                                    <thead><tr><th>Asset</th><th>Type</th><th>Amount</th><th>P/L</th></tr></thead>
                                    <tbody id="tradeHistoryBody">
                                        <tr><td colspan="4" class="text-muted text-center">No trades yet</td></tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== BOTS ===== -->
            <div class="page" id="page-bots">
                <div class="flex flex-between mb-16">
                    <div><span class="text-muted">Create and manage your trading bots</span></div>
                    <button class="btn btn-primary" onclick="openBotModal()"><i class="fas fa-plus"></i> New Bot</button>
                </div>
                <div class="grid-2" id="botsList">
                    <div class="empty-state" style="grid-column:1/-1;"><i class="fas fa-robot"></i><p>No bots created yet. Click "New Bot" to get started.</p></div>
                </div>
            </div>

            <!-- ===== STRATEGIES ===== -->
            <div class="page" id="page-strategies">
                <div class="card">
                    <div class="card-title"><i class="fas fa-code-branch"></i> Available Strategies</div>
                    <div class="grid-3" id="strategiesList">
                        <div class="bot-card"><div class="bot-header"><div class="bot-name">RSI Strategy</div><span class="badge info">Built-in</span></div><div class="bot-details">Buy when RSI &lt; 30, Sell when RSI &gt; 70</div></div>
                        <div class="bot-card"><div class="bot-header"><div class="bot-name">MACD Strategy</div><span class="badge info">Built-in</span></div><div class="bot-details">Buy on MACD crossover above signal</div></div>
                        <div class="bot-card"><div class="bot-header"><div class="bot-name">SMA Crossover</div><span class="badge info">Built-in</span></div><div class="bot-details">Buy when 50 SMA crosses above 200 SMA</div></div>
                        <div class="bot-card"><div class="bot-header"><div class="bot-name">Bollinger Bands</div><span class="badge info">Built-in</span></div><div class="bot-details">Buy at lower band, Sell at upper band</div></div>
                        <div class="bot-card"><div class="bot-header"><div class="bot-name">Grid Strategy</div><span class="badge warning">Custom</span></div><div class="bot-details">Place buy/sell orders at grid levels</div></div>
                        <div class="bot-card"><div class="bot-header"><div class="bot-name">Scalper</div><span class="badge warning">Custom</span></div><div class="bot-details">Fast trades on small price movements</div></div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-title"><i class="fas fa-pen-to-square"></i> Create Custom Strategy</div>
                    <div class="form-row">
                        <div class="form-group"><label>Strategy Name</label><input id="strategyName" placeholder="My Strategy" /></div>
                        <div class="form-group"><label>Type</label><select id="strategyType"><option value="rsi">RSI</option><option value="macd">MACD</option><option value="sma">SMA Crossover</option></select></div>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label>Parameter 1</label><input id="strategyParam1" placeholder="e.g. 14" value="14" /></div>
                        <div class="form-group"><label>Parameter 2</label><input id="strategyParam2" placeholder="e.g. 30" value="30" /></div>
                    </div>
                    <button class="btn btn-success" onclick="saveCustomStrategy()"><i class="fas fa-save"></i> Save Strategy</button>
                </div>
            </div>

            <!-- ===== PAYMENTS ===== -->
            <div class="page" id="page-payments">
                <div class="grid-2">
                    <div class="card">
                        <div class="card-title"><i class="fas fa-arrow-up"></i> Deposit</div>
                        <div class="form-group"><label>Amount ($)</label><input id="depositAmount" type="number" placeholder="100" min="1" value="100" /></div>
                        <div class="form-group"><label>Payment Method</label>
                            <div class="flex gap-8" style="flex-wrap:wrap;">
                                <div class="payment-method selected" data-method="bank"><i class="fas fa-university"></i><div><div class="pm-name">Bank Transfer</div><div class="pm-desc">1-2 business days</div></div></div>
                                <div class="payment-method" data-method="card"><i class="fas fa-credit-card"></i><div><div class="pm-name">Credit Card</div><div class="pm-desc">Instant</div></div></div>
                                <div class="payment-method" data-method="crypto"><i class="fab fa-bitcoin"></i><div><div class="pm-name">Cryptocurrency</div><div class="pm-desc">~10 min</div></div></div>
                            </div>
                        </div>
                        <button class="btn btn-success btn-block" onclick="depositFunds()"><i class="fas fa-arrow-up"></i> Deposit Now</button>
                    </div>
                    <div class="card">
                        <div class="card-title"><i class="fas fa-arrow-down"></i> Withdraw</div>
                        <div class="form-group"><label>Amount ($)</label><input id="withdrawAmount" type="number" placeholder="50" min="1" value="50" /></div>
                        <div class="form-group"><label>Withdrawal Method</label>
                            <select><option>Bank Transfer</option><option>Credit Card</option><option>Cryptocurrency</option></select>
                        </div>
                        <button class="btn btn-danger btn-block" onclick="withdrawFunds()"><i class="fas fa-arrow-down"></i> Withdraw</button>
                    </div>
                </div>
                <div class="card">
                    <div class="card-title"><i class="fas fa-list"></i> Transaction History</div>
                    <div class="table-wrap">
                        <table>
                            <thead><tr><th>Type</th><th>Amount</th><th>Method</th><th>Status</th><th>Date</th></tr></thead>
                            <tbody id="transactionHistoryBody">
                                <tr><td colspan="5" class="text-muted text-center">No transactions yet</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- ===== SETTINGS ===== -->
            <div class="page" id="page-settings">
                <div class="grid-2">
                    <div class="card">
                        <div class="card-title"><i class="fas fa-user"></i> Profile</div>
                        <div class="form-group"><label>Full Name</label><input id="settingsName" value="John Doe" /></div>
                        <div class="form-group"><label>Email</label><input id="settingsEmail" value="john@trader.com" /></div>
                        <div class="form-group"><label>Username</label><input id="settingsUsername" value="johndoe" /></div>
                        <button class="btn btn-primary" onclick="saveProfile()"><i class="fas fa-save"></i> Save Profile</button>
                    </div>
                    <div class="card">
                        <div class="card-title"><i class="fas fa-sliders-h"></i> Preferences</div>
                        <div class="flex flex-between" style="padding:8px 0;border-bottom:1px solid #1e2735;">
                            <span>Dark Mode</span>
                            <div class="toggle active" onclick="this.classList.toggle('active')"><div class="toggle-knob"></div></div>
                        </div>
                        <div class="flex flex-between" style="padding:8px 0;border-bottom:1px solid #1e2735;">
                            <span>Email Notifications</span>
                            <div class="toggle active" onclick="this.classList.toggle('active')"><div class="toggle-knob"></div></div>
                        </div>
                        <div class="flex flex-between" style="padding:8px 0;border-bottom:1px solid #1e2735;">
                            <span>Trade Confirmations</span>
                            <div class="toggle" onclick="this.classList.toggle('active')"><div class="toggle-knob"></div></div>
                        </div>
                        <div class="flex flex-between" style="padding:8px 0;">
                            <span>Auto-Trading</span>
                            <div class="toggle" onclick="this.classList.toggle('active')"><div class="toggle-knob"></div></div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-title"><i class="fas fa-shield-alt"></i> Security</div>
                    <div class="form-row">
                        <div class="form-group"><label>Current Password</label><input type="password" placeholder="••••••••" /></div>
                        <div class="form-group"><label>New Password</label><input type="password" placeholder="••••••••" /></div>
                    </div>
                    <button class="btn btn-outline"><i class="fas fa-key"></i> Change Password</button>
                    <button class="btn btn-danger" style="margin-left:8px;"><i class="fas fa-trash"></i> Delete Account</button>
                </div>
            </div>

            <!-- ===== USER DATA ===== -->
            <div class="page" id="page-data">
                <div class="grid-2">
                    <div class="card">
                        <div class="card-title"><i class="fas fa-user-circle"></i> User Profile</div>
                        <p><strong>Name:</strong> <span id="dataName">John Doe</span></p>
                        <p><strong>Email:</strong> <span id="dataEmail">john@trader.com</span></p>
                        <p><strong>Username:</strong> <span id="dataUsername">johndoe</span></p>
                        <p><strong>Member Since:</strong> <span id="dataMemberSince">Jan 2025</span></p>
                        <p><strong>Total Trades:</strong> <span id="dataTotalTrades">47</span></p>
                        <p><strong>Win Rate:</strong> <span id="dataWinRate">68%</span></p>
                        <p><strong>Balance:</strong> $<span id="dataBalance">10,000.00</span></p>
                    </div>
                    <div class="card">
                        <div class="card-title"><i class="fas fa-database"></i> Data Management</div>
                        <button class="btn btn-outline btn-block" onclick="exportData()"><i class="fas fa-download"></i> Export All Data (JSON)</button>
                        <button class="btn btn-outline btn-block mt-8" onclick="importData()"><i class="fas fa-upload"></i> Import Data</button>
                        <button class="btn btn-danger btn-block mt-8" onclick="resetAllData()"><i class="fas fa-trash"></i> Reset All Data</button>
                        <p class="text-muted" style="font-size:12px;margin-top:12px;">⚠️ This will delete all your trading data, bots, and settings.</p>
                    </div>
                </div>
                <div class="card">
                    <div class="card-title"><i class="fas fa-chart-bar"></i> Full Trade History</div>
                    <div class="table-wrap" style="max-height:300px;overflow-y:auto;">
                        <table>
                            <thead><tr><th>ID</th><th>Asset</th><th>Type</th><th>Amount</th><th>Price</th><th>P/L</th><th>Date</th></tr></thead>
                            <tbody id="fullTradeHistoryBody">
                                <tr><td colspan="7" class="text-muted text-center">No trades recorded</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div><!-- /content -->
    </div><!-- /main -->

    <!-- ==================== BOT MODAL ==================== -->
    <div id="botModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.7);z-index:9998;align-items:center;justify-content:center;backdrop-filter:blur(4px);">
        <div style="background:#0f141e;border:1px solid #1e2735;border-radius:20px;padding:28px;max-width:480px;width:90%;max-height:90vh;overflow-y:auto;">
            <div class="flex flex-between" style="margin-bottom:16px;">
                <h3 style="font-weight:600;"><i class="fas fa-robot" style="color:#2e7dff;"></i> Create New Bot</h3>
                <button onclick="closeBotModal()" style="background:none;border:none;color:#8a94a6;font-size:20px;cursor:pointer;">&times;</button>
            </div>
            <div class="form-group"><label>Bot Name</label><input id="botName" placeholder="My Bot" /></div>
            <div class="form-group"><label>Strategy</label>
                <select id="botStrategy">
                    <option value="rsi">RSI Strategy</option>
                    <option value="macd">MACD Strategy</option>
                    <option value="sma">SMA Crossover</option>
                    <option value="bollinger">Bollinger Bands</option>
                    <option value="grid">Grid Strategy</option>
                    <option value="scalper">Scalper</option>
                </select>
            </div>
            <div class="form-group"><label>Asset</label>
                <select id="botAsset"><option value="BTC/USD">BTC/USD</option><option value="ETH/USD">ETH/USD</option><option value="SOL/USD">SOL/USD</option></select>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Trade Amount ($)</label><input id="botAmount" type="number" value="50" min="1" /></div>
                <div class="form-group"><label>Interval (seconds)</label><input id="botInterval" type="number" value="30" min="5" /></div>
            </div>
            <div class="flex gap-12 mt-12">
                <button class="btn btn-primary" onclick="createBot()"><i class="fas fa-check"></i> Create</button>
                <button class="btn btn-outline" onclick="closeBotModal()">Cancel</button>
            </div>
        </div>
    </div>

    <!-- ==================== TOAST CONTAINER ==================== -->
    <div class="toast-container" id="toastContainer"></div>

    <!-- ==================== SCRIPTS ==================== -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js">
    </script>
    <script>
        // ================================================================
        //  STATE
        // ================================================================
        const state = {
            balance: 10000,
            trades: [],
            bots: [],
            transactions: [],
            settings: {
                name: 'John Doe',
                email: 'john@trader.com',
                username: 'johndoe',
                memberSince: 'Jan 2025'
            },
            customStrategies: [],
            botIdCounter: 1,
            tradeIdCounter: 1,
            txIdCounter: 1,
            priceHistory: [],
            currentPrice: 42350,
            priceTrend: 0,
            botIntervals: {},
        };

        // ================================================================
        //  INIT
        // ================================================================
        document.addEventListener('DOMContentLoaded', () => {
            loadState();
            initNavigation();
            initPaymentMethods();
            initTradingChart();
            initDashboardChart();
            updateUI();
            startPriceSimulation();
            updateClock();
            setInterval(updateClock, 1000);
            // Auto-save every 30s
            setInterval(saveState, 30000);
            // Render bots on load
            renderBots();
            renderRecentTrades();
            renderTradeHistory();
            renderTransactions();
            renderFullTradeHistory();
            updateBotActivity();
        });

        // ================================================================
        //  PERSISTENCE
        // ================================================================
        function saveState() {
            try {
                const data = {
                    balance: state.balance,
                    trades: state.trades,
                    bots: state.bots,
                    transactions: state.transactions,
                    settings: state.settings,
                    customStrategies: state.customStrategies,
                    botIdCounter: state.botIdCounter,
                    tradeIdCounter: state.tradeIdCounter,
                    txIdCounter: state.txIdCounter,
                    priceHistory: state.priceHistory,
                    currentPrice: state.currentPrice,
                };
                localStorage.setItem('novatrade_data', JSON.stringify(data));
            } catch (e) { /* ignore */ }
        }

        function loadState() {
            try {
                const raw = localStorage.getItem('novatrade_data');
                if (!raw) return;
                const data = JSON.parse(raw);
                Object.assign(state, data);
                // Ensure arrays exist
                if (!state.trades) state.trades = [];
                if (!state.bots) state.bots = [];
                if (!state.transactions) state.transactions = [];
                if (!state.customStrategies) state.customStrategies = [];
                if (!state.priceHistory) state.priceHistory = [];
                if (!state.settings) state.settings = { name: 'John Doe', email: 'john@trader.com', username: 'johndoe',
                    memberSince: 'Jan 2025' };
                // Rebuild bot intervals if needed
                state.bots.forEach(b => {
                    if (b.status === 'running') {
                        startBotEngine(b.id);
                    }
                });
            } catch (e) { /* ignore */ }
        }

        function resetAllData() {
            if (!confirm('Are you sure you want to reset ALL data? This cannot be undone.')) return;
            localStorage.removeItem('novatrade_data');
            Object.assign(state, {
                balance: 10000,
                trades: [],
                bots: [],
                transactions: [],
                customStrategies: [],
                botIdCounter: 1,
                tradeIdCounter: 1,
                txIdCounter: 1,
                priceHistory: [],
                currentPrice: 42350,
                priceTrend: 0,
                settings: { name: 'John Doe', email: 'john@trader.com', username: 'johndoe', memberSince: 'Jan 2025' }
            });
            Object.values(state.botIntervals).forEach(id => clearInterval(id));
            state.botIntervals = {};
            updateUI();
            renderBots();
            renderRecentTrades();
            renderTradeHistory();
            renderTransactions();
            renderFullTradeHistory();
            updateBotActivity();
            toast('All data has been reset.', 'info');
        }

        function exportData() {
            const data = JSON.stringify(state, null, 2);
            const blob = new Blob([data], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `novatrade_backup_${Date.now()}.json`;
            a.click();
            URL.revokeObjectURL(url);
            toast('Data exported successfully.', 'success');
        }

        function importData() {
            const input = document.createElement('input');
            input.type = 'file';
            input.accept = '.json';
            input.onchange = (e) => {
                const file = e.target.files[0];
                if (!file) return;
                const reader = new FileReader();
                reader.onload = (ev) => {
                    try {
                        const data = JSON.parse(ev.target.result);
                        Object.assign(state, data);
                        saveState();
                        updateUI();
                        renderBots();
                        renderRecentTrades();
                        renderTradeHistory();
                        renderTransactions();
                        renderFullTradeHistory();
                        updateBotActivity();
                        toast('Data imported successfully.', 'success');
                    } catch (err) {
                        toast('Invalid file format.', 'error');
                    }
                };
                reader.readAsText(file);
            };
            input.click();
        }

        // ================================================================
        //  NAVIGATION
        // ================================================================
        function initNavigation() {
            const links = document.querySelectorAll('.sidebar nav a');
            const pages = {
                dashboard: 'Dashboard',
                trading: 'Trading',
                bots: 'Bots',
                strategies: 'Strategies',
                payments: 'Payments',
                settings: 'Settings',
                data: 'User Data'
            };
            links.forEach(link => {
                link.addEventListener('click', () => {
                    links.forEach(l => l.classList.remove('active'));
                    link.classList.add('active');
                    const page = link.dataset.page;
                    document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
                    document.getElementById(`page-${page}`).classList.add('active');
                    document.querySelector('.page-title').innerHTML =
                        `${pages[page] || page} <small>${page === 'dashboard' ? 'overview' : ''}</small>`;
                    // Refresh charts when switching
                    if (page === 'trading') setTimeout(initTradingChart, 100);
                    if (page === 'dashboard') setTimeout(initDashboardChart, 100);
                });
            });
        }

        // ================================================================
        //  UI UPDATE
        // ================================================================
        function updateUI() {
            const bal = state.balance.toFixed(2);
            document.getElementById('headerBalance').textContent = bal;
            document.getElementById('dashBalance').textContent = '$' + bal;
            document.getElementById('dataBalance').textContent = bal;
            document.getElementById('dashTrades').textContent = state.trades.length;
            document.getElementById('dataTotalTrades').textContent = state.trades.length;
            const wins = state.trades.filter(t => t.result === 'win').length;
            const winRate = state.trades.length > 0 ? Math.round((wins / state.trades.length) * 100) : 0;
            document.getElementById('dashPnL').textContent = '$' + calcPnL().toFixed(2);
            document.getElementById('dataWinRate').textContent = winRate + '%';
            document.getElementById('dashBots').textContent = state.bots.filter(b => b.status === 'running').length;
            document.getElementById('dataName').textContent = state.settings.name;
            document.getElementById('dataEmail').textContent = state.settings.email;
            document.getElementById('dataUsername').textContent = state.settings.username;
            document.getElementById('dataMemberSince').textContent = state.settings.memberSince;
            document.getElementById('userNameDisplay').textContent = state.settings.name;
            document.getElementById('avatarLetter').textContent = state.settings.name.split(' ').map(n => n[0]).join('')
            .toUpperCase();
            document.getElementById('settingsName').value = state.settings.name;
            document.getElementById('settingsEmail').value = state.settings.email;
            document.getElementById('settingsUsername').value = state.settings.username;
        }

        function calcPnL() {
            return state.trades.reduce((sum, t) => sum + (t.profit || 0), 0);
        }

        // ================================================================
        //  TOAST
        // ================================================================
        function toast(msg, type = 'info') {
            const container = document.getElementById('toastContainer');
            const el = document.createElement('div');
            el.className = `toast ${type}`;
            const icons = { success: 'fas fa-check-circle', error: 'fas fa-exclamation-circle', info: 'fas fa-info-circle' };
            el.innerHTML = `<div class="toast-icon" style="color:${type === 'success' ? '#2ecc71' : type === 'error' ? '#e74c3c' : '#2e7dff'}"><i class="${icons[type] || icons.info}"></i></div><div class="toast-msg">${msg}</div>`;
            container.appendChild(el);
            setTimeout(() => { el.style.opacity = '0';
                el.style.transform = 'translateX(20px)';
                setTimeout(() => el.remove(), 300); }, 3500);
        }

        // ================================================================
        //  PRICE SIMULATION
        // ================================================================
        function startPriceSimulation() {
            if (state.priceHistory.length === 0) {
                for (let i = 0; i < 60; i++) {
                    state.priceHistory.push(42000 + Math.random() * 800);
                }
                state.currentPrice = state.priceHistory[state.priceHistory.length - 1];
            }
            setInterval(() => {
                const change = (Math.random() - 0.48) * 80;
                state.currentPrice = Math.max(1000, state.currentPrice + change);
                state.priceHistory.push(state.currentPrice);
                if (state.priceHistory.length > 200) state.priceHistory.shift();
                document.getElementById('tradingPrice').textContent = '$' + state.currentPrice.toFixed(2);
                const last = state.priceHistory[state.priceHistory.length - 2] || state.currentPrice;
                const pct = ((state.currentPrice - last) / last * 100);
                const el = document.getElementById('tradingChange');
                el.textContent = (pct >= 0 ? '+' : '') + pct.toFixed(2) + '%';
                el.className = pct >= 0 ? 'text-success' : 'text-danger';
                updateTradingChart();
                updateDashboardChart();
                saveState();
            }, 2000);
        }

        // ================================================================
        //  DASHBOARD CHART
        // ================================================================
        let dashChartInstance = null;

        function initDashboardChart() {
            const ctx = document.getElementById('dashboardChart').getContext('2d');
            if (dashChartInstance) { dashChartInstance.destroy();
                dashChartInstance = null; }
            const labels = state.priceHistory.map((_, i) => i);
            const data = state.priceHistory.length > 0 ? state.priceHistory : [42000, 42500, 42300, 42800, 42600];
            dashChartInstance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Price',
                        data: data,
                        borderColor: '#2e7dff',
                        backgroundColor: 'rgba(46,125,255,0.08)',
                        fill: true,
                        tension: 0.3,
                        pointRadius: 0,
                        borderWidth: 2,
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        x: { grid: { color: 'rgba(255,255,255,0.04)' }, ticks: { color: '#5a6478',
                                maxTicksLimit: 12 } },
                        y: { grid: { color: 'rgba(255,255,255,0.04)' }, ticks: { color: '#5a6478' } }
                    }
                }
            });
        }

        function updateDashboardChart() {
            if (dashChartInstance) {
                const data = state.priceHistory.length > 0 ? state.priceHistory : [42000, 42500, 42300, 42800, 42600];
                dashChartInstance.data.labels = data.map((_, i) => i);
                dashChartInstance.data.datasets[0].data = data;
                dashChartInstance.update('none');
            }
        }

        // ================================================================
        //  TRADING CHART
        // ================================================================
        let tradingChartInstance = null;

        function initTradingChart() {
            const ctx = document.getElementById('tradingChart').getContext('2d');
            if (tradingChartInstance) { tradingChartInstance.destroy();
                tradingChartInstance = null; }
            const data = state.priceHistory.length > 0 ? state.priceHistory : [42000, 42500, 42300, 42800, 42600];
            const labels = data.map((_, i) => i);
            tradingChartInstance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Price',
                        data: data,
                        borderColor: '#2e7dff',
                        backgroundColor: 'rgba(46,125,255,0.05)',
                        fill: true,
                        tension: 0.3,
                        pointRadius: 0,
                        borderWidth: 2,
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        x: { grid: { color: 'rgba(255,255,255,0.04)' }, ticks: { color: '#5a6478',
                                maxTicksLimit: 20 } },
                        y: { grid: { color: 'rgba(255,255,255,0.04)' }, ticks: { color: '#5a6478' } }
                    }
                }
            });
            document.getElementById('tradingPrice').textContent = '$' + state.currentPrice.toFixed(2);
        }

        function updateTradingChart() {
            if (tradingChartInstance) {
                const data = state.priceHistory.length > 0 ? state.priceHistory : [42000, 42500, 42300, 42800, 42600];
                tradingChartInstance.data.labels = data.map((_, i) => i);
                tradingChartInstance.data.datasets[0].data = data;
                tradingChartInstance.update('none');
            }
        }

        // ================================================================
        //  TRADING
        // ================================================================
        function executeTrade() {
            const asset = document.getElementById('tradeAsset').value;
            const amount = parseFloat(document.getElementById('tradeAmount').value);
            const direction = document.getElementById('tradeDirection').value;
            if (!amount || amount <= 0) { toast('Please enter a valid amount.', 'error'); return; }
            if (amount > state.balance) { toast('Insufficient balance.', 'error'); return; }
            const price = state.currentPrice;
            // Simulate outcome (60% win rate)
            const isWin = Math.random() < 0.6;
            const profit = isWin ? amount * (0.05 + Math.random() * 0.15) : -amount * (0.02 + Math.random() * 0.08);
            state.balance += profit;
            state.trades.push({
                id: state.tradeIdCounter++,
                asset,
                direction,
                amount,
                price,
                profit: Math.round(profit * 100) / 100,
                result: isWin ? 'win' : 'loss',
                time: new Date().toISOString(),
            });
            state.transactions.push({
                id: state.txIdCounter++,
                type: 'trade',
                amount: amount,
                method: direction.toUpperCase(),
                status: 'completed',
                date: new Date().toISOString(),
                profit: Math.round(profit * 100) / 100,
            });
            saveState();
            updateUI();
            renderRecentTrades();
            renderTradeHistory();
            renderTransactions();
            renderFullTradeHistory();
            toast(`${direction.toUpperCase()} ${asset} ${isWin ? 'won' : 'lost'}! ${profit >= 0 ? '+' : ''}$${profit.toFixed(2)}`,
                isWin ? 'success' : 'error');
        }

        function renderTradeHistory() {
            const tbody = document.getElementById('tradeHistoryBody');
            const trades = state.trades.slice(-10).reverse();
            if (trades.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" class="text-muted text-center">No trades yet</td></tr>';
                return;
            }
            tbody.innerHTML = trades.map(t =>
                `<tr><td>${t.asset}</td><td><span class="badge ${t.direction === 'buy' ? 'success' : 'danger'}">${t.direction.toUpperCase()}</span></td><td>$${t.amount.toFixed(2)}</td><td class="${t.profit >= 0 ? 'text-success' : 'text-danger'}">${t.profit >= 0 ? '+' : ''}$${t.profit.toFixed(2)}</td></tr>`
            ).join('');
        }

        function renderRecentTrades() {
            const tbody = document.getElementById('recentTradesBody');
            const trades = state.trades.slice(-5).reverse();
            if (trades.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="text-muted text-center">No recent trades</td></tr>';
                return;
            }
            tbody.innerHTML = trades.map(t =>
                `<tr><td>${t.asset}</td><td><span class="badge ${t.direction === 'buy' ? 'success' : 'danger'}">${t.direction.toUpperCase()}</span></td><td>$${t.amount.toFixed(2)}</td><td><span class="badge ${t.result === 'win' ? 'success' : 'danger'}">${t.result.toUpperCase()}</span></td><td>${new Date(t.time).toLocaleTimeString()}</td></tr>`
            ).join('');
        }

        function renderFullTradeHistory() {
            const tbody = document.getElementById('fullTradeHistoryBody');
            const trades = state.trades.slice().reverse();
            if (trades.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" class="text-muted text-center">No trades recorded</td></tr>';
                return;
            }
            tbody.innerHTML = trades.map(t =>
                `<tr><td>#${t.id}</td><td>${t.asset}</td><td><span class="badge ${t.direction === 'buy' ? 'success' : 'danger'}">${t.direction.toUpperCase()}</span></td><td>$${t.amount.toFixed(2)}</td><td>$${t.price.toFixed(2)}</td><td class="${t.profit >= 0 ? 'text-success' : 'text-danger'}">${t.profit >= 0 ? '+' : ''}$${t.profit.toFixed(2)}</td><td>${new Date(t.time).toLocaleDateString()}</td></tr>`
            ).join('');
        }

        // ================================================================
        //  PAYMENTS
        // ================================================================
        function initPaymentMethods() {
            document.querySelectorAll('.payment-method').forEach(el => {
                el.addEventListener('click', () => {
                    document.querySelectorAll('.payment-method').forEach(m => m.classList.remove('selected'));
                    el.classList.add('selected');
                });
            });
        }

        function depositFunds() {
            const amount = parseFloat(document.getElementById('depositAmount').value);
            if (!amount || amount <= 0) { toast('Enter a valid amount.', 'error'); return; }
            const method = document.querySelector('.payment-method.selected')?.dataset.method || 'bank';
            state.balance += amount;
            state.transactions.push({
                id: state.txIdCounter++,
                type: 'deposit',
                amount: amount,
                method: method,
                status: 'completed',
                date: new Date().toISOString(),
            });
            saveState();
            updateUI();
            renderTransactions();
            toast(`Deposited $${amount.toFixed(2)} successfully!`, 'success');
        }

        function withdrawFunds() {
            const amount = parseFloat(document.getElementById('withdrawAmount').value);
            if (!amount || amount <= 0) { toast('Enter a valid amount.', 'error'); return; }
            if (amount > state.balance) { toast('Insufficient balance.', 'error'); return; }
            state.balance -= amount;
            state.transactions.push({
                id: state.txIdCounter++,
                type: 'withdrawal',
                amount: amount,
                method: 'Bank Transfer',
                status: 'pending',
                date: new Date().toISOString(),
            });
            saveState();
            updateUI();
            renderTransactions();
            toast(`Withdrawal of $${amount.toFixed(2)} initiated (pending).`, 'info');
        }

        function renderTransactions() {
            const tbody = document.getElementById('transactionHistoryBody');
            const txs = state.transactions.slice().reverse().slice(0, 10);
            if (txs.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="text-muted text-center">No transactions yet</td></tr>';
                return;
            }
            tbody.innerHTML = txs.map(t =>
                `<tr><td><span class="badge ${t.type === 'deposit' ? 'success' : t.type === 'withdrawal' ? 'danger' : 'info'}">${t.type}</span></td><td>$${t.amount.toFixed(2)}</td><td>${t.method || 'N/A'}</td><td><span class="badge ${t.status === 'completed' ? 'success' : 'warning'}">${t.status}</span></td><td>${new Date(t.date).toLocaleDateString()}</td></tr>`
            ).join('');
        }

        // ================================================================
        //  BOTS
        // ================================================================
        function openBotModal() {
            document.getElementById('botModal').style.display = 'flex';
        }

        function closeBotModal() {
            document.getElementById('botModal').style.display = 'none';
        }

        function createBot() {
            const name = document.getElementById('botName').value.trim() || 'Unnamed Bot';
            const strategy = document.getElementById('botStrategy').value;
            const asset = document.getElementById('botAsset').value;
            const amount = parseFloat(document.getElementById('botAmount').value) || 50;
            const interval = parseInt(document.getElementById('botInterval').value) || 30;
            const bot = {
                id: state.botIdCounter++,
                name,
                strategy,
                asset,
                amount,
                interval,
                status: 'running',
                trades: 0,
                profit: 0,
                createdAt: new Date().toISOString(),
            };
            state.bots.push(bot);
            saveState();
            renderBots();
            updateBotActivity();
            closeBotModal();
            startBotEngine(bot.id);
            toast(`Bot "${name}" created and running.`, 'success');
        }

        function startBotEngine(botId) {
            const bot = state.bots.find(b => b.id === botId);
            if (!bot) return;
            if (state.botIntervals[botId]) clearInterval(state.botIntervals[botId]);
            state.botIntervals[botId] = setInterval(() => {
                const currentBot = state.bots.find(b => b.id === botId);
                if (!currentBot || currentBot.status !== 'running') {
                    clearInterval(state.botIntervals[botId]);
                    delete state.botIntervals[botId];
                    return;
                }
                // Simulate bot trade
                const isWin = Math.random() < 0.55;
                const profit = isWin ? currentBot.amount * (0.03 + Math.random() * 0.1) : -currentBot.amount * (0.01 +
                    Math.random() * 0.05);
                state.balance += profit;
                currentBot.trades += 1;
                currentBot.profit += profit;
                state.trades.push({
                    id: state.tradeIdCounter++,
                    asset: currentBot.asset,
                    direction: isWin ? 'buy' : 'sell',
                    amount: currentBot.amount,
                    price: state.currentPrice,
                    profit: Math.round(profit * 100) / 100,
                    result: isWin ? 'win' : 'loss',
                    time: new Date().toISOString(),
                    bot: currentBot.name,
                });
                saveState();
                updateUI();
                renderRecentTrades();
                renderTradeHistory();
                renderFullTradeHistory();
                updateBotActivity();
                renderBots();
            }, bot.interval * 1000);
        }

        function toggleBot(id) {
            const bot = state.bots.find(b => b.id === id);
            if (!bot) return;
            if (bot.status === 'running') {
                bot.status = 'stopped';
                if (state.botIntervals[id]) {
                    clearInterval(state.botIntervals[id]);
                    delete state.botIntervals[id];
                }
                toast(`Bot "${bot.name}" stopped.`, 'info');
            } else {
                bot.status = 'running';
                startBotEngine(id);
                toast(`Bot "${bot.name}" started.`, 'success');
            }
            saveState();
            renderBots();
            updateBotActivity();
        }

        function deleteBot(id) {
            if (!confirm('Delete this bot?')) return;
            const bot = state.bots.find(b => b.id === id);
            if (bot && state.botIntervals[id]) {
                clearInterval(state.botIntervals[id]);
                delete state.botIntervals[id];
            }
            state.bots = state.bots.filter(b => b.id !== id);
            saveState();
            renderBots();
            updateBotActivity();
            toast('Bot deleted.', 'info');
        }

        function renderBots() {
            const container = document.getElementById('botsList');
            if (state.bots.length === 0) {
                container.innerHTML =
                    '<div class="empty-state" style="grid-column:1/-1;"><i class="fas fa-robot"></i><p>No bots created yet. Click "New Bot" to get started.</p></div>';
                return;
            }
            container.innerHTML = state.bots.map(b => `
                    <div class="bot-card">
                        <div class="bot-header">
                            <div class="bot-name">${b.name}</div>
                            <span class="bot-status ${b.status}">${b.status.toUpperCase()}</span>
                        </div>
                        <div class="bot-details">
                            <span><i class="fas fa-chart-line"></i> ${b.asset}</span>
                            <span><i class="fas fa-dollar-sign"></i> $${b.amount}</span>
                            <span><i class="fas fa-clock"></i> ${b.interval}s</span>
                            <span><i class="fas fa-tag"></i> ${b.strategy}</span>
                        </div>
                        <div class="bot-details">
                            <span><i class="fas fa-exchange-alt"></i> Trades: ${b.trades || 0}</span>
                            <span><i class="fas fa-coins"></i> P/L: <span class="${(b.profit || 0) >= 0 ? 'text-success' : 'text-danger'}">${(b.profit || 0) >= 0 ? '+' : ''}$${(b.profit || 0).toFixed(2)}</span></span>
                        </div>
                        <div class="bot-actions">
                            <button class="btn ${b.status === 'running' ? 'btn-danger' : 'btn-success'} btn-sm" onclick="toggleBot(${b.id})">${b.status === 'running' ? '<i class="fas fa-pause"></i> Stop' : '<i class="fas fa-play"></i> Start'}</button>
                            <button class="btn btn-outline btn-sm" onclick="deleteBot(${b.id})"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                `).join('');
        }

        function updateBotActivity() {
            const container = document.getElementById('botActivityList');
            const running = state.bots.filter(b => b.status === 'running');
            if (running.length === 0) {
                container.innerHTML = '<div class="text-muted text-center" style="padding:20px 0;">No active bots</div>';
                return;
            }
            container.innerHTML = running.map(b =>
                `<div class="flex flex-between" style="padding:8px 0;border-bottom:1px solid #141c2a;">
                        <span><i class="fas fa-circle" style="color:#2ecc71;font-size:8px;"></i> ${b.name}</span>
                        <span class="text-muted">${b.asset} | $${b.amount} | ${b.interval}s</span>
                        <span class="${(b.profit || 0) >= 0 ? 'text-success' : 'text-danger'}">${(b.profit || 0) >= 0 ? '+' : ''}$${(b.profit || 0).toFixed(2)}</span>
                    </div>`
            ).join('');
        }

        // ================================================================
        //  STRATEGIES
        // ================================================================
        function saveCustomStrategy() {
            const name = document.getElementById('strategyName').value.trim();
            const type = document.getElementById('strategyType').value;
            const p1 = document.getElementById('strategyParam1').value;
            const p2 = document.getElementById('strategyParam2').value;
            if (!name) { toast('Please enter a strategy name.', 'error'); return; }
            state.customStrategies.push({ name, type, params: [p1, p2], created: new Date().toISOString() });
            saveState();
            document.getElementById('strategyName').value = '';
            toast(`Strategy "${name}" saved!`, 'success');
            // Re-render strategies list
            renderStrategies();
        }

        function renderStrategies() {
            // Already rendered statically, but we could update custom ones
            const container = document.getElementById('strategiesList');
            const custom = state.customStrategies || [];
            if (custom.length === 0) return;
            // Append custom strategies
            custom.forEach(s => {
                const el = document.createElement('div');
                el.className = 'bot-card';
                el.innerHTML = `
                        <div class="bot-header"><div class="bot-name">${s.name}</div><span class="badge warning">Custom</span></div>
                        <div class="bot-details">${s.type.toUpperCase()} | Params: ${s.params.join(', ')}</div>
                    `;
                container.appendChild(el);
            });
        }

        // ================================================================
        //  SETTINGS
        // ================================================================
        function saveProfile() {
            state.settings.name = document.getElementById('settingsName').value.trim() || 'John Doe';
            state.settings.email = document.getElementById('settingsEmail').value.trim() || 'john@trader.com';
            state.settings.username = document.getElementById('settingsUsername').value.trim() || 'johndoe';
            saveState();
            updateUI();
            toast('Profile updated successfully.', 'success');
        }

        // ================================================================
        //  REFRESH
        // ================================================================
        function refreshData() {
            updateUI();
            renderBots();
            renderRecentTrades();
            renderTradeHistory();
            renderTransactions();
            renderFullTradeHistory();
            updateBotActivity();
            toast('Data refreshed.', 'info');
        }

        // ================================================================
        //  CLOCK
        // ================================================================
        function updateClock() {
            const el = document.querySelector('.topbar .page-title small');
            if (el) {
                const now = new Date();
                el.textContent = now.toLocaleTimeString();
            }
        }

        // ================================================================
        //  EXTRA: renderStrategies on load
        // ================================================================
        setTimeout(renderStrategies, 500);

        console.log('🚀 NovaTrade Platform loaded successfully.');
        console.log('📊 Data stored in localStorage under "novatrade_data"');
    </script>
</body>
</html>
EOF

# 3. Install Python if not already installed
if ! command -v python &> /dev/null; then
    echo "🐍 Python not found. Installing..."
    pkg install python -y
fi

# 4. Start the server on port 5000
echo "🚀 Starting NovaTrade server on port 5000..."
echo "📱 Open http://localhost:5000 in your browser (or use the IP of your device on the same network)."
echo "Press Ctrl+C to stop the server."

python -m http.server 5000
