// led related functions

// green led pwm pins
int g1pin = 5;
int g2pin = 6;

// green led channels on the TI chip
int g1grn = 8;
int g2grn = 9;

// rgb channels on the TI chip
int r1red = 10;
int r1grn = 11;
int r1blu = 12;
int r2red = 13;
int r2grn = 14;
int r2blu = 15;


// update 1st green led
void g1update(int val) {
  
  
  // marker knob (20-960) reduces val
  if ((marker > 0) && (marker < 1024)) {
    val = map(marker, 1000, 0, 0, val);
  }
  
  // horphase distors green led values
  if (phaseswitch == 0) {
    if (random(1024) < horphase) {
      if (random(10) > 3) val = int(random(255));
      // debug: Serial.println("green distortion");
    }
  } // end phase switch
  
  // extmarkswitch inverts green leds
  if (extmarkswitch != 0) {
    // no extmarkswitch, act normal
    analogWrite(g1pin, 255 - val);  
    //Tlc.set(g1grn, map(255-val, 0, 255, 4095, 0));
  } else {
    // extmarkswitch, invert everything
    analogWrite(g1pin, val);  
    //Tlc.set(g1grn, map(val, 0, 255, 4095, 0));
  } // end extmarkswitch
    
} // end g1update


// update 2nd green led
void g2update(int val) {
  
  
  // marker knob (20-960) reduces val
  if ((marker > 0) && (marker < 1024)) {
    val = map(marker, 1000, 0, 0, val);
  }
  
  // horphase distors green led values
  if (phaseswitch == 0) {
    if (random(1024) < horphase) {
      if (random(10) > 3) val = int(random(255));
      // debug: Serial.println("green distortion");
    }
  } // end phase switch
  
  // extmarkswitch inverts green leds
  if (extmarkswitch != 0) {
    
    // no extmarkswitch, act normal
    analogWrite(g2pin, 255 - val);  
    //Tlc.set(g2grn, map(255-val, 0, 255, 4095, 0));
    
  } else {
    
    // extmarkswitch, invert everything
    analogWrite(g2pin, val);  
    //Tlc.set(g2grn, map(val, 0, 255, 4095, 0));
    
  } // end extmarkswitch
    
} // end g2update



// update 1st rgb channel
void r1update(long r, long g, long b) {
  
  
  // marker knob (20-960) reduces r,g,b vals
  if ((marker > 0) && (marker < 1024)) {
    r = map(marker, 1000, 0, 0, r);
    g = map(marker, 1000, 0, 0, g);
    b = map(marker, 1000, 0, 0, b);
  }
  
  // markeramp distorts r,g,b values
  if (markerampswitch == 0) {
    
    // debug:
    //Serial.print("markeramp=");
    //Serial.println(markeramp); 
    
    if (random(1024) < markeramp) {
      // debug: Serial.println("rgb distortion");
      if (random(10) > 3) r = int(random(255));
      if (random(10) > 3) g = int(random(255));
      if (random(10) > 3) b = int(random(255));
    }
  }
  
  
  
  // xtal switch inverts rgb leds
  if (xtalswitch != 0) {

    // no xtal switch, act normal
    Tlc.set(r1red, map(r, 0, 255, 4095, 0));
    Tlc.set(r1grn, map(g, 0, 255, 4095, 0));
    Tlc.set(r1blu, map(b, 0, 255, 4095, 0));
    
  } else {
  
    // invert rgb leds
    Tlc.set(r1red, map(r, 0, 255, 0, 4095));
    Tlc.set(r1grn, map(g, 0, 255, 0, 4095));
    Tlc.set(r1blu, map(b, 0, 255, 0, 4095));
    
  } // end xtal switch if

} // end r1update


// update 2nd rgb channel
void r2update(long r, long g, long b) {
  
  
  // marker knob (20-960) reduces r,g,b vals
  if ((marker > 0) && (marker < 1024)) {
    r = map(marker, 1000, 0, 0, r);
    g = map(marker, 1000, 0, 0, g);
    b = map(marker, 1000, 0, 0, b);
  }
  
  // markerampswitch distorts r,g,b values
  if (markerampswitch == 0) {
    
    // debug:
    //Serial.print("markeramp=");
    //Serial.println(markeramp); 
    
    if (random(1024) < markeramp) {
      // debug: Serial.println("rgb distortion");
      if (random(10) > 3) r = int(random(255));
      if (random(10) > 3) g = int(random(255));
      if (random(10) > 3) b = int(random(255));
    }
  }
  
  // xtal switch inverts rgb leds
  if (xtalswitch != 0) {
  
    // no xtal switch, act normal
    Tlc.set(r2red, map(r, 0, 255, 4095, 0));
    Tlc.set(r2grn, map(g, 0, 255, 4095, 0));
    Tlc.set(r2blu, map(b, 0, 255, 4095, 0));
    
  } else {
  
    // invert rgb leds
    Tlc.set(r2red, map(r, 0, 255, 0, 4095));
    Tlc.set(r2grn, map(g, 0, 255, 0, 4095));
    Tlc.set(r2blu, map(b, 0, 255, 0, 4095));
    
  } // end xtal switch if
  
} // end r2update

