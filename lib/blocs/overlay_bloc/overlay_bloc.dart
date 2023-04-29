import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

part 'overlay_event.dart';

part 'overlay_state.dart';

class OverlayBloc extends Bloc<OverlayEvent, OverlayState> {
  OverlayBloc() : super(OverlayInitial()) {
    on<StartGestureInterceptor>(_onStartGestureInterceptor);
    on<CloseGestureInterceptor>(_onCloseGestureInterceptor);
    on<RequestInterceptorPermission>(_onRequestInterceptorPermission);
  }

  FutureOr<void> _onRequestInterceptorPermission(
    RequestInterceptorPermission event,
    Emitter<OverlayState> emit,
  ) async {
    await FlutterOverlayWindow.requestPermission();
  }

  FutureOr<void> _onStartGestureInterceptor(
    StartGestureInterceptor event,
    Emitter<OverlayState> emit,
  ) async {
    if (await FlutterOverlayWindow.isActive()) return;
    await FlutterOverlayWindow.showOverlay(
      enableDrag: false,
      flag: OverlayFlag.defaultFlag,
      alignment: OverlayAlignment.centerLeft,
      visibility: NotificationVisibility.visibilitySecret,
      positionGravity: PositionGravity.none,
      height: WindowSize.fullCover,
      width: WindowSize.fullCover,
    );
  }

  FutureOr<void> _onCloseGestureInterceptor(
    CloseGestureInterceptor event,
    Emitter<OverlayState> emit,
  ) async {
    await FlutterOverlayWindow.closeOverlay();
  }
}
