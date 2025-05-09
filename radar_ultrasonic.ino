#include <Wire.h>
#include "MAX30100_PulseOximeter.h"
#include <LiquidCrystal.h>

#define REPORTING_PERIOD_MS     1000
#define BUZZER_PIN 8

PulseOximeter pox;
uint32_t tsLastReport = 0;

LiquidCrystal lcd(7, 6, 5, 4, 3, 2);

void onBeatDetected() {
  Serial.println("Beat!");
}

void setup() {
  Serial.begin(9600);
  lcd.begin(16, 2);
  lcd.print("Initializing...");

  pinMode(BUZZER_PIN, OUTPUT);
  digitalWrite(BUZZER_PIN, LOW);

  if (!pox.begin()) {
    lcd.clear();
    lcd.print("MAX30100 FAIL");
    while (1);
  }

  pox.setIRLedCurrent(MAX30100_LED_CURR_7_6MA);
  pox.setOnBeatDetectedCallback(onBeatDetected);

  lcd.clear();
  lcd.print("Place finger...");
  delay(2000);
}

void loop() {
  pox.update();

  if (millis() - tsLastReport > REPORTING_PERIOD_MS) {
    tsLastReport = millis();

    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("HR: ");
    lcd.print(pox.getHeartRate(), 0);
    lcd.print(" BPM");

    lcd.setCursor(0, 1);
    lcd.print("SPO2: ");
    lcd.print(pox.getSpO2(), 0);
    lcd.print(" %");

    if (pox.getHeartRate() > 120) {
      digitalWrite(BUZZER_PIN, HIGH);
    } else {
      digitalWrite(BUZZER_PIN, LOW);
    }
  }
}