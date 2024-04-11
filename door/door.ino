#include <Servo.h>

// Servo
Servo servo;
const int SERVO_PIN = 11;
int servoPos = 0;

// Ultrasonic sensor
const int TRIG_PIN = 9;
const int ECHO_PIN = 10;
const int OPEN_TIME = 5000;
long duration;
int distance;

void setup() {
  Serial.begin(750);
  servo.attach(SERVO_PIN);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  // Set servo to starting position
  servo.write(0);
  delay(20);
}

void loop() {
  // Clears the TRIG_PIN
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);

    // Sets the TRIG_PIN on HIGH state for 10 micro seconds
    digitalWrite(TRIG_PIN, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG_PIN, LOW);

    // Reads the ECHO_PIN, returns the sound wave travel time in microseconds
    duration = pulseIn(ECHO_PIN, HIGH);

    // Calculate and print distance in cm
    distance = duration * 0.034 / 2;
    Serial.println(distance);

    // Trigger servo to 180 degrees if it's within distance range and back to 0 after x seconds
    if (distance <= 20 && distance >= 0) {
      servo.write(180);
      Serial.print("Servo triggered at distance: ");
      Serial.println(distance);
      delay(OPEN_TIME);
      servo.write(0);
      delay(20);
    }
}