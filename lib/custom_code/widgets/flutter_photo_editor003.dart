// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_photo_editor/flutter_photo_editor.dart';
import 'package:image_picker/image_picker.dart';

class FlutterPhotoEditor003 extends StatefulWidget {
  const FlutterPhotoEditor003({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _FlutterPhotoEditor003State createState() => _FlutterPhotoEditor003State();
}

class _FlutterPhotoEditor003State extends State<FlutterPhotoEditor003> {
  String _platformVersion = 'Unknown';
  final _flutterPhotoEditorPlugin = FlutterPhotoEditor();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterPhotoEditorPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: TextButton(
                onPressed: () {
                  test();
                },
                child: Text("Add photo"),
              ),
            ),
            if (imagePath != null)
              Image.file(
                File(imagePath!),
                width: 300,
                height: 500,
              )
          ],
        ),
      ),
    );
  }

  String? imagePath;

  void test() async {
    print("start");

    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    String? path = image?.path;
    // onImageEdit(path);
    if (path != null) {
      editImage(path);
    }
  }

  void editImage(String path) async {
    print("path: $path");

    var b = await FlutterPhotoEditor().editImage(path);

    setState(() {
      imagePath = path;
    });
    print("end : $b");
  }
}
