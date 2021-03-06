//
// UNION Creative / http://unioncreative.com 
// Data Viz Project; data supplied through GA traffic, browsing behaviour + events
// By: Jordan Shaw
// 
// =========== 
// 
// Flocking inspiration from Daniel Shiffman + http://natureofcode.com
//
// ===========
//
// Flocking Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment


Flock flock;
Table table;
PVector center;

boolean showvalues = true;
boolean scrollbar = false;

int max_page_views = 0;
int max_u_page_views = 0;

void setup() {
  frameRate(30);
  size(displayWidth,displayHeight,P2D);
  setupScrollbars();
  center = new PVector(width/2,height/2);
  colorMode(RGB,255,255,255,100);
  
  table = loadTable("ga_demo_lg.csv", "header");

  println(table.getRowCount() + " total rows in table"); 

  flock = new Flock();

  for (TableRow row : table.rows()) {
    
    String page = row.getString("Page");
    int page_views = row.getInt("Page Views");
    int unique_page_views = row.getInt("Unique Page Views");
    
    println(page);
    println( page_views + " page views / " + unique_page_views + " unique page views" );
    
    if(int(page_views) >= max_page_views ){
      max_page_views = page_views;
    }
    
    if(int(unique_page_views) >= max_u_page_views ){
      max_u_page_views = unique_page_views;
    }
    
    if(page_views > 0){
      println( (float)unique_page_views / (float)page_views );
    }
    
    println("*************************");
    
    if(page_views > 0){
     println(unique_page_views / page_views);
     flock.addBoid(new Boid(random(0,width),random(0,height), (float)max_u_page_views, (float)page_views, (float)unique_page_views));
    }
      
  }
  
  println( max_page_views + " max_page_views / " + max_u_page_views + " max_u_page_views" );
  
  smooth();
}


void draw() {

  background(255, 255, 255); 
  flock.run();
  drawScrollbars();

  if (mousePressed && !scrollbar) {
    flock.addBoid(new Boid(mouseX,mouseY, 1, 1, 1));
  }


  if (showvalues) {
    fill(0);
    textAlign(LEFT);
    text("Total boids: " + flock.boids.size() + "\n" + "Framerate: " + round(frameRate) + "\nPress any key to show/hide sliders and text\nClick mouse to add more boids",5,100);
  }
}

void keyPressed() {
  showvalues = !showvalues;
}

void mousePressed() {
}