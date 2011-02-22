import processing.core.*; 
import processing.xml.*; 

import processing.serial.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class ufodummy extends PApplet {

/*
 *
 *
 *
 */
 



Serial box;
String indata = null;
String invals[];

// line feed in ascii
int lf = 10;

public void setup() {
  
  // open serial port to box-o-knobs (it's usually 0)
  println(Serial.list());
  box = new Serial(this, Serial.list()[0], 9600);
  
  // throw out the first string read
  box.clear();
  indata = box.readStringUntil(lf);
  indata = null;

}


public void draw() {
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
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#DFDFDF", "ufodummy" });
  }
}
