import React from 'react';
import { Link } from 'react-router-dom';

const Footer = () => {
  return (
    <footer className="bg-green-900 text-white">
      <div className="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div>
            <h3 className="text-lg font-semibold mb-4">FarmTech</h3>
            <p className="text-sm text-gray-300">
              Smart Agriculture Monitoring System designed for farmers in regions like Nepal.
              Monitor your farm zones, get alerts, and recommendations in real-time.
            </p>
          </div>
          <div>
            <h3 className="text-lg font-semibold mb-4">Links</h3>
            <ul className="space-y-2">
              <li>
                <Link to="/" className="text-sm text-gray-300 hover:text-white">
                  Dashboard
                </Link>
              </li>
              <li>
                <Link to="/zones" className="text-sm text-gray-300 hover:text-white">
                  Zones & Alerts
                </Link>
              </li>
              <li>
                <Link to="/recommendations" className="text-sm text-gray-300 hover:text-white">
                  Recommendations
                </Link>
              </li>
              <li>
                <Link to="/settings" className="text-sm text-gray-300 hover:text-white">
                  Settings & Help
                </Link>
              </li>
            </ul>
          </div>
          <div>
            <h3 className="text-lg font-semibold mb-4">Contact</h3>
            <p className="text-sm text-gray-300 mb-2">
              Email: support@farmtech.com
            </p>
            <p className="text-sm text-gray-300">
              Phone: +977-9800000000
            </p>
            <div className="mt-4">
              <button className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-md text-sm font-medium">
                Contact Support
              </button>
            </div>
          </div>
        </div>
        <div className="mt-8 pt-8 border-t border-gray-700">
          <p className="text-sm text-gray-300 text-center">
            &copy; {new Date().getFullYear()} FarmTech. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;