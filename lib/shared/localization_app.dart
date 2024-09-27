import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventaris/shared/localization_app_delegate.dart';

class LocalizationsApp {
  final Locale locale;
  late Map<String, String> _localizationString;

  LocalizationsApp(this.locale);

  Future<bool> load() async {
    String jsonString =
    await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizationString =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));

    return true;
  }

  String translate(String key) {
    try {
      if (_localizationString.containsKey(key)) {
        return _localizationString[key]!;
      }
      return "";
    } on Exception {
      return "";
    }
  }

  static LocalizationsApp? of(BuildContext context) {
    return Localizations.of<LocalizationsApp>(context, LocalizationsApp);
  }

  static LocalizationsAppDelegate delegate = LocalizationsAppDelegate();
}