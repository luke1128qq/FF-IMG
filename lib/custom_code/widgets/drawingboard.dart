// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';

// 建構工具列的引入
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_drawing_board/src/drawing_controller.dart';
import 'package:flutter_drawing_board/src/helper/ex_value_builder.dart';
import 'package:flutter_drawing_board/src/helper/get_size.dart';
import 'package:flutter_drawing_board/src/paint_contents/eraser.dart';
import 'package:flutter_drawing_board/src/paint_contents/simple_line.dart';
import 'package:flutter_drawing_board/src/painter.dart';

final List<Map<String, dynamic>> tData = <Map<String, dynamic>>[
  <String, dynamic>{
    'type': 'SimpleLine',
    'path': <String, dynamic>{
      'fillType': 0,
      'steps': <Map<String, dynamic>>[
        <String, dynamic>{'type': 'moveTo', 'x': 163.0, 'y': 122.0},
        // ... (省略部分步骤)
        <String, dynamic>{'type': 'lineTo', 'x': 304.0, 'y': 191.0}
      ]
    },
    'paint': <String, dynamic>{
      'blendMode': 3,
      'color': 4294198070,
      'filterQuality': 3,
      'invertColors': false,
      'isAntiAlias': false,
      'strokeCap': 1,
      'strokeJoin': 1,
      'strokeWidth': 33.375,
      'style': 1
    }
  },
  // 添加更多绘图数据
];

const Map<String, dynamic> _testLine1 = <String, dynamic>{
  'type': 'StraightLine',
  'startPoint': <String, dynamic>{
    'dx': 68.94337550070736,
    'dy': 62.05980083656557
  },
  'endPoint': <String, dynamic>{
    'dx': 277.1373386828114,
    'dy': 277.32029957032194
  },
  'paint': <String, dynamic>{
    'blendMode': 3,
    'color': 4294198070,
    'filterQuality': 3,
    'invertColors': false,
    'isAntiAlias': false,
    'strokeCap': 1,
    'strokeJoin': 1,
    'strokeWidth': 4.0,
    'style': 1
  }
};

const Map<String, dynamic> _testLine2 = <String, dynamic>{
  'type': 'StraightLine',
  'startPoint': <String, dynamic>{
    'dx': 106.35164817830423,
    'dy': 255.9575653134524
  },
  'endPoint': <String, dynamic>{
    'dx': 292.76034659254094,
    'dy': 92.125586665872
  },
  'paint': <String, dynamic>{
    'blendMode': 3,
    'color': 4294198070,
    'filterQuality': 3,
    'invertColors': false,
    'isAntiAlias': false,
    'strokeCap': 1,
    'strokeJoin': 1,
    'strokeWidth': 4.0,
    'style': 1
  }
};

class Drawingboard extends StatefulWidget {
  const Drawingboard({
    Key? key,
    this.width,
    this.height,
    this.url,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? url;

  @override
  _DrawingboardState createState() => _DrawingboardState();
}

// 新引入的建構工具列程式碼
/// 默认工具栏构建器
typedef DefaultToolsBuilder = List<DefToolItem> Function(
  Type currType,
  DrawingController controller,
);

/// 画板
class DrawingBoard extends StatefulWidget {
  Color selectedColor;

  DrawingBoard({
    super.key,
    required this.background,
    this.controller,
    this.showDefaultActions = false,
    this.showDefaultTools = false,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    this.clipBehavior = Clip.antiAlias,
    this.defaultToolsBuilder,
    this.boardClipBehavior = Clip.hardEdge,
    this.panAxis = PanAxis.free,
    this.boardBoundaryMargin,
    this.boardConstrained = false,
    this.maxScale = 20,
    this.minScale = 0.2,
    this.boardPanEnabled = true,
    this.boardScaleEnabled = true,
    this.boardScaleFactor = 200.0,
    this.onInteractionEnd,
    this.onInteractionStart,
    this.onInteractionUpdate,
    this.transformationController,
    this.alignment = Alignment.topCenter,
    this.selectedColor = Colors.red,
  });

  /// 画板背景控件
  final Widget background;

  /// 画板控制器
  final DrawingController? controller;

  /// 显示默认样式的操作栏
  final bool showDefaultActions;

  /// 显示默认样式的工具栏
  final bool showDefaultTools;

  /// 开始拖动
  final Function(PointerDownEvent pde)? onPointerDown;

  /// 正在拖动
  final Function(PointerMoveEvent pme)? onPointerMove;

  /// 结束拖动
  final Function(PointerUpEvent pue)? onPointerUp;

  /// 边缘裁剪方式
  final Clip clipBehavior;

  /// 默认工具栏构建器
  final DefaultToolsBuilder? defaultToolsBuilder;

  /// 缩放板属性
  final Clip boardClipBehavior;
  final PanAxis panAxis;
  final EdgeInsets? boardBoundaryMargin;
  final bool boardConstrained;
  final double maxScale;
  final double minScale;
  final void Function(ScaleEndDetails)? onInteractionEnd;
  final void Function(ScaleStartDetails)? onInteractionStart;
  final void Function(ScaleUpdateDetails)? onInteractionUpdate;
  final bool boardPanEnabled;
  final bool boardScaleEnabled;
  final double boardScaleFactor;
  final TransformationController? transformationController;
  final AlignmentGeometry alignment;

  /// 默认工具项列表
  static List<DefToolItem> defaultTools(
      Type currType, DrawingController controller) {
    return <DefToolItem>[
      DefToolItem(
          isActive: currType == SimpleLine,
          icon: CupertinoIcons.pencil,
          onTap: () => controller.setPaintContent(SimpleLine())),
      DefToolItem(
          isActive: currType == Eraser,
          icon: CupertinoIcons.bandage,
          onTap: () => controller.setPaintContent(Eraser(color: Colors.white))),
    ];
  }

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  // 绘制控制器
  final DrawingController _drawingController = DrawingController();

  // 获取画板数据 `getImageData()`
  Future<void> _getImageData() async {
    final Uint8List? data =
        (await _drawingController.getImageData())?.buffer.asUint8List();
    if (data == null) {
      debugPrint('獲取圖片資料失敗');
      return;
    }

    if (mounted) {
      showDialog<void>(
        context: context,
        builder: (BuildContext c) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pop(c),
              child: Image.memory(data),
            ),
          );
        },
      );
    }
  }

  late final DrawingController _controller =
      widget.controller ?? DrawingController();

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = InteractiveViewer(
      maxScale: widget.maxScale,
      minScale: widget.minScale,
      boundaryMargin: widget.boardBoundaryMargin ??
          EdgeInsets.all(MediaQuery.of(context).size.width),
      clipBehavior: widget.boardClipBehavior,
      panAxis: widget.panAxis,
      constrained: widget.boardConstrained,
      onInteractionStart: widget.onInteractionStart,
      onInteractionUpdate: widget.onInteractionUpdate,
      onInteractionEnd: widget.onInteractionEnd,
      scaleFactor: widget.boardScaleFactor,
      panEnabled: widget.boardPanEnabled,
      scaleEnabled: widget.boardScaleEnabled,
      transformationController: widget.transformationController,
      child: Align(alignment: widget.alignment, child: _buildBoard),
    );

    if (widget.showDefaultActions || widget.showDefaultTools) {
      content = Column(
        children: <Widget>[
          Expanded(child: content),
          if (widget.showDefaultActions) _buildDefaultActions,
          if (widget.showDefaultTools) _buildDefaultTools,
        ],
      );
    }

    return Listener(
      onPointerDown: (PointerDownEvent pde) =>
          _controller.addFingerCount(pde.localPosition),
      onPointerUp: (PointerUpEvent pue) =>
          _controller.reduceFingerCount(pue.localPosition),
      child: content,
    );
  }

  /// 构建画板
  Widget get _buildBoard {
    return RepaintBoundary(
      key: _controller.painterKey,
      child: ExValueBuilder<DrawConfig>(
        valueListenable: _controller.drawConfig,
        shouldRebuild: (DrawConfig p, DrawConfig n) =>
            p.angle != n.angle || p.size != n.size,
        builder: (_, DrawConfig dc, Widget? child) {
          Widget c = child!;

          if (dc.size != null) {
            final bool isHorizontal = dc.angle.toDouble() % 2 == 0;
            final double max = dc.size!.longestSide;

            if (!isHorizontal) {
              c = SizedBox(
                width: max,
                height: max,
                child: c,
              );
            }
          }

          return Transform.rotate(
            angle: dc.angle * pi / 2,
            child: c,
          );
        },
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[_buildImage, _buildPainter],
          ),
        ),
      ),
    );
  }

  /// 构建背景
  Widget get _buildImage => GetSize(
        onChange: (Size? size) => _controller.setBoardSize(size),
        child: widget.background,
      );

  /// 构建绘制层
  Widget get _buildPainter {
    return ExValueBuilder<DrawConfig>(
      valueListenable: _controller.drawConfig,
      shouldRebuild: (DrawConfig p, DrawConfig n) => p.size != n.size,
      builder: (_, DrawConfig dc, Widget? child) {
        return SizedBox(
          width: dc.size?.width,
          height: dc.size?.height,
          child: child,
        );
      },
      child: Painter(
        drawingController: _controller,
        onPointerDown: widget.onPointerDown,
        onPointerMove: widget.onPointerMove,
        onPointerUp: widget.onPointerUp,
      ),
    );
  }

  /// 构建默认操作栏
  Widget get _buildDefaultActions {
    return Container(
      // Wrap the actions with a Container
      width: 500, // Set the desired width
      child: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          child: Row(
            children: <Widget>[
              DropdownButton<Color>(
                value: widget.selectedColor, // 当前所选颜色
                onChanged: (Color? newColor) {
                  if (newColor != null) {
                    setState(() {
                      widget.selectedColor = newColor;
                    });
                    _controller.setStyle(color: newColor); // 设置所选颜色
                  }
                },
                items: <DropdownMenuItem<Color>>[
                  DropdownMenuItem(
                    value: Colors.black,
                    child: Text("黑"),
                  ),
                  DropdownMenuItem(
                    value: Colors.red,
                    child: Text("紅"),
                  ),
                  DropdownMenuItem(
                    value: Colors.blue,
                    child: Text("藍"),
                  ),
                  DropdownMenuItem(
                    value: Colors.yellow,
                    child: Text("黄"),
                  ),
                ],
              ),

              SizedBox(
                height: 24,
                width: 160,
                child: ExValueBuilder<DrawConfig>(
                  valueListenable: _controller.drawConfig,
                  shouldRebuild: (DrawConfig p, DrawConfig n) =>
                      p.strokeWidth != n.strokeWidth,
                  builder: (_, DrawConfig dc, ___) {
                    return Slider(
                      value: dc.strokeWidth,
                      max: 50,
                      min: 1,
                      onChanged: (double v) =>
                          _controller.setStyle(strokeWidth: v),
                    );
                  },
                ),
              ),
              // 工具栏
              ExValueBuilder<DrawConfig>(
                valueListenable: _controller.drawConfig,
                shouldRebuild: (DrawConfig p, DrawConfig n) =>
                    p.contentType != n.contentType,
                builder: (_, DrawConfig dc, ___) {
                  final Type currType = dc.contentType;
                  return Row(
                    children: (widget.defaultToolsBuilder
                                ?.call(currType, _controller) ??
                            DrawingBoard.defaultTools(currType, _controller))
                        .map((DefToolItem item) =>
                            _DefToolItemWidget(item: item))
                        .toList(),
                  );
                },
              ),

              IconButton(
                  icon: const Icon(CupertinoIcons.arrow_turn_up_left),
                  onPressed: () => _controller.undo()),
              IconButton(
                  icon: const Icon(CupertinoIcons.arrow_turn_up_right),
                  onPressed: () => _controller.redo()),
              IconButton(
                  icon: const Icon(CupertinoIcons.trash),
                  onPressed: () => _controller.clear()),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _getImageData,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建默认工具栏
  Widget get _buildDefaultTools {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        child: ExValueBuilder<DrawConfig>(
          valueListenable: _controller.drawConfig,
          shouldRebuild: (DrawConfig p, DrawConfig n) =>
              p.contentType != n.contentType,
          builder: (_, DrawConfig dc, ___) {
            final Type currType = dc.contentType;

            return Row(
              children:
                  (widget.defaultToolsBuilder?.call(currType, _controller) ??
                          DrawingBoard.defaultTools(currType, _controller))
                      .map((DefToolItem item) => _DefToolItemWidget(item: item))
                      .toList(),
            );
          },
        ),
      ),
    );
  }
}

/// 默认工具项配置文件
class DefToolItem {
  DefToolItem({
    required this.icon,
    required this.isActive,
    this.onTap,
    this.color,
    this.activeColor = Colors.blue,
    this.iconSize,
  });

  final Function()? onTap;
  final bool isActive;

  final IconData icon;
  final double? iconSize;
  final Color? color;
  final Color activeColor;
}

/// 默认工具项 Widget
class _DefToolItemWidget extends StatelessWidget {
  const _DefToolItemWidget({
    required this.item,
  });

  final DefToolItem item;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: item.onTap,
      icon: Icon(
        item.icon,
        color: item.isActive ? item.activeColor : item.color,
        size: item.iconSize,
      ),
    );
  }
}

class _DrawingboardState extends State<Drawingboard> {
  // 绘制控制器
  final DrawingController _drawingController = DrawingController();

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  // 获取画板内容 Json `getJsonList()`
  Future<void> _getJson() async {
    showDialog<void>(
      context: context,
      builder: (BuildContext c) {
        return Center(
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => Navigator.pop(c),
              child: Container(
                constraints:
                    const BoxConstraints(maxWidth: 500, maxHeight: 800),
                padding: const EdgeInsets.all(20.0),
                child: SelectableText(
                  const JsonEncoder.withIndent('  ')
                      .convert(_drawingController.getJsonList()),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 添加Json测试内容
  void _addTestLine() {
    _drawingController.addContent(StraightLine.fromJson(_testLine1));
    _drawingController
        .addContents(<PaintContent>[StraightLine.fromJson(_testLine2)]);
    _drawingController.addContent(SimpleLine.fromJson(tData[0]));
    // 添加更多绘图数据
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return DrawingBoard(
                  boardPanEnabled: false,
                  boardScaleEnabled: false,
                  controller: _drawingController,
                  background: Container(
                    width: 800,
                    height: 600,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.url ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  showDefaultActions: true,
                  showDefaultTools: false,
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SelectableText(
              'https://github.com/fluttercandies/flutter_drawing_board',
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
