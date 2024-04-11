// Libraries
import ddf.minim.*;
import processing.serial.*;
//import processing.video.*;

// Port
Serial port;

Camera myCamera;





// Monster objects
Monster monster;
Spider spider;

//radar object
Radar radar;

// Sensor values
int valP_force; 
int valP_light;
int LIGHT_THRESHOLD = 240;

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
  spider = new Spider(new PVector(width / 2, height / 2));
  myCamera = new Camera(this, width/3, height/3); //how big is the camera?
  //video.start();
  radar = new Radar();
  
  // Load font
  PFont font = loadFont("FuturaBT-Book-48.vlw");
  textFont(font, height/20);
  
  // Set level
  current_level = INTRO;
  
  //open the port that the board's connected to & use the same speed (9600 bps)
  println(Serial.list());
  port = new Serial(this,Serial.list()[2],9600);
}

void draw() {

  
  if (port.available()>0){
    port.readBytesUntil('&', inBuffer); //read in all the data until '&' is encountered
    //port.readBytesUntil('&'); //read in all the data until '&' is encountered

    
    if (inBuffer != null){
      String myString = new String(inBuffer);
      
      //p is all the sensor data (with a's and b's) ('&' is eliminated)
      String[] p = splitTokens(myString, "&");

      if (p.length == 2 || p.length > 2){ //exit this function is packet is broken
        println(p);
        /*
          Force Sensor
        */
        String[] force_sensor = readSensorValues(p, "a", "Force sensor in String:");
        //String[] force_sensor = splitTokens(p[0], "a"); //get force sensor reading
        print("force sensor String length: ");
        println(force_sensor.length);
        if (force_sensor.length == 2){ //exit this function if packet is broken
          println("this means force_sensor.length is 2");
          valP_force = int(force_sensor[0]);
          print("force sensor in int:");
          print(valP_force);
          println(" ");
          monster.inflictDamage(valP_force);
        } else {
          return;
        }
        //valP_force = int(force_sensor[1]);
        
        
        /*
          Light Sensor reading
        */  
        String[] light_sensor = readSensorValues(p, "b", "Light sensor in String:");
        print("light sensor String length: ");
        println(light_sensor.length);
        if (light_sensor.length == 3){
        
          valP_light = int(light_sensor[1]);
    
          print("light sensor in int:");
          print(valP_light);
          println(" "); 
          
        } else {
        return;
        } //exit this function if light sensor packet is broken
        

        
      } else {
        return; //exit if inBuffer is null.
      }
      
      /*
        servo motor reading
      */

      background(50);
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

// Based on the current_level, it runs a specific 
void switchLevel() {
  switch (current_level) {
    case INTRO: {
      //radar.update();
      myCamera.update();

      spider.update(valP_light*2); //how big is the spider?
      drawStoryTextBox("Make the spider move to shine the wall...");
      if (valP_light > LIGHT_THRESHOLD) current_level = LEVEL_ONE; 
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
