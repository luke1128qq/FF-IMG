// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_painting_tools/flutter_painting_tools.dart';

class FlutterPaintingTools130 extends StatefulWidget {
  const FlutterPaintingTools130({Key? key, this.width, this.height, this.url})
      : super(key: key);

  final double? width;
  final double? height;
  final String? url;

  @override
  _FlutterPaintingTools130State createState() =>
      _FlutterPaintingTools130State();
}

class _FlutterPaintingTools130State extends State<FlutterPaintingTools130> {
  late final PaintingBoardController controller;

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
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.url ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
              child: PaintingBoard(
                boardHeight: 500,
                boardWidth: 600,
                controller: controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
