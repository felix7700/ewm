import 'package:ewm/db_manager.dart';
import 'package:ewm/widgets/DialogContent/InputCards/input_card_add_new_item.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddItemIconButton extends StatelessWidget {
  AddItemIconButton(
      {required this.refreshItemsFunction,
      required this.categoriesDataMap,
      Key? key})
      : super(key: key);

  final DbManager dbManager = DbManager.instance;
  final Function refreshItemsFunction;
  final List<Map<String, dynamic>> categoriesDataMap;
  final List<String> categoriesAsList = [];

  void _addItem(String newCategoryName) {
    debugPrint('Add Category: ' + newCategoryName);

    Map<String, dynamic> row = {'category_name': newCategoryName};

    dbManager.insertIntoTable(
        tableName: dbManager.categoriesTableName, row: row);

    refreshItemsFunction();
  }

  Future<String?> _showDialog(context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Neuer Artikel'),
        content: AddNewItemCard(
          dataUpdatedFunction: _addItem,
          categoriesAsList: categoriesAsList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showDialog(context),
      icon: const Icon(Icons.add),
    );
  }
}
