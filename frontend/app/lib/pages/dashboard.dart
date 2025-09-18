import 'dart:convert';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:universal_html/html.dart' as html;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../services/telemetry.dart';
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>{
  late WebSocketChannel channel;
  Map<String, dynamic>? soilData;
  int waterLevel = 40;
  StreamSubscription? _wsSubscription;

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse("ws://10.209.239.219:8080"),
    );

    _wsSubscription = channel.stream.listen((message) {
      try {
        final String raw = message is String ? message : utf8.decode(message);

        // Try to salvage JSON substring between the first '{' and last '}'
        final int start = raw.indexOf('{');
        final int end = raw.lastIndexOf('}');
        if (start == -1 || end == -1 || end <= start) {
          debugPrint('WS payload has no JSON object braces: $raw');
          return;
        }

        String jsonStr = raw.substring(start, end + 1);

        // Heuristic cleanups for malformed tokens sometimes observed in payloads
        if (jsonStr.contains('K"') || jsonStr.contains('D"')) {
          jsonStr = jsonStr
              .replaceAll('K"', '"')
              .replaceAll('D"', '"');
        }

        final dynamic decoded = jsonDecode(jsonStr);

        // Accept either { zones: ... } or the zone object itself
        dynamic zones = (decoded is Map<String, dynamic>) ? decoded['zones'] : null;
        dynamic zoneCandidate = zones ?? decoded;

        Map<String, dynamic>? zoneMap;
        if (zoneCandidate is List && zoneCandidate.isNotEmpty) {
          final first = zoneCandidate.first;
          if (first is Map<String, dynamic>) zoneMap = Map<String, dynamic>.from(first);
        } else if (zoneCandidate is Map<String, dynamic>) {
          zoneMap = Map<String, dynamic>.from(zoneCandidate);
        }

        if (zoneMap == null) {
          // No zone payload, but update tank if provided at top-level
          T? _asNum<T extends num>(dynamic v) {
            if (v == null) return null;
            if (v is T) return v;
            if (v is num) return (T == int ? v.toInt() : v.toDouble()) as T;
            if (v is String) {
              final parsed = num.tryParse(v);
              if (parsed != null) return (T == int ? parsed.toInt() : parsed.toDouble()) as T;
            }
            return null;
          }
          final int? topTank = (decoded is Map<String, dynamic>)
              ? _asNum<int>(decoded['tankLevel'] ?? decoded['tank'] ?? decoded['tank_level'])
              : null;
          if (topTank != null && topTank >= 0 && topTank <= 100) {
            if (!mounted) return;
            setState(() {
              waterLevel = topTank;
            });
          }
          return;
        }

        // Normalize alerts to a List<String>
        final dynamic alerts = zoneMap['alerts'];
        List<dynamic> normalizedAlerts;
        if (alerts == null) {
          normalizedAlerts = [];
        } else if (alerts is List) {
          normalizedAlerts = alerts;
        } else if (alerts is Map) {
          normalizedAlerts = alerts.values.toList();
        } else {
          normalizedAlerts = [alerts.toString()];
        }
        zoneMap['alerts'] = normalizedAlerts;

        // Coerce numeric fields to expected types if present
        T? _asNum<T extends num>(dynamic v) {
          if (v == null) return null;
          if (v is T) return v;
          if (v is num) return (T == int ? v.toInt() : v.toDouble()) as T;
          if (v is String) {
            final parsed = num.tryParse(v);
            if (parsed != null) return (T == int ? parsed.toInt() : parsed.toDouble()) as T;
          }
          return null;
        }
        // Accept common aliases for tank level (prefer top-level if present)
        final int? topTank = (decoded is Map<String, dynamic>)
            ? _asNum<int>(decoded['tankLevel'] ?? decoded['tank'] ?? decoded['tank_level'])
            : null;
        final int? tank = _asNum<int>(
          zoneMap['tankLevel'] ?? zoneMap['tank'] ?? zoneMap['tank_level'],
        );
        final double? flowRate = _asNum<double>(
          zoneMap['flowRate'] ?? zoneMap['flow_rate'] ?? zoneMap['flow'],
        );

        // publish telemetry for other pages
        TelemetryService.instance.publish(
          flowRateLpm: flowRate,
          tankLevelPercent: (tank ?? topTank),
        );

        if (!mounted) return;
        setState(() {
          soilData = zoneMap;
          final int? effectiveTank = tank ?? topTank;
          if (effectiveTank != null && effectiveTank >= 0 && effectiveTank <= 100) {
            waterLevel = effectiveTank;
          }
        });
      } catch (e) {
        debugPrint('Failed to parse WS message: $e');
      }
    });

  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    channel.sink.close();
    super.dispose();
  }

  Future<void> listWebCameras() async {
    final devices = await html.window.navigator.mediaDevices!.enumerateDevices();
    for (final d in devices) {
      if (d.kind == 'videoinput') {
        print("Camera: ${d.label} (${d.deviceId})");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // waterLevel bound to WS tankLevel updates
    final fields = [
      {
        "image": "assets/pic1.jpg",
        "title": "Empty field",
        "size": "15 ha",
      },
      {
        "image": "assets/pic3.jpg",
        "title": "Corn field",
        "size": "18 ha",
      },
      {
        "image": "assets/pic1.jpg",
        "title": "Wheat field",
        "size": "22 ha",
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🌧️ Weather Card
          Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        "Watering skipped",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Text("It's raining"),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "RUN ANYWAY",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Image.asset("assets/rain.jpeg", width: 150, height: 150),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),
          SizedBox(
            width:double.infinity,
            child: Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: soilData == null
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🌱 Zone: ${soilData!["name"] ?? "Unknown"}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // 🌊 Moisture Card
                        Expanded(
                          child: SizedBox(
                            height: 100, // 👈 set card height here
                            child: Card(
                              color:Color.fromRGBO(229, 244, 251, 1.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: Center(
                                child: Text(
                                  "Moisture: ${soilData!["moisture"]}%",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12), // spacing between cards

                        // 🌡️ Temperature Card
                        Expanded(
                          child: SizedBox(
                            height: 100, // 👈 set card height here
                            child: Card(
                              color:Color.fromRGBO(251, 249, 229, 1.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: Center(
                                child: Text(
                                  "Temperature: ${soilData!["temperature"]} °C",
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text("Humidity: ${soilData!["humidity"]}%", style:TextStyle(fontSize:18)),
                    Text("Flow Rate: ${soilData!["flowRate"]} L/min", style:TextStyle(fontSize:18)),
                    //Text("Pest Risk: ${soilData!["pestRisk"]}", style:TextStyle(fontSize:18)),
                     //Text("Tank Level: ${waterLevel}%", style:TextStyle(fontSize:18)),

                    const SizedBox(height: 10),
                    if (soilData!["alerts"] != null &&
                        (soilData!["alerts"] as List).isNotEmpty) ...[
                      const Text(
                        "⚠️ Alerts:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...(soilData!["alerts"] as List)
                          .map((alert) => Text("• $alert"))
                          .toList(),
                    ] else
                      const Text("No Alerts"),
                  ],
                ),
              ),
            ),
          ),
          /// 💧 Rainwater Tank with wavy water
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Tank outline
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.grey[200],
                  ),
                ),

                // 🌊 Wavy water fill
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: waterLevel / 100, // fill % based on waterLevel
                    widthFactor: 1.0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: WaveWidget(
                        config: CustomConfig(
                          gradients: [
                            [Colors.lightBlueAccent, Colors.blueAccent],
                            [Colors.blueAccent.withOpacity(0.7), Colors.lightBlueAccent],
                          ],
                          durations: [10000, 8000],
                          heightPercentages: [0.20, 0.23],
                          gradientBegin: Alignment.bottomLeft,
                          gradientEnd: Alignment.topRight,
                        ),
                        size: const Size(double.infinity, double.infinity),
                        waveAmplitude: 25, // wave height
                      ),
                    ),
                  ),
                ),

                // Big number + label
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$waterLevel",
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Rainwater Tank",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),


              ],
            ),
          ),
      SizedBox(height:20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  final field = fields[index];
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🖼 Image
                          Expanded(
                            child: Image.asset(
                              field["image"]!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          // 📄 Field info
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  field["title"]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  field["size"]!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ➡️ Arrow button
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_forward, size: 26),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height:20),
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Growth rate",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Row(
                    children: const [
                      Text("W  M  Y",
                          style: TextStyle(
                              fontSize: 12, color: Colors.black54)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Text("0.75 ↑",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),

              const SizedBox(height: 10),

              // Bar Chart
              SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 10,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const Text("August, 25", style: TextStyle(fontSize: 10));
                            if (value == 30) return const Text("September, 25", style: TextStyle(fontSize: 10));
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: false),

                    // Bars
                    barGroups: List.generate(30, (index) {
                      final double height = (index * index) / 5 + 5;

                      (index < 15)
                          ? index.toDouble() + 10
                          : 30 - index.toDouble() + 5; // decreases after 15
                           // Fake data
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: height,
                            gradient: const LinearGradient(
                              colors: [Colors.green, Colors.lightGreenAccent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 6,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        ],
      ),
    );
  }
}
