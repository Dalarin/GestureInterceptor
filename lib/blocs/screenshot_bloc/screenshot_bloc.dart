import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

part 'screenshot_event.dart';

part 'screenshot_state.dart';

class ScreenshotBloc extends Bloc<ScreenshotEvent, ScreenshotState> {

  ScreenshotBloc() : super(ScreenshotInitial()) {
    on<CreateScreenshot>(_onCreateScreenshot);
  }

  FutureOr<void> _onCreateScreenshot(
    CreateScreenshot event,
    Emitter<ScreenshotState> emit,
  ) async {
    try {
      final package = event.packageName;
      if (package != null) {
        final exists = await _checkIfScreenshotAlreadyExist(package);
        if (exists) return;
        final directory = await getApplicationDocumentsDirectory();
      }
    } on Exception {}
  }

  Future<bool> _checkIfScreenshotAlreadyExist(String fileName) async {
    var syncPath = await getApplicationDocumentsDirectory();
    var path = '${syncPath.path}/$fileName.png';
    return File(path).existsSync();
  }
}
