import 'package:flutter/material.dart';

class EditItemIconButton extends StatelessWidget {
  const EditItemIconButton(
      {required this.itemId,
      required this.color,
      // required this.buttonPressed,
      Key? key})
      : super(key: key);
  final int itemId;
  final Color color;
  // final Function buttonPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      color: color,
      onPressed: () {
        debugPrint('edit Item');
        //buttonPressed(itemId);
      },
    );
  }
}
