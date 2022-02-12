import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "database.db";
  static const _databaseVersion = 1;

  static const tableInventory = 'inventory';
  static const columnItemID = 'inventory_id';
  static const columnCategoryNumbers = 'inventory_categorie_numbers';
  static const columnItemName = 'inventory_item_name';
  static const columnItemCount = 'inventory_item_count';

  static const tableCategories = 'categories';
  static const columnCategoryID = 'category_id';
  static const columnCategoryName = 'category_name';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  initDatabase() async {
    print('_initDatabase');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    print('_onCreate');
    return;
    await db.execute('''
          CREATE TABLE $tableInventory (
            $columnItemID INTEGER PRIMARY KEY,
            $columnCategoryNumbers TEXT NOT NULL,
            $columnItemName TEXT NOT NULL
            $columnItemCount INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableCategories (
            $columnCategoryID INTEGER PRIMARY KEY,
            $columnCategoryName TEXT NOT NULL
          )
          ''');
  }

  void dropTable({required tableName}) async {
    Database db = await instance.database;
    db.rawQuery('DROP TABLE $tableName');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertIntoTable(
      {required String tableName, required Map<String, dynamic> row}) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(
      {required String tableName}) async {
    Database db = await instance.database;
    var result = await db.query(tableName);
    return result;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount({required String tableName}) async {
    print('queryRowCount');
    Database db = await instance.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $tableName'),
    );
  }

  Future<List<Map<String, Object?>>> queryItem(
      {required String tableName,
      required String columnName,
      required int value}) async {
    print('queryItem');
    Database db = await instance.database;
    return await db
        .rawQuery('SELECT * FROM $tableName where $columnName = $value');
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateRow(
      {required String tableName,
      required String columnIdName,
      required Map<String, dynamic> rowData}) async {
    Database db = await instance.database;
    int id = rowData[columnIdName];
    return await db.update(tableName, rowData,
        where: '$columnIdName = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete({required String tableName, required int id}) async {
    Database db = await instance.database;
    return await db
        .delete(tableInventory, where: '$tableName = ?', whereArgs: [id]);
  }

  // Only for Testing!
  void createTable({required String tableName}) async {
    print('createTable');
    Database db = await instance.database;
    await db.execute('''
          CREATE TABLE $tableInventory (
            $tableName INTEGER PRIMARY KEY,
            $columnCategoryNumbers TEXT NOT NULL,
            $columnItemName INTEGER NOT NULL
          )
          ''');
  }
}
