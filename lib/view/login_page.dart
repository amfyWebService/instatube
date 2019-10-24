import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  static const String routeName = '/login';
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {

    return new SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 155.0,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 45.0),
              field("email", style ,context),
              SizedBox(height: 25.0),
              field("password", style ,context),
              SizedBox(
                height: 35.0,
              ),
              loginButton(context, style),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget field(String title, TextStyle style , BuildContext context) {
   return TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: FlutterI18n.translate(context, title),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
}


Widget loginButton (BuildContext context, TextStyle style){ 
   return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: 5.0,
      child:Container(
        decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF5E0075),
                    Color(0xFFFC0002),
                    Color(0xFFFFAD00),
                  ],
                ),
              ),
        child: MaterialButton(
        
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () =>print('click'),
        child: Text(FlutterI18n.translate(context, "login"),
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      ),
    );
}
