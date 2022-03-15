import 'package:ewm/db_manager.dart';
import 'package:ewm/widgets/DialogContent/InputCards/input_card_add_new_item.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddItemIconButton extends StatelessWidget {
  AddItemIconButton(
      {required this.addItemToInvetoryAndRefreshDataOnDisplayFunction,
      required this.categoriesDataMap,
      Key? key})
      : super(key: key);

  final Function addItemToInvetoryAndRefreshDataOnDisplayFunction;
  final List<Map<String, dynamic>> categoriesDataMap;
  final List<String> categoriesAsList = [];

  Future<String?> _showDialog(context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Neuer Artikel'),
        content: AddNewItemCard(
          addItemToInvetoryAndRefreshDataOnDisplayFunction:
              addItemToInvetoryAndRefreshDataOnDisplayFunction,
          categoriesData: categoriesDataMap,
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
