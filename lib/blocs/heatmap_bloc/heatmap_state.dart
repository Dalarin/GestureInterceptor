part of 'heatmap_bloc.dart';

abstract class HeatmapState extends Equatable {
  const HeatmapState();

  @override
  List<Object> get props => [];
}

class HeatMapLoading extends HeatmapState {}

class HeatMapsLoaded extends HeatmapState {
  final Uint8List page;

  const HeatMapsLoaded(this.page);

  @override
  List<Object> get props => [page];
}

class PackagesLoaded extends HeatmapState {
  final List<String> packages;

  const PackagesLoaded(this.packages);
}

class MostPopularApplicationsLoaded extends HeatmapState {
  final List<Map<String, dynamic>> applications;

  const MostPopularApplicationsLoaded(this.applications);
}

class HeatMapFailure extends HeatmapState {}
