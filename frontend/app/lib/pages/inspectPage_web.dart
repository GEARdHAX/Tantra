// lib/pages/inspectPage_web.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui_web' as ui;

class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key});

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen>{
  String activeTab = "Fertilizations"; // default active tab

  // Example soil/production data for Nepal (replace with real stats later)
  final Map<String, List<FlSpot>> soilGraphs = {
    "Plowing": [
      FlSpot(4, 40),
      FlSpot(6, 55),
      FlSpot(8, 50),
      FlSpot(10, 65),
      FlSpot(12, 70),
    ],
    "Spraying": [
      FlSpot(4, 30),
      FlSpot(6, 40),
      FlSpot(8, 45),
      FlSpot(10, 60),
      FlSpot(12, 58),
    ],
    "Fertilizations": [
      FlSpot(4, 60),
      FlSpot(6, 65),
      FlSpot(8, 62),
      FlSpot(10, 70),
      FlSpot(12, 66),
      FlSpot(14, 80),
    ],
    "Harvest": [
      FlSpot(4, 50),
      FlSpot(6, 55),
      FlSpot(8, 70),
      FlSpot(10, 75),
      FlSpot(12, 85),
    ],
  };

  /// List available cameras in browser
  Future<void> listWebCameras() async {
    try {
      await html.window.navigator.mediaDevices!.getUserMedia({'video': true});

      final devices =
      await html.window.navigator.mediaDevices!.enumerateDevices();
      for (final d in devices) {
        if (d.kind == 'videoinput') {
          print("Camera: ${d.label} (${d.deviceId})");
        }
      }
    } catch (e) {
      print("Error accessing cameras: $e");
    }
  }

  /// Capture one frame and send to backend
  Future<void> sendImageToBackend(BuildContext context) async {
    try {
      final stream = await html.window.navigator.mediaDevices!
          .getUserMedia({'video': true});

      final video = html.VideoElement()
        ..srcObject = stream
        ..width = 640
        ..height = 480;

      await video.play();
      await Future.delayed(const Duration(milliseconds: 100));

      final canvas = html.CanvasElement(width: 640, height: 480);
      final ctx = canvas.context2D;

      // ✅ Correct drawImage usage
      ctx.drawImage(video, 0, 0);

      final dataUrl = canvas.toDataUrl('image/jpeg', 0.8);
      final base64Image = dataUrl.split(',')[1];

      stream.getTracks().forEach((t) => t.stop());

      final response = await http.post(
        Uri.parse(" http://10.209.239.42:8000/video_feed"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        print("Frame sent successfully!");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Frame sent successfully!")),
          );
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error capturing image: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Overview Statistics",
            style: TextStyle(color: Colors.black45)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTab("Plowing"),
                _buildTab("Spraying"),
                _buildTab("Fertilizations"),
                _buildTab("Harvest"),
              ],
            ),
            const SizedBox(height: 20),

            // Dynamic graph
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 4:
                              return const Text("4.09");
                            case 6:
                              return const Text("6.09");
                            case 8:
                              return const Text("8.09");
                            case 10:
                              return const Text("10.09");
                            case 12:
                              return const Text("12.09");
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: soilGraphs[activeTab] ?? [],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 4,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.4),
                            Colors.green.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Camera Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(title: const Text("Web Camera Stream")),
                            body: const Center(
                              child: IPhoneCameraStream(
                                streamUrl:
                                "http://192.168.1.12:8000/video_feed", // backend stream
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Check Field Now",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.greenAccent,
                          radius: 15,
                          child: Icon(Icons.arrow_forward, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => sendImageToBackend(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.camera_alt, color: Colors.white),
                      SizedBox(width: 8),
                      Text("Capture",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Camera List Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: listWebCameras,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.videocam, color: Colors.black87),
                    SizedBox(width: 8),
                    Text("List Available Cameras",
                        style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String subtitle, String value, Color color,
      {bool isHighlighted = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: isHighlighted ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: TextStyle(
                    color: isHighlighted ? Colors.white70 : Colors.grey,
                    fontSize: 12)),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    color: isHighlighted ? Colors.white : color,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    final isActive = activeTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? Colors.black : Colors.grey.shade400,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class IPhoneCameraStream extends StatefulWidget {
  final String streamUrl;
  const IPhoneCameraStream({super.key, required this.streamUrl});

  @override
  State<IPhoneCameraStream> createState() => _IPhoneCameraStreamState();
}

class _IPhoneCameraStreamState extends State<IPhoneCameraStream> {
  html.MediaStream? _stream;
  bool _isStreaming = false;


  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  Future<void> _startCamera() async {
    try {
      final stream = await html.window.navigator.mediaDevices!.getUserMedia({
        'video': {
          'width': 640,
          'height': 480,
          'facingMode': 'environment',
        },
        'audio': false,
      });

      setState(() {
        _stream = stream;
        _isStreaming = true;
      });

      ui.platformViewRegistry.registerViewFactory(
        'web-camera',
            (int viewId) {
          final video = html.VideoElement()
            ..srcObject = stream
            ..autoplay = true
            ..muted = true
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.objectFit = 'cover';
          return video;
        },
      );
    } catch (e) {
      print("Error starting camera: $e");
      ui.platformViewRegistry.registerViewFactory(
        'web-camera',
            (int viewId) {
          final element = html.ImageElement()
            ..src = widget.streamUrl
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.objectFit = 'cover';
          return element;
        },
      );
    }
  }

  Future<void> _capturePhoto() async {
    if (_stream == null) return;
    try {
      final video = html.VideoElement()
        ..srcObject = _stream
        ..width = 640
        ..height = 480;

      await video.play();
      await Future.delayed(const Duration(milliseconds: 100));

      final canvas = html.CanvasElement(width: 640, height: 480);
      final ctx = canvas.context2D;

      // ✅ Correct usage
      ctx.drawImage(video, 0, 0);

      final dataUrl = canvas.toDataUrl('image/jpeg', 0.8);
      final base64Image = dataUrl.split(',')[1];

      final response = await http.post(
        Uri.parse("http://192.168.1.12:8000/video_feed"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        print("Photo captured and sent successfully!");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Photo captured and sent successfully!")),
          );
        }
      } else {
        print("Error sending photo: ${response.statusCode}");
      }
    } catch (e) {
      print("Error capturing photo: $e");
    }
  }

  @override
  void dispose() {
    _stream?.getTracks().forEach((track) => track.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Register a <img> element that streams MJPEG from backend
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iphone-camera',
          (int viewId) {
        final element = html.ImageElement()
          ..src = 'http://10.209.239.42:8000/video_feed'
          ..style.width = '100%'     // responsive
          ..style.height = '100%'
          ..style.objectFit = 'cover'
          ..style.border = 'none';
        return element;
      },
    );

    return const Scaffold(
      body: Center(
        child: HtmlElementView(viewType: 'iphone-camera'),
      ),
    );
  }
}
