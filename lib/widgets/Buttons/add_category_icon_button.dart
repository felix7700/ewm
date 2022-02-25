import 'package:ewm/db_manager.dart';
import 'package:flutter/material.dart';
import '../DialogContent/InputCards/input_card_add_new_category.dart';

// ignore: must_be_immutable
class AddCategoryIconButton extends StatelessWidget {
  AddCategoryIconButton({required this.refreshItemsFunction, Key? key})
      : super(key: key);

  DbManager dbManager = DbManager.instance;
  Function refreshItemsFunction;

  void _addCategory(String newCategoryName) {
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
        title: const Text('Neue Kategorie'),
        content: AddNewCategoryCard(addNewCategoryFunction: _addCategory),
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
