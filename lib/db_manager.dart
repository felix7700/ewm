import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbManager {
  static const databaseName = "database.db";
  static const databaseVersion = 1;

  final tableNameInventory = 'inventory';
  static const columnNameItemID = 'inventory_id';
  static const columnNameCategoryNumbers = 'inventory_categorie_numbers';
  static const columnNameItemName = 'inventory_item_name';
  static const columnNameItemCount = 'inventory_item_count';

  final tableNameCategories = 'categories';
  static const columnNameCategoryID = 'category_id';
  static const columnNameCategoryName = 'category_name';

  DbManager._privateConstructor();
  static final DbManager instance = DbManager._privateConstructor();

  static Database? db;

  Future<Database> get database async {
    debugPrint('Future<Database> get database async{}');
    if (db != null) return db!;
    // lazily instantiate the db the first time it is accessed
    db = await initDatabase();
    return db!;
  }

  // this opens the database (and creates it if it doesn't exist)
  initDatabase() async {
    debugPrint('_initDatabase');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    debugPrint("debugPrint('_initDatabase'); done");

    String path = join(documentsDirectory.path, databaseName);
    debugPrint(
        "String path = join(documentsDirectory.path, databaseName); done");

    return await openDatabase(path,
        version: databaseVersion, onCreate: onCreate);
  }

  // SQL code to create the database table
  Future onCreate(Database db, int version) async {
    debugPrint('_onCreate');

    await db.execute('''
          CREATE TABLE $tableNameInventory (
            $columnNameItemID INTEGER NOT NULL UNIQUE,
            $columnNameCategoryNumbers TEXT NOT NULL,
            $columnNameItemName TEXT NOT NULL,
            $columnNameItemCount INTEGER NOT NULL,
            PRIMARY KEY("$columnNameItemID" AUTOINCREMENT)
          )
          ''');

    await db.execute('''
            CREATE TABLE $tableNameCategories (
              $columnNameCategoryID INTEGER NOT NULL UNIQUE,
              $columnNameCategoryName TEXT NOT NULL UNIQUE,
              PRIMARY KEY("$columnNameCategoryID" AUTOINCREMENT)
            )
            ''');
  }

  void dropTable({required tableName}) async {
    debugPrint('\ndropTable');
    Database db = await instance.database;
    db.execute('DROP TABLE IF EXISTS $tableName');
  }

  Future<int> insertIntoTable(
      {required String tableName, required Map<String, dynamic> row}) async {
    debugPrint('queryAllRows');
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(
      {required String tableName}) async {
    debugPrint('queryAllRows');
    Database db = await instance.database;
    List<Map<String, dynamic>> result;
    try {
      result = await db.query(tableName);
    } catch (e) {
      debugPrint('error! : ' + e.toString());
      result = e as List<Map<String, dynamic>>;
    }
    debugPrint('result = ' + result.toString());
    return result;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount({required String tableName}) async {
    debugPrint('queryRowCount');
    Database db = await instance.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $tableName'),
    );
  }

  Future<List<Map<String, Object?>>> queryItem(
      {required String tableName,
      required String columnName,
      required int value}) async {
    debugPrint('queryItem');
    Database db = await instance.database;
    return await db
        .rawQuery('SELECT * FROM $tableName where $columnName = $value');
  }

  Future<int> updateRow(
      {required String tableName,
      required String columnIdName,
      required Map<String, dynamic> rowData}) async {
    debugPrint('updateRow()');
    Database db = await instance.database;
    int id = rowData[columnIdName];
    return await db.update(tableName, rowData,
        where: '$columnIdName = ?', whereArgs: [id]);
  }

  Future<int> deleteRow({required String tableName, required int id}) async {
    debugPrint('deleteRow()');
    Database db = await instance.database;
    return await db
        .delete(tableNameInventory, where: '$tableName = ?', whereArgs: [id]);
  }

  Future<int> deleteAllRows({required String tableName}) async {
    debugPrint('\ndeleteAllRows()');
    Database db = await instance.database;
    bool tableExists = await isTableExists(db: db, tableName: tableName);
    if (tableExists) {
      return await db.rawDelete(
          'DELETE FROM $tableNameCategories WHERE $columnNameCategoryID > 0');
    } else {
      return -1;
    }
  }

  // Only for Testing!
  void createTable({required String tableName}) async {
    debugPrint('createTable');
    Database db = await instance.database;
    await db.execute('''
          CREATE TABLE $tableNameInventory (
            $tableName INTEGER PRIMARY KEY,
            $columnNameCategoryNumbers TEXT NOT NULL,
            $columnNameItemName INTEGER NOT NULL
          )
          ''');
  }
}

Future<bool> isTableExists(
    {required Database db, required String tableName}) async {
  debugPrint('isTableExists');
  String sql = "SELECT name FROM sqlite_master WHERE type='table' AND name='" +
      tableName +
      "'";
  List<Map<String, Object?>> result = await db.rawQuery(sql);
  if (result.isNotEmpty) {
    return true;
  }
  //  result.close();
  return false;
}
