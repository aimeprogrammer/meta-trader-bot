// CRiskManager.mqh
#pragma once

class CRiskManager
  {
public:
   double CalculateLot(string symbol, double stopLossPips)
     {
      double balance = AccountInfoDouble(ACCOUNT_BALANCE);
      double riskMoney = balance * (RiskPercent/100.0);
      double tick_value = SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE);
      double tick_size  = SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE);
      double pipPrice = PipsToPrice(symbol,1);
      double pipValuePerLot = (tick_size>0 && pipPrice>0) ? (tick_value / tick_size) / pipPrice : 10.0;
      if(pipValuePerLot<=0) pipValuePerLot=10.0;
      double lossPerLot = pipValuePerLot * stopLossPips; if(lossPerLot<=0) return 0.01;
      double lots = riskMoney / lossPerLot; lots = MathMin(lots,MaxLot);
      double step = SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP); if(step<=0) step=0.01;
      double minlot = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN); double res = MathFloor(lots/step)*step; if(res<minlot) res=minlot;
      return NormalizeDouble(res,2);
     }
   bool CheckDailyDrawdownExceeded(double dayStartBalance, double MaxDailyDrawdown)
     {
      if(dayStartBalance<=0) return false;
      double balance = AccountInfoDouble(ACCOUNT_BALANCE);
      double dd = (dayStartBalance - balance)/dayStartBalance*100.0;
      return dd >= MaxDailyDrawdown;
     }
   int CountOpenTrades()
     {
      return PositionsTotal();
     }
  };

CRiskManager riskManager;
