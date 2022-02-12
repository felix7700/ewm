import 'package:ewm/dbhelper.dart';
import 'package:ewm/widgets/Pages/category_list.dart';
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
  late Future<Set<String>> _categoryNamesSet;

  @override
  void initState() {
    super.initState();
    _categoryNamesSet = _loadData();
  }

  Future<Set<String>> _loadData() async {
    var categoryNamesMap =
        await _dbHelper.queryAllRows(tableName: 'category_names');
    Set<String> categoryNamesSet = <String>{};

    for (var element in categoryNamesMap) {
      categoryNamesSet.add(element['category_name']);
    }
    return categoryNamesSet;
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
            widget = CategoryList(categoryNames: snapshot.data as Set<Object>);
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
