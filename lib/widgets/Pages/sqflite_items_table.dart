import 'package:ewm/db_manager.dart';
import 'package:flutter/material.dart';
import '../Buttons/add_item_icon_button.dart';

class SqfliteItemsTablePage extends StatefulWidget {
  const SqfliteItemsTablePage({Key? key}) : super(key: key);

  @override
  State<SqfliteItemsTablePage> createState() => _SqfliteItemsTablePageState();
}

class _SqfliteItemsTablePageState extends State<SqfliteItemsTablePage> {
  static const String _title = 'SQFlite Beispiel Lagerhaus';
  DbManager dbManager = DbManager.instance;
  late Future<List<Map<String, dynamic>>> _categoriesData;
  late Future<List<Map<String, dynamic>>> _inventoryData;

  @override
  void initState() {
    debugPrint('super.initState();');
    super.initState();
    _categoriesData =
        dbManager.queryAllRows(tableName: dbManager.categoriesTableName);
    _inventoryData =
        dbManager.queryAllRows(tableName: dbManager.inventoryTableName);
  }

  void _loadData() {
    debugPrint('_loadData()');
    setState(
      () {
        _categoriesData =
            dbManager.queryAllRows(tableName: dbManager.categoriesTableName);
        _inventoryData =
            dbManager.queryAllRows(tableName: dbManager.inventoryTableName);
      },
    );
  }

  Future<String?> _showErrorDialog(BuildContext context, String errorText) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Ups! Ein Fehler ist aufgetreten!'),
        content: Text(errorText),
      ),
    );
  }

  Future<String?> _showEditItemValueDialog(
      {required BuildContext context,
      required String title,
      required int itemId,
      required String columnName,
      required String itemValue}) {
    TextEditingController _textEditingController = TextEditingController();
    _textEditingController.text = itemValue;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: _textEditingController,
        ),
      ),
    );
  }

  Future<String?> _showEditItemValueDialogWithDropDownMenu(
      {required BuildContext context,
      required String title,
      required int itemId,
      required String columnName,
      required String itemValue}) {
    TextEditingController _textEditingController = TextEditingController();
    _textEditingController.text = itemValue;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: TextButton(
            child: Text(''),
            onPressed: () {},
          )),
    );
  }

  void _increaseItemCountWithErrorMessageForErrorDemonstation(
      int itemId) async {
    String _table = dbManager.inventoryTableName;
    String _columnToIncrease = dbManager.inventoryColumnNameItemCount;
    String _inventoryColumnNameItemID = dbManager.inventoryColumnNameItemID;
    String _itemId = itemId.toString();
    String _queryString =
        'UUPDATE $_table SET $_columnToIncrease = $_columnToIncrease + 1 WHERE $_inventoryColumnNameItemID = $_itemId';
    var _resultErrorList = await dbManager.rawQuery(queryString: _queryString);
    if (_resultErrorList.isEmpty) {
      _loadData();
    } else {
      _showErrorDialog(context, _resultErrorList.toString());
    }
  }

  void _increaseItemCount(int itemId) async {
    String _table = dbManager.inventoryTableName;
    String _columnToIncrease = dbManager.inventoryColumnNameItemCount;
    String _inventoryColumnNameItemID = dbManager.inventoryColumnNameItemID;
    String _itemId = itemId.toString();
    String _queryString =
        'UPDATE $_table SET $_columnToIncrease = $_columnToIncrease + 1 WHERE $_inventoryColumnNameItemID = $_itemId';
    var _resultErrorList = await dbManager.rawQuery(queryString: _queryString);
    if (_resultErrorList.isEmpty) {
      _loadData();
    } else {
      _showErrorDialog(context, _resultErrorList.toString());
    }
  }

  void _decreaseItemCount(int itemId) async {
    String _table = dbManager.inventoryTableName;
    String _columnToIncrease = dbManager.inventoryColumnNameItemCount;
    String _inventoryColumnNameItemID = dbManager.inventoryColumnNameItemID;
    String _itemId = itemId.toString();
    String _queryString =
        'UPDATE $_table SET $_columnToIncrease = $_columnToIncrease - 1 WHERE $_inventoryColumnNameItemID = $_itemId AND $_columnToIncrease > 0';
    var _resultErrorList = await dbManager.rawQuery(queryString: _queryString);
    if (_resultErrorList.isEmpty) {
      _loadData();
    } else {
      _showErrorDialog(context, _resultErrorList.toString());
    }
  }

  List<TableRow> _getTableRows(
      {required List<Map<String, dynamic>> inventoryData}) {
    final List<TableRow> tableRows = [];

    const TextStyle _headlineCellsTextStyle = TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold);
    const _headlineCellsTextPaddingEdgeInsets = EdgeInsets.all(8.0);
    const TextStyle _cellTextStyle = TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.normal);

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
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: Center(
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
              child: TextButton(
                onPressed: () {
                  _showEditItemValueDialogWithDropDownMenu(
                      context: context,
                      title: 'Kategorie wählen:',
                      itemId: inventoryData[rowIndex]
                          [dbManager.inventoryColumnNameItemID],
                      columnName: dbManager.inventoryColumnNameCategoryId,
                      itemValue: inventoryData[rowIndex]
                          [dbManager.inventoryColumnNameCategoryId]);
                },
                child: Text(
                  inventoryData[rowIndex]
                          [dbManager.inventoryColumnNameCategoryId]
                      .toString(),
                  style: _cellTextStyle,
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: TextButton(
                onPressed: () {},
                child: Text(
                    inventoryData[rowIndex]
                        [dbManager.inventoryColumnNameItemName],
                    style: _cellTextStyle),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  inventoryData[rowIndex]
                          [dbManager.inventoryColumnNameItemPrice]
                      .toString(),
                  style: _cellTextStyle,
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  inventoryData[rowIndex]
                          [dbManager.inventoryColumnNameItemCount]
                      .toString(),
                  style: _cellTextStyle,
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
      backgroundColor: Colors.grey[100],
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
            debugPrint('_inventoryData: ' + _inventoryData.toString());
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
                  AddItemIconButton(
                    refreshItemsFunction: _loadData,
                  ),
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
