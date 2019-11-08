//class Video
//{
//  String filename;
//  String id;
//  String description;
//  String title;
//  Video(String filename, String id, String description, String title)
//  {
//    this.filename = filename;
//    this.id = id;
//    this.description = description;
//    this.title = title;
//  }
//
//  String getVideoLink()
//  {
//    return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
//  }
//}

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:instatube/core/Config.dart';

part 'video.g.dart';

abstract class Video implements Built<Video, VideoBuilder> {
  static Serializer<Video> get serializer => _$videoSerializer;

  String get id;

  String get title;

  String get description;

  String get filename;

  Video._();
  factory Video([void Function(VideoBuilder) updates]) = _$Video;

  static String getLink(widgets.BuildContext context, Map<String, dynamic> video) {
    return Config.of(context).apiBaseUrl + "/videos/file/${video['user_id']}/${video['filename']}";
  }

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
