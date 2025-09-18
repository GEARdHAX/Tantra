import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'energy.dart';

class LatLon {
  final double latitude;
  final double longitude;

  LatLon({required this.latitude, required this.longitude});
}

class WeatherData {
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String condition;
  final String icon;

  WeatherData({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      condition: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}

Future<WeatherData?> fetchWeather(LatLon latLon) async {
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  String url =
      'https://api.openweathermap.org/data/2.5/forecast?lat=${latLon.latitude}&lon=${latLon.longitude}&appid=$apiKey&units=metric';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final firstForecast = data['list'][0]; // nearest forecast
    return WeatherData.fromJson(firstForecast);
  } else {
    print('Failed to fetch weather: ${response.statusCode}');
    return null;
  }
}

Future<LatLon?> getUserLatLon() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return null;
  }

  if (permission == LocationPermission.deniedForever) return null;

  Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
  return LatLon(latitude: position.latitude, longitude: position.longitude);
}

class WeatherWidget extends StatefulWidget {
  final Function(String)? onWeatherChange; // callback to parent

  const WeatherWidget({super.key, this.onWeatherChange});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  WeatherData? weatherData;
  bool isLoading = true;

  // Energy production values
  double solarProduction = 0;
  double turbineProduction = 0;
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadWeather();
    _determineEnergyProduction("Sunny");
  }

  void loadWeather() async {
    LatLon? userLocation = await getUserLatLon();
    if (userLocation != null) {
      WeatherData? data = await fetchWeather(userLocation);
      setState(() {
        weatherData = data;
        isLoading = false;
      });

      // 🔥 notify parent (HomePage) about weather condition
      if (data != null && widget.onWeatherChange != null) {
        widget.onWeatherChange!(data.condition.toLowerCase());
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
  void _determineEnergyProduction(String condition) {
    final cond = condition.toLowerCase();
    if (cond.contains("storm") || cond.contains("rain")) {
      // bad for solar, good for turbine
      solarProduction = 10; // minimal
      turbineProduction = 120; // full
      status = "Turbine Active";
    } else {
      // good for solar
      solarProduction = 20;
      turbineProduction = 120; // minimal
      status = "Solar Active";
    }
    setState(() {});
  }

  String _getBackgroundImage(String condition) {
    if (condition.toLowerCase().contains("storm")) {
      return "assets/stormy.jpg";
    } else if (condition.toLowerCase().contains("rain")) {
      return "assets/rainy.jpg";
    } else {
      return "assets/normal.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.transparent,
      body: Stack(
        children: [
          /// 🎨 Background painter
          Stack(
            children: [
              /// 🎨 Background (sky/ground)
              Positioned.fill(
                child: CustomPaint(
                  painter: LandscapePainter(),
                ),
              ),

              /// 🌬 Turbines (background layer, painted above landscape)
              Positioned.fill(
                child: Stack(
                  children: const [
                    Positioned(
                      left: 200,
                      bottom: 220,
                      child: SizedBox(
                        width: 200,
                        height: 300,
                        child: WindTurbine(height: 180, x: 100, y: 250),
                      ),
                    ),
                    Positioned(
                      left: 130,
                      bottom: 200,
                      child: SizedBox(
                        width: 200,
                        height: 300,
                        child: WindTurbine(height: 150, x: 100, y: 250),
                      ),
                    ),
                    Positioned(
                      left: 270,
                      bottom: 250,
                      child: SizedBox(
                        width: 200,
                        height: 300,
                        child: WindTurbine(height: 200, x: 100, y: 250),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const AutoScrollCards(),
                  SizedBox(height:20),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Energy Production",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: status == "Turbine Active"
                                      ? Colors.blueGrey
                                      : Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        // Solar Energy
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.yellow.shade50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.wb_sunny, color: Colors.orange, size: 28),
                                  const SizedBox(width: 12),
                                  const Text("Solar Energy",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16)),
                                  const Spacer(),
                                  Text(
                                    "${solarProduction.toStringAsFixed(1)} Wh",
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: solarProduction / 150, // max solar = 150
                                color: Colors.orange,
                                backgroundColor: Colors.orange.shade100,
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                        ),

                        // Water Turbine
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.lightBlue.shade50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.water, color: Colors.blue, size: 28),
                                  const SizedBox(width: 12),
                                  const Text("Water Turbine",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16)),
                                  const Spacer(),
                                  Text(
                                    "${turbineProduction.toStringAsFixed(1)} Wh",
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: turbineProduction / 120, // max turbine = 120
                                color: Colors.blue,
                                backgroundColor: Colors.blue.shade100,
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )

              /// 👉 You can add more Positioned cards here if needed
            ],
          ),

          /// 📜 Foreground scroll sheet
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : weatherData != null
              ? DraggableScrollableSheet(
            initialChildSize: 0.32,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// 🌤 Weather card
                      Center(
                        child: Container(
                          width: 320,
                          height: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(
                                _getBackgroundImage(weatherData!.condition),
                              ),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              color: Colors.black.withOpacity(0.3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    "https://openweathermap.org/img/wn/${weatherData!.icon}@2x.png",
                                    width: 80,
                                    height: 80,
                                  ),
                                  Text(
                                    "${weatherData!.temp.toStringAsFixed(1)}°C",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    weatherData!.condition.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Feels like: ${weatherData!.feelsLike.toStringAsFixed(1)}°C",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Humidity: ${weatherData!.humidity}%",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Wind Speed: ${weatherData!.windSpeed} m/s",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🌱 Field cards
                      _buildFieldCard("Zone 2", "Last Irrigation: 2h ago", "In Progress", "Irrigation: 25 mm", Colors.red),
                      const SizedBox(height: 10),
                      _buildFieldCard("Zone 3", "Last Irrigation: 10h ago", "Done", "Irrigation: 20 mm", Colors.orange),
                      const SizedBox(height: 10),
                      _buildFieldCard("Zone 5", "Last Irrigation: 8h ago", "Done", "Irrigation: 28 mm", Colors.blue),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          )
              : const Center(
            child: Text(
              'Unable to get weather',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right:20.0, left:10),
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(2, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldCard(String veld, String crop, String name, String moisture, Color moistureColor) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(veld, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(crop, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: moistureColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  moisture,
                  style: TextStyle(color: moistureColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class AutoScrollCards extends StatefulWidget {
  const AutoScrollCards({super.key});

  @override
  State<AutoScrollCards> createState() => _AutoScrollCardsState();
}

class _AutoScrollCardsState extends State<AutoScrollCards> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // ⏳ Auto scroll every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView(
        controller: _pageController,
        children: [
          _buildDashboardCard("⚡ Energy Saving through Solar Panels", "50%", Colors.green),
          _buildDashboardCard("⚡ Energy saving through water turbine"," 100W ", Colors.blue),
        ],
      ),
    );
  }

  /// 🔹 Reusable card
  Widget _buildDashboardCard(String title, String value, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(2, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
