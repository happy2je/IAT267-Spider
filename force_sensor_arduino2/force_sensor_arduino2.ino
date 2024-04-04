const int forceSensorPin = A0; // Assuming force sensor connected to analog pin A0
const int lightPin = A1; //lightPin = pin A1
const int threshold = 10;     // Adjust this threshold value according to your sensor and setup

#include <Servo.h>

String readString;
Servo myServo;

//for ultrasonic
const int trigPin = 13;
const int echoPin = 12;
long duration;
int distance;


void setup() {
  Serial.begin(9600);
  pinMode(forceSensorPin, INPUT);

  myServo.attach(11);
  myServo.writeMicroseconds(1500); //set initial servo position if desired
  //myservo.attach(11, 500, 2500);  //the pin for the servo control, and range if desired

	pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin, INPUT); // Sets the echoPin as an Input


}

void loop() {
  int forceValue = analogRead(forceSensorPin);
  int lightValue = analogRead(lightPin);
  lightValue = lightValue/4;
  
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


  Serial.print("&"); //denotes the end from the sensors
  delay(100); //wait 100ms for next reading 


//'c' packet starts (servo)
  for(int i=10;i<=170;i++){  
    myServo.write(i);
    delay(30);
    distance = calculateDistance();// Calls a function for calculating the distance  by the Ultrasonic sensor for each degree
    // Serial.print("c");
    Serial.print(i); // Sends the current degree into the Serial Port
    Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
    Serial.print(distance); // Sends the distance value into the Serial Port
    Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
  }
   // Going back
  for(int i=170;i>10;i--){  
    myServo.write(i);
    delay(30);
    distance = calculateDistance();
    // Serial.print("c");
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
  //'c' packet ends

}

int calculateDistance(){ 
  
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH); // Reads the echoPin, returns the sound wave travel time in microseconds
  distance= duration*0.034/2;
  return distance;
}

