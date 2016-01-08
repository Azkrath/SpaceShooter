class Fluid {
  PVector loc;
  PVector dim;
  float viscosity;
  int delay;
  int lastTime;
  float offset;
  
  Fluid(PVector loc, PVector dim, float viscosity) {
    this.loc = loc.copy();
    this.dim = dim.copy();
    this.viscosity = viscosity;
    delay = 10000;
    this.loc.x = random(0, width);
    this.loc.y = random(100,height - 100);
    lastTime = 0;
    offset = 1;
  }
  
  PVector dragForce(Mover m) {
    PVector f = m.vel.copy();
    float speed = f.mag();
    return f.normalize().mult(-speed*speed*viscosity);
  }
  
  boolean isInside(Mover m) {
    if (m.loc.x > loc.x && m.loc.x < (loc.x + dim.x) && m.loc.y > loc.y && m.loc.y < (loc.y + dim.y)) return true;
    return false;
  }
  
  void move() {
    int curTime = millis();
    if(curTime - lastTime > delay) {
      loc.x = random(0, width);
      loc.y = random(0,height);
      offset = random(1, 5);
      lastTime = millis();
    } else {
      loc.x += offset;
      if(loc.x > width | loc.x < 0) {
        offset = offset * -1;
      }
    }
  }
  
  void display() {
    fill(30,180,180,40);
    rect(loc.x, loc.y, dim.x, dim.y);
  }
  
}