import processing.opengl.*;
import ddf.minim.*;

World world;
Minim minim;
AudioPlayer song, blt,en_blt, expl_snd, ship_expl;
PImage space;
PFont font;
color c;
boolean paused;

void restart() {
  paused = false;
  blt = minim.loadFile("Audio//bullets.wav");
  en_blt = minim.loadFile("Audio//en_bullets.wav");
  song = minim.loadFile("Audio//music.mp3"); 
  expl_snd = minim.loadFile("Audio//explosion.wav");
  ship_expl = minim.loadFile("Audio//ship_expl.wav"); //<>//
  song.play();
  world = new World((int)random(4,12), song, blt, en_blt, expl_snd, ship_expl); //<>//
  loop();
}

void setup() {
  size(1366,768, P2D);
  smooth(4);
  space = loadImage("Images//space.png");
  frameRate(60);
  font = createFont("Arial", 16, true);
  c = color(255,0,0);
  minim = new Minim(this);
  paused = false;
  blt = minim.loadFile("Audio//bullets.wav");
  en_blt = minim.loadFile("Audio//en_bullets.wav");
  song = minim.loadFile("Audio//music.mp3");
  expl_snd = minim.loadFile("Audio//explosion.wav");
  ship_expl = minim.loadFile("Audio//ship_expl.wav");
  song.play();
  world = new World((int)random(4,12), song, blt, en_blt, expl_snd, ship_expl);
}

void draw() {
  background(space);
  textFont(font,32);
  fill(c);
  text("PLANETS :", 20, 50);
  text("SHIELD :", 400, 50);
  text("MULTI :", 750, 50);
  text("POINTS :", 1100, 50);
  world.run();
}

void keyPressed() {
  if(key == 'r') {
    restart();
  }
  if(key == 'p' & !paused) {
    noLoop();
    song.pause();
    paused = true;
    text("PAUSED", 620, 600);
  } else if(key == 'p' & paused) {
    song.play();
    paused = false;
    loop();
  }
}
