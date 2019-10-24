import 'package:flutter/material.dart';
import 'package:instatube/main.dart';
import 'package:instatube/view/home_page.dart';
import 'package:instatube/view/login_page.dart';
import 'package:instatube/view/settings_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(icon: Icons.home, text: 'Home',
            onTap: () =>
              Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new HomePage()))),
          _createDrawerItem(icon: Icons.settings, text: 'Settings',
          onTap: () =>
              Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new SettingsPage()))),
          Divider(),
          _createDrawerItem(icon: Icons.input, text:'Logout',
          onTap: () =>
              Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new MyHomePage()))),
          Divider(),
         
        ],
      ),
    );
  }
}

  Widget _createHeader() {
  return DrawerHeader(
      margin: EdgeInsets.only(left: 10.0),
      padding: EdgeInsets.zero,
      child: Stack(children: <Widget>[
        Container(
        width: 90.0,
        height: 90.0,
        decoration:  BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage("assets/images/profile.jpg")
                        )
                    ),),
      
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text("Menu",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))),
      ]));
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}