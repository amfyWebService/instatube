import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/main.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController txtCtrlEmail = TextEditingController();
  TextEditingController txtCtrlPassword = TextEditingController();
  TextEditingController textCtrlRptPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String register = """
      mutation Register(\$username: String!, \$password: String!) {
        register(username: \$username, password: \$password) {
          token
          user {
            id
            username
          }
        }
      }
    """;

    return GestureDetector(
        onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(FlutterI18n.translate(context, "app_name")),
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
          ),
          body: Mutation(
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
                        SizedBox(height: 25.0),
                        field(
                            hintTextKey: "repeat_password",
                            style: style,
                            context: context,
                            obscureText: true,
                            textInputType: TextInputType.emailAddress,
                            txtCtrl: textCtrlRptPassword),
                        SizedBox(height: 25.0),
                        if (txtCtrlPassword.text != textCtrlRptPassword.text)
                          Column(
                            children: <Widget>[
                              SizedBox(height: 25.0),
                              Text(
                                FlutterI18n.translate(
                                    context, "different_password_repeat"),
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        if (txtCtrlPassword.text == "" ||
                            textCtrlRptPassword.text == "" ||
                            txtCtrlEmail.text == "")
                          Column(
                            children: <Widget>[
                              SizedBox(height: 25.0),
                              Text(
                                FlutterI18n.translate(
                                    context, "set_all_fields"),
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        if (result.loading)
                          Column(
                            children: <Widget>[
                              SizedBox(height: 25.0),
                              CircularProgressIndicator()
                            ],
                          ),
                        SizedBox(
                          height: 35.0,
                        ),
                        registerButton(context, style,
                            onPressed: result.loading
                                ? null
                                : () => runMutation({
                                      "username": txtCtrlEmail.text,
                                      "password": txtCtrlPassword.text
                                    })),
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
              if (resultData != null) {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new MyHomePage()));
              }
            },
          ),
        ));
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

Widget registerButton(BuildContext context, TextStyle style,
    {Function onPressed}) {
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
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}
