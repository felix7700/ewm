import 'package:ewm/db_manager.dart';
import 'package:ewm/widgets/Buttons/DropDownButtons/categories_drop_down_button.dart';
import 'package:ewm/widgets/DialogContent/InputCards/input_card_add_new_category.dart';
import 'package:ewm/widgets/DialogContent/InputCards/input_card_edit_item_name.dart';
import 'package:flutter/material.dart';
import '../Buttons/add_item_icon_button.dart';
import '../DialogContent/InputCards/input_card_edit_item_count.dart';
import '../DialogContent/InputCards/input_card_edit_item_price.dart';

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

  void _addNewItemIntoInventory(
      {required Map<String, dynamic> newItemdataRow}) async {
    debugPrint('_addNewItemIntoInventory');

    int? _resultErrorNumber = await dbManager.insertIntoTable(
        tableName: dbManager.inventoryTableName, row: newItemdataRow);
    debugPrint('_resultErrorNumber: $_resultErrorNumber');

    if (_resultErrorNumber >= 0) {
      _loadData();
    } else {
      _showErrorDialog(context, _resultErrorNumber.toString());
    }
    debugPrint(' Navigator.of(context).pop();');
    Navigator.of(context).pop();
  }

  void _loadDataAndCloseDialog() {
    debugPrint('_loadDataAndCloseDialog');
    _loadData();
    Navigator.of(context).pop();
  }

  void _addNewCategoy({required Map<String, dynamic> newCategoryRow}) async {
    debugPrint('_addNewCategoy');
    debugPrint('newCategoryRow : ' + newCategoryRow.toString());

    int? _resultErrorNumber = await dbManager.insertIntoTable(
        tableName: dbManager.categoriesTableName, row: newCategoryRow);
    debugPrint('_resultErrorNumber: $_resultErrorNumber');

    if (_resultErrorNumber >= 0) {
      _loadData();
    } else {
      _showErrorDialog(context, _resultErrorNumber.toString());
    }
  }

  Future<String?> _showErrorDialog(BuildContext context, String errorText) {
    debugPrint('_showErrorDialog()');
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Ups! Ein Fehler ist aufgetreten!'),
        content: Text(errorText),
      ),
    );
  }

  void _updateItemCategory(
      {required int itemId, required int categoryIdValue}) async {
    String _table = dbManager.inventoryTableName;
    String _columnToUpdate = dbManager.inventoryColumnNameCategoryId;
    String _inventoryColumnNameItemID = dbManager.inventoryColumnNameItemID;
    String _itemId = itemId.toString();
    String _queryString =
        'UPDATE $_table SET $_columnToUpdate = $categoryIdValue WHERE $_inventoryColumnNameItemID = $_itemId';
    debugPrint('_queryString : ' + _queryString);
    var _resultErrorNumber =
        await dbManager.rawQuery(queryString: _queryString);
    if (_resultErrorNumber.isEmpty) {
      _loadData();
    } else {
      _showErrorDialog(context, _resultErrorNumber.toString());
    }
    Navigator.of(context).pop();
  }

  void _updateItemName(
      {required int itemId, required String newItemName}) async {
    String _table = dbManager.inventoryTableName;
    String _columnToUpdate = dbManager.inventoryColumnNameItemName;
    String _inventoryColumnNameItemID = dbManager.inventoryColumnNameItemID;
    String _itemId = itemId.toString();
    String _queryString =
        'UPDATE $_table SET $_columnToUpdate = "$newItemName" WHERE $_inventoryColumnNameItemID = $_itemId';
    debugPrint('_queryString: ' + _queryString);
    var _resultErrorNumber =
        await dbManager.rawQuery(queryString: _queryString);
    if (_resultErrorNumber.isEmpty) {
      _loadData();
    } else {
      _showErrorDialog(context, _resultErrorNumber.toString());
    }
    Navigator.of(context).pop();
  }

  void _updateItemPrice(
      {required int itemId, required String newItemPrice}) async {
    String _table = dbManager.inventoryTableName;
    String _columnToUpdate = dbManager.inventoryColumnNameItemPrice;
    String _inventoryColumnNameItemID = dbManager.inventoryColumnNameItemID;
    String _itemId = itemId.toString();
    String _queryString =
        'UPDATE $_table SET $_columnToUpdate = "$newItemPrice" WHERE $_inventoryColumnNameItemID = $_itemId';
    debugPrint('_queryString: ' + _queryString);
    var _resultErrorNumber =
        await dbManager.rawQuery(queryString: _queryString);
    if (_resultErrorNumber.isEmpty) {
      _loadData();
    } else {
      _showErrorDialog(context, _resultErrorNumber.toString());
    }
    Navigator.of(context).pop();
  }

  Future<String?> _showEditItemCategoryDialog({
    required String title,
    required Map<String, dynamic> itemData,
    required List<Map<String, dynamic>> categories,
  }) {
    String dropdownInitValue =
        categories[itemData[dbManager.inventoryColumnNameCategoryId] - 1]
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
            Row(
              children: [
                CategoriesDropDownButton(
                  itemId: itemData[dbManager.inventoryColumnNameItemID],
                  onChangedFunction: _updateItemCategory,
                  categoriesData: categories,
                  dropdownValue: dropdownInitValue,
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showAddNewCategoryDialog() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Neue Kategorie:'),
        content: AddNewCategoryCard(
          addNewCategoryFunction: _addNewCategoy,
        ),
      ),
    );
  }

  Future<String?> _showEditItemNameDialog({
    required String title,
    required Map<String, dynamic> itemData,
  }) {
    String dropdownInitValue = itemData[dbManager.inventoryColumnNameItemName];
    TextEditingController _categoryTextEditingController =
        TextEditingController();
    _categoryTextEditingController.text = dropdownInitValue;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: InputCardEditItemName(
          itemId: itemData[dbManager.inventoryColumnNameItemID],
          updateItemNameinSqliteDB: _updateItemName,
          itemNameTextFieldInitValue:
              itemData[dbManager.inventoryColumnNameItemName],
        ),
      ),
    );
  }

  Future<String?> _showEditItemCountDialog({
    required String title,
    required Map<String, dynamic> itemData,
  }) {
    String dropdownInitValue = itemData[dbManager.inventoryColumnNameItemName];
    TextEditingController _categoryTextEditingController =
        TextEditingController();
    _categoryTextEditingController.text = dropdownInitValue;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: InputCardEditItemCount(
          itemId: itemData[dbManager.inventoryColumnNameItemID],
          itemCountValue: itemData[dbManager.inventoryColumnNameItemCount],
          dataUpdatedFunction: _loadDataAndCloseDialog,
          dialogbuildContext: context,
        ),
      ),
    );
  }

  Future<String?> _showEditItemPriceDialog({
    required String title,
    required Map<String, dynamic> itemData,
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
        content: InputCardEditItemPrice(
          itemId: itemData[dbManager.inventoryColumnNameItemID],
          updateItemPriceinSqliteDB: _updateItemPrice,
          editItemPriceTextFieldInitValue:
              itemData[dbManager.inventoryColumnNameItemPrice],
        ),
      ),
    );
  }

  List<List<TableRow>> _getTableRows(
      {required List<Map<String, dynamic>> categoriesDataAsList,
      required List<Map<String, dynamic>> inventoryData}) {
    final List<TableRow> tableRowHeadline = [];
    final List<TableRow> tableRows = [];

    const TextStyle _headlineCellsTextStyle = TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold);
    const _headlineCellsTextPaddingEdgeInsets = EdgeInsets.all(8.0);
    const TextStyle _cellTextStyle = TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.normal);

    tableRowHeadline.add(
      TableRow(
        children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Padding(
              padding: _headlineCellsTextPaddingEdgeInsets,
              child: Center(
                child: Text(
                  'ID',
                  style: _headlineCellsTextStyle,
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Text(
                      'Kategorie',
                      style: _headlineCellsTextStyle,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showAddNewCategoryDialog();
                    },
                    icon: const Icon(Icons.add),
                    constraints: const BoxConstraints(),
                  )
                ],
              ),
            ),
          ),
          const TableCell(
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
          const TableCell(
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
          const TableCell(
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
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Center(
              child: Padding(
                padding: _headlineCellsTextPaddingEdgeInsets,
                child: Text(
                  '',
                  // 'Delete-\nButton',
                  style: _headlineCellsTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    for (int rowIndex = 0; rowIndex < inventoryData.length; rowIndex++) {
      String _categoryName = categoriesDataAsList[inventoryData[rowIndex]
              [dbManager.inventoryColumnNameCategoryId] -
          1][dbManager.categoriesColumnNameCategoryName];
      int _itemIdAsInt =
          inventoryData[rowIndex][dbManager.inventoryColumnNameItemID];
      String _itemName =
          inventoryData[rowIndex][dbManager.inventoryColumnNameItemName];
      String _itemPriceAsString = inventoryData[rowIndex]
              [dbManager.inventoryColumnNameItemPrice]
          .toStringAsFixed(2);
      String _itemCountAsString = inventoryData[rowIndex]
              [dbManager.inventoryColumnNameItemCount]
          .toString();

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
                    categories: categoriesDataAsList,
                    title: 'Kategorie wählen:',
                    itemData: inventoryData[rowIndex],
                  );
                },
                child: Text(
                  _categoryName,
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
                  );
                },
                child: Text(_itemName, style: _cellTextStyle),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: TextButton(
                onPressed: () {
                  _showEditItemPriceDialog(
                    title: 'Neuer Preis:',
                    itemData: inventoryData[rowIndex],
                  );
                },
                child: Text(
                  _itemPriceAsString,
                  style: _cellTextStyle,
                ),
              ),
            ),
            TableCell(
              child: TextButton(
                onPressed: () {
                  _showEditItemCountDialog(
                    title: 'Artikel ein-/ausbuchen',
                    itemData: inventoryData[rowIndex],
                  );
                },
                child: Text(
                  _itemCountAsString,
                  style: _cellTextStyle,
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: IconButton(
                onPressed: () {
                  _deleteSelectedItemFromInventory(itemId: _itemIdAsInt);
                },
                icon: const Icon(Icons.delete),
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      );
    }
    return [tableRowHeadline, tableRows];
  }

  void _deleteAllItemsFromInventory() async {
    int _result = await dbManager.deleteAllRows(
        tableName: dbManager.inventoryTableName,
        idColumnName: dbManager.inventoryColumnNameItemID);
    debugPrint('_result: ' + _result.toString());
    _loadData();
  }

  void _deleteSelectedItemFromInventory({required int itemId}) async {
    int _result = await dbManager.deleteRow(
        tableName: dbManager.inventoryTableName,
        idColumnName: dbManager.inventoryColumnNameItemID,
        id: itemId);
    debugPrint('_result: ' + _result.toString());
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(_title),
        actions: [
          IconButton(
            onPressed: _deleteAllItemsFromInventory,
            icon: const Icon(Icons.delete),
          )
        ],
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
            final List<TableRow> tableRowHeadline = _getTableRows(
                categoriesDataAsList: _categoriesData,
                inventoryData: _inventoryData)[0];
            final List<TableRow> tableRows = _getTableRows(
                categoriesDataAsList: _categoriesData,
                inventoryData: _inventoryData)[1];
            widget = Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Table(
                    children: tableRowHeadline,
                    border: TableBorder.all(),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(32),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(),
                      4: FixedColumnWidth(68),
                      5: FixedColumnWidth(32),
                    },
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Table(
                          children: tableRows,
                          border: TableBorder.all(),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(32),
                            1: FlexColumnWidth(),
                            2: FlexColumnWidth(1.5),
                            3: FlexColumnWidth(),
                            4: FixedColumnWidth(68),
                            5: FixedColumnWidth(32),
                          },
                        ),
                      ],
                    ),
                  ),
                  AddItemIconButton(
                    addItemToInvetoryAndRefreshDataOnDisplayFunction:
                        _addNewItemIntoInventory,
                    categoriesDataMap: _categoriesData,
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
