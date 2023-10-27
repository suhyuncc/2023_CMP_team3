class Player{
  PImage p_image;
  float pos_x;
  float pos_y;
  float speed;
  
  Player(){
    p_image = loadImage("캐릭터_정면_1.png");
    pos_x = 160;
    pos_y = 740;
    speed = 5;
  }
  
  void GoRight(){
    pos_x += speed;
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
