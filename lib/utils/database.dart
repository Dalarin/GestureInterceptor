import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cache.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = '${await getDatabasesPath()}/$filePath';
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database database, int version) async {
    try {
      await database.execute("""
      CREATE TABLE "heat_map_table" (
      "id" INTEGER,
      "package_name" TEXT,
      "dx" REAL,
      "dy" REAL,
      "click_time" INTEGER,
      PRIMARY KEY("id" AUTOINCREMENT)
      ); 
      """);
    } catch (E) {}
  }

  Future<int> createHeatModel(Map<String, dynamic> heat) async {
    final db = await database;
    return await db.insert('heat_map_table', heat);
  }

  Future<List<dynamic>> getDistinctPackages() async {
    final db = await database;
    return await db
        .rawQuery('SELECT DISTINCT package_name FROM heat_map_table');
  }

  Future<List<dynamic>> getMostPopularApplications() async {
    final db = await database;
    return await db.rawQuery(
      'SELECT package_name, COUNT(id) as count FROM heat_map_table GROUP BY package_name ORDER BY count DESC LIMIT 3',
    );
  }
  
  Future<List<Map<String, Object?>>> getNumberOfClicks() async {
    final db = await database;
    return await db.rawQuery('SELECT COUNT(id) from heat_map_table');
  }
  
  Future<List<dynamic>> getClicksByHours() async {
    final db = await database;
    return await db.rawQuery("SELECT COUNT(id) FROM heat_map_table GROUP BY strftime('%H',click_time)");
  }

  Future<List<dynamic>?> getHeatMapOfPackage(String packageName, int milliseconds) async {
    final db = await database;
    return await db.rawQuery(
      'SELECT * FROM heat_map_table WHERE package_name = ? and click_time between ? and ?',
      [packageName, milliseconds - 86400000, milliseconds + 86400000],
    );
  }
}
