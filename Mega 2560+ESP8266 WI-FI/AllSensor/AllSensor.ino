#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>

// <----------- HANDWRITTEN CODE & PINS SELECTION, VALUES BY SHASHWAT SATYA aka No-Reed--------------->
#define SOIL_PIN A0
#define FLOW_SENSOR_PIN 2
#define TRIG_PIN 7
#define ECHO_PIN 6
#define RELAY_PIN 8

const int SOIL_DRY_VALUE = 537;
const int SOIL_WET_VALUE = 300;
const float TANK_HEIGHT_CM = 20.0;

Adafruit_BME280 bme;
float temperature, humidity;

// Flow Rate Sensor
volatile int pulseCount = 0;
float flowRate = 0.0;
unsigned long oldTime = 0;

long duration;
float distance;
int tankLevelPercent = 0;

unsigned long lastReadTime = 0;
const long readInterval = 2000;

void pulseCounter()
{
  pulseCount++;
}

void setup()
{
  Serial.begin(9600);

  // Initialize BME280
  if (!bme.begin(0x76))
  {
    Serial.println("DEBUG >> Could not find a valid BME280 sensor, check wiring!");
    while (1)
      ;
  }

  pinMode(FLOW_SENSOR_PIN, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN), pulseCounter, RISING);

  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  pinMode(RELAY_PIN, OUTPUT);

  digitalWrite(RELAY_PIN, HIGH);

  oldTime = millis();
}
// <----------- HANDWRITTEN CODE & PINS SELECTION, VALUES BY SHASHWAT SATYA aka No-Reed--------------->


// <-------------- FROM HERE ONWARDS, ITS AI-GENERATED ------------>
void loop()
{
  
  if (millis() - lastReadTime >= readInterval)
  {
    lastReadTime = millis();
    
    int soilRaw = analogRead(SOIL_PIN);
    int soilPercent = map(soilRaw, SOIL_DRY_VALUE, SOIL_WET_VALUE, 10, 100);
    soilPercent = constrain(soilPercent, 10, 100);
    
    temperature = bme.readTemperature();
    humidity = bme.readHumidity();
    
    digitalWrite(TRIG_PIN, LOW);
    delayMicroseconds(2);
    digitalWrite(TRIG_PIN, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG_PIN, LOW);
    duration = pulseIn(ECHO_PIN, HIGH);
    distance = duration * 0.034 / 2;
    float waterLevel = TANK_HEIGHT_CM - distance;
    if (waterLevel < 0)
    waterLevel = 0;
    if (waterLevel > TANK_HEIGHT_CM)
    waterLevel = TANK_HEIGHT_CM;
    tankLevelPercent = (int)((waterLevel / TANK_HEIGHT_CM) * 100);
    
    detachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN));
    flowRate = ((1000.0 / (millis() - oldTime)) * pulseCount) / 7.5;
    oldTime = millis();
    pulseCount = 0;
    attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN), pulseCounter, RISING);
    
    if (tankLevelPercent < 30)
    {
      
      digitalWrite(RELAY_PIN, HIGH);
    }
    else
    {
      
      digitalWrite(RELAY_PIN, LOW);
    }
    
    String dataString = "DATA:" + String(soilPercent) + "," +
    String(temperature) + "," +
    String(humidity) + "," +
    String(flowRate) + "," +
    String(tankLevelPercent);
    Serial.println(dataString);
    
    String debugString = "DEBUG >> Moisture: " + String(soilPercent) + "% | " +
    "Temp: " + String(temperature) + "C | " +
    "Humidity: " + String(humidity) + "% | " +
    "Flow: " + String(flowRate) + " L/min | " +
    "Tank: " + String(tankLevelPercent) + "% | " +
    "Relay: " + (digitalRead(RELAY_PIN) == LOW ? "ON" : "OFF");
    Serial.println(debugString);
  }
}
// <-------------- FROM HERE ONWARDS, ITS AI-GENERATED ------------>
