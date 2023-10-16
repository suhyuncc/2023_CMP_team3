PImage map_image;
PGraphics pg;

boolean LightOn;

LowBettery bettery;
Player player;

float light_dis;
float value = 0;

void setup(){
  
  map_image = loadImage("maze.png");
  player = new Player();
  bettery = new LowBettery();
  LightOn = false;
  light_dis = 100;
  
  size(1000,800);
  background(255);
  pg = createGraphics(500, 500); 
}

void draw(){
  if(light_dis < 0){
    player.speed = 0;
    bettery.drawPage();
    image(pg, 250, 150);
    rectMode(CORNERS);
    fill(255,255,255);
    rect(400, 300, 600, 580);
    rectMode(CORNERS);
    fill(0,255,0);
    rect(400, 580 - (2.8 * value), 600, 580);
  }else{
    background(255);
    image(map_image, 100, 0, 800, 800);
    image(player.p_image, player.pos_x, player.pos_y, 50, 50);
    FlashLight();
    light_dis -= 0.1;
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
    player.GoRight();
  }
  else if(keyCode == LEFT){
    player.GoLeft();
  }
  else if(keyCode == UP){
    player.GoUp();
  }
  else if(keyCode == DOWN){
    player.GoDown();
  }
}

void mouseMoved() {
  if(light_dis < 0){
    value = value + 0.1;
    if (value > 100) {
      light_dis = 100;
      player.speed = 10;
      value = 0;
    }
  }
}
