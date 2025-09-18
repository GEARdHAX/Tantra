## 📂 Flutter App Structure

- **lib/**
  - **l10n/** → Handles app localization & internationalization  
    - `app_en.arb` → English translations  
    - `app_hi.arb` → Hindi translations  
    - `app_ne.arb` → Nepali translations  
    - `app_localizations.dart` → Base localization setup  
    - `app_localizations_en.dart` → English localization logic  
    - `app_localizations_hi.dart` → Hindi localization logic  
    - `app_localizations_ne.dart` → Nepali localization logic  

  - **pages/** → Contains all app screens (UI pages)  
    - `dashboard.dart` → Main dashboard UI  
    - `energy.dart` → Energy monitoring page  
    - `fertilizerPage.dart` → Fertilizer insights page  
    - `help_page.dart` → Help & support page  
    - `inspectPage.dart` → General inspection screen  
    - `inspectPage_mobile.dart` → Mobile-specific inspection view  
    - `inspectPage_web.dart` → Web-specific inspection view  
    - `inspectPage_stub.dart` → Stub/fallback inspection page  
    - `irrigation.dart` → Irrigation monitoring & control  
    - `profilePage.dart` → User profile page  
    - `weather.dart` → Weather forecasting & monitoring  

  - **services/** → Contains app services & APIs  
    - `telemetry.dart` → Manages telemetry data (IoT/sensor readings)  

  - `main.dart` → Entry point of the Flutter application

## ✨ Key Features of the Flutter App

- **🌱 Smart Irrigation Dashboard**
  - Displays real-time soil moisture, temperature, humidity, and tank levels.  
  - Provides alerts when soil is too dry, tank is low, or pest risk is detected.  

- **💧 Irrigation Control**
  - Monitor and manage water flow rate.  
  - Automated irrigation trigger when soil moisture is low.  

- **⚡ Energy Monitoring**
  - Tracks renewable power simulation (micro-turbine & battery input).  
  - Displays energy usage in real-time.  

- **🌦 Weather Forecasting**
  - Shows weather predictions to optimize irrigation scheduling.  

- **🧪 Fertilizer Management**
  - Provides fertilizer usage insights.  
  - Helps track crop input efficiency.  

- **📡 Telemetry Services**
  - Handles IoT data from sensors (moisture, flow, turbine, etc.).  
  - Real-time updates pushed to the app dashboard.  

- **👤 User Profile & Settings**
  - Manage user details and preferences.  
  - Customize app language and region.  

- **🌍 Multi-Language Support**
  - Available in English, Hindi, and Nepali (extendable via `.arb` files).  
  - Easy switching between languages.  

- **📱 Cross-Platform UI**
  - Optimized views for **mobile** and **web** using separate inspection pages.  
  - Consistent experience across devices.  

- **🧬 Soil Nutrient Analysis (Advanced Feature)**
  - Analyzes soil content (NPK values, micronutrients, pH levels).  
  - Suggests required nutrients and fertilizers for healthy crop growth.  
  - Shows recommendations of fertilizers available in the market along with sources to buy them.  
  - Personalized insights for different soil zones in the field.
