const int forceSensorPin = A0; // Assuming force sensor connected to analog pin A0
const int lightPin = A1; //lightPin = pin A1
const int threshold = 10;     // Adjust this threshold value according to your sensor and setup

void setup() {
  Serial.begin(9600);
  pinMode(forceSensorPin, INPUT);
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

  // if (sensorValue > threshold) {
  //   // Send a signal to Processing to play the sound
  //   Serial.println("PLAY_SOUND");
  //   delay(1000); // Delay to prevent rapid triggering
  // }


  // Serial.print("Light Sensor Value: ");
  // Serial.println(lightVal);

  // if (lightVal > 250){

  //   Serial.println("LIGHT_UP");
  // }


}
