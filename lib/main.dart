import 'package:ewm/db_manager.dart';
import 'package:ewm/widgets/Pages/category_list_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final DbManager dbManager = DbManager.instance;
  late Future<Set<String>> _categoryNamesSet;

  @override
  void initState() {
    super.initState();
    _categoryNamesSet = _loadData();
  }

  Future<Set<String>> _loadData() async {
    debugPrint('_loadData()');
    List<Map<String, dynamic>> categoryNamesListMap = [];
    try {
      debugPrint('try  dbManager.queryAllRows');
      categoryNamesListMap = await dbManager.queryAllRows(
          tableName: dbManager.tableNameCategories);
    } catch (e) {
      debugPrint('load error e = ' + e.toString());
      categoryNamesListMap = [];
    }
    Set<String> categoryNamesSet = <String>{};

    for (var element in categoryNamesListMap) {
      categoryNamesSet.add(element['category_name']);
    }

    if (categoryNamesListMap.toString().contains('no such table')) {
      debugPrint('error no such table');
      return {};
    }
    debugPrint(
        'categoryNamesListMap loadet = ' + categoryNamesListMap.toString());

    // 'no such table'
    return categoryNamesSet;
  }

  void _refreshData() {
    debugPrint('_refreshData()');
    setState(() {
      _categoryNamesSet = _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _categoryNamesSet,
        builder: (context, snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            widget = Scaffold(
                body: CategoryListPage(
                    refreshFunction: _refreshData,
                    categoryNames: snapshot.data as Set<Object>));
          } else if (snapshot.hasError) {
            widget = const Scaffold(
                body: Center(
                    child: Text('Error!',
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.red))));
          } else {
            widget = const Scaffold(
                backgroundColor: Colors.grey,
                body: Center(
                    child: Text('Daten werden geladen...',
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54))));
          }
          return widget;
        },
      ),
    );
  }
}
