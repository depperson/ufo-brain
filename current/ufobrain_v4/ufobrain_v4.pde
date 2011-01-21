/**
 * UFO Brain v.4.0
 * 
 * See the file 'comments' for comments.
 *
 * Daniel Epperson, 2010
 *
 */


// TI pwm controller library
#include "Tlc5940.h"



// knob values
int marker = 0;
int oscillator = 0;
int fineatten = 0;
int sweepwidth = 0;
int horphase = 0;
int markeramp = 0;

// switch values (1 means off)
int redswitch = 1;
int xtalswitch = 1;
int extmarkswitch = 1;
int markerampswitch = 1;
int phaseswitch = 1;
int attenswitch1 = 1;


// do not switch modes by default
//int attenswitch3 = 0;
//int attenswitch2 = 1; 

// do switch modes by default
int attenswitch3 = 1;
int attenswitch2 = 0;


// slow pattern player
int patternmode = 0;
int pm0_selected_pattern = 5;
int pm0_patterns_max = 5;




// this function only runs once, at application start
void setup() {

  // wake up the tlc
  Tlc.init();
  Tlc.clear();
  
  // blank the tlc channels at startup
  for (int clearit=10; clearit<=15; clearit++) {
    Tlc.set(clearit,4095);
  }
  Tlc.update();

  // blank the rgb leds
  r1update(0, 0, 0);
  r2update(0, 0, 0);
  
  // blank the green leds
  g1update(0);
  g2update(0);

  // enable serial
  Serial.begin(9600);
  Serial.println("Ufo brain starting.");
  
  // seed the random number generator
  randomSeed(analogRead(0));
  
} // setup() close




// main loop()
void loop() {
  
  // check for serial data, or fake it
  checkserial();

  // don't update anything while paused
  if (redswitch != 0) {
    
    // patternmode :
    // 0 draws one slow pattern onto all available leds
    // 1 draws one fast pattern onto all available leds
    switch (patternmode) {
      
      default:
      case 0:
        // patternmode==0 - one slow pattern controls all 8 channels
        patternmode0(pm0_selected_pattern);

        
        break;
    }
  
    Tlc.update();
    
  } // end pause detection if

} // loop() close
