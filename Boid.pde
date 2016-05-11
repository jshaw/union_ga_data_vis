//
// UNION Creative / http://unioncreative.com 
// Data Viz Project; data supplied through GA traffic, browsing behaviour + events
// By: Jordan Shaw
// 
// =========================
// 
// Inspired by...
// The Nature of Code + Flocking
// Daniel Shiffman <http://www.shiffman.net>
// http://natureofcode.com
// 

float swt = 25.0;     //sep.mult(25.0f);
float awt = 4.0;      //ali.mult(4.0f);
float cwt = 5.0;      //coh.mult(5.0f);
float maxspeed = 1;
float maxforce = 0.025;

class Boid {

  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float max_page_view;
  float page_view;
  float unique_page_view;

  // canvas x, y, max page view, page view, unique page view
  Boid(float x, float y, float mpv, float pv, float upv) {
    acc = new PVector(0,0);
    vel = new PVector(random(-1,1),random(-1,1));
    loc = new PVector(x,y);
    r = 2.0;
    page_view = pv;
    unique_page_view = upv;
    max_page_view = mpv;
    
    println(page_view);
    println(unique_page_view);
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acc.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(swt);
    ali.mult(awt);
    coh.mult(cwt);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update location
  void update() {
    // Update velocity
    vel.add(acc);
    // Limit 
    vel.limit(maxspeed);
    loc.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,loc);  // A vector pointing from the location to the target

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,vel);
    steer.limit(maxforce);  // Limit to maximum steering force

    return steer;
  }
  
  void render() {
    
    // Draw a triangle rotated in the direction of velocity
    float theta = vel.heading2D() + radians(90);
    //colorMode(HSB, 100);
    
    // Playing around with HSB colour mode
    // =====================
    //fill(map(loc.x, 0, width, 0, 255), map(loc.y, 0, height, 0, 255), 175);
    //stroke(map(loc.x, 0, width, 0, 255), map(loc.y, 0, height, 0, 255), 175);
    
    //fill(map(loc.x, 0, width, 0, 255), map(loc.y, 0, height, 0, 255), 175);
    //stroke(map(loc.x, 0, width, 0, 255), map(loc.y, 0, height, 0, 255), 175);
    
    println("=============");
    println(unique_page_view / page_view);
    println(map((unique_page_view / page_view), 0, 1, 0, 100));
    println("=============");
    
    
    // Testing
    // =======
    //fill(map((unique_page_view / page_view), 0, 1, 0, 100), map(loc.x, 0, width, 0, 100), map(loc.y, 0, height, 0, 100));
    //fill(map((unique_page_view / page_view), 0, 1, 0, 100), 100, 100);
   
    //fill(map(loc.x, 0, width, 0, 255), map(loc.y, 0, height, 0, 255), map((unique_page_view / page_view), 0, 1, 1, 100));
    
    //fill(map(loc.x, 0, width, 0, 255), map(loc.y, 0, height, 0, 255), 175);
    //stroke(map(loc.x, 0, width, 0, 255), map(loc.y, 0, height, 0, 255), 175);
    
    //stroke(map((unique_page_view / page_view), 0, 1, 0, 100), 100, 100);
    //stroke(map(loc.x, 0, width, 0, 255), map(loc.y, 0, height, 0, 255), map((unique_page_view / page_view), 0, 1, 1, 100));
    // =======
    
    fill(map(loc.x, 0, width, 0, 255), map(loc.y, 0, height, 0, 255), 175, map((unique_page_view / page_view), 0, 1, 1, 255));
    stroke(map(loc.x, 0, width, 0, 255), map(loc.y, 0, height, 0, 255), 175, map((unique_page_view / page_view), 0, 1, 1, 255));
    
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(theta);
    beginShape(TRIANGLES);
    
    // defaults
    // =======
    //vertex(0, -r*2);
    //vertex(-r, r*2);
    //vertex(r, r*2);
    
    vertex(0*map((page_view), 0, (int)max_page_view, 3, 10), -r*map((page_view), 0, (int)max_page_view, 3, 10));
    vertex(-r, r*map((page_view), 0, (int)max_page_view, 3, 10));
    vertex(r*map((page_view), 0, (int)max_page_view, 3, 10), r*map((page_view), 0, (int)max_page_view, 3, 10));
    
    // Playing around with HSB colour mode
    // =====================
    //vertex(0 * map(page_view, 1, 971, 4, 10), -r * map(page_view, 1, 971, 4, 10));
    //vertex(-r, r * map(page_view, 1, 971, 4, 10));
    //vertex(r * map(page_view, 1, 971, 4, 10), r * map(page_view, 1, 971, 4, 10));
    
    //colorMode(RGB, 100);
    
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (loc.x < -r) loc.x = width+r;
    if (loc.y < -r) loc.y = height+r;
    if (loc.x > width+r) loc.x = -r;
    if (loc.y > height+r) loc.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0;
    PVector steer = new PVector(0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(loc,other.loc);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(loc,other.loc);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50.0;
    PVector steer = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(loc,other.loc);
      if ((d > 0) && (d < neighbordist)) {
        steer.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50.0;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(loc,other.loc);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.loc); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return seek(sum);  // Steer towards the location
    }
    return sum;
  }
}