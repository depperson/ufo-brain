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
void gmode1() {
  
  // sanity check input values, or generate random ones
  if ((sweepwidth >= 0) && (sweepwidth <= 1023)) {  
    gmode1_val1 = sweepwidth - gmode1_val1_sub;
    //println(sweepwidth);
  } else { gmode1_val1 = int(random(1023)); }
  if ((fineatten >= 0) && (fineatten <= 1023)) {
    gmode1_val2 = fineatten;
  } else { gmode1_val2 = int(random(1023)); }
  
  // decide whether or not to change LED values
  if (random(1024) >= gmode1_val1) {
    if (random(1024) >= gmode1_val2) {
      if (random(10) > 5) {
        int a = int(random(255));
        g1update(a);
        if (extmarkswitch == 0) g2update(a);
      } else {
        g1update(0);
        if (extmarkswitch == 0) g2update(0);
      }
      if (extmarkswitch == 1) {
        if (random(10) > 5) {
          g2update(0);
        } else {
          g2update((20 + random(235)));
        }
      }
    }
  } // end led value decision
  
  // phase switch introduces quietness
  if (phaseswitch == 0) {
    // debug: println("phaseswitch=0");
    if ((horphase >= 0) && (horphase <= 1023)) {
      if (random(1024) < horphase) {
        if (random(100) > 10) g1update(0);
        if (random(100) > 10) g2update(0);
      }
    }
  } // end phase switch
  
}  // end of gmode1 (knobs control random flashes)
