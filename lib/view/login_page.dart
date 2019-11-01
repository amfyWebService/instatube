import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/core/model/user.dart';
import 'package:instatube/core/utils/PreferenceService.dart';
import 'package:instatube/view/register_page.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  static const String routeName = '/login';

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController txtCtrlEmail = TextEditingController();
  TextEditingController txtCtrlPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String register = """
      mutation Login(\$username: String!, \$password: String!) {
        login(username: \$username, password: \$password) {
          token
          user {
            id
            username
          }
        }
      }
    """;

    return Mutation(
      options: MutationOptions(document: register),
      builder: (RunMutation runMutation, QueryResult result) {
        return SingleChildScrollView(
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
                  field(
                      hintTextKey: "email",
                      style: style,
                      context: context,
                      textInputType: TextInputType.emailAddress,
                      txtCtrl: txtCtrlEmail),
                  SizedBox(height: 25.0),
                  field(hintTextKey: "password", style: style, context: context, obscureText: true, txtCtrl: txtCtrlPassword),
                  if (result.hasErrors)
                    Column(
                      children: <Widget>[
                        SizedBox(height: 25.0),
                        Text(
                          FlutterI18n.translate(context, "error.wrong_email_password"),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  if (result.loading)
                    Column(
                      children: <Widget>[SizedBox(height: 25.0), CircularProgressIndicator()],
                    ),
                  SizedBox(
                    height: 35.0,
                  ),
                  loginButton(context, style,
                      onPressed:
                          result.loading ? null : () => runMutation({"username": txtCtrlEmail.text, "password": txtCtrlPassword.text})),
                  SizedBox(
                    height: 35.0,
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => new RegisterPage()));
                    },
                    child: Center(
                      child: Text(FlutterI18n.translate(context, "register_propose" ),textAlign: TextAlign.center)
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      onCompleted: (dynamic resultData) {
        // if login ok
        print(resultData.toString());
        if (resultData != null) {
          Map data = resultData["login"];

          User user = User((b) => b
            ..id = data['user']['id']
            ..email = data['user']['email']
            ..username = data['user']['username']);
          PreferenceService.user = user;
          PreferenceService.token = data['token'];
          Navigator.pushReplacement(this.context, new MaterialPageRoute(builder: (context) => new HomePage()));
        }
      },
    );
  }
}

Widget field(
    {@required BuildContext context,
    @required String hintTextKey,
    TextStyle style,
    TextEditingController txtCtrl,
    TextInputType textInputType,
    bool obscureText = false}) {
  return TextField(
    obscureText: obscureText,
    style: style,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: FlutterI18n.translate(context, hintTextKey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    keyboardType: textInputType,
    controller: txtCtrl,
  );
}

Widget loginButton(BuildContext context, TextStyle style, {Function onPressed}) {
  return Material(
    borderRadius: BorderRadius.circular(30.0),
    elevation: 5.0,
    child: Container(
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
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onPressed,
        child: Text(FlutterI18n.translate(context, "login"),
            textAlign: TextAlign.center, style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}

Widget registerButton(BuildContext context, TextStyle style, {Function onPressed}) {
  return Material(
    borderRadius: BorderRadius.circular(30.0),
    elevation: 5.0,
    child: Container(
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
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onPressed,
        child: Text(FlutterI18n.translate(context, "register"),
            textAlign: TextAlign.center, style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}

