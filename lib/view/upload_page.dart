import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/view/home_page.dart';
import 'package:instatube/widgets/my_app_bar.dart';
import 'package:instatube/widgets/text_i18n.dart';

class UploadPage extends StatefulWidget {
  final String value;

  UploadPage(r, {Key key, this.value}) : super(key: key);
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _fileNameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final String title = "upload_video";

  @override
  Widget build(BuildContext context) {
    String createVideo = """
      mutation CreateVideo(\$data: VideoInput!) {
        createVideo(data: \$data) {
            id
            title
            filename
          }
        }
      }
    """;
    return Mutation(
      options: MutationOptions(document: createVideo),
      builder: (RunMutation runMutation, QueryResult result) {
        return Scaffold(
          appBar: MyAppBar(
            title: TextI18n(context, title),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _descriptionCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _titleCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: widget.value,
                  controller: _fileNameCtrl,
                  enabled: false,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                if (result.loading)
                  Column(
                    children: <Widget>[
                      SizedBox(height: 25.0),
                      CircularProgressIndicator()
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate() &&
                          (result.loading != null)) {
                        // If the form is valid, display a Snackbar.
                        runMutation({
                          "data": {
                            "title": _titleCtrl,
                            "description": _descriptionCtrl,
                            "filename": _fileNameCtrl
                          }
                        });
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onCompleted: (dynamic resultData) {
        print(resultData.toString());
        AlertDialog(
            title: new Text("Info"),
            content: new Text("Success!"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.pushReplacement(this.context, new MaterialPageRoute(builder: (context) => new HomePage()));
                },
              ),
            ]);
      },
    );
  }
}
