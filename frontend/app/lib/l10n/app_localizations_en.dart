// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Hi, Tantra User';

  @override
  String get checkField => 'Check Field Now';

  @override
  String get wateringSkipped => 'Watering skipped';

  @override
  String get itsRaining => 'It\'s raining';
}
