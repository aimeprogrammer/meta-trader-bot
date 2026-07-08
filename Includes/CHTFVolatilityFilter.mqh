// CHTFVolatilityFilter.mqh
#pragma once

class CHTFVolatilityFilter
  {
private:
   double ATR_M15_Percent;
   double ATR_H1_Percent;
   int    M15_Regime;
   int    H1_Regime;
   double M15_FastMA, M15_SlowMA;
   double H1_FastMA, H1_SlowMA;
public:
   CHTFVolatilityFilter() { ATR_M15_Percent=0; ATR_H1_Percent=0; M15_Regime=0; H1_Regime=0; }
   void UpdateIfNeeded(string symbol)
     {
      datetime barTimeM15 = iTime(symbol,PERIOD_M15,0);
      datetime barTimeH1  = iTime(symbol,PERIOD_H1,0);
      extern datetime lastBarTime_M15;
      extern datetime lastBarTime_H1;
      if(barTimeM15 != lastBarTime_M15)
        {
         ATR_M15_Percent = ComputeATRPercent(symbol,PERIOD_M15,ATR_Period);
         M15_FastMA = iMA(symbol,PERIOD_M15,FastMA_Period,0,MODE_EMA,PRICE_CLOSE,0);
         M15_SlowMA = iMA(symbol,PERIOD_M15,SlowMA_Period,0,MODE_EMA,PRICE_CLOSE,0);
         M15_Regime = ComputeRegime(symbol,PERIOD_M15);
         lastBarTime_M15 = barTimeM15;
        }
      if(barTimeH1 != lastBarTime_H1)
        {
         ATR_H1_Percent = ComputeATRPercent(symbol,PERIOD_H1,ATR_Period);
         H1_FastMA = iMA(symbol,PERIOD_H1,FastMA_Period,0,MODE_EMA,PRICE_CLOSE,0);
         H1_SlowMA = iMA(symbol,PERIOD_H1,SlowMA_Period,0,MODE_EMA,PRICE_CLOSE,0);
         H1_Regime = ComputeRegime(symbol,PERIOD_H1);
         lastBarTime_H1 = barTimeH1;
        }
     }
   double GetATRPercentM15() { return ATR_M15_Percent; }
   double GetATRPercentH1()  { return ATR_H1_Percent; }
   int    GetRegimeM15()     { return M15_Regime; }
   int    GetRegimeH1()      { return H1_Regime; }
   double GetM15FastMA()     { return M15_FastMA; }
   double GetM15SlowMA()     { return M15_SlowMA; }
   double GetH1FastMA()      { return H1_FastMA; }
   double GetH1SlowMA()      { return H1_SlowMA; }
   bool VolatilityPasses()
     {
      extern double MinVolatility_M15; extern double MaxVolatility_M15;
      extern double MinVolatility_H1; extern double MaxVolatility_H1;
      bool passM15 = (ATR_M15_Percent >= MinVolatility_M15 && ATR_M15_Percent <= MaxVolatility_M15);
      bool passH1  = (ATR_H1_Percent  >= MinVolatility_H1  && ATR_H1_Percent  <= MaxVolatility_H1);
      return passM15 && passH1;
     }
private:
   double ComputeATRPercent(string symbol, ENUM_TIMEFRAMES tf, int atrPeriod)
     {
      double atr = iATR(symbol,tf,atrPeriod,0);
      double price = SymbolInfoDouble(symbol,SYMBOL_BID);
      if(price<=0) return 0.0;
      return (atr/price)*100.0;
     }
   int ComputeRegime(string symbol, ENUM_TIMEFRAMES tf)
     {
      int bars = 50; if(Bars(symbol,tf)<bars) return 1;
      double closes[]; ArrayResize(closes,bars);
      for(int i=0;i<bars;i++) closes[i]=iClose(symbol,tf,i);
      double returnsSum=0, returnsSq=0;
      for(int i=0;i<bars-1;i++) { double r=(closes[i]-closes[i+1])/closes[i+1]; returnsSum+=r; returnsSq+=r*r; }
      double mean=returnsSum/(bars-1); double var=(returnsSq/(bars-1)) - mean*mean; double std = MathSqrt(MathMax(0.0,var));
      if(std>0.003) return 2; // volatile
      double slope = (closes[0]-closes[bars-1]) / bars;
      if(fabs(slope) > (SymbolInfoDouble(symbol,SYMBOL_POINT)*5.0)) return 0; // trending
      return 1; // ranging
     }
  };

CHTFVolatilityFilter volFilter;
