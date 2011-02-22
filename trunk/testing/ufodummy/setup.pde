
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

float H1,S1,L1,Rval1,Gval1,Bval1;
float H2,S2,L2,Rval2,Gval2,Bval2;
float H,S,L,Rval,Gval,Bval;

// thanks for the hue 2 rgb functions!
// http://www.dipzo.com/wordpress/?p=50
void HSL(float H, float S, float L, float& Rval, float& Gval, float& Bval);
float Hue_2_RGB( float v1, float v2, float vH );





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


void HSL(float H, float S, float L, float& Rval, float& Gval, float& Bval)
{
  float var_1;
  float var_2;
  float Hu=H+.33;
  float Hd=H-.33;
  if ( S == 0 )                       //HSL from 0 to 1
  {
     Rval = L * 255;                      //RGB results from 0 to 255
     Gval = L * 255;
     Bval = L * 255;
  }
  else
  {
     if ( L < 0.5 ) 
       var_2 = L * ( 1 + S );
     else           
       var_2 = ( L + S ) - ( S * L );
 
     var_1 = 2 * L - var_2;
 
     Rval = round(255 * Hue_2_RGB( var_1, var_2, Hu ));
     Serial.print("Rval:");
     Serial.println(Hue_2_RGB( var_1, var_2, Hu ));
     Gval = round(255 * Hue_2_RGB( var_1, var_2, H ));
     Bval = round(255 * Hue_2_RGB( var_1, var_2, Hd ));
  }
 
}
float Hue_2_RGB( float v1, float v2, float vH )             //Function Hue_2_RGB
{
   if ( vH < 0 ) 
     vH += 1;
   if ( vH > 1 ) 
     vH -= 1;
   if ( ( 6 * vH ) < 1 ) 
     return ( v1 + ( v2 - v1 ) * 6 * vH );
   if ( ( 2 * vH ) < 1 ) 
     return ( v2 );
   if ( ( 3 * vH ) < 2 ) 
     return ( v1 + ( v2 - v1 ) * (.66-vH) * 6 );
   return ( v1 );
}


