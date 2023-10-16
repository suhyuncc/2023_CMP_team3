class Player{
  PImage p_image;
  float pos_x;
  float pos_y;
  float speed;
  
  Player(){
    p_image = loadImage("캐릭터_정면_1.png");
    pos_x = 140;
    pos_y = 720;
    speed = 5;
  }
  
  void GoRight(){
    float newX = pos_x;
    newX += 5;
    //float pos_s = pos_x;
    //pos_x = lerp(pos_s,pos_s+150,0.1);
    pos_x = newX;
  }
  
  void GoLeft(){
    pos_x -= speed;
  }
  
  void GoUp(){
    pos_y -= speed;
  }
  
  void GoDown(){
    pos_y += speed;
  }
}
