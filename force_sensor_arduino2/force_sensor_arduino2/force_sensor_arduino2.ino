
#include <Servo.h>

// Force sensor
const int forceSensorPin = A0;

// Light sensor
const int lightPin = A1;

// Servomotor for door mechanism
Servo servo;
const int SERVO_PIN = 11;
int servoPos = 0;

// Ultrasonic sensor
const int TRIG_PIN = 9;
const int ECHO_PIN = 10;
const int OPEN_TIME = 10000; // 10 seconds
long duration;
int distance;

void setup() {
  // Set data rate to 9600 bps
  Serial.begin(9600);

  // Force sensor setup
  pinMode(forceSensorPin, INPUT);
  
  // Servomotor setup
  servo.attach(SERVO_PIN);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  // Set servo to starting position of 0 degrees
  servo.write(0);
  delay(20);
}

void loop() {
  // Read force sensor and light sensor values
  int forceValue = analogRead(forceSensorPin);
  int lightValue = analogRead(lightPin);
  lightValue /= 4; // Scale light sensor value down from 0-1023 to 0-255

  // Clear the TRIG_PIN of the ultrasonic sensor
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);

  // Send values to Serial for processing

  // 'a' packet - force sensor value
  Serial.print("a"); // Character 'a' will delimit the reading from the force sensor
  Serial.print(forceValue);
  Serial.print("a");
  Serial.println();

  // 'b' packet starts - light sensor value
  Serial.print("b");
  Serial.print(lightValue);
  Serial.print("b");
  Serial.println();

  /* Get ultrasonic sensor distance */ 

  // Sets the TRIG_PIN on HIGH state for 10 micro seconds
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  // Reads the ECHO_PIN and returns the sound wave travel time in microseconds
  duration = pulseIn(ECHO_PIN, HIGH);

  // Calculate the distance in cm
  distance = duration * 0.034 / 2;

  // 'c' packet - ultrasonic sensor value
  Serial.print("c");
  Serial.print(distance);
  Serial.print("c");
  Serial.println();

  // Trigger servo to 70 degrees if it's within distance range and back to 0 after 10 seconds
  String message = Serial.readStringUntil('\n');
  if (message.equals("trigger_servo")) {
    servo.write(70);
    delay(OPEN_TIME);
    servo.write(0);
  }

  // End point for packets being sent
  Serial.print("&");
  delay(100);
}
