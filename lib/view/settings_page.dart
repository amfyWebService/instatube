
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:instatube/widgets/appbar.dart';
import 'package:preferences/preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);
  

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String name = "Settings";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
            title: Text(FlutterI18n.translate(context, name) ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    Color(0xFF5E0075),
                    Color(0xFFFC0002),
                    Color(0xFFFFAD00),
                  ],
                  ),
                ),
              ),
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

