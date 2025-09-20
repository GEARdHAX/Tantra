import React from 'react';
import { zones } from '../../data/mockData';


// <--------------- HANDWRITTEN BY ADARSH ARYA ----------------->

const ZoneList = ({ onSelectZone, selectedZoneId }) => {
  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <div className="px-6 py-4 bg-green-900 text-white">
        <h2 className="text-lg font-semibold">Farm Zones</h2>
      </div>
      <ul className="divide-y divide-gray-200">
        {zones.map((zone) => (
          <li 
            key={zone.id} 
            className={`p-4 hover:bg-gray-50 cursor-pointer ${selectedZoneId === zone.id ? 'bg-green-50' : ''}`}
            onClick={() => onSelectZone(zone.id)}
          >
            <div className="flex justify-between items-center">
              <div className="flex items-center">
                <div className={`w-3 h-3 rounded-full ${zone.status === 'normal' ? 'bg-green-500' : zone.status === 'warning' ? 'bg-yellow-500' : 'bg-red-500'} mr-3`}></div>
                <span className="font-medium text-gray-900">{zone.name}</span>
              </div>
              <span className="text-sm text-gray-500">{zone.alerts.length} alerts</span>
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default ZoneList;