#include "enums.h"
#include <OLEDFourBit.h>

// State variables
unsigned char state=STARTUP;
unsigned char previousState=IDLE;
unsigned char mode;
unsigned char doPosPeakDetect=0;
unsigned char doNegPeakDetect=0;

// Fast filtered temperatures
float beerTemperatureActual; 
float beerTemperatureSetting=20; 
float fridgeTemperatureActual; 
float fridgeTemperatureSetting=20;
float fridgeTempFiltFast[3];
float fridgeTempFast[3]; //input for filter
float beerTempFast[3];
float beerTempFiltFast[3];

// Slow filtered temperatures
float fridgeTempFiltSlow[3];
float fridgeTempSlow[3]; //input for filter
float beerTempSlow[3];
float beerTempFiltSlow[3];
float beerSlope;

// Control parameters
float heatOvershootEstimator;
float coolOvershootEstimator;
float fridgeSettingForNegPeakEstimate;
float fridgeSettingForPosPeakEstimate;
float negPeak;
float posPeak;
float differenceIntegral;

//Timers 
unsigned long slowTimer = 0;
unsigned long fastTimer = 0;
unsigned long sampleTimer = 0;
unsigned long lastCoolTime=0;
unsigned long lastHeatTime=0;
unsigned long lastIdleTime=0;

// LCD
OLEDFourBit lcd(3, 4, 5, 6, 7, 8, 9);
char lcdText[4][21];

