/*
 * UFO for Flipside - Standalone Edition 
 *
 * Daniel Epperson, 05/2010
 *
 * I hope the comments are enough to let you get your tweak on.
 * (look for CHANGEME)
 */
 
#include "Tlc5940.h"


// you probably dont want to mess with this stuff
int g1pin = 5;                     // green leds on pins 5,6
int g2pin = 6;
int ledoffset = 10;                // using channels 10-15 on the TLC
int foo=0;
int bar=0;                         // mmhmm


// define modes and mode changers
// CHANGEME: You should mess with this stuff
int luxmode;
int rgbmode;
int luxmode_max = 7;                // CHANGEME: If you add more modes
int rgbmode_max = 7;                // CHANGEME: If you add more modes
long int modeselect_cycle = 0;
long int modeselect_cycle_divider = 250000;        // this gets changed immediately
long int modeselect_cycle_divider_max = 5000000;   // CHANGEME: Maximum time per pattern

// CHANGEME: Limit (or don't) the duration of a freakout session
long int freakout_limit = 50;
//long int freakout_limit = modeselect_cycle_divider_max;



// lux modes (green only leds)

// define variables for lux mode 1
// ibook breath 
int lux_mode1_dir = 0;              // fader starting direction (down)
int lux_mode1_fadeval = 200;        // fader starting value (max)
int lux_mode1_fader_jump = 1;       // increment fade value by this number each step
int lux_mode1_fader_max = 200;      // fader max value
int lux_mode1_fader_min = 0;        // fader min value
long int lux_mode1_cycle_divider = 280;   // how often to step the fade (more means less)
long int lux_mode1_cycle = 0;

// variables for lux mode 2
// chase pattern
long int lux_mode2_cycle_divider = 20000;   
long int lux_mode2_cycle = 0;
int lux_mode2_activeled = 0;              // chase pattern, which led is active

// lux mode 3 is freakout mode
// lux mode 4 pauses the green leds
// lux mode 5 is dim
// lux mode 6 is ring 1
// lux mode 7 is ring 2 with ring 1 glowing




// rgb modes

// define variables for rgb mode 1
// inverted ibook breath
int rgb_mode1_dir = 1;              // fader starting direction (up)
int rgb_mode1_fadeval = 0;          // fader starting value (min)
int rgb_mode1_fader_jump = 20;       // increment fade value by this number each step
int rgb_mode1_fader_max = 4000;      // fader max value
int rgb_mode1_fader_min = 0;        // fader min value
long int rgb_mode1_cycle_divider = 1200;   // how often to step the fade (more means less)
long int rgb_mode1_cycle = 0;

// define variables for rgb mode 2
// set luxmode to 1 and mirror it
long int rgb_mode2_cycle_divider = 3;   // how often to step the fade (more means less)
long int rgb_mode2_cycle = 0;

// define variables for rgb mode 3
// just freak the fuck out 
long int rgb_mode3_cycle_divider = 1200;   // how often to step the fade (more means less)
long int rgb_mode3_cycle = 0;

// rgb mode 4 variables
// random colors with a slow, smooth fade
long int rgb_mode4_cycle_divider = 200;   // CHANGEME: Color fading step speed (more means slower)
long int rgb_mode4_cycle = 0;
long int rgb_mode4_color_picker_cycle_divider = 200;     // CHANGEME: Color changing frequency (more means slower)
long int rgb_mode4_color_picker_cycle = 0;
long int rgb_mode4_fader_jump = 20;      // CHANGEME: Color fading increment (more means faster)
long int rgb_mode4_led_cur[6];
long int rgb_mode4_led_dest[6];
int rgb_mode4_color_picker_firstrun = 0;
int yyy = 0;
int zzz = 0;

// rgb mode 5 is just another freakout, sets luxmode=3
// rgb mode 6 is mode 1 but white
// rgb mode 7 is dim red




// introduce a generic delay (in microseconds) to patterns that require it
long int generic_delay = 10;


void setup()
{

  Tlc.init();
  Tlc.clear();

  // blank the LEDs at startup
  for (int clearit=0; clearit<6; clearit++) {
    Tlc.set(clearit+ledoffset,4095);
  }
  Tlc.update();

  Serial.begin(9600);
  Serial.println("startup");
  
  //luxmode=random(1,luxmode_max);
  //rgbmode=random(1,rgbmode_max);
  
  luxmode=1;
  rgbmode=2;
  
  
  Serial.print("luxmode=");
  Serial.print(luxmode);
  Serial.print(" rgbmode=");
  Serial.print(rgbmode);
  Serial.println("");
}


// main code loop
void loop()
{
  // CHANGEME: Uncomment the following line for the DJ Screw version
  //delayMicroseconds(20);
  
  // CHANGEME: Comment the following line to disable mode changing
  modeselect_cycle++;
  if (modeselect_cycle >= modeselect_cycle_divider) {
    Serial.println("modeselect");
    modeselect_cycle = 0;
    modeselect_cycle_divider = random(modeselect_cycle_divider_max);
    
    // CHANGEME: Odds are against changing the mode even if it is time 
    if (random(100) > 60) luxmode=random(1,luxmode_max+1);
    if (random(100) > 60) rgbmode=random(1,rgbmode_max+1);
    
    /*
    Serial.print("luxmode=");
    Serial.print(luxmode);
    Serial.print(" rgbmode=");
    Serial.print(rgbmode);
    Serial.print(" modeselect_cycle_divider=");
    Serial.print(modeselect_cycle_divider);
    Serial.println("");
    */
    
  }    
  
  switch (luxmode) {
  
      case 1:
        // mode 1 for green leds, do an ibook style breathing pulse
        lux_mode1_cycle++;
        if (lux_mode1_cycle == lux_mode1_cycle_divider) {
          lux_mode1_cycle = 0;
          analogWrite(g1pin, lux_mode1_fadeval);
          analogWrite(g2pin, lux_mode1_fadeval);
          if (lux_mode1_dir == 1) {
            // going up
            if (lux_mode1_fadeval >= lux_mode1_fader_max) { 
              // max reached, change directions
              lux_mode1_fadeval -= lux_mode1_fader_jump; 
              lux_mode1_dir = 0; 
            } else { 
              lux_mode1_fadeval += lux_mode1_fader_jump; 
            }
          } else {
            if (lux_mode1_dir == 0) {
              // going down
              if (lux_mode1_fadeval <= lux_mode1_fader_min) { 
                // min reached, change directions
                lux_mode1_fadeval += lux_mode1_fader_jump; 
                lux_mode1_dir = 1; 
              } else { 
                lux_mode1_fadeval -= lux_mode1_fader_jump; 
              }
            }
          } // closing directional if statement
        } // closing cycle divider if statement
        // rgbmode 4 is slow, run the delay for everything else
        if (rgbmode != 4) delayMicroseconds(generic_delay);
        break;
        
      case 2:
        // chase pattern
        lux_mode2_cycle++;
        if (lux_mode2_cycle == lux_mode2_cycle_divider) {
          lux_mode2_cycle = 0;
          // blah
          if (lux_mode2_activeled == 0) {
            lux_mode2_activeled = 1;
            analogWrite(g1pin, 100);
            analogWrite(g2pin, 255);
          } else {
            if (lux_mode2_activeled == 1) {
              lux_mode2_activeled = 0;
              analogWrite(g1pin, 255);
              analogWrite(g2pin, 100);
            }
          }
        } // closing cycle divider if statement  
        // rgbmode 4 is slow, run the delay for everything else
        if (rgbmode != 4) delayMicroseconds(generic_delay);
        break;
        
      case 3:
         rgbmode=5;
         // flash some random shit
         if (random(100) > 50) { 
           analogWrite(g1pin, random(255)); 
         } else { 
           analogWrite(g2pin, random(255)); 
         } 
         modeselect_cycle_divider = freakout_limit;
         break;
  
      case 4:
        // hold please...
        delay(10);
        break;      
        
      case 5:
         // just be dim
         analogWrite(g1pin, 220);
         analogWrite(g2pin, 220);
         break;
         
      case 6: 
          // light up one ring
          analogWrite(g1pin, 1);
          analogWrite(g2pin, 255);
          break;
          
      case 7:
         // light up the other ring (with glow)
         analogWrite(g1pin, 220);
         analogWrite(g2pin, 1);
         break;
         
  } // end switch case for lux mode
  
  
  switch (rgbmode) {
    
      case 1:
        // mode 1 for rgb leds, do an inverted ibook style breathing pulse
        rgb_mode1_cycle++;
        if (rgb_mode1_cycle == rgb_mode1_cycle_divider) {
          rgb_mode1_cycle = 0;
          /* CHANGEME: 
          for (int foo=0; foo<6; foo++) {
            Tlc.set(foo+ledoffset, rgb_mode1_fadeval);
            Tlc.update();
            Serial.println(foo+ledoffset);
          }
          */
  
          // do green pulses
          Tlc.set(10, 4095);
          Tlc.set(11, rgb_mode1_fadeval);
          Tlc.set(12, 4095);
          Tlc.set(13, 4095);
          Tlc.set(14, rgb_mode1_fadeval);
          Tlc.set(15, 4095);
          // end of green pulses
  
          Tlc.update();
          if (rgb_mode1_dir == 1) {
            // going up
            if (rgb_mode1_fadeval >= rgb_mode1_fader_max) { 
              // max reached, change directions
              rgb_mode1_fadeval -= rgb_mode1_fader_jump; 
              rgb_mode1_dir = 0; 
            } else { 
              rgb_mode1_fadeval += rgb_mode1_fader_jump; 
            }
          } else {
            if (rgb_mode1_dir == 0) {
              // going down
              if (rgb_mode1_fadeval <= rgb_mode1_fader_min) { 
                // min reached, change directions
                rgb_mode1_fadeval += rgb_mode1_fader_jump; 
                rgb_mode1_dir = 1; 
              } else { 
                rgb_mode1_fadeval -= rgb_mode1_fader_jump; 
              }
            }
          } // closing directional if statement
        } // closing cycle divider if statement
        break;
                
     case 2:
       // change to and follow lux mode1's colors
       luxmode=1;
       rgb_mode2_cycle++;
       if (rgb_mode2_cycle == rgb_mode2_cycle_divider) {
         rgb_mode2_cycle = 0;        
         Tlc.set(11, (lux_mode1_fadeval*16));
         Tlc.set(14, (lux_mode1_fadeval*16));
         Tlc.set(10, 4095);
         Tlc.set(12, 4095);
         Tlc.set(13, 4095);
         Tlc.set(15, 4095);
         Tlc.update();
       }
       break;
    
     case 3:
        // just freak the fuck out
        rgb_mode3_cycle++;
        if (rgb_mode3_cycle == rgb_mode3_cycle_divider) {
          rgb_mode3_cycle = 0;        
          int chan=random(6)+ledoffset;
          int val=random(4095);
          Tlc.set(chan, val);
          Tlc.update();
        }
        modeselect_cycle_divider = freakout_limit;
        break;
      
     case 4:
        // random colors / fading
        rgb_mode4_cycle++;
        if (rgb_mode4_cycle == rgb_mode4_cycle_divider) {
          // cycle expired, do mode 4 stuff
          rgb_mode4_cycle = 0;
          
          // check to see if it is time to pick colors
          rgb_mode4_color_picker_cycle++;
          if ((rgb_mode4_color_picker_cycle == rgb_mode4_color_picker_cycle_divider) || (rgb_mode4_color_picker_firstrun == 0)) {
            rgb_mode4_color_picker_firstrun = 1;
            // pick new colors
            rgb_mode4_color_picker_cycle = 0;
            if (zzz == 6) zzz = 0;
            //for (int zzz=0; zzz<6; zzz++) {
              rgb_mode4_led_dest[zzz] = random(4095);
              /*
              Serial.print("new ");
              Serial.print(zzz);
              Serial.print(" to ");
              Serial.print(rgb_mode4_led_dest[zzz]);
              Serial.println("");
              */
            //}
            zzz++;

          }
          
          // fade leds towards dest
          if (yyy == 6) yyy = 0;
          //for (int yyy=0; yyy<6; yyy++) {
              if (rgb_mode4_led_cur[yyy] <= (rgb_mode4_led_dest[yyy] + rgb_mode4_fader_jump)) {
                rgb_mode4_led_cur[yyy] += rgb_mode4_fader_jump;
                Tlc.set(yyy + ledoffset, rgb_mode4_led_cur[yyy]);
                /*
                Serial.print("set ");
                Serial.print(yyy);
                Serial.print(" to ");
                Serial.print(rgb_mode4_led_cur[yyy]);
                Serial.println("");
                */
                Tlc.update();
              }
              if (rgb_mode4_led_cur[yyy] >= (rgb_mode4_led_dest[yyy] - rgb_mode4_fader_jump)) {
                rgb_mode4_led_cur[yyy] -= rgb_mode4_fader_jump;
                Tlc.set(yyy + ledoffset, rgb_mode4_led_cur[yyy]);
                /*
                Serial.print("set ");
                Serial.print(yyy);
                Serial.print(" to ");
                Serial.print(rgb_mode4_led_cur[yyy]);
                Serial.println("");
                */
                Tlc.update();
              }
          //}
          yyy++;

        } // end mode4_cycle_divider if statement
        break;

    case 5:
      luxmode=3;
      // light up some random shit
      Tlc.set(random(6) + ledoffset, random(4095));
      Tlc.update();
      modeselect_cycle_divider = freakout_limit;
      break;    

      case 6:
        // mode 6 is mode 1 but white, do an inverted ibook style breathing pulse
        rgb_mode1_cycle++;
        if (rgb_mode1_cycle == rgb_mode1_cycle_divider) {
          rgb_mode1_cycle = 0;
          for (int foo=0; foo<6; foo++) {
            Tlc.set(foo+ledoffset, rgb_mode1_fadeval);
            Tlc.update();
            Serial.println(foo+ledoffset);
          }
  
          /* do green pulses
          Tlc.set(10, 4095);
          Tlc.set(11, rgb_mode1_fadeval);
          Tlc.set(12, 4095);
          Tlc.set(13, 4095);
          Tlc.set(14, rgb_mode1_fadeval);
          Tlc.set(15, 4095);
          */
  
          Tlc.update();
          if (rgb_mode1_dir == 1) {
            // going up
            if (rgb_mode1_fadeval >= rgb_mode1_fader_max) { 
              // max reached, change directions
              rgb_mode1_fadeval -= rgb_mode1_fader_jump; 
              rgb_mode1_dir = 0; 
            } else { 
              rgb_mode1_fadeval += rgb_mode1_fader_jump; 
            }
          } else {
            if (rgb_mode1_dir == 0) {
              // going down
              if (rgb_mode1_fadeval <= rgb_mode1_fader_min) { 
                // min reached, change directions
                rgb_mode1_fadeval += rgb_mode1_fader_jump; 
                rgb_mode1_dir = 1; 
              } else { 
                rgb_mode1_fadeval -= rgb_mode1_fader_jump; 
              }
            }
          } // closing directional if statement
        } // closing cycle divider if statement
        break;

      case 7:
          // just be dim red
          Tlc.set(10, 3600);
          Tlc.set(11, 4095);
          Tlc.set(12, 4095);
          Tlc.set(13, 3600);
          Tlc.set(14, 4095);
          Tlc.set(15, 4095);
          Tlc.update();
          break;

  } // end switch case for rgb mode
  
} // end of the road

