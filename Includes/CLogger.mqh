// CLogger.mqh
#pragma once

class CLogger
  {
public:
   void Log(string s)
     {
      extern bool EnableDetailedLogs;
      if(EnableDetailedLogs) Print(TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS)," | ",s);
     }
   void Dashboard(string text)
     {
      Comment(text);
     }
  };

// expose global
CLogger logger;
