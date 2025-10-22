import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/language_controller.dart';
import '../utils/localization.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Provider.of<LanguageController>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.language)),
      body: ListView(
        children: [
          ListTile(
            title: Text(localizations.english),
            onTap: () {
              languageController.changeLanguage('en');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(localizations.hindi),
            onTap: () {
              languageController.changeLanguage('hi');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
