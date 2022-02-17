import 'package:ewm/widgets/InputCards/input_card_add_new_category.dart';
import 'package:flutter/material.dart';

class AddCategoryButton extends StatelessWidget {
  const AddCategoryButton({Key? key}) : super(key: key);

  void _addCategory(String newCategoryName) {
    debugPrint('Add Category: ' + newCategoryName);
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
