class Player{
  PImage p_image;
  float pos_x;
  float pos_y;
  
  Player(){
    p_image = loadImage("캐릭터_정면_1.png");
    pos_x = 140;
    pos_y = 720;
  }
  
  void GoRight(){
    //float pos_s = pos_x;
    //pos_x = lerp(pos_s,pos_s+10,0.5);
    pos_x += 10;
  }
  
  void GoLeft(){
    pos_x -= 10;
  }
  
  void GoUp(){
    pos_y -= 10;
  }
  
  void GoDown(){
    pos_y += 10;
  }
}
