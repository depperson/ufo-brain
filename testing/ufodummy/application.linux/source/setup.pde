
// java imports
import processing.serial.*;
import java.awt.Color;

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
void setup() {
  
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
