import 'package:flutter/material.dart';
import 'package:instatube/widgets/my_app_bar.dart';
import 'package:instatube/widgets/text_i18n.dart';
import 'package:preferences/preferences.dart';

class SettingsPage extends StatelessWidget {
  static String title = "settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: TextI18n(context, title),
      ),
      body: PreferencePage([
        PreferenceTitle('General'),
        DropdownPreference(
          'Start Page',
          'start_page',
          defaultVal: 'Timeline',
          values: ['Posts', 'Timeline', 'Private Messages'],
        ),
        PreferenceTitle('Personalization'),
        RadioPreference(
          'Light Theme',
          'light',
          'ui_theme',
          isDefault: true,
        ),
        RadioPreference(
          'Dark Theme',
          'dark',
          'ui_theme',
        ),
      ]),
    );
  }
}
