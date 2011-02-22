/*
 * gmode=5 - PING (inverted). knobs control brightness and frequency
 * "fine atten" controls a delay between pings
 * "sweep width" adjusts the step between values in the fader
 * "hor. phase" introduces random brightness values
 * "ext mark" turns on 2nd channel
 */


// initialize default values
int gmode5_val1 = 0, gmode5_val2 = 0, gmode5_direction = 1;
int gmode5_inc = 25;
float gmode5_ticks = 0, gmode5_start = 100;


// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
void gmode5() {

  // sanity check input values, or generate random ones
  if ((sweepwidth >= 0) && (sweepwidth <= 1023)) {  
    gmode5_inc = (sweepwidth / 16);
  } else { gmode5_inc = int(10 + random(40)); }
  if ((fineatten >= 0) && (fineatten <= 1023)) {
    gmode5_start = (fineatten / 8);
  } else { gmode5_start = int(random(1023)); }

  
  // delay timer for fade action
  gmode5_ticks += 1;
  if (gmode5_ticks > gmode5_start) {
    if (gmode5_direction == 1) {
      // going up
      if ((gmode5_val1 + gmode5_inc) <= 255) {
        gmode5_val1 += gmode5_inc;
        g1update(255 - gmode5_val1);
        if (extmarkswitch != 1) {  
          g2update(255 - gmode5_val1);
        }
      }
      // reverse at peak
      if (gmode5_val1 >= (255 - gmode5_inc)) {
        gmode5_direction = 0;
        gmode5_val1 = 255;
        g1update(255 - gmode5_val1);
        if (extmarkswitch != 1) {  
          g2update(255 - gmode5_val1);
        }
      }
    } // end fade up, switch to down
    
    if (gmode5_direction == 0) {
      // going down
      if ((gmode5_val1 - gmode5_inc) >= 0) {
        gmode5_val1 -= gmode5_inc;
        g1update(255 - gmode5_val1);
        if (extmarkswitch != 1) {  
          g2update(255 - gmode5_val1);
        }
      }
      // reverse and reset 
      if (gmode5_val1 <= gmode5_inc) { 
        gmode5_val1 = 0;
        // change direction back to up
        gmode5_direction = 1; 
        // reset counter
        gmode5_ticks = 0;
        g1update(255 - gmode5_val1);
        if (extmarkswitch != 1) {  
          g2update(255 - gmode5_val1);
        }  
      }
    } // end fade down, reset
    
    // turn off 2nd channel if ext switch is off
    if (extmarkswitch == 1) {  
      g2update(0);
    }
  } // end pulse start if statement
  
  // phase switch induces randomness          
  if (phaseswitch == 0) {
    // debug: println("phaseswitch=0");
    if ((horphase >= 0) && (horphase <= 1023)) {
      if (random(1024) < horphase) {
        if (random(100) > 90) g1update(random(255));
        if (random(100) > 90) g2update(random(255));
      }
    }
  } // end phase switch
        
}  // end of gmode=5 - ping   
