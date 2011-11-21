#include "globals.h"
#include "enums.h"

#define NUM_READS 100
float readTemperature(int sensorpin){
   // read multiple values and sort them to take the mode
   int sortedValues[NUM_READS];
   for(int i=0;i<NUM_READS;i++){
     int value = analogRead(sensorpin);
     int j;
     if(value<sortedValues[0] || i==0){
        j=0; //insert at first position
     }
     else{
       for(j=1;j<i;j++){
          if(sortedValues[j-1]<=value && sortedValues[j]>=value){
            // j is insert position
            break;
          }
       }
     }
     for(int k=i;k>j;k--){
       // move all values higher than current reading up one position
       sortedValues[k]=sortedValues[k-1];
     }
     sortedValues[j]=value; //insert current reading
   }
   //return scaled mode of 10 values
   float returnval = 0;
   for(int i=NUM_READS/2-5;i<(NUM_READS/2+5);i++){
     returnval +=sortedValues[i];
   }
   returnval = returnval/10;
   return returnval*1100/1023;
}

void updateTemperatures(void){ //called every 200 milliseconds  
   fridgeTempFast[0] = fridgeTempFast[1]; fridgeTempFast[1] = fridgeTempFast[2]; 
   fridgeTempFast[2] = readTemperature(fridgePin);   

   beerTempFast[0] = beerTempFast[1]; beerTempFast[1] = beerTempFast[2]; 
   beerTempFast[2] = readTemperature(beerPin);   
   
   // Butterworth filter with cutoff frequency 0.033*sample frequency (FS=5Hz)
   fridgeTempFiltFast[0] = fridgeTempFiltFast[1]; fridgeTempFiltFast[1] = fridgeTempFiltFast[2]; 
   fridgeTempFiltFast[2] =   (fridgeTempFast[0] + fridgeTempFast[2] + 2 * fridgeTempFast[1] )/106.9668733
               + ( -0.7458605806   * fridgeTempFiltFast[0]) + (  1.7084658258    * fridgeTempFiltFast[1]); 

   fridgeTemperatureActual = fridgeTempFiltFast[2];

   // Butterworth filter with cutoff frequency 0.01*sample frequency (FS=5Hz)
   beerTempFiltFast[0] = beerTempFiltFast[1]; beerTempFiltFast[1] = beerTempFiltFast[2]; 
   beerTempFiltFast[2] =   (beerTempFast[0] + beerTempFast[2] + 2 * beerTempFast[1] )/1058.546241
               + ( -0.9149758348   * beerTempFiltFast[0]) + (  1.9111970674     * beerTempFiltFast[1]); 

   beerTemperatureActual = beerTempFiltFast[2];
}

void updateSlowFilteredTemperatures(void){ //called every 10 seconds
   // Input for filter
   fridgeTempSlow[0] = fridgeTempSlow[1]; fridgeTempSlow[1] = fridgeTempSlow[2]; 
   fridgeTempSlow[2] = fridgeTemperatureActual;
   
   // Butterworth filter with cutoff frequency 0.01*sample frequency. Used for peak detection
   fridgeTempFiltSlow[0] = fridgeTempFiltSlow[1]; fridgeTempFiltSlow[1] = fridgeTempFiltSlow[2]; 
   fridgeTempFiltSlow[2] =   (fridgeTempSlow[0] + fridgeTempSlow[2] + 2 * fridgeTempSlow[1])/1058.546241
               + ( -0.9149758348  * fridgeTempFiltSlow[0]) + (  1.9111970674 * fridgeTempFiltSlow[1]);
               
   beerTempSlow[0] = beerTempSlow[1]; beerTempSlow[1] = beerTempSlow[2]; 
   beerTempSlow[2] = beerTemperatureActual;

   // Butterworth filter with cutoff frequency 0.003*sample frequency.   
   beerTempFiltSlow[0] = beerTempFiltSlow[1]; beerTempFiltSlow[1] = beerTempFiltSlow[2]; 
   beerTempFiltSlow[2] =   (beerTempSlow[0] + beerTempSlow[2] + 2 * beerTempSlow[1])/11408.29091
               + ( -0.9736948720    * beerTempFiltSlow[0]) + (  1.9733442498  * beerTempFiltSlow[1]);
         
   beerSlope = (beerTempFiltSlow[2]-beerTempFiltSlow[0])/2;
}

void initFilters(void){
  beerTemperatureActual = readTemperature(beerPin);
  fridgeTemperatureActual = readTemperature(fridgePin);
  for(int i=0;i<3;i++){
    fridgeTempFast[i]=fridgeTemperatureActual;
    fridgeTempFiltFast[i]=fridgeTemperatureActual;
    beerTempFast[i]=beerTemperatureActual;
    beerTempFiltFast[i]=beerTemperatureActual;
    
  }
  for(int i=0;i<100;i++){
    updateTemperatures();
  }
  for(int i=0;i<3;i++){
    fridgeTempSlow[i]=fridgeTempFiltFast[2];
    fridgeTempFiltSlow[i]=fridgeTempFiltFast[2];
    beerTempSlow[i]=beerTempFiltFast[2];
    beerTempFiltSlow[i]=beerTempFiltFast[2];
  }
  for(int i=0;i<100;i++){
    updateSlowFilteredTemperatures();
  }
}
