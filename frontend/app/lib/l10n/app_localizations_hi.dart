// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get title => 'नमस्ते, कृषि उपयोगकर्ता';

  @override
  String get checkField => 'अभी खेत जाँचें';

  @override
  String get wateringSkipped => 'सिंचाई रोकी गई';

  @override
  String get itsRaining => 'बारिश हो रही है';
}
