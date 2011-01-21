/*
 * void checkserial();
 * 
 * Reads serial input into variables
 * or possibly come up with random values 
 */

// an example string read
// "1,1,1,1,0,1,1,1,19,0,0,2,989,0"

// a real string read
// 0,0,0,1,1,1,0,1,255,205,152,220,993,798

// for testing, use a to terminate the last string
//   1,1,1,1,0,1,1,1,19,0,0,2,989,0a

// this string should pause everything
//   1,1,1,1,0,1,1,0,19,0,0,2,989,0a

// dont fake the serial input for now
boolean fakeserial = false;

// byte and byte buffer storage
char inbyte;
char instrbuf[5];
int bufptr = 0;

// variable buffer storage
byte varbuf;
const byte numvars = 14;
int variables[numvars];
int varptr = 0;

// CR/LF,a in ascii
byte lf = 10;
byte cr = 13;
byte cm = 44;
char a = 97;

// serial reads are slow, so run a delay since we won't get data
int non_read_delay = 40;
//int non_read_delay = 25;

// check for serial data, or fake it
void checkserial() {
  
  //if (fakeserial) {

    // standalone mode
    // generate random values in place of serial input
    
    // serial reads are slow, so run a delay since we won't get data
    delayMicroseconds(non_read_delay);

  //} else {
    
    // serial input mode
    // try to only handle a byte at a time

    
    // check for bytes waiting on the serial buffer
    if (Serial.available() > 0) {
      
      // debug
      //Serial.print("serial buffer = ");
      //Serial.println(Serial.available(),DEC);
      
      // read a byte from the serial buffer
      inbyte = Serial.read();
      
      // debug
      //Serial.print("read byte ");
      //Serial.println(inbyte);
      
      // start string with LF and end with with CR (or a for testing)
      // delimited by commas
      // val,val,valCRLFval,val,valCRLF
      if ((inbyte == lf) || (inbyte == cr) || (inbyte == a)) {
        //Serial.println(inbyte);
        // byte is CR or LF or a, read last variable (if there is one) and reset the pointers
        //if (varptr > 0) {
          
          // read last variable
          int temp = atoi(instrbuf);
          
          // debug
          //Serial.println(temp);
          
          if (temp < 1030) {
            // sane read, insert value into variables array
            variables[varptr] = temp;
            
            /*
            // debug 
            Serial.print("Inserting ");
            Serial.print(temp);
            Serial.print(" into variables[");
            Serial.print(varptr);
            Serial.println("] end of string");
            */
            
            //Serial.flush();
            
            
          } else {
            
            // debug
            Serial.print("Failed to read atoi(instrbuf), got ");
            Serial.println(temp);
            
          } // end atoi result sanity check
          
        //} else { Serial.print(varptr); } // end varptr check

        
        // reset buffer and variable pointers to 0
        bufptr = 0;
        varptr = 0;
        
        // empty the byte buffer
        for (int x=0; x<5; x++) {
          instrbuf[x] = 0;
        }
        
        
        // string processing complete
        // copy values from variables[] to individual named variables
        
        // switches
        phaseswitch = variables[0];
        markerampswitch = variables[1];
        attenswitch1 = variables[4];
        attenswitch2 = variables[2];
        attenswitch3 = variables[3];
        xtalswitch = variables[5];
        extmarkswitch = variables[6];
        redswitch = variables[7];
        
        // knobs
        marker = variables[8];
        oscillator = variables[9];
        markeramp = variables[10];
        horphase = variables[11];
        fineatten = variables[12];
        sweepwidth = variables[13]; 
        
        
        
      } else if ((inbyte >= 48 ) && (inbyte <= 57)) {
        
        // bytes 48-57 are ascii 0-9
        // this byte is a slice of a variable
        instrbuf[bufptr] = inbyte;
        
        /*
        // debug
        Serial.print("Inserting ");
        Serial.print(inbyte);
        Serial.print(" into instrbuf[");
        Serial.print(bufptr);
        Serial.println("]");
        
        */
        
        // increase byte buffer pointer
        bufptr++;
        
      } else if (inbyte == cm) {
        
        // byte is , (comma) 
        
        // variable is complete, attempt extracting an int
        int temp = atoi(instrbuf);
        
        if (temp < 1030) {
          // sane read, insert value into variables array
          variables[varptr] = temp;
          
          /*
          // debug 
          Serial.print("Inserting ");
          Serial.print(temp);
          Serial.print(" into variables[");
          Serial.print(varptr);
          Serial.println("]");
          */
          
          
        } else {
          
          // debug
          Serial.print("Failed to read atoi(instrbuf), got ");
          Serial.println(temp);
          
        }
        
        // reset byte buffer pointer
        bufptr = 0;
        
        // empty the byte buffer
        for (int x=0; x<5; x++) {
          instrbuf[x] = 0;
        }
        
        // increase variable pointer
        varptr++;
        
     
      } // end byte detection if/else
      
    } else {
      
      // serial data is not available
      // serial reads are slow, so run a delay if we dont get any data
      delayMicroseconds(non_read_delay);
      
    }// end serial available if/else
    
  //} // end fakeserial if
    
} // end checkserial()

