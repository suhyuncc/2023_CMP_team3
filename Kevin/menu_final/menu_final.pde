
PFont horrorFont;
Button playButton;
Button quitButton;
Button creditButton;
PImage img;


void setup() {
  size(1000, 800);
  //background(0);
  img= loadImage("c.jpg");
  

  
  // Charger la police
  horrorFont = createFont("Arial", 32);
  
  // Créer les boutons
  playButton = new Button(width/10 + 20, height/3+400, 200, 80, "Play");
  quitButton = new Button(width/3+70, height/3+400, 200, 80, "Quit");
  creditButton = new Button(width/1.5+20, height/3+400, 200, 80, "Credit");
}

void draw() {
  //background(0);
    image(img, 0, 0);


  textAlign(CENTER, CENTER);
  
  // Effet d'horreur pour le titre
  fill(255, 0, 0); // Rouge sang
  textSize(70);
  text("ESCAPING SHADOWS", width/2, 100 + random(-5, 5)); // Effet de brouillard
  
  // Afficher les boutons
  playButton.display();
  quitButton.display();
  creditButton.display();
  
  // Vérifier si la souris est sur un bouton
  playButton.hoverEffect();
  quitButton.hoverEffect();
  creditButton.hoverEffect();
}

void mousePressed() {
  if (playButton.isMouseOver()) {
    // Action pour le bouton jouer
    println("Démarrer le jeu !");
  } else if (quitButton.isMouseOver()) {
    // Action pour le bouton quitter
    println("Quitter le jeu !");
  }
}

// Classe pour le bouton
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
    rect(x, y, w, h, 7);
    fill(0);
    textSize(18); // Réduire la taille du texte des boutons
    text(label, x + w/2, y + h/2);
  }
  
  void hoverEffect() {
    if (isMouseOver()) {
      fill(173, 216, 230); // Bleu clair
    } else {
      fill(255, 165, 0); // Orange
    }
    rect(x, y, w, h, 7);
    fill(0);
    textSize(18); // Réduire la taille du texte des boutons
    text(label, x + w/2, y + h/2);
  }
  
  boolean isMouseOver() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
