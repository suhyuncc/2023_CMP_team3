import processing.sound.*;


SoundFile player;
PImage soundOn, soundOff;
boolean isLoaded = false;
boolean isSoundOn = true;
boolean isButtonVisible = true;
boolean clickToggle = true;

void setup() {
  size(400, 400);
  soundOn = loadImage("on.png");
  soundOff = loadImage("off.png");
  soundOn.resize(50, 50);
  soundOff.resize(50, 50);
  
  thread("loadSong");
}

void loadSong(){//load song in other thread
  player = new SoundFile(this, "song.mp3");
  isLoaded = true;
  player.play();//play after loaded
}

void draw() {
  if(isLoaded == true){//work only after the song is loaded
    if (isButtonVisible) {
      if (isSoundOn) {
        if (clickToggle) {
          background(255);
          image(soundOn, width - 50, height - 50);
        } else {
          background(255);
          image(soundOff, width - 50, height - 50);
        }
      } else {
        background(255);
        image(soundOff, width - 50, height - 50);
      }
    }
  }
}

void mousePressed() {
  int buttonX = width - 50;
  int buttonY = height - 50;

  if(isLoaded == true){//only work after the song is loaded
    if (mouseX >= buttonX && mouseX <= buttonX + 50 && mouseY >= buttonY && mouseY <= buttonY + 50) {
      isSoundOn = !isSoundOn;
      
      if (isSoundOn) {
        player.play();
      } else {
        player.pause();
      }
  
      clickToggle = !clickToggle;
    }
  }
}
