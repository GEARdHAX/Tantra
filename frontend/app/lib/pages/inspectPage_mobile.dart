// lib/pages/inspectPage_mobile.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class InspectionScreen extends StatelessWidget {
  const InspectionScreen({super.key});

  Future<void> sendImageToBackend() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse("http://<YOUR_MAC_IP>:8000/process_frame"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
      } else {
        print("Error: ${response.statusCode}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Overview Statistics", style: TextStyle(color: Colors.black45)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("Insect", "Normal Level", "18%", Colors.greenAccent),
                _buildStatCard("Water", "Normal Level", "74%", Colors.black87,
                    isHighlighted: true),
                _buildStatCard("Clay", "Black Soil", "83%", Colors.green),
              ],
            ),
            const SizedBox(height: 20),

            // Tabs (Plowing, Spraying, Fertilizations, Harvest)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTab("Plowing"),
                _buildTab("Spraying"),
                _buildTab("Fertilizations", isActive: true),
                _buildTab("Harvest"),
              ],
            ),
            const SizedBox(height: 20),

            // Graph
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
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
                            case 14:
                              return const Text("14.09");
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(4, 60),
                        FlSpot(6, 65),
                        FlSpot(8, 62),
                        FlSpot(10, 70),
                        FlSpot(12, 66),
                        FlSpot(14, 80),
                      ],
                      isCurved: true,
                      color: Colors.green,
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
                      barWidth: 4,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CTA Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(title: const Text("iPhone Camera Stream")),
                        body: const Center(
                          child: IPhoneCameraStream(
                            streamUrl: "http://10.209.239.42:8000/video_feed", // 👈 your backend stream
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Check Field Now",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.greenAccent,
                      radius: 15,
                      child: Icon(Icons.arrow_forward, color: Colors.black),
                    )
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

  Widget _buildTab(String title, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class IPhoneCameraStream extends StatelessWidget {
  final String streamUrl;

  const IPhoneCameraStream({super.key, required this.streamUrl});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Camera streaming is only available on Web builds.",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

class CameraPreviewScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraPreviewScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Webcam Preview")),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final picture = await _controller.takePicture();
            print("📸 Captured: ${picture.path}");
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
