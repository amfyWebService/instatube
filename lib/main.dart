import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/core/Config.dart';
import 'package:instatube/core/utils/preference_service.dart';
import 'package:instatube/view/my_app.dart';
import 'package:preferences/preferences.dart';

void main() async {
  final String apiBaseUrl = "http://localhost:3000";

  await PrefService.init(prefix: 'pref_');

  final HttpLink httpLink = HttpLink(
    uri: '$apiBaseUrl/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: () => 'Bearer ${PreferenceService.token}',
  );

  var graphQlClient = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: authLink.concat(httpLink),
    ),
  );

  var configuredApp = Config(
    env: "Development",
    appName: "Instatube Dev",
    apiBaseUrl: apiBaseUrl,
    child: MyApp(graphQlClient: graphQlClient),
  );

  runApp(configuredApp);
}

//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//        onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
//        child: Scaffold(
//          backgroundColor: Colors.white,
//          appBar: AppBar(
//            title: Text(FlutterI18n.translate(context, "app_name")),
//            flexibleSpace: Container(
//              decoration: BoxDecoration(
//                gradient: LinearGradient(
//                  begin: Alignment.centerLeft,
//                  end: Alignment.centerRight,
//                  colors: <Color>[
//                    Color(0xFF5E0075),
//                    Color(0xFFFC0002),
//                    Color(0xFFFFAD00),
//                  ],
//                ),
//              ),
//            ),
//          ),
//          body: LoginPage(),
//        ));
//  }
//}
