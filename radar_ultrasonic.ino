#include <Servo.h>

const int trigPin = 9;
const int echoPin = 10;
Servo myServo;

void setup() {
  Serial.begin(9600);
  myServo.attach(11);  // Servo control pin
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  // Sweep from 0° to 180°
  for (int angle = 0; angle <= 180; angle++) {
    myServo.write(angle);
    delay(15);
    int distance = measureDistance();
    sendData(angle, distance);
    delay(10);
  }

  // Sweep back from 180° to 0°
  for (int angle = 180; angle >= 0; angle--) {
    myServo.write(angle);
    delay(15);
    int distance = measureDistance();
    sendData(angle, distance);
    delay(10);
  }
}

int measureDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000);  // timeout after 30 ms
  int distance = duration * 0.034 / 2;

  if (distance <= 0 || distance > 200) {
    distance = 200; // out of range capped
  }

  return distance;
}

void sendData(int angle, int distance) {
  Serial.print(angle);
  Serial.print(",");
  Serial.print(distance);
  Serial.println(".");
}
