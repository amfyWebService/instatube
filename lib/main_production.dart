import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/core/Config.dart';
import 'package:instatube/core/utils/preference_service.dart';
import 'package:instatube/view/my_app.dart';
import 'package:preferences/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final String apiBaseUrl = "http://ec2-52-206-238-206.compute-1.amazonaws.com:8080";

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
    env: "Production",
    appName: "Instatube",
    apiBaseUrl: apiBaseUrl,
    child: MyApp(graphQlClient: graphQlClient),
  );

  runApp(configuredApp);
}
