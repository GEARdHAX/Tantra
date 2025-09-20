import React from 'react';
import { DropletIcon, ThermometerIcon, MapPinIcon, ClockIcon, MapIcon, VolumeIcon } from 'lucide-react';
import { zones } from '../../data/mockData';
import { useAppContext } from '../../hooks/useAppContext';
import { speakText } from '../../utils/voiceUtils';


// <-----------HANDWRITTEN BY ADARSH ARYA------------>


const ZoneDetails = ({ zoneId }) => {
  const zone = zones.find(z => z.id === zoneId);
  const { appState } = useAppContext();

  if (!zone) {
    return (
      <div className="bg-white rounded-lg shadow-md p-6">
        <p className="text-gray-500">Select a zone to view details</p>
      </div>
    );
  }

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleString();
  };
// <---------------- GETTING STATUS OF ALERTS ---------------->
  const getStatusBadge = (status) => {
    switch (status) {
      case 'normal':
        return <span className="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">Normal</span>;
      case 'warning':
        return <span className="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs">Warning</span>;
      case 'critical':
        return <span className="px-2 py-1 bg-red-100 text-red-800 rounded-full text-xs">Critical</span>;
      default:
        return <span className="px-2 py-1 bg-gray-100 text-gray-800 rounded-full text-xs">Unknown</span>;
    }
  };

  const handlePlayAlert = () => {
    if (zone.alerts.length > 0) {
      const languageMap = {
        'en': 'en-US',
        'ne': 'ne-NP',
        'hi': 'hi-IN'
      };
      const speechLanguage = languageMap[appState.preferredLanguage] || 'en-US';
      speakText(zone.alerts[0].message, speechLanguage);
    }
  };
//  <------------ SIMPLE GOOGLE MAPS API USING QUERIES---------------->
  const openGoogleMaps = () => {
    const url = `https://www.google.com/maps?q=${zone.location.lat},${zone.location.lng}`;
    window.open(url, '_blank');
  };

  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <div className="px-6 py-4 bg-green-900 text-white flex justify-between items-center">
        <h2 className="text-lg font-semibold">{zone.name}</h2>
        {getStatusBadge(zone.status)}
      </div>
      <div className="p-6">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
          <div className="bg-blue-50 p-4 rounded-lg">
            <div className="flex items-center mb-2">
              <DropletIcon size={20} className="text-blue-500 mr-2" />
              <h3 className="font-medium">Soil Moisture</h3>
            </div>
            <div className="text-3xl font-bold text-blue-700">{zone.moisture}%</div>
            <div className="w-full bg-gray-200 rounded-full h-2 mt-2">
              <div 
                className={`h-2 rounded-full ${
                  zone.moisture > 60 ? 'bg-green-500' : 
                  zone.moisture > 40 ? 'bg-yellow-500' : 
                  'bg-red-500'
                }`}
                style={{ width: `${zone.moisture}%` }}
              ></div>
            </div>
          </div>
          <div className="bg-orange-50 p-4 rounded-lg">
            <div className="flex items-center mb-2">
              <ThermometerIcon size={20} className="text-orange-500 mr-2" />
              <h3 className="font-medium">Temperature</h3>
            </div>
            <div className="text-3xl font-bold text-orange-700">{zone.temperature}°C</div>
            <div className="w-full bg-gray-200 rounded-full h-2 mt-2">
              <div 
                className={`h-2 rounded-full ${
                  zone.temperature < 25 ? 'bg-blue-500' : 
                  zone.temperature < 30 ? 'bg-green-500' : 
                  zone.temperature < 35 ? 'bg-yellow-500' : 
                  'bg-red-500'
                }`}
                style={{ width: `${(zone.temperature / 50) * 100}%` }}
              ></div>
            </div>
          </div>
        </div>
        <div className="mb-6">
          <div className="flex items-center mb-2">
            <ClockIcon size={18} className="text-gray-500 mr-2" />
            <span className="text-sm text-gray-500">Last updated: {formatDate(zone.lastUpdated)}</span>
          </div>
          <div className="flex items-center">
            <MapPinIcon size={18} className="text-gray-500 mr-2" />
            <span className="text-sm text-gray-500">
              Location: {zone.location.lat.toFixed(4)}, {zone.location.lng.toFixed(4)}
            </span>
          </div>
        </div>
        <div className="flex space-x-4">
          <button
            className="flex items-center px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none"
            onClick={openGoogleMaps}
          >
            <MapIcon size={18} className="mr-2" />
            View on Map
          </button>
          {zone.alerts.length > 0 && (
            <button
              className="flex items-center px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 focus:outline-none"
              onClick={handlePlayAlert}
            >
              <VolumeIcon size={18} className="mr-2" />
              Play Alert
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default ZoneDetails;