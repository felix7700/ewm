import 'package:ewm/widgets/InputCards/add_new_item_input_card.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);

  void addItem({required List<dynamic> newItemValues}) {
    print('AddItem: ' + newItemValues.toString());
  }

  Future<String?> _showDialog(context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: const Text('Neue Kategorie'),
          content: AddNewItemCard(addItemFunction: addItem)),
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
