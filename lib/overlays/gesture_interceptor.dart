import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:specvuz_gesture_interceptor/blocs/heatmap_bloc/heatmap_bloc.dart';
import 'package:specvuz_gesture_interceptor/blocs/screenshot_bloc/screenshot_bloc.dart';
import 'package:specvuz_gesture_interceptor/models/heat_model.dart';

class GestureInterceptor extends StatefulWidget {
  const GestureInterceptor({Key? key}) : super(key: key);

  @override
  State<GestureInterceptor> createState() => _GestureInterceptorState();
}

class _GestureInterceptorState extends State<GestureInterceptor> {
  String? _currentPackage;
  String? _currentWindowType;

  @override
  void initState() {
    FlutterAccessibilityService.accessStream.listen((event) {
      _currentWindowType = event.windowType.toString();
      _currentPackage = event.packageName;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HeatmapBloc>(
          create: (_) => HeatmapBloc(),
        ),
        BlocProvider(
          create: (context) => ScreenshotBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final bloc = context.read<HeatmapBloc>();
          final screenBloc = context.read<ScreenshotBloc>();
          return Material(
            elevation: 0.0,
            color: Colors.transparent,
            child: GestureDetector(
              // onPanUpdate: (details) async {
              //   _updateFlagState(duration: const Duration(seconds: 1));
              // },
              onTapDown: (position) async {
                final location = position.globalPosition;
                final package = _currentPackage;
                if (package != null && _currentWindowType != 'WindowType.typeSystem') {
                  final model = HeatModel(
                    package: package ?? 'null',
                    dx: location.dx,
                    dy: location.dy,
                    clickTime: DateTime.now(),
                  );
                  bloc.add(AddHeatMap(model));
                  screenBloc.add(CreateScreenshot(_currentPackage));
                }
                log('Current Location: ${location.dx} ${location.dy}\nCurrent Package: $package');
                _clickOnCoordinates(location);
                _updateFlagState(duration: const Duration(milliseconds: 400));
              },
            ),
          );
        },
      ),
    );
  }

  void _updateFlagState({required Duration duration}) async {
    await FlutterOverlayWindow.updateFlag(OverlayFlag.clickThrough);
    Future.delayed(
      duration,
      () async {
        await FlutterOverlayWindow.updateFlag(OverlayFlag.defaultFlag);
      },
    );
  }

  void _clickOnCoordinates(position) {
    final result = HitTestResult();
    WidgetsBinding.instance.hitTest(result, position);
    for (HitTestEntry tapResult in result.path) {
      tapResult.target
          .handleEvent(PointerDownEvent(position: position), tapResult);
      tapResult.target
          .handleEvent(PointerUpEvent(position: position), tapResult);
    }
  }
}
