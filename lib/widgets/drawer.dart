import 'package:flutter/material.dart';
import 'package:instatube/main.dart';
import 'package:instatube/view/home_page.dart';
import 'package:instatube/view/settings_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
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

  Widget _createHeader(BuildContext context) {
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
            
      accountName: Text("Ashish Rawat"),
  accountEmail: Text("ashishrawat2911@gmail.com"),
  currentAccountPicture: CircleAvatar(
     radius: 30.0,
     backgroundColor: Colors.transparent,
     backgroundImage:AssetImage("assets/images/profile.jpg")
                    
                
      ),
    );
  
  
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