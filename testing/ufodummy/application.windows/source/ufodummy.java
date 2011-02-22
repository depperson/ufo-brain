import processing.core.*; 
import processing.xml.*; 

import processing.serial.*; 
import java.awt.Color; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class ufodummy extends PApplet {

/**
 * UFO Simulator
 * for box-o-knobs
 *
 * By: Daniel Epperson, 2010
 *
 */
 

// initial led modes
int rmode = 6;
int gmode = 5;

// mode randomizer needs to know how many modes there are
int rmode_max=5, gmode_max=5;


// main loop()
public void draw() {
  
  // check for serial data, or fake it
  checkserial();
  
  // debug
  //if (attenswitch1 == 0) println("sw1");
  //if (attenswitch2 == 0) println("sw2");
  //if (attenswitch3 == 0) println("sw3");
  
  // modechanger - "attenuator" switch selects if or how to switch gmode and rmode
  // if "x1" is selected then attenswitch3 == 0  -- dont switch modes at all
  // if "x100" is selected then attenswitch2 == 0 - switch modes randomly
  // if "x10k" is selected then attenswitch1 == 0 - minime, remote control mode
  
  if (attenswitch3 == 1) {
    // x1 is not selected
    
    // check for randomizer mode
    if (attenswitch2 == 1) {

      // x100 is not selected
      // check for remote control mode
      if (attenswitch1 == 1) {
        
        // x10k is not selected
        // meaning none of the switches are selected
        // this may happen during startup
        // dont do anything
        
      } else { 
      
        // x10k is selected  
        // remote control code 

      } // end x10k if/else
      
    } else {
      
      // x100 is selected
      // randomizer code
      
      // dont change modes very often
      if (random(1000) < 13) {
        if (random(1000) > 920) {
          gmode = PApplet.parseInt(random(gmode_max + 1));
          // make mode 0 and 3 happen less
          if (((gmode == 0) || (gmode == 3)) && (random(100) > 60)) gmode = PApplet.parseInt(random(gmode_max + 1));
          println("gmode=" + gmode);
        }
        if (random(1000) < 100) {
          rmode = PApplet.parseInt(random(rmode_max + 1));
          // make mode zero happen less
          if (((rmode == 0) || (rmode == 3)) && (random(100) > 60)) rmode = PApplet.parseInt(random(rmode_max + 1));
          println("rmode=" + rmode);
        }
      }
      
      
    } // end x100 if/else
    
  } else {
    
    // x1 is selected
    // don't do anything
    
  } // end x1/x100/x10k if/else
  
  
  // main mode processing starts here


  // don't update anything while paused
  if (redswitch != 0) {
    
    // mode selector for green leds
    switch (gmode) {
      case 0:
        // gmode=0 - everything to the max
        g1.update(255);
        g2.update(255);
        break;
        
      default:
      case 1:
        // gmode=1 - random flashes
        gmode1();
        break;
        
      case 2:
        // gmode=2 - PING. knobs control brightness and frequency
        gmode2();     
        break;
      
      case 3:
        // dont do anything (just pause green leds)
        break;

      case 4:
        // gmode=4 - damaged breathe
        gmode4();
        break;
        
      case 5:
        // gmode=5 - inverted PING
        gmode5();
        break;
        
    } // end switch case for gmode
    

    // mode selector for rgb leds
    switch (rmode) {
      
      case 0:
        // rmode=0 - everything to the max (white)
        r1.update(color(255,255,255));
        r2.update(color(255,255,255));
        break;
      
      default:
      case 1:
        // rmode=1 - breathe
        rmode1();
        break;
      
      case 2:
        // rmode=2 - pick random colors and fade to them
        rmode2();
        break;
       
      case 3:
        // dont do anything (just pause rgb leds)
        break;
        
      case 4:
        // rmode=3 - PING. knobs control color and frequency
        rmode4();
        break;
      
      case 5:
        // rmode=5 - inverted breathe
        rmode5();
        break;
      
      case 6:
        // rmode=6 - pattern
        rmode6();
        break;
        

    } // end rmode switch case
    
  } // end pause detection if

  // end of main mode processing
  
  // prevent java from eating all of the cpu cycles available
  delay(1);

} // loop() close
// Green Led Class
class GrnLed {
  
  float x1, x2, x3;
  float y1, y2, y3;
  float b, s = 8;
  
  // grnled object 
  // x,y values are LEDs on the screen
  // GrnLed(brightness, x1, y1, x2, y2, x3, y3)
  GrnLed(float inb, float inx1, float iny1, float inx2, float iny2, float inx3, float iny3) {
    b = inb;
    x1 = inx1; y1 = iny1;
    x2 = inx2; y2 = iny2;
    x3 = inx3; y3 = iny3;
  }
  
  public void display() {
    fill(color(0, b, 0));
    ellipse(x1, y1, s, s);
    ellipse(x2, y2, s, s);
    ellipse(x3, y3, s, s);
  }

  public void update(float inb) {
    b = inb;
    display();
  }
  
} // end green led class
// RGB Led Class
class RGBLed {
  
  int c, inc;
  float x1, x2, x3;
  float y1, y2, y3;
  float s = 8;
  
  //rgbled object 
  // x,y values are LEDs on the screen
  //RGBLed(color(r,g,b), x1, y1, x2, y2, x3, y3)
  RGBLed(int inc, float inx1, float iny1, float inx2, float iny2, float inx3, float iny3) {
    c = inc;
    x1 = inx1; y1 = iny1;
    x2 = inx2; y2 = iny2;
    x3 = inx3; y3 = iny3;
  }
  
  // draw this led channel on the screen
  public void display() {
    fill(c);
    ellipse(x1, y1, s, s);
    ellipse(x2, y2, s, s);
    ellipse(x3, y3, s, s);
  }
  
  // change the color of this led
  public void update(int inc) {
    c = inc;
    display();
  }
  
} // end of RGBLed class

/*

mode ideas

solar flares
  slow, sparky buildup
  blast of intensity
  fizzle out

damage
  sparky breathing mode
  



    
*/
/*
 * gmode=1 - knobs control random flashes
 * "fine atten" introduces more opportunities to not do anything
 * "sweep width" adjusts how often the rest of the code runs
 * "hor. phase" introduces quietness
 * "ext mark" makes 2nd leds follow or mirror
 */

// initialize default values
int gmode1_val1 = 0, gmode1_val1_sub = 100, gmode1_val2;

// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
public void gmode1() {
  
  // sanity check input values, or generate random ones
  if ((sweepwidth >= 0) && (sweepwidth <= 1023)) {  
    gmode1_val1 = sweepwidth - gmode1_val1_sub;
    //println(sweepwidth);
  } else { gmode1_val1 = PApplet.parseInt(random(1023)); }
  if ((fineatten >= 0) && (fineatten <= 1023)) {
    gmode1_val2 = fineatten;
  } else { gmode1_val2 = PApplet.parseInt(random(1023)); }
  
  // decide whether or not to change LED values
  if (random(1024) >= gmode1_val1) {
    if (random(1024) >= gmode1_val2) {
      if (random(10) > 5) {
        int a = PApplet.parseInt(random(255));
        g1.update(a);
        if (extmarkswitch == 0) g2.update(a);
      } else {
        g1.update(0);
        if (extmarkswitch == 0) g2.update(0);
      }
      if (extmarkswitch == 1) {
        if (random(10) > 5) {
          g2.update(0);
        } else {
          g2.update((20 + random(235)));
        }
      }
    }
  } // end led value decision
  
  // phase switch introduces quietness
  if (phaseswitch == 0) {
    // debug: println("phaseswitch=0");
    if ((horphase >= 0) && (horphase <= 1023)) {
      if (random(1024) < horphase) {
        if (random(100) > 10) g1.update(0);
        if (random(100) > 10) g2.update(0);
      }
    }
  } // end phase switch
  
}  // end of gmode1 (knobs control random flashes)
/*
 * gmode=2 - PING. knobs control brightness and frequency
 * "fine atten" controls a delay between pings
 * "sweep width" adjusts the step between values in the fader
 * "hor. phase" introduces random brightness values
 * "ext mark" turns on 2nd channel
 */


// initialize default values
int gmode2_val1 = 0, gmode2_val2 = 0, gmode2_direction = 1;
int gmode2_inc = 25;
float gmode2_ticks = 0, gmode2_start = 100;


// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
public void gmode2() {

  // sanity check input values, or generate random ones
  if ((sweepwidth >= 0) && (sweepwidth <= 1023)) {  
    gmode2_inc = (sweepwidth / 16);
  } else { gmode2_inc = PApplet.parseInt(10 + random(40)); }
  if ((fineatten >= 0) && (fineatten <= 1023)) {
    gmode2_start = (fineatten / 8);
  } else { gmode2_start = PApplet.parseInt(random(1023)); }

  
  // delay timer for fade action
  gmode2_ticks += 1;
  if (gmode2_ticks > gmode2_start) {
    if (gmode2_direction == 1) {
      // going up
      if ((gmode2_val1 + gmode2_inc) <= 255) {
        gmode2_val1 += gmode2_inc;
        g1.update(gmode2_val1);
        if (extmarkswitch != 1) {  
          g2.update(gmode2_val1);
        }
      }
      // reverse at peak
      if (gmode2_val1 >= (255 - gmode2_inc)) {
        gmode2_direction = 0;
        gmode2_val1 = 255;
        g1.update(gmode2_val1);
        if (extmarkswitch != 1) {  
          g2.update(gmode2_val1);
        }
      }
    } // end fade up, switch to down
    
    if (gmode2_direction == 0) {
      // going down
      if ((gmode2_val1 - gmode2_inc) >= 0) {
        gmode2_val1 -= gmode2_inc;
        g1.update(gmode2_val1);
        if (extmarkswitch != 1) {  
          g2.update(gmode2_val1);
        }
      }
      // reverse and reset 
      if (gmode2_val1 <= gmode2_inc) { 
        gmode2_val1 = 0;
        // change direction back to up
        gmode2_direction = 1; 
        // reset counter
        gmode2_ticks = 0;
        g1.update(gmode2_val1);
        if (extmarkswitch != 1) {  
          g2.update(gmode2_val1);
        }  
      }
    } // end fade down, reset
    
    // turn off 2nd channel if ext switch is off
    if (extmarkswitch == 1) {  
      g2.update(0);
    }
  } // end pulse start if statement
  
  // phase switch induces randomness          
  if (phaseswitch == 0) {
    // debug: println("phaseswitch=0");
    if ((horphase >= 0) && (horphase <= 1023)) {
      if (random(1024) < horphase) {
        if (random(100) > 90) g1.update(random(255));
        if (random(100) > 90) g2.update(random(255));
      }
    }
  } // end phase switch
        
}  // end of gmode=2 - ping   
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
float gmode4_sat = 1.0f;

// this defines the minimum speed
int gmode4_inc_min = 5;

// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
public void gmode4() {
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
    int ct1 = Color.HSBtoRGB((PApplet.parseFloat(gmode4_osc_val) / 1023), gmode4_sat, (PApplet.parseFloat(gmode4_value) / 255));
    int ct2 = Color.HSBtoRGB((PApplet.parseFloat(gmode4_osc_val) / 1023), gmode4_sat, (PApplet.parseFloat(gmode4_value2) / 255));
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
      gmode4_sat = 1.0f;
      
    } // end marker amp switch

  } // end mode1 ticks counter

} // end of gmode=4 (damaged breathe)
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
public void gmode5() {

  // sanity check input values, or generate random ones
  if ((sweepwidth >= 0) && (sweepwidth <= 1023)) {  
    gmode5_inc = (sweepwidth / 16);
  } else { gmode5_inc = PApplet.parseInt(10 + random(40)); }
  if ((fineatten >= 0) && (fineatten <= 1023)) {
    gmode5_start = (fineatten / 8);
  } else { gmode5_start = PApplet.parseInt(random(1023)); }

  
  // delay timer for fade action
  gmode5_ticks += 1;
  if (gmode5_ticks > gmode5_start) {
    if (gmode5_direction == 1) {
      // going up
      if ((gmode5_val1 + gmode5_inc) <= 255) {
        gmode5_val1 += gmode5_inc;
        g1.update(255 - gmode5_val1);
        if (extmarkswitch != 1) {  
          g2.update(255 - gmode5_val1);
        }
      }
      // reverse at peak
      if (gmode5_val1 >= (255 - gmode5_inc)) {
        gmode5_direction = 0;
        gmode5_val1 = 255;
        g1.update(255 - gmode5_val1);
        if (extmarkswitch != 1) {  
          g2.update(255 - gmode5_val1);
        }
      }
    } // end fade up, switch to down
    
    if (gmode5_direction == 0) {
      // going down
      if ((gmode5_val1 - gmode5_inc) >= 0) {
        gmode5_val1 -= gmode5_inc;
        g1.update(255 - gmode5_val1);
        if (extmarkswitch != 1) {  
          g2.update(255 - gmode5_val1);
        }
      }
      // reverse and reset 
      if (gmode5_val1 <= gmode5_inc) { 
        gmode5_val1 = 0;
        // change direction back to up
        gmode5_direction = 1; 
        // reset counter
        gmode5_ticks = 0;
        g1.update(255 - gmode5_val1);
        if (extmarkswitch != 1) {  
          g2.update(255 - gmode5_val1);
        }  
      }
    } // end fade down, reset
    
    // turn off 2nd channel if ext switch is off
    if (extmarkswitch == 1) {  
      g2.update(0);
    }
  } // end pulse start if statement
  
  // phase switch induces randomness          
  if (phaseswitch == 0) {
    // debug: println("phaseswitch=0");
    if ((horphase >= 0) && (horphase <= 1023)) {
      if (random(1024) < horphase) {
        if (random(100) > 90) g1.update(random(255));
        if (random(100) > 90) g2.update(random(255));
      }
    }
  } // end phase switch
        
}  // end of gmode=5 - ping   
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
float rmode1_sat = 1.0f;

// this defines the minimum speed
int rmode1_inc_min = 5;

// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
public void rmode1() {
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
    int ct1 = Color.HSBtoRGB((PApplet.parseFloat(rmode1_osc_val) / 1023), rmode1_sat, (PApplet.parseFloat(rmode1_value) / 255));
    int ct2 = Color.HSBtoRGB((PApplet.parseFloat(rmode1_osc_val) / 1023), rmode1_sat, (PApplet.parseFloat(rmode1_value2) / 255));
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
          rmode1_sat = (PApplet.parseFloat(1024 - markeramp) / 1023);
          
        } // end marker amp adjustment
        
      } // end marker knob nonzero validation
      
    } else {
      
      // reset saturation to full
      rmode1_sat = 1.0f;
      
    } // end marker amp switch

  } // end mode1 ticks counter

} // end of rmode=1 (breathe)
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

int r1c, r2c;

// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
public void rmode2() {
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
            rmode2_want_val_r1 = PApplet.parseInt(random(255));
            rmode2_want_val_g1 = PApplet.parseInt(random(255));
            rmode2_want_val_b1 = PApplet.parseInt(random(255));

            // debug
            //println("picking colors");
            //println(rmode2_want_val_r1);
            //println(rmode2_want_val_g1);
            //println(rmode2_want_val_b1);

            // color picker code for rgb led 2
            rmode2_want_val_r2 = PApplet.parseInt(random(255));
            rmode2_want_val_g2 = PApplet.parseInt(random(255));
            rmode2_want_val_b2 = PApplet.parseInt(random(255));
            
            
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
public void rmode4() {

  // sanity check input values, or generate random ones
  if ((marker >= 0) && (marker <= 1023)) {  
    rmode4_inc = ((1024 - marker) / 16);
  } else { rmode4_inc = PApplet.parseInt(10 + random(40)); }
  if ((oscillator >= 0) && (oscillator <= 1023)) {
    rmode4_start = (oscillator / 8);
  } else { rmode4_start = PApplet.parseInt(random(1023)); }

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
        int ct1 = Color.HSBtoRGB((PApplet.parseFloat(rmode4_osc_val) / 1023), 1.0f, (PApplet.parseFloat(rmode4_val1) / 255));
        r1.update(ct1);
        if (xtalswitch != 1) {  
          r2.update(ct1);
        }
      }
      // reverse at peak
      if (rmode4_val1 >= (255 - rmode4_inc)) {
        rmode4_direction = 0;
        rmode4_val1 = 255;
        int ct1 = Color.HSBtoRGB((PApplet.parseFloat(rmode4_osc_val) / 1023), 1.0f, (PApplet.parseFloat(rmode4_val1) / 255));
        r1.update(ct1);
        if (xtalswitch != 1) {  
          r2.update(ct1);
        }
      }
    } // end fade up, switch to down
    
    if (rmode4_direction == 0) {
      // going down
      if ((rmode4_val1 - rmode4_inc) >= 0) {
        rmode4_val1 -= rmode4_inc;
        int ct1 = Color.HSBtoRGB((PApplet.parseFloat(rmode4_osc_val) / 1023), 1.0f, (PApplet.parseFloat(rmode4_val1) / 255));
        r1.update(ct1);
        if (xtalswitch != 1) {  
          r2.update(ct1);
        }
      }
      // reverse and reset 
      if (rmode4_val1 <= rmode4_inc) { 
        rmode4_val1 = 0;
        // change direction back to up
        rmode4_direction = 1; 
        // reset counter
        rmode4_ticks = 0;
        int ct1 = Color.HSBtoRGB((PApplet.parseFloat(rmode4_osc_val) / 1023), 1.0f, (PApplet.parseFloat(rmode4_val1) / 255));
        r1.update(ct1);
        if (xtalswitch != 1) {  
          r2.update(ct1);
        } 
        // bring in new color after fade completes
        rmode4_osc_val = rmode4_osc_val2;
      }
    } // end fade down, reset
    
    // turn off 2nd channel if ext switch is off
    if (xtalswitch == 1) {  
      r2.update(color(0, 0, 0));
    }
  } // end pulse start if statement
  
  // marker amp changes the color         
  if (markerampswitch == 0) {
    // debug: println("markerampswitch=0");
    if ((markeramp >= 0) && (markeramp <= 1023)) {
      if (random(1024) < markeramp) {
        if (random(100) > 95) rmode4_osc_val2 = PApplet.parseInt(random(360));
      }
    }
  } // end phase switch
        
}  // end of rmode=4 - ping   
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
float rmode5_sat = 1.0f;

// this defines the minimum speed
int rmode5_inc_min = 5;

// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
public void rmode5() {
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
  
    // Color.HSBtoRGB(float hue,float saturation,float brightness)
    // create a color in hsb colorspace, then convert it to rgb values
    // in hsb, incrementing hue 0-360 spins the color wheel
    // "oscillator" knob = hue
    // "marker amp" knob = saturation
    // 0-255 sinewave = brightness
    int ct1 = Color.HSBtoRGB((PApplet.parseFloat(rmode5_osc_val) / 1023), rmode5_sat, (PApplet.parseFloat(255-rmode5_value) / 255));
    int ct2 = Color.HSBtoRGB((PApplet.parseFloat(rmode5_osc_val) / 1023), rmode5_sat, (PApplet.parseFloat(255-rmode5_value2) / 255));
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
          //if (random(100) > 90) { rmode5_value = int(random(255)); }
          //if (random(100) < 10) { rmode5_value2 = int(random(255)); }
          
          // white flashes
          //if (random(100) > 90) { float a = random(255); r1.update(color(a, a, a)); }
          //if (random(100) > 90) { float b = random(255); r2.update(color(b, b, b)); }
          
          // change saturation of current HSB color (fade to white)
          rmode5_sat = (PApplet.parseFloat(1024 - markeramp) / 1023);
          
        } // end marker amp adjustment
        
      } // end marker knob nonzero validation
      
    } else {
      
      // reset saturation to full
      rmode5_sat = 1.0f;
      
    } // end marker amp switch

  } // end mode1 ticks counter

} // end of rmode=5 (breathe)
/*
 * rmode=6 - binary pattern 00,01,10,11
 * "marker" controls color one
 * "oscillator" controls color zero
 * "marker amp" adjusts the speed (frame delay)
 * "xtal" makes the LEDs turn white
 */


// initialize default values
int rmode6_ticks = 0, rmode6_start = 20;

// pattern definition
// each line is one frame
// r1, g1, b1, r2, g2, b2
// binary 00,01,10,11
int[][] mode7_pattern = {  {0, 0, 0,  0, 0, 0},
                           {0, 0, 0,  255, 255, 255},
                           {255, 255, 255,  0, 0, 0},
                           {255, 255, 255,  255, 255, 255}  };
                           
// green/white chasing
//int[][] mode7_pattern = {  {0, 255, 0,  255, 255, 255},
//                           {255, 255, 255,  0, 255, 0}   };
                           
int rmode6_frames = mode7_pattern.length;
int rmode6_cur_frame = 0;
float rmode6_hue;
float rmode6_hue2;



// function is called inside a switch case in the main loop
// only do 1 frame worth of changes per call to this function
public void rmode6() {

  // sanity check input values, or generate random ones
  if ((marker >= 0) && (marker <= 1023)) {  
    rmode6_hue = ((1024 - marker) / 3);
  } else { rmode6_hue = PApplet.parseInt(10 + random(350)); }
  if ((oscillator >= 0) && (oscillator <= 1023)) {
    rmode6_hue2 = (oscillator / 3);
  } else { rmode6_start = PApplet.parseInt(random(1023)); }

  // Color.HSBtoRGB(float hue,float saturation,float brightness)
  // create a color in hsb colorspace, then convert it to rgb values
  // in hsb, incrementing hue 0-360 spins the color wheel
  // 0-1.0 = brightness, saturation
  //color ct1 = Color.HSBtoRGB((float(rmode1_osc_val) / 1023), rmode1_sat, (float(rmode1_value) / 255));
  //color ct2 = Color.HSBtoRGB((float(rmode1_osc_val) / 1023), rmode1_sat, (float(rmode1_value2) / 255));


  // delay timer for action
  rmode6_ticks += 1;
  if (rmode6_ticks > rmode6_start) {
    
    // reset counter, comment for speed
    rmode6_ticks = 0;


    // xtal switch changes color to white
    if (xtalswitch == 1) {  
      
      // shift colors using knobs
      int sh1 = Color.HSBtoRGB((rmode6_hue / 360), 1.0f, PApplet.parseFloat(mode7_pattern[rmode6_cur_frame][0] / 255));
      int sh2 = Color.HSBtoRGB((rmode6_hue2 / 360), 1.0f, PApplet.parseFloat(mode7_pattern[rmode6_cur_frame][3] / 255));
      r1.update(sh1);
      r2.update(sh2);
      
    } else {
      
      // static rgb mode
      int ct1 = color(mode7_pattern[rmode6_cur_frame][0], mode7_pattern[rmode6_cur_frame][1], mode7_pattern[rmode6_cur_frame][2]);
      int ct2 = color(mode7_pattern[rmode6_cur_frame][3], mode7_pattern[rmode6_cur_frame][4], mode7_pattern[rmode6_cur_frame][5]);
      r1.update(ct1);
      r2.update(ct2);
      
    }

    // frame advance control
    if (rmode6_cur_frame < (rmode6_frames - 1)) {
      // move to next frame
      rmode6_cur_frame += 1;
    } else {
      // end of frames, restart
      rmode6_cur_frame = 0;
    }

  } // delay timer if statement
  
  // marker amp changes the speed         
  if (markerampswitch == 0) {
    // debug: println("markerampswitch=0");
    if ((markeramp >= 0) && (markeramp <= 1023)) {
      rmode6_start = 64 - (markeramp / 16);
    }
  } // end marker amp
        
}  // end of rmode=6 - ping   

// serial stuff
Serial box;
String indata = null;
String invals[];
boolean fakeserial = false;

// check for serial data, or fake it
public void checkserial() {
  if (!fakeserial) if (box.available() > 0) {
    
    // read string terminated by LF
    indata = box.readStringUntil(lf);
    
    // ignore null reads
    if (indata != null) {
      
      // strip off the trailing CR/LF
      indata = split(indata, ccr)[0];

      // explode string into an array
      invals = split(indata, ',');
      
      // debugging
      //println(indata);

      //println(indata.length());
      
      // only bring in values from complete reads
      if (invals.length == 14) {
        
        // switches
        phaseswitch = Integer.parseInt(invals[0]);
        markerampswitch = Integer.parseInt(invals[1]);
        attenswitch1 = Integer.parseInt(invals[4]);
        attenswitch2 = Integer.parseInt(invals[2]);
        attenswitch3 = Integer.parseInt(invals[3]);
        xtalswitch = Integer.parseInt(invals[5]);
        extmarkswitch = Integer.parseInt(invals[6]);
        redswitch = Integer.parseInt(invals[7]);
        
        // knobs
        marker = Integer.parseInt(invals[8]);
        oscillator = Integer.parseInt(invals[9]);
        markeramp = Integer.parseInt(invals[10]);
        horphase = Integer.parseInt(invals[11]);
        fineatten = Integer.parseInt(invals[12]);
        sweepwidth = Integer.parseInt(invals[13]); 
                 
      } // end parsing values into invals[]

    } // bad reads if
    
  } // end box.available/fakeserial if statements
  
} // end checkserial()

// java imports



// background image
PImage ufoimg;

// led objects
RGBLed r1;
RGBLed r2;
GrnLed g1;
GrnLed g2;

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
int attenswitch2 = 1;
int attenswitch3 = 1;

// CR/LF in ascii
int lf = 10;
char clf = 10;
int cr = 13;
char ccr = 13;


// this function only runs once, at application start
public void setup() {
  
  // setup graphical output
  size(412, 291);
  
  // load background ufo image
  ufoimg = loadImage("ufo.jpg");
  background(ufoimg);
  
  // use HSB (vs rgb) colors
  colorMode(RGB, 255);


  // create software LED objects
  // and initialize led positions on screen
  r1 = new RGBLed(color(0, 0, 0), 80, 180, 170, 152, 260, 138);
  r1.update(color(25, 25, 25));
  
  r2 = new RGBLed(color(0, 0, 0), 120, 163, 215, 145, 300, 138);
  r2.update(color(25, 25, 25));
  
  g1 = new GrnLed(255, 170, 190, 200, 182, 230, 177); 
  g1.update(25);
  
  g2 = new GrnLed(100, 185, 187, 215, 180, 245, 176);
  g2.update(25);
  
  
  // list serial ports
  println(Serial.list());
  
  // if serial 0 is not present, fake it
  if ( Serial.list().length > 0 ) {
    
    // Connect the serial port using the first one available
    box = new Serial(this, Serial.list()[0], 9600);
    
    // throw out the first string read (we aren't faking it)
    box.clear();
    indata = box.readStringUntil(lf);
    indata = null;
    
  } else {

    // set up simulated values in the input array
    fakeserial = true;
    indata = "1,1,1,1,0,1,1,1,19,0,0,2,989,0";

    // explode string into an array
    invals = split(indata, ',');  

  } // serial presence if
    
   
} // setup() close
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#DFDFDF", "ufodummy" });
  }
}
