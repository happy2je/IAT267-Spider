const int forceSensorPin = A0; // Assuming force sensor connected to analog pin A0
const int lightPin = A1; //lightPin = pin A1
const int threshold = 10;     // Adjust this threshold value according to your sensor and setup

#include <Servo.h>

String readString;
Servo servo;

//servo
const int SERVO_PIN = 11;
int servoPos = 0;


//for ultrasonic
// Ultrasonic sensor
const int TRIG_PIN = 9;
const int ECHO_PIN = 10;
const int OPEN_TIME = 10000;

long duration;
int distance;


void setup() {
  Serial.begin(9600);
  pinMode(forceSensorPin, INPUT);
  servo.attach(SERVO_PIN);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

// Set servo to starting position
  servo.write(0);
  delay(20);


}

void loop() {
  int forceValue = analogRead(forceSensorPin);
  int lightValue = analogRead(lightPin);
  lightValue = lightValue/4;

    // Clears the TRIG_PIN
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);

  
  // Serial.print("Force Sensor Value: ");
  Serial.print("a"); //character 'a' will delimit the reading from the force sensor
  Serial.print(forceValue);
  Serial.print("a");
  Serial.println();
  //'a' packet - force sensor ends

  //'b' packet starts
  Serial.print("b");
  Serial.print(lightValue);
  Serial.print("b");
  Serial.println();
  //'b' packet ends


  Serial.print("c");
// Sets the TRIG_PIN on HIGH state for 10 micro seconds
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  // Reads the ECHO_PIN, returns the sound wave travel time in microseconds
  duration = pulseIn(ECHO_PIN, HIGH);

  // Calculate and print distance in cm
  distance = duration * 0.034 / 2;
  Serial.print(distance);


  Serial.print("c");
  Serial.println();

  Serial.print("d");
    String message = Serial.readStringUntil('\n');
    if (message.equals("trigger_servo")) {
    // Trigger servo to 180 degrees if it's within distance range and back to 0 after x seconds
//  if (distance <= 10 && distance >= 0) {
    servo.write(90);
    //println("Servo triggered at distance: ");
    // println(distance);
    delay(OPEN_TIME);
    servo.write(0);
    delay(20);
  }
  Serial.print("d");
  Serial.println();

  Serial.print("&"); //denotes the end from the sensors
  delay(100); //wait 100ms for next reading 





}

