/* 
 * rmode=2 - pick random colors and fade to them
 * "marker" controls the frequency of new colors
 * "oscillator" controls the speed of the fade to a new color
 * "marker amp" introduces turns off random leds
 * "xtal" makes the 2nd RGB LEDs mirror
 */

// initialize default values
int rmode2_ticks = 0, rmode2_divider = 2, rmode2_increment = 1;
int rmode2_picker_ticks = 1023, rmode2_picker_divider = 200;
int rmode2_cur_val_r1, rmode2_cur_val_b1, rmode2_cur_val_g1;
int rmode2_want_val_r1, rmode2_want_val_b1, rmode2_want_val_g1;
int rmode2_cur_val_r2, rmode2_cur_val_b2, rmode2_cur_val_g2;
int rmode2_want_val_r2, rmode2_want_val_b2, rmode2_want_val_g2;

int rmode2_osc_val = 0, rmode2_marker_val = 0, rmode2_inc_min = 1;

color r1c, r2c;

// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
void rmode2() {
        // random colors, fading
        
        rmode2_ticks += 1; 
        rmode2_picker_ticks += 1;
        
        // use marker knob to change color picker timer
        if (marker > 0) rmode2_picker_divider = marker / 3;
        
        // use oscillator knob to change fading speed
        if (oscillator > 0) rmode2_increment = ((1023 - oscillator) / 20) + rmode2_inc_min;

        // cycle timer
        if (rmode2_ticks > rmode2_divider) {
          
          // reset the main counter
          rmode2_ticks = 0;

          // color picker counter
          if (rmode2_picker_ticks > rmode2_picker_divider) {
            
            // reset the color picker counter
            rmode2_picker_ticks = 0;
            
            // color picker code for rgb led 1
            rmode2_want_val_r1 = int(random(255));
            rmode2_want_val_g1 = int(random(255));
            rmode2_want_val_b1 = int(random(255));

            // debug
            //println("picking colors");
            //println(rmode2_want_val_r1);
            //println(rmode2_want_val_g1);
            //println(rmode2_want_val_b1);

            // color picker code for rgb led 2
            rmode2_want_val_r2 = int(random(255));
            rmode2_want_val_g2 = int(random(255));
            rmode2_want_val_b2 = int(random(255));
            
            
          }          
          
          
          // fade colors for led 1          
          
          // fade upwards r1
          if (rmode2_cur_val_r1 < rmode2_want_val_r1) 
            if ((rmode2_cur_val_r1 + rmode2_increment) <= 255) 
              rmode2_cur_val_r1 += rmode2_increment;

          // fade downwards r1
          if (rmode2_cur_val_r1 > rmode2_want_val_r1) 
            if ((rmode2_cur_val_r1 - rmode2_increment) >= 0) 
              rmode2_cur_val_r1 -= rmode2_increment;
            
          // fade upwards g1
          if (rmode2_cur_val_g1 < rmode2_want_val_g1) 
            if ((rmode2_cur_val_g1 + rmode2_increment) <= 255) 
              rmode2_cur_val_g1 += rmode2_increment;

          // fade downwards g1
          if (rmode2_cur_val_g1 > rmode2_want_val_g1) 
            if ((rmode2_cur_val_g1 - rmode2_increment) >= 0) 
              rmode2_cur_val_g1 -= rmode2_increment;
          
          // fade upwards b1
          if (rmode2_cur_val_b1 < rmode2_want_val_b1) 
            if ((rmode2_cur_val_b1 + rmode2_increment) <= 255) 
              rmode2_cur_val_b1 += rmode2_increment;

          // fade downwards b1
          if (rmode2_cur_val_b1 > rmode2_want_val_b1) 
            if ((rmode2_cur_val_b1 - rmode2_increment) >= 0) 
              rmode2_cur_val_b1 -= rmode2_increment;
              

          // fade colors for led 2
          
          // fade upwards r2
          if (rmode2_cur_val_r2 < rmode2_want_val_r2) 
            if ((rmode2_cur_val_r2 + rmode2_increment) <= 255) 
              rmode2_cur_val_r2 += rmode2_increment;

          // fade downwards r2
          if (rmode2_cur_val_r2 > rmode2_want_val_r2) 
            if ((rmode2_cur_val_r2 - rmode2_increment) >= 0) 
              rmode2_cur_val_r2 -= rmode2_increment;
            
          // fade upwards g2
          if (rmode2_cur_val_g2 < rmode2_want_val_g2) 
            if ((rmode2_cur_val_g2 + rmode2_increment) <= 255) 
              rmode2_cur_val_g2 += rmode2_increment;

          // fade downwards g2
          if (rmode2_cur_val_g2 > rmode2_want_val_g2) 
            if ((rmode2_cur_val_g2 - rmode2_increment) >= 0) 
              rmode2_cur_val_g2 -= rmode2_increment;
          
          // fade upwards b2
          if (rmode2_cur_val_b2 < rmode2_want_val_b2) 
            if ((rmode2_cur_val_b2 + rmode2_increment) <= 255) 
              rmode2_cur_val_b2 += rmode2_increment;

          // fade downwards b2
          if (rmode2_cur_val_b2 > rmode2_want_val_b2) 
            if ((rmode2_cur_val_b2 - rmode2_increment) >= 0) 
              rmode2_cur_val_b2 -= rmode2_increment;

          

          
          // marker amp changes the color         
          if (markerampswitch == 0) {
            // debug: println("markerampswitch=0");
            if ((markeramp >= 0) && (markeramp <= 1023)) {
              if (random(1024) < markeramp) {
                // turn off a random color
                
                // channel 1
                if (random(100) > 90) rmode2_cur_val_r1 = 0;
                if (random(100) > 90) rmode2_cur_val_g1 = 0;
                if (random(100) > 90) rmode2_cur_val_b1 = 0;
                r1c = color(rmode2_cur_val_r1, rmode2_cur_val_g1, rmode2_cur_val_b1);
                
                // channel 2
                if (random(100) > 90) rmode2_cur_val_r2 = 0;
                if (random(100) > 90) rmode2_cur_val_g2 = 0;
                if (random(100) > 90) rmode2_cur_val_b2 = 0;
                r2c = color(rmode2_cur_val_r2, rmode2_cur_val_g2, rmode2_cur_val_b2);
              } else {
                
                // apply faded colors
                r1c = color(rmode2_cur_val_r1, rmode2_cur_val_g1, rmode2_cur_val_b1); 
                r2c = color(rmode2_cur_val_r2, rmode2_cur_val_g2, rmode2_cur_val_b2);
              }
            }
          } else {
            
            // apply faded colors
            r1c = color(rmode2_cur_val_r1, rmode2_cur_val_g1, rmode2_cur_val_b1); 
            r2c = color(rmode2_cur_val_r2, rmode2_cur_val_g2, rmode2_cur_val_b2);
            
          } // end marker amp switch
          
          // update rgb 1
          r1.update(r1c);
          
          // rgb 2 either mirrors or follows rgb 1
          if (xtalswitch == 1) r2.update(r2c); else r2.update(r1c); 
          
          //println(rmode2_cur_val_r1);
          //println(rmode2_want_val_r1);
        }
        // end of case 2 (random colors, fading)
}

