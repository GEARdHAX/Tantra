# Tantra Backend

The **Tantra Backend** is a lightweight **Node.js WebSocket server** that connects the **Arduino Mega + ESP8266 (sensors)** with the **Tantra Frontend (React/Flutter)** in real-time.  

It acts as a **data pipeline**:
- Receives live data from the ESP8266 (soil moisture, turbine readings, etc.)
- Broadcasts sensor data to all connected frontend clients instantly
- Ensures a persistent, low-latency communication channel between IoT devices and the user interface

---

## 📂 Project Structure

```bash
backend/
│
├── src/
│   ├── app.js         # WebSocket server (main file)
├── package.json         # Dependencies and scripts
└── README.md            # This file
````

---

## 🚀 Features

* **WebSocket Server on Port 8080**

  * Handles multiple frontend (React/Flutter) clients at once
* **Client Tracking**

  * Manages active connections using a `Set`
* **Broadcast Mechanism**

  * Any message received is forwarded to all connected clients
* **Connection Lifecycle Handling**

  * Tracks `connection`, `message`, `close`, and `error` events
* **ESP8266 → Backend → Frontend**

  * Designed to forward sensor JSON data to UIs in real time

---

## 🔧 Tech Stack

* **Runtime**: Node.js (>= 16.x recommended)
* **WebSocket Library**: [`ws`](https://www.npmjs.com/package/ws)

---

## ⚡ Getting Started

1. **Clone Repository**

   ```bash
   git clone https://github.com/your-username/tantra.git
   cd tantra/backend
   ```

2. **Install Dependencies**

   ```bash
   npm install
   ```

3. **Run the Server**

   ```bash
   node src/index.js
   ```

4. **Expected Output**

   ```bash
   🚀 WebSocket server running on port 8080
   📡 Ready to receive ESP8266 data and forward to React clients
   ```

---

## 📡 Data Flow

```
[Arduino Mega + ESP8266]
        ↓ (JSON)
  Tantra Backend (Node.js)
        ↓ (WebSocket)
   Tantra Frontend (React / Flutter)
```

---

## 🧩 Example JSON Payload

The ESP8266 or Arduino sends data in JSON format like:

```json
{
  "zones": [
    {
      "id": 1,
      "name": "Zone 1",
      "moisture": 13,
      "temperature": 27.86,
      "humidity": 69.03,
      "flowRate": 0,
      "pestRisk": "medium",
      "alerts": []
    }
  ],
  "tankLevel": 0
}
```

The backend then **forwards this to all connected clients**.

---

## 🖥️ Example Client (React Hook)

```jsx
import { useEffect, useState } from "react";

function SensorListener() {
  const [data, setData] = useState(null);

  useEffect(() => {
    const socket = new WebSocket("ws://localhost:8080");

    socket.onmessage = (event) => {
      const parsed = JSON.parse(event.data);
      setData(parsed);
    };

    return () => socket.close();
  }, []);

  return (
    <div>
      {data ? (
        <p>{data.sensor}: {data.value} {data.unit}</p>
      ) : (
        <p>Waiting for sensor data...</p>
      )}
    </div>
  );
}
```

---

## 📜 Future Enhancements

* Add **REST API routes** for historical sensor data
* Implement **authentication** for secured connections
* Integrate with **databases** (MongoDB / PostgreSQL) for storing logs
* Support **MQTT** alongside WebSockets for flexibility

---

## 📄 License

This backend is part of the **Tantra Project** and is licensed under the **MIT License**.

---

## 🙌 Credits

Built with ❤️ to bridge **IoT hardware and frontend applications** for **sustainable farming & renewable energy**.

