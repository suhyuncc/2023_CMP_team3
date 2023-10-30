class Player{
  PImage p_image;
  float start_x[] = {160, 400, 600, 800};
  float start_y[] = {740, 380, 180, 60};
  float pos_x;
  float pos_y;
  float speed;
  
  Player(){
    int ran = int(random(4));
    p_image = loadImage("캐릭터_정면_1.png");
    pos_x = start_x[ran];
    pos_y = start_y[ran];
    speed = 5;
  }
  
  //move player right
  void GoRight(){
    pos_x += speed;
  }
  
  //move player left
  void GoLeft(){
    pos_x -= speed;
  }
  
  //move player up
  void GoUp(){
    pos_y -= speed;
  }
  
  //move player down
  void GoDown(){
    pos_y += speed;
  }
}
