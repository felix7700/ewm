import 'package:ewm/db_manager.dart';
import 'package:flutter/material.dart';
import '../Buttons/add_item_icon_button.dart';
import '../Buttons/increment_item_count_icon_button.dart';

class SqfliteItemsTablePage extends StatefulWidget {
  const SqfliteItemsTablePage({Key? key}) : super(key: key);

  @override
  State<SqfliteItemsTablePage> createState() => _SqfliteItemsTablePageState();
}

class _SqfliteItemsTablePageState extends State<SqfliteItemsTablePage> {
  static const String _title = 'SQFlite Beispiel Lagerhaus';
  DbManager dbManager = DbManager.instance;
  late Future<List<Map<String, dynamic>>> _inventoryData;

  @override
  void initState() {
    super.initState();
    _inventoryData =
        dbManager.queryAllRows(tableName: dbManager.inventoryTableName);
  }

  void _loadData() {
    setState(
      () {
        _inventoryData =
            dbManager.queryAllRows(tableName: dbManager.inventoryTableName);
      },
    );
  }

  void _incrementItemCount(int itemId) {
    debugPrint('\n\n\n');
    debugPrint('_incrementItemCount from itemData ' + itemId.toString());

    String _table = dbManager.inventoryTableName;
    String _columnToIncrease = dbManager.inventoryColumnNameItemCount;
    String _inventoryColumnNameItemID = dbManager.inventoryColumnNameItemID;
    String _itemId = itemId.toString();
    String _queryString =
        'UPDATE $_table SET $_columnToIncrease = $_columnToIncrease + 1 WHERE $_inventoryColumnNameItemID = $_itemId';
    var result = dbManager.rawQuery(queryString: _queryString);
    debugPrint('result = ' + result.toString());
    _loadData();
  }

  List<TableRow> _getTableRows(
      {required List<Map<String, dynamic>> inventoryData}) {
    debugPrint('\n_getTableRows()');

    final List<TableRow> tableRows = [];

    const TextStyle _headlineCellsTextStyle = TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold);
    const _headlineCellsTextPaddingEdgeInsets = EdgeInsets.all(8.0);
    const TextStyle _cellTextStyle = TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.normal);
    const _cellsTextPaddingEdgeInsets = EdgeInsets.all(8.0);

    tableRows.add(
      const TableRow(
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Center(
              child: Padding(
                padding: _headlineCellsTextPaddingEdgeInsets,
                child: Text(
                  'Item-\nID',
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
                  'Stück-\nPreis (€)',
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
                  'Bestand\nStück',
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
                    inventoryData[rowIndex][dbManager.inventoryColumnNameItemID]
                        .toString(),
                    style: _cellTextStyle,
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
                        [dbManager.inventoryColumnNameCategoryName],
                    style: _cellTextStyle,
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
                          [dbManager.inventoryColumnNameItemName],
                      style: _cellTextStyle),
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
                              [dbManager.inventoryColumnNameItemPrice]
                          .toString(),
                      style: _cellTextStyle),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Center(
                child: Padding(
                  padding: _cellsTextPaddingEdgeInsets,
                  child: Row(
                    children: [
                      Text(
                        inventoryData[rowIndex]
                                [dbManager.inventoryColumnNameItemCount]
                            .toString(),
                        style: _cellTextStyle,
                      ),
                      IncrementItemCountIconButton(
                          itemId: inventoryData[rowIndex]
                              [dbManager.inventoryColumnNameItemID],
                          buttonPressed: _incrementItemCount)
                    ],
                  ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
      ),
      body: FutureBuilder(
        future: _inventoryData,
        builder: (context, snapshot) {
          final Widget widget;
          if (snapshot.hasData) {
            List<Map<String, dynamic>> _inventoryData =
                snapshot.data as List<Map<String, dynamic>>;
            debugPrint('_inventoryData = ' + _inventoryData.toString());

            final List<TableRow> tableRows =
                _getTableRows(inventoryData: _inventoryData);
            widget = Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Table(
                    children: tableRows,
                    border: TableBorder.all(),
                    columnWidths: const <int, TableColumnWidth>{
                      0: IntrinsicColumnWidth(),
                      1: IntrinsicColumnWidth(),
                      2: FlexColumnWidth(),
                      3: IntrinsicColumnWidth(),
                      4: IntrinsicColumnWidth(),
                    },
                  ),
                  AddItemIconButton(refreshItemsFunction: _loadData)
                ],
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
    );
  }
}
