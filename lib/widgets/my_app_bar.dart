import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar({Widget title, List<Widget> actions})
      : super(
          title: title,
          actions: actions,
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
