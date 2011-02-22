/*
 * rmode=4 - PING. knobs control brightness and frequency
 * "marker" adjusts the step between values in the fader
 * "oscillator" controls a delay between pings
 * "marker amp" introduces random color values
 * "xtal" makes the 2nd RGB LEDs mirror
 */


// initialize default values
int rmode4_val1 = 0, rmode4_val2 = 0, rmode4_direction = 1;
int rmode4_inc = 25, rmode4_osc_val = 10, rmode4_osc_val2 = 10;
float rmode4_ticks = 0, rmode4_start = 100;


// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
void rmode4() {

  // sanity check input values, or generate random ones
  if ((marker >= 0) && (marker <= 1023)) {  
    rmode4_inc = ((1024 - marker) / 16);
  } else { rmode4_inc = int(10 + random(40)); }
  if ((oscillator >= 0) && (oscillator <= 1023)) {
    rmode4_start = (oscillator / 8);
  } else { rmode4_start = int(random(1023)); }

  // Color.HSBtoRGB(float hue,float saturation,float brightness)
  // create a color in hsb colorspace, then convert it to rgb values
  // in hsb, incrementing hue 0-360 spins the color wheel
  // 0-255 sinewave = brightness
  //color ct1 = Color.HSBtoRGB((float(rmode1_osc_val) / 1023), rmode1_sat, (float(rmode1_value) / 255));
  //color ct2 = Color.HSBtoRGB((float(rmode1_osc_val) / 1023), rmode1_sat, (float(rmode1_value2) / 255));


  // delay timer for fade action
  rmode4_ticks += 1;
  if (rmode4_ticks > rmode4_start) {
    if (rmode4_direction == 1) {
      // going up
      if ((rmode4_val1 + rmode4_inc) <= 255) {
        rmode4_val1 += rmode4_inc;
        
        // H1,S1,L1,Rval1,Gval1,Bval1
        H = (float(rmode4_osc_val) / 1023);
        S = 1.0;
        L = (float(rmode4_val1) / 255);
        HSL(float(rotary.position())/360,S,L,Rval1,Gval1,Bval1);
        
        r1update(Rval1, Gval1, Bval1);
        if (xtalswitch != 1) {  
          r2update(Rval1, Gval1, Bval1);
        }
      }
      // reverse at peak
      if (rmode4_val1 >= (255 - rmode4_inc)) {
        rmode4_direction = 0;
        rmode4_val1 = 255;

        // H1,S1,L1,Rval1,Gval1,Bval1
        H = (float(rmode4_osc_val) / 1023);
        S = 1.0;
        L = (float(rmode4_val1) / 255);
        HSL(float(rotary.position())/360,S,L,Rval1,Gval1,Bval1);
        
        r1update(Rval1, Gval1, Bval1);
        if (xtalswitch != 1) {  
          r2update(Rval1, Gval1, Bval1);
        }
      }
    } // end fade up, switch to down
    
    if (rmode4_direction == 0) {
      // going down
      if ((rmode4_val1 - rmode4_inc) >= 0) {
        rmode4_val1 -= rmode4_inc;

        // H1,S1,L1,Rval1,Gval1,Bval1
        H = (float(rmode4_osc_val) / 1023);
        S = 1.0;
        L = (float(rmode4_val1) / 255);
        HSL(float(rotary.position())/360,S,L,Rval1,Gval1,Bval1);
        
        r1update(Rval1, Gval1, Bval1);
        if (xtalswitch != 1) {  
          r2update(Rval1, Gval1, Bval1);
        }
      }
      // reverse and reset 
      if (rmode4_val1 <= rmode4_inc) { 
        rmode4_val1 = 0;
        // change direction back to up
        rmode4_direction = 1; 
        // reset counter
        rmode4_ticks = 0;

        // H1,S1,L1,Rval1,Gval1,Bval1
        H = (float(rmode4_osc_val) / 1023);
        S = 1.0;
        L = (float(rmode4_val1) / 255);
        HSL(float(rotary.position())/360,S,L,Rval1,Gval1,Bval1);
        
        r1update(Rval1, Gval1, Bval1);
        if (xtalswitch != 1) {  
          r2update(Rval1, Gval1, Bval1);
        }

        // bring in new color after fade completes
        rmode4_osc_val = rmode4_osc_val2;
      }
    } // end fade down, reset
    
    // turn off 2nd channel if ext switch is off
    if (xtalswitch == 1) {  
      r2update(0, 0, 0);
    }
  } // end pulse start if statement
  
  // marker amp changes the color         
  if (markerampswitch == 0) {
    // debug: println("markerampswitch=0");
    if ((markeramp >= 0) && (markeramp <= 1023)) {
      if (random(1024) < markeramp) {
        if (random(100) > 95) rmode4_osc_val2 = int(random(360));
      }
    }
  } // end phase switch
        
}  // end of rmode=4 - ping   
