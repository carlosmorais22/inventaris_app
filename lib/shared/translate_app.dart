import 'package:flutter/cupertino.dart';
import 'package:inventaris/shared/localization_app.dart';

class TranslateApp {
  final BuildContext context;

  TranslateApp(this.context);

  String text(String key, [String params1 = "", String params2 = ""]) {
    String resultado = "";
    try {
      resultado = LocalizationsApp.of(context)!.translate(key);
    } on Exception {
      return resultado;
    }
    if (params1 != "") resultado = resultado.replaceFirst("?", params1);
    return resultado;
  }
// String text(String key) => LocalizationsApp.of(context)!.translate(key);
}