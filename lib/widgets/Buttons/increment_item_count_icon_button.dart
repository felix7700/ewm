import 'package:flutter/material.dart';

class IncrementItemCountIconButton extends StatelessWidget {
  const IncrementItemCountIconButton(
      {required this.itemData, required this.buttonPressed, Key? key})
      : super(key: key);
  final Function buttonPressed;
  final dynamic itemData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_circle_rounded),
      color: Colors.blue,
      onPressed: () => buttonPressed(itemData),
    );
  }
}
