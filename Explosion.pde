class Explosion {

  int WDIM, HDIM, W, H;
  PImage explosion = loadImage("Images//explosion1.png");;
  float x, y;
  PImage explosions[];
  int curIdx;
  AudioPlayer expl_snd;
  
  Explosion(float x, float y, AudioPlayer expl_snd) {
    WDIM = 4;
    HDIM = 4;
    W = explosion.width/WDIM;
    H = explosion.height/HDIM;
    explosions = new PImage[WDIM*HDIM];
    this.expl_snd = expl_snd;
    expl_snd.rewind();
    for(int i = 0; i < explosions.length; i++) {
        int ximg = i%WDIM*W;
        int yimg = i/HDIM*H;
        explosions[i] = explosion.get(ximg, yimg, W, H);
    }
    curIdx = 0;
    this.x = x;
    this.y = y;
  }
    
  void explode() {
    if(curIdx < explosions.length) {
        image(explosions[curIdx++], x, y);
        expl_snd.play();
    }
  }
  
}