//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "© GM, 2020, 2021, 2022, 2023"
#property description "Spread Regression"

#property indicator_separate_window
//#property indicator_minimum 0
//#property indicator_maximum 100

#property indicator_buffers 5
#property indicator_plots   5
#property indicator_type1   DRAW_LINE
#property indicator_type2   DRAW_LINE
#property indicator_type3   DRAW_LINE
#property indicator_type4   DRAW_LINE
#property indicator_type5   DRAW_LINE
//#property indicator_type6   DRAW_LINE
//#property indicator_type7   DRAW_LINE
//#property indicator_type8   DRAW_LINE
//#property indicator_type9   DRAW_LINE
//#property indicator_type10   DRAW_LINE
//#property indicator_type11   DRAW_LINE
//#property indicator_type12   DRAW_LINE
//#property indicator_type13   DRAW_LINE
//#property indicator_type14   DRAW_LINE
//#property indicator_type15   DRAW_LINE
//#property indicator_type16   DRAW_LINE
//#property indicator_type17   DRAW_LINE
//#property indicator_type18   DRAW_LINE
//#property indicator_type19   DRAW_LINE

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input string ativo1 = "DOL$";
input string ativo2 = "WIN$";
input string ativo3 = "";
input double referencia1 = 0;
input double referencia2 = 0;
input double referencia3 = 0;
input color    colorSpread                            = clrYellow;     // Cor do spread
input color    colorAtivo1                  = clrRed;         // Cor ativo 1
input color    colorAtivo2                    = clrLime;        // Cor ativo 2
input color    colorAtivo3                    = clrDodgerBlue;        // Cor ativo 3
input int      espessura_linha                     = 2;              // Espessura da linha
input double   levelUp                             = 70;             // Nível da linha de sobrecompra
input double   levelDown                           = 30;             // Nível da linha de sobrevenda
input int      limitCandles                        = 200;           // O cálculo será feito somente a partir do número de candles definido
input int      WaitMilliseconds                    = 2000;           // Timer (milliseconds) for recalculation
input datetime                   DefaultInitialDate              = "2022.8.1 9:00:00";          // Data inicial padrão
input bool                       debug = false;
input bool     enableX = false;
input bool     useExtremeHL = true;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input double percentual = 0.3;
//--- indicator buffers
double    spreadBuffer[];
double    bufferAtivo1[];
double    bufferAtivo2[];
double    bufferAtivo3[];
double    bufferAtivoX[];

//double regChannelBuffer[];
//double Channel1[], Channel2[], Channel3[], Channel4[], Channel5[], Channel6[], Channel7[], Channel8[], Channel9[], Channel10[], Channel11[], Channel12[];
double A, B, stdev;
datetime data_inicial;
int barFrom;
//double    winClose[];
//double    wdoClose[];

//datetime winTime[];
//datetime wdoTime[];
long totalRates;
int rateCount;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

//--- indicator buffers mapping
   SetIndexBuffer(0, spreadBuffer, INDICATOR_DATA);
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetInteger(0, PLOT_LINE_WIDTH, espessura_linha);
   PlotIndexSetInteger(0, PLOT_LINE_COLOR, 0, colorSpread);

//PlotIndexSetInteger(0,PLOT_ARROW,159);
   SetIndexBuffer(1, bufferAtivo1, INDICATOR_DATA);
   SetIndexBuffer(2, bufferAtivo2, INDICATOR_DATA);
   SetIndexBuffer(3, bufferAtivo3, INDICATOR_DATA);
   SetIndexBuffer(4, bufferAtivoX, INDICATOR_DATA);

//ArrayInitialize(regChannelBuffer, 0);
//ArrayInitialize(Channel1, 0);
//ArrayInitialize(Channel2, 0);
//ArrayInitialize(Channel3, 0);
//ArrayInitialize(Channel4, 0);
//ArrayInitialize(Channel5, 0);
//ArrayInitialize(Channel6, 0);
//ArrayInitialize(Channel7, 0);
//ArrayInitialize(Channel8, 0);
//ArrayInitialize(Channel9, 0);
//ArrayInitialize(Channel10, 0);
//ArrayInitialize(Channel11, 0);
//ArrayInitialize(Channel12, 0);

//   SetIndexBuffer(5, regChannelBuffer, INDICATOR_DATA);
//   SetIndexBuffer(6, Channel1, INDICATOR_DATA);
//   SetIndexBuffer(7, Channel2, INDICATOR_DATA);
//   SetIndexBuffer(8, Channel3, INDICATOR_DATA);
//   SetIndexBuffer(9, Channel4, INDICATOR_DATA);
//   SetIndexBuffer(10, Channel5, INDICATOR_DATA);
//   SetIndexBuffer(11, Channel6, INDICATOR_DATA);
//   SetIndexBuffer(12, Channel7, INDICATOR_DATA);
//   SetIndexBuffer(13, Channel8, INDICATOR_DATA);
//   SetIndexBuffer(14, Channel9, INDICATOR_DATA);
//   SetIndexBuffer(15, Channel10, INDICATOR_DATA);
//   SetIndexBuffer(16, Channel11, INDICATOR_DATA);
//   SetIndexBuffer(17, Channel12, INDICATOR_DATA);
//
//   ArraySetAsSeries(regChannelBuffer, true);
//   ArraySetAsSeries(Channel1, true);
//   ArraySetAsSeries(Channel2, true);
//   ArraySetAsSeries(Channel3, true);
//   ArraySetAsSeries(Channel4, true);
//   ArraySetAsSeries(Channel5, true);
//   ArraySetAsSeries(Channel6, true);
//   ArraySetAsSeries(Channel7, true);
//   ArraySetAsSeries(Channel8, true);
//   ArraySetAsSeries(Channel9, true);
//   ArraySetAsSeries(Channel10, true);
//   ArraySetAsSeries(Channel11, true);
//   ArraySetAsSeries(Channel12, true);

//PlotIndexSetInteger(5, PLOT_LINE_COLOR, 0, clrYellow);
//PlotIndexSetInteger(6, PLOT_LINE_COLOR, 0, clrDarkOrange);
//PlotIndexSetInteger(7, PLOT_LINE_COLOR, 0, clrDarkOrange);
//PlotIndexSetInteger(8, PLOT_LINE_COLOR, 0, clrDarkOrange);
//PlotIndexSetInteger(9, PLOT_LINE_COLOR, 0, clrDarkOrange);
//PlotIndexSetInteger(10, PLOT_LINE_COLOR, 0, clrDarkOrange);
//PlotIndexSetInteger(11, PLOT_LINE_COLOR, 0, clrDarkOrange);
//PlotIndexSetInteger(12, PLOT_LINE_COLOR, 0, clrDarkOrange);
//PlotIndexSetInteger(13, PLOT_LINE_COLOR, 0, clrDarkOrange);
//PlotIndexSetInteger(14, PLOT_LINE_COLOR, 0, clrDarkOrange);
//PlotIndexSetInteger(15, PLOT_LINE_COLOR, 0, clrDarkOrange);
//PlotIndexSetInteger(16, PLOT_LINE_COLOR, 0, clrDarkOrange);
//PlotIndexSetInteger(17, PLOT_LINE_COLOR, 0, clrDarkOrange);

//PlotIndexSetDouble(5, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(6, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(7, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(8, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(9, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(10, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(11, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(12, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(13, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(14, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(15, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(16, PLOT_EMPTY_VALUE, 0.0);
//PlotIndexSetDouble(17, PLOT_EMPTY_VALUE, 0.0);

   data_inicial = DefaultInitialDate;
   barFrom = iBarShift(NULL, PERIOD_CURRENT, data_inicial);

   PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetDouble(3, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetDouble(4, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetString(1, PLOT_LABEL, ativo1);
   PlotIndexSetString(2, PLOT_LABEL, ativo2);
   PlotIndexSetString(3, PLOT_LABEL, ativo3);
   PlotIndexSetString(4, PLOT_LABEL, "DOL+DI1");
   PlotIndexSetInteger(1, PLOT_LINE_COLOR, 0, colorAtivo1);
   PlotIndexSetInteger(2, PLOT_LINE_COLOR, 0, colorAtivo2);
   PlotIndexSetInteger(3, PLOT_LINE_COLOR, 0, colorAtivo3);
   PlotIndexSetInteger(4, PLOT_LINE_COLOR, 0, clrPurple);

   ArraySetAsSeries(spreadBuffer, true);
   ArraySetAsSeries(bufferAtivo1, true);
   ArraySetAsSeries(bufferAtivo2, true);
   ArraySetAsSeries(bufferAtivo3, true);
   ArraySetAsSeries(bufferAtivoX, true);

   IndicatorSetInteger(INDICATOR_LEVELS, 29);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 0, percentual * 1);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 1, percentual * 2);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 2, percentual * 3);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 3, percentual * 4);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 4, percentual * 5);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 5, percentual * 6);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 6, percentual * 7);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 7, percentual * 8);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 8, percentual * 9);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 9, percentual * 10);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 10, percentual * 11);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 11, percentual * 12);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 25, percentual * 13);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 26, percentual * 14);

   IndicatorSetDouble(INDICATOR_LEVELVALUE, 12, percentual * -1);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 13, percentual * -2);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 14, percentual * -3);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 15, percentual * -4);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 16, percentual * -5);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 17, percentual * -6);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 18, percentual * -7);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 19, percentual * -8);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 20, percentual * -9);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 21, percentual * -10);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 22, percentual * -11);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 23, percentual * -12);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 27, percentual * -13);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 28, percentual * -14);

   IndicatorSetDouble(INDICATOR_LEVELVALUE, 24, 0);

   for (int i = 0; i < 12; i++) {
      IndicatorSetInteger(INDICATOR_LEVELCOLOR, i, C'45,45,45');
      IndicatorSetInteger(INDICATOR_LEVELSTYLE, i, STYLE_DOT);
      IndicatorSetInteger(INDICATOR_LEVELWIDTH, i, 1);
   }

   for (int i = 12; i < 29; i++) {
      IndicatorSetInteger(INDICATOR_LEVELCOLOR, i, C'45,45,45');
      IndicatorSetInteger(INDICATOR_LEVELSTYLE, i, STYLE_DOT);
      IndicatorSetInteger(INDICATOR_LEVELWIDTH, i, 1);
   }

   IndicatorSetInteger(INDICATOR_LEVELCOLOR, 24, clrYellow);
   IndicatorSetInteger(INDICATOR_LEVELSTYLE, 24, STYLE_DOT);
   IndicatorSetInteger(INDICATOR_LEVELWIDTH, 24, 1);

   IndicatorSetInteger(INDICATOR_DIGITS, 2);
   IndicatorSetString(INDICATOR_SHORTNAME, "Spread " + ativo1 + " x " + ativo2);

   totalRates = SeriesInfoInteger(_Symbol, PERIOD_CURRENT, SERIES_BARS_COUNT);
   if (totalRates >= limitCandles)
      totalRates = limitCandles;

   _updateTimer = new MillisecondTimer(WaitMilliseconds, false);
//_lastOK = false;
   CheckTimer();

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Relative Strength Index                                          |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated, const int begin, const double &price[]) {
   return (1);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Update() {

   totalRates = SeriesInfoInteger(_Symbol, PERIOD_CURRENT, SERIES_BARS_COUNT);
   if (totalRates >= barFrom)
      totalRates = barFrom;

   int lastIndex = totalRates - 1;

   if (lastIndex <= 0)
      return false;

   if (ArraySize(spreadBuffer) <= 0)
      return false;

   double price1, price2, price3;
   double fech1, fech2, fech3;
   datetime ontem, atual;

   ArrayInitialize(spreadBuffer, 0);
   ArrayInitialize(bufferAtivo1, 0);
   ArrayInitialize(bufferAtivo2, 0);
   ArrayInitialize(bufferAtivo3, 0);

   for(int i = 0; i <= lastIndex - 1; i++) {

      if (_Period == PERIOD_D1 || _Period == PERIOD_W1 || _Period == PERIOD_MN1) {
         int barOntem = i + 1;

         ontem = iTime(ativo1, PERIOD_CURRENT, i + 1);
         atual = iTime(ativo1, PERIOD_CURRENT, i);

         if (referencia1 <= 0)
            fech1 = iClose(ativo1, PERIOD_CURRENT, iBarShift(ativo1, PERIOD_CURRENT, ontem));
         else
            fech1 = referencia1;

         if (referencia2 <= 0)
            fech2 = iClose(ativo2, PERIOD_CURRENT, iBarShift(ativo2, PERIOD_CURRENT, ontem));
         else
            fech2 = referencia2;

         price1 = iClose(ativo1, PERIOD_CURRENT, iBarShift(ativo1, PERIOD_CURRENT, atual));
         price2 = iClose(ativo2, PERIOD_CURRENT, iBarShift(ativo2, PERIOD_CURRENT, atual));


         if (ativo3 != "") {
            if (referencia3 <= 0)
               fech3 = iClose(ativo3, PERIOD_CURRENT, iBarShift(ativo3, PERIOD_CURRENT, ontem));
            else
               fech3 = referencia3;

            price3 = iClose(ativo3, PERIOD_CURRENT, iBarShift(ativo3, PERIOD_CURRENT, atual));
         }

      } else {

         ontem = StringToTime(TimeToString(iTime(ativo1, PERIOD_CURRENT, i)  - PeriodSeconds(PERIOD_D1), TIME_DATE));
         atual = iTime(ativo1, PERIOD_CURRENT, i);
         int barOntem = iBarShift(ativo1, PERIOD_CURRENT, ontem);

         if (referencia1 <= 0)
            fech1 = iClose(ativo1, PERIOD_D1, iBarShift(ativo1, PERIOD_D1, ontem));
         else
            fech1 = referencia1;

         if (referencia2 <= 0)
            fech2 = iClose(ativo2, PERIOD_D1, iBarShift(ativo2, PERIOD_D1, ontem));
         else
            fech2 = referencia2;

         price1 = iClose(ativo1, PERIOD_CURRENT, iBarShift(ativo1, PERIOD_CURRENT, atual));
         price2 = iClose(ativo2, PERIOD_CURRENT, iBarShift(ativo2, PERIOD_CURRENT, atual));

         if (ativo3 != "") {
            if (referencia3 <= 0)
               fech3 = iClose(ativo3, PERIOD_D1, iBarShift(ativo3, PERIOD_D1, ontem));
            else
               fech3 = referencia3;

            price3 = iClose(ativo3, PERIOD_CURRENT, iBarShift(ativo3, PERIOD_CURRENT, atual));
         }
         int u = 0;
      }

      if (price1 >= fech1) {
         bufferAtivo1[i] = (price1 / fech1 - 1) * 100;
      } else {
         bufferAtivo1[i] = (1 - price1 / fech1) * -100;
      }

      if (price2 >= fech2) {
         bufferAtivo2[i] = (price2 / fech2 - 1) * 100;
      } else {
         bufferAtivo2[i] = (1 - price2 / fech2) * -100;
      }

      if (ativo3 != "") {
         if (price3 >= fech3) {
            bufferAtivo3[i] = (price3 / fech3 - 1) * 100;
         } else {
            bufferAtivo3[i] = (1 - price3 / fech3) * -100;
         }
      } else {
         bufferAtivo3[i] = 0;
      }

      if (enableX)
         bufferAtivoX[i] = (bufferAtivo2[i] + bufferAtivo3[i]) ;
      //bufferAtivoX[i] = MathAbs(bufferAtivo2[i] + bufferAtivo3[i]) / MathAbs(bufferAtivo1[i]);
      else
         bufferAtivoX[i] = 0;

      if (bufferAtivo1[i] >= 0 && bufferAtivo2[i] >= 0) {
         spreadBuffer[i] = MathAbs(bufferAtivo1[i] - (bufferAtivo2[i] + bufferAtivo3[i]));
      } else if ((bufferAtivo2[i] + bufferAtivo3[i]) < 0 && bufferAtivo1[i] < 0) {
         spreadBuffer[i] = MathAbs(bufferAtivo1[i] - (bufferAtivo2[i] + bufferAtivo3[i]));
      } else {
         spreadBuffer[i] = MathAbs(bufferAtivo1[i]) + MathAbs((bufferAtivo2[i] + bufferAtivo3[i]));
      }

      if (useExtremeHL) {
         if (bufferAtivo1[i] >= 0) {
            bufferAtivo1[i] = (iHigh(ativo1, PERIOD_CURRENT, iBarShift(ativo1, PERIOD_CURRENT, atual)) / fech1 - 1) * 100;
         } else {
            bufferAtivo1[i] = (iLow(ativo1, PERIOD_CURRENT, iBarShift(ativo1, PERIOD_CURRENT, atual)) / fech1 - 1) * 100;
         }

         if (bufferAtivo2[i] >= 0) {
            bufferAtivo2[i] = (iHigh(ativo2, PERIOD_CURRENT, iBarShift(ativo2, PERIOD_CURRENT, atual)) / fech2 - 1) * 100;
         } else {
            bufferAtivo2[i] = (iLow(ativo2, PERIOD_CURRENT, iBarShift(ativo2, PERIOD_CURRENT, atual)) / fech2 - 1) * 100;
         }
      }

      spreadBuffer[i] = bufferAtivo1[i] - (bufferAtivo2[i] + bufferAtivo3[i]);

   }

//   double dataArray[];
//   ArrayCopy(dataArray, spreadBuffer);
//   ArrayReverse(dataArray);
//   barFrom = iBarShift(NULL, PERIOD_CURRENT, data_inicial);
//
//   CalcAB(dataArray, 0, barFrom, A, B);
//   stdev = GetStdDev(dataArray, 0, barFrom); //calculate standand deviation
//
//   for(int n = 0; n < ArraySize(regChannelBuffer) - 1; n++) {
//      regChannelBuffer[n] = 0.0;
//      Channel1[n] = 0.0;
//      Channel2[n] = 0.0;
//      Channel3[n] = 0.0;
//      Channel4[n] = 0.0;
//      Channel5[n] = 0.0;
//      Channel6[n] = 0.0;
//      Channel7[n] = 0.0;
//      Channel8[n] = 0.0;
//      Channel9[n] = 0.0;
//      Channel10[n] = 0.0;
//      Channel11[n] = 0.0;
//      Channel12[n] = 0.0;
//   }

//   double mult = 2;
//   for (int i = 0; i < barFrom  && !_StopFlag; i++) {
//      regChannelBuffer[i] = (A * (i) + B);
//
//      Channel1[i] = (A * (i) + B) - 3 * mult * stdev;
//      Channel2[i] = (A * (i) + B) - 2.5 * mult * stdev;
//      Channel3[i] = (A * (i) + B) - 2 * mult * stdev;
//      Channel4[i] = (A * (i) + B) - 1.5 * mult * stdev;
//      Channel5[i] = (A * (i) + B) - 1 * mult * stdev;
//      Channel6[i] = (A * (i) + B) - 0.5 * mult * stdev;
//
//      Channel7[i] = (A * (i) + B) + 2.5 * mult * stdev;
//      Channel8[i] = (A * (i) + B) + 0.5 * mult * stdev;
//      Channel9[i] = (A * (i) + B) + 1 * mult * stdev;
//      Channel10[i] = (A * (i) + B) + 1.5 * mult * stdev;
//      Channel11[i] = (A * (i) + B) + 2 * mult * stdev;
//      Channel12[i] = (A * (i) + B) + 3 * mult * stdev;
//   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(true);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer() {
   CheckTimer();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   delete(_updateTimer);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckTimer() {

   EventKillTimer();

   if(_updateTimer.Check() || !_lastOK) {
      _lastOK = Update();

      EventSetMillisecondTimer(WaitMilliseconds);

      ChartRedraw();
      if (debug) Print("Spread WIN-WDO " + " " + _Symbol + ":" + GetTimeFrame(Period()) + " ok");

      _updateTimer.Reset();
   } else {
      EventSetTimer(1);
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MillisecondTimer {

 private:
   int               _milliseconds;
 private:
   uint              _lastTick;

 public:
   void              MillisecondTimer(const int milliseconds, const bool reset = true) {
      _milliseconds = milliseconds;

      if(reset)
         Reset();
      else
         _lastTick = 0;
   }

 public:
   bool              Check() {
      uint now = getCurrentTick();
      bool stop = now >= _lastTick + _milliseconds;

      if(stop)
         _lastTick = now;

      return(stop);
   }

 public:
   void              Reset() {
      _lastTick = getCurrentTick();
   }

 private:
   uint              getCurrentTick() const {
      return(GetTickCount());
   }

};

bool _lastOK = false;
MillisecondTimer *_updateTimer;

//+---------------------------------------------------------------------+
//| GetTimeFrame function - returns the textual timeframe               |
//+---------------------------------------------------------------------+
string GetTimeFrame(int lPeriod) {
   switch(lPeriod) {
   case PERIOD_M1:
      return("M1");
   case PERIOD_M2:
      return("M2");
   case PERIOD_M3:
      return("M3");
   case PERIOD_M4:
      return("M4");
   case PERIOD_M5:
      return("M5");
   case PERIOD_M6:
      return("M6");
   case PERIOD_M10:
      return("M10");
   case PERIOD_M12:
      return("M12");
   case PERIOD_M15:
      return("M15");
   case PERIOD_M20:
      return("M20");
   case PERIOD_M30:
      return("M30");
   case PERIOD_H1:
      return("H1");
   case PERIOD_H2:
      return("H2");
   case PERIOD_H3:
      return("H3");
   case PERIOD_H4:
      return("H4");
   case PERIOD_H6:
      return("H6");
   case PERIOD_H8:
      return("H8");
   case PERIOD_H12:
      return("H12");
   case PERIOD_D1:
      return("D1");
   case PERIOD_W1:
      return("W1");
   case PERIOD_MN1:
      return("MN1");
   }
   return IntegerToString(lPeriod);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//Linear Regression Calculation for sample data: arr[]
//line equation  y = f(x)  = ax + b
void CalcAB(const double &arr[], int start, int end, double & a, double & b) {

   a = 0.0;
   b = 0.0;
   int size = MathAbs(start - end) + 1;
   if(size < 2)
      return;

   double sumxy = 0.0, sumx = 0.0, sumy = 0.0, sumx2 = 0.0;
   for(int i = start; i < end; i++) {
      sumxy += i * arr[i];
      sumy += arr[i];
      sumx += i;
      sumx2 += i * i;
   }

   double M = size * sumx2 - sumx * sumx;
   if(M == 0.0)
      return;

   a = (size * sumxy - sumx * sumy) / M;
   b = (sumy - a * sumx) / size;

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetStdDev(const double & arr[], int start, int end) {
   int size = MathAbs(start - end) + 1;
   if(size < 2)
      return(0.0);

   double sum = 0.0;
   for(int i = start; i < end; i++) {
      sum = sum + arr[i];
   }

   sum = sum / size;

   double sum2 = 0.0;
   for(int i = start; i < end; i++) {
      sum2 = sum2 + (arr[i] - sum) * (arr[i] - sum);
   }

   sum2 = sum2 / (size - 1);
   sum2 = MathSqrt(sum2);

   return(sum2);
}
//+------------------------------------------------------------------+
