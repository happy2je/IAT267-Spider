class Spider {

    final int ANIMATION_SPEED = 500; // monster animation speed in milliseconds
      final int HEALTH_BAR_WIDTH = 900;
  final int HEALTH_BAR_HEIGHT = 40;
  final int MONSTER_RESISTANCE = 20;
  
  PVector pos, dim;
  boolean isDead;
  PImage movement1;
  PImage movement2;
  int currentHealth;
  
  // Constructor
  Spider(PVector pos) {
    this.pos = pos;
    //dim = new PVector(550, 550);
    isDead = false;
    
    movement1 = loadImage("data/spider1.png");
    movement2 = loadImage("data/spider2.png");    
  }

  void update(int size) {
    // Draws the monster and health if it is not dead
    if (!isDead) {
      //drawHealthBar();
      if (valP_light>1) drawCharacter(size);
    }
  }
  
  
  // Draws the monster with alternating frames
  void drawCharacter(int size) {
    // Pushes the current transformation matrix onto the matrix stack
    pushMatrix();
    
    // Draw the monster
    translate(pos.x, pos.y);    
    imageMode(CENTER);
    PImage currentImg;
    currentImg = movement1;
//     Change the monster frames every ANIMATION_SPEED ms
    if ((millis() / ANIMATION_SPEED) % 2 == 0) {
      currentImg = movement1;
    } else {
      currentImg = movement2;
    }
    
     if (currentImg != null) {
    image(currentImg, 0, 0, size, size);
  } else {
    println("currentImg is null! Make sure images are loaded correctly.");
  }
    //image(currentImg, 0, 0, size, size);
    
    // Pops the current transformation matrix off the matrix stack
    popMatrix();
  }
  
  
  
  
 
}
