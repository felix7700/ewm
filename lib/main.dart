import 'package:ewm/dbhelper.dart';
import 'package:ewm/widgets/ListViews/category_list.dart';
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
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final List<String> _categoryNames = ['Milch', 'Brot'];
  late final Future<Set> categoryNamesSet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState');
    // _dbHelper.initDatabase();
    loadData();
  }

  Future<Set> loadData() async {
    var categoryNamesMap =
        await _dbHelper.queryAllRows(tableName: 'category_names');
    Set _categoryNamesSet = Set<dynamic>();

    for (var element in categoryNamesMap) {
      // print(element['category_name']);
      _categoryNamesSet.add(element['category_name']);
    }
    print('categoryNamesSet = ' + _categoryNamesSet.toString());
    return _categoryNamesSet;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CategoryList(categoryNames: _categoryNames),
      // home: FutureBuilder(
      //   future: categoryNamesSet,
      // ),
    );
  }
}
