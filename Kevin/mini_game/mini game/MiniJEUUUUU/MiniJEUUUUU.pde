PImage sunflower, bui, arbre, feuille;
ArrayList<ImageElement> images = new ArrayList<ImageElement>();
float scaleFactor = 0.1; 

void setup() {
  size(400, 400);
  noFill();
  rectMode(CENTER);
  ellipseMode(CENTER);
  imageMode(CENTER);

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

void draw() {
  background(255);

  for (ImageElement img : images) {
    img.display();
  }

  if (images.size() == 0) {
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(0);
    text("Well done ,Let's continue the maze !", width / 2, height / 2);
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    int indexToRemove = -1;
    for (int i = images.size() - 1; i >= 0; i--) {
      ImageElement img = images.get(i);
      if (img.contains(mouseX, mouseY)) {
        indexToRemove = i;
        break;
      }
    }
    if (indexToRemove >= 0) {
      images.remove(indexToRemove);
    }
  }
}



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

boolean isOverlapping(float x, float y, PImage selectedImage) {
  for (ImageElement img : images) {
    float d = dist(x, y, img.x, img.y);
    if (d < (selectedImage.width / 2 + img.img.width / 2)) {
      return true; // Les images se chevauchent
    }
  }
  return false;
}

void spawnImages(int numImages) {
  for (int i = 0; i < numImages; i++) {
    PImage selectedImage = getRandomImage();
    float x, y;
    do {
      x = random(selectedImage.width / 2, width - selectedImage.width / 2);
      y = random(selectedImage.height / 2, height - selectedImage.height / 2);
    } while (isOverlapping(x, y, selectedImage));
    images.add(new ImageElement(selectedImage, x, y));
  }
}

class ImageElement {
  PImage img;
  float x, y;

  ImageElement(PImage img, float x, float y) {
    this.img = img;
    this.x = x;
    this.y = y;
  }

  boolean contains(float px, float py) {
    float halfWidth = img.width / 2;
    float halfHeight = img.height / 2;
    return px > x - halfWidth && px < x + halfWidth && py > y - halfHeight && py < y + halfHeight;
  }

  void display() {
    image(img, x, y);
  }
}
