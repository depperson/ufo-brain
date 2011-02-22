
// serial stuff
Serial box;
String indata = null;
String invals[];
boolean fakeserial = false;

// check for serial data, or fake it
void checkserial() {
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
