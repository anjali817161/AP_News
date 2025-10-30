import 'package:ap_news/auth/login_signup/view/login_view.dart';
import 'package:ap_news/modules/home/home_page.dart';
import 'package:ap_news/modules/weather/weather_controller.dart';
import 'package:ap_news/modules/weather/weather_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/language_controller.dart';
import 'utils/localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Try to load .env file from project root
  try {
    // If you used a different filename, change fileName param.
    await dotenv.load(fileName: ".env");
    debugPrint('✅ Loaded .env file');
  } catch (e) {
    // FileNotFoundError or other load issues end up here
    debugPrint('⚠️ Could not load .env file: $e');
    debugPrint(
      'You can provide OPENWEATHER_API_KEY via --dart-define or ensure .env exists at project root.',
    );
  }

  // 2) Read API key from dotenv first, then fallback to dart-define
  final envKey = dotenv.env['OPENWEATHER_API_KEY'];
  final dartDefineKey = const String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: '',
  );
  final String apiKey = envKey?.isNotEmpty == true ? envKey! : dartDefineKey;

  if (apiKey.isEmpty) {
    debugPrint(
      '⚠️ OPENWEATHER_API_KEY not found. Weather feature will be disabled until you provide the key.',
    );
  } else {
    debugPrint('Using OpenWeather API key (length=${apiKey.length})');
  }

  // create service and controller (you already had this approach)
  final ws = WeatherService(apiKey: apiKey);
  Get.put(WeatherController(service: ws));

  // auth
  final authController = AuthController();
  await authController.checkAuthStatus();

  runApp(MyApp(authController: authController));
}

class MyApp extends StatelessWidget {
  final AuthController authController;

  const MyApp({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authController),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => LanguageController()),
      ],
      child: Consumer2<ThemeController, LanguageController>(
        builder: (context, themeController, languageController, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'AP News',
            theme: themeController.isDarkMode
                ? ThemeData.dark().copyWith(
                    primaryColor: Colors.red[800],
                    colorScheme: ColorScheme.dark(
                      primary: Colors.red[800]!,
                      secondary: Colors.red[600]!,
                    ),
                  )
                : ThemeData.light().copyWith(
                    primaryColor: Colors.red[800],
                    colorScheme: ColorScheme.light(
                      primary: Colors.red[800]!,
                      secondary: Colors.red[600]!,
                    ),
                  ),
            locale: Locale(languageController.currentLanguage),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', ''), Locale('hi', '')],
            home: HomePage(),
          );
        },
      ),
    );
  }
}
