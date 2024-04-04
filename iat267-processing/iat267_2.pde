// Libraries
import ddf.minim.*;
import processing.serial.*;

// Port
Serial port;

// Monster objects
Monster monster;

// Sensor values
int valP_force; 
int valP_light;

// Misc
int time = 0;

// Game states/levels
final int INTRO = 0;
final int LEVEL_ONE = 1;
int current_level;

byte[] inBuffer = new byte[255]; // Size of the serial buffer to allow for end of data characters and all chars (see arduino code)

// Checks each state/level if it has been initialized and prevents setup from being executed more than once
boolean setupMonster = false;
boolean setupIntro = false;
boolean setupWon = false;
boolean setupLost = false;

void setup() {
  size(1400,800);
  monster = new Monster(new PVector(width / 2, height / 2));
  
  // Load font
  PFont font = loadFont("FuturaBT-Book-48.vlw");
  textFont(font, height/20);
  
  // Set level
  current_level = INTRO;
  
  //open the port that the board's connected to & use the same speed (9600 bps)
  println(Serial.list());
  port = new Serial(this,Serial.list()[1],9600);
}

void draw() {
  background(50);
  
  if (port.available()>0){
    port.readBytesUntil('&', inBuffer); //read in all the data until '&' is encountered
    
    if (inBuffer != null){
      String myString = new String(inBuffer);
      
      //p is all the sensor data (with a's and b's) ('&' is eliminated)
      String[] p = splitTokens(myString, "&");
      println(p);
      if (p.length < 2) return; //exit this function is packet is broken
      
      /*
        Force Sensor
      */
      String[] force_sensor = readSensorValues(p, "a", "Force sensor in String:");
      String[] light_sensor = readSensorValues(p, "b", "Light sensor in String:"); 
      //String[] force_sensor = splitTokens(p[0], "a"); //get force sensor reading
      //String[] light_sensor = splitTokens(p[0], "b");  //get light sensor reading 
      
      if (force_sensor.length != 3) return; //exit this function if packet is broken
      valP_force = int(force_sensor[0]);
      
      if (light_sensor.length != 3) return;  //exit this function if packet is broken
      valP_light = int(light_sensor[0]);
      
      print("force sensor in int:");
      print(valP_force);
      println(" ");
      monster.inflictDamage(valP_force);
      
      print("light sensor in int:");
      print(valP_light);
      println(" "); 

      
      /*
        Light Sensor reading
      */  
      //String[] light_sensor = readSensorValues(p, "b", "Light sensor in String:");   
      ////String[] light_sensor = splitTokens(p[0], "b");  //get light sensor reading 

      //if (light_sensor.length != 3) return;  //exit this function if packet is broken
      //valP_light = int(light_sensor[1]);

      //print("light sensor in int:");
      //print(valP_light);
      //println(" "); 
      
      
              
    }
  }
  
  // Switches the level based on current_level
  switchLevel();
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

// Based on the current_level, it runs a specific 
void switchLevel() {
  switch (current_level) {
    case INTRO: {
      drawStoryTextBox("Make the spider move to shine the wall...");
      if (valP_light > 250) current_level = LEVEL_ONE;
      break;
    }
    case LEVEL_ONE: {
      monster.update();
      displayLevelOne();
      break;
    }
    default:
      print("Invalid state found. Please try again");
      break;
  }
}

// Draw level 1 text box
void displayLevelOne() {
  if (!monster.isDead) {
    drawEventTextBox("OH NO! The monster is on your way! Press the Force Sensor on the robot to attack the monster.");
  } else {
    drawStoryTextBox("You have defeated the monster! Move on.");
  }
}
