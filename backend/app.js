const WebSocket = require("ws");
const wss = new WebSocket.Server({ port: 8080 });

// Track all connected clients 
let reactClients = new Set();

wss.on("connection", function connection(ws) {
    console.log("✅ New connection established");

    // Add this client to our tracking set
    reactClients.add(ws);

    // Send connection confirmation to React
    ws.send(JSON.stringify({
        status: "connected",
        timestamp: new Date().toISOString()
    }));

    ws.on("message", function incoming(message) {
        try {
            const data = JSON.parse(message);
            console.log(data);

            // 🚀 BROADCAST to ALL connected React clients
            reactClients.forEach(client => {
                if (client !== ws && client.readyState === WebSocket.OPEN) {
                    client.send(JSON.stringify(data));
                    console.log("📤 Forwarded to React client");
                }
            });

        } catch (e) {
            console.error("❌ Invalid JSON:", message.toString());
        }
    });

    // Clean up disconnected clients
    ws.on('close', () => {
        console.log("❌ Connection closed");
        reactClients.delete(ws);
    });

    ws.on('error', (error) => {
        console.error('❌ WebSocket error:', error);
        reactClients.delete(ws);
    });
});

console.log("🚀 WebSocket server running on port 8080");
console.log("📡 Ready to receive ESP8266 data and forward to React clients");

