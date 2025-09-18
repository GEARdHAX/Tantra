# **Tantra: Arduino Firmware**

This directory contains all the necessary firmware for the Tantra smart farming system's hardware controllers.

* **Arduino Mega 2560:** The sensor and control hub.  
* **ESP8266:** The dedicated Wi-Fi and WebSocket gateway.


### **1. Integrated Firmware**

These two sketches work together to form the complete system. They should be used for the final deployment.

* ATMega2560_Sensor_Hub.ino: The primary sketch for the **Arduino Mega**. It reads all sensors (soil, temp/humidity, flow, tank level), controls the gate relay based on the water level, and sends a compiled data string to the ESP8266 via serial communication.  
* ESP8266_WebSocket_Gateway.ino (Assumed): The sketch for the **ESP8266**. It listens for the data string from the Mega, parses it, constructs a JSON object, and sends it to the backend server over Wi-Fi.

## **Hardware & Wiring**

This section details the physical connections required for the integrated firmware to function correctly.

### **Sensors & Relay <-> Arduino Mega**

 Component -> Arduino Mega Pin
 Soil Moisture (Analog) -> A0 
 BME280 SDA -> 20 (SDA) 
 BME280 SCL -> 21 (SCL) 
 HC-SR04 Trig -> 7 
 HC-SR04 Echo -> 6 
 Flow Sensor Signal -> 2 (Interrupt) 
 Relay IN -> 8 

## **2. Deployment using DIP Switches**
Step 1: Upload to Arduino Mega
Set DIP switches:
ON: 3, 4
OFF: All others
Connect the Arduino Mega via USB.
Select Arduino Mega or Mega 2560 board and the correct COM Port.
Upload the ATMega2560_Sensor_Hub.ino sketch.
Disconnect the USB.

Step 2: Upload to ESP8266
Set DIP switches:
ON: 5, 6, 7
OFF: All others
Connect the ESP8266 via USB.
Select NodeMCU 1.0 (or your board) and the correct COM Port.
Upload the ESP8266_WebSocket_Gateway.ino sketch.
Keep the USB connected.

Step 3: Connect to Wi-Fi
Set DIP switches:
ON: 5, 6
OFF: All others (especially 7)
Press the physical RESET button on the ESP8266 board. The ESP will now connect to your Wi-Fi network.

Step 4: Run the System & Send Data
Set DIP switches:
ON: 2, 5, 6
OFF: All others

The Arduino Mega will send sensor data to the ESP8266, which will forward it as JSON to your WebSocket server.

## **. Deployment using DIP Switches**
1. **Install Arduino IDE:** Ensure you have the latest version from the [official website](https://www.arduino.cc/en/software).  
2. **Install Board Managers:**  
   * In the IDE, go to Tools \> Board \> Boards Manager... and install Arduino AVR Boards.  
   * Add the ESP8266 board URL in File \> Preferences \> Additional Boards Manager URLs:  
     \[http://arduino.esp8266.com/stable/package\_esp8266com\_index.json\](http://arduino.esp8266.com/stable/package\_esp8266com\_index.json)

   * Install esp8266 from the Boards Manager.  
3. **Install Libraries:**  
   * Go to Sketch \> Include Library \> Manage Libraries....  
   * Install the following libraries:  
     * Adafruit BME280 Library  
     * Adafruit Unified Sensor  
     * WebSockets by Markus Sattler  
4. **Configure Firmware:**  
   * In the ESP8266 sketch, update the following variables with your credentials:  
     const char\* ssid \= "WIFI_SSID";  
     const char\* password \= "WIFI_PASSWORD";  
     const char\* websocket_host = "SERVER_IP_ADDRESS";

   * In the Arduino Mega sketch, calibrate your soil moisture sensor by updating SOIL_DRY_VALUE and SOIL_WET_VALUE.  
5. **Upload Firmware:**  
   * Connect the Arduino Mega, select Arduino Mega or Mega 2560 as the board, choose the correct COM port, and upload the main Mega sketch.  
   * Connect the ESP8266, select NodeMCU 1.0 (ESP-12E Module) (or your specific board), choose the correct COM port, and upload the main ESP8266 sketch.
