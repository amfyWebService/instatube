import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instatube/core/utils/exceptions.dart';
import 'package:instatube/core/utils/preference_service.dart';
import 'package:instatube/view/upload_page.dart';
import 'package:path/path.dart' as path;

class VideoService {
  static uploadVideoFromCamera(BuildContext context) async {
    var file = await pickVideoFromCamera();
    if (file == null) return;
    uploadVideo(file, context);
  }

  static uploadVideoFromGalery(BuildContext context) async {
    var file = await pickVideoFromGalery();
    if (file == null) return;
    uploadVideo(file, context);
  }

  static Future<File> pickVideoFromCamera() {
    return ImagePicker.pickVideo(source: ImageSource.camera);
  }

  static Future<File> pickVideoFromGalery() {
    return ImagePicker.pickVideo(source: ImageSource.gallery);
  }

  static Future<String> uploadVideo(File file, BuildContext context) async {
    if (!file.existsSync()) throw FileNotFoundException();
    final uploader = FlutterUploader();
    final filename = path.basename(file.path);

    uploader.progress.listen((progress) => print(progress.progress.toString()));
    uploader.result.listen((UploadTaskResponse result) {
      print("uploaded: ${result.response}");

      Map res = jsonDecode(result.response);
  
      Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPage(res['filename'])));
    }, onError: (error) => print('error upload $error'));
    return await uploader.enqueue(
        url: "http://ec2-52-206-238-206.compute-1.amazonaws.com:8080/videos/upload",
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
