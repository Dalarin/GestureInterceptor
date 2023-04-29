part of 'overlay_bloc.dart';

abstract class OverlayEvent extends Equatable {
  const OverlayEvent();

  @override
  List<Object> get props => [];
}

class StartGestureInterceptor extends OverlayEvent {}

class CloseGestureInterceptor extends OverlayEvent {}

class RequestInterceptorPermission extends OverlayEvent {}
