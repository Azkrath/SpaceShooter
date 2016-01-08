class Mover {
  PVector loc, vel, acc;
  color c;
  float mass;
  float lifespan;
  PImage celBody;
  
  Mover(PVector loc, PVector vel, float mass, color c, int n) {
    this.loc = loc.copy();
    this.vel = vel.copy();
    this.mass = mass;
    this.c = c;
    acc = new PVector();
    lifespan = 120.;
    if (n > 0) {
      celBody = loadImage("Images//planet" + n + ".png");
    }
  }
  
  void applyForce(PVector f) {
    acc.add(PVector.div(f,mass));
  }
  
  boolean hit(Mover m) {
    float d = PVector.dist(loc, m.loc);
    if (d < pow(m.mass,2/3.)) return true;
    return false;
  }
  
  boolean hit(Star s) {
    float d = PVector.dist(loc, s.loc);
    if (d < s.size) return true;
    return false;
  }
  
  boolean hit(Spaceship ss) {
    float d = PVector.dist(loc, ss.loc);
    if (d < ss.size) return true;
    return false;
  }
  
  void move(float dt) {
    vel.add(PVector.mult(acc,dt));
    PVector vdt = PVector.mult(vel,dt);
    loc.add(vdt);
    acc.mult(0);
  }
  
  void display() {
    fill(c);
    float r = pow(mass,2/3.);
    if(celBody != null) {
      image(celBody, loc.x, loc.y, r, r);
    } else {
      ellipse(loc.x, loc.y, r, r);
    }
  }
}