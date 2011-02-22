/* 
 * rmode=1 - breathe
 * "marker" controls the speed
 * "oscillator" controls the color
 * "marker amp" fades color to white
 * "xtal" makes the 2nd RGB LEDs mirror or follow
 */

// initialize default values
int rmode1_ticks = 2, rmode1_divider = 1, rmode1_direction = 1;
int rmode1_value = 0, rmode1_increment = 1, rmode1_marker_val = 0;
int rmode1_value2 = 0, rmode1_osc_val = 0;
float rmode1_sat = 1.0;

// this defines the minimum speed
int rmode1_inc_min = 5;

// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
void rmode1() {
  // breathe action delay
  //rmode1_ticks = 2;
  if (rmode1_ticks > rmode1_divider) {
    
    // reset the counter
    // commented for maximum speed
    //rmode1_ticks = 0;
    
    // use the marker knob (if it is non-zero) to control increment 
    if (marker > 0) rmode1_marker_val = marker / 12;
    if (rmode1_marker_val > 0) rmode1_increment = rmode1_marker_val + rmode1_inc_min;
  
    // use the oscillator knob to control color bias
    if (oscillator > 0) rmode1_osc_val = oscillator;
    // debug: if (rmode1_osc_val > 0) { print("rmode1_osc_val="); println(rmode1_osc_val); }

    // the order of directions is 1,0,2,3  
    // fade values up 
    if (rmode1_direction == 1) {
      // going up
      if ((rmode1_value + rmode1_increment) <= 255) {
        // go all the way up to 255 before reversing
        rmode1_value += rmode1_increment;
      } else {
        rmode1_direction = 0;
      }
    }
    
    // fade values down
    if (rmode1_direction == 0) {
      // going down
      if ((rmode1_value - rmode1_increment) >= 0) {
        // drop all the way to zero before reversing
        rmode1_value -= rmode1_increment;
      } else {
        rmode1_direction = 2;
      }
    }
    
    // fade values up on 2nd RGB
    if (rmode1_direction == 2) {
      // going up
      if ((rmode1_value2 + rmode1_increment) <= 255) {
        // go all the way up to 255 before reversing
        rmode1_value2 += rmode1_increment;
      } else {
        rmode1_direction = 3;
      }
    }
    
    // fade values down on 2nd RGB
    if (rmode1_direction == 3) {
      // going down
      if ((rmode1_value2 - rmode1_increment) >= 0) {
        // drop all the way to zero before reversing
        rmode1_value2 -= rmode1_increment;
      } else {
        rmode1_direction = 1;
      }
    }
  
    // Color.HSBtoRGB(float hue,float saturation,float brightness)
    // create a color in hsb colorspace, then convert it to rgb values
    // in hsb, incrementing hue 0-360 spins the color wheel
    // "oscillator" knob = hue
    // "marker amp" knob = saturation
    // 0-255 sinewave = brightness
    color ct1 = Color.HSBtoRGB((float(rmode1_osc_val) / 1023), rmode1_sat, (float(rmode1_value) / 255));
    color ct2 = Color.HSBtoRGB((float(rmode1_osc_val) / 1023), rmode1_sat, (float(rmode1_value2) / 255));
    r1.update(ct1);
  
    // rgb 2 either mirrors or follows rgb 1
    if (xtalswitch == 1) r2.update(ct2); else r2.update(ct1);  
    
    // marker amp switch induces randomness          
    if (markerampswitch == 0) {
      // introduce lots of opportunites for this function to -not- run
      if ((markeramp >= 0) && (markeramp <= 1023)) {
        // more opportunities for nothing to happen (adjusted by marker amp knob)
        if (random(1024) < markeramp) {
          
          // flashes of current color
          //if (random(100) > 90) { rmode1_value = int(random(255)); }
          //if (random(100) < 10) { rmode1_value2 = int(random(255)); }
          
          // white flashes
          //if (random(100) > 90) { float a = random(255); r1.update(color(a, a, a)); }
          //if (random(100) > 90) { float b = random(255); r2.update(color(b, b, b)); }
          
          // change saturation of current HSB color (fade to white)
          rmode1_sat = (float(1024 - markeramp) / 1023);
          
        } // end marker amp adjustment
        
      } // end marker knob nonzero validation
      
    } else {
      
      // reset saturation to full
      rmode1_sat = 1.0;
      
    } // end marker amp switch

  } // end mode1 ticks counter

} // end of rmode=1 (breathe)
