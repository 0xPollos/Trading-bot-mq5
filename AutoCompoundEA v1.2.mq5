//+------------------------------------------------------------------+
//|                   AutoCompoundEA v1.2 - Risk 10%, RR 1:2         |
//|                                by Pollos                         |
//+------------------------------------------------------------------+
#property strict

input double RiskPercent     = 10.0;     // Risiko per trade (% balance)
input double RewardRatio     = 2.0;      // Risk:Reward = 1:2 → +20% target
input int StopLossPoints     = 1500;     // 150 pips (XAUUSD = 0.15)
input bool UseATRforSL       = false;    // Gunakan ATR untuk SL dinamis
input int SignalMode         = 0;        // 0 = MA, 1 = FVG, 2 = OB
input int FastMAPeriod       = 9;
input int SlowMAPeriod       = 21;
input double ATRMultiplier   = 1.5;
input bool TradeBuy          = true;
input bool TradeSell         = true;
input double MaxLots         = 10.0;
input int MagicNumber        = 7777;

//--------------------------------------------------------------------
// Function: Hitung lot berdasarkan risiko
//--------------------------------------------------------------------
double CalculateLot(double stopLossPoints)
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskValue = balance * (RiskPercent / 100.0);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);

   double lot = riskValue / ((stopLossPoints * tickValue) / tickSize);
   lot = MathMin(lot, MaxLots);
   return NormalizeDouble(lot, 2);
}

//--------------------------------------------------------------------
// Function: Entry berdasarkan signal mode
//--------------------------------------------------------------------
bool CheckBuySignal()
{
   if (SignalMode == 0)
   {
      double maFast = iMA(_Symbol, 0, FastMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 0);
      double maSlow = iMA(_Symbol, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 0);
      double maFastPrev = iMA(_Symbol, 0, FastMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
      double maSlowPrev = iMA(_Symbol, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
      return (maFast > maSlow && maFastPrev < maSlowPrev);
   }
   // FVG dan OB bisa ditambahkan kemudian
   return false;
}

bool CheckSellSignal()
{
   if (SignalMode == 0)
   {
      double maFast = iMA(_Symbol, 0, FastMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 0);
      double maSlow = iMA(_Symbol, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 0);
      double maFastPrev = iMA(_Symbol, 0, FastMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
      double maSlowPrev = iMA(_Symbol, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
      return (maFast < maSlow && maFastPrev > maSlowPrev);
   }
   // FVG dan OB bisa ditambahkan kemudian
   return false;
}

//--------------------------------------------------------------------
// Function: Entry order
//--------------------------------------------------------------------
void OpenTrade(bool isBuy)
{
   double slPoints = StopLossPoints;
   if (UseATRforSL)
   {
      double atr = iATR(_Symbol, 0, 14, 0);
      slPoints = atr / SymbolInfoDouble(_Symbol, SYMBOL_POINT) * ATRMultiplier;
   }

   double lot = CalculateLot(slPoints);
   double slPrice, tpPrice;

   if (isBuy)
   {
      slPrice = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID) - slPoints * _Point, _Digits);
      tpPrice = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID) + (slPoints * RewardRatio * _Point), _Digits);
      OrderSend(_Symbol, OP_BUY, lot, SymbolInfoDouble(_Symbol, SYMBOL_ASK), 3, slPrice, tpPrice, "AutoCompound Buy", MagicNumber, 0, clrBlue);
   }
   else
   {
      slPrice = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK) + slPoints * _Point, _Digits);
      tpPrice = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK) - (slPoints * RewardRatio * _Point), _Digits);
      OrderSend(_Symbol, OP_SELL, lot, SymbolInfoDouble(_Symbol, SYMBOL_BID), 3, slPrice, tpPrice, "AutoCompound Sell", MagicNumber, 0, clrRed);
   }
}

//--------------------------------------------------------------------
// Main logic
//--------------------------------------------------------------------
void OnTick()
{
   if (PositionsTotal() > 0) return;

   if (TradeBuy && CheckBuySignal())  OpenTrade(true);
   if (TradeSell && CheckSellSignal()) OpenTrade(false);
}
