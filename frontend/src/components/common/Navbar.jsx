import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { MenuIcon, XIcon } from 'lucide-react';
import LanguageSelector from '../dashboard/LanguageSelector';

const Navbar = () => {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <nav className="bg-green-900 text-white shadow-lg">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          <div className="flex items-center">
            <Link to="/" className="flex-shrink-0 flex items-center">
              <span className="text-xl font-bold">Tantra</span>
            </Link>
          </div>
          <div className="hidden md:flex items-center space-x-4">
            <Link to="/" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-green-800">
              Dashboard
            </Link>
            <Link to="/zones" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-green-800">
              Zones & Alerts
            </Link>
            <Link to="/recommendations" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-green-800">
              Recommendations
            </Link>
            <Link to="/settings" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-green-800">
              Settings & Help
            </Link>
            <div className="ml-4">
              <LanguageSelector />
            </div>
          </div>
          <div className="md:hidden flex items-center">
            <button
              onClick={() => setIsOpen(!isOpen)}
              className="inline-flex items-center justify-center p-2 rounded-md text-white hover:bg-green-800 focus:outline-none"
            >
              {isOpen ? <XIcon size={24} /> : <MenuIcon size={24} />}
            </button>
          </div>
        </div>
      </div>
      {isOpen && (
        <div className="md:hidden">
          <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3">
            <Link 
              to="/" 
              className="block px-3 py-2 rounded-md text-base font-medium hover:bg-green-800"
              onClick={() => setIsOpen(false)}
            >
              Dashboard
            </Link>
            <Link 
              to="/zones" 
              className="block px-3 py-2 rounded-md text-base font-medium hover:bg-green-800"
              onClick={() => setIsOpen(false)}
            >
              Zones & Alerts
            </Link>
            <Link 
              to="/recommendations" 
              className="block px-3 py-2 rounded-md text-base font-medium hover:bg-green-800"
              onClick={() => setIsOpen(false)}
            >
              Recommendations
            </Link>
            <Link 
              to="/settings" 
              className="block px-3 py-2 rounded-md text-base font-medium hover:bg-green-800"
              onClick={() => setIsOpen(false)}
            >
              Settings & Help
            </Link>
            <div className="px-3 py-2">
              <LanguageSelector />
            </div>
          </div>
        </div>
      )}
    </nav>
  );
};

export default Navbar;