part of 'heatmap_bloc.dart';

abstract class HeatmapEvent extends Equatable {
  const HeatmapEvent();

  @override
  List<Object> get props => [];
}

class GetPackageList extends HeatmapEvent {}

class GetMostUsedApplications extends HeatmapEvent {}

class GetHeatMapsByPackage extends HeatmapEvent {
  final String packageName;
  final DateTime dateTime;

  const GetHeatMapsByPackage(this.packageName, this.dateTime);
}

class AddHeatMap extends HeatmapEvent {
  final HeatModel model;

  const AddHeatMap(this.model);


}