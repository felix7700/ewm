import 'package:flutter/material.dart';

class DecreaseItemCountIconButton extends StatelessWidget {
  const DecreaseItemCountIconButton(
      {required this.itemId, required this.buttonPressed, Key? key})
      : super(key: key);
  final Function buttonPressed;
  final int itemId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.remove_circle),
      color: Colors.blue,
      onPressed: () => buttonPressed(itemId),
    );
  }
}
