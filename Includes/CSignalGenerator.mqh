// CSignalGenerator.mqh
#pragma once

class CSignalGenerator
  {
public:
   bool GetM5Signal(string symbol, int &signal, double &fastMA, double &slowMA, double &rsi)
     {
      signal = 0;
      fastMA = iMA(symbol,PERIOD_M5,FastMA_Period,0,MODE_EMA,PRICE_CLOSE,0);
      slowMA = iMA(symbol,PERIOD_M5,SlowMA_Period,0,MODE_EMA,PRICE_CLOSE,0);
      rsi = iRSI(symbol,PERIOD_M5,RSI_Period,PRICE_CLOSE,0);
      if(fastMA>slowMA && rsi<50.0) signal=1;
      else if(fastMA<slowMA && rsi>50.0) signal=-1;
      else signal=0;
      return true;
     }
  };

CSignalGenerator signalGen;
