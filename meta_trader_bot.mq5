#property copyright "aimeprogrammer"
#property link      "https://github.com/aimeprogrammer/meta-trader-bot"
#property version   "1.1"
#property strict

#include "Includes/CLogger.mqh"
#include "Includes/CSignalGenerator.mqh"
#include "Includes/CPatternRecognizer.mqh"
#include "Includes/CHTFVolatilityFilter.mqh"
#include "Includes/CConfirmationManager.mqh"
#include "Includes/CRiskManager.mqh"
#include "Includes/COrderExecutor.mqh"
#include "Includes/ChartUI.mqh"
#include "Includes/patterns_seed.mqh"

#include <Trade\Trade.mqh>

// Main EA file - meta_trader_bot.mq5
// This file wires together modular components and exposes OnInit/OnTick/OnTimer/OnDeinit/OnChartEvent.

// Inputs (kept same as previous version)
input int      FastMA_Period        = 10;      // Fast MA period (M5)
input int      SlowMA_Period        = 30;      // Slow MA period (M5)
input int      RSI_Period           = 14;      // RSI period (M5)
input double   RSIOversold         = 30.0;     // RSI oversold
input double   RSIOverbought       = 70.0;     // RSI overbought

input int      ATR_Period           = 14;      // ATR period (M15 & H1)
input double   MinVolatility_M15    = 0.1;     // Min ATR% M15
input double   MaxVolatility_M15    = 0.8;     // Max ATR% M15
input double   MinVolatility_H1     = 0.2;     // Min ATR% H1
input double   MaxVolatility_H1     = 1.0;     // Max ATR% H1

enum ConfirmModes { MODE_REGIME_MA = 0, MODE_MA_ONLY = 1 };
input int      ConfirmMTF_Mode      = MODE_REGIME_MA;

input int      StopLossPips         = 30;      // Stop Loss (pips)
input int      TakeProfitPips       = 50;      // Take Profit (pips)
input int      TrailingStopPips     = 25;      // Trailing stop (pips)
input int      TrailingActivationPips = 20;    // Trailing start after X pips profit

input double   RiskPercent          = 2.0;     // % risk per trade
input double   MaxDailyDrawdown     = 5.0;     // % max daily drawdown
input int      MaxOpenTrades        = 3;       // Maximum open trades across all instruments

input bool     EnableAIPattern      = true;
input double   PatternAccuracyThreshold = 0.6; // Pattern score threshold

input bool     EnableDetailedLogs   = true;    // Enable extensive Print() logs
input string   SymbolsList          = "EURUSD,GBPUSD,XAUUSD,US30"; // comma-separated instruments to trade
input double   MaxLot               = 10.0;   // Safety cap

// Global objects declared in includes are used here
extern CLogger logger;
extern CPatternRecognizer patternRecognizer;
extern CSignalGenerator signalGen;
extern CHTFVolatilityFilter volFilter;
extern CConfirmationManager confirmManager;
extern CRiskManager riskManager;
extern COrderExecutor orderExec;
extern CChartUI chartUI;

string SymbolsArray[];

auto ParseSymbols = []()
  {
   int count = StringSplit(SymbolsList,',',SymbolsArray);
   for(int i=0;i<count;i++) SymbolsArray[i] = StringTrim(SymbolsArray[i]);
  };

int OnInit()
  {
   ParseSymbols();
   // Initialize pattern DB from seed include. patterns_seed.mqh defines ProvidePatternSeed.
   if(EnableAIPattern)
     {
      patternRecognizer.ClearDatabase();
      ProvidePatternSeed(patternRecognizer); // loads patterns from seed file (separate include)
      logger.Log("Pattern DB loaded from seed. Count="+IntegerToString(patternRecognizer.GetDatabaseSize()));
     }

   chartUI.CreateUI();

   EventSetTimer(3600);
   logger.Log("EA Initialized (modular).\n");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   chartUI.DestroyUI();
   EventKillTimer();
   logger.Log("EA Deinitialized. Reason="+IntegerToString(reason));
  }

void OnTimer()
  {
   chartUI.OnTimer();
  }

void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   chartUI.OnChartEvent(id,lparam,dparam,sparam);
  }

void OnTick()
  {
   // delegate main logic to a function implemented in COrderExecutor (or keep in main loop)
   // For simplicity keep core orchestration here but using modular objects
   for(int si=0; si<ArraySize(SymbolsArray); si++)
     {
      string symbol = SymbolsArray[si];
      if(StringLen(symbol)==0) continue;
      if(!SymbolSelect(symbol,true)) { logger.Log("SymbolSelect failed: "+symbol); continue; }

      volFilter.UpdateIfNeeded(symbol);

      int m5Signal=0; double fastMA=0, slowMA=0, rsi=0;
      signalGen.GetM5Signal(symbol,m5Signal,fastMA,slowMA,rsi);

      double patternScore = 1.0;
      if(EnableAIPattern)
        {
         double currentPattern[]; ArrayResize(currentPattern,20);
         if(patternRecognizer.BuildCurrentPattern(symbol,PERIOD_M5,currentPattern))
            patternScore = patternRecognizer.PatternScore(currentPattern);
         else patternScore = 0.0;
        }

      bool htfVolPass = volFilter.VolatilityPasses();
      string htfreason=""; bool htfConfirm = confirmManager.ConfirmHTF(symbol,m5Signal,volFilter,htfreason);

      bool allowed=true; string blockedReason="";
      if(!htfVolPass) { allowed=false; blockedReason = "Blocked: HTF Volatility outside thresholds"; }
      if(!htfConfirm) { allowed=false; if(blockedReason=="") blockedReason = "Blocked: HTF Confirmation failed ("+htfreason+")"; }
      if(EnableAIPattern && patternScore < PatternAccuracyThreshold) { allowed=false; if(blockedReason=="") blockedReason = "Blocked: PatternScore low"; }
      if(m5Signal==0) { allowed=false; if(blockedReason=="") blockedReason = "Blocked: No M5 signal"; }
      if(riskManager.CountOpenTrades() >= MaxOpenTrades) { allowed=false; if(blockedReason=="") blockedReason = "Blocked: Max open trades reached"; }

      // Log
      logger.Log("SYM="+symbol+" | M5="+((m5Signal==1)?"BUY":(m5Signal==-1?"SELL":"NEUTRAL"))
                 +" | M15Reg="+RegimeToString(volFilter.GetRegimeM15())+" ATR%="+DoubleToString(volFilter.GetATRPercentM15(),3)
                 +" | H1Reg="+RegimeToString(volFilter.GetRegimeH1())+" ATR%="+DoubleToString(volFilter.GetATRPercentH1(),3)
                 +" | PatternScore="+DoubleToString(patternScore,3)+" | Decision="+(allowed?"TRADE ALLOWED":"TRADE BLOCKED")");

      chartUI.UpdateDashboard(symbol, m5Signal, volFilter, patternScore, allowed, blockedReason);

      if(allowed)
        {
         // attempt trade
         bool hasSameDir=false;
         for(int p=0;p<PositionsTotal();p++)
           {
            if(PositionSelectByIndex(p))
              {
               string psym = PositionGetString(POSITION_SYMBOL);
               long type = PositionGetInteger(POSITION_TYPE);
               if(psym==symbol)
                 {
                  if((m5Signal==1 && type==POSITION_TYPE_BUY) || (m5Signal==-1 && type==POSITION_TYPE_SELL)) hasSameDir=true;
                 }
              }
           }
         if(!hasSameDir)
           {
            double lots = riskManager.CalculateLot(symbol,StopLossPips);
            if(lots>0) orderExec.SendOrder(symbol, (m5Signal==1)?1:-1, lots, StopLossPips, TakeProfitPips);
           }
        }
     }
  }
