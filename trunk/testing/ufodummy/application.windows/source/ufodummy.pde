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
void draw() {
  
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
          gmode = int(random(gmode_max + 1));
          // make mode 0 and 3 happen less
          if (((gmode == 0) || (gmode == 3)) && (random(100) > 60)) gmode = int(random(gmode_max + 1));
          println("gmode=" + gmode);
        }
        if (random(1000) < 100) {
          rmode = int(random(rmode_max + 1));
          // make mode zero happen less
          if (((rmode == 0) || (rmode == 3)) && (random(100) > 60)) rmode = int(random(rmode_max + 1));
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
