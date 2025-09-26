import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { AppProvider } from './contexts/AppContext';

// Import Layout Components
import Navbar from './components/common/Navbar';
import Footer from './components/common/Footer';
import QRDownloadFloat from './components/common/QRDownloadFloat'; // <-- Import the QR component

// Import Page Components
import Dashboard from './pages/Dashboard';
import ZonesAndAlerts from './pages/ZonesAndAlerts';
import RecommendationsAndReports from './pages/RecommendationsAndReports';
import SettingsAndHelp from './pages/SettingsAndHelp';

function App() {
  return (
    <AppProvider>
      <Router>
        <div className="flex flex-col min-h-screen bg-gray-50">
          <Navbar />
          <main className="flex-grow">
            <Routes>
              <Route path="/" element={<Dashboard />} />
              <Route path="/zones" element={<ZonesAndAlerts />} />
              <Route path="/recommendations" element={<RecommendationsAndReports />} />
              <Route path="/settings" element={<SettingsAndHelp />} />
              {/* You can add more routes here, like for a 404 page */}
            </Routes>
          </main>
          {/* <Footer /> */}
          
          {/* QR Download button will now float over all pages */}
          <QRDownloadFloat /> 
        </div>
      </Router>
    </AppProvider>
  );
}

export default App;