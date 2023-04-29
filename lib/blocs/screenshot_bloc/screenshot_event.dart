part of 'screenshot_bloc.dart';

abstract class ScreenshotEvent extends Equatable {
  const ScreenshotEvent();

  @override
  List<Object> get props => [];
}

class CreateScreenshot extends ScreenshotEvent {
  final String? packageName;

  const CreateScreenshot(this.packageName);
}
