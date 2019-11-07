import 'package:flutter/material.dart';
import 'package:instatube/view/home_page.dart';
import 'package:instatube/view/profile_page.dart';
import 'package:instatube/view/login_page.dart';
import 'package:instatube/view/settings_page.dart';
import 'package:instatube/view/test_page.dart';
import 'package:instatube/widgets/text_i18n.dart';

import '../core/utils/preference_service.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildHeader(),
          _buildDrawerItem(
              icon: Icons.home,
              textKey: HomePage.title,
              onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage()))),
          _buildDrawerItem(
              icon: Icons.settings,
              textKey: SettingsPage.title,
              onTap: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => SettingsPage()))),
          Divider(),
          _buildDrawerItem(
            icon: Icons.input,
            textKey: 'logout',
            onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => LoginPage())),
          ),
          Divider(),
          _buildDrawerItem(
              icon: Icons.input,
              textKey: 'test',
              onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => TestPage()))),
          Divider(),
          _buildDrawerItem(
              icon: Icons.input,
              textKey: 'profile',
              onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new ProfilePage()))),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return UserAccountsDrawerHeader(
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
      accountName: Text(PreferenceService.user?.username ?? ''),
      accountEmail: Text(PreferenceService.user?.email ?? ''),
      currentAccountPicture:
          CircleAvatar(radius: 30.0, backgroundColor: Colors.transparent, backgroundImage: AssetImage("assets/images/profile.jpg")),
    );
  }

  Widget _buildDrawerItem({@required IconData icon, @required String textKey, @required Function onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: TextI18n(context, textKey),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
