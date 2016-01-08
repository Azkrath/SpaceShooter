class Star {
  PVector loc;
  int size;
  float weight;
  float mass;
  final float G = 1.;
  PImage sun;
  
  Star(PVector loc) {
    this.loc = loc.copy();
    sun = loadImage("Images//sun3.png");
    size = 32;
    weight = 15000.;
    mass = weight * size;
  }
  
  PVector attractionForce(Mover m) {
    PVector r = PVector.sub(loc, m.loc);
    float d = r.mag();
    float strength = G * ((mass * m.mass) / pow(d,2));
    return PVector.mult(r.normalize(),strength);
  }
  
  void grow() {
      size += 1;
      mass = weight * size;
  }
  
  void display() {
    fill(255,255,0);
    noStroke();
    imageMode(CENTER);
    image(sun, loc.x, loc.y, size*2, size*2);
  }
}