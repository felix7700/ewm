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
                dbManager.dropTable(tableName: dbManager.tableNameCategories);
                dbManager.dropTable(tableName: dbManager.tableNameInventory);
              },
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () {
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

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: MyStatelessWidget(),
      ),
    );
  }
}

class MyStatelessWidget extends StatefulWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  State<MyStatelessWidget> createState() => _MyStatelessWidgetState();
}

class _MyStatelessWidgetState extends State<MyStatelessWidget> {
  final Set<String> categorys = {'Käse', 'Butter', 'Milch', 'Brot'};
  final Set<String> items = {
    'Gauda',
    'Markenbutter',
    'Vollmilch 3,8%',
    'Körnerbrot'
  };
  final List<TableRow> tableRows = [];

  @override
  void initState() {
    super.initState();
    tableRows.add(TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Container(
          height: 32,
          width: 32,
          color: Color.fromARGB(255, 255, 255, 255),
          child: const Center(
            child: Text(
              'Kategorie',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Container(
          height: 32,
          width: 32,
          color: Color.fromARGB(255, 255, 255, 255),
          child: const Center(
            child: Text(
              'Artikel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      )
    ]));
    debugPrint('_MyStatelessWidgetState _initState()');
    for (String categoryElement in categorys) {
      tableRows.add(TableRow(children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            height: 32,
            width: 32,
            color: Colors.blue[100],
            child: Center(child: Text(categoryElement)),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            height: 32,
            width: 32,
            color: Colors.blue[100],
            child: Center(child: Text(categoryElement)),
          ),
        ),
      ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FractionColumnWidth(0.5),
                1: FractionColumnWidth(0.5)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: tableRows,
            ),
          ),
        ],
      ),
    );
  }
}
