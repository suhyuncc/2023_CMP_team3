PImage up, down, left, right;
PImage clear, fail;

PImage[] arrows;

int curIdx;

//ranNum for set arrays length randomly
int ranNum = 0;

//time value is for time limits in minigame
float time = 0;

void setup(){
  size(1600, 900);
  background(255);
  rectMode(CENTER);
  ranNum = (int)random(8, 13);//random number from 8 to 12(number of image)
  
  //load images
  up = loadImage("up.png");
  down = loadImage("down.png");
  left = loadImage("left.png");
  right = loadImage("right.png");
  clear = loadImage("clear.png");

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
  println(curIdx);
}

void draw(){
  background(255);
  //if you complete minigame, the timer is stop
  //time limit is 3 seconds
  if(arrows.length != 0 && time <= 3){
    time += 0.01;
  }
  
  //timer
  if(time <= 3){
  fill(255, 0, 0);
  rect(width/2, 800, 600 - 200*time, 100);
  }
  
  //shows image from last index of array, because the array is kind of stack.
  //When you pressed the correct arrow, the function 'shorten' will be applied
  //and if(function shorten) pops out last index of array.
  //To make player to press arrow from left side to right side, I showed image
  //from last index to first index
  for(int i = arrows.length - 1; i >= 0; i--){
    //I set images position of X like below to make them locate on the center.
    image(arrows[i], width - (850 - arrows.length * 50) - 100*i , 100, 50, 50);
  }
  
  //when you don't make it in time
  if(time > 3){
    println("task fail");
  }
  
  if(arrows.length == 0){
    image(clear, 650, 250, 300, 300);
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
          println("fail");
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
        }
      }
    }
  }
}
