import 'package:ap_news/auth/login_signup/view/login_view.dart';
import 'package:ap_news/modules/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/language_controller.dart';
import 'utils/localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            home: LoginSignupPage(),
          );
        },
      ),
    );
  }
}
