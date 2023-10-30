class WallGame{
  
  PImage sunflower, bui, arbre, feuille;
  ArrayList<ImageElement> images = new ArrayList<ImageElement>();
  float scaleFactor = 0.1; 
  
  WallGame(){
    sunflower = loadImage("sunflower.png");
    bui = loadImage("bui.png");
    arbre = loadImage("arbre.png");
    feuille = loadImage("feuille.png");

    sunflower.resize(int(sunflower.width * scaleFactor), int(sunflower.height * scaleFactor));
    bui.resize(int(bui.width * scaleFactor), int(bui.height * scaleFactor));
    arbre.resize(int(arbre.width * scaleFactor), int(arbre.height * scaleFactor));
    feuille.resize(int(feuille.width * scaleFactor), int(feuille.height * scaleFactor));
    
    spawnImages(10); 
  }
  
  //Display Game page
  void drawWallGame(){
    
    Wall_pg.beginDraw();
    Wall_pg.background(70);
    Wall_pg.textSize(60);
    Wall_pg.textAlign(CENTER);
    Wall_pg.text("Clash!!",250,60);
    Wall_pg.endDraw();
    
  }
  
  //set image randomly
  PImage getRandomImage() {
    int imgIndex = int(random(4));
      switch (imgIndex) {
        case 0:
          return sunflower;
        case 1:
          return bui;
        case 2:
          return arbre;
        case 3:
          return feuille;
    }
    return sunflower; 
  }

  // checking image overlap
  boolean isOverlapping(float x, float y, PImage selectedImage) {
    for (ImageElement img : images) {
      float d = dist(x, y, img.x, img.y);
      if (d < (selectedImage.width / 2 + img.img.width / 2)) {
        return true; // Les images se chevauchent
      }
    }
    return false;
  }
  
  //spawn images and add on array
  void spawnImages(int numImages) {
    for (int i = 0; i < numImages; i++) {
      PImage selectedImage = getRandomImage();
      float x, y;
      do {
        x = random(300 + selectedImage.width / 2, 700 - selectedImage.width / 2);
        y = random(300 + selectedImage.height / 2, 600 - selectedImage.height / 2);
      } while (isOverlapping(x, y, selectedImage));
      images.add(new ImageElement(selectedImage, x, y));
    }
}
  
  
  
  
  
  
  
}
