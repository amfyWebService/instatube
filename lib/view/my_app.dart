import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/core/Config.dart';
import 'package:instatube/core/utils/preference_service.dart';
import 'package:instatube/view/home_page.dart';
import 'package:instatube/view/login_page.dart';

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
              title: Config.of(context).appName,
              localizationsDelegates: [
                FlutterI18nDelegate(useCountryCode: false, fallbackFile: "en", path: "assets/i18n"),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              theme: ThemeData(),
              home: GestureDetector(
                onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
                child: PreferenceService.isLogged ? HomePage() : LoginPage(),
              )),
        ));
  }
}
