import React, { useState, useEffect, useRef } from 'react';
import { QrCodeIcon, XIcon, DownloadIcon, SmartphoneIcon, LinkIcon, CheckCircleIcon } from 'lucide-react';

// --- Configuration ---
const APK_DOWNLOAD_URL = 'https://github.com/GEARdHAX/Tantra/releases/download/v1.0/tantra.apk';
const APP_NAME = 'Tantra v1.0';

const QRDownloadFloat = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [qrCodeUrl, setQrCodeUrl] = useState('');
  const [isGenerating, setIsGenerating] = useState(false);
  const [statusMessage, setStatusMessage] = useState(null);

  // Generate QR code using the single APK URL
  const generateQRCode = async (url) => {
    setIsGenerating(true);
    try {
      const qrParams = new URLSearchParams({
        size: '250x250', data: url, format: 'png',
        ecc: 'M', margin: '1', qzone: '2',
        bgcolor: 'ffffff', color: '16a34a'
      });
      const apiUrl = `https://api.qrserver.com/v1/create-qr-code/?${qrParams.toString()}`;
      
      return new Promise((resolve) => {
        const img = new Image();
        img.onload = () => { setIsGenerating(false); resolve(apiUrl); };
        img.onerror = () => { setIsGenerating(false); resolve(''); };
        img.src = apiUrl;
      });
    } catch (error) {
      console.error('Error generating QR code:', error);
      setIsGenerating(false);
      return '';
    }
  };

  useEffect(() => {
    if (isOpen) {
      generateQRCode(APK_DOWNLOAD_URL).then(url => setQrCodeUrl(url));
    }
  }, [isOpen]);

  const handleDirectDownload = () => {
    const link = document.createElement('a');
    link.href = APK_DOWNLOAD_URL;
    link.download = APP_NAME + '.apk';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    setStatusMessage('Download started!');
    setTimeout(() => setStatusMessage(null), 3000);
  };

  const downloadQRImage = () => {
    if (!qrCodeUrl) return;
    const link = document.createElement('a');
    link.href = qrCodeUrl;
    link.download = `farmtech-apk-qr.png`;
    link.click();
    
    setStatusMessage('QR code image downloaded!');
    setTimeout(() => setStatusMessage(null), 3000);
  };
  
  const copyDownloadLink = () => {
    navigator.clipboard.writeText(APK_DOWNLOAD_URL);
    setStatusMessage('Download link copied to clipboard!');
    setTimeout(() => setStatusMessage(null), 3000);
  };

  return (
    <>
      {/* Floating Action Button */}
      <div className="fixed bottom-6 right-6 z-50">
        <button
          onClick={() => setIsOpen(true)}
          className="relative bg-green-600 hover:bg-green-700 text-white p-4 rounded-full shadow-lg transition-all duration-300 transform hover:scale-110 focus:outline-none focus:ring-4 focus:ring-green-300"
          aria-label="Download FarmTech App"
        >
          <QrCodeIcon size={24} />
          <div className="absolute inset-0 rounded-full bg-green-600 animate-ping opacity-20"></div>
        </button>
      </div>

      {/* QR Modal with Blur Background */}
      {isOpen && (
        // --- THIS IS THE UPDATED LINE ---
        <div className="fixed inset-0 bg-black bg-opacity-30 flex items-center justify-center z-50 p-4 backdrop-blur-md">
          <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full mx-4 transform transition-all duration-300">
            {/* Modal Header */}
            <div className="relative p-6 pb-4">
              <div className="flex items-center justify-between">
                <div>
                  <h2 className="text-2xl font-bold text-gray-900">Download Tantra App</h2>
                  <p className="text-sm text-gray-600 mt-1">Direct APK Download for Android</p>
                </div>
                <button onClick={() => setIsOpen(false)} className="text-gray-400 hover:text-gray-600 p-2 hover:bg-gray-100 rounded-full">
                  <XIcon size={20} />
                </button>
              </div>
            </div>

            {/* Status Message */}
            {statusMessage && (
              <div className="mx-6 mb-4 p-3 bg-green-50 border border-green-200 rounded-lg flex items-center">
                <CheckCircleIcon size={16} className="text-green-600 mr-2" />
                <span className="text-sm text-green-800">{statusMessage}</span>
              </div>
            )}

            {/* Modal Content */}
            <div className="px-6 pb-6">
              {/* QR Code Display */}
              <div className="text-center mb-6">
                <div className="inline-block p-4 bg-white rounded-xl border-2 border-gray-100 shadow-inner relative">
                  {isGenerating ? (
                    <div className="w-64 h-64 bg-gray-50 flex items-center justify-center rounded-lg">
                      <p className="text-sm text-gray-600">Generating QR Code...</p>
                    </div>
                  ) : qrCodeUrl ? (
                    <img src={qrCodeUrl} alt="QR Code for FarmTech APK download" className="w-64 h-64 mx-auto rounded-lg" />
                  ) : (
                    <div className="w-64 h-64 bg-gray-100 flex items-center justify-center rounded-lg">
                      <p className="text-gray-500">Failed to generate QR code</p>
                    </div>
                  )}
                </div>
                <div className="mt-4">
                  <h3 className="text-lg font-semibold text-gray-900 mb-1">Scan to Download App</h3>
                  <p className="text-sm text-gray-600 leading-relaxed">Point your mobile camera at the QR code to download the APK directly.</p>
                </div>
              </div>

              {/* Action Buttons */}
              <div className="grid grid-cols-2 gap-3 mb-4">
                <button onClick={downloadQRImage} className="flex items-center justify-center px-4 py-3 bg-gray-100 text-gray-700 rounded-xl hover:bg-gray-200 font-medium" disabled={!qrCodeUrl}><DownloadIcon size={16} className="mr-2" /> Save QR</button>
                <button onClick={copyDownloadLink} className="flex items-center justify-center px-4 py-3 bg-blue-100 text-blue-700 rounded-xl hover:bg-blue-200 font-medium"><LinkIcon size={16} className="mr-2" /> Copy Link</button>
              </div>

              {/* Direct Download Button */}
              <button
                onClick={handleDirectDownload}
                className="w-full flex items-center justify-center px-6 py-4 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors font-semibold shadow-lg"
              >
                <DownloadIcon size={20} className="mr-2" /> Direct Download APK
              </button>
            </div>
            
            {/* Modal Footer */}
            <div className="px-6 py-4 bg-gray-50 rounded-b-2xl">
              <div className="flex items-center justify-between text-xs text-gray-500">
                <span>🔒 Secure Download • {APP_NAME}</span>
                <span>Made with 💚 for farmers</span>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default QRDownloadFloat;