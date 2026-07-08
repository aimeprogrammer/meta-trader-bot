// CPatternRecognizer.mqh
#pragma once
#include <Mathandom.mqh>

#define PATTERN_LENGTH 20

class CPatternRecognizer
  {
private:
   double patterns[][];
   double winRates[];
public:
   CPatternRecognizer() {}
   void ClearDatabase()
     {
      ArrayResize(patterns,0);
      ArrayResize(winRates,0);
     }
   int GetDatabaseSize() { return ArraySize(winRates); }
   void AddPattern(const double vec[], double winRate)
     {
      int idx = ArraySize(winRates);
      ArrayResize(winRates,idx+1);
      ArrayResize(patterns,idx+1);
      ArrayResize(patterns[idx],PATTERN_LENGTH);
      for(int i=0;i<PATTERN_LENGTH;i++) patterns[idx][i] = vec[i];
      winRates[idx] = winRate;
     }

   bool BuildCurrentPattern(string symbol, ENUM_TIMEFRAMES tf, double outPattern[])
     {
      if(Bars(symbol,tf) < PATTERN_LENGTH+5) return false;
      double closes[]; ArrayResize(closes,PATTERN_LENGTH+1);
      for(int i=0;i<=PATTERN_LENGTH;i++) closes[i] = iClose(symbol,tf,i);
      double returns[]; ArrayResize(returns,PATTERN_LENGTH);
      for(int i=0;i<PATTERN_LENGTH;i++) returns[i] = (closes[i]-closes[i+1])/(MathAbs(closes[i+1])+1e-9);
      double maxabs=0; for(int i=0;i<PATTERN_LENGTH;i++) if(fabs(returns[i])>maxabs) maxabs=fabs(returns[i]); if(maxabs<1e-9) maxabs=1.0;
      for(int i=0;i<PATTERN_LENGTH;i++) outPattern[i] = returns[i]/maxabs;
      return true;
     }

   double PatternScore(const double pattern[])
     {
      int db = ArraySize(winRates);
      if(db==0) return 0.0;
      double distances[]; ArrayResize(distances,db);
      for(int i=0;i<db;i++) distances[i] = euclidean(pattern, patterns[i]);
      double sumWin=0.0;
      for(int k=0;k<5 && k<db;k++)
        {
         int best=-1; double bestd=DBL_MAX;
         for(int i=0;i<db;i++) if(distances[i]>=0 && distances[i]<bestd) { bestd=distances[i]; best=i; }
         if(best==-1) break;
         sumWin += winRates[best]; distances[best] = -1.0;
        }
      return (sumWin / (double)MathMin(5,db));
     }

private:
   double euclidean(const double a[], const double b[])
     {
      double s=0;
      for(int i=0;i<PATTERN_LENGTH;i++) s += (a[i]-b[i])*(a[i]-b[i]);
      return MathSqrt(s);
     }
  };

CPatternRecognizer patternRecognizer;
