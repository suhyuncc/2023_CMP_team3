class LowBettery {
  
  void drawPage(){
 
    // do all drawing with "pg"
    pg.beginDraw();
    pg.background(150,150,150);
    pg.textSize(60);
    pg.textAlign(CENTER);
    pg.text("Shake!!",250,100);
    pg.endDraw();
  }
}
