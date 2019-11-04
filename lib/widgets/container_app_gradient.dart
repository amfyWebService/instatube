import 'package:flutter/material.dart';

class ContainerAppGradient extends StatelessWidget {
  final Widget child;

  ContainerAppGradient({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xFF5E0075),
            Color(0xFFFC0002),
            Color(0xFFFFAD00),
          ],
        ),
      ),
      child: this.child,
    );
  }
}
