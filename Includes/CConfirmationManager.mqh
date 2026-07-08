// CConfirmationManager.mqh
#pragma once

class CConfirmationManager
  {
public:
   bool ConfirmHTF(string symbol, int m5Signal, CHTFVolatilityFilter &volFilter, string &reason)
     {
      reason = "";
      if(m5Signal==0) { reason="Neutral M5"; return false; }
      extern int ConfirmMTF_Mode;
      if(ConfirmMTF_Mode == MODE_MA_ONLY)
        {
         bool m15Align = (volFilter.GetM15FastMA() > volFilter.GetM15SlowMA());
         bool h1Align  = (volFilter.GetH1FastMA() > volFilter.GetH1SlowMA());
         if(m5Signal<0) { m15Align = (volFilter.GetM15FastMA() < volFilter.GetM15SlowMA()); h1Align = (volFilter.GetH1FastMA() < volFilter.GetH1SlowMA()); }
         if(m15Align && h1Align) return true; reason = "MA alignment failed"; return false;
        }
      else
        {
         int rM15 = volFilter.GetRegimeM15(); int rH1 = volFilter.GetRegimeH1(); bool regimesSame = (rM15==rH1);
         bool m15Dir = (volFilter.GetM15FastMA() > volFilter.GetM15SlowMA()); bool h1Dir = (volFilter.GetH1FastMA() > volFilter.GetH1SlowMA());
         if(m5Signal<0) { m15Dir = (volFilter.GetM15FastMA() < volFilter.GetM15SlowMA()); h1Dir = (volFilter.GetH1FastMA() < volFilter.GetH1SlowMA()); }
         if(regimesSame && m15Dir && h1Dir) return true; reason = "Regime or MA mismatch"; return false;
        }
     }
  };

CConfirmationManager confirmManager;
