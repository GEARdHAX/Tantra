import React from 'react';
import { useAppContext } from '../hooks/useAppContext';
import { languages } from '../data/mockData';

// Language Settings Component (inline)
const LanguageSettings = () => {
  const { appState, updateAppState } = useAppContext();

  const handleLanguageChange = (e) => {
    const newLanguage = e.target.value;
    updateAppState('preferredLanguage', newLanguage);
  };

  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <div className="px-6 py-4 bg-green-900 text-white">
        <h2 className="text-lg font-semibold">Language Settings</h2>
      </div>
      <div className="p-6">
        <div className="mb-4">
          <label htmlFor="language" className="block text-sm font-medium text-gray-700 mb-2">
            Select Language
          </label>
          <select
            id="language"
            value={appState.preferredLanguage}
            onChange={handleLanguageChange}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
          >
            {languages.map((language) => (
              <option key={language.code} value={language.code}>
                {language.name}
              </option>
            ))}
          </select>
          <p className="mt-2 text-sm text-gray-500">
            This will change the language for voice alerts and text throughout the application.
          </p>
        </div>
      </div>
    </div>
  );
};

// Alert Settings Component (inline)
const AlertSettings = () => {
  const { appState, updateAppState } = useAppContext();

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    const newValue = type === 'checkbox' ? checked : (type === 'number' ? Number(value) : value);
    
    updateAppState('alertSettings', {
      ...appState.alertSettings,
      [name]: newValue
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    alert('Alert settings saved successfully!');
  };

  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <div className="px-6 py-4 bg-green-900 text-white">
        <h2 className="text-lg font-semibold">Alert Settings</h2>
      </div>
      <div className="p-6">
        <form onSubmit={handleSubmit}>
          <div className="mb-4">
            <label htmlFor="moistureThreshold" className="block text-sm font-medium text-gray-700 mb-2">
              Low Moisture Threshold (%)
            </label>
            <input
              type="range"
              id="moistureThreshold"
              name="moistureThreshold"
              min="20"
              max="70"
              value={appState.alertSettings.moistureThreshold}
              onChange={handleChange}
              className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
            />
            <div className="flex justify-between mt-1">
              <span className="text-xs text-gray-500">20%</span>
              <span className="text-xs font-medium text-green-600">{appState.alertSettings.moistureThreshold}%</span>
              <span className="text-xs text-gray-500">70%</span>
            </div>
          </div>
          <div className="mb-4">
            <label htmlFor="temperatureThreshold" className="block text-sm font-medium text-gray-700 mb-2">
              High Temperature Threshold (°C)
            </label>
            <input
              type="range"
              id="temperatureThreshold"
              name="temperatureThreshold"
              min="25"
              max="40"
              value={appState.alertSettings.temperatureThreshold}
              onChange={handleChange}
              className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
            />
            <div className="flex justify-between mt-1">
              <span className="text-xs text-gray-500">25°C</span>
              <span className="text-xs font-medium text-green-600">{appState.alertSettings.temperatureThreshold}°C</span>
              <span className="text-xs text-gray-500">40°C</span>
            </div>
          </div>
          <div className="mb-4">
            <div className="flex items-center">
              <input
                type="checkbox"
                id="enableVoiceAlerts"
                name="enableVoiceAlerts"
                checked={appState.alertSettings.enableVoiceAlerts}
                onChange={handleChange}
                className="h-4 w-4 text-green-600 focus:ring-green-500 border-gray-300 rounded"
              />
              <label htmlFor="enableVoiceAlerts" className="ml-2 block text-sm font-medium text-gray-700">
                Enable Voice Alerts
              </label>
            </div>
          </div>
          <div className="mb-6">
            <label htmlFor="alertFrequency" className="block text-sm font-medium text-gray-700 mb-2">
              Alert Frequency
            </label>
            <select
              id="alertFrequency"
              name="alertFrequency"
              value={appState.alertSettings.alertFrequency}
              onChange={handleChange}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
            >
              <option value="immediate">Immediate</option>
              <option value="hourly">Hourly Summary</option>
              <option value="daily">Daily Summary</option>
            </select>
          </div>
          <div className="flex justify-end">
            <button
              type="submit"
              className="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 focus:outline-none"
            >
              Save Settings
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

const SettingsAndHelp = () => {
  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Settings & Help</h1>
        <p className="mt-1 text-gray-600">
          Configure your preferences and get assistance
        </p>
      </div>
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div className="space-y-8">
          <LanguageSettings />
          <AlertSettings />
        </div>
        <div className="space-y-8">
          <div className="bg-white rounded-lg shadow-md overflow-hidden">
            <div className="px-6 py-4 bg-green-900 text-white">
              <h2 className="text-lg font-semibold">Help & FAQ</h2>
            </div>
            <div className="p-6">
              <div className="space-y-4">
                <div>
                  <h3 className="font-medium text-gray-900">How do I set up a new zone?</h3>
                  <p className="text-sm text-gray-600 mt-1">Currently, zones must be set up by an administrator. Please contact support to add a new monitoring zone to your account.</p>
                </div>
                <div>
                  <h3 className="font-medium text-gray-900">How do voice alerts work?</h3>
                  <p className="text-sm text-gray-600 mt-1">Voice alerts use your device's text-to-speech capability to notify you of important events. Make sure your volume is turned up and you've given permission for the website to play audio.</p>
                </div>
                <div>
                  <h3 className="font-medium text-gray-900">Can I use the system offline?</h3>
                  <p className="text-sm text-gray-600 mt-1">Basic functionality works offline. However, you'll need an internet connection for real-time sensor updates and weather information.</p>
                </div>
                <div>
                  <h3 className="font-medium text-gray-900">How accurate are the sensor readings?</h3>
                  <p className="text-sm text-gray-600 mt-1">Our sensors have an accuracy of ±2% for moisture readings and ±0.5°C for temperature readings. Regular calibration is recommended for optimal performance.</p>
                </div>
              </div>
              <div className="border-t border-gray-200 pt-6 mt-6">
                <h3 className="text-lg font-medium text-gray-900 mb-2">Contact Support</h3>
                <div className="space-y-2">
                  <p className="text-sm">
                    <span className="font-medium">Email:</span> support@farmtech.com
                  </p>
                  <p className="text-sm">
                    <span className="font-medium">Phone:</span> +977-9800000000
                  </p>
                  <p className="text-sm">
                    <span className="font-medium">Hours:</span> Monday-Friday, 9am-5pm NPT
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SettingsAndHelp;