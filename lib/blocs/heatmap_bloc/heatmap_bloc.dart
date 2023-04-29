import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heat_map/flutter_heat_map.dart' as package;
import 'package:specvuz_gesture_interceptor/blocs/heatmap_bloc/heatmap_repository.dart';
import 'package:specvuz_gesture_interceptor/models/heat_model.dart';

part 'heatmap_event.dart';

part 'heatmap_state.dart';

class HeatmapBloc extends Bloc<HeatmapEvent, HeatmapState> {
  final _repository = HeatMapRepository();

  HeatmapBloc() : super(HeatMapLoading()) {
    on<GetPackageList>(_onGetPackageList);
    on<GetMostUsedApplications>(_onGetMostUsedApplications);
    on<GetHeatMapsByPackage>(_onGetHeatMapsByPackage);
    on<AddHeatMap>(_onAddHeatMap);
  }

  FutureOr<void> _onGetPackageList(
    GetPackageList event,
    Emitter<HeatmapState> emit,
  ) async {
    emit(HeatMapLoading());
    final packages = await _repository.getPackagesList();
    if (packages != null) {
      emit(PackagesLoaded(packages));
    } else {
      emit(HeatMapFailure());
    }
  }

  FutureOr<void> _onGetMostUsedApplications(
    GetMostUsedApplications event,
    Emitter<HeatmapState> emit,
  ) async {
    emit(HeatMapLoading());
    final records = await _repository.getMostPopularApplications();
    if (records != null) {
      emit(MostPopularApplicationsLoaded(records));
    } else {
      emit(HeatMapFailure());
    }
  }

  FutureOr<void> _onGetHeatMapsByPackage(
    GetHeatMapsByPackage event,
    Emitter<HeatmapState> emit,
  ) async {
    try {
      emit(HeatMapLoading());
      final clickRecords = await _repository.getClickRecords(event.packageName, event.dateTime);
      if (clickRecords != null) {
        final events = _generateEvents(clickRecords);
        if (events != null) {
          final page = await _generateHeatMap(events);
          final uint8 = await package.HeatMap.process(
            page,
            package.HeatMapConfig(
              quantityOfEvent: package.HeatMapQuantityOfEvent(enabled: true),
            ),
          );
          if (uint8 == null) {
            emit(HeatMapFailure());
          } else {
            return emit(HeatMapsLoaded(uint8));
          }
        }
        emit(HeatMapFailure());
      } else {
        emit(HeatMapFailure());
      }
    } on Exception catch (_) {
      emit(HeatMapFailure());
    }
  }

  Future<package.HeatMapPage> _generateHeatMap(
    List<package.HeatMapEvent> events,
  ) async {
    ImageProvider? provider = const AssetImage('assets/images/background.png');
    ui.Image image = await package.HeatMap.imageProviderToUiImage(provider);
    return package.HeatMapPage(image: image, events: events);
  }

  List<package.HeatMapEvent>? _generateEvents(List<HeatModel> model) {
    return List<package.HeatMapEvent>.generate(
      model.length,
      (index) => package.HeatMapEvent(
        location: Offset(model[index].dx, model[index].dy),
      ),
    );
  }

  FutureOr<void> _onAddHeatMap(
    AddHeatMap event,
    Emitter<HeatmapState> emit,
  ) async {
    final heatmap = await _repository.createHeatModel(event.model);
    if (heatmap == null) {
      emit(HeatMapFailure());
    }
  }
}
