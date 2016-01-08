class Bullet extends Mover {
  PImage bullet;
  String type;
  
  Bullet(PVector loc, PVector vel, float mass, color c, String type) {
    super(loc, vel, mass, c, 0);
    this.type = type;
    if(type.equals("player")) {
      bullet = loadImage("Images//bullet1.png");
    } else {
      bullet = loadImage("Images//bullet2.png");
    }
  }
  
  void run(float dt, Fluid fluid) {
    if (fluid.isInside(this)) {
      PVector f = fluid.dragForce(this);
      applyForce(f);
    }
    move(dt);
    display();
  }
  
  boolean isOut() {
    if (loc.x < 0 || loc.x > width || loc.y < 0 || loc.y > height) return true;
    return false;
  }
  
  void display() {
    fill(0); 
    if(type.equals("player")) {
      bullet.resize(24,24);
      image(bullet, loc.x-12, loc.y);
      image(bullet, loc.x+12, loc.y);
    } else {
      bullet.resize(10,38);
      image(bullet, loc.x-12, loc.y);
      image(bullet, loc.x+12, loc.y);
    }
  }
}