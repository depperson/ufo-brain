// Green Led Class
class GrnLed {
  
  float x1, x2, x3;
  float y1, y2, y3;
  float b, s = 8;
  
  // grnled object 
  // x,y values are LEDs on the screen
  // GrnLed(brightness, x1, y1, x2, y2, x3, y3)
  GrnLed(float inb, float inx1, float iny1, float inx2, float iny2, float inx3, float iny3) {
    b = inb;
    x1 = inx1; y1 = iny1;
    x2 = inx2; y2 = iny2;
    x3 = inx3; y3 = iny3;
  }
  
  void display() {
    fill(color(0, b, 0));
    ellipse(x1, y1, s, s);
    ellipse(x2, y2, s, s);
    ellipse(x3, y3, s, s);
  }

  void update(float inb) {
    b = inb;
    display();
  }
  
} // end green led class
