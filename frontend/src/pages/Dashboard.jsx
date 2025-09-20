import React, { useState, useEffect, useRef } from 'react';
import { 
  DropletIcon, ThermometerIcon, BellIcon, PowerIcon, SprayCanIcon,
  BugIcon, Barrel, AlertTriangleIcon, CheckCircleIcon, Clock, MapPinIcon
} from 'lucide-react';
import { useAppContext } from '../hooks/useAppContext';
import TestVoiceButton from '../components/dashboard/TestVoiceButton';
import LanguageSelector from '../components/dashboard/LanguageSelector';

// 🚨🚨🚨 <------------------- THIS BLOCK IS AI-GENERATED i.e. WEBSOCKETS etc etc... ------------------------>

// --- MOCK DATA for additional UI elements ---
const mockZonesData = [
  { id: 'zone2', name: 'Zone 2 (Mock)', moisture: 0, temperature: 0, pestRisk: 'low', alerts: [{timestamp: new Date().toISOString(), message: "Low battery detected in sensor."}] },
  { id: 'zone3', name: 'Zone 3 (Mock)', moisture: 0, temperature: 0, pestRisk: 'low', alerts: [] },
];

const Dashboard = () => {
  const { appState } = useAppContext();
  const ws = useRef(null);
  
  // --- REAL-TIME STATE MANAGEMENT ---
  const [zones, setZones] = useState([]); // This will hold Zone 1 from the WebSocket
  const [tankLevel, setTankLevel] = useState(0);
  const [networkStatus, setNetworkStatus] = useState('Connecting...');
  const [lastUpdate, setLastUpdate] = useState(null);
  const [relayStates, setRelayStates] = useState({ mainTank: true }); // State for all relays
  const [generatedPower, setGeneratedPower] = useState(0);
  
  // --- WEBSOCKET CONNECTION & DATA HANDLING ---
  useEffect(() => {
    const WEBSOCKET_URL = 'ws://10.209.239.219:8080';
    ws.current = new WebSocket(WEBSOCKET_URL);
    
    ws.current.onopen = () => {
      console.log("✅ WebSocket connection established.");
      setNetworkStatus('Online');
      ws.current.send(JSON.stringify({ type: "identify", client: "ui" }));
    };
    
    ws.current.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        console.log("📩 Data received:", data);
        
        if (data.zones) {
          setZones(data.zones); // Updates Zone 1 with live data
          
          if (data.zones.length > 0 && data.zones[0].flowRate !== undefined) {
            const flowRateLPM = data.zones[0].flowRate;
            const head = 3, efficiency = 0.7, gravity = 9.81, density = 1000;
            const flowRateCMS = flowRateLPM / 60000;
            const powerInWatts = density * gravity * flowRateCMS * head * efficiency;
            setGeneratedPower(powerInWatts);
          }
        }
        if (data.tankLevel !== undefined) {
          setTankLevel(data.tankLevel);
        }
        setLastUpdate(new Date());
      } catch (err) {
        console.error("❌ Failed to parse message:", err);
      }
    };
    
    ws.current.onclose = () => { setNetworkStatus('Offline'); console.log("❌ WebSocket disconnected."); };
    ws.current.onerror = (error) => { setNetworkStatus('Error'); console.error('❌ WebSocket error:', error); };
    return () => { if (ws.current) ws.current.close(); };
  }, []);
  
  // --- COMMAND FUNCTIONS ---
  const sendCommand = (commandPayload) => {
    if (ws.current && ws.current.readyState === WebSocket.OPEN) {
      ws.current.send(JSON.stringify(commandPayload));
      console.log("📤 Sent command:", commandPayload);
    } else {
      console.error("❌ Cannot send command: WebSocket is not open.");
    }
  };
  
  const handleRelayToggle = (zoneId) => {
    const newRelayState = !relayStates[zoneId];
    setRelayStates(prev => ({ ...prev, [zoneId]: newRelayState }));
    sendCommand({
      type: 'control', target: 'relay', zoneId: zoneId,
      state: newRelayState ? 'ON' : 'OFF'
    });
  };
  
  // --- DERIVED DATA & HELPERS ---
  const displayZones = [...zones, ...mockZonesData]; // Combine real and mock zones for rendering
  const avgMoisture = zones.length > 0 ? zones.reduce((sum, zone) => sum + (zone.moisture || 0), 0) / zones.length : 0;
  const avgTemp = zones.length > 0 ? zones.reduce((sum, zone) => sum + (zone.temperature || 0), 0) / zones.length : 0;
  const criticalPestZones = displayZones.filter(zone => zone.pestRisk === 'high').length;
  
  const getStatusColor = (zone) => {
    if (!zone || (zone.id.toString().includes('Mock') && zone.moisture === 0 && zone.temperature === 0)) return 'bg-gray-400';
    if ((zone.moisture || 0) < 30 || (zone.temperature || 0) > 35 || zone.pestRisk === 'high') return 'bg-red-500';
    if ((zone.moisture || 0) < 50 || (zone.temperature || 0) > 30 || zone.pestRisk === 'medium') return 'bg-yellow-500';
    return 'bg-green-500';
  };
  const formatTime = (timestamp) => {
    if (!timestamp) return 'Never';
    try {
      return new Date(timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    } catch (error) {
      return 'Invalid time';
    }
  };
  const getMoistureStatus = (moisture) => (moisture > 60 ? 'Optimal' : moisture > 40 ? 'Low' : 'Critical');
  const getTempStatus = (temp) => (temp < 30 ? 'Normal' : temp < 35 ? 'High' : 'Critical');
  const getTankStatus = (level) => (level > 60 ? 'Full' : level > 30 ? 'Medium' : 'Low');
  
  // 🚨🚨🚨 <------------------- THIS BLOCK IS AI-GENERATED i.e. WEBSOCKETS etc etc... ------------------------>
  
  // 🚨🚨🚨 <-------------- JSX HERE IS WRITTEN BY ADARSH ARYA ----------------->
  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Header section */}
      <div className="mb-8 flex justify-between items-center">
        <div><h1 className="text-3xl font-bold text-gray-900">Smart Farm Dashboard</h1><p className="mt-1 text-gray-600">Real-time monitoring and control system</p></div>
        <div className="flex items-center space-x-4"><LanguageSelector /> <TestVoiceButton /></div>
      </div>

      {/* Summary metrics cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div className="bg-white rounded-lg shadow-md p-6 border-l-4 border-blue-500">
          <div className="flex items-center justify-between">
            <div><div className="flex items-center"><DropletIcon size={24} className="text-blue-500 mr-2" /><h3 className="text-sm font-medium text-gray-500">Avg Moisture</h3></div><p className="text-2xl font-bold text-gray-900 mt-2">{avgMoisture.toFixed(1)}%</p></div>
            <div className="text-right"><span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${avgMoisture > 60 ? 'bg-green-100 text-green-800' : avgMoisture > 40 ? 'bg-yellow-100 text-yellow-800' : 'bg-red-100 text-red-800'}`}>{getMoistureStatus(avgMoisture)}</span></div>
          </div>
        </div>
        <div className="bg-white rounded-lg shadow-md p-6 border-l-4 border-orange-500">
          <div className="flex items-center justify-between">
            <div><div className="flex items-center"><ThermometerIcon size={24} className="text-orange-500 mr-2" /><h3 className="text-sm font-medium text-gray-500">Avg Temperature</h3></div><p className="text-2xl font-bold text-gray-900 mt-2">{avgTemp.toFixed(1)}°C</p></div>
            <div className="text-right"><span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${avgTemp < 30 ? 'bg-green-100 text-green-800' : avgTemp < 35 ? 'bg-yellow-100 text-yellow-800' : 'bg-red-100 text-red-800'}`}>{getTempStatus(avgTemp)}</span></div>
          </div>
        </div>
        <div className="bg-white rounded-lg shadow-md p-6 border-l-4 border-cyan-500">
          <div className="flex items-center justify-between">
            <div><div className="flex items-center"><Barrel size={24} className="text-cyan-500 mr-2" /><h3 className="text-sm font-medium text-gray-500">Tank Level</h3></div><p className="text-2xl font-bold text-gray-900 mt-2">{tankLevel}%</p></div>
            <div className="text-right"><span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${tankLevel > 60 ? 'bg-green-100 text-green-800' : tankLevel > 30 ? 'bg-yellow-100 text-yellow-800' : 'bg-red-100 text-red-800'}`}>{getTankStatus(tankLevel)}</span></div>
          </div>
        </div>
        <div className="bg-white rounded-lg shadow-md p-6 border-l-4 border-red-500">
          <div className="flex items-center justify-between">
            <div><div className="flex items-center"><BugIcon size={24} className="text-red-500 mr-2" /><h3 className="text-sm font-medium text-gray-500">Pest Alerts</h3></div><p className="text-2xl font-bold text-gray-900 mt-2">{criticalPestZones}</p></div>
            <div className="text-right"><span className="text-xs text-gray-500">Zones affected</span></div>
          </div>
        </div>
      </div>

      {/* Main dashboard grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2 space-y-6">
          {/* Zone monitoring cards */}
          <div className="bg-white rounded-lg shadow-md overflow-hidden">
            <div className="px-6 py-4 bg-green-900 text-white"><h2 className="text-lg font-semibold">Zone Status & Controls</h2></div>
            <div className="p-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {displayZones.map((zone) => (
                  <div key={zone.id} className="border rounded-lg p-4 hover:shadow-md transition-shadow">
                    <div className="flex items-center justify-between mb-3">
                      <div className="flex items-center">
                        <div className={`w-3 h-3 rounded-full mr-3 ${getStatusColor(zone)}`}></div>
                        <h3 className="font-semibold text-gray-900">{zone.name}</h3>
                        {(zone.id === 1 || zone.id === "zone1") && (<span className="ml-3 text-xs font-mono bg-yellow-200 text-yellow-800 px-2 py-0.5 rounded-full">⚡ {generatedPower.toFixed(1)} W</span>)}
                      </div>
                      <button className="text-blue-600 hover:text-blue-800 text-sm"><MapPinIcon size={16} className="inline mr-1" />GPS</button>
                    </div>
                    <div className="grid grid-cols-2 gap-2 mb-3 text-sm">
                      <div className="flex items-center"><DropletIcon size={14} className="text-blue-500 mr-1" /><span>{zone.moisture?.toFixed(1) || '0'}%</span></div>
                      <div className="flex items-center"><ThermometerIcon size={14} className="text-orange-500 mr-1" /><span>{zone.temperature?.toFixed(1) || '0'}°C</span></div>
                      <div className="flex items-center"><BugIcon size={14} className="text-red-500 mr-1" /><span className="capitalize">{zone.pestRisk || 'low'}</span></div>
                      <div className="flex items-center"><BellIcon size={14} className="text-gray-500 mr-1" /><span>{zone.alerts?.length || 0} alerts</span></div>
                    </div>
                    <div className="flex space-x-2">
                      <button onClick={() => handleRelayToggle(zone.id)} className={`flex-1 flex items-center justify-center px-3 py-2 text-xs font-medium rounded-md transition-colors ${relayStates[zone.id] ? 'bg-blue-600 text-white hover:bg-blue-700' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'}`}><PowerIcon size={14} className="mr-1" /> RELAY {relayStates[zone.id] ? 'ON' : 'OFF'}</button>
                      <button className="flex-1 flex items-center justify-center px-3 py-2 text-xs font-medium rounded-md bg-gray-200 text-gray-400 cursor-not-allowed"><SprayCanIcon size={14} className="mr-1" /> SPRAYER</button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Recent alerts section */}
          <div className="bg-white rounded-lg shadow-md overflow-hidden">
            <div className="px-6 py-4 bg-green-900 text-white"><h2 className="text-lg font-semibold">Latest Alerts</h2></div>
            <div className="divide-y divide-gray-200">
              {displayZones.flatMap(zone => zone.alerts.map(alert => ({...alert, zoneName: zone.name}))).slice(0, 5).map((alert, idx) => (
                <div key={idx} className="p-4 hover:bg-gray-50">
                  <div className="flex items-start">
                    <div className="flex-shrink-0"><AlertTriangleIcon size={16} className="text-red-500 mt-1" /></div>
                    <div className="ml-3 flex-1">
                      <div className="flex items-center justify-between"><p className="text-sm font-medium text-gray-900">{alert.zoneName}</p><span className="text-xs text-gray-500"><Clock size={12} className="inline mr-1" />{formatTime(alert.timestamp)}</span></div>
                      <p className="text-sm text-gray-600 mt-1">{alert.message}</p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Right sidebar */}
        <div className="space-y-6">
          <div className="bg-white rounded-lg shadow-md overflow-hidden">
            <div className="px-6 py-4 bg-green-900 text-white"><h2 className="text-lg font-semibold">System Controls</h2></div>
            <div className="p-6 space-y-4">
              <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div className="flex items-center"><Barrel size={20} className="text-cyan-500 mr-3" /><div><p className="font-medium text-gray-900">Main Tank Relay</p><p className="text-sm text-gray-500">Water supply system</p></div></div>
                <button onClick={() => handleRelayToggle('mainTank')} className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${relayStates.mainTank ? 'bg-blue-600' : 'bg-gray-300'}`}><span className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${relayStates.mainTank ? 'translate-x-6' : 'translate-x-1'}`} /></button>
              </div>
              <button className="w-full bg-red-600 text-white px-4 py-3 rounded-lg hover:bg-red-700 font-medium">Emergency Stop All</button>
              <button className="w-full bg-purple-600 text-white px-4 py-3 rounded-lg hover:bg-purple-700 font-medium">Enable Auto Mode</button>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md overflow-hidden">
            <div className="px-6 py-4 bg-green-900 text-white"><h2 className="text-lg font-semibold">System Status</h2></div>
            <div className="p-6 space-y-4">
              <div className="flex items-center justify-between"><span className="text-sm text-gray-600">Network Status</span><span className={`flex items-center font-semibold ${networkStatus === 'Online' ? 'text-green-600' : 'text-red-600'}`}><CheckCircleIcon size={16} className="mr-1" /> {networkStatus}</span></div>
              <div className="flex items-center justify-between"><span className="text-sm text-gray-600">Last Sensor Update</span><span className="text-sm text-gray-900 font-mono">{formatTime(lastUpdate)}</span></div>
              <div className="flex items-center justify-between"><span className="text-sm text-gray-600">Active Relays</span><span className="text-sm text-gray-900 font-bold">{Object.values(relayStates).filter(Boolean).length}</span></div>
              <div className="flex items-center justify-between"><span className="text-sm text-gray-600">Active Sprayers</span><span className="text-sm text-gray-900 font-bold">0</span></div>
              <div className="flex items-center justify-between"><span className="text-sm text-gray-600">Battery Level</span><span className="text-sm text-gray-900 font-bold">-- %</span></div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md overflow-hidden">
            <div className="px-6 py-4 bg-green-900 text-white"><h2 className="text-lg font-semibold">Quick Zone Access</h2></div>
            <div className="p-6 space-y-2">
              {displayZones.map((zone) => (<button key={zone.id} className="w-full flex items-center justify-between p-3 text-left hover:bg-gray-50 rounded-lg border"><div className="flex items-center"><div className={`w-2 h-2 rounded-full mr-3 ${getStatusColor(zone)}`}></div><span className="font-medium">{zone.name}</span></div><span className="text-sm text-gray-500">{zone.alerts?.length > 0 ? `${zone.alerts.length} alerts` : 'Normal'}</span></button>))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
// <-------------- JSX HERE IS WRITTEN BY ADARSH ARYA ----------------->