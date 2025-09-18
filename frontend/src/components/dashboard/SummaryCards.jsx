import React from 'react';
import { DropletIcon, ThermometerIcon, BellIcon } from 'lucide-react';
import { zones } from '../../data/mockData';

const SummaryCards = () => {
  // Calculate average moisture and temperature
  const avgMoisture = zones.reduce((sum, zone) => sum + zone.moisture, 0) / zones.length;
  const avgTemperature = zones.reduce((sum, zone) => sum + zone.temperature, 0) / zones.length;
  
  // Count total alerts
  const totalAlerts = zones.reduce((sum, zone) => sum + zone.alerts.length, 0);
  
  // Count zones by status
  const zoneStatuses = zones.reduce((acc, zone) => {
    acc[zone.status] = (acc[zone.status] || 0) + 1;
    return acc;
  }, {});

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div className="bg-white rounded-lg shadow-md p-6 border-l-4 border-blue-500">
        <div className="flex items-center">
          <div className="bg-blue-100 p-3 rounded-full">
            <DropletIcon size={24} className="text-blue-500" />
          </div>
          <div className="ml-4">
            <h3 className="text-sm font-medium text-gray-500">Average Moisture</h3>
            <p className="text-2xl font-semibold text-gray-900">{avgMoisture.toFixed(1)}%</p>
          </div>
        </div>
        <div className="mt-4">
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div 
              className="bg-blue-500 h-2 rounded-full" 
              style={{ width: `${avgMoisture}%` }}
            ></div>
          </div>
        </div>
      </div>
      
      <div className="bg-white rounded-lg shadow-md p-6 border-l-4 border-orange-500">
        <div className="flex items-center">
          <div className="bg-orange-100 p-3 rounded-full">
            <ThermometerIcon size={24} className="text-orange-500" />
          </div>
          <div className="ml-4">
            <h3 className="text-sm font-medium text-gray-500">Average Temperature</h3>
            <p className="text-2xl font-semibold text-gray-900">{avgTemperature.toFixed(1)}°C</p>
          </div>
        </div>
        <div className="mt-4">
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div 
              className="bg-orange-500 h-2 rounded-full" 
              style={{ width: `${(avgTemperature / 50) * 100}%` }}
            ></div>
          </div>
        </div>
      </div>
      
      <div className="bg-white rounded-lg shadow-md p-6 border-l-4 border-red-500">
        <div className="flex items-center">
          <div className="bg-red-100 p-3 rounded-full">
            <BellIcon size={24} className="text-red-500" />
          </div>
          <div className="ml-4">
            <h3 className="text-sm font-medium text-gray-500">Active Alerts</h3>
            <p className="text-2xl font-semibold text-gray-900">{totalAlerts}</p>
          </div>
        </div>
        <div className="mt-4 flex items-center justify-between text-sm">
          <span className="text-green-500">Normal: {zoneStatuses.normal || 0}</span>
          <span className="text-yellow-500">Warning: {zoneStatuses.warning || 0}</span>
          <span className="text-red-500">Critical: {zoneStatuses.critical || 0}</span>
        </div>
      </div>
    </div>
  );
};

export default SummaryCards;