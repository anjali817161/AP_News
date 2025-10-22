import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController with ChangeNotifier {
  String _currentLanguage = 'en'; // Default to English

  String get currentLanguage => _currentLanguage;

  LanguageController() {
    _loadLanguageFromPrefs();
  }

  void changeLanguage(String languageCode) {
    _currentLanguage = languageCode;
    _saveLanguageToPrefs();
    notifyListeners();
  }

  Future<void> _loadLanguageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'en';
    notifyListeners();
  }

  Future<void> _saveLanguageToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _currentLanguage);
  }
}
