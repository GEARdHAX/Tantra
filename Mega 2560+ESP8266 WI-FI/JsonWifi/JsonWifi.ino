
#include <ESP8266WiFi.h>
#include <WebSocketsClient.h>

// <---------- HANDWRITTEN BY ADARSH ARYA-------------->
// WE'RE SETTING UP WIFI COMMUNICATION AND USING WEBSOCKET FOR RTC
const char *ssid = "No_Reed";
const char *password = "NR@850490";
const char *websocket_host = "10.209.239.219";
const int websocket_port = 8080;
const char *websocket_path = "/";

WebSocketsClient webSocket;
String serialBuffer = "";

void webSocketEvent(WStype_t type, uint8_t *payload, size_t length)
{
  switch (type)
  {
  case WStype_CONNECTED:
    Serial.printf("[WSc] Connected to url: %s\n", payload);
    break;
  case WStype_DISCONNECTED:
    Serial.println("[WSc] Disconnected!");
    break;
  case WStype_TEXT:
    Serial.printf("[WSc] Received message: %s\n", payload);
    break;
  }
}

// CONVERTING DATA TO STRING
String getValueFromString(String data, char separator, int index)
{
  int found = 0;
  int strIndex[] = {0, -1};
  int maxIndex = data.length() - 1;
  for (int i = 0; i <= maxIndex && found <= index; i++)
  {
    if (data.charAt(i) == separator || i == maxIndex)
    {
      found++;
      strIndex[0] = strIndex[1] + 1;
      strIndex[1] = (i == maxIndex) ? i + 1 : i;
    }
  }
  return found > index ? data.substring(strIndex[0], strIndex[1]) : "";
}

void setup()
{
  Serial.begin(9600);
  delay(1000);
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\n✅ Wi-Fi connected!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
  webSocket.begin(websocket_host, websocket_port, websocket_path);
  webSocket.onEvent(webSocketEvent);
  webSocket.setReconnectInterval(5000);
}

// <---------- HANDWRITTEN BY ADARSH ARYA-------------->


// FROM HERE, LOOP PART IS AI-GENERATED
void loop()
{
  webSocket.loop();
  if (Serial.available())
  {
    char c = Serial.read();
    if (c == '\n')
    {
      if (serialBuffer.startsWith("DATA:"))
      {
        String sensorValues = serialBuffer.substring(5);
        
        String moistureStr = getValueFromString(sensorValues, ',', 0);
        String tempStr = getValueFromString(sensorValues, ',', 1);
        String humidityStr = getValueFromString(sensorValues, ',', 2);
        String flowRateStr = getValueFromString(sensorValues, ',', 3);
        String tankLevelStr = getValueFromString(sensorValues, ',', 4);
        
        String json = "{";
        json += "\"zones\":[{\"id\":1,\"name\":\"Zone 1\",\"moisture\":";
        json += moistureStr;
        json += ",\"temperature\":";
        json += tempStr;
        json += ",\"humidity\":";
        json += humidityStr;
        json += ",\"flowRate\":";
        json += flowRateStr;
        json += ",\"pestRisk\":\"medium\",\"alerts\":[]}],";
        json += "\"tankLevel\":";
        json += tankLevelStr;
        json += "}";
        
        Serial.println("📤 Sending JSON: " + json);
        webSocket.sendTXT(json);
      }
      serialBuffer = "";
    }
    else if (c != '\r')
    {
      serialBuffer += c;
    }
  }
}
// HERE, LOOP PART IS AI-GENERATED