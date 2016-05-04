// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com


// Flocking
// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system
Flock flock;
Table table;
PVector center;

boolean showvalues = true;
boolean scrollbar = false;


void setup() {
  frameRate(30);
  size(displayWidth,displayHeight,P2D);
  setupScrollbars();
  center = new PVector(width/2,height/2);
  colorMode(RGB,255,255,255,100);
  
  table = loadTable("ga_demo_lg.csv", "header");

  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows()) {
    
    String page = row.getString("Page");
    int page_views = row.getInt("Page Views");
    int unique_page_views = row.getInt("Unique Page Views");
    
    println(page);
    println( page_views + " page views / " + unique_page_views + " unique page views" );
  }
  
  
  
  flock = new Flock();
  // Add an initial set of boids into the system
  
  for (int i = 0; i < table.getRowCount(); i++) {
  //for (int i = 0; i < 500; i++) {
    //flock.addBoid(new Boid(width/2,height/2));
    flock.addBoid(new Boid(random(0,width),random(0,height)));
  }
  smooth();
  
  table = loadTable("ga_demo_sm.csv", "header");

  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows()) {
    
    int page = row.getInt("Page");
    String page_views = row.getString("Page Views");
    String unique_page_views = row.getString("Unique Page Views");
    
    println(page + " (" + unique_page_views + ") has an ID of " + page_views);
  }
}


void draw() {

  background(255); 
  flock.run();
  drawScrollbars();

  if (mousePressed && !scrollbar) {
    flock.addBoid(new Boid(mouseX,mouseY));
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