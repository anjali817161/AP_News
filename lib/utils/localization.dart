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
      'politics': 'Politics',
      'business': 'Business',
      'technology': 'Technology',
      'sports': 'Sports',
      'entertainment': 'Entertainment',
      'health': 'Health',
      'science': 'Science',
      'language': 'Language',
      'english': 'English',
      'hindi': 'Hindi',
      'theme': 'Theme',
      'logout': 'Logout',
      'live_tv': 'Live TV',
      'trending': 'Trending',
      'saved': 'Saved',
      'recent_news': 'Recent news',
      'more_videos': '📹 More Videos',
      'latest_news': '📰 Latest News',
      'see_all': 'See All',
      'breaking': 'Breaking',
      'live_now': 'LIVE NOW',
      'watch_now': 'Watch Now',
      'play_now': 'Play Now',
      'new': 'NEW',
      'read_more': 'Read More',
      'search_flight': 'Search Flight',
      'from': 'From',
      'to': 'To',
      'data_filter': 'Data Filter',
      'default': 'Default',
      'status_true': 'Status: True',
      'error_false': 'Error: False',
      'cancel': 'Cancel',
      'search': 'Search',
      'logged_out': 'Logged out',
      'content_coming_soon': 'Content Coming Soon',
    },
    'hi': {
      'login': 'लॉगिन',
      'signup': 'साइनअप',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'name': 'नाम',
      'welcome': 'स्वागत',
      'home': 'होम',
      'politics': 'राजनीति',
      'business': 'व्यापार',
      'technology': 'तकनीक',
      'sports': 'खेल',
      'entertainment': 'मनोरंजन',
      'health': 'स्वास्थ्य',
      'science': 'विज्ञान',
      'language': 'भाषा',
      'english': 'अंग्रेजी',
      'hindi': 'हिंदी',
      'theme': 'थीम',
      'logout': 'लॉगआउट',
      'live_tv': 'लाइव टीवी',
      'trending': 'ट्रेंडिंग',
      'saved': 'सेव्ड',
      'recent_news': 'हाल की खबरें',
      'more_videos': '📹 और वीडियो',
      'latest_news': '📰 नवीनतम खबरें',
      'see_all': 'सभी देखें',
      'breaking': 'ब्रेकिंग',
      'live_now': 'अभी लाइव',
      'watch_now': 'अभी देखें',
      'play_now': 'अभी चलाएं',
      'new': 'नया',
      'read_more': 'और पढ़ें',
      'search_flight': 'फ्लाइट खोजें',
      'from': 'से',
      'to': 'तक',
      'data_filter': 'डेटा फिल्टर',
      'default': 'डिफॉल्ट',
      'status_true': 'स्थिति: सही',
      'error_false': 'त्रुटि: गलत',
      'cancel': 'रद्द करें',
      'search': 'खोजें',
      'logged_out': 'लॉग आउट हो गया',
      'content_coming_soon': 'सामग्री जल्द आ रही है',
    },
  };

  String get login => _localizedValues[_locale.languageCode]!['login']!;
  String get signup => _localizedValues[_locale.languageCode]!['signup']!;
  String get email => _localizedValues[_locale.languageCode]!['email']!;
  String get password => _localizedValues[_locale.languageCode]!['password']!;
  String get name => _localizedValues[_locale.languageCode]!['name']!;
  String get welcome => _localizedValues[_locale.languageCode]!['welcome']!;
  String get home => _localizedValues[_locale.languageCode]!['home']!;
  String get politics => _localizedValues[_locale.languageCode]!['politics']!;
  String get business => _localizedValues[_locale.languageCode]!['business']!;
  String get technology =>
      _localizedValues[_locale.languageCode]!['technology']!;
  String get sports => _localizedValues[_locale.languageCode]!['sports']!;
  String get entertainment =>
      _localizedValues[_locale.languageCode]!['entertainment']!;
  String get health => _localizedValues[_locale.languageCode]!['health']!;
  String get science => _localizedValues[_locale.languageCode]!['science']!;
  String get language => _localizedValues[_locale.languageCode]!['language']!;
  String get english => _localizedValues[_locale.languageCode]!['english']!;
  String get hindi => _localizedValues[_locale.languageCode]!['hindi']!;
  String get theme => _localizedValues[_locale.languageCode]!['theme']!;
  String get logout => _localizedValues[_locale.languageCode]!['logout']!;
  String get live_tv => _localizedValues[_locale.languageCode]!['live_tv']!;
  String get trending => _localizedValues[_locale.languageCode]!['trending']!;
  String get saved => _localizedValues[_locale.languageCode]!['saved']!;
  String get recent_news =>
      _localizedValues[_locale.languageCode]!['recent_news']!;
  String get more_videos =>
      _localizedValues[_locale.languageCode]!['more_videos']!;
  String get latest_news =>
      _localizedValues[_locale.languageCode]!['latest_news']!;
  String get see_all => _localizedValues[_locale.languageCode]!['see_all']!;
  String get breaking => _localizedValues[_locale.languageCode]!['breaking']!;
  String get live_now => _localizedValues[_locale.languageCode]!['live_now']!;
  String get watch_now => _localizedValues[_locale.languageCode]!['watch_now']!;
  String get play_now => _localizedValues[_locale.languageCode]!['play_now']!;
  String get new_ => _localizedValues[_locale.languageCode]!['new']!;
  String get read_more => _localizedValues[_locale.languageCode]!['read_more']!;
  String get search_flight =>
      _localizedValues[_locale.languageCode]!['search_flight']!;
  String get from => _localizedValues[_locale.languageCode]!['from']!;
  String get to => _localizedValues[_locale.languageCode]!['to']!;
  String get data_filter =>
      _localizedValues[_locale.languageCode]!['data_filter']!;
  String get default_ => _localizedValues[_locale.languageCode]!['default']!;
  String get status_true =>
      _localizedValues[_locale.languageCode]!['status_true']!;
  String get error_false =>
      _localizedValues[_locale.languageCode]!['error_false']!;
  String get cancel => _localizedValues[_locale.languageCode]!['cancel']!;
  String get search => _localizedValues[_locale.languageCode]!['search']!;
  String get logged_out =>
      _localizedValues[_locale.languageCode]!['logged_out']!;
  String get content_coming_soon =>
      _localizedValues[_locale.languageCode]!['content_coming_soon']!;

  String getLocalizedTab(String tab) {
    return _localizedValues[_locale.languageCode]![tab.toLowerCase()] ?? tab;
  }

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
