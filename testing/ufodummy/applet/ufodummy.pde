/*
 *
 *
 *
 */
 
import processing.serial.*;


Serial box;
String indata = null;
String invals[];

// line feed in ascii
int lf = 10;

void setup() {
  
  // open serial port to box-o-knobs (it's usually 0)
  println(Serial.list());
  box = new Serial(this, Serial.list()[0], 9600);
  
  // throw out the first string read
  box.clear();
  indata = box.readStringUntil(lf);
  indata = null;

}


void draw() {
  if (box.available() > 0) {
    // read string terminated by LF
    indata = box.readStringUntil(lf);
    if (indata != null) {
      println(indata);
      invals = split(indata, ',');
      println(invals[0]);
    }
  }
}
