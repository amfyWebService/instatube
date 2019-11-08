import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/core/model/user.dart';
import 'package:instatube/core/utils/preference_service.dart';
import 'package:instatube/view/register_page.dart';
import 'package:instatube/widgets/app_button.dart';
import 'package:instatube/widgets/my_app_bar.dart';
import 'package:instatube/widgets/text_i18n.dart';
import 'package:preferences/preference_service.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key) {
    PrefService.sharedPreferences.clear();
  }

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
        return Scaffold(
            appBar: MyAppBar(
              title: TextI18n(context, "login"),
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
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
                field(
                    hintTextKey: "password",
                    style: style,
                    context: context,
                    obscureText: true,
                    txtCtrl: txtCtrlPassword),
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
                AppButton.text(
                  text: FlutterI18n.translate(context, "login"),
                  onPressed: result.loading
                      ? null
                      : () => runMutation({"username": txtCtrlEmail.text, "password": txtCtrlPassword.text}),
                  style: style,
                ),
                SizedBox(
                  height: 35.0,
                ),
                InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => new RegisterPage())),
                    child: Center(
                      child: Text(FlutterI18n.translate(context, "register_propose"),
                          style: TextStyle(decoration: TextDecoration.underline), textAlign: TextAlign.center),
                    )),
              ],
//              child: Container(
//                child: Padding(
//                  padding: const EdgeInsets.all(36.0),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                    children: <Widget>[
//
//                    ],
//                  ),
//                ),
//              ),
            ));
      },
      onCompleted: (dynamic resultData) {
        // if login ok
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
