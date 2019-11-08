import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/widgets/app_button.dart';
import 'package:instatube/widgets/my_app_bar.dart';
import 'package:instatube/widgets/text_i18n.dart';

class UploadPage extends StatefulWidget {
  final String filename;

  UploadPage({Key key, @required this.filename}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _fileNameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const String title = "publish_video";

  @override
  void initState() {
    super.initState();
    this._fileNameCtrl.text = this.widget.filename;
  }

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
            key: _scaffoldKey,
            appBar: MyAppBar(
              title: TextI18n(context, title),
            ),
            body: SingleChildScrollView(
                child: SafeArea(
              minimum: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: FlutterI18n.translate(context, "title")),
                      controller: _titleCtrl,
                      validator: (value) {
                        if (value.isEmpty) {
                          return FlutterI18n.translate(context, "form.error.empty");
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: FlutterI18n.translate(context, "description")),
                      controller: _descriptionCtrl,
                      validator: (value) {
                        if (value.isEmpty) {
                          return FlutterI18n.translate(context, "form.error.empty");
                        }
                        return null;
                      },
                    ),
                    if (result.loading)
                      Column(
                        children: <Widget>[SizedBox(height: 25.0), CircularProgressIndicator()],
                      ),
                    SizedBox(
                      height: 25,
                    ),
                    AppButton.text(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          if (_formKey.currentState.validate() && (result.loading != null)) {
                            // If the form is valid, display a Snackbar.
                            runMutation({
                              "data": {
                                "title": _titleCtrl.text,
                                "description": _descriptionCtrl.text,
                                "filename": widget.filename
                              }
                            });
//                              Scaffold.of(context)
//                                  .showSnackBar(SnackBar(content: TextI18n(context, 'sending_in_progress')));
                          }
                        },
                        text: FlutterI18n.translate(context, "publish")),
                  ],
                ),
              ),
            )));
      },
      onCompleted: (dynamic resultData) {
        if (resultData != null) {
//          _scaffoldKey.currentState.showSnackBar(SnackBar(
//            content: TextI18n(context, 'success.published'),
//            backgroundColor: Colors.green,
//          ));
          Navigator.pop(context);
        }
      },
    );
  }
}
