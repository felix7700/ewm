import 'package:ewm/db_manager.dart';
import 'package:flutter/material.dart';

class SqfliteItemsTablePage extends StatelessWidget {
  const SqfliteItemsTablePage({Key? key}) : super(key: key);
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
  late Future<List<Map<String, dynamic>>> _inventoryData;

  @override
  void initState() {
    super.initState();
    debugPrint('super.initState();');
    _inventoryData =
        dbManager.queryAllRows(tableName: dbManager.inventoryTableName);
  }

  List<TableRow> _getTableRows(
      {required List<Map<String, dynamic>> inventoryData}) {
    debugPrint('\n_getTableRows()');
    debugPrint('inventoryData = ' + inventoryData.toString());
    debugPrint('\ninventoryData[] = ' +
        inventoryData[0][dbManager.inventoryColumnNameCategoryName].toString());

    final List<TableRow> tableRows = [];

    const TextStyle _headlineCellsTextStyle = TextStyle(
        fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);
    const _headlineCellsTextPaddingEdgeInsets = EdgeInsets.all(8.0);
    const TextStyle _cellTextStyle = TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.normal);
    const _cellsTextPaddingEdgeInsets = EdgeInsets.all(16.0);

    tableRows.add(
      const TableRow(
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Center(
              child: Padding(
                padding: _headlineCellsTextPaddingEdgeInsets,
                child: Text(
                  'Kategorie',
                  style: _headlineCellsTextStyle,
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Center(
              child: Padding(
                padding: _headlineCellsTextPaddingEdgeInsets,
                child: Text(
                  'Artikel',
                  style: _headlineCellsTextStyle,
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Center(
              child: Padding(
                padding: _headlineCellsTextPaddingEdgeInsets,
                child: Text(
                  'Stück',
                  style: _headlineCellsTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    for (int rowIndex = 0; rowIndex < inventoryData.length; rowIndex++) {
      tableRows.add(
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Center(
                child: Padding(
                  padding: _cellsTextPaddingEdgeInsets,
                  child: Text(
                    inventoryData[rowIndex]
                        [dbManager.inventoryColumnNameCategoryName],
                    style: _cellTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Center(
                child: Expanded(
                  child: Padding(
                    padding: _cellsTextPaddingEdgeInsets,
                    child: Text(
                        inventoryData[rowIndex]
                            [dbManager.inventoryColumnNameItemName],
                        style: _cellTextStyle),
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Center(
                child: Padding(
                  padding: _cellsTextPaddingEdgeInsets,
                  child: Text(
                      inventoryData[rowIndex]
                              [dbManager.inventoryColumnNameItemCount]
                          .toString(),
                      style: _cellTextStyle),
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
          future: _inventoryData,
          builder: (context, snapshot) {
            final Widget widget;
            if (snapshot.hasData) {
              List<Map<String, dynamic>> _inventoryData =
                  snapshot.data as List<Map<String, dynamic>>;
              final List<TableRow> tableRows =
                  _getTableRows(inventoryData: _inventoryData);
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
  }
}
