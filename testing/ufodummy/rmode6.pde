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
void rmode6() {

  // sanity check input values, or generate random ones
  if ((marker >= 0) && (marker <= 1023)) {  
    rmode6_hue = ((1024 - marker) / 3);
  } else { rmode6_hue = int(10 + random(350)); }
  if ((oscillator >= 0) && (oscillator <= 1023)) {
    rmode6_hue2 = (oscillator / 3);
  } else { rmode6_start = int(random(1023)); }

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
      // H1,S1,L1,Rval1,Gval1,Bval1
      H = (rmode6_hue / 360);
      S = 1.0;
      L = (float(mode7_pattern[rmode6_cur_frame][0] / 255));
      HSL(float(rotary.position())/360,S,L,Rval1,Gval1,Bval1);
      H = (rmode6_hue2 / 360);
      L = (float(mode7_pattern[rmode6_cur_frame][3] / 255));
      HSL(float(rotary.position())/360,S,L,Rval2,Gval2,Bval2);
    
      r1update(Rval1, Gval1, Bval1);
      r2update(Rval2, Gval2, Bval2);
      
      //color sh1 = Color.HSBtoRGB((rmode6_hue / 360), 1.0, float(mode7_pattern[rmode6_cur_frame][0] / 255));
      //color sh2 = Color.HSBtoRGB((rmode6_hue2 / 360), 1.0, float(mode7_pattern[rmode6_cur_frame][3] / 255));
      //r1update(sh1);
      //r2update(sh2);
      
    } else {
      
      // static rgb mode
      //color ct1 = color(mode7_pattern[rmode6_cur_frame][0], mode7_pattern[rmode6_cur_frame][1], mode7_pattern[rmode6_cur_frame][2]);
      //color ct2 = color(mode7_pattern[rmode6_cur_frame][3], mode7_pattern[rmode6_cur_frame][4], mode7_pattern[rmode6_cur_frame][5]);
      r1update(mode7_pattern[rmode6_cur_frame][0], mode7_pattern[rmode6_cur_frame][1], mode7_pattern[rmode6_cur_frame][2]);
      r2update(mode7_pattern[rmode6_cur_frame][3], mode7_pattern[rmode6_cur_frame][4], mode7_pattern[rmode6_cur_frame][5]);
      
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
