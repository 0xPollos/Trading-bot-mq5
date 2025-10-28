# AutoCompoundEA-MT5 🚀
Smart Auto-Compounding Expert Advisor for MetaTrader 5 — built for precision risk management and scalable growth on **XAUUSD** or any volatile pair.

---

## ⚙️ Features
- 💰 **Auto-Compound Lot Sizing** — dynamically adjusts position size based on account balance.
- 🎯 **Configurable Risk & Reward** — default: Risk 10%, R:R 1:2 (+20% target).
- 🧭 **Multiple Entry Signals**
  - MA Cross
  - FVG (Fair Value Gap)
  - OB (Order Block)
- 🧩 **Optional ATR-based Stop Loss**
- 📈 **Compatible with Prop Firm rules** (risk management oriented)

---

## 🧮 Parameters
| Parameter | Default | Description |
|------------|----------|-------------|
| `RiskPercent` | `10.0` | Percentage of balance risked per trade |
| `RewardRatio` | `2.0` | Risk-to-reward ratio (1:2 = +20%) |
| `StopLossPoints` | `1500` | Fixed stop-loss distance in points |
| `UseATRforSL` | `false` | Use ATR-based dynamic SL |
| `SignalMode` | `0` | 0 = MA, 1 = FVG, 2 = OB |
| `FastMAPeriod` | `9` | Fast MA period |
| `SlowMAPeriod` | `21` | Slow MA period |
| `MaxLots` | `10.0` | Maximum allowable lot size |
| `MagicNumber` | `7777` | Trade identification ID |

---

## 📂 Preset Files
You can load pre-configured `.set` files for faster setup:

| Preset | Risk | Reward Ratio | Notes |
|---------|------|---------------|-------|
| `Risk10_RR2.set` | 10% | 1:2 | Recommended for aggressive compounding |
| `Risk5_RR3.set` | 5% | 1:3 | Safer option for consistency |

How to load:
1. Open MT5 → `Navigator → Expert Advisors`
2. Right-click `AutoCompoundEA` → Attach to chart
3. In **Inputs tab**, click **Load** → select preset file

---

## How to use
1. Open MetaEditor, create new EA file and paste `AutoCompoundEA.mq5` content.
2. Compile, attach to XAUUSD chart.
3. Configure inputs: `RiskPercent=5`, `SignalMode=0/1/2`, `StopLossPoints`, `RR`, etc.
4. Test on demo account extensively.

---

## 🧭 Recommended Use
- Pair: `XAUUSD` or volatile pairs  
- Timeframe: `M5 – H1`  
- Spread: ≤ 30 points  
- Account Type: ECN or Raw  
- Use **demo account first** to forward test for at least 2 weeks.

---

## 📊 Backtest Example
Example settings:
