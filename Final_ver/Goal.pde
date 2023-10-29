class Goal{
  float pos_x;
  float pos_y;
  
  Goal(float x, float y){
    pos_x = x;
    pos_y = y;
  }
  
  void display(){
    fill(255,0,0);
    rect(pos_x, pos_y, 40, 40);
  }
}
