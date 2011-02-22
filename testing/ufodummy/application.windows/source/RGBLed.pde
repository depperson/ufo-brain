// RGB Led Class
class RGBLed {
  
  color c, inc;
  float x1, x2, x3;
  float y1, y2, y3;
  float s = 8;
  
  //rgbled object 
  // x,y values are LEDs on the screen
  //RGBLed(color(r,g,b), x1, y1, x2, y2, x3, y3)
  RGBLed(color inc, float inx1, float iny1, float inx2, float iny2, float inx3, float iny3) {
    c = inc;
    x1 = inx1; y1 = iny1;
    x2 = inx2; y2 = iny2;
    x3 = inx3; y3 = iny3;
  }
  
  // draw this led channel on the screen
  void display() {
    fill(c);
    ellipse(x1, y1, s, s);
    ellipse(x2, y2, s, s);
    ellipse(x3, y3, s, s);
  }
  
  // change the color of this led
  void update(color inc) {
    c = inc;
    display();
  }
  
} // end of RGBLed class

