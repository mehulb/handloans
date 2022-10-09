import 'package:sqflite/sqflite.dart';
import 'package:handloans/models/constants.dart';

class DataHandler {
  DataHandler._();
  static final DataHandler shared = DataHandler._();

  static var _database;
  static var _dbPath;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await init();
    return _database;
  }

  init() async {
    String dbDirPath = await getDatabasesPath();
    _dbPath = dbDirPath + "/hl.db";
    print(_dbPath);
    // await deleteDatabase(_dbPath);

    return await openDatabase(
        _dbPath,
        version: 1,
        onCreate: (Database db, int version) async {

          await db.execute("""
          CREATE TABLE 
          $tblAccounts (
          $colID TEXT PRIMARY KEY, 
          $colName TEXT,
          $colComments TEXT)
          """);

          await db.execute("""
          CREATE TABLE 
          $tblHandloans (
          $colID TEXT PRIMARY KEY, 
          $colType TEXT,
          $colName TEXT, 
          $colDatetime TEXT,
          $colAmount REAL,
          $colComments TEXT,
          $colAccountID TEXT)
          """);

          await db.execute("""
          CREATE TABLE 
          $tblTransactions (
          $colID TEXT PRIMARY KEY, 
          $colType TEXT,
          $colDatetime TEXT,
          $colAmount REAL,
          $colComments TEXT,
          $colHandloanID TEXT)
          """);
        }
    );
  }

  Future insert({required Map<String, dynamic> map, required String tableName}) async {
    print("INSERT: $map -> $tableName");
    final db = await database;
    int count = await db.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
    print("INSERT: $count record(s) -> $tableName");
  }
  Future<List<Map<String, dynamic>>> fetch({required String tableName, String? key, String? value}) async {
    print("FETCH: [$key: $value] -> $tableName");
    final db = await database;
    if (key != null && value != null) {
      List<Map<String, dynamic>> list = await db.query(tableName, where: "$key = ?", whereArgs: [value]);
      print("FETCH: [${list.length}] record(s) -> $tableName");
      return list;
    } else {
      List<Map<String, dynamic>> list = await db.query(tableName);
      print("FETCH(ALL): [${list.length}] record(s) -> $tableName");
      return list;
    }
  }
  Future update({required Map<String, dynamic> map, required String tableName}) async {
    print("UPDATE: $map -> $tableName");
    final db = await database;
    int count = 0;
    count = await db.update(tableName, map, whereArgs: [map[colID]], where: "$colID = ?");
    print("UPDATE: [$count] record(s) -> $tableName");
  }
  Future delete({required String tableName, required String key, required String value}) async {
    print("DELETE: [$key: $value] -> $tableName");
    final db = await database;
    int count = await db.delete(tableName, where: "$key = ?", whereArgs: [value]);
    print("DELETE: [$count] record(s) -> $tableName");
  }

  Future cleanUp() async {
    print("CLEAN UP");
    final db = await database;
    int count = await db.delete(tblTransactions);
    print("DELETE: $tblTransactions [$count] records");
    count = await db.delete(tblHandloans);
    print("DELETE: $tblHandloans [$count] records");
    count = await db.delete(tblAccounts);
    print("DELETE: $tblAccounts [$count] records");
  }
}