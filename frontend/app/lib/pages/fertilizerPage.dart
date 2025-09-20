import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

// handwritten code  - this page shows the Details of each field farmer hold, it shows the alerts prevailing, and the location with neceassry niutrients for the crop
// gpt 4o - get details of required nutrients and get the details of them
//animation deals with moving turbines and design of the background
final FlutterTts flutterTts = FlutterTts();


class FieldDashboard extends StatelessWidget {
  final Map<String, String> farm;

  const FieldDashboard({Key? key, required this.farm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              farm["background"]!, // now uses the farm passed in
              fit: BoxFit.cover,
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.45, // how much is visible initially
            minChildSize: 0.2, // collapsed height
            maxChildSize: 0.85, // expanded height
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  controller: scrollController, // important for dragging to work
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // grab handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Field of ${farm["name"]}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              farm["icon"] ?? farm["image"]!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),

                      Text("Irrigation Level: ${farm["irrigation"]}",
                          style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
                      Text("Pesticides: ${farm["pesticides"]}",
                          style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _InfoBox(label: "Distance", value: farm["distance"] ?? "--"),
                          _InfoBox(label: "Land", value: farm["land"] ?? "--"),
                          _InfoBox(label: "Wind", value: farm["wind"] ?? "--"),
                        ],
                      ),
                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Perform Irrigation Now",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Soil Analysis & Fertilizer Recommendations Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Soil Analysis Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.brown.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.brown.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.eco, color: Colors.brown.shade700),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Soil Analysis for ${farm['name']}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildSoilRequirement("pH Level", "6.2", "Optimal", Colors.green),
                                  _buildSoilRequirement("Nitrogen (N)", "45 ppm", "Low", Colors.orange),
                                  _buildSoilRequirement("Phosphorus (P)", "12 ppm", "Very Low", Colors.red),
                                  _buildSoilRequirement("Potassium (K)", "85 ppm", "Adequate", Colors.green),
                                  _buildSoilRequirement("Organic Matter", "2.1%", "Low", Colors.orange),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Fertilizer Recommendations
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.agriculture, color: Colors.green.shade700),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Recommended Fertilizers",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildFertilizerRecommendation(
                                    "NPK 20-20-20",
                                    "Balanced fertilizer for general use",
                                    "₹450/bag",
                                    "https://example.com/npk-20-20-20",
                                    Colors.blue,
                                  ),
                                  _buildFertilizerRecommendation(
                                    "DAP (18-46-0)",
                                    "High phosphorus for root development",
                                    "₹380/bag",
                                    "https://example.com/dap-fertilizer",
                                    Colors.purple,
                                  ),
                                  _buildFertilizerRecommendation(
                                    "Urea (46-0-0)",
                                    "High nitrogen for leaf growth",
                                    "₹280/bag",
                                    "https://example.com/urea-fertilizer",
                                    Colors.orange,
                                  ),
                                  _buildFertilizerRecommendation(
                                    "Compost",
                                    "Organic matter improvement",
                                    "₹150/bag",
                                    "https://example.com/organic-compost",
                                    Colors.brown,
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Navigate to detailed soil analysis
                                      _showSoilAnalysisDetails(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.brown,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: const Icon(Icons.analytics, color: Colors.white),
                                    label: const Text(
                                      "View Detailed Analysis",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Navigate to fertilizer marketplace
                                      _openFertilizerMarketplace(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                                    label: const Text(
                                      "Shop Fertilizers",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                SizedBox(
                  height: 300,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${farm['name']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "Critical",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Body content (example placeholders for soil and temperature)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                // Soil Moisture
                                Card(
                                  color: Colors.blue.shade50,
                                  child: ListTile(
                                    leading: const Icon(Icons.water_drop, color: Colors.blue),
                                    title: const Text("Soil Moisture"),
                                    subtitle: LinearProgressIndicator(
                                      value: 0.75,
                                      color: Colors.green,
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    trailing: const Text(
                                      "75%",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                // Temperature
                                Card(
                                  color: Colors.orange.shade50,
                                  child: ListTile(
                                    leading: const Icon(Icons.thermostat, color: Colors.orange),
                                    title: const Text("Temperature"),
                                    subtitle: LinearProgressIndicator(
                                      value: 0.6,
                                      color: Colors.orange,
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    trailing: const Text(
                                      "33°C",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Footer
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.access_time, size: 14, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    " \t Last updated: 15/9/2023, 10:40 AM",
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.location_on, size: 14, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    " \t Location: 27.7190, 85.3250",
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              //const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: const Icon(Icons.map),
                                    label: const Text("View on Map"),
                                    onPressed: () async {
                                      final double latitude = 27.7190;  // Replace with farm['lat']
                                      final double longitude = 85.3250; // Replace with farm['lng']

                                      final Uri googleMapsUrl = Uri.parse(
                                          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

                                      if (await canLaunchUrl(googleMapsUrl)) {
                                        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
                                      } else {
                                        throw 'Could not open the map.';
                                      }
                                    },
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: const Icon(Icons.volume_up),
                                    label: const Text("Play Alert"),
                                    onPressed: () async {
                                      double soilMoisture = 25; // <-- replace with real sensor value

                                      String alertMessage;
                                      if (soilMoisture < 30) {
                                        alertMessage = "Critical irrigation alert";
                                      } else if (soilMoisture > 80) {
                                        alertMessage = "High irrigation alert";
                                      } else {
                                        alertMessage = "Irrigation level is normal";
                                      }

                                      await flutterTts.speak(alertMessage);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //const SizedBox(height: 300), // extra space to test scrolling
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSoilRequirement(String nutrient, String value, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              nutrient,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFertilizerRecommendation(String name, String description, String price, String url, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.open_in_new,
                    color: color,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSoilAnalysisDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Detailed Soil Analysis"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Based on your field analysis, here are the detailed recommendations:",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _buildDetailItem("pH Level (6.2)", "Optimal range for most crops. No adjustment needed."),
              _buildDetailItem("Nitrogen Deficiency", "Apply 50-75 kg N per hectare. Use urea or ammonium nitrate."),
              _buildDetailItem("Phosphorus Deficiency", "Apply 40-60 kg P2O5 per hectare. Use DAP or superphosphate."),
              _buildDetailItem("Potassium Level", "Adequate for current crops. Monitor for next season."),
              _buildDetailItem("Organic Matter", "Add compost or manure to improve soil structure."),
              const SizedBox(height: 16),
              const Text(
                "Application Timing:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text("• Apply nitrogen in 2-3 splits during growing season"),
              const Text("• Apply phosphorus at planting time"),
              const Text("• Add organic matter during land preparation"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _openFertilizerMarketplace(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Fertilizer Marketplace"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.store, color: Colors.blue),
              title: Text("AgriMart"),
              subtitle: Text("Local fertilizer supplier"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag, color: Colors.green),
              title: Text("FarmDirect"),
              subtitle: Text("Online fertilizer marketplace"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              leading: Icon(Icons.local_shipping, color: Colors.orange),
              title: Text("CropCare"),
              subtitle: Text("Premium organic fertilizers"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _launchUrl("https://example.com/fertilizer-marketplace");
            },
            child: const Text("Visit Marketplace"),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Show error message - we'll handle this in the calling context
      print("Could not open $url");
    }
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

final List<Map<String, String>> farmDataList = [
  {
    "name": "Wheat Field",
    "irrigation": "High",
    "pesticides": "Low",
    "background": "assets/farm1.jpg",
    "icon": "assets/farm1.jpg",
    "distance": "12.9 km",
    "land": "1.89 ha",
    "wind": "12 km/h",
  },
  {
    "name": "Corn Field",
    "irrigation": "Medium",
    "pesticides": "Moderate",
    "background": "assets/farm2.jpg",
    "icon": "assets/farm2.jpg",
    "distance": "10.2 km",
    "land": "2.14 ha",
    "wind": "15 km/h",
  },
  {
    "name": "Empty Land",
    "irrigation": "None",
    "pesticides": "None",
    "background": "assets/farm3.jpg",
    "icon": "assets/farm3.jpg",
    "distance": "8.4 km",
    "land": "1.20 ha",
    "wind": "9 km/h",
  },
];
