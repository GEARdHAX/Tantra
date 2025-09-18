import 'package:agroproject/pages/inspectPage.dart';
import 'package:agroproject/pages/irrigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../pages/dashboard.dart';
import 'pages/profilePage.dart';
import '../pages/weather.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); 

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Agriculture Project",
      debugShowCheckedModeBanner: false,
      locale: _locale,
      home: HomePage(onLocaleChange: _setLocale), 
      theme: ThemeData(
        useMaterial3: false,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color.fromRGBO(230, 255, 230, 1.0),
          selectedItemColor: const Color.fromRGBO(5, 5, 5, 1.0),
          unselectedItemColor: Colors.grey[600],
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          surfaceTint: Colors.transparent,
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations
            .delegate, 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // englishh
        Locale('ne'), // nepalii
        Locale('hi'), // hindi
      ],
    );
  }
}
class HomePage extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const HomePage({super.key, required this.onLocaleChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Default colors
  Color _appBarColor = const Color.fromRGBO(234, 239, 234, 0.9);
  Color _bgColor = const Color.fromRGBO(239, 243, 235, 1.0);
  Color _bottomNavColor = const Color.fromRGBO(224, 239, 224, 1.0);

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(),
      FieldScreen(),
      InspectionScreen(),
      WeatherWidget(onWeatherChange: _updateThemeBasedOnWeather),
      ProfilePage(onLocaleChange: widget.onLocaleChange),
    ];
  }

  void _updateThemeBasedOnWeather(String condition) {
    setState(() {
      if (condition.contains("storm")) {
        _appBarColor = Colors.blue.shade100;
        _bgColor = Colors.blue.shade50;
        _bottomNavColor = Colors.blue.shade100;
      } else if (condition.contains("sunny") ||
          condition.contains("clear") ||
          condition.contains("rain")) {
        _appBarColor = const Color.fromRGBO(224, 237, 220, 0.9);
        _bgColor = const Color.fromRGBO(245, 248, 241, 1.0);
        _bottomNavColor = const Color.fromRGBO(224, 239, 224, 1.0);
      } else {
        // Default (mild green theme)
        _appBarColor = const Color.fromRGBO(229, 250, 229, 1.0);
        _bgColor = const Color.fromRGBO(226, 228, 217, 1.0);
        _bottomNavColor = const Color.fromRGBO(230, 255, 230, 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: Text(
          loc.title,
          style: TextStyle(color: Colors.grey[800]!),
        ),
        centerTitle: false,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 18,
            child: ClipOval(
              child: Image.asset(
                "assets/profile.jpg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.account_circle,
                      color: Colors.grey[800], size: 35);
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.language,color:Colors.black54, size:30),
            onPressed: () => _showLanguageDialog(context),
          ),
          const SizedBox(width: 20),
        ],
      ),
      backgroundColor: _bgColor,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: _bottomNavColor,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_filled), label: loc.dashboard),
          BottomNavigationBarItem(icon: const Icon(Icons.local_florist), label: loc.irrigation),
          BottomNavigationBarItem(icon: const Icon(Icons.eco_outlined), label: loc.analysis),
          BottomNavigationBarItem(icon: const Icon(Icons.cloudy_snowing), label: loc.weather),
          BottomNavigationBarItem(icon: const Icon(Icons.perm_identity_rounded), label: loc.profile),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Choose Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("English"),
              onTap: () {
                widget.onLocaleChange(const Locale('en'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text("हिंदी"),
              onTap: () {
                widget.onLocaleChange(const Locale('hi'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text("नेपाली"),
              onTap: () {
                widget.onLocaleChange(const Locale('ne'));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}
