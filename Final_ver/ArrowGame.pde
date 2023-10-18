class ArrowGame{
  PImage up, down, left, right;
  PImage clear, fail;

  PImage[] arrows;

  int curIdx;
  int count;

  //ranNum for set arrays length randomly
  int ranNum = 0;

  //time value is for time limits in minigame
  float time = 0;

  float arrow_pos;
  
  ArrowGame(){
    ranNum = (int)random(8, 13);//random number from 8 to 12(number of image)
    //load images
    up = loadImage("up.png");
    down = loadImage("down.png");
    left = loadImage("left.png");
    right = loadImage("right.png");
    clear = loadImage("clear.png");
    fail = loadImage("fail.png");
    
    //make array of arrow images and each index has random arrow
    arrows = new PImage[ranNum];
    for(int i = 0; i < arrows.length; i++){
      int x = (int)random(1, 5);
      if(x == 1 || x == 5){arrows[i] = up;}
      if(x == 2){arrows[i] = down;}
      if(x == 3){arrows[i] = left;}
      if(x == 4){arrows[i] = right;}
    }
    
    //setting curIdx as last index of array because I draw images in array from
    //last to first
    curIdx = arrows.length - 1;
  
    arrow_pos = width / (arrows.length + 1);
    count = 0;
  }
  
  void drawArrowGame(){
    Arrow_pg.beginDraw();
    Arrow_pg.background(70);
    Arrow_pg.endDraw();
  }
}
