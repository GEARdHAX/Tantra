# 📖 Overview

This project demonstrates a smart irrigation system that automates watering based on real-time soil conditions. It uses IoT hardware with ESP8266 for connectivity, a relay-driven solenoid valve for water control, and renewable energy simulation via a micro turbine.

A Flutter-powered web and mobile dashboard provides live monitoring and control features for soil moisture, humidity, water flow, and tank levels.

🛠 Hardware Setup
Components Used

Arduino (with onboard ESP8266 Wi-Fi) – microcontroller + Wi-Fi

Relay Module (5V) – controls water valve

12V Solenoid Valve – water flow control

Capacitive Soil Moisture Sensor – soil condition sensing

Water Flow Sensor (YF-S201) – measures flow rate

Micro Turbine (DC generator) – simulates renewable energy

12V Rechargeable Battery – power supply

Flyback Diode (1N4007) – protects relay circuit

Laptop USB – programming + power

Wiring & Connections

Arduino → Relay, Moisture Sensor, Flow Sensor

Relay Module

IN → D5

COM → Battery +

NO → Solenoid Valve +

Solenoid Valve

+12V → Relay NO

GND → Battery –

Moisture Sensor

AO → A0

Flow Sensor

Signal → D2

⚙️ Working Principle

Soil moisture sensor continuously monitors soil conditions.

If soil is dry → Relay activates → Solenoid valve opens → Irrigation starts.

Flow sensor tracks the water flow in real time.

ESP8266 sends live data to a local web server via Wi-Fi.

Micro turbine + battery simulate renewable energy powering the system.

💻 Software
Arduino/ESP8266 Features

Reads soil moisture level

Reads water flow rate

Controls solenoid valve automatically

Hosts a local web server

Streams real-time sensor data

Libraries Used

ESP8266WiFi.h

ESP8266WebServer.h

📱Website & App

The Flutter app and dashboard act as the user interface for the system:

Features

🌧 Weather-Aware Irrigation

Automatically pauses irrigation if rain is detected

Shows current weather condition (sunny, rainy, stormy)

📊 Real-Time Monitoring

Displays soil moisture, humidity, temperature, tank level, pest risk, and alerts

Live charts for growth trends

Mulity Lingual Support

best niutrients for the sepecific field

💧 Tank Visualization

Animated water tank showing live water level percentage

🚜 Field Overview

Manage multiple fields (Wheat, Corn, Empty field, etc.)

Irrigation status and pesticide tracking

🔔 Alerts & Notifications

Warnings for low moisture, abnormal flow, or pest risk

⚡ Energy Source Tracking

Displays whether system is powered by solar or turbine (renewable simulation)

🌍 Cross-Platform

Works on Web, Android, iOS
