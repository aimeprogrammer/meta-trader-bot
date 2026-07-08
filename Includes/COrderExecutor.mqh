// COrderExecutor.mqh
#pragma once
#include <Trade\Trade.mqh>

class COrderExecutor
  {
private:
   CTrade trade;
public:
   bool SendOrder(string symbol, int type, double lots, int slPips, int tpPips)
     {
      double price = (type==1) ? SymbolInfoDouble(symbol,SYMBOL_ASK) : SymbolInfoDouble(symbol,SYMBOL_BID);
      double sl_price = (type==1) ? price - PipsToPrice(symbol,slPips) : price + PipsToPrice(symbol,slPips);
      double tp_price = (type==1) ? price + PipsToPrice(symbol,tpPips) : price - PipsToPrice(symbol,tpPips);
      int attempts=0; bool ok=false;
      while(attempts<3 && !ok)
        {
         attempts++;
         trade.SetExpertMagic(123456);
         trade.SetDeviationInPoints(30);
         if(type==1) ok = trade.Buy(lots,symbol,price,sl_price,tp_price,"MT5-AI-EA"); else ok = trade.Sell(lots,symbol,price,sl_price,tp_price,"MT5-AI-EA");
         if(!ok) { Print("Order send failed attempt "+IntegerToString(attempts)+": "+trade.ResultRetcodeDescription()); Sleep(200); }
        }
      if(!ok) { Print("SendOrder failed after retries for "+symbol); return false; }
      Print("Order placed: "+symbol+" "+((type==1)?"BUY":"SELL")+" lots="+DoubleToString(lots,2));
      return true;
     }
  };

COrderExecutor orderExec;
