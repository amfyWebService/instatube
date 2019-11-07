import 'package:flutter/widgets.dart';

@immutable
class Config extends InheritedWidget {
  final String env;
  final String appName;
  final String apiBaseUrl;

  Config({@required this.env, @required this.appName, @required this.apiBaseUrl, @required Widget child}) : super(child: child);

  static Config of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(Config);
  }

  bool get isDev => this.env == "Development"; // Dev in emulator
  bool get isProd => this.env == "Production"; // Production app store
  bool get isStaging => this.env == "Staging"; // Dev in real device

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
