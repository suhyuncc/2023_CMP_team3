import processing.sound.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

AudioIn input;
Amplitude analyzer;

PImage map_image, main_image;
PGraphics pg, Arrow_pg, Wall_pg;
PFont horrorFont;

boolean LightOn, OnGhost, GameStart, OnWall, Pause, isGoal, end_lose, end_win;

LowBettery bettery;
Player player;
Collider collider;
Ghost ghost;
ArrowGame arrowGame;
WallGame wallGame;
Button playButton, quitButton, restartButton, s_quitButton, creditButton;
Goal up_goal, down_goal;

float light_dis;
float value = 0;

//-----------------------------------------------------------------------------------//

//Goal Game

Capture video;
OpenCV opencv;
int detectionTimer; // Timer for face detection
boolean faceDetected; // Flag indicating if a face is currently detected
int holdDuration = 3 * 20; // 3 seconds (assuming 60 frames per second)
float movementThreshold = 50; // Adjust the threshold based on your needs

// Variables to store the previous position of the face rectangle
float prevX, prevY, prevWidth, prevHeight;

// Variables for the enemy (red rectangle)
float enemyX, enemyY, enemySpeed;

void setup(){
  
  input = new AudioIn(this, 0);
  input.start();
  analyzer = new Amplitude(this);
  analyzer.input(input);
  
  horrorFont = createFont("Arial", 32);
  map_image = loadImage("maze.png");
  main_image = loadImage("c.jpg");
  
  player = new Player();
  bettery = new LowBettery();
  ghost = new Ghost();
  arrowGame = new ArrowGame();
  wallGame = new WallGame();
  
  playButton = new Button(width/5, height/3+400, 200, 80, "Play");
  s_quitButton = new Button(width/2, height/3+400, 200, 80, "Quit");
  creditButton = new Button(width * 4 /5, height/3+400, 200, 80, "Credit");
  
  
  quitButton = new Button(width/2, height/2 + 160, 250, 80, "Quit");
  restartButton = new Button(width/2, height/2 + 300, 250, 80, "ReStart");
  
  up_goal = new Goal(160, 20);
  down_goal = new Goal(840, 780);
  
  LightOn = false;
  OnGhost = false;
  GameStart = false;
  OnWall = false;
  Pause = false;
  isGoal = false;
  end_lose = false;
  end_win = false;
  light_dis = 100;
  
  size(1000, 800, P2D);
  background(255);
  image(map_image, 100, 0, 800, 800);
  collider = new Collider();
  pg = createGraphics(500, 500);
  Arrow_pg = createGraphics(1000, 800);
  Wall_pg = createGraphics(500, 500);
//-----------------------------------------------------------------------------------//

  //use under second code when your processing error
  video = new Capture(this, 1000, 800, "Camera Sensor OV02C10");
  //video = new Capture(this, 1000, 800);
  
  // set up OpenCV
  opencv = new OpenCV(this, 1000, 800);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();
  detectionTimer = 0;
  faceDetected = false;
  prevX = prevY = prevWidth = prevHeight = 0;

  // Initialize enemy position and speed
  enemyX = random(width);
  enemyY = random(height);
  enemySpeed = 2; // Adjust the speed as needed
  
}

void draw(){
  //Show main page when game start
  if(!GameStart){
    player.speed = 0;
    ghost.speed = 0;
    background(0);
    textAlign(CENTER, CENTER);
    
    imageMode(CENTER);
    image(main_image, width/2, height/2);
    
    fill(255, 0, 0);
    textSize(70);
    text("ESCAPING SHADOWS", width/2, 100 + random(-5, 5));
    
    // Display buttons
    playButton.display();
    s_quitButton.display();
    creditButton.display();
  
    //MouseOver effect on button
    playButton.hoverEffect();
    s_quitButton.hoverEffect();
    creditButton.hoverEffect();
    
    return;
  }
  // Show Pause page
  else if(Pause){
    player.speed = 0;
    ghost.speed = 0;
    background(0);
    textAlign(CENTER, CENTER);
    
    fill(255, 0, 0);
    textSize(70);
    text("Pause!!", width/2, 230 + random(-2, 2));
  
    restartButton.display();
    quitButton.display();
  
    restartButton.hoverEffect();
    quitButton.hoverEffect();
  }
  
  //Show final page after game
  else if(end_lose || end_win){
    //reposition Button
    restartButton = new Button(width/2, height/2 + 60, 250, 80, "ReStart");
    
    player.speed = 0;
    ghost.speed = 0;
    background(0);
    textAlign(CENTER, CENTER);
    
    
    textSize(70);
    if(end_lose){
      fill(255, 0, 0);
      text("Try Again!!", width/2, 230 + random(-2, 2));
    }
    else if(end_win){
      fill(255);
      text("Escape!!", width/2, 230 + random(-2, 2));
    }
    
  
    restartButton.display();
    quitButton.display();
  
    restartButton.hoverEffect();
    quitButton.hoverEffect();
  }
  
  //Show charging game page when Flash light's battery over
  else if(light_dis < 0){
    player.speed = 0;
    ghost.speed = 0;
    bettery.drawPage();
    image(pg, 500, 400);
    rectMode(CORNERS);
    fill(255,255,255);
    rect(400, 300, 600, 580);
    rectMode(CORNERS);
    fill(0,255,0);
    rect(400, 580 - (2.8 * value), 600, 580);
  }
  
  //Show arrowgame when meet ghost
  else if(OnGhost){
    player.speed = 0;
    ghost.speed = 0;
    arrowGame.drawArrowGame();
    image(Arrow_pg, 500, 400);
    
    if(arrowGame.arrows.length != 0 && arrowGame.time <= 3){
      arrowGame.time += 0.01;
    }
    
    if(arrowGame.time <= 3){
      fill(255, 0, 0);
      rectMode(CENTER);
      rect(width/2, 800, 600 - 200 * arrowGame.time, 100);
      fill(0);
      textSize(50);
      text("Timer", width/2, 700);
    }
    
    for(int i = arrowGame.arrows.length - 1; i >= 0; i--){
      //I set images position of X like below to make them locate on the center.
      image(arrowGame.arrows[i], width - (arrowGame.arrow_pos * (i + 1)), 100, 30, 30);
    }
    
    //when you don't make it in time
    if(arrowGame.time > 3){
      image(arrowGame.fail, width/2, height/2, 300, 300);
      textSize(50);
      fill(255,0,0);
      text("Fail", width/2, 600);
      
      restartButton.display();
      restartButton.hoverEffect();
    }
  
    if(arrowGame.arrows.length == 0){
      OnGhost = false;
      arrowGame = new ArrowGame();
    }
  }
  
  //show clash mini game when player collide on the wall
  else if(OnWall){
    player.speed = 0;
    ghost.speed = 0;
    background(0);
    wallGame.drawWallGame();
    image(Wall_pg, 500, 400);
    
    for (ImageElement img : wallGame.images) {
      img.display();
    }
    
    if (wallGame.images.size() == 0) {
      OnWall = false;
      wallGame = new WallGame();
    }
  }
  else if(isGoal){
    player.speed = 0;
    ghost.speed = 0;
    
    opencv.loadImage(video);
    
    imageMode(CENTER);
    image(video, width/2, height/2);
    
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);


    // Detect faces from the video frame
    Rectangle[] faces = opencv.detect();

    // If no faces are detected, reset the timer
    if (faces.length == 0) {
      detectionTimer = 0;
      faceDetected = false;
    }

    // Draw a rect around each face
    for (int i = 0; i < faces.length; i++) {
      float x = faces[i].x;
      float y = faces[i].y;
      float w = faces[i].width;
      float h = faces[i].height;

      // Check if the movement of the face rectangle is below the threshold
      if (abs(x - prevX) < movementThreshold && abs(y - prevY) < movementThreshold &&
        abs(w - prevWidth) < movementThreshold && abs(h - prevHeight) < movementThreshold) {
        // Update the timer when the movement is below the threshold
        detectionTimer++;
        println(detectionTimer);
      } else {
        // Reset the timer when the movement is above the threshold
        detectionTimer = 0;
      }

      // Draw a rect around each face centered on the face
      rectMode(CENTER);
      rect(x + w / 2, y + h / 2, w, h);

      // Update the previous position
      prevX = x;
      prevY = y;
      prevWidth = w;
      prevHeight = h;

      // Update the flag if a face is detected
      faceDetected = true;
    }

    // Draw the enemy (red rectangle)
    fill(255, 0, 0); // Red fill color
    rect(enemyX, enemyY, 50, 50); // Adjust the size as needed

    // Update the enemy position
    if (faceDetected) {
      // Follow the face
      float deltaX = prevX - enemyX;
      float deltaY = prevY - enemyY;
      float distance = dist(enemyX, enemyY, prevX, prevY);
      enemyX += (deltaX / distance) * enemySpeed;
      enemyY += (deltaY / distance) * enemySpeed;
    }

    // Display the counter on the screen in red
    fill(255, 0, 0); // Set the fill color to red
    textSize(24);
    text("Hold still: " + (holdDuration - detectionTimer) / 20 + " seconds", 120, 30);
    
    // If the center of the red rectangle is within the bounds of the face, end the game and print "You Lose"
    if (faceDetected && enemyX > prevX && enemyX < prevX + prevWidth && enemyY > prevY && enemyY < prevY + prevHeight) {
      println("You Lose");
      end_lose = true;
    }

    // If a face is continuously detected for the hold duration, close the sketch and print "You Win"
    if (faceDetected && detectionTimer >= holdDuration) {
      println("You Win");
      end_win = true;
    }
    
    return;
  }
  else{
    player.speed = 5;
    ghost.speed = 0.01;
    background(255);
    imageMode(CORNER);
    image(map_image, 100, 0, 800, 800);
    imageMode(CENTER);
    image(player.p_image, player.pos_x, player.pos_y, 40, 40);
    imageMode(CENTER);
    image(ghost.p_image, ghost.pos_x, ghost.pos_y, 40, 40);
    ghost.follow(player.pos_x,player.pos_y);
    FlashLight();
    light_dis -= 0.061;
    float vol = analyzer.analyze();
    if(dist(player.pos_x, player.pos_y, ghost.pos_x, ghost.pos_y) < 20){
      ghost = new Ghost();
      OnGhost = true;
    }
    else if(dist(player.pos_x, player.pos_y, ghost.pos_x, ghost.pos_y) < light_dis &&
    vol * 100 > 3){
      ghost = new Ghost();
    }
    else if(dist(player.pos_x, player.pos_y, up_goal.pos_x, up_goal.pos_y) < 40){
      isGoal = true;
    }
    else if(dist(player.pos_x, player.pos_y, down_goal.pos_x, down_goal.pos_y) < 40){
      isGoal = true;
    }
    
    return;
  }
  
}

// Working feature like flashlight on game
void FlashLight(){
  loadPixels();
  for (int y = 0; y < height; y++ ) {
    for (int x = 0; x < width; x++ ) {
      int loc = x + y * width;
      
      float r = red(pixels[loc]);
      float g = green(pixels[loc]);
      float b = blue(pixels[loc]);

      float distance = dist(x, y, mouseX, mouseY);
     
      float adjustBrightness = map(distance, 0, light_dis, 1, 0);
      r *= adjustBrightness;
      g *= adjustBrightness;
      b *= adjustBrightness;
      
      r = constrain(r, 0, 255); 
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);
      
      b = b * 108 / 255;
      // Set the display pixel to the image pixel
      pixels[loc] = color(r,g,b);
    }
  }
  updatePixels();
}

void keyPressed(){
  // push 'p' open 'pause page'
  if(key == 'p'){
    if(!Pause){
      quitButton = new Button(width/2, height/2 + 160, 250, 80, "Quit");
      restartButton = new Button(width/2, height/2 + 60, 250, 80, "ReStart");
      Pause = true;
    }
    else{
      Pause = false;
    }
  }
  //else if(key == 'c'){
  //  isGoal = true;
  //}
  //else if(key == 'l'){
  //  light_dis = -1.0;
  //}
  
  //move player using Arrowkey
  if(keyCode == RIGHT){
    if(!collider.walls[int(player.pos_x) + 5 + int(player.pos_y) * width]){
      player.GoRight();
    }
    else{
      OnWall = true;
    }
    
  }
  else if(keyCode == LEFT){
    if(!collider.walls[int(player.pos_x) - 5 + int(player.pos_y) * width]){
      player.GoLeft();
    }
    else{
      OnWall = true;
    }
    
  }
  else if(keyCode == UP){
    if(!collider.walls[int(player.pos_x) + (int(player.pos_y) - 15) * width]){
      player.GoUp();
    }
    else{
      OnWall = true;
    }
    
  }
  else if(keyCode == DOWN){
    if(!collider.walls[int(player.pos_x) + (int(player.pos_y) + 15) * width]){
      player.GoDown();
    }
    else{
      OnWall = true;
    }
    
  }
  
  //if the time reaches the limit, pressing key doesn't work
  if(OnGhost){
    if(arrowGame.arrows.length != 0){//to avoid Nullpoint Exception
      if(keyCode == UP){
        if(arrowGame.arrows[arrowGame.curIdx] == arrowGame.up){
          arrowGame.arrows = (PImage[]) shorten(arrowGame.arrows);
          arrowGame.curIdx--;
        }
        else{
          println("fail");
        }
      }
        
      if(keyCode == DOWN){
        if(arrowGame.arrows[arrowGame.curIdx] == arrowGame.down){
        arrowGame.arrows = (PImage[]) shorten(arrowGame.arrows);
        arrowGame.curIdx--;
        }
        else{
          println("fail");
        }
      }
        
        
      if(keyCode == LEFT){
        if(arrowGame.arrows[arrowGame.curIdx] == arrowGame.left){
          arrowGame.arrows = (PImage[]) shorten(arrowGame.arrows);
          arrowGame.curIdx--;
        }
        else{
          println("fail");
        }
      }
    
        
      if(keyCode == RIGHT){
        if(arrowGame.arrows[arrowGame.curIdx] == arrowGame.right){
          arrowGame.arrows = (PImage[]) shorten(arrowGame.arrows);
          arrowGame.curIdx--;
        }
        else{
          println("fail");
        }
      }
    }
  }
}

void mouseMoved() {
  // when flashlight's bettery over charge bettery to move mouse
  if(light_dis < 0){
    value = value + 0.1;
    if (value > 100) {
      light_dis = 100;
      value = 0;
      ghost = new Ghost();
    }
  }
}

void mousePressed(){
  
  if (mouseButton == LEFT) {
    if(!GameStart){
      if (playButton.isMouseOver()) {
        player = new Player();
        ghost = new Ghost();
        
        //Initilize for after second time's play
        light_dis = 100;
        GameStart = true;
        LightOn = false;
        OnGhost = false;
        OnWall = false;
        Pause = false;
        isGoal = false;
        end_lose = false;
        end_win = false;
      }
      else if (s_quitButton.isMouseOver()) {
        exit();
      }
    }
    else if(OnWall){
      int indexToRemove = -1;
      for (int i = wallGame.images.size() - 1; i >= 0; i--) {
        ImageElement img = wallGame.images.get(i);
        if (img.contains(mouseX, mouseY)) {
          indexToRemove = i;
          break;
        }
      }
      if (indexToRemove >= 0) {
        wallGame.images.remove(indexToRemove);
      }
    }
    else if(OnGhost){
      if (restartButton.isMouseOver()) {
        GameStart = false;
        OnGhost = false;
        arrowGame = new ArrowGame();
      }
    }
    else if(Pause){
      if (restartButton.isMouseOver()) {
        GameStart = false;
        Pause = false;
      }
      else if (quitButton.isMouseOver()) {
        exit();
      }
    }
    else if(end_lose || end_win){
      if (restartButton.isMouseOver()) {
        GameStart = false;
        Pause = false;
      }
      else if (quitButton.isMouseOver()) {
        exit();
      }
    }
  }
  
}

void captureEvent(Capture c) {
  c.read();
}
