import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbManager {
  static const databaseName = "database.db";
  static const databaseVersion = 1;

  final String inventoryTableName = 'inventory';
  final String inventoryColumnNameItemID = 'inventory_id';
  final String inventoryColumnNameCategoryId = 'inventory_category_id';
  final String inventoryColumnNameItemName = 'inventory_item_name';
  final String inventoryColumnNameItemPrice = 'inventory_item_price';
  final String inventoryColumnNameItemCount = 'inventory_item_count';

  final categoriesTableName = 'categories';
  final String categoriesColumnNameCategoryID = 'category_id';
  final String categoriesColumnNameCategoryName = 'category_name';

  bool _createExampleTableData = false;

  DbManager._privateConstructor();
  static final DbManager instance = DbManager._privateConstructor();
  static Database? _db;

  Future<Database> get database async {
    debugPrint('Future<Database> get database async{}');
    if (_db != null) return _db!;
    // lazily instantiate the db the first time it is accessed
    _db = await _initDatabase();

    if (_createExampleTableData) {
      await _insertExampleDataIntoAllTables();
    }

    return _db!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    debugPrint('_initDatabase');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, databaseName);
    debugPrint(
        "dbPath to see DB in DBBrowser when using iPhone-Simulator = $dbPath");

    return await openDatabase(dbPath,
        version: databaseVersion, onCreate: onCreate);
  }

  // SQL code to create the database table
  Future onCreate(Database db, int version) async {
    debugPrint('_onCreate');
    _createExampleTableData = true;

    await db.execute(
        '''
          CREATE TABLE $inventoryTableName (
            $inventoryColumnNameItemID INTEGER NOT NULL UNIQUE,
            $inventoryColumnNameCategoryId INTEGER NOT NULL,
            $inventoryColumnNameItemName TEXT NOT NULL,
            $inventoryColumnNameItemPrice DOUBLE NOT NULL,
            $inventoryColumnNameItemCount INTEGER NOT NULL,
            PRIMARY KEY("$inventoryColumnNameItemID" AUTOINCREMENT)
          )
          ''');

    await db.execute(
        '''
            CREATE TABLE $categoriesTableName (
              $categoriesColumnNameCategoryID INTEGER NOT NULL UNIQUE,
              $categoriesColumnNameCategoryName TEXT NOT NULL UNIQUE,
              PRIMARY KEY("$categoriesColumnNameCategoryID" AUTOINCREMENT)
            )
            ''');
  }

  Future _insertExampleDataIntoAllTables() async {
    debugPrint('\ninsertExampleDatesIntoAllTables()');
    await _insertExampleDataIntoCategoriesTable();
    await _insertExampleDataIntoInventoryTable();
  }

  Future _insertExampleDataIntoCategoriesTable() async {
    debugPrint('_insertExampleDataIntoColumnTable()');
    List<Map<String, dynamic>> _exampleData = [
      {
        categoriesColumnNameCategoryID: 1,
        categoriesColumnNameCategoryName: 'Butter',
      },
      {
        categoriesColumnNameCategoryID: 2,
        categoriesColumnNameCategoryName: 'Brot',
      },
      {
        categoriesColumnNameCategoryID: 3,
        categoriesColumnNameCategoryName: 'Wein',
      }
    ];
    for (Map<String, dynamic> _dataRow in _exampleData) {
      await insertIntoTable(tableName: categoriesTableName, row: _dataRow);
    }
  }

  Future _insertExampleDataIntoInventoryTable() async {
    debugPrint('_insertExampleDataIntoInventoryTable()');
    List<Map<String, dynamic>> _exampleData = [
      {
        inventoryColumnNameItemID: 1,
        inventoryColumnNameCategoryId: 1,
        inventoryColumnNameItemName: 'Deutsche Markenbutter',
        inventoryColumnNameItemPrice: 1.29,
        inventoryColumnNameItemCount: 2
      },
      {
        inventoryColumnNameItemID: 2,
        inventoryColumnNameCategoryId: 2,
        inventoryColumnNameItemName: "Weißbrot",
        inventoryColumnNameItemPrice: 0.99,
        inventoryColumnNameItemCount: 4
      },
      {
        inventoryColumnNameItemID: 3,
        inventoryColumnNameCategoryId: 3,
        inventoryColumnNameItemName: 'Portwein',
        inventoryColumnNameItemPrice: 2.99,
        inventoryColumnNameItemCount: 5
      }
    ];
    for (Map<String, dynamic> _dataRow in _exampleData) {
      await insertIntoTable(tableName: inventoryTableName, row: _dataRow);
    }
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
    try {
      return await db.insert(tableName, row);
    } catch (error) {
      debugPrint('insertIntoTable errorCode : ' + error.toString());
      return -1;
    }
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
    return result;
  }

  Future<List<List<Map<String, dynamic>>>> queryAllRowsFromAllTables() async {
    debugPrint('queryAllRows');
    Database db = await instance.database;

    List<Map<String, dynamic>> resultTable1;
    try {
      resultTable1 = await db.query(categoriesTableName);
    } catch (e) {
      debugPrint('error! : ' + e.toString());
      resultTable1 = e as List<Map<String, dynamic>>;
    }
    List<Map<String, dynamic>> resultTable2;
    try {
      resultTable2 = await db.query(inventoryTableName);
    } catch (e) {
      debugPrint('error! : ' + e.toString());
      resultTable2 = e as List<Map<String, dynamic>>;
    }
    return [resultTable1, resultTable2];
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
      required String whereColumnIdName,
      required Map<String, dynamic> rowData}) async {
    debugPrint('updateRow()');

    Database db = await instance.database;
    int id = rowData[whereColumnIdName];

    return await db.update(tableName, rowData,
        where: '$whereColumnIdName = ?', whereArgs: [id]);
  }

  Future<int> deleteRow(
      {required String tableName,
      required String idColumnName,
      required int id}) async {
    debugPrint('deleteRow()');
    Database db = await instance.database;
    return await db
        .delete(tableName, where: '$idColumnName = ?', whereArgs: [id]);
  }

  Future<int> deleteAllRows(
      {required String tableName, required String idColumnName}) async {
    debugPrint('\ndeleteAllRows()');
    Database db = await instance.database;
    int? tableExists = 0;

    tableExists = await isTableExists(tableName: tableName);
    if (tableExists! > 0) {
      return await db
          .rawDelete('DELETE FROM $tableName WHERE $idColumnName > 0');
    } else {
      return -1;
    }
  }

  // Only for Testing!
  void createTable({required String tableName}) async {
    debugPrint('createTable');
    Database db = await instance.database;
    await db.execute(
        '''
          CREATE TABLE $inventoryTableName (
            $tableName INTEGER PRIMARY KEY,
            $inventoryColumnNameCategoryId TEXT NOT NULL,
            $inventoryColumnNameItemName INTEGER NOT NULL
          )
          ''');
  }

  Future<int?> isTableExists({required String tableName}) async {
    debugPrint('isTableExists()');
    Database db = await instance.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $tableName'),
    );
  }

  Future<List<Map<String, Object?>>> rawQuery(
      {required String queryString}) async {
    debugPrint('rawQuery()');
    Database db = await instance.database;
    List<Map<String, Object?>> _queryResult;
    try {
      _queryResult = await db.rawQuery(queryString);
    } catch (error) {
      _queryResult = [
        {'error': error}
      ];
    }
    return _queryResult;
  }
}
