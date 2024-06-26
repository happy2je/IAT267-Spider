class Monster {
  final int ANIMATION_SPEED = 500; // monster animation speed in milliseconds
  final int HEALTH_BAR_WIDTH = 900;
  final int HEALTH_BAR_HEIGHT = 40;
  final int MONSTER_RESISTANCE = 50;
  
  PVector pos, dim;
  boolean isDead;
  PImage movement1;
  PImage movement2;
  int currentHealth;
  
  // Constructor
  Monster(PVector pos) {
    this.pos = pos;
    dim = new PVector(550, 550);
    isDead = false;
    currentHealth = HEALTH_BAR_WIDTH;
    
    movement1 = loadImage("data/monster1.png");
    movement2 = loadImage("data/monster2.png");    
  }

  void update() {
    // Draws the monster and health if it is not dead
    if (!isDead) {
      drawHealthBar();
      drawCharacter();
    }
  }
  
  // Monster takes damage  
  void inflictDamage(int damage) {
   // beep.play();
    damage /= MONSTER_RESISTANCE;
    currentHealth -= damage;
    
    if (currentHealth <= 0) {
      isDead = true;
    }
    
     // Play beep sound only when force sensor is pressed\
     if (damage > 0) {
    beep.play();
  }
 }
  
  // Draws the monster with alternating frames
  void drawCharacter() {
    // Pushes the current transformation matrix onto the matrix stack
    pushMatrix();
    
    // Draw the monster
    translate(pos.x, pos.y);    
    imageMode(CENTER);
    PImage currentImg;
    // Change the monster frames every ANIMATION_SPEED ms
    if ((millis() / ANIMATION_SPEED) % 2 == 0) {
      currentImg = movement1;
    } else {
      currentImg = movement2;
    }
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
    } else if (currentHealth >= (HEALTH_BAR_WIDTH * 0.3)) { // Current health >= 30%
      fill(255, 165, 0); // orange
    } else { // Current health >= 0%
      fill(255, 0, 0); // red
    }
    
    // Draw the current health bar (current monster life)
    if (currentHealth > 0) {
      rect(0, 0, currentHealth, HEALTH_BAR_HEIGHT);
    }
    
    // Pops the current transformation matrix off the matrix stack
    popMatrix();
  }
}
