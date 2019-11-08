import 'package:flutter/material.dart';
import 'package:instatube/core/service/videos_service.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  FancyFab({this.onPressed, this.tooltip, this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.purple,
      end: Colors.orange,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget addFromCamera() {
    return Container(
      child:Align(
          child: FloatingActionButton(
            onPressed: () {
              VideoService.uploadVideoFromCamera(context);
            },
            child: Icon(Icons.videocam),
            backgroundColor: Colors.red,
            elevation: 0,
            heroTag: null,
          ),
          alignment: FractionalOffset(0.55, 1.0)
      )
    );
  }

  Widget addFromGalery() {
    return Container(
      child: Align(
          child: FloatingActionButton(
            onPressed: () {
              VideoService.uploadVideoFromGalery(context);
            },
            child: Icon(Icons.video_library),
            backgroundColor: Colors.red,
            elevation: 0,
            heroTag: null,
          ),
          alignment: FractionalOffset(0.55, 1.0)
      )
    );
  }

  Widget toggle() {
    return Container(
    child: Align(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
        ),
        alignment: FractionalOffset(0.55, 1.0)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: addFromCamera(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 1.0,
            0.0,
          ),
          child: addFromGalery(),
        ),
        toggle(),
      ],
    );
  }
}