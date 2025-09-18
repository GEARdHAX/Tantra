import React, { useState } from 'react';
import { zones } from '../../data/mockData';
import { BellIcon, CheckIcon, DropletIcon, ThermometerIcon, AlertCircleIcon } from 'lucide-react';

const AlertList = ({ zoneId }) => {
  const [alerts, setAlerts] = useState(() => {
    if (zoneId) {
      const zone = zones.find(z => z.id === zoneId);
      return zone ? [...zone.alerts] : [];
    } else {
      // Flatten all alerts from all zones and add zone name
      return zones.flatMap(zone => 
        zone.alerts.map(alert => ({ ...alert, zoneName: zone.name, zoneId: zone.id }))
      );
    }
  });

  const handleMarkAsRead = (alertId) => {
    setAlerts(alerts.map(alert => 
      alert.id === alertId ? { ...alert, read: true } : alert
    ));
  };

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleString();
  };

  const getAlertTypeIcon = (type) => {
    switch (type) {
      case 'moisture':
        return <div className="bg-blue-100 p-2 rounded-full"><DropletIcon size={16} className="text-blue-500" /></div>;
      case 'temperature':
        return <div className="bg-orange-100 p-2 rounded-full"><ThermometerIcon size={16} className="text-orange-500" /></div>;
      default:
        return <div className="bg-gray-100 p-2 rounded-full"><AlertCircleIcon size={16} className="text-gray-500" /></div>;
    }
  };

  if (alerts.length === 0) {
    return (
      <div className="bg-white rounded-lg shadow-md p-6 text-center">
        <BellIcon size={24} className="text-green-500 mx-auto mb-2" />
        <p className="text-gray-500">No alerts at this time</p>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <div className="px-6 py-4 bg-green-900 text-white">
        <h2 className="text-lg font-semibold">
          {zoneId ? 'Zone Alerts' : 'All Alerts'}
        </h2>
      </div>
      <ul className="divide-y divide-gray-200">
        {alerts.map((alert) => (
          <li key={alert.id} className={`p-4 ${!alert.read ? 'bg-yellow-50' : ''}`}>
            <div className="flex items-start">
              <div className="flex-shrink-0 mr-3">
                {getAlertTypeIcon(alert.type)}
              </div>
              <div className="flex-1">
                {!zoneId && (
                  <div className="text-sm font-medium text-green-600 mb-1">
                    {alert.zoneName}
                  </div>
                )}
                <div className="text-sm font-medium text-gray-900 mb-1">
                  {alert.message}
                </div>
                <div className="text-xs text-gray-500">
                  {formatDate(alert.timestamp)}
                </div>
              </div>
              {!alert.read && (
                <button 
                  className="ml-2 bg-green-100 text-green-700 p-1 rounded-full hover:bg-green-200"
                  onClick={() => handleMarkAsRead(alert.id)}
                  title="Mark as read"
                >
                  <CheckIcon size={16} />
                </button>
              )}
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default AlertList;