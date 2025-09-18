# Tantra Frontend

The **Tantra Frontend** is the web interface of the Tantra project.  
It is built using **React (JSX)** to provide real-time monitoring, visualization, and control for smart farming and renewable energy systems.

This frontend communicates with the **backend (Node.js + WebSocket)**, which collects live data from **Arduino Mega 2560 + ESP8266** boards connected to sensors like soil moisture, INA219 (turbine monitoring), and other IoT devices.

---

## 🌱 About Tantra

**Tantra** is an initiative that combines **IoT + Renewable Energy + Smart Farming** into one ecosystem.  
It aims to empower farmers with **real-time insights, automated monitoring, and efficient resource usage** through technology.

---

## 📂 Project Structure (Frontend Only)

```bash
frontend/
│
├── public/               # Static assets (favicon, index.html, manifest, etc.)
├── src/
│   ├── components/       # Reusable UI components
│   ├── pages/            # Page-level React components (Dashboard, Monitoring, Alerts)
│   ├── hooks/            # Custom React hooks (e.g., WebSocket connections, sensor data)
│   ├── services/         # API and WebSocket clients
│   ├── utils/            # Helper functions (formatting, thresholds, etc.)
│   ├── App.jsx           # Root React component
│   └── index.js          # Entry point for React DOM rendering
│
├── package.json          # Project metadata & dependencies
└── README.md             # This file
````

---

## 🚀 Features

* **Real-time Sensor Data**

  * Displays live soil moisture, turbine voltage/current, and environmental conditions.
* **WebSocket Integration**

  * Instant updates from the backend without refreshing the page.
* **Visualization**

  * Graphs, charts, and alerts for easy interpretation of sensor data.
* **Zones & Alerts**

  * Configure farm zones and receive warnings for critical thresholds.
* **Responsive UI**

  * Works across desktop, tablet, and mobile devices.
* **Future Ready**

  * Can integrate weather APIs, AI-driven recommendations, and voice alerts.

---

## 🔧 Tech Stack

* **Frontend Framework**: React (JSX)
* **UI Styling**: Tailwind CSS / custom CSS
* **Real-time Communication**: WebSockets
* **Package Manager**: npm or yarn

---

## ⚡ Getting Started

1. **Clone the Repository**

   ```bash
   git clone https://github.com/your-username/Tantra.git
   cd tantra/frontend
   ```

2. **Install Dependencies**

   ```bash
   npm install
   ```

3. **Start Development Server**

   ```bash
   npm run dev
   ```

   The frontend will run on:
   👉 `http://localhost:5173` (if using Vite)
   👉 or `http://localhost:3000` (if using CRA)

4. **Connect to Backend**

   * Ensure the **Tantra Backend** (Node.js + WebSocket server) is running.
   * Update the WebSocket URL in `src/services/websocket.js`.

---

## 📡 Data Flow Overview

```
[Soil Moisture / Turbine Sensors]
            ↓
   Arduino Mega + ESP8266
            ↓
       Tantra Backend
   (Node.js + WebSocket)
            ↓
     Tantra Frontend (React)
```

---

## 🧩 Example WebSocket Client

```jsx
import { useEffect, useState } from "react";

function SensorData() {
  const [data, setData] = useState(null);

  useEffect(() => {
    const socket = new WebSocket("ws://localhost:8080");

    socket.onmessage = (event) => {
      const sensorData = JSON.parse(event.data);
      setData(sensorData);
    };

    return () => socket.close();
  }, []);

  return (
    <div>
      {data ? (
        <p>Soil Moisture: {data.soilMoisture} %</p>
      ) : (
        <p>Waiting for sensor data...</p>
      )}
    </div>
  );
}

export default SensorData;
```

---

## 📜 Future Enhancements

* AI-based irrigation recommendations
* Integration with weather APIs
* Mobile-first redesign
* Offline-first capability with PWA

---

## 📄 License

This project is licensed under the **MIT License**.
Feel free to use, modify, and distribute with attribution.

---

## 🙌 Credits

Developed with ❤️ as part of the **Tantra Initiative**.
Bringing **technology, energy, and agriculture** together for a sustainable future.
