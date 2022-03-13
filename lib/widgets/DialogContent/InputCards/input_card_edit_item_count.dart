import 'package:ewm/widgets/Buttons/increase_item_count_icon_button.dart';
import 'package:flutter/material.dart';

class InputCardEditItemCount extends StatelessWidget {
  InputCardEditItemCount(
      {Key? key,
      required this.increaseItemCountFunction,
      required this.itemId,
      required this.editItemCountTextFieldInitValue})
      : super(key: key);
  final Function increaseItemCountFunction;
  final int itemId;
  final int editItemCountTextFieldInitValue;
  final _itemCountController = TextEditingController();
  final _formKeyPriceInput = GlobalKey<FormState>();

  void increaseItemCount() {
    increaseItemCountFunction(itemId: itemId);
  }

  @override
  Widget build(BuildContext context) {
    _itemCountController.text = editItemCountTextFieldInitValue.toString();
    return Card(
      elevation: 5,
      child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              IncreaseItemCountIconButton(
                color: Colors.blue,
                increaseItemCountFunction: increaseItemCount,
              )
            ],
          )),
    );
  }
}
