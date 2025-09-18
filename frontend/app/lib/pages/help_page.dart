import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.helpUserGuide)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(loc.helpIntro, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          _step(context, '1', loc.helpStepDashboard),
          _step(context, '2', loc.helpStepIrrigation),
          _step(context, '3', loc.helpStepWeather),
          _step(context, '4', loc.helpStepProfile),
          const SizedBox(height: 16),
          Text(loc.helpContact, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _step(BuildContext context, String num, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 14, backgroundColor: Colors.green, child: Text(num, style: const TextStyle(color: Colors.white))),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}


