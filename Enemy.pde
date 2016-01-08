class Enemy extends Mover {
  
  ArrayList<Bullet> bullets;
  PImage ship;
  int shield, size, speed;
  float mass;
  color c;
  AudioPlayer blt_sound;

  Enemy(PVector loc, PVector vel, float mass, AudioPlayer en_blt) {
    super(loc, vel, mass , color(0), 0);
    bullets = new ArrayList<Bullet>();
    ship = loadImage("Images//enemy1.png");
    shield = 60;
    size = 64;
    speed = 4;
    blt_sound = en_blt;
  }

  void update(float dt, Fluid fluid) {
    
      if(random(0,100) < 2) {
        speed = (int)random(-4, 4);
      }
    
      if(loc.x < 0 | loc.x > width) {
          speed *= -1;
      }
    
      if(random(0, 100) < 2) {
        shoot();
        blt_sound.play();
      }
      loc.x += speed;
      
      for (int i=bullets.size()-1;i>=0;i--) {
        Bullet b = bullets.get(i);
        if (b.isOut()) bullets.remove(i);
        else b.run(dt, fluid);
      }
  }
  
  void shoot() {
    Bullet b = new Bullet(loc, vel, 1., color(0), "enemy");
    b.applyForce(vel.normalize().mult(100));
    bullets.add(b);
    blt_sound.rewind();
  }
  
  void display() {
    fill(0);
    ship.resize(size,size);
    imageMode(CENTER);
    image(ship, loc.x, loc.y);
  }


}