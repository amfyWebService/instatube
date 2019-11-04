import 'package:flutter/material.dart';
import 'package:instatube/widgets/container_app_gradient.dart';

class AppButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  final TextStyle style;

  AppButton({@required this.onPressed, @required this.child, this.style}) : super();

  AppButton.text({@required this.onPressed, @required String text, this.style = const TextStyle()})
      : child = Text(text, textAlign: TextAlign.center, style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        super();

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: 5.0,
      child: ContainerAppGradient(
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
