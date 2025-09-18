import React, { useState } from 'react';
import { ChevronDownIcon } from 'lucide-react';
import { languages } from '../../data/mockData';
import { useAppContext } from '../../hooks/useAppContext';

const LanguageSelector = () => {
  const { appState, updateAppState } = useAppContext();
  const [isOpen, setIsOpen] = useState(false);

  const handleLanguageChange = (languageCode) => {
    updateAppState('preferredLanguage', languageCode);
    setIsOpen(false);
  };

  const getLanguageName = (code) => {
    const language = languages.find(lang => lang.code === code);
    return language ? language.name : 'English';
  };

  return (
    <div className="relative">
      <button 
        className="flex items-center text-sm px-3 py-1 rounded-md bg-green-700 hover:bg-green-600 focus:outline-none"
        onClick={() => setIsOpen(!isOpen)}
      >
        <span>{getLanguageName(appState.preferredLanguage)}</span>
        <ChevronDownIcon size={16} className="ml-1" />
      </button>
      {isOpen && (
        <div className="absolute right-0 mt-2 w-36 bg-white rounded-md shadow-lg z-10">
          <ul className="py-1">
            {languages.map(language => (
              <li key={language.code}>
                <button
                  className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                  onClick={() => handleLanguageChange(language.code)}
                >
                  {language.name}
                </button>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};

export default LanguageSelector;