import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/widgets/app_button.dart';
import 'package:instatube/widgets/my_app_bar.dart';
import 'package:instatube/widgets/text_i18n.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool allFieldsAreSet = false;
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

    return Mutation(
      options: MutationOptions(document: register),
      builder: (RunMutation runMutation, QueryResult result) {
        return Scaffold(
          appBar: MyAppBar(
            title: TextI18n(context, "register"),
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            children: <Widget>[
              SizedBox(height: 45.0),
              _buildField(hintTextKey: "email", textInputType: TextInputType.emailAddress, txtCtrl: txtCtrlEmail),
              SizedBox(height: 25.0),
              _buildField(hintTextKey: "password", obscureText: true, txtCtrl: txtCtrlPassword),
              SizedBox(height: 25.0),
              _buildField(hintTextKey: "repeat_password", obscureText: true, txtCtrl: textCtrlRptPassword),
              SizedBox(height: 25.0),
              Column(children: <Widget>[
                _buildErrorMessage(txtCtrlPassword.text, textCtrlRptPassword.text, txtCtrlEmail.text),
                SizedBox(height: 25.0),
              ]),
              if (result.loading)
                Column(
                  children: <Widget>[SizedBox(height: 25.0), CircularProgressIndicator()],
                ),
              SizedBox(
                height: 35.0,
              ),
              AppButton.text(
                  text: FlutterI18n.translate(context, "register"),
                  style: style,
                  onPressed: result.loading || !allFieldsAreSet
                      ? () => null
                      : () => runMutation({"username": txtCtrlEmail.text, "password": txtCtrlPassword.text})),
//              SizedBox(
//                height: 15.0,
//              ),
            ],
          ),
        );
      },
      onCompleted: (dynamic resultData) {
        // if login ok
        if (resultData != null) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildField({@required String hintTextKey, TextEditingController txtCtrl, TextInputType textInputType, bool obscureText = false}) {
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

  Widget _buildErrorMessage(String txtCtrlPassword, String textCtrlRptPassword, String txtCtrlEmail) {
    if (txtCtrlPassword == "" || textCtrlRptPassword == "" || txtCtrlEmail == "") {
      allFieldsAreSet = false;
      return Text(
        FlutterI18n.translate(context, "set_all_fields"),
        style: TextStyle(color: Colors.black),
      );
    } else if (txtCtrlPassword != textCtrlRptPassword) {
      allFieldsAreSet = false;
      return Text(
        FlutterI18n.translate(context, "different_password_repeat"),
        style: TextStyle(color: Colors.red),
      );
    } else {
      allFieldsAreSet = true;
      return Text("");
    }
  }
}
