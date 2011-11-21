#include <OLEDFourBit.h>
#include "globals.h"
#include "enums.h"


void setup()
{
  lcdText[0][20]='\0';
  lcdText[1][20]='\0';
  lcdText[2][20]='\0';
  lcdText[3][20]='\0';

  pinMode(coolingPin, OUTPUT);
  pinMode(heatingPin, OUTPUT);
  pinMode(doorPin, INPUT);
  // analog pins are input by default
  
  analogReference(2); //set analog reference to internal 1.1V
  delay(100);
  lcd.begin(20, 4);
  lcd.clear(); 
  lcdPrintStationaryText();
  loadSettings(); //read previous settings from EEPROM
  
  lcdPrintMode();
  Serial.begin(9600);
  initFilters();
  initControl();
  updateSettings();
  serialFridgeMessage(ARDUINO_START);
}

void loop()
{
  if(millis()-slowTimer > 10000){ //update slow filter every 10 seconds
    slowTimer=millis();
    updateSlowFilteredTemperatures();
    detectPeaks();
    updateSettings();
  }
  if(millis()- sampleTimer > 200){
    sampleTimer=millis();
    updateTemperatures();
  }
  if(millis()-fastTimer >1000){
    fastTimer=millis();
    updateState();
    lcdPrintState();
    updateOutputs(); 
    lcdPrintAllTemperatures();
    lcdPrintMode();

  }
 //listen for incoming serial connections while waiting top update
  handleSerialCommunication();  
  //Check if menu button is pressed
  if(analogRead(button3)>900){
    menu(MENU_TOP);
  }
}





