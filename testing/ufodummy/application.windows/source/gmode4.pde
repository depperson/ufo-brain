/* 
 * gmode=4 - damaged breathe
 * "fine atten" controls the speed
 * "sweep width" controls the brightness
 * "hor. phase" introduces random loss of brightness
 * "ext mark" makes 2nd leds follow or mirror
 */

// initialize default values
int gmode4_ticks = 2, gmode4_divider = 1, gmode4_direction = 1;
int gmode4_value = 0, gmode4_increment = 1, gmode4_marker_val = 0;
int gmode4_value2 = 0, gmode4_osc_val = 355;
float gmode4_sat = 1.0;

// this defines the minimum speed
int gmode4_inc_min = 5;

// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
void gmode4() {
  // breathe action delay
  //gmode4_ticks = 2;
  if (gmode4_ticks > gmode4_divider) {
    
    // reset the counter
    // commented for maximum speed
    //gmode4_ticks = 0;
    
    // use the sweep width knob (if it is non-zero) to control increment 
    if (sweepwidth > 12) gmode4_marker_val = sweepwidth / 12;
    if (gmode4_marker_val > 0) gmode4_increment = gmode4_marker_val + gmode4_inc_min;
  
    // use the fineatten knob to control color bias
    if (fineatten > 0) gmode4_osc_val = (fineatten / 4) + 350;
    // debug: if (gmode4_osc_val > 0) { print("gmode4_osc_val="); println(gmode4_osc_val); }

    // the order of directions is 1,0,2,3  
    // fade values up 
    if (gmode4_direction == 1) {
      // going up
      if ((gmode4_value + gmode4_increment) <= 255) {
        // go all the way up to 255 before reversing
        gmode4_value += gmode4_increment;
      } else {
        gmode4_direction = 0;
      }
    }
    
    // fade values down
    if (gmode4_direction == 0) {
      // going down
      if ((gmode4_value - gmode4_increment) >= 0) {
        // drop all the way to zero before reversing
        gmode4_value -= gmode4_increment;
      } else {
        gmode4_direction = 2;
      }
    }
    
    // fade values up on 2nd RGB
    if (gmode4_direction == 2) {
      // going up
      if ((gmode4_value2 + gmode4_increment) <= 255) {
        // go all the way up to 255 before reversing
        gmode4_value2 += gmode4_increment;
      } else {
        gmode4_direction = 3;
      }
    }
    
    // fade values down on 2nd RGB
    if (gmode4_direction == 3) {
      // going down
      if ((gmode4_value2 - gmode4_increment) >= 0) {
        // drop all the way to zero before reversing
        gmode4_value2 -= gmode4_increment;
      } else {
        gmode4_direction = 1;
      }
    }
  
    // Color.HSBtoRGB(float hue,float saturation,float brightness)
    // create a color in hsb colorspace, then convert it to rgb values
    // in hsb, incrementing hue 0-360 spins the color wheel
    // "oscillator" knob = hue
    // "marker amp" knob = saturation
    // 0-255 sinewave = brightness
    color ct1 = Color.HSBtoRGB((float(gmode4_osc_val) / 1023), gmode4_sat, (float(gmode4_value) / 255));
    color ct2 = Color.HSBtoRGB((float(gmode4_osc_val) / 1023), gmode4_sat, (float(gmode4_value2) / 255));
    g1.update(green(ct1));
  
    // g 2 either mirrors or follows g 1
    if (extmarkswitch == 1) g2.update(green(ct2)); else g2.update(green(ct1));  
    
    // phase switch induces more damage          
    if (phaseswitch == 0) {
      // debug: 
      //println("phaseswitch=0");
      if ((horphase >= 0) && (horphase <= 1023)) {
        // opportunities for nothing to happen (adjusted by hor phase knob)
        if (random(1024) < horphase) {
          
          if(random(1024) > 100) g1.update(0);
          if(random(1024) > 100) g2.update(0);
          
        } // end horphase adjustment
        
      } // end horphase knob nonzero validation
      
    } else {
      
      // reset saturation to full
      gmode4_sat = 1.0;
      
    } // end marker amp switch

  } // end mode1 ticks counter

} // end of gmode=4 (damaged breathe)
