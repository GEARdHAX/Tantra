import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'help_page.dart';

class ProfilePage extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const ProfilePage({super.key, required this.onLocaleChange});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Fake demo data; in a real app this would come from a backend/local DB
  String selectedLanguageCode = 'en';

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header card with avatar and basic info
          _Card(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(Icons.agriculture, size: 36, color: Colors.green),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text('+123-456-7890', style: Theme.of(context).textTheme.bodyMedium),
                          Text('john.doe@example.com', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Farm details
          _SectionHeader(title: loc.farmDetailsTitle),
          _Card(
            child: Column(
              children: [
                _kv(loc.farmNameLocation, 'Green Acres Farm'),
                _kv(loc.farmSize, '100 acres'),
                _kv(loc.primaryCrops, 'Wheat, Corn'),
                _kv(loc.irrigationMethod, 'Drip'),
                _kv(loc.powerSource, 'Solar'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Device & Sensors
          _SectionHeader(title: loc.deviceSensorTitle),
          _Card(
            child: Column(
              children: [
                _kv(loc.linkedDevices, loc.sampleDevices),
                _kv(loc.activeSensors, loc.sampleSensors),
                _kv(loc.connectivityStatus, 'LoRa, Online'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Preferences
          _SectionHeader(title: loc.preferencesSettingsTitle),
          _Card(
            child: Column(
              children: [
                _kv(loc.notificationPreferences, 'App, Email'),
                _kv(loc.voiceAlertLanguage, _languageName(selectedLanguageCode, loc)),
                _kv(loc.dashboardCustomization, loc.dashboardCustomizationOptions),
                _kv(loc.privacySecurity, loc.privacySecurityHint),
                const Divider(height: 24),
                // Inline language selector
                Row(
                  children: [
                    Icon(Icons.language, color: Colors.grey[700]),
                    const SizedBox(width: 12),
                    Expanded(child: Text(loc.preferredLanguage)),
                    DropdownButton<String>(
                      value: selectedLanguageCode,
                      items: [
                        DropdownMenuItem(value: 'en', child: Text(loc.langEnglish)),
                        DropdownMenuItem(value: 'hi', child: Text(loc.langHindi)),
                        DropdownMenuItem(value: 'ne', child: Text(loc.langNepali)),
                      ],
                      onChanged: (val) {
                        if (val == null) return;
                        setState(() => selectedLanguageCode = val);
                        widget.onLocaleChange(Locale(val));
                      },
                    )
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Achievements
          _SectionHeader(title: loc.achievementsTitle),
          _Card(
            child: Column(
              children: [
                _kv(loc.totalAlertsResponded, '42'),
                _kv(loc.waterSaved, '3,200 L'),
                _kv(loc.energyGenerated, '120 Wh'),
                _kv(loc.badgesRewards, loc.sampleBadges),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Soil Requirements & Fertilizer Recommendations
          _SectionHeader(title: "Soil Analysis & Fertilizer Recommendations"),
          _Card(
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
                            "Soil Analysis for Your Fields",
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

          const SizedBox(height: 16),

          // Support
          _SectionHeader(title: loc.supportTitle),
          _Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.menu_book_outlined),
                  title: Text(loc.helpUserGuide),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HelpPage()),
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.support_agent),
                  title: Text(loc.contactSupport),
                  subtitle: Text('support@agrosmart.example'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _languageName(String code, AppLocalizations loc) {
    switch (code) {
      case 'hi':
        return loc.langHindi;
      case 'ne':
        return loc.langNepali;
      default:
        return loc.langEnglish;
    }
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
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open $url")),
        );
      }
    }
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 3,
            child: Text(v, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _Card({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: child,
    );
  }
}


