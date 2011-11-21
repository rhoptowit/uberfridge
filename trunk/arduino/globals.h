#ifndef GLOBALS_H
#define GLOBALS_H

// pins
#define beerPin    A0
#define fridgePin  A1

//ADC 6 and 7 are not available as digital pins. Use analogRead() to read the buttons.
#define button1    A7
#define button2    A6
#define button3    A5

#define coolingPin 10 
#define heatingPin 11 
#define doorPin    12
 

// State variables
extern unsigned char mode; // Constant beer temperature, constant fridge temperature or beer temperature profile;
extern unsigned char state;
extern unsigned char previousState;
extern unsigned char doPosPeakDetect;
extern unsigned char doNegPeakDetect;

// Fast filtered temperatures
extern float beerTemperatureActual;
extern float beerTemperatureSetting;
extern float fridgeTemperatureActual;
extern float fridgeTemperatureSetting;

extern float fridgeTempFiltFast[3]; // Filtered data from sensors
extern float fridgeTempFast[3];     // Input from filter

// Slow filtered Temperatures used for peak detection
extern float fridgeTempFiltSlow[3];
extern float fridgeTempSlow[3];
extern float beerTempFast[3];
extern float beerTempFiltFast[3];
extern float beerTempSlow[3];
extern float beerTempFiltSlow[3];
extern float beerSlope;

//filtered setting for fridge temperature
//extern float fridgeSetting[3];
//extern float fridgeSettingInput[3];

// Control parameters
extern float heatOvershootEstimator;
extern float coolOvershootEstimator;
extern float fridgeSettingForNegPeakEstimate;
extern float fridgeSettingForPosPeakEstimate;
extern float negPeak;
extern float posPeak;
extern float differenceIntegral;

//Timers 
extern unsigned long slowTimer;
extern unsigned long fastTimer;
extern unsigned long sampleTimer;
extern unsigned long lastCoolTime;
extern unsigned long lastHeatTime;
extern unsigned long lastIdleTime;

// LCD
extern char lcdText[4][21];
extern OLEDFourBit lcd;

#endif
