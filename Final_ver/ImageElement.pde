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
