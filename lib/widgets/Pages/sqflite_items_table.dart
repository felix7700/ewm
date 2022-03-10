import 'package:ewm/db_manager.dart';
import 'package:ewm/widgets/Buttons/DropDownButtons/categories_drop_down_button.dart';
import 'package:ewm/widgets/DialogContent/InputCards/input_card_edit_item_name.dart';
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
  Future<List<List<Map<String, dynamic>>>>? _allData;

  @override
  void initState() {
    debugPrint('super.initState();');
    super.initState();
    _allData = dbManager.queryAllRowsFromAllTables();
  }

  void _loadData() {
    debugPrint('_loadData()');
    _allData = dbManager.queryAllRowsFromAllTables();

    setState(
      () {
        _allData = dbManager.queryAllRowsFromAllTables();
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

  void _updateItemCategory(
      {required int itemId, required int newCategoryId}) async {
    String _table = dbManager.inventoryTableName;
    String _columnToUpdate = dbManager.inventoryColumnNameCategoryId;
    String _inventoryColumnNameItemID = dbManager.inventoryColumnNameItemID;
    String _itemId = itemId.toString();
    String _queryString =
        'UPDATE $_table SET $_columnToUpdate = $newCategoryId WHERE $_inventoryColumnNameItemID = $_itemId';
    debugPrint('_queryString : ' + _queryString);
    var _resultErrorList = await dbManager.rawQuery(queryString: _queryString);
    if (_resultErrorList.isEmpty) {
      _loadData();
    } else {
      _showErrorDialog(context, _resultErrorList.toString());
    }
    Navigator.of(context).pop();
  }

  void _updateItemName(
      {required int itemId, required String newItemName}) async {
    debugPrint('_updateItemName() itemId: $itemId  newItemName: $newItemName');
    String _table = dbManager.inventoryTableName;
    String _columnToUpdate = dbManager.inventoryColumnNameItemName;
    String _inventoryColumnNameItemID = dbManager.inventoryColumnNameItemID;
    String _itemId = itemId.toString();
    String _queryString =
        'UPDATE $_table SET $_columnToUpdate = "$newItemName" WHERE $_inventoryColumnNameItemID = $_itemId';
    debugPrint('_queryString: ' + _queryString);
    var _resultErrorList = await dbManager.rawQuery(queryString: _queryString);
    if (_resultErrorList.isEmpty) {
      _loadData();
    } else {
      _showErrorDialog(context, _resultErrorList.toString());
    }
    Navigator.of(context).pop();
  }

  Future<String?> _showEditItemCategoryDialog({
    required String title,
    required Map<String, dynamic> itemData,
    required String columnNameToUpdate,
    required List<Map<String, dynamic>> categories,
  }) {
    String dropdownInitValue =
        categories[(itemData[dbManager.inventoryColumnNameCategoryId]) as int]
            [dbManager.categoriesColumnNameCategoryName];
    debugPrint('dropdownInitValue: ' + dropdownInitValue.toString());
    TextEditingController _categoryTextEditingController =
        TextEditingController();
    _categoryTextEditingController.text = dropdownInitValue;
    List<String> _categoriesAsList = [];
    for (int i = 0; i < categories.length; i++) {
      _categoriesAsList.add(
          categories[i][dbManager.categoriesColumnNameCategoryName].toString());
    }
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Row(
          children: [
            TextButton(
              child: Row(
                children: [
                  CategoriesDropDownButton(
                    itemData: itemData,
                    updateCategoryIdInItemDataFunction: _updateItemCategory,
                    categoriesFromDBasList: _categoriesAsList,
                    dropdownValue: dropdownInitValue,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showEditItemNameDialog({
    required String title,
    required Map<String, dynamic> itemData,
    required String columnNameToUpdate,
  }) {
    String dropdownInitValue = itemData[dbManager.inventoryColumnNameItemName];
    TextEditingController _categoryTextEditingController =
        TextEditingController();
    _categoryTextEditingController.text = dropdownInitValue;
    List<String> _categoriesAsList = [];

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: InputCardEditItemName(
            itemId: itemData[dbManager.inventoryColumnNameItemID],
            updateItemNameinSqliteDB: _updateItemName,
          )),
    );
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
      {required List<Map<String, dynamic>> categoriesData,
      required List<Map<String, dynamic>> inventoryData}) {
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
                  _showEditItemCategoryDialog(
                    categories: categoriesData,
                    title: 'Kategorie wählen:',
                    itemData: inventoryData[rowIndex],
                    columnNameToUpdate: dbManager.inventoryColumnNameCategoryId,
                  );
                },
                child: Text(
                  categoriesData[inventoryData[rowIndex]
                          [dbManager.inventoryColumnNameCategoryId]]
                      [dbManager.categoriesColumnNameCategoryName],
                  style: _cellTextStyle,
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: TextButton(
                onPressed: () {
                  _showEditItemNameDialog(
                    title: 'Neuer Artikelname:',
                    itemData: inventoryData[rowIndex],
                    columnNameToUpdate: dbManager.inventoryColumnNameCategoryId,
                  );
                },
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
        future: _allData,
        builder: (context, snapshot) {
          final Widget widget;
          if (snapshot.hasData) {
            List<List<Map<String, dynamic>>> _allDataFromAllTables =
                snapshot.data as List<List<Map<String, dynamic>>>;
            List<Map<String, dynamic>> _categoriesData =
                _allDataFromAllTables[0];
            List<Map<String, dynamic>> _inventoryData =
                _allDataFromAllTables[1];
            final List<TableRow> tableRows = _getTableRows(
                categoriesData: _categoriesData, inventoryData: _inventoryData);
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
