class Apple {
  // Constants
  final int HEALTH_BAR_WIDTH = 900;
  final int HEALTH_BAR_HEIGHT = 40;
  final int APPLE_RESISTANCE = 200;
  
  PVector pos, dim;
  boolean isDead;
  PImage movement1;
  PImage movement2;
  PImage movement3;
  PImage currentImg;
  int currentHealth;
  
  // Constructor
  Apple(PVector pos) {
    this.pos = pos;
    dim = new PVector(550, 550);
    isDead = false;
    currentHealth = HEALTH_BAR_WIDTH;
    
    movement1 = loadImage("data/apple1.png");
    movement2 = loadImage("data/apple2.png");    
    movement3 = loadImage("data/apple3.png");

    currentImg = movement1;
  }

  void update() {
    // Draws the apple and health if it is not dead
    if (!isDead) {
      drawHealthBar();
      drawCharacter();
    }
  }
  
  // Apple gets eaten
  void inflictDamage(int damage) {
    damage /= APPLE_RESISTANCE;
    currentHealth -= damage;
    
    if (currentHealth <= 0) {
      isDead = true;
    }
  }
  
  // Draws the apple
  void drawCharacter() {
    // Pushes the current transformation matrix onto the matrix stack
    pushMatrix();
    
    translate(pos.x, pos.y);    
    imageMode(CENTER);
    image(currentImg, 0, 0, dim.x, dim.y);
    
    // Pops the current transformation matrix off the matrix stack
    popMatrix();
  }
  
  // Draws the health bar with the current health and background
  void drawHealthBar() {
    // Pushes the current transformation matrix onto the matrix stack
    pushMatrix();
    
    // Draw the health bar background
    fill(0, 64); // Fill with gray color
    strokeWeight(3);
    translate(pos.x, pos.y + dim.y / 2 + HEALTH_BAR_HEIGHT);
    rectMode(CENTER);
    rect(0, 0, HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT);
    
    // Change the current health bar color based on the percentage of life
    if (currentHealth >= (HEALTH_BAR_WIDTH * 0.6)) { // Current health >= 60%
      fill(0, 255, 0); // green
      currentImg = movement2;
    } else if (currentHealth >= (HEALTH_BAR_WIDTH * 0.3)) { // Current health >= 30%
      fill(255, 165, 0); // orange
      currentImg = movement3;
    } else { // Current health >= 0%
      fill(255, 0, 0); // red
    }
    
    // Draw the current health bar (current apple life)
    if (currentHealth > 0) {
      rect(0, 0, currentHealth, HEALTH_BAR_HEIGHT);
    }
    
    // Pops the current transformation matrix off the matrix stack
    popMatrix();
  }
}
