import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/core/utils/PreferenceService.dart';
import 'package:instatube/view/login_page.dart';
import 'package:instatube/widgets/drawer.dart';
import 'package:preferences/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PrefService.init(prefix: 'pref_');

  final HttpLink httpLink = HttpLink(
    uri: 'http://10.0.2.2:3000/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: () => 'Bearer ${PreferenceService.token}',
  );

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> gqlClient = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    ),
  );

  runApp(MyApp(graphQlClient: gqlClient));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> graphQlClient;

  MyApp({this.graphQlClient});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: this.graphQlClient,
        child: CacheProvider(
          child: MaterialApp(
            title: "Instatube",
            localizationsDelegates: [
              FlutterI18nDelegate(useCountryCode: false, fallbackFile: "en", path: "assets/i18n"),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            theme: ThemeData(),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    FlutterI18n.refresh(context, Locale("fr"));
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
          body: LoginPage(),
          drawer: AppDrawer(),
        ));
  }
}
