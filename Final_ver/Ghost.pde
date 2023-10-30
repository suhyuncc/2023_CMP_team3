class Ghost{
  PImage p_image;

  float start_x[] = {500, 500, 10, 990};
  float start_y[] = {10, 790, 400, 400};
  float pos_x;
  float pos_y;
  float speed;
  
  Ghost(){
    int ran = int(random(4));
    p_image = loadImage("ghost.png");
    
    // random spawn points
    pos_x = start_x[ran];
    pos_y = start_y[ran];
    
    speed = 0.01;
  }
  
  // following player
  void follow(float p_x, float p_y){
    float dx = p_x - pos_x;
    float dy = p_y - pos_y;
    pos_x += dx * speed;
    pos_y += dy * speed;
    
  }
}
