class HeatModel {
  int? id;
  String package;
  double dx;
  double dy;
  DateTime clickTime;

  HeatModel({
    this.id,
    required this.package,
    required this.dx,
    required this.dy,
    required this.clickTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeatModel &&
          runtimeType == other.runtimeType &&
          id == other.id);

  @override
  int get hashCode => id.hashCode ^ package.hashCode ^ clickTime.hashCode;

  @override
  String toString() {
    return 'HeatModel{ id: $id, package: $package, clickTime: $clickTime,}';
  }

  HeatModel copyWith({
    int? id,
    String? package,
    double? dx,
    double? dy,
    DateTime? clickTime,
  }) {
    return HeatModel(
      id: id ?? this.id,
      package: package ?? this.package,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      clickTime: clickTime ?? this.clickTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'package_name': package,
      'dx': dx,
      'dy': dy,
      'click_time': clickTime.millisecondsSinceEpoch,
    };
  }

  factory HeatModel.fromMap(Map<String, dynamic> map) {
    return HeatModel(
      id: map['id'] as int,
      package: map['package_name'] as String,
      dx: map['dx'] as double,
      dy: map['dy'] as double,
      clickTime: DateTime.fromMillisecondsSinceEpoch(map['click_time']),
    );
  }

//</editor-fold>
}
