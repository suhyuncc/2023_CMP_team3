class Button {
  float x, y, w, h;
  String label;
  
  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  void display() {
    textAlign(CENTER, CENTER);
    if (isMouseOver()) {
      fill(204, 229, 255); // Bleu clair
    } else {
      fill(255, 165, 0); // Orange
    }
    rectMode(CENTER);
    rect(x, y, w, h, 7);
    fill(0);
    textSize(18); // Réduire la taille du texte des boutons
    textMode(CENTER);
    text(label, x, y);
  }
  
  void hoverEffect() {
    if (isMouseOver()) {
      fill(173, 216, 230); // Bleu clair
    } else {
      fill(255, 165, 0); // Orange
    }
    rectMode(CENTER);
    rect(x, y, w, h, 7);
    fill(0);
    textSize(18); // Réduire la taille du texte des boutons
    textMode(CENTER);
    text(label, x, y);
  }
  
  boolean isMouseOver() {
    return mouseX > x - w/2 && mouseX < x + w/2 && mouseY > y - h/2 && mouseY < y + h/2;
  }
}
