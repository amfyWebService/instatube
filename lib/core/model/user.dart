import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {
  static Serializer<User> get serializer => _$userSerializer;

  String get id;

  String get username;

  @nullable
  String get email;

  User._();
  factory User([void Function(UserBuilder) updates]) = _$User;

//  User({this.id, this.username, this.email});
//
//  Map<String, dynamic> toJson() {
//    return {"id": id, "username": username, "email": email};
//  }
//
//  static fromJson(Map<String, dynamic> json) {
//    return User(id: json['id'], username: json['username'], email: json['email']);
//  }
}
