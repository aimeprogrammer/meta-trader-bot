// ChartUI.mqh - Enhanced Digital UI
#pragma once

// Enhanced Chart UI for MT5 Expert Advisor
// Provides a compact dashboard on the chart with labeled fields and interactive buttons

class CChartUI
  {
private:
   string obj_bg       = "MT5_UI_BG";
   string obj_title    = "MT5_UI_TITLE";
   string obj_m5       = "MT5_UI_M5";
   string obj_m15      = "MT5_UI_M15";
   string obj_h1       = "MT5_UI_H1";
   string obj_overall  = "MT5_UI_OVERALL";
   string obj_info     = "MT5_UI_INFO";
   string btn_logs     = "MT5_BTN_LOGS";
   string btn_mode     = "MT5_BTN_MODE";

   // UI layout constants
   int corner = 0; // top-left
   int xdist  = 12;
   int ydist  = 12;
   int width  = 360;
   int height = 160;

public:
   // Create UI elements (idempotent)
   void CreateUI()
     {
      // Remove existing to avoid duplicates
      DestroyUI();

      // Background rectangle label
      if(!ObjectCreate(0,obj_bg,OBJ_RECTANGLE_LABEL,0,0,0)) {}
      ObjectSetInteger(0,obj_bg,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,obj_bg,OBJPROP_XDISTANCE,xdist);
      ObjectSetInteger(0,obj_bg,OBJPROP_YDISTANCE,ydist);
      ObjectSetInteger(0,obj_bg,OBJPROP_XSIZE,width);
      ObjectSetInteger(0,obj_bg,OBJPROP_YSIZE,height);
      ObjectSetInteger(0,obj_bg,OBJPROP_COLOR,clrGray);
      ObjectSetInteger(0,obj_bg,OBJPROP_BACKCOLOR,clrBlack);
      ObjectSetInteger(0,obj_bg,OBJPROP_TRANSPARENCY,70);

      // Title label
      if(!ObjectCreate(0,obj_title,OBJ_LABEL,0,0,0)) {}
      ObjectSetInteger(0,obj_title,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,obj_title,OBJPROP_XDISTANCE,xdist+8);
      ObjectSetInteger(0,obj_title,OBJPROP_YDISTANCE,ydist+6);
      ObjectSetString(0,obj_title,OBJPROP_TEXT,"MT5 AI Hybrid EA - Dashboard");
      ObjectSetInteger(0,obj_title,OBJPROP_FONTSIZE,12);
      ObjectSetInteger(0,obj_title,OBJPROP_COLOR,clrWhite);

      // M5 status
      if(!ObjectCreate(0,obj_m5,OBJ_LABEL,0,0,0)) {}
      ObjectSetInteger(0,obj_m5,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,obj_m5,OBJPROP_XDISTANCE,xdist+8);
      ObjectSetInteger(0,obj_m5,OBJPROP_YDISTANCE,ydist+30);
      ObjectSetString(0,obj_m5,OBJPROP_TEXT,"M5: --");
      ObjectSetInteger(0,obj_m5,OBJPROP_FONTSIZE,11);
      ObjectSetInteger(0,obj_m5,OBJPROP_COLOR,clrLime);

      // M15 status
      if(!ObjectCreate(0,obj_m15,OBJ_LABEL,0,0,0)) {}
      ObjectSetInteger(0,obj_m15,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,obj_m15,OBJPROP_XDISTANCE,xdist+8);
      ObjectSetInteger(0,obj_m15,OBJPROP_YDISTANCE,ydist+50);
      ObjectSetString(0,obj_m15,OBJPROP_TEXT,"M15: --");
      ObjectSetInteger(0,obj_m15,OBJPROP_FONTSIZE,11);
      ObjectSetInteger(0,obj_m15,OBJPROP_COLOR,clrYellow);

      // H1 status
      if(!ObjectCreate(0,obj_h1,OBJ_LABEL,0,0,0)) {}
      ObjectSetInteger(0,obj_h1,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,obj_h1,OBJPROP_XDISTANCE,xdist+8);
      ObjectSetInteger(0,obj_h1,OBJPROP_YDISTANCE,ydist+70);
      ObjectSetString(0,obj_h1,OBJPROP_TEXT,"H1: --");
      ObjectSetInteger(0,obj_h1,OBJPROP_FONTSIZE,11);
      ObjectSetInteger(0,obj_h1,OBJPROP_COLOR,clrAqua);

      // Overall status
      if(!ObjectCreate(0,obj_overall,OBJ_LABEL,0,0,0)) {}
      ObjectSetInteger(0,obj_overall,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,obj_overall,OBJPROP_XDISTANCE,xdist+8);
      ObjectSetInteger(0,obj_overall,OBJPROP_YDISTANCE,ydist+96);
      ObjectSetString(0,obj_overall,OBJPROP_TEXT,"Overall: --");
      ObjectSetInteger(0,obj_overall,OBJPROP_FONTSIZE,11);
      ObjectSetInteger(0,obj_overall,OBJPROP_COLOR,clrWhite);

      // Info (open trades, drawdown)
      if(!ObjectCreate(0,obj_info,OBJ_LABEL,0,0,0)) {}
      ObjectSetInteger(0,obj_info,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,obj_info,OBJPROP_XDISTANCE,xdist+200);
      ObjectSetInteger(0,obj_info,OBJPROP_YDISTANCE,ydist+30);
      ObjectSetString(0,obj_info,OBJPROP_TEXT,"Trades: 0 | DD: 0.00%");
      ObjectSetInteger(0,obj_info,OBJPROP_FONTSIZE,11);
      ObjectSetInteger(0,obj_info,OBJPROP_COLOR,clrWhite);

      // Buttons
      if(!ObjectCreate(0,btn_logs,OBJ_BUTTON,0,0,0)) {}
      ObjectSetInteger(0,btn_logs,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,btn_logs,OBJPROP_XDISTANCE,xdist+8);
      ObjectSetInteger(0,btn_logs,OBJPROP_YDISTANCE,ydist+122);
      ObjectSetString(0,btn_logs,OBJPROP_TEXT,"Toggle Logs");
      ObjectSetInteger(0,btn_logs,OBJPROP_FONTSIZE,10);

      if(!ObjectCreate(0,btn_mode,OBJ_BUTTON,0,0,0)) {}
      ObjectSetInteger(0,btn_mode,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,btn_mode,OBJPROP_XDISTANCE,xdist+120);
      ObjectSetInteger(0,btn_mode,OBJPROP_YDISTANCE,ydist+122);
      ObjectSetString(0,btn_mode,OBJPROP_TEXT,"Toggle HTF Mode");
      ObjectSetInteger(0,btn_mode,OBJPROP_FONTSIZE,10);
     }

   void DestroyUI()
     {
      string objs[] = {obj_bg,obj_title,obj_m5,obj_m15,obj_h1,obj_overall,obj_info,btn_logs,btn_mode};
      for(int i=0;i<ArraySize(objs);i++)
        {
         if(ObjectFind(0,objs[i])>=0) ObjectDelete(0,objs[i]);
        }
     }

   void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
     {
      if(id==CHARTEVENT_OBJECT_CLICK)
        {
         if(sparam==btn_logs)
           {
            extern bool EnableDetailedLogs;
            EnableDetailedLogs = !EnableDetailedLogs;
            Print("EnableDetailedLogs toggled: "+(EnableDetailedLogs?"ON":"OFF"));
           }
         else if(sparam==btn_mode)
           {
            extern int ConfirmMTF_Mode;
            ConfirmMTF_Mode = (ConfirmMTF_Mode==MODE_REGIME_MA)?MODE_MA_ONLY:MODE_REGIME_MA;
            Print("ConfirmMTF_Mode set to "+IntegerToString(ConfirmMTF_Mode));
           }
        }
     }

   // Update dashboard fields; minimal string lengths handled
   void UpdateDashboard(string symbol,int m5Signal, CHTFVolatilityFilter &volFilter, double patternScore, bool allowed, string reason)
     {
      string m5s = (m5Signal==1)?"BUY":(m5Signal==-1?"SELL":"NEUTRAL");
      string m15s = RegimeToString(volFilter.GetRegimeM15())+" | ATR:"+DoubleToString(volFilter.GetATRPercentM15(),3)+"%";
      string h1s = RegimeToString(volFilter.GetRegimeH1())+" | ATR:"+DoubleToString(volFilter.GetATRPercentH1(),3)+"%";
      string overall = (allowed?"ALLOWED":"BLOCKED") + ((allowed)?"":" - "+reason);

      ObjectSetString(0,obj_m5,OBJPROP_TEXT,"M5: "+m5s+" | Pattern:"+DoubleToString(patternScore,3));
      ObjectSetString(0,obj_m15,OBJPROP_TEXT,"M15: "+m15s);
      ObjectSetString(0,obj_h1,OBJPROP_TEXT,"H1:  "+h1s);
      ObjectSetString(0,obj_overall,OBJPROP_TEXT,"Overall: "+overall);

      double dayStartBalance = 0.0;
      extern double dayStartBalance;
      double ddPercent = 0.0;
      if(dayStartBalance>0) ddPercent = (dayStartBalance - AccountInfoDouble(ACCOUNT_BALANCE)) / dayStartBalance * 100.0;
      int openTrades = PositionsTotal();
      ObjectSetString(0,obj_info,OBJPROP_TEXT,"Trades: "+IntegerToString(openTrades)+" | DD: "+DoubleToString(ddPercent,2)+"%");
     }

   void OnTimer() { /* place for UI refresh actions if needed */ }
  };

CChartUI chartUI;
