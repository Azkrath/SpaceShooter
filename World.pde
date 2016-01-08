import java.util.Iterator;
import ddf.minim.*;

class World {
  Spaceship spaceship;
  Enemy enemy;
  Star sun;
  Fluid fluid;
  ArrayList<Mover> planets;
  ArrayList<Explosion> explosions;
  ArrayList<Enemy> enemies;
  int nPlanets, planetsAdded;
  int lastTime;
  float speed;
  Explosion sunExplosions;
  int score, multiplier, enCounter;
  AudioPlayer song, blt, en_blt, expl_snd, ship_expl;
  
  World(int nPlanets, AudioPlayer song,AudioPlayer blt, AudioPlayer en_blt, AudioPlayer expl_snd, AudioPlayer ship_expl) {
    spaceship = new Spaceship(new PVector(width/2,height-70), new PVector(0,-1), 50., blt);
    sun = new Star(new PVector(width/2, height/2));
    fluid = new Fluid(new PVector(100,100), new PVector(400,50), .04);
    planets = new ArrayList<Mover>();
    explosions = new ArrayList<Explosion>();
    enemies = new ArrayList<Enemy>();
    planetsAdded = 0;
    lastTime = millis();
    speed = 5;
    score = 0;
    multiplier = 1;
    enCounter = 0;
    this.song = song;
    this.blt = blt;
    this.en_blt = en_blt;
    this.expl_snd = expl_snd;
    this.ship_expl = ship_expl;
    this.nPlanets = nPlanets;
    for (int i=0;i<nPlanets;i++) {
      PVector loc = new PVector(random(0,width/2),random(0,height/4));
      PVector vel = new PVector(random(20,50),0);
      float mass = random(50,200);
      if(planetsAdded == 8) {
        planetsAdded = 0;
      }
      Mover planet = new Mover(loc, vel, mass, color(random(255),random(255),random(255)), ++planetsAdded);
      planets.add(planet);
    }
  }
  
  void run() {
    float dt = millis() - lastTime;
    lastTime = millis();
            
    fluid.move();        
    fluid.display();   
    
   if(random(0,1000) < 8) {
     enemies.add(new Enemy(new PVector(random(0,width),70), new PVector(0,1), 50., en_blt));
   }
    
    for (Mover m : planets) {
      PVector f = sun.attractionForce(m);
      m.applyForce(f);
      if (fluid.isInside(m)) {
        f = fluid.dragForce(m);
        m.applyForce(f);
      }
      m.move(speed * dt/1000.);
      m.display();
    }
    
    Iterator<Mover> pIt = planets.iterator();
    while(pIt.hasNext()) {
      Mover p = pIt.next();
      Iterator<Bullet> bIt = spaceship.bullets.iterator();
      while (bIt.hasNext()) {
        Bullet b = bIt.next();
        if (b.hit(p)) {
          p.lifespan -= 1;
          if(p instanceof ParticleSystem & p.lifespan == 0){
              pIt.remove();
              break;
          } else if(p instanceof Mover & p.lifespan == 0) {
              planets.set(planets.indexOf(p), new ParticleSystem(p.loc, p.vel, p.mass, p.c));
          } 
          explosions.add(new Explosion(b.loc.x, b.loc.y, expl_snd));
          bIt.remove();
        }
      }
      if(p.hit(sun)) {
        p.lifespan -= 10;
        if(p instanceof ParticleSystem & p.lifespan == 0){
          pIt.remove();
          break;
        } else if(p instanceof Mover & p.lifespan == 0) {
          planets.set(planets.indexOf(p), new ParticleSystem(p.loc, p.vel, p.mass, p.c));
        } 
        explosions.add(new Explosion(p.loc.x, p.loc.y, expl_snd));
      }
      for(Mover plnts : planets) {
        if(p.hit(plnts) & !p.equals(plnts)) {
          p.lifespan -= 2;
          if(p instanceof ParticleSystem & p.lifespan == 0){
            pIt.remove();
            break;
          } else if(p instanceof Mover & p.lifespan == 0) {
              planets.set(planets.indexOf(p), new ParticleSystem(p.loc, p.vel, p.mass, p.c));
          } 
          explosions.add(new Explosion(p.loc.x, p.loc.y, expl_snd));
         }
      }
      if(p.hit(spaceship)) {
        spaceship.shield -= 20; 
        explosions.add(new Explosion(spaceship.loc.x, spaceship.loc.y, expl_snd));
        multiplier = 1;
      }
      for(Enemy en : enemies) {
        if(p.hit(en)) {
          en.shield -= 20; 
          explosions.add(new Explosion(en.loc.x, en.loc.y, expl_snd));
        }
      }
    }
    
    Iterator<Bullet> itS1 = spaceship.bullets.iterator();
    boolean toRemove = false;
    while (itS1.hasNext()) {
      Bullet b = itS1.next();
      if (b.hit(sun)) {
        sunExplosions = new Explosion(b.loc.x, b.loc.y, expl_snd);
        sun.grow();
        toRemove = true;
      } else {
        for(Enemy en : enemies) {
          if(b.type.equals("player") & b.hit(en)) {
            en.shield -= 20; 
            explosions.add(new Explosion(en.loc.x, en.loc.y, expl_snd));
            score += (10 * multiplier);
            enCounter += 1;
            if(enCounter == 10) {
              multiplier += 1;
              enCounter = 0;
              toRemove = true;
            }
          }
        }
      }
      if(toRemove) {
        itS1.remove();
      }
    } 
    
    if(spaceship.hit(sun)) {
      spaceship.shield -= 50; 
      explosions.add(new Explosion(spaceship.loc.x, spaceship.loc.y, expl_snd));
      sun.grow();
      multiplier = 1;
    }
    
    for(Enemy en : enemies) {     
      Iterator<Bullet> itE = en.bullets.iterator();
      while (itE.hasNext()) {
        Bullet b = itE.next();
        if (b.hit(sun)) {
          sunExplosions = new Explosion(b.loc.x, b.loc.y, expl_snd);
          sun.grow();
          itE.remove();
        }
        else if(b.type.equals("enemy") & b.hit(spaceship)) {
          spaceship.shield -= 20; 
          explosions.add(new Explosion(spaceship.loc.x, spaceship.loc.y, expl_snd));
          itE.remove();
          multiplier = 1;
        }
      } 
      
      if(en.hit(sun)) {
        en.shield -= 50; 
        explosions.add(new Explosion(en.loc.x, en.loc.y, expl_snd));
        sun.grow();
      }
      
      en.update(speed * dt/1000., fluid);
      en.display();
    }
      
    spaceship.update(speed * dt/1000., fluid);
    spaceship.display();
    
    if(sunExplosions != null) {
      sunExplosions.explode();
    }
    sun.display();
    
    Iterator<Explosion> expIt = explosions.iterator();
    while(expIt.hasNext()) {
        Explosion e = expIt.next();
        if(e != null) {
          if(e.curIdx < e.WDIM*e.HDIM - 1) {
            e.explode();
          } else {
            expIt.remove();
          }
        }
    }
    
    Iterator<Enemy> enemyIt = enemies.iterator();
    while(enemyIt.hasNext()) {
      Enemy enemy = enemyIt.next();
      if(enemy.shield <= 0) {
        enemyIt.remove();
      }
    }
    
    text(planets.size(), 200, 50);
    text(spaceship.shield, 550, 50);
    text("x"+multiplier,880, 50);
    text(score,1300, 50);
    
    if(spaceship.shield <= 0) {
      fill(color(255,0,0));
      ship_expl.play();
      song.close();
      noLoop();
      text("GAME OVER", 580, 250);
      text("PRESS    TO RESTART", 520, 550);
      fill(color(255,255,0));
      text("R", 635, 550);
    }
  }
}