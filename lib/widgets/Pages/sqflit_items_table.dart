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
        body: const MyStatelessWidget(),
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
  DbManager dbManager = DbManager.instance;

  late Future<List<String>> _categoryNamesSet;

  final List<String> categorys = ['Käse', 'Butter', 'Milch', 'Brot'];
  final List<String> items = [
    'Gauda',
    'Markenbutter',
    'Vollmilch 3,8%',
    'Körnerbrot'
  ];

  @override
  void initState() {
    super.initState();
    _categoryNamesSet = _loadData();
    // _loadItems();
  }

  Future<List<String>> _loadData() async {
    debugPrint('_loadData()');
    List<Map<String, dynamic>> _categoryNamesListMap = [];
    try {
      debugPrint('try  dbManager.queryAllRows');
      _categoryNamesListMap = await dbManager.queryAllRows(
          tableName: dbManager.tableNameCategories);
    } catch (e) {
      debugPrint('load error e = ' + e.toString());
      _categoryNamesListMap = [];
    }
    List<String> categoryNamesSet = <String>[];

    for (var element in _categoryNamesListMap) {
      categoryNamesSet.add(element['category_name']);
    }

    if (_categoryNamesListMap.toString().contains('no such table')) {
      debugPrint('error no such table');
      return [];
    }
    debugPrint(
        'categoryNamesListMap loadet = ' + _categoryNamesListMap.toString());

    // 'no such table'
    return categoryNamesSet;
  }

  List<TableRow> _getTableRows(
      {required List<String> categorys, required List<String> items}) {
    final List<TableRow> tableRows = [];

    const TextStyle _headlineCellsTextStyle = TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold);
    const TextStyle _cellTextStyle = TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal);

    tableRows.add(
      TableRow(
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Container(
              height: 32,
              width: 32,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: const Center(
                child: Text(
                  'Kategorie',
                  style: _headlineCellsTextStyle,
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Container(
              height: 32,
              width: 32,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: const Center(
                child: Text(
                  'Artikel',
                  style: _headlineCellsTextStyle,
                ),
              ),
            ),
          )
        ],
      ),
    );
    for (int index = 0; index < categorys.length; index++) {
      tableRows.add(
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 32,
                width: 32,
                color: Colors.blue[100],
                child: Center(
                  child: Text(
                    categorys.elementAt(index),
                    style: _cellTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 32,
                width: 32,
                color: Colors.blue[100],
                child: Center(
                  child: Text(items.elementAt(index), style: _cellTextStyle),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return tableRows;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: _categoryNamesSet,
          builder: (context, snapshot) {
            final Widget widget;
            if (snapshot.hasData) {
              var categorys = snapshot.data as List<String>;
              final List<TableRow> tableRows =
                  _getTableRows(categorys: categorys, items: categorys);
              widget = Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  children: tableRows,
                  border: TableBorder.all(),
                ),
              );
            } else {
              widget = const Center(
                child: Text('Daten werden geladen...'),
              );
            }

            return widget;
          },
        ),
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: FutureBuilder(
    //     future: _categoryNamesSet,
    //     builder: (context, snapshot) {
    //       Widget widget;
    //       if (snapshot.hasData) {
    //         widget = Scaffold(
    //             body: CategoryListPage(
    //                 refreshFunction: _refreshData,
    //                 categoryNames: snapshot.data as Set<Object>));
    //       } else if (snapshot.hasError) {
    //         widget = const Scaffold(
    //             body: Center(
    //                 child: Text('Error!',
    //                     style: TextStyle(
    //                         fontSize: 20,
    //                         fontStyle: FontStyle.italic,
    //                         color: Colors.red))));
    //       } else {
    //         widget = const Scaffold(
    //             backgroundColor: Colors.grey,
    //             body: Center(
    //                 child: Text('Daten werden geladen...',
    //                     style: TextStyle(
    //                         fontSize: 20,
    //                         fontStyle: FontStyle.italic,
    //                         color: Colors.black54))));
    //       }
    //       return widget;
    //     },
    //   ),

    //  Padding(
    //   padding: const EdgeInsets.all(16.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       SizedBox(
    //         width: double.infinity,
    //         child: Table(
    //           border: TableBorder.all(),
    //           columnWidths: const {
    //             0: FractionColumnWidth(0.5),
    //             1: FractionColumnWidth(0.5)
    //           },
    //           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    //           children: tableRows,
    //         ),
    //       ),
    //     ],
    //   ),
    // )
  }
}
