/* 
 * rmode=5 - breathe (inverted)
 * "marker" controls the speed
 * "oscillator" controls the color
 * "marker amp" fades color to white
 * "xtal" makes the 2nd RGB LEDs mirror or follow
 */

// initialize default values
int rmode5_ticks = 2, rmode5_divider = 1, rmode5_direction = 1;
int rmode5_value = 0, rmode5_increment = 1, rmode5_marker_val = 0;
int rmode5_value2 = 0, rmode5_osc_val = 0;
float rmode5_sat = 1.0;

// this defines the minimum speed
int rmode5_inc_min = 5;

// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
void rmode5() {
  // breathe action delay
  //rmode5_ticks = 2;
  if (rmode5_ticks > rmode5_divider) {
    
    // reset the counter
    // commented for maximum speed
    //rmode5_ticks = 0;
    
    // use the marker knob (if it is non-zero) to control increment 
    if (marker > 0) rmode5_marker_val = marker / 12;
    if (rmode5_marker_val > 0) rmode5_increment = rmode5_marker_val + rmode5_inc_min;
  
    // use the oscillator knob to control color bias
    if (oscillator > 0) rmode5_osc_val = oscillator;
    // debug: if (rmode5_osc_val > 0) { print("rmode5_osc_val="); println(rmode5_osc_val); }

    // the order of directions is 1,0,2,3  
    // fade values up 
    if (rmode5_direction == 1) {
      // going up
      if ((rmode5_value + rmode5_increment) <= 255) {
        // go all the way up to 255 before reversing
        rmode5_value += rmode5_increment;
      } else {
        rmode5_direction = 0;
      }
    }
    
    // fade values down
    if (rmode5_direction == 0) {
      // going down
      if ((rmode5_value - rmode5_increment) >= 0) {
        // drop all the way to zero before reversing
        rmode5_value -= rmode5_increment;
      } else {
        rmode5_direction = 2;
      }
    }
    
    // fade values up on 2nd RGB
    if (rmode5_direction == 2) {
      // going up
      if ((rmode5_value2 + rmode5_increment) <= 255) {
        // go all the way up to 255 before reversing
        rmode5_value2 += rmode5_increment;
      } else {
        rmode5_direction = 3;
      }
    }
    
    // fade values down on 2nd RGB
    if (rmode5_direction == 3) {
      // going down
      if ((rmode5_value2 - rmode5_increment) >= 0) {
        // drop all the way to zero before reversing
        rmode5_value2 -= rmode5_increment;
      } else {
        rmode5_direction = 1;
      }
    }
  
    
    //color ct1 = Color.HSBtoRGB((float(rmode5_osc_val) / 1023), rmode5_sat, (float(255-rmode5_value) / 255));
    //color ct2 = Color.HSBtoRGB((float(rmode5_osc_val) / 1023), rmode5_sat, (float(255-rmode5_value2) / 255));
    
    // H1,S1,L1,Rval1,Gval1,Bval1
    H = (float(rmode5_osc_val) / 1023);
    S = rmode5_sat;
    L = (float(255-rmode5_value) / 255);
    HSL(float(rotary.position())/360,S,L,Rval1,Gval1,Bval1);
    L = (float(255-rmode5_value2) / 255);
    HSL(float(rotary.position())/360,S,L,Rval2,Gval2,Bval2);
    
    r1update(Rval1, Gval1, Bval1);
  
    // rgb 2 either mirrors or follows rgb 1
    if (xtalswitch == 1) r2update(Rval2, Gval2, Bval2); else r2update(Rval1, Gval1, Bval1);  
    
    // marker amp switch induces randomness          
    if (markerampswitch == 0) {
      // introduce lots of opportunites for this function to -not- run
      if ((markeramp >= 0) && (markeramp <= 1023)) {
        // more opportunities for nothing to happen (adjusted by marker amp knob)
        if (random(1024) < markeramp) {
          
          // flashes of current color
          //if (random(100) > 90) { rmode5_value = int(random(255)); }
          //if (random(100) < 10) { rmode5_value2 = int(random(255)); }
          
          // white flashes
          //if (random(100) > 90) { float a = random(255); r1update(color(a, a, a)); }
          //if (random(100) > 90) { float b = random(255); r2update(color(b, b, b)); }
          
          // change saturation of current HSB color (fade to white)
          rmode5_sat = (float(1024 - markeramp) / 1023);
          
        } // end marker amp adjustment
        
      } // end marker knob nonzero validation
      
    } else {
      
      // reset saturation to full
      rmode5_sat = 1.0;
      
    } // end marker amp switch

  } // end mode1 ticks counter

} // end of rmode=5 (breathe)
