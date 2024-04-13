// Libraries
import ddf.minim.*;
import processing.serial.*;
//import processing.video.*;

// Port
Serial port;

// Camera
Camera myCamera;

// Sounds
Minim minim;
AudioPlayer cave, walk, combat, beep;
final String CAVE = "data/cave.mp3";
final String WALK = "data/walking5.wav";
final String COMBAT = "data/combat.mp3";
final String BEEP = "data/beep.mp3";

// Game Objects
Monster monster;
Spider spider;
Apple apple;

// Sensor values
int valP_force; 
int valP_light;
int valP_ultrasonic;
final int LIGHT_THRESHOLD = 250;

// Misc
int time = 0;

// Game states/levels
final int HOWTO = -1;
final int INTRO = 0;
final int LEVEL_ONE = 1;
final int LEVEL_TWO = 2; 
final int LEVEL_THREE = 3;
final int FINISH = 4; 
int current_level;

// Size of the serial buffer to allow for end of data characters and all chars (see arduino code)
byte[] inBuffer = new byte[255]; 

// Checks each state/level if it has been initialized and prevents setup from being executed more than once
boolean setupMonster = false;
boolean setupIntro = false;
boolean setupWon = false;
boolean setupLost = false;

void setup() {
  // Set fullscreen view
  fullScreen();

  // Initialize objects
  monster = new Monster(new PVector(width / 2, height / 2));
  spider = new Spider(new PVector(width / 2, height / 2));
  myCamera = new Camera(this, width/3, height/3); //how big is the camera?
  apple = new Apple(new PVector(width / 2, height / 2));

  // Load font
  PFont font = loadFont("FuturaBT-Book-48.vlw");
  textFont(font, height/20);
  
  // Set level
  current_level = HOWTO;
  
  // Open the port that the board's connected to & use the same speed (9600 bps)
  println(Serial.list());
  port = new Serial(this,Serial.list()[2],9600);
  
  loadSound();
}

void draw() {
  if (port.available() > 0) {
    // Read in all the data until '&' is encountered
    port.readBytesUntil('&', inBuffer);

    if (inBuffer != null) {
      String myString = new String(inBuffer);
      
      // p is all the sensor data (with a's and b's) ('&' is eliminated)
      String[] p = splitTokens(myString, "&");

      if (p.length == 2 || p.length > 2) { 
        println(p);

        /*
          Force Sensor
        */
        if (current_level == LEVEL_ONE || current_level == LEVEL_THREE) {
          String[] force_sensor = readSensorValues(p, "a", "Force sensor in String:");
          print("force sensor String length: ");
          println(force_sensor.length);

          if (force_sensor.length == 2) {
            valP_force = int(force_sensor[0]);
            print("force sensor in int:");
            print(valP_force);
            println(" ");
            monster.inflictDamage(valP_force);
            apple.inflictDamage(valP_force);
          } else {
            // Exit this function if packet is broken
            return;
          }
        }
        
        /*
          Light Sensor reading
        */  
        if (current_level == INTRO) {
          String[] light_sensor = readSensorValues(p, "b", "Light sensor in String:");
          print("light sensor String length: ");
          println(light_sensor.length);

          if (light_sensor.length == 3){
            valP_light = int(light_sensor[1]);
            print("light sensor in int:");
            print(valP_light);
            println(" "); 
          } else {
            // Exit this function if packet is broken
            return;
          } 
        }

        /*
          servo motor reading
        */
        if (current_level == LEVEL_TWO) {
          String[] ultrasonic_sensor = readSensorValues(p, "c", "Ultrasonic sensor in String:");
          print("ultrasonic sensor String length: ");
          println(ultrasonic_sensor.length);

          if (ultrasonic_sensor.length == 3){
            valP_ultrasonic = int(ultrasonic_sensor[1]);
            print("ultrasonic sensor in int:");
            print(valP_ultrasonic);
            println(" "); 
          } else {
            // Exit this function if packet is broken
            return;
          } 
        } else {
          return; //exit if inBuffer is null.
        }
      
        // Draw cave background
        background(50);
        PImage background = loadImage("data/cave1.png");
        background.resize(width, height);
        background(background);

        // Switches the level based on current_level
        switchLevel();
      }
  }
}

// Get the sensor data of a specific code and return it
String[] readSensorValues(String[] sensorData, String code, String message) {
  String[] values = splitTokens(sensorData[0], code);
  print(message);

  // Prints each string in values
  for (String s : values) {
    print(s);
  }
  println(" ");
  return values;
}

// Draws a text box for story
void drawStoryTextBox(String message) {
  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text(message, width/2, height/2);
}

// Draws a text box for an event
void drawEventTextBox(String message) {
  fill(255,193,248);
  rect(width-700,54,700,70);
  fill(0);
  textAlign(CENTER);
  textSize(15);
  text(message, width/2, 60);
}

// Switches the level based on current_level
void switchLevel() {
  switch (current_level) {
    // Instructions scene
    case HOWTO: {
      PImage howto = loadImage("data/howto.png");
      howto.resize(width, height);
      background(howto);
      if (mousePressed) {
        current_level = INTRO;
      }
      break;
    }

    // Introduction scene
    case INTRO: {
      myCamera.update();
      cave.play();

      // Animate spider walking
      if (valP_light > 0) {
        walk.play();
      }

      // Update spider size based on light sensor value
      spider.update(valP_light*3);

      drawStoryTextBox("Make the spider move to shine the wall...");

      // If light sensor value exceeds threshold, move onto level one
      if (valP_light > LIGHT_THRESHOLD) current_level = LEVEL_ONE; 
      break;
    }

    // Level one
    case LEVEL_ONE: {
      combat.play();
      monster.update();

      if (!monster.isDead) {
        drawEventTextBox("OH NO! The monster is on your way! Press the Force Sensor to attack the monster.");
      } else {
        current_level = LEVEL_TWO;
      }
      break;
    }

    // Level two
    case LEVEL_TWO: {
      drawStoryTextBox("You have defeated the monster! Move on.");
      myCamera.update();
      delay(300);

      if (valP_ultrasonic <= 5) {
        current_level = LEVEL_THREE;
        port.write("trigger_servo");
        delay(100);
      }
      break;
    }

    // Level three
    // Servomotor's triggered & door opened. Eat the apple. 
    case LEVEL_THREE: { 
      if (apple.isDead) {
        current_level = FINISH; // Transition to finish level
      } else {
        apple.update();
      }
      break;      
    }
    
    // Game end
    case FINISH: {
      drawStoryTextBox("You fed the Spider and finished the game! Yay!");
      beep.play();
      break;
    }

    // Any other current_level values will run this default code block
    default: {
      print("Invalid state found. Please try again");
      break;
    }
  }
}

// Load the audio files 
void loadSound() {
  minim = new Minim(this);
  cave = minim.loadFile(CAVE);
  walk = minim.loadFile(WALK);
  combat = minim.loadFile(COMBAT);
  beep = minim.loadFile(BEEP);
}
