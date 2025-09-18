import React, { useState, useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import ZoneList from '../components/zones/ZoneList';
import ZoneDetails from '../components/zones/ZoneDetails';
import AlertList from '../components/zones/AlertList';

const ZonesAndAlerts = () => {
  const [selectedZoneId, setSelectedZoneId] = useState(null);
  const location = useLocation();

  useEffect(() => {
    // Check if there's a zone ID in the URL query parameters
    const params = new URLSearchParams(location.search);
    const zoneId = params.get('id');
    if (zoneId) {
      setSelectedZoneId(Number(zoneId));
    }
  }, [location]);

  const handleSelectZone = (zoneId) => {
    setSelectedZoneId(zoneId);
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Zones & Alerts</h1>
        <p className="mt-1 text-gray-600">
          Monitor your farm zones and receive alerts
        </p>
      </div>
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div>
          <ZoneList onSelectZone={handleSelectZone} selectedZoneId={selectedZoneId} />
        </div>
        <div className="lg:col-span-2 space-y-8">
          <ZoneDetails zoneId={selectedZoneId} />
          <AlertList zoneId={selectedZoneId} />
        </div>
      </div>
    </div>
  );
};

export default ZonesAndAlerts;