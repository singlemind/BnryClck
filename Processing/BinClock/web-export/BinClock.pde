/**
 * A simple binary clock.
 * ...with a weird set of features
 * 
 * author: edward sharp
 * year: 2012
 * license: creative commons
 */

int FRAMERATE = 10;
String info="";
boolean showTime=false; 
boolean clickAndHold=false;
int clickAndHoldTimer=0;
float blockHue = 12;
color timeHue = 200;
float s = 200;
float b = 200;
float blockSat = 200;
float blockBri = 200;
PFont font;
int startingTime, seconds, sketch_width, sketch_height;

BinaryClock binClock;


void setup() {

  // width & height for android?
  sketch_width = screenWidth / 3;
  sketch_height = screenHeight / 3;
  //iPhone is 480x320, HTC Thunderbolt is 480x800
  
  //for Androids...
  //orientation(LANDSCAPE);
  
  size(sketch_width, sketch_height);
   
  //hue, saturation, bal with 200 limit
  colorMode(HSB, 200);

  background(0);

  //generally only need 1fps for a clock 
  // however a faster framerate makes the mouseclick more responsive & the fades more vivd...
  frameRate(FRAMERATE);
  // constructor, no parameters
  binClock = new BinaryClock();

  //#TODO: use createFont
  //font = loadFont("SansSerif-100.vlw");
  //textFont(font, 100);
  
  //String[] fontList = PFont.list(); //print out a list of useable fonts
  //println(fontList);
  font = createFont("SansSerif", binClock.getYRectSize());
  textFont(font);
}

void draw() {
  binClock.display();

  if ( mousePressed ) { 

    clickAndHoldTimer +=1;
    if ( clickAndHoldTimer > 3 ) {
      clickAndHold = true;
    }
    //println("CLICKANDHOLD: "+clickAndHold);
  }
}

void keyPressed() {
  if (key=='s') {
    showTime=!showTime;
  }
  //#TODO: fix this up... 
  /*try {
   //int myMenuKeyCode = KeyEvent.KEYCODE_MENU;
   if (key == CODED && keyCode == KeyEvent.KEYCODE_MENU) {
   showTime=!showTime;
   }
   } catch (NullPointerException e) 
   {
   //#TODO:keep calm.
   
   }
   */
}

void mousePressed() {
  /*if( mouseButton==LEFT ){
   showTime=!showTime;
   } */
}

void mouseReleased() {
  if (!clickAndHold) {
    //println("GONNA CHANGE THE TIME");
    showTime=!showTime;
  }
  clickAndHold = false;
  clickAndHoldTimer = 0;
  //println(" clickAndHold:"+clickAndHold);
}

void mouseDragged() {
  if (clickAndHold) {
    blockHue = map(mouseX, 0, width, 0.0, 200.0);
    s =  map(mouseY, 0, width, 50.0, 200.0);
    b =  map(mouseY, 0, width, 50.0, 200.0);
    timeHue = complymentary(blockHue, mouseX, 100);
  }
}

color complymentary(float c, float all, int e) {
  //#TODO: sort out float->int conversion 
  int int_color= Math.round(c);
  float h = hue(int_color);
  float s = saturation(int_color);
  float b = brightness(int_color);
  float angle = 200/all*e;

  h = h + angle;

  if (h> 200) {
    h = h - 200;
  }

  return(color(h, s, 200));
}

class BinaryClock {
  int strk = 0;
  int c_bg = 0;
  int sqr = 2;
  int alphaDelta = 1; 
  int alphaValue = 255;   
  int c_on = #ff6600;
  int c_off = 0;
  int timeColor1 = #ededed;
  int timeColor2 = #ff6600;
  String[] hStr, mStr, sStr;

  //dynamically calculate the size of a single box determined by the sketch height & width.
  int xRectSize = sketch_width / 6;  
  int yRectSize = sketch_height / 4;

  //since were for looping down from 3 we need the offset of (what would be) the bottom box
  int yOffset = yRectSize * 3;
  int xRect0 = 0;
  int xRect1 = xRectSize;
  int xRect2 = xRectSize * 2;
  int xRect3 = xRectSize * 3;
  int xRect4 = xRectSize * 4;
  int xRect5 = xRectSize * 5;

  // #TODO: constructor with paramz?
  BinaryClock() {
  }
  
  int getYRectSize() {
    //return yRectSize to be used for setting the font size.
    return yRectSize;
  }
  
  void display() {

    // mod 10 the current time into 6 columnz (hh:mm:ss)
    int s = second();
    int s0 = s % 10;
    int s1 = (s - s0)/10;
    int m = minute();
    int m0 = m % 10;
    int m1 = (m - m0)/10;
    int h = hour();
    int h0 = h % 10;
    int h1 = (h - h0)/10;

    // step the alpha an entire cycle every second. 
    // multiply by FRAMERATE (steppin, yo).
    alphaValue += alphaDelta + ( alphaValue / FRAMERATE );
    alphaDelta++;
    if ( alphaDelta >= FRAMERATE-1 ) { 
      alphaDelta = 0;
    }
    if (alphaValue > 255) { 
      alphaValue = 0;
    } 

    //for each HH, MM, SS turn on the results from last run, recalculate next second and draw the rect...
    for ( int i=3; i>=0; i-- ){
      int yRect = yOffset-(i*yRectSize);     
      noStroke();
      
      if ( h1 >= pow(sqr, i) ){
        h1 -= pow(sqr, i);
        fill(blockHue, blockSat, blockBri, alphaValue);
      } else {    
        fill(c_off);
      } 
      rect(xRect0, yRect, xRectSize, yRectSize);
      
      if ( h0 >= pow(sqr, i) ){
        h0 -= pow(sqr, i);
        fill(blockHue, blockSat, blockBri, alphaValue);
      } else {
        fill(c_off);
      }

      rect(xRect1, yRect, xRectSize, yRectSize);
      
      if ( m1 >= pow(sqr, i) ){
        m1 -= pow(sqr, i);
        fill(blockHue, blockSat, blockBri, alphaValue);
      } else {
        fill(c_off);
      }
      
      rect(xRect2, yRect, xRectSize, yRectSize);
      
      if ( m0 >= pow(sqr, i) ){
        m0 -= pow(sqr, i);
        fill(blockHue, blockSat, blockBri, alphaValue);
      } else { 
        fill(c_off);
      }
      
      rect(xRect3, yRect, xRectSize, yRectSize);
      
      if ( s1 >= pow(sqr, i) ){
        s1 -= pow(sqr, i);
        fill(blockHue, blockSat, blockBri, alphaValue);
      } else{
        fill(c_off);
      }
      
      rect(xRect4, yRect, xRectSize, yRectSize);
      
      if ( s0 >= pow(sqr, i) ){
        s0 -= pow(sqr, i);
        fill(blockHue, blockSat, blockBri, alphaValue);
      } else {
        fill(c_off);
      }
      
      rect(xRect5, yRect, xRectSize, yRectSize);
      
      //print("xRectSize: "+xRectSize+" yRectSize: "+yRectSize);
      //println("xRect0: "+xRect0+" xRect1: "+xRect1+" xRect5: "+xRect5+" yRect: "+yRect+" xRectSize: "+xRectSize+" yRectSize: "+yRectSize);
      
    } //end for

    if ( showTime ){
      displayTime(h, m, s);
    }
    
  } //end display

  void displayTime(int h, int m, int s) {
    
    if (blockHue>10 && blockHue<20) {
      fill(timeHue);
    }
    else {
      fill(timeHue);
    }

    //#TODO: text outline? text is bitmap based, so stroke attributes are ignored.
    // a work-around is to just draw the text again slightly smaller.
    hStr = nf(h, 2).split("");
    mStr = nf(m, 2).split("");
    sStr = nf(s, 2).split("");
    
    //ugh, so in processing.js this index is zero-based, in regular processing it starts at 1...
    // #TODO: as a work-around, check the values at both idx 0 & 1 and try/catch accordingly
    //print(hStr[1] + hStr[2] + " " + mStr[1] + mStr[2] + " " + sStr[1] + sStr[2] + "\n");
    //print("xRectSize: "+xRectSize);
    //print("timeXOffset: "+timeXOffset);
    
    int timeYOffset = (yRectSize * 4) -  5;
    int timeXOffset = yRectSize / 3;
    int timeSepOffset = xRectSize / 7;

    text(hStr[1], xRect0+timeXOffset, timeYOffset);
    text(hStr[2], xRect1+timeXOffset, timeYOffset);
    text(":", xRect2-timeSepOffset, timeYOffset);
    text(mStr[1], xRect2+timeXOffset, timeYOffset);
    text(mStr[2], xRect3+timeXOffset, timeYOffset);
    text(":", xRect4-timeSepOffset, timeYOffset);
    text(sStr[1], xRect4+timeXOffset, timeYOffset);
    text(sStr[2], xRect5+timeXOffset, timeYOffset);
  }

}

