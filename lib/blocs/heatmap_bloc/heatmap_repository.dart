import 'package:specvuz_gesture_interceptor/models/heat_model.dart';
import 'package:specvuz_gesture_interceptor/utils/database.dart';

class HeatMapRepository {
  final DatabaseHelper _helper = DatabaseHelper();

  Future<List<HeatModel>?> getClickRecords(
    String packageName,
    DateTime dateTime,
  ) async {
    final models = await _helper.getHeatMapOfPackage(packageName, dateTime.millisecondsSinceEpoch);
    if (models != null) {
      return models.map((e) => HeatModel.fromMap(e)).toList();
    }
    return null;
  }

  Future<HeatModel?> createHeatModel(HeatModel heatModel) async {
    final model = await _helper.createHeatModel(heatModel.toMap());
    if (model != 0) return heatModel;
    return null;
  }

  Future<List<String>?> getPackagesList() async {
    final list = await _helper.getDistinctPackages();
    return list.map((e) => e['package_name'].toString()).toList();
  }

  Future<List<Map<String, dynamic>>?> getMostPopularApplications() async {
    final list = await _helper.getMostPopularApplications();
    return list.map((e) => Map<String, dynamic>.of(e)).toList();
  }
}
