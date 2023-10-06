PImage map_image;

boolean LightOn;


Player player;

void setup(){
  map_image = loadImage("maze.png");
  player = new Player();
  LightOn = false;
  size(1000,800);
  background(255);
}

void draw(){
  background(255);
  image(map_image,100,0,800,800);
  image(player.p_image,player.pos_x,player.pos_y,50,50);
  FlashLight();
}

void FlashLight(){
  loadPixels();
  for (int y = 0; y < height; y++ ) {
    for (int x = 0; x < width; x++ ) {
      int loc = x + y*width;
      float r = red(pixels[loc]);
      float g = green(pixels[loc]);
      float b = blue(pixels[loc]);
      
      /*
      if(LightOn){
        r = 250;
        g = 244;
        b = 192;
      }else{
        r = 255;
        g = 255;
        b = 255;
      }*/
      
      // Calculate an amount to change brightness
      // based on proximity to the mouse
      float distance = dist(x, y, mouseX, mouseY);

      // The closer the pixel is to the mouse, the lower the distance 
      // We want closer pixels to be brighter, so we invert the value u      
      // using map(). Pixels with a distance >= 50 are completely dark.
      // Pixels with a distance of 0 have a brightness of 1.0.
      float adjustBrightness = map(distance, 20, 100, 1, 0);
      r *= adjustBrightness;
      g *= adjustBrightness;
      b *= adjustBrightness;
      
   // The RGB values are constrained between 0 and 255.
      r = constrain(r, 0, 255); 
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);
      
      // Set the display pixel to the image pixel
      pixels[loc] = color(r,g,b);
    }
  }
  updatePixels();
}

void keyPressed(){
  if(key == 'l'){
    LightOn = !LightOn;
  }
  if(keyCode == RIGHT){
    player.GoRight();
    println("hi");
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
