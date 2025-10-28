## Features:
- Auto-calc lot (auto-compound) using RiskPercent
- Selectable signal mode: MA crossover, FVG, or Order Block (OB)
- Keep core money management untouched; signal selection only
- Safe guards: min/max lots, volume step normalization

---

# AutoCompoundEA (MQL5)

This repository contains `AutoCompoundEA.mq5` — an Expert Advisor for MetaTrader 5 that auto-calculates lot sizes using a fixed risk percentage (auto-compound) and supports selectable signal modes:
- MA crossover (default)
- Fair Value Gap (FVG)
- Order Block (OB)


**Important:** This EA provides example signal implementations. You should backtest and forward-test in demo before using live.

---

## How to use
1. Open MetaEditor, create new EA file and paste `AutoCompoundEA.mq5` content.
2. Compile, attach to XAUUSD chart.
3. Configure inputs: `RiskPercent=5`, `SignalMode=0/1/2`, `StopLossPoints`, `RR`, etc.
4. Test on demo account extensively.

---

# FILE: Dockerfile 
- Dockerfile (optional) - for storing repo or CI tasks (not for running EA)
- FROM alpine:latest
- CMD ["/bin/sh"]

---

=== END OF REPO FILES ===
