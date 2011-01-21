/*
 * patternmode=0 - simple, slow pattern player
 * "marker" 
 * "oscillator" controls the speed
 * "marker amp" 
 * "xtal" 
 */



// pattern 0 - binary pattern 00,01,10,11
const int pm0_pattern0_frames = 4;
// values as follows:                             r1,  g1,  b1,   r2,  g2,  b2,  g4,  g3
int pm0_pattern0[pm0_pattern0_frames][8] = {    {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,  255, 255, 255,   0, 255},
                                                {255, 255, 255,    0,   0,   0, 255,   0},
                                                {255, 255, 255,  255, 255, 255, 255, 255}  };
                                                
// pattern 1 - binary pattern 00,01,10,11
// same as 0, just switches g3 and g4

// pattern 2 - swirly somethingorother
const int pm0_pattern2_frames = 19;
// values as follows:                             r1,  g1,  b1,   r2,  g2,  b2,  g4,  g3
int pm0_pattern2[pm0_pattern2_frames][8] = {    {  0,   0,   0,    0,   0,   0,   0, 255},
                                                {  0,   0,   0,    0,   0,   0, 255,   0},
                                                {  0,   0,   0,    0,   0,   0, 255, 255},
                                                {  0,   0,   0,    0,   0,   0,   0, 255},
                                                {  0,   0,   0,  255, 255, 255,   0, 255},
                                                {255, 255, 255,  255, 255, 255, 255,   0},
                                                {255, 255, 255,    0,   0,   0, 255, 255},
                                                {255, 255, 255,    0,   0,   0,   0, 255},
                                                {255, 255, 255,  255, 255, 255,   0, 255},
                                                
                                                {255, 255, 255,  255, 255, 255, 255, 255},
                                                
                                                {255, 255, 255,  255, 255, 255,   0, 255},
                                                {255, 255, 255,    0,   0,   0,   0, 255},
                                                {255, 255, 255,    0,   0,   0, 255, 255},
                                                {255, 255, 255,  255, 255, 255, 255,   0},
                                                {  0,   0,   0,  255, 255, 255,   0, 255},
                                                {  0,   0,   0,    0,   0,   0,   0, 255},
                                                {  0,   0,   0,    0,   0,   0, 255, 255},
                                                {  0,   0,   0,    0,   0,   0, 255,   0},
                                                {  0,   0,   0,    0,   0,   0, 255,   0}   };



// pattern 3 - chasing
const int pm0_pattern3_frames = 2;
// values as follows:                             r1,  g1,  b1,   r2,  g2,  b2,  g4,  g3
int pm0_pattern3[pm0_pattern3_frames][8] = {    {255, 255, 255,    0,   0,   0, 255,   0},
                                                {  0,   0,   0,  255, 255, 255,   0, 255}   };
                                                

// pattern 4 - chasing
const int pm0_pattern4_frames = 8;
// values as follows:                             r1,  g1,  b1,   r2,  g2,  b2,  g4,  g3
int pm0_pattern4[pm0_pattern4_frames][8] = {    {255,   0,   0,    0,   0,   0,   0,   0},
                                                {  0, 255,   0,    0,   0,   0,   0,   0},
                                                {  0,   0, 255,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,  255,   0,   0,   0,   0},
                                                {  0,   0,   0,    0, 255,   0,   0,   0},
                                                {  0,   0,   0,    0,   0, 255,   0,   0},
                                                {  0,   0,   0,    0,   0,   0, 255,   0},
                                                {  0,   0,   0,    0,   0,   0,   0, 255}   };             
                
                
// pattern 5 - pulse
const int pm0_pattern5_frames = 32;
// values as follows:                             r1,  g1,  b1,   r2,  g2,  b2,  g4,  g3
int pm0_pattern5[pm0_pattern5_frames][8] = {    {255, 255, 255,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,  255, 255, 255,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0, 255,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0, 255},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},
                                                {  0,   0,   0,    0,   0,   0,   0,   0},                                                
                                                {  0,   0,   0,    0,   0,   0,   0,   0}   };                                   

                                         
                                         


long patternmode0_cur_frame = 0;
long no_action_ticks = 1000;
long no_action_ticks_min = 10;

// microseconds
int no_action_delay_micros = 450;
long pm0_ticks = 0;


void patternmode0(int pattern_number) {

  // increment the ticks counter
  pm0_ticks++;
  
  if (pm0_ticks > no_action_ticks) {
    
    // timing
    //int blah = micros();
    
    // reset the counter
    pm0_ticks = 0;
    
    // advance the frame counter 
    patternmode0_cur_frame++;
    
    // use oscillator knob to adjust no_action_ticks
    if ((oscillator >= 1) && (oscillator < 1025)) {
      no_action_ticks = no_action_ticks_min + (oscillator*3);
    }
    
    // use sweep width knob to randomly add delays
    if (random(1024) < sweepwidth) {
      // debug:
      //Serial.print("sweepwidth=");
      //Serial.println(sweepwidth);
      
      //if (random(10) > 5) no_action_ticks += int(random(sweepwidth*3));
      if (random(10) > 5) no_action_ticks = int(random(sweepwidth*3));
      
      
      // debug:
      //Serial.print("no_action_ticks=");
      //Serial.println(no_action_ticks);
    }
    
    // play the selected pattern
    switch (pattern_number) {
      
      default:
      case 0:
        
        // pattern 0
        
        // wrap frame counter if it exceeds number of frames
        patternmode0_cur_frame = patternmode0_cur_frame % pm0_pattern0_frames; 
        
        // update the rgb leds
        r1update(pm0_pattern0[patternmode0_cur_frame][0], pm0_pattern0[patternmode0_cur_frame][1], pm0_pattern0[patternmode0_cur_frame][2]);
        r2update(pm0_pattern0[patternmode0_cur_frame][3], pm0_pattern0[patternmode0_cur_frame][4], pm0_pattern0[patternmode0_cur_frame][5]);
        
        // update the green leds
        g1update(pm0_pattern0[patternmode0_cur_frame][7]);
        g2update(pm0_pattern0[patternmode0_cur_frame][6]);

        break; 
        

      case 1:
        
        // pattern 1 (pattern 0 with green leds switched)
        
        // wrap frame counter if it exceeds number of frames
        patternmode0_cur_frame = patternmode0_cur_frame % pm0_pattern0_frames; 
        
        // update the rgb leds
        r1update(pm0_pattern0[patternmode0_cur_frame][0], pm0_pattern0[patternmode0_cur_frame][1], pm0_pattern0[patternmode0_cur_frame][2]);
        r2update(pm0_pattern0[patternmode0_cur_frame][3], pm0_pattern0[patternmode0_cur_frame][4], pm0_pattern0[patternmode0_cur_frame][5]);
        
        // update the green leds
        g1update(pm0_pattern0[patternmode0_cur_frame][6]);
        g2update(pm0_pattern0[patternmode0_cur_frame][7]);

        break; 
      
      
      case 2:
        
        // pattern 2
        
        // wrap frame counter if it exceeds number of frames
        patternmode0_cur_frame = patternmode0_cur_frame % pm0_pattern2_frames;  
        
        // update the rgb leds
        r1update(pm0_pattern2[patternmode0_cur_frame][0], pm0_pattern2[patternmode0_cur_frame][1], pm0_pattern2[patternmode0_cur_frame][2]);
        r2update(pm0_pattern2[patternmode0_cur_frame][3], pm0_pattern2[patternmode0_cur_frame][4], pm0_pattern2[patternmode0_cur_frame][5]);
        
        // update the green leds
        g1update(pm0_pattern2[patternmode0_cur_frame][7]);
        g2update(pm0_pattern2[patternmode0_cur_frame][6]);
        
        break; 
        
        
      case 3:
        
        // pattern 3
        
        // wrap frame counter if it exceeds number of frames
        patternmode0_cur_frame = patternmode0_cur_frame % pm0_pattern3_frames;  
        
        // update the rgb leds
        r1update(pm0_pattern3[patternmode0_cur_frame][0], pm0_pattern3[patternmode0_cur_frame][1], pm0_pattern3[patternmode0_cur_frame][2]);
        r2update(pm0_pattern3[patternmode0_cur_frame][3], pm0_pattern3[patternmode0_cur_frame][4], pm0_pattern3[patternmode0_cur_frame][5]);
        
        // update the green leds
        g1update(pm0_pattern3[patternmode0_cur_frame][7]);
        g2update(pm0_pattern3[patternmode0_cur_frame][6]);
        
        break; 


      case 4:
        
        // pattern 4
        
        // wrap frame counter if it exceeds number of frames
        patternmode0_cur_frame = patternmode0_cur_frame % pm0_pattern4_frames; 
        
        // update the rgb leds
        r1update(pm0_pattern4[patternmode0_cur_frame][0], pm0_pattern4[patternmode0_cur_frame][1], pm0_pattern4[patternmode0_cur_frame][2]);
        r2update(pm0_pattern4[patternmode0_cur_frame][3], pm0_pattern4[patternmode0_cur_frame][4], pm0_pattern4[patternmode0_cur_frame][5]);
        
        // update the green leds
        g1update(pm0_pattern4[patternmode0_cur_frame][7]);
        g2update(pm0_pattern4[patternmode0_cur_frame][6]);

        break;         
      
      case 5:
        
        // pattern 5
        
        // wrap frame counter if it exceeds number of frames
        patternmode0_cur_frame = patternmode0_cur_frame % pm0_pattern5_frames; 
        
        // update the rgb leds
        r1update(pm0_pattern5[patternmode0_cur_frame][0], pm0_pattern5[patternmode0_cur_frame][1], pm0_pattern5[patternmode0_cur_frame][2]);
        r2update(pm0_pattern5[patternmode0_cur_frame][3], pm0_pattern5[patternmode0_cur_frame][4], pm0_pattern5[patternmode0_cur_frame][5]);
        
        // update the green leds
        g1update(pm0_pattern5[patternmode0_cur_frame][7]);
        g2update(pm0_pattern5[patternmode0_cur_frame][6]);

        break;    
        
    } // end pattern number switch case
    
    // debug:
    //Serial.print("frame=");
    //Serial.println(patternmode0_cur_frame);
    
    
    // change patterns sometimes
    //if (random(32767) == 1337) pm0_selected_pattern = int(random(pm0_patterns_max));
    // dont switch pattern if attenswitch3 == 0
    // switch pattern slowly if attenswitch2 == 0
    // switch pattern quickly if attenswitch1 == 0
    
    // slow pattern changer
    if (attenswitch2 == 0) {
      // only change patters after frame 0
      if (patternmode0_cur_frame == 0) {
        if (random(100) > 90) {
          pm0_selected_pattern = int(random(pm0_patterns_max));
          // debug: 
          //Serial.print("pattern=");
          //Serial.println(pm0_selected_pattern);
        }
      }
    } // end slow pattern changer
    
    // fast pattern changer
    if (attenswitch1 == 0) {
      // only change patters after frame 0
      if (patternmode0_cur_frame == 0) {
        if (random(100) > 60) {
          pm0_selected_pattern = int(random(pm0_patterns_max));
          // debug: 
          //Serial.print("pattern=");
          //Serial.println(pm0_selected_pattern);
        }
      }
    } // end fast pattern changer
    
    
        
    
    // timing
    //int now = micros() - blah;
    //Serial.println(now);

  } else {
    
    // cause a delay if no action is taken to equalize 
    // the amount of cpu time spent in this function  
    delayMicroseconds(no_action_delay_micros);
     
  } // end pm0 ticks counter
  
} // end patternmode0()
