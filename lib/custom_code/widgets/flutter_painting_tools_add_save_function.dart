// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow importsRenderRepaintBoundaryB

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_painting_tools/flutter_painting_tools.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui; // 导入 ui 包
import 'dart:typed_data';

class FlutterPaintingToolsAddSaveFunction extends StatefulWidget {
  const FlutterPaintingToolsAddSaveFunction({
    Key? key,
    this.width,
    this.height,
    this.url,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? url;

  @override
  _FlutterPaintingToolsAddSaveFunctionState createState() =>
      _FlutterPaintingToolsAddSaveFunctionState();
}

class _FlutterPaintingToolsAddSaveFunctionState
    extends State<FlutterPaintingToolsAddSaveFunction> {
  late final PaintingBoardController controller;
  final GlobalKey _boardKey = GlobalKey();

  @override
  void initState() {
    controller = PaintingBoardController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void saveImage() async {
    RenderRepaintBoundary boundary =
        _boardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    Uint8List uint8List = byteData!.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(uint8List);

    if (result != null && result.isNotEmpty) {
      print('Image saved successfully at: $result');
    } else {
      print('Image not saved.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
        actions: [
          IconButton(
            onPressed: () => controller.deleteLastLine(),
            icon: const Icon(Icons.undo_rounded),
          ),
          IconButton(
            onPressed: () => controller.deletePainting(),
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: saveImage,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          PaintingColorBar(
            controller: controller,
            paintingColorBarMargin: const EdgeInsets.symmetric(horizontal: 6),
            colorsType: ColorsType.material,
            onTap: (Color color) {
              print('tapped color: $color');
              controller.changeBrushColor(color);
            },
          ),
          const SizedBox(height: 50),
          Center(
            child: RepaintBoundary(
              key: _boardKey,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.url ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
                child: PaintingBoard(
                  boardHeight: 600,
                  boardWidth: 800,
                  controller: controller,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
