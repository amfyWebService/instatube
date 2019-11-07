import 'dart:convert';

import 'package:instatube/core/model/serializers.dart';
import 'package:instatube/core/model/user.dart';
import 'package:preferences/preference_service.dart';

class PreferenceService {
  static const KEY_AUTH_TOKEN = "auth_token";
  static const KEY_AUTH_USER = "auth_user";

  static String get token {
    return PrefService.getString(KEY_AUTH_TOKEN);
  }

  static get isLogged => token?.isNotEmpty ?? false;

  static set token(String token) {
    return PrefService.setString(KEY_AUTH_TOKEN, token);
  }

  static User get user {
    String userJsonString = PrefService.getString(KEY_AUTH_USER);
    if (userJsonString == null) {
      return null;
    }

    return serializers.deserialize(jsonDecode(userJsonString)) as User;
  }

  static set user(User user) {
    PrefService.setString(KEY_AUTH_USER, jsonEncode(serializers.serialize(user)));
  }
}
