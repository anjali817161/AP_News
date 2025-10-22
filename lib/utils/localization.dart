import 'package:flutter/material.dart';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // English translations
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'login': 'Login',
      'signup': 'Signup',
      'email': 'Email',
      'password': 'Password',
      'name': 'Name',
      'welcome': 'Welcome',
      'home': 'Home',
      'language': 'Language',
      'english': 'English',
      'hindi': 'Hindi',
      'theme': 'Theme',
      'logout': 'Logout',
    },
    'hi': {
      'login': 'लॉगिन',
      'signup': 'साइनअप',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'name': 'नाम',
      'welcome': 'स्वागत',
      'home': 'होम',
      'language': 'भाषा',
      'english': 'अंग्रेजी',
      'hindi': 'हिंदी',
      'theme': 'थीम',
      'logout': 'लॉगआउट',
    },
  };

  String get login => _localizedValues[_locale.languageCode]!['login']!;
  String get signup => _localizedValues[_locale.languageCode]!['signup']!;
  String get email => _localizedValues[_locale.languageCode]!['email']!;
  String get password => _localizedValues[_locale.languageCode]!['password']!;
  String get name => _localizedValues[_locale.languageCode]!['name']!;
  String get welcome => _localizedValues[_locale.languageCode]!['welcome']!;
  String get home => _localizedValues[_locale.languageCode]!['home']!;
  String get language => _localizedValues[_locale.languageCode]!['language']!;
  String get english => _localizedValues[_locale.languageCode]!['english']!;
  String get hindi => _localizedValues[_locale.languageCode]!['hindi']!;
  String get theme => _localizedValues[_locale.languageCode]!['theme']!;
  String get logout => _localizedValues[_locale.languageCode]!['logout']!;

  late Locale _locale;

  AppLocalizations(this._locale);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
