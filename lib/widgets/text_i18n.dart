import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class TextI18n extends Text {
  TextI18n(BuildContext context, String txtKey, [final Map<String, String> translationParams])
      : super(FlutterI18n.translate(context, txtKey, translationParams));
}
