
PFont horrorFont;
Button playButton;
Button quitButton;

void setup() {
  size(400, 300);
  background(0);
  
  // Charger la police
  horrorFont = createFont("Arial", 32);
  
  // Créer les boutons
  playButton = new Button(width/2 - 50, height/2, 100, 40, "Jouer");
  quitButton = new Button(width/2 - 50, height/2 + 60, 100, 40, "Quitter");
}

void draw() {
  background(0);
  textAlign(CENTER, CENTER);
  
  // Effet d'horreur pour le titre
  fill(255, 0, 0); // Rouge sang
  textSize(32);
  text("M E N U   D E   J E U", width/2, 50 + random(-2, 2)); // Effet de brouillard
  
  // Afficher les boutons
  playButton.display();
  quitButton.display();
  
  // Vérifier si la souris est sur un bouton
  playButton.hoverEffect();
  quitButton.hoverEffect();
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
