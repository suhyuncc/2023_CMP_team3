import processing.sound.*;

AudioIn input;
Amplitude analyzer;

PImage map_image;
PGraphics pg, Arrow_pg, Wall_pg;
PFont horrorFont;

boolean LightOn, OnGhost, GameStart, OnWall, Pause;

LowBettery bettery;
Player player;
Collider collider;
Ghost ghost;
ArrowGame arrowGame;
WallGame wallGame;
Button playButton, quitButton, restartButton;

float light_dis;
float value = 0;

void setup(){
  
  input = new AudioIn(this, 0);
  input.start();
  analyzer = new Amplitude(this);
  analyzer.input(input);
  
  horrorFont = createFont("Arial", 32);
  map_image = loadImage("maze.png");
  
  player = new Player();
  bettery = new LowBettery();
  ghost = new Ghost();
  arrowGame = new ArrowGame();
  wallGame = new WallGame();
  playButton = new Button(width/2, height/2 + 60, 250, 80, "Play");
  quitButton = new Button(width/2, height/2 + 160, 250, 80, "Quit");
  restartButton = new Button(width/2, height/2 + 300, 250, 80, "ReStart");
  
  LightOn = false;
  OnGhost = false;
  GameStart = false;
  OnWall = false;
  Pause = false;
  light_dis = 100;
  
  size(1000,800);
  background(255);
  image(map_image, 100, 0, 800, 800);
  collider = new Collider();
  pg = createGraphics(500, 500);
  Arrow_pg = createGraphics(1000, 800);
  Wall_pg = createGraphics(500, 500);
}

void draw(){
  if(!GameStart){
    player.speed = 0;
    ghost.speed = 0;
    background(0);
    textAlign(CENTER, CENTER);
    
    fill(255, 0, 0);
    textSize(32);
    text("Escaping The Shadows!!", width/2, 230 + random(-2, 2));
  
    playButton.display();
    quitButton.display();
  
    playButton.hoverEffect();
    quitButton.hoverEffect();
  }
  else if(Pause){
    player.speed = 0;
    ghost.speed = 0;
    background(0);
    textAlign(CENTER, CENTER);
    
    fill(255, 0, 0);
    textSize(32);
    text("Pause!!", width/2, 230 + random(-2, 2));
  
    restartButton.display();
    quitButton.display();
  
    restartButton.hoverEffect();
    quitButton.hoverEffect();
  }
  else if(light_dis < 0){
    player.speed = 0;
    ghost.speed = 0;
    bettery.drawPage();
    image(pg, 500, 400);
    rectMode(CORNERS);
    fill(255,255,255);
    rect(400, 300, 600, 580);
    rectMode(CORNERS);
    fill(0,255,0);
    rect(400, 580 - (2.8 * value), 600, 580);
  }
  else if(OnGhost){
    player.speed = 0;
    ghost.speed = 0;
    arrowGame.drawArrowGame();
    image(Arrow_pg, 500, 400);
    
    if(arrowGame.arrows.length != 0 && arrowGame.time <= 3){
      arrowGame.time += 0.01;
    }
    
    if(arrowGame.time <= 3){
      fill(255, 0, 0);
      rectMode(CENTER);
      rect(width/2, 800, 600 - 200 * arrowGame.time, 100);
      fill(0);
      textSize(50);
      text("Timer", width/2, 700);
    }
    
    for(int i = arrowGame.arrows.length - 1; i >= 0; i--){
      //I set images position of X like below to make them locate on the center.
      image(arrowGame.arrows[i], width - (arrowGame.arrow_pos * (i + 1)), 100, 30, 30);
    }
    
    //when you don't make it in time
    if(arrowGame.time > 3){
      image(arrowGame.fail, width/2, height/2, 300, 300);
      textSize(50);
      fill(255,0,0);
      text("Fail", width/2, 600);
      
      restartButton.display();
      restartButton.hoverEffect();
    }
  
    if(arrowGame.arrows.length == 0){
      OnGhost = false;
      arrowGame = new ArrowGame();
    }
  }
  else if(OnWall){
    player.speed = 0;
    ghost.speed = 0;
    background(0);
    wallGame.drawWallGame();
    image(Wall_pg, 500, 400);
    
    for (ImageElement img : wallGame.images) {
      img.display();
    }
    
    if (wallGame.images.size() == 0) {
      OnWall = false;
      wallGame = new WallGame();
    }
  }
  else{
    player.speed = 5;
    ghost.speed = 0.01;
    background(255);
    imageMode(CORNER);
    image(map_image, 100, 0, 800, 800);
    imageMode(CENTER);
    image(player.p_image, player.pos_x, player.pos_y, 40, 40);
    imageMode(CENTER);
    image(ghost.p_image, ghost.pos_x, ghost.pos_y, 40, 40);
    ghost.follow(player.pos_x,player.pos_y);
    FlashLight();
    light_dis -= 0.016;
    float vol = analyzer.analyze();
    if(dist(player.pos_x, player.pos_y, ghost.pos_x, ghost.pos_y) < 20){
      ghost = new Ghost();
      OnGhost = true;
    }
    else if(dist(player.pos_x, player.pos_y, ghost.pos_x, ghost.pos_y) < light_dis &&
    vol * 100 > 3){
      ghost = new Ghost();
    }
  }
  
}

void FlashLight(){
  loadPixels();
  for (int y = 0; y < height; y++ ) {
    for (int x = 0; x < width; x++ ) {
      int loc = x + y * width;
      
      float r = red(pixels[loc]);
      float g = green(pixels[loc]);
      float b = blue(pixels[loc]);

      float distance = dist(x, y, mouseX, mouseY);
     
      float adjustBrightness = map(distance, 0, light_dis, 1, 0);
      r *= adjustBrightness;
      g *= adjustBrightness;
      b *= adjustBrightness;
      
      r = constrain(r, 0, 255); 
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);
      
      b = b * 108 / 255;
      // Set the display pixel to the image pixel
      pixels[loc] = color(r,g,b);
    }
  }
  updatePixels();
}

void keyPressed(){
  if(key == 'p'){
    if(!Pause){
      quitButton = new Button(width/2, height/2 + 160, 250, 80, "Quit");
      restartButton = new Button(width/2, height/2 + 60, 250, 80, "ReStart");
      Pause = true;
    }
    else{
      Pause = false;
    }
  }
  if(keyCode == RIGHT){
    if(!collider.walls[int(player.pos_x) + 5 + int(player.pos_y) * width]){
      player.GoRight();
    }
    else{
      OnWall = true;
    }
    
  }
  else if(keyCode == LEFT){
    if(!collider.walls[int(player.pos_x) - 5 + int(player.pos_y) * width]){
      player.GoLeft();
    }
    else{
      OnWall = true;
    }
    
  }
  else if(keyCode == UP){
    if(!collider.walls[int(player.pos_x) + (int(player.pos_y) - 15) * width]){
      player.GoUp();
    }
    else{
      OnWall = true;
    }
    
  }
  else if(keyCode == DOWN){
    if(!collider.walls[int(player.pos_x) + (int(player.pos_y) + 15) * width]){
      player.GoDown();
    }
    else{
      OnWall = true;
    }
    
  }
  
  //if the time reaches the limit, pressing key doesn't work
  if(OnGhost){
    if(arrowGame.arrows.length != 0){//to avoid Nullpoint Exception
      if(keyCode == UP){
        if(arrowGame.arrows[arrowGame.curIdx] == arrowGame.up){
          arrowGame.arrows = (PImage[]) shorten(arrowGame.arrows);
          arrowGame.curIdx--;
        }
        else{
          println("fail");
        }
      }
        
      if(keyCode == DOWN){
        if(arrowGame.arrows[arrowGame.curIdx] == arrowGame.down){
        arrowGame.arrows = (PImage[]) shorten(arrowGame.arrows);
        arrowGame.curIdx--;
        }
        else{
          println("fail");
        }
      }
        
        
      if(keyCode == LEFT){
        if(arrowGame.arrows[arrowGame.curIdx] == arrowGame.left){
          arrowGame.arrows = (PImage[]) shorten(arrowGame.arrows);
          arrowGame.curIdx--;
        }
        else{
          println("fail");
        }
      }
    
        
      if(keyCode == RIGHT){
        if(arrowGame.arrows[arrowGame.curIdx] == arrowGame.right){
          arrowGame.arrows = (PImage[]) shorten(arrowGame.arrows);
          arrowGame.curIdx--;
        }
        else{
          println("fail");
        }
      }
    }
  }
}

void mouseMoved() {
  if(light_dis < 0){
    value = value + 0.1;
    if (value > 100) {
      light_dis = 100;
      value = 0;
    }
  }
}

void mousePressed(){
  
  if (mouseButton == LEFT) {
    if(!GameStart){
      if (playButton.isMouseOver()) {
        player = new Player();
        ghost = new Ghost();
        GameStart = true;
      }
      else if (quitButton.isMouseOver()) {
        exit();
      }
    }
    else if(OnWall){
      int indexToRemove = -1;
      for (int i = wallGame.images.size() - 1; i >= 0; i--) {
        ImageElement img = wallGame.images.get(i);
        if (img.contains(mouseX, mouseY)) {
          indexToRemove = i;
          break;
        }
      }
      if (indexToRemove >= 0) {
        wallGame.images.remove(indexToRemove);
      }
    }
    else if(OnGhost){
      if (restartButton.isMouseOver()) {
        GameStart = false;
        OnGhost = false;
        arrowGame = new ArrowGame();
      }
    }
    else if(Pause){
      if (restartButton.isMouseOver()) {
        GameStart = false;
        Pause = false;
      }
      else if (quitButton.isMouseOver()) {
        exit();
      }
    }
  }
  
}
