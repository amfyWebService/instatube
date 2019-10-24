import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class AppHeader extends StatelessWidget with PreferredSizeWidget{
  final String name;

  AppHeader({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}