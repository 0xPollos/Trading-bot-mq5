#include <Trade/Trade.mqh>
CTrade trade;


//--- input parameters
input double RiskPercent = 5.0; // Risk percent per trade (e.g., 5 means 5%)
input int StopLossPoints = 150; // Stop loss in points (1 point = 0.01 for XAUUSD typically)
input double RR = 3.0; // Reward-to-risk ratio (TP = SL * RR)
input double MaxLots = 0.30; // Maximum lot size allowed by this EA
input ENUM_TIMEFRAMES ma_tf = PERIOD_M5; // timeframe for MA signal
input int MA_PeriodFast = 20; // MA fast period
input int MA_PeriodSlow = 50; // MA slow period
input bool UseATRforSL = false; // If true, uses ATR to calculate SL
input int ATR_Period = 14; // ATR period (if used)
input double ATR_Multiplier = 1.5; // ATR multiplier for SL
input ulong MagicNumber = 20251028; // Magic number
input bool TradeBuy = true; // Allow buy trades
input bool TradeSell = true; // Allow sell trades
input double MinLots = 0.01; // Minimum allowed lot size
input bool UseFixedSL = true; // Use StopLossPoints if true; else use ATR
input int Slippage = 10; // Slippage in points


//--- Signal selection: 0=MA, 1=FVG, 2=OB
input int SignalMode = 0;


//--- global
string symbolName;
double pointVal, tickValue, tickSize, contractSize;
double volumeStep, minVolume, maxVolume;


// Helper: simple logging
void log(string s) { PrintFormat("[AutoCompoundEA] %s", s); }


int OnInit()
{
symbolName = _Symbol;
pointVal = SymbolInfoDouble(symbolName,SYMBOL_POINT);
tickValue = SymbolInfoDouble(symbolName,SYMBOL_TRADE_TICK_VALUE);
tickSize = SymbolInfoDouble(symbolName,SYMBOL_TRADE_TICK_SIZE);
contractSize = SymbolInfoDouble(symbolName,SYMBOL_TRADE_CONTRACT_SIZE);
volumeStep = SymbolInfoDouble(symbolName,SYMBOL_VOLUME_STEP);
minVolume = SymbolInfoDouble(symbolName,SYMBOL_VOLUME_MIN);
maxVolume = SymbolInfoDouble(symbolName,SYMBOL_VOLUME_MAX);


if(pointVal==0 || tickSize==0)
{
log("Symbol info error. Check symbol: " + symbolName);
return(INIT_FAILED);
}


PrintFormat("AutoCompoundEA initialized for %s | SignalMode=%d | Risk=%.2f%%",
symbolName, SignalMode, RiskPercent);
return(INIT_SUCCEEDED);
}


// Calculate lot size based on risk percent and SL (points)
double CalculateLot(double risk_percent, int sl_points)
{
double balance = AccountInfoDouble(ACCOUNT_BALANCE);
double risk_amount = balance * (risk_percent/100.0);


double valuePerPoint = 0.0;
if(tickSize>0)
valuePerPoint = tickValue / tickSize; // currency per 1 price tick for 1 lot
else
valuePerPoint = contractSize * pointVal;


double risk_per_lot = sl_points * pointVal * valuePerPoint;
if(risk_per_lot<=0)
{
log("Risk per lot calculation error.");
return(0.0);
}


double raw_lots = risk_amount / risk_per_lot;
double normalized = MathFloor(raw_lots/volumeStep) * volumeStep;
if(normalized < minVolume) normalized = minVolume;
if(normalized > maxVolume) normalized = maxVolume;
if(normalized > MaxLots) normalized = MathMin(normalized, MaxLots);
if(normalized < MinLots) return(0.0);


return(NormalizeDouble(normalized,2));
}


// ATR helper
double GetATRPoints(ENUM_TIMEFRAMES tf,int period)
{
int handle = iATR(symbolName,tf,period);
if(handle==INVALID_HANDLE) return(0);
double atrArray[];
ArraySetAsSeries(atrArray,true);
int copied = CopyBuffer(handle,0,0,3,atrArray);
IndicatorRelease(handle);
if(copied<=0) return(0);
double atr = atrArray[0]; // price units
double atr_points = atr/pointVal;
void OnDeinit(const int reason) { }
