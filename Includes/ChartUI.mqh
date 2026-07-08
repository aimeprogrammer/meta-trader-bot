// ChartUI.mqh
#pragma once

class CChartUI
  {
private:
   int btnToggleLogs;
   int btnToggleMode;
public:
   void CreateUI()
     {
      // Create two simple buttons on the chart
      btnToggleLogs = ChartCreateObject(0,OBJ_BUTTON,"btnLogs",0,0,0);
      btnToggleMode = ChartCreateObject(0,OBJ_BUTTON,"btnMode",0,0,0);
      // Using object-create functions directly for portability
      ObjectCreate(0,"MT5_BTN_LOGS",OBJ_BUTTON,0,0,0);
      ObjectSetString(0,"MT5_BTN_LOGS",OBJPROP_TEXT,"Toggle Logs");
      ObjectSetInteger(0,"MT5_BTN_LOGS",OBJPROP_XDISTANCE,10);
      ObjectSetInteger(0,"MT5_BTN_LOGS",OBJPROP_YDISTANCE,10);

      ObjectCreate(0,"MT5_BTN_MODE",OBJ_BUTTON,0,0,0);
      ObjectSetString(0,"MT5_BTN_MODE",OBJPROP_TEXT,"Toggle HTF Mode");
      ObjectSetInteger(0,"MT5_BTN_MODE",OBJPROP_XDISTANCE,120);
      ObjectSetInteger(0,"MT5_BTN_MODE",OBJPROP_YDISTANCE,10);
     }
   void DestroyUI()
     {
      ObjectDelete(0,"MT5_BTN_LOGS"); ObjectDelete(0,"MT5_BTN_MODE");
     }
   void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
     {
      if(id==CHARTEVENT_OBJECT_CLICK)
        {
         if(sparam=="MT5_BTN_LOGS") { EnableDetailedLogs = !EnableDetailedLogs; Print("EnableDetailedLogs toggled: "+(EnableDetailedLogs?"ON":"OFF")); }
         if(sparam=="MT5_BTN_MODE") { ConfirmMTF_Mode = (ConfirmMTF_Mode==MODE_REGIME_MA)?MODE_MA_ONLY:MODE_REGIME_MA; Print("ConfirmMTF_Mode set to "+IntegerToString(ConfirmMTF_Mode)); }
        }
     }
   void OnTimer() { /* reserved for future UI updates */ }
   void UpdateDashboard(string symbol,int m5Signal, CHTFVolatilityFilter &volFilter, double patternScore, bool allowed, string reason)
     {
      string lines="";
      lines += "SYMBOL: "+symbol+"\n";
      lines += "M5 Signal: "+((m5Signal==1)?"BUY":(m5Signal==-1?"SELL":"NEUTRAL"))+"\n";
      lines += "M15: "+RegimeToString(volFilter.GetRegimeM15())+" ATR%:"+DoubleToString(volFilter.GetATRPercentM15(),3)+"\n";
      lines += "H1 : "+RegimeToString(volFilter.GetRegimeH1())+" ATR%:"+DoubleToString(volFilter.GetATRPercentH1(),3)+"\n";
      lines += "PatternScore: "+DoubleToString(patternScore,3)+"\n";
      lines += "Overall: "+(allowed?"ALLOWED":"BLOCKED - "+reason)+"\n";
      logger.Dashboard(lines);
     }
  };

CChartUI chartUI;
