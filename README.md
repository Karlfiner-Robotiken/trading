# NovaTrade – Self‑Hosted Trading Platform

**NovaTrade** is a complete, single‑page trading dashboard inspired by platforms like **Deriv**. It combines a live‑price simulation, manual trading, automated trading bots, strategy management, deposit/withdraw mock payments, user settings, and full data export/import – all in one HTML file.

> ⚠️ **For educational/demo purposes only.** No real money, no real trades, no external API calls. All data is stored in your browser’s `localStorage`.

---

## ✨ Features

- **📊 Dashboard** – Balance, profit/loss, trade count, win rate, active bots, and a performance chart.
- **📈 Trading** – Live price chart (simulated), quick buy/sell with instant outcome (60% win rate).
- **🤖 Bots** – Create and manage automated bots with selectable strategies (RSI, MACD, SMA, Bollinger, Grid, Scalper). Each bot runs on a configurable interval and tracks its own P&L.
- **🧠 Strategies** – Built‑in strategy list and a form to save your own custom strategies.
- **💳 Payments** – Deposit and withdrawal simulation with multiple payment methods; transaction history is logged.
- **⚙️ Settings** – Profile update, preference toggles (dark mode, notifications, etc.), and password change (UI only).
- **📁 User Data** – View full profile, export/import all data as JSON, or reset everything.
- **📱 Responsive** – Optimised for desktop, tablet, and mobile.

---

## 🚀 Installation & Setup

### Prerequisites
- A modern web browser (Chrome, Firefox, Edge, Safari)
- (Optional) A local web server for testing – **recommended** to avoid CORS or `file://` limitations.

### Quick Start – The Easy Way

1. **Download** the `index.html` file from this repository (or copy the full source).
2. **Open** it directly in your browser – it works offline!
   - However, some browsers may restrict `localStorage` or font loading from CDN when using `file://`. For best results, use a local server.

### Running with a Local Server (Recommended)

#### Using Python (built‑in)
```bash
# Navigate to the folder containing index.html
cd ~/trading
python -m http.server 5000
