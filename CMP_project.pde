PImage map_image;
PGraphics pg, Arrow_pg;

boolean LightOn, OnGhost;

LowBettery bettery;
Player player;
Collider collider;
Ghost ghost;
ArrowGame arrowGame;

float light_dis;
float value = 0;

void setup(){
  
  map_image = loadImage("maze.png");
  player = new Player();
  bettery = new LowBettery();
  ghost = new Ghost();
  arrowGame = new ArrowGame();
  LightOn = false;
  OnGhost = false;
  light_dis = 100;
  
  size(1000,800);
  background(255);
  image(map_image, 100, 0, 800, 800);
  collider = new Collider();
  pg = createGraphics(500, 500);
  Arrow_pg = createGraphics(1000, 800);
}

void draw(){
  if(light_dis < 0){
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
      text("Timer", width/2 - textWidth("Timer")/2, 700);
    }
    
    for(int i = arrowGame.arrows.length - 1; i >= 0; i--){
      //I set images position of X like below to make them locate on the center.
      image(arrowGame.arrows[i], width - (arrowGame.arrow_pos * (i + 1)), 100, 30, 30);
    }
    
    //when you don't make it in time
    if(arrowGame.time > 3){
      image(arrowGame.fail, width/2, height/2, 300, 300);
      textSize(50);
      fill(0);
      text("Fail", width/2 - textWidth("Fail")/2, 700);
    }
  
    if(arrowGame.arrows.length == 0){
      player.speed = 5;
      ghost.speed = 0.01;
      OnGhost = false;
      arrowGame = new ArrowGame();
    }
  }
  else{
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
    if(dist(player.pos_x, player.pos_y, ghost.pos_x, ghost.pos_y) < 20){
      ghost = new Ghost();
      OnGhost = true;
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
  if(key == 'l'){
    light_dis = 100;
  }
  if(keyCode == RIGHT){
    if(!collider.walls[int(player.pos_x) + 5 + int(player.pos_y) * width]){
      player.GoRight();
    }
    
  }
  else if(keyCode == LEFT){
    if(!collider.walls[int(player.pos_x) - 5 + int(player.pos_y) * width]){
      player.GoLeft();
    }
    
  }
  else if(keyCode == UP){
    if(!collider.walls[int(player.pos_x) + (int(player.pos_y) - 15) * width]){
      player.GoUp();
    }
    
  }
  else if(keyCode == DOWN){
    if(!collider.walls[int(player.pos_x) + (int(player.pos_y) + 15) * width]){
      player.GoDown();
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
      player.speed = 5;
      ghost.speed = 0.01;
      value = 0;
    }
  }
}

void mousePressed(){
  println(int(mouseX) , int(mouseY));
  println(collider.walls[int(mouseX) + int(mouseY) * width]);
}
