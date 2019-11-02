import 'dart:io';

import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:instatube/core/utils/PreferenceService.dart';
import 'package:instatube/core/utils/exceptions.dart';
import 'package:path/path.dart' as path;

class VideoService {
  Future<String> uploadVideo(File file) async {
    if (!file.existsSync()) throw FileNotFoundException();

    final uploader = FlutterUploader();
    final filename = path.basename(file.path);

    return await uploader.enqueue(
        url: "http://10.0.2.2:3000/videos/upload",
        //required: url to upload to
        files: [FileItem(filename: filename, savedDir: path.dirname(file.path), fieldname: "video")],
        // required: list of files that you want to upload
        method: UploadMethod.POST,
        // HTTP method  (POST or PUT or PATCH)
        headers: {"authorization": "Bearer ${PreferenceService.token}"},
        // any data you want to send in upload request
        showNotification: true,
        // send local notification (android only) for upload status
        tag: filename // unique tag for upload task
        );
  }
}
