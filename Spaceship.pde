class Spaceship extends Mover {
  ArrayList<Bullet> bullets;
  PImage ship;
  int shield, size;
  float mass;
  color c;
  int speed;
  AudioPlayer blt_sound;
  
  // Construir uma nave
  Spaceship(PVector loc, PVector vel, float mass, AudioPlayer blt) {
    super(loc, vel, mass , color(0), 0);
    bullets = new ArrayList<Bullet>();
    ship = loadImage("Images//spaceship2.png");
    shield = 500;
    size = 64;
    speed = 20;
    blt_sound = blt;
  }
  
  // Controlo de ações da Nave
  void update(float dt, Fluid fluid) {
    if (keyPressed) {
      if (key == ' ') { 
        shoot();
        blt_sound.play();
      }
      if (key == 'a') {
        if(loc.x - speed > size/2 & loc.x - speed < width - size/2) {
          loc.x -= speed;
        }
      }
      if (key == 'd') {
        if(loc.x + speed > size/2 & loc.x + speed < width - size/2) {
          loc.x += speed;
        }
      }
    }
    
    for (int i=bullets.size()-1;i>=0;i--) {
      Bullet b = bullets.get(i);
      if (b.isOut()) bullets.remove(i);
      else b.run(dt, fluid);
    }
  }
  
  // Disparar balas
  void shoot() {
    Bullet b = new Bullet(loc, vel, 1., color(0), "player");
    b.applyForce(vel.normalize().mult(100));
    bullets.add(b);
    blt_sound.rewind();
  }
  
  // Atualizar a informação da nave
  void display() {
    fill(0);
    ship.resize(size,size);
    imageMode(CENTER);
    image(ship, loc.x, loc.y);
  }
}