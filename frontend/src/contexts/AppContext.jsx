import React, { createContext, useState } from 'react';

export const AppContext = createContext();

export const AppProvider = ({ children }) => {
  const [appState, setAppState] = useState({
    preferredLanguage: 'en',
    alertSettings: {
      moistureThreshold: 35,
      temperatureThreshold: 32,
      enableVoiceAlerts: true,
      alertFrequency: 'immediate'
    }
  });

  const updateAppState = (key, value) => {
    setAppState(prev => ({
      ...prev,
      [key]: value
    }));
  };

  return (
    <AppContext.Provider value={{ appState, updateAppState }}>
      {children}
    </AppContext.Provider>
  );
};

export default AppProvider;