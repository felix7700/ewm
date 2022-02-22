import 'package:ewm/db_manager.dart';
import 'package:flutter/material.dart';
import '../AppBarButtons/add_category_icon_button.dart';

// ignore: must_be_immutable
class CategoryListPage extends StatelessWidget {
  CategoryListPage(
      {required this.refreshFunction, required this.categoryNames, Key? key})
      : super(key: key);
  final Set<dynamic> categoryNames;
  DbManager dbManager = DbManager.instance;
  Function refreshFunction;

  void _refreshList() {
    debugPrint('_refreshList()');
    refreshFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Kategorieen', style: TextStyle(fontSize: 24))),
        actions: [
          IconButton(
              onPressed: () {
                // dbManager.dropTable(tableName: dbManager.tableNameCategories);
                // dbManager.dropTable(tableName: dbManager.tableNameInventory);
                var error = dbManager.deleteAllRows(
                    tableName: dbManager.tableNameCategories);
                debugPrint('error = ' + error.toString());
                refreshFunction();
              },
              icon: const Icon(Icons.delete_forever)),
          IconButton(
              onPressed: () =>
                  dbManager.onCreate(DbManager.db!, DbManager.databaseVersion),
              icon: const Icon(Icons.new_label)),
          AddCategoryIconButton(
            refreshItemsFunction: _refreshList,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categoryNames.length,
              itemBuilder: (context, int element) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Card(
                      // ignore: prefer_const_constructors
                      color: Color.fromARGB(255, 127, 182, 228),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200.0,
                          child: Text(
                            categoryNames.elementAt(element),
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
