// lib/pages/inspectPage_stub.dart
// Safe fallback for non-web platforms (iOS, Android, Desktop)

import 'package:flutter/material.dart';

class InspectionScreen extends StatelessWidget {
  const InspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview Statistics"),
      ),
      body: const Center(
        child: Text(
          "Web-only features (camera stream) are not available on this platform.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
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
    // ❌ No HTML camera support outside Web
    return const Center(
      child: Text(
        "Camera stream is only supported on Web builds.",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
