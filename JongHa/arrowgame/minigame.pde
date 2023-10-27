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

void setup(){
  size(1000, 800);
  background(255);
  rectMode(CENTER);
  imageMode(CENTER);
  ranNum = (int)random(10, 15);//random number from 10 to 14(number of image)
  
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
    if(x == 4){arrows[i] = down;}
  }
  
  //setting curIdx as last index of array because I draw images in array from
  //last to first
  curIdx = arrows.length - 1;
  
  arrow_pos = width / (arrows.length + 1);
  count = 0;
}

void draw(){
  background(70);
  //if you complete minigame, the timer is stop
  //time limit is 3 seconds
  if(arrows.length != 0 && time <= 3){
    time += 0.01;
  }
  
  //timer
  if(time <= 3){
  fill(255, 0, 0);
  rect(width/2, 800, 600 - 200*time, 100);
  fill(0);
  textSize(50);
  text("Timer", width/2 - textWidth("Timer")/2, 700);
  }
  
  //shows image from last index of array, because the array is kind of stack.
  //When you pressed the correct arrow, the function 'shorten' will be applied
  //and if(function shorten) pops out last index of array.
  //To make player to press arrow from left side to right side, I showed image
  //from last index to first index
  for(int i = arrows.length - 1; i >= 0; i--){
    //I set images position of X like below to make them locate on the center.
    image(arrows[i], width - (arrow_pos * (i + 1)), 100, 30, 30);
  }
  
  //when you don't make it in time
  if(time > 3){
    //println("task fail");
    image(fail, width/2, height/2, 300, 300);
    textSize(50);
    fill(0);
    text("Fail", width/2 - textWidth("Fail")/2, 700);
  }
  
  //when you clear the minigame
  if(arrows.length == 0){
    image(clear, width/2, height/2, 300, 300);
  }
}

void keyPressed(){
  //if the time reaches the limit, pressing key doesn't work
  if(time <= 3){
    if(arrows.length != 0){//to avoid Nullpoint Exception
      if(keyCode == UP){
        println("pressed up");
        if(arrows[curIdx] == up){
          arrows = (PImage[]) shorten(arrows);
          println("correct");
          curIdx--;
          println(curIdx);
        }
        else{
          //if player press wrong button, remaning time is reduced
          println("fail");
          time += 0.1;
        }
      }
        
      if(keyCode == DOWN){
        println("pressed down");
        if(arrows[curIdx] == down){
        arrows = (PImage[]) shorten(arrows);
        println("correct");
        curIdx--;
        println(curIdx);
        }
        else{
          println("fail");
          time += 0.1;
        }
      }
        
        
      if(keyCode == LEFT){
        println("pressed left");
        if(arrows[curIdx] == left){
          arrows = (PImage[]) shorten(arrows);
          println("correct");
          curIdx--;
          println(curIdx);
        }
        else{
          println("fail");
          time += 0.1;
        }
      }
    
        
      if(keyCode == RIGHT){
        println("pressed right");
        if(arrows[curIdx] == right){
          arrows = (PImage[]) shorten(arrows);
          println("correct");
          curIdx--;
          println(curIdx);
        }
        else{
          println("fail");
          time += 0.1;
        }
      }
    }
  }
}
