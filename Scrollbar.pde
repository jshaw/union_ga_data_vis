// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Code based on "Scrollbar" by Casey Reas

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

float v_fader1 = 0.0f;
float v_fader2 = 0.0f;
float v_fader3 = 0.0f;
float v_fader4 = 0.0f;
float v_fader5 = 0.0f;
float v_toggle1 = 0.0f;
float v_toggle2 = 0.0f;
float v_toggle3 = 0.0f;
float v_toggle4 = 0.0f;
boolean needsRedraw = true;

HScrollbar[] hs = new HScrollbar[5];//
String[] labels =  {"separation", "alignment","cohesion","maxspeed","maxforce"};

int x = 5;
int y = 20;
int w = 50;
int h = 8;
int l = 2;
int spacing = 4;

void setupScrollbars() {
  for (int i = 0; i < hs.length; i++) {
    print("Inded: ");
    println(i);
    hs[i] = new HScrollbar(x, y + i*(h+spacing), w, h, l, i);
  }

  hs[0].setPos(0.5);
  hs[1].setPos(0.5);
  hs[2].setPos(0.5);
  hs[3].setPos(0.5);
  hs[4].setPos(0.05);

  oscP5 = new OscP5(this,8000);
  myRemoteLocation = new NetAddress("10.10.30.91", 9000);

}

void oscEvent(OscMessage theOscMessage) {

    String addr = theOscMessage.addrPattern();
    float  val  = theOscMessage.get(0).floatValue();
    
    if(addr.equals("/1/fader1"))        { v_fader1 = val; }
    else if(addr.equals("/1/fader2"))   { v_fader2 = val; }
    else if(addr.equals("/1/fader3"))   { v_fader3 = val; }
    else if(addr.equals("/1/fader4"))   { v_fader4 = val; }
    else if(addr.equals("/1/fader5"))   { v_fader5 = val; }
    else if(addr.equals("/1/toggle1"))  { v_toggle1 = val; }
    else if(addr.equals("/1/toggle2"))  { v_toggle2 = val; }
    else if(addr.equals("/1/toggle3"))  { v_toggle3 = val; }
    else if(addr.equals("/1/toggle4"))  { v_toggle4 = val; }
    
    needsRedraw = true;
}


void drawScrollbars() {
  //if (showvalues) {
  swt = hs[0].getPos()*10.0f;     //sep.mult(25.0f);
  awt = hs[1].getPos()*2.0f;     //sep.mult(25.0f);
  cwt = hs[2].getPos()*2.0f;     //sep.mult(25.0f);
  maxspeed = hs[3].getPos()*10.0f;
  maxforce = hs[4].getPos()*0.5;


  if (showvalues) {
    for (int i = 0; i < hs.length; i++) {
      hs[i].update();
      hs[i].draw();
      fill(0);
      textAlign(LEFT);
      text(labels[i],x+w+spacing,y+i*(h+spacing)+spacing);
      //text(hs[i].getPos(),x+w+spacing+75,y+i*(h+spacing)+spacing);
    }
  }
}


class HScrollbar
{
  int idx;              // index of array so we know what slider to use
  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // x position of slider
  int sposMin, sposMax;   // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  float whichFader = 0.0;

  HScrollbar (int xp, int yp, int sw, int sh, int l, int index) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
    idx = index;
  }

  void update() {
    if(over()) {
      over = true;
    } else {
      over = false;
    }
    if(mousePressed && over) {
      scrollbar = true;
      locked = true;
    }
    if(!mousePressed) {
      locked = false;
      scrollbar = false;
    }
    if(locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
      
       String fader = "";
            
      switch(idx) {
        case 0: 
          fader = "/1/fader1";
          v_fader1 = map(newspos, 0, 50, 0, 1);
          break;
        case 1: 
          fader = "/1/fader2";
          v_fader2 = map(newspos, 0, 50, 0, 1);
          break;
        case 2: 
          fader = "/1/fader3";
          v_fader3 = map(newspos, 0, 50, 0, 1);
          break;
        case 3: 
          fader = "/1/fader4";
          v_fader4 = map(newspos, 0, 50, 0, 1);
          break;
        case 4: 
          fader = "/1/fader5";
          v_fader5 = map(newspos, 0, 50, 0, 1);
          break;
      }
      
      OscMessage myMessage = new OscMessage(fader);
      float moving = map(newspos, 0, 50, 0, 1);

      //print("***MOVING SHIT: ");
      //println(moving);
      
      myMessage.add(moving); /* add an int to the osc message */
      
      /* send the message */
      oscP5.send(myMessage, myRemoteLocation);     
      
    } else {
      
      switch(idx) {
        case 0: 
          whichFader = v_fader1;
          break;
        case 1: 
          whichFader = v_fader2;
          break;
        case 2: 
          whichFader = v_fader3;
          break;
        case 3: 
          whichFader = v_fader4;
          break;
        case 4: 
          whichFader = v_fader5;
          break;
      }
      
      // println(whichFader);
      // println(int(whichFader));
      
      newspos = constrain(int(map(whichFader, 0, 1, 0, 50)), sposMin, sposMax);
      
    }
    
    if(abs(newspos - spos) > 0) {
      spos = spos + (newspos-spos)/loose;
    }
    
    //println("================================");
    
  }

  int constrain(int val, int minv, int maxv) {
    return min(max(val, minv), maxv);
  }

  boolean over() {
    if(mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } 
    else {
      return false;
    }
  }

  void draw() {
    fill(255);
    stroke(0);
    rectMode(CORNER);
    rect(xpos, ypos, swidth, sheight);
    if(over || locked) {
      fill(153, 102, 0);
    } 
    else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
    
    
    //if(needsRedraw == true){
    //  //background(0);
    //  // fader5 + toggle 1-4 outlines
    //  fill(0);
    //  stroke(0, 196, 168);  
  
    //  rect(17,21,287,55);
    //  rect(17,369,60,50);
    //  rect(92,369,60,50);
    //  rect(168,369,60,50);
    //  rect(244,369,60,50);
  
    //  // fader5 + toggle 1-4 fills
    //  fill(0, 196, 168);
    //  rect(17,21,v_fader5*287,55);
    //  if(v_toggle1 == 1.0f) rect(22,374,50,40);
    //  if(v_toggle2 == 1.0f) rect(97,374,50,40);
    //  if(v_toggle3 == 1.0f) rect(173,374,50,40);
    //  if(v_toggle4 == 1.0f) rect(249,374,50,40);
      
    //  // fader 1-4 outlines
    //  fill(0);
    //  stroke(255, 237, 0);
    //  rect(17,95,60,255);
    //  rect(92,95,60,255);
    //  rect(168,95,60,255);
    //  rect(244,95,60,255);
      
    //  // fader 1-4 fills
    //  fill(255, 237, 0);
    //  rect(17,95 + 255 - v_fader1*255,60,v_fader1*255);
    //  rect(92,95 + 255 - v_fader2*255,60,v_fader2*255);
    //  rect(168,95 + 255 - v_fader3*255,60,v_fader3*255);
    //  rect(244,95 + 255 - v_fader4*255,60,v_fader4*255);
    //  needsRedraw = false;
    //}
    
    
  }

  void setPos(float s) {
    spos = xpos + s*(sposMax-sposMin);
    newspos = spos;
  }

  float getPos() {
    // convert spos to be values between
    // 0 and the total width of the scrollbar
    return ((spos-xpos))/(sposMax-sposMin);// * ratio;
  }
}